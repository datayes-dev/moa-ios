/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  DYInterfaceRequesterBase.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/20.
//

#import "DYInterfaceRequesterBase.h"
#import "DYInterfacePropertiesManager.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "DYErrorHelper.h"
#import "DYDataSourceBase.h"
#import "NSString+URL.h"

#define MAX_CONCURRENT_OPERATION_COUNT  5                       // 最大并发请求数
#define MAX_OPERATION_COUNT             10                      // 单个请求允许的最大请求数

static NSString* const kOperationMsgIdKey = @"msgIdKey";        // 字典里msgId的key
static NSString* const kInterfaceInfoKey = @"interfaceInfoKey"; // 字典里interface info的key
static NSString* const kParametersKey = @"parametersKey";       // 字典里参数的key

@implementation DYInterfaceRequesterBase

- (void)sendRequestWithMsgId:(EInterfaceId)msgId
                  parameters:(id)params
               canUsingCache:(BOOL)usingCacheFlag
                 forceReload:(BOOL)reloadFlag
                 resultBlock:(DYRequestResultBlock)resultBlock
{
    __weak __typeof(self)weakSelf = self;
    __block id blockParams = [params copy];
    dispatch_async(weakSelf.networkProcessingQueue, ^{
        DYInterfaceInfo* interfaceInfo = [DYInterfacePropertiesManager interfaceInfoWithInterfaceId:msgId];
        if (interfaceInfo != nil) {
            // 检查是否已经存在这个请求了
            AFHTTPRequestOperation* urlConnectionOperation = [weakSelf operationWithMsgId:msgId];
            if (urlConnectionOperation != nil) {
                // 强制重新加载
                if (reloadFlag) {
                    [urlConnectionOperation cancel];
                    urlConnectionOperation = nil;
                }
                // 不允许多个并发请求时，直接返回
                else if (!interfaceInfo.allowMutableRequest ||
                         [weakSelf countOfOperationWithMsgId:msgId] > MAX_OPERATION_COUNT)
                {
                    DDLogInfo(@"请求 （%@） 被忽略", interfaceInfo.comment);
                    resultBlock(nil, nil, [NSError errorWithDomain:kRequestError code:RepeatedRequest userInfo:nil]);
                    return ;
                }
            }
            
            NSString* url = [weakSelf urlWithInterfaceInfo:interfaceInfo];
            if ((interfaceInfo.requestType == eRequestTypeGet || interfaceInfo.requestType == eRequestTypeDelete || interfaceInfo.requestType == eRequestTypePut) && [blockParams isKindOfClass:[NSString class]]) {
                url = [NSString stringWithFormat:@"%@/%@", url, blockParams];
                blockParams = @"";
            }
            else if ([blockParams isKindOfClass:[NSDictionary class]])
            {
                NSString* extraAddedSubUrl = [blockParams objectForKey:kExtraAddedSubUrlKey];
                if (extraAddedSubUrl != nil) {
                    url = [NSString stringWithFormat:@"%@/%@", url, extraAddedSubUrl];
                    
                    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
                    for (id key in [blockParams allKeys]) {
                        if ([key isKindOfClass:[NSString class]] && ![key isEqualToString:kExtraAddedSubUrlKey]) {
                            [mDic setObject:[blockParams objectForKey:key] forKey:key];
                        }
                    }
                    blockParams = mDic;
                }
                else
                {
                    // do nothing
                }
            }
            
            NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
            [mDic setObject:@(msgId) forKey:kOperationMsgIdKey];
            [mDic setObject:interfaceInfo forKey:kInterfaceInfoKey];
            if (blockParams != nil) {
                [mDic setObject:blockParams forKey:kParametersKey];
            }
            
            void (^ successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject != nil) {
                    if (interfaceInfo.responseBodyTiedType == eResponseBodyTiedTypeGBuf) {
                        //
                    }
                    else if (interfaceInfo.responseBodyTiedType == eResponseBodyTiedTypeJson)
                    {
                        DDLogInfo(@"%@\nURL为：\n%@\n参数为：\n%@\n调用结果已返回:%@", [weakSelf stringWithInterfaceInfo:interfaceInfo], url, blockParams, responseObject);
                        resultBlock(operation, responseObject, nil);
                    }
                }
                else
                {
                    NSError* err = [NSError errorWithDomain:kInterfaceDataError code:NullData userInfo:nil];
                    resultBlock(operation, nil, err);
                    DDLogInfo(@"%@\nURL为：\n%@\n参数为：\n%@\n返回异常：\n%@", [weakSelf stringWithInterfaceInfo:interfaceInfo], url, blockParams, err);
                }
            };
            
            void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
                DDLogInfo(@"%@\nURL为：\n%@\n参数为：\n%@\n返回异常：\n%@", [weakSelf stringWithInterfaceInfo:interfaceInfo], url, blockParams, error);
                [DYErrorHelper dealWithError:error];
                resultBlock(operation, nil, error);
            };
            
            DDLogInfo(@"%@被调用, here is httpheader:%@", [weakSelf stringWithInterfaceInfo:interfaceInfo], weakSelf.requestOperationManager.requestSerializer.HTTPRequestHeaders);
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *cookie in cookies) {
                // Here I see the correct rails session cookie
                DDLogInfo(@"cookie: %@", cookie);
            }
            DDLogInfo(@"%@被调用, url为：%@，参数为：%@", [weakSelf stringWithInterfaceInfo:interfaceInfo], url, blockParams);
            
            
            //获取cacheExpireTime
//            if (usingCacheFlag) {
//                weakSelf.requestOperationManager.cacheExpireTime = interfaceInfo.cacheExpireTime;
//            }
//            else
//            {
//                weakSelf.requestOperationManager.cacheExpireTime = 0;
//            }
            
            //添加接口版本号；
            NSString *apiVersion;
            if (interfaceInfo.apiVersion == nil) {
                apiVersion = @"2.2.0";
            }else{
                apiVersion = interfaceInfo.apiVersion;
            }
            
            if ([blockParams isKindOfClass:[NSDictionary class]]){
                NSMutableDictionary *dic = [(NSDictionary *)blockParams mutableCopy];
//                [dic setObject:apiVersion forKey:@"apiVersion"];
                blockParams = dic;
            }
            
            
            switch (interfaceInfo.requestType) {
                case eRequestTypeGet:
                {
                    urlConnectionOperation =
                    [weakSelf.requestOperationManager GET:url
                                                   parameters:blockParams
                                                      success:successBlock
                                                      failure:failureBlock];
                }
                    break;
                case eRequestTypePost:
                {
                    urlConnectionOperation =
                    [weakSelf.requestOperationManager POST:url
                                                    parameters:blockParams
                                                       success:successBlock
                                                       failure:failureBlock];
                }
                    break;
                case eRequestTypePut:
                {
                    NSDictionary* mDic = nil;
                    NSString* composedUrl = url;
                    if (interfaceInfo.putParamAfterUrl == YES) { //参数拼接到url后面
                        composedUrl = [weakSelf composeUrl:url WithStringParamters:blockParams];
                    } else {
                        if ([blockParams isKindOfClass:[NSDictionary class]]) {
                            mDic = [blockParams mutableCopy];
                        }
                    }
                    
                    urlConnectionOperation = 
                    [weakSelf.requestOperationManager PUT:composedUrl
                                                parameters:mDic
                                                   success:successBlock
                                                   failure:failureBlock];
                }
                    break;
                case eRequestMutipartFormDataPost:
                {
                    NSData* fileData = [blockParams objectForKey:MUTIPART_FORM_DATA_KEY];
                    NSString* name = [blockParams objectForKey:MUTIPART_FORM_DATA_NAME_KEY];
                    NSString* fileName = [blockParams objectForKey:MUTIPART_FORM_DATA_FILE_NAME_KEY];
                    NSString* mimeType = [blockParams objectForKey:MUTIPART_FORM_DATA_MIME_TYPE_KEY];
                    [weakSelf.requestOperationManager POST:url
                                                parameters:nil
                                 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                     [formData appendPartWithFileData:fileData
                                                                 name:name
                                                             fileName:fileName
                                                             mimeType:mimeType];
                                 }
                                                   success:successBlock
                                                   failure:failureBlock];
                }
                    break;
                case eRequestTypeDelete:
                {
                    urlConnectionOperation =
                    [weakSelf.requestOperationManager DELETE:url parameters:blockParams success:successBlock failure:failureBlock];
                }
                    break;
                    
                default:
                    break;
            }
            
            urlConnectionOperation.userInfo = mDic;
        }
    });
}

- (NSString*)composeUrl:(NSString*)url WithStringParamters:(NSDictionary*)params
{
    NSMutableString* mString = [NSMutableString stringWithString:url];
    BOOL firstOne = YES;
    for (NSString* key in [params allKeys]) {
        if (firstOne) {
            [mString appendString:@"?"];
            firstOne = NO;
        }
        else
        {
            [mString appendString:@"&"];
        }
        
        NSString* value = [params objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            value = [value urlEncodeString];
        }
        [mString appendFormat:@"%@=%@", key, value];
    }
    
    return mString;
}

- (AFHTTPRequestOperation *)operationWithMsgId:(NSInteger)msgId
{
    NSArray *operations = [self.requestOperationManager.operationQueue operations];
    if ([operations count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userInfo.msgIdKey == %@", @(msgId)];
        NSArray *array = [operations filteredArrayUsingPredicate:predicate];
        return [array lastObject];
    }
    
    return nil;
}

- (NSUInteger)countOfOperationWithMsgId:(NSInteger)msgId
{
    NSArray *operations = [self.requestOperationManager.operationQueue operations];
    if ([operations count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userInfo.msgIdKey == %@", @(msgId)];
        NSArray *array = [operations filteredArrayUsingPredicate:predicate];
        return [array count];
    }
    
    return 0;
}

- (NSString*)urlWithInterfaceInfo:(DYInterfaceInfo*)interfaceInfo
{
    NSString* specialBasicUrl = interfaceInfo.basicUrl;
    if ([specialBasicUrl length] > 0) {
        return [NSString stringWithFormat:@"%@%@", specialBasicUrl, interfaceInfo.subUrl];
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@", self.basicUrl , interfaceInfo.subUrl];
    }
}

- (instancetype)init
{
    NSAssert(nil, @"请调用 initWithUrl: 来初始化对象");
    return nil;
}

- (instancetype)initWithUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        if ([url length] > 0) {
            self.basicUrl = url;
        }
        else
        {
            NSAssert(nil, @"url 无效");
        }
        
        [self setupRequestOperationManager];
        [self setupNetWorkProcessingQueue];
    }
    return self;
}

- (void)setAccessToken:(NSString*)accessToken
{
    if ([accessToken length] > 0) {
        NSString* accessTokenWithHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
        DDLogInfo(@"accessToken %@", accessTokenWithHeader);
        [self.requestOperationManager.requestSerializer setValue:accessTokenWithHeader forHTTPHeaderField:@"Authorization"];
    }
    else
    {
        [self.requestOperationManager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    }
}

- (void)setupRequestOperationManager
{
    //
}

- (void)setupNetWorkProcessingQueue
{
    self.networkProcessingQueue = dispatch_queue_create("com.network.jgrequest", NULL);
    __weak __typeof(self)weakSelf = self;
    dispatch_async(self.networkProcessingQueue, ^{

        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [weakSelf.requestOperationManager.operationQueue setMaxConcurrentOperationCount:MAX_CONCURRENT_OPERATION_COUNT];
    });
}

- (NSString *)stringWithInterfaceInfo:(DYInterfaceInfo*)interfaceinfo
{
    NSString *requestTypeString = nil;
    switch (interfaceinfo.requestType) {
        case eRequestTypeGet:
            requestTypeString = @"GET";
            break;
        case eRequestTypePost:
            requestTypeString = @"POST";
            break;
        case eRequestTypePut:
            requestTypeString = @"PUT";
            break;
        case eRequestMutipartFormDataPost:
            requestTypeString = @"mutipart-form-data post";
            break;
        case eRequestTypeDelete:
            requestTypeString = @"DELETE";
            break;
        default:
            requestTypeString = @"Unknown";
            break;
    }
    return [NSString stringWithFormat:@"接口【%@】%@", requestTypeString, interfaceinfo.comment];
}

@end
