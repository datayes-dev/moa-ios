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
//  DYAuthorityResponseHelper.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/21.
//

#import "DYAuthorityResponseHelper.h"
#import "DYErrorHelper.h"


@implementation DYAuthorityResponseHelper

+ (NSString*)descriptionOfErrorCode:(NSString*)errorCode
{
    static NSDictionary* errorCodeDic = nil;
    if (errorCodeDic == nil) {
        errorCodeDic = @{@"13":@"输入username字段为空字符串, 输入username不满足用户名规则",
                         @"16":@"输入mobile字段为空字符串, 输入mobile不满足手机号规则",
                         @"17":@"该手机号已注册",
                         @"18":@"验证码输入不正确 或 输入验证码后修改手机号",
                         @"19":@"password不满足密码规则",
                         @"20":@"验证码过期",
                         @"21":@"验证码发送失败",
                         @"23":@"输入username字段为纯数字",
                         @"24":@"该用户名已经存在",
                         @"27":@"50秒内连续发送",
                         @"29":@"活动注册码不符合规则",
                         @"403":@""};
    }
    
    return errorCodeDic[errorCode];
}

+ (id)errorWithResponse:(NSDictionary*)response
{
    NSString* errorCodeString = [NSString stringWithFormat:@"%@", response[@"code"]];
    NSInteger errorCode = [errorCodeString integerValue];
    if(Sucess == errorCode) {
        return nil;
    }
    
    NSDictionary* errorDescDic = nil;
    NSString* descString = [DYAuthorityResponseHelper descriptionOfErrorCode:errorCodeString];
    
    if ([descString length] > 0) {
        errorDescDic = @{AUTHORITY_ERROR_DESC:descString};
    }
    
    return [NSError errorWithDomain:kAuthorityrErrorDomain code:errorCode userInfo:errorDescDic];
}

@end
