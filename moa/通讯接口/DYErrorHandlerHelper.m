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
//  DYErrorHandlerHelper.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/21.
//

#import "DYErrorHandlerHelper.h"
#import "DYErrorHelper.h"
#import "DYAuthTokenManager.h"
#import "DYInterfaceRequestHelper.h"
#import "DYInterfaceInfo.h"
#import "DYInterfacePropertiesManager.h"
#import "AFNetworking.h"
#import "DYInterfaceRequesterBase.h"
#import "DYAuthorityManager.h"

@implementation DYErrorHandlerHelper

+ (NSError*)dealWithResponse:(id)response
           andErrorClassName:(NSString*)className
               fromRequester:(DYInterfaceRequesterBase*)requester
              andInterfaceId:(EInterfaceId)msgId
       withcanUsingCacheFlag:(BOOL)usingCacheFlag
          andforceReloadFlag:(BOOL)reloadFlag
                   andParams:(id)params
              andResultBlock:(DYInterfaceResultBlock)resultBlock
{
    if (response == nil) {
        return [NSError errorWithDomain:kInterfaceDataError code:NullData userInfo:nil];
    }
    
    DYInterfaceInfo* interfaceInfo = [DYInterfacePropertiesManager interfaceInfoWithInterfaceId:msgId];
    
    // 判断是否需要重新登录
    if ((interfaceInfo.needAuthInfoType == eNeedAuthInfo ||
         interfaceInfo.needAuthInfoType == eNeedAuthInfoIfLogin ||
         interfaceInfo.needAuthInfoType == eCMSNeedAutoInfo ||
         interfaceInfo.needAuthInfoType == eAddMutipartData ||
         interfaceInfo.needAuthInfoType == eNotifyInfo) &&
        [DYErrorHelper checkIfNeedRefreshAccessTokenWith:response]) {
        
        // 刷新accessToken
        [[DYAuthorityManager sharedInstance] refreshAccessTokenWithRefreshToken];
        
        // 将请求保存起来，后续再resume
        [[DYInterfaceRequestHelper shareInstance] addRequestIntoResumeQueueWithMsgId:msgId parameters:params canUsingCache:usingCacheFlag forceReload:reloadFlag resultBlock:resultBlock];
        
        return [NSError errorWithDomain:kAuthorityrErrorDomain code:NeedLogin userInfo:nil];
    }
    
    // 没有错误
    return nil;
}

@end
