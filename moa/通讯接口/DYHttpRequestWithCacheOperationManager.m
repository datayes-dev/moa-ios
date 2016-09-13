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
//  DYHttpRequestWithCacheOperationManager.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/3/2.
//

#import "DYHttpRequestWithCacheOperationManager.h"

@implementation DYHttpRequestWithCacheOperationManager

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation,
                                                                      id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation,
                                                                      NSError *error))failure
{
    NSMutableURLRequest *modifiedRequest = request.mutableCopy;
    AFNetworkReachabilityManager *reachability = self.reachabilityManager;
    if (!reachability.isReachable)
    {
        modifiedRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:modifiedRequest
                                                                       success:success
                                                                       failure:failure];
 
    WS(weakSelf);
    [operation setCacheResponseBlock: ^NSCachedURLResponse *(NSURLConnection *connection,
                                                             NSCachedURLResponse *cachedResponse)
     {
         NSURLResponse *response = cachedResponse.response;
         if (![response isKindOfClass:NSHTTPURLResponse.class])
             return cachedResponse;
         
         NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
         NSDictionary *headers = HTTPResponse.allHeaderFields;
         if (headers[@"Cache-Control"] != nil)
             return cachedResponse;
         
         NSMutableDictionary *modifiedHeaders = headers.mutableCopy;
         
         //获取到plist里定义的cacheExpireTime，默认为0，即不缓存
         if (weakSelf.cacheExpireTime > 0) {
             modifiedHeaders[@"Cache-Control"] = [NSString stringWithFormat:@"max-age=%lu", (unsigned long)weakSelf.cacheExpireTime];
         }else{
             modifiedHeaders[@"Cache-Control"] = [NSString stringWithFormat:@"no-cache"];
         }
         
         
         NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                                initWithURL:HTTPResponse.URL
                                                statusCode:HTTPResponse.statusCode
                                                HTTPVersion:@"HTTP/1.1"
                                                headerFields:modifiedHeaders];
         
         cachedResponse = [[NSCachedURLResponse alloc]
                           initWithResponse:modifiedResponse
                           data:cachedResponse.data
                           userInfo:cachedResponse.userInfo
                           storagePolicy:cachedResponse.storagePolicy];
         return cachedResponse;
     }];
    
    return operation;
}

@end
