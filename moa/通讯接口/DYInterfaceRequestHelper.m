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
//  DYInterfaceRequestHelper.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/21.
//

#import "DYInterfaceRequestHelper.h"
#import "DYInterfacePropertiesManager.h"
#import "DYJsonRequestWithGBufResponseRequest.h"
#import "DYJsonRequestWithJsonResponseRequest.h"
#import "DYXFormRequestWithJsonResponseRequest.h"
#import "DYJsonRequestWithTextHtmlResponseRequest.h"
#import "DYNotifiesRequest.h"
#import "DYErrorHandlerHelper.h"
#import "DYAuthTokenManager.h"
#import "DYNetStatusManager.h"
#import "DYErrorHelper.h"
#import "DYInterfaceReqeustItem.h"
#import "DYMutipartFormDataRequest.h"
#import "DYAppConfigManager.h"
#import "DYProgressHUD.h"
#import "AFNetworking.h"
#import "DYCacheService.h"
#import "PromptView.h"

static DYInterfaceRequestHelper* gInterfaceRequestHelper;

@interface DYInterfaceRequestHelper ()

@property (nonatomic, strong)NSMutableArray* mResumeRequestItemArray;

@end

@implementation DYInterfaceRequestHelper

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInterfaceRequestHelper = [[DYInterfaceRequestHelper alloc] init];
    });
    
    return gInterfaceRequestHelper;
}

+ (NSString*)dataInfoInterfaceBasicUrl
{
    
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
            return [DYInterfacePropertiesManager shareInstance].devBaseUrl;
            break;
            
        case eCurrentEnvTypeQA:
            return [DYInterfacePropertiesManager shareInstance].qaBaseUrl;
            break;
            
        case eCurrentEnvTypeStag:
            return [DYInterfacePropertiesManager shareInstance].stageBaseUrl;
            break;
            
        case eCurrentEnvTypeProduct:
            return [DYInterfacePropertiesManager shareInstance].productBaseUrl;
            break;
            
        default:
            break;
    }
    //#ifdef BUILD_FOR_DEV
    //    return [DYInterfacePropertiesManager shareInstance].devBaseUrl;
    //#endif
    //#ifdef BUILD_FOR_QA
    //    return [DYInterfacePropertiesManager shareInstance].qaBaseUrl;
    //#endif
    //#ifdef BUILD_FOR_STAGE
    //    return [DYInterfacePropertiesManager shareInstance].stageBaseUrl;
    //#endif
    //#ifdef BUILD_FOR_PRODUCT
    //    return [DYInterfacePropertiesManager shareInstance].productBaseUrl;
    //#endif
}

+ (NSString*)authInterfaceBasicUrl
{
    
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
            return [DYInterfacePropertiesManager shareInstance].qaAuthorityUrl;
            break;
            
        case eCurrentEnvTypeQA:
            return [DYInterfacePropertiesManager shareInstance].qaAuthorityUrl;
            break;
            
        case eCurrentEnvTypeStag:
            return [DYInterfacePropertiesManager shareInstance].stageAuthorityUrl;
            break;
            
        case eCurrentEnvTypeProduct:
            return [DYInterfacePropertiesManager shareInstance].productAuthorityUrl;
            break;
            
        default:
            break;
    }
    //#ifdef BUILD_FOR_DEV
    //    return [DYInterfacePropertiesManager shareInstance].qaAuthorityUrl;
    //#endif
    //#ifdef BUILD_FOR_QA
    //    return [DYInterfacePropertiesManager shareInstance].qaAuthorityUrl;
    //#endif
    //#ifdef BUILD_FOR_STAGE
    //    return [DYInterfacePropertiesManager shareInstance].stageAuthorityUrl;
    //#endif
    //#ifdef BUILD_FOR_PRODUCT
    //    return [DYInterfacePropertiesManager shareInstance].productAuthorityUrl;
    //#endif
}

+ (NSString*)notifyUrl
{
    
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
            return [DYInterfacePropertiesManager shareInstance].qaNotifyUrl;
            break;
            
        case eCurrentEnvTypeQA:
            return [DYInterfacePropertiesManager shareInstance].qaNotifyUrl;
            break;
            
        case eCurrentEnvTypeStag:
            return [DYInterfacePropertiesManager shareInstance].stageNotifyUrl;
            break;
            
        case eCurrentEnvTypeProduct:
            return [DYInterfacePropertiesManager shareInstance].productNotifyUrl;
            break;
            
        default:
            break;
    }
    //#ifdef BUILD_FOR_DEV
    //    return [DYInterfacePropertiesManager shareInstance].qaNotifyUrl;
    //#endif
    //#ifdef BUILD_FOR_QA
    //    return [DYInterfacePropertiesManager shareInstance].qaNotifyUrl;
    //#endif
    //#ifdef BUILD_FOR_STAGE
    //    return [DYInterfacePropertiesManager shareInstance].stageNotifyUrl;
    //#endif
    //#ifdef BUILD_FOR_PRODUCT
    //    return [DYInterfacePropertiesManager shareInstance].productNotifyUrl;
    //#endif
}


+ (NSString *)appPushUrl
{
    
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
            return [DYInterfacePropertiesManager shareInstance].devAppPushUrl;
            break;
            
        case eCurrentEnvTypeQA:
            return [DYInterfacePropertiesManager shareInstance].qaAppPushUrl;
            break;
            
        case eCurrentEnvTypeStag:
            return [DYInterfacePropertiesManager shareInstance].stageAppPushUrl;
            break;
            
        case eCurrentEnvTypeProduct:
            return [DYInterfacePropertiesManager shareInstance].productAppPushUrl;
            break;
            
        default:
            break;
    }
    //#ifdef BUILD_FOR_DEV
    //    return [DYInterfacePropertiesManager shareInstance].devAppPushUrl;
    //#endif
    //#ifdef BUILD_FOR_QA
    //    return [DYInterfacePropertiesManager shareInstance].qaAppPushUrl;
    //#endif
    //#ifdef BUILD_FOR_STAGE
    //    return [DYInterfacePropertiesManager shareInstance].stageAppPushUrl;
    //#endif
    //#ifdef BUILD_FOR_PRODUCT
    //    return [DYInterfacePropertiesManager shareInstance].productAppPushUrl;
    //#endif
    
}

+ (NSString*)cmsUrl
{
    
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
            return [DYInterfacePropertiesManager shareInstance].devCMSUrl;
            break;
            
        case eCurrentEnvTypeQA:
            return [DYInterfacePropertiesManager shareInstance].qaCMSUrl;
            break;
            
        case eCurrentEnvTypeStag:
            return [DYInterfacePropertiesManager shareInstance].stageCMSUrl;
            break;
            
        case eCurrentEnvTypeProduct:
            return [DYInterfacePropertiesManager shareInstance].productCMSUrl;
            break;
            
        default:
            break;
    }
    
    //#ifdef BUILD_FOR_DEV
    //    return [DYInterfacePropertiesManager shareInstance].devCMSUrl;
    //#endif
    //#ifdef BUILD_FOR_QA
    //    return [DYInterfacePropertiesManager shareInstance].qaCMSUrl;
    //#endif
    //#ifdef BUILD_FOR_STAGE
    //    return [DYInterfacePropertiesManager shareInstance].stageCMSUrl;
    //#endif
    //#ifdef BUILD_FOR_PRODUCT
    //    return [DYInterfacePropertiesManager shareInstance].productCMSUrl;
    //#endif
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupRequesters];
    }
    
    return self;
}

- (void)setupRequesters
{
    NSString* basicUrl = [DYInterfaceRequestHelper dataInfoInterfaceBasicUrl];
    NSString* basicAuthUrl = [DYInterfaceRequestHelper authInterfaceBasicUrl];
    NSString* notifyUrl = [DYInterfaceRequestHelper notifyUrl];
    NSString* appPushBaseUrl = [DYInterfaceRequestHelper appPushUrl];
    NSString* cmsUrl = [DYInterfaceRequestHelper cmsUrl];
    
    self.dataInfoRequest = [[DYJsonRequestWithGBufResponseRequest alloc] initWithUrl:basicUrl];
    self.dataInfoWithAuthParamsRequest = [[DYJsonRequestWithGBufResponseRequest alloc] initWithUrl:basicUrl];
    self.authInfoRequest = [[DYXFormRequestWithJsonResponseRequest alloc] initWithUrl:basicAuthUrl];
    self.accessRefreshRequest = [[DYXFormRequestWithJsonResponseRequest alloc] initWithUrl:basicAuthUrl];
    self.notifyRequest = [[DYNotifiesRequest alloc] initWithUrl:notifyUrl];
    self.appPushRequest = [[DYJsonRequestWithJsonResponseRequest alloc]initWithUrl:appPushBaseUrl];
    self.cmsRequest = [[DYJsonRequestWithJsonResponseRequest alloc] initWithUrl:cmsUrl];
    self.cmsNeedAuthInfoRequest = [[DYJsonRequestWithJsonResponseRequest alloc] initWithUrl:cmsUrl];
    self.addMutipartFormDataRequest = [[DYMutipartFormDataRequest alloc] initWithUrl:basicAuthUrl];
    self.diningRequest = [[DYJsonRequestWithTextHtmlResponseRequest alloc] initWithUrl:basicAuthUrl];
}

- (void)sendRequestWithMsgId:(EInterfaceId)msgId
                  parameters:(id)params
               canUsingCache:(BOOL)usingCacheFlag
                 forceReload:(BOOL)reloadFlag
                 resultBlock:(DYInterfaceResultBlock)resultBlock
{
    if (![DYNetStatusManager shareInstance].isNetWorkAvaliable)
    {
        [DYProgressHUD  hideWaiting];
        
        NSNumber *showNoNetWorkFlag = loadFromCacheWithType(CK_ShowNoNetWorkFlag, JMDataTypeEnumObject);
        
        if(![showNoNetWorkFlag boolValue]){//3秒内不会再提示
            [PromptView showWithPrompt:@"网络暂时无法访问"];
            saveToCacheWithType(CK_ShowNoNetWorkFlag, @YES, JMDataTypeEnumObject);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 3.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                saveToCacheWithType(CK_ShowNoNetWorkFlag, @NO, JMDataTypeEnumObject);
            });
        }
        resultBlock(nil, [NSError errorWithDomain:kNetWorkingErrorDomain code:NetAccessError userInfo:nil]);
        return;
    }
    
    DYInterfaceInfo* interfaceInfo = [DYInterfacePropertiesManager interfaceInfoWithInterfaceId:msgId];
    DYInterfaceRequesterBase* dealRequester = nil;
    if (interfaceInfo != nil) {
        switch (interfaceInfo.needAuthInfoType) {
            case eNeedNoAuthInfo:
                dealRequester = self.dataInfoRequest;
                break;
            case eNeedAuthInfoIfLogin:
            {
                //                if ([DYAuthTokenManager shareInstance].isLogined) {
                dealRequester = self.dataInfoWithAuthParamsRequest;
                //                }
                //                else
                //                {
                //                    dealRequester = self.dataInfoRequest;
                //                }
            }
                break;
            case eNeedAuthInfo:
                dealRequester = self.authInfoRequest;
                break;
            case eIamAuthInfo:
                dealRequester = self.accessRefreshRequest;
                break;
            case eNotifyInfo:
                dealRequester = self.notifyRequest;
                break;
            case eAppPushInfo:
                dealRequester = self.appPushRequest;
                break;
            case eCMSInfo:
                dealRequester = self.cmsRequest;
                break;
            case eCMSNeedAutoInfo:
                dealRequester = self.cmsNeedAuthInfoRequest;
                break;
            case eAddMutipartData:
                dealRequester = self.addMutipartFormDataRequest;
                break;
            case eDining:
                dealRequester = self.diningRequest;
                break;
            default:
                break;
        }
        
        if (dealRequester != nil) {
            [dealRequester sendRequestWithMsgId:msgId parameters:params canUsingCache:usingCacheFlag forceReload:reloadFlag resultBlock:^(AFHTTPRequestOperation *operation, id data, NSError *error) {
                if (error == nil) {
                    // 业务级错误
                    NSError* businessError = [DYErrorHandlerHelper dealWithResponse:data
                                                                  andErrorClassName:interfaceInfo.errorHandlerClass
                                                                      fromRequester:dealRequester
                                                                     andInterfaceId:msgId
                                                              withcanUsingCacheFlag:usingCacheFlag
                                                                 andforceReloadFlag:reloadFlag
                                                                          andParams:params
                                                                     andResultBlock:resultBlock];
                    
                    if (businessError != nil) {
                        resultBlock(nil, businessError);
                    }
                    else
                    {
                        resultBlock(data, nil);
                    }
                }
                else
                {
                    resultBlock(data, error);
                }
            }];
        }
    }
}

- (NSMutableArray*)mResumeRequestItemArray
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mResumeRequestItemArray = [[NSMutableArray alloc] init];
    });
    
    return _mResumeRequestItemArray;
}

- (void)addRequestIntoResumeQueueWithMsgId:(EInterfaceId)msgId
                                parameters:(id)params
                             canUsingCache:(BOOL)usingCacheFlag
                               forceReload:(BOOL)reloadFlag
                               resultBlock:(DYInterfaceResultBlock)resultBlock
{
    DYInterfaceReqeustItem* item = [[DYInterfaceReqeustItem alloc] init];
    item.msgId = msgId;
    item.params = params;
    item.usingCacheFlag = usingCacheFlag;
    item.reloadFlag = reloadFlag;
    item.resultBlock = resultBlock;
    
    [self.mResumeRequestItemArray addObject:item];
}

- (void)resumeAllRequstNeedToBeResume
{
    @synchronized(self.mResumeRequestItemArray) {
        NSUInteger count = [self.mResumeRequestItemArray count];
        for (NSUInteger i = 0 ; i < count ; i ++) {
            DYInterfaceReqeustItem* requestItem = self.mResumeRequestItemArray[0];
            [self sendRequestWithMsgId:requestItem.msgId parameters:requestItem.params canUsingCache:NO forceReload:requestItem.reloadFlag resultBlock:requestItem.resultBlock];
            [self.mResumeRequestItemArray removeObjectAtIndex:0];
        }
    }
}

- (void)changeCurrentEnvironment
{
    
    [self setupRequesters];
}


@end
