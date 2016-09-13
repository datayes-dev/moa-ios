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
//  DYErrorHelper.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/11.
//

#import "DYErrorHelper.h"
#import "PromptView.h"

NSString* const kNetWorkingErrorDomain = @"com.networking.error";
NSString* const kCodingErrorDomain = @"com.coding.error";
NSString* const kParameterErrorDomain = @"com.paramter.error";
NSString* const kAuthorityrErrorDomain = @"com.authority.error";
NSString* const kInterfaceDataError = @"com.interfaceData.error";
NSString* const kRequestError = @"com.request.error";

@implementation DYErrorHelper

+ (void)dealWithError:(NSError*)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        if (error.code != NSURLErrorCancelled) {
            [PromptView showWithPrompt:@"网络不给力，请稍后再试"];
        }
    }
    else if (error.code == kCFURLErrorBadServerResponse)
    {
        [PromptView showWithPrompt:@"网络不给力，请稍后再试"];
    }
    else
    {
        [PromptView showWithPrompt:@"网络不给力，请稍后再试"];
    }
}

+ (BOOL)checkIfNeedRefreshAccessTokenWith:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([data[@"errorcode"] intValue] == NeedLogin ||
            [data[@"code"] intValue] == NeedLogin) {
            return YES;
        }
    }
    
    return NO;
}
@end
