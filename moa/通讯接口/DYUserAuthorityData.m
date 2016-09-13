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
//  DYUserAuthorityData.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/17.
//

#import "DYUserAuthorityData.h"

@interface DYUserAuthorityData () {
    NSArray* _loginErrorNames;
    NSDictionary* _loginErrors;
}

@end
@implementation DYUserAuthorityData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loginErrorNames = @[@"SUCCESS", @"FAIL", @"INVALID", @"NOTEXIST", @"LOCKED", @"CODE_REQUIRED", @"INVALID_CODE", @"ERROR_CODE"];
        _loginErrors = @{
                         _loginErrorNames[0] : @"成功",
                         _loginErrorNames[1] : @"失败",
                         _loginErrorNames[2] : @"参数错误",
                         _loginErrorNames[3] : @"用户不存在",
                         _loginErrorNames[4] : @"用户被锁定",
                         _loginErrorNames[5] : @"需要输入验证码", // （登录失败2次）
                         _loginErrorNames[6] : @"验证码失效", //（过期或输错次数达到上限）
                         _loginErrorNames[7] : @"验证码错误",
                         };
    }
    return self;
}

- (void)parseLoginResult:(NSDictionary*)result {
    self.errorCode = result[@"content"][@"result"];
    if([self.errorCode isEqualToString:_loginErrorNames[0]]) {
        // login successful
        self.accessToken = result[@"content"][@"token"][@"tokenString"];
        self.expiredTime = [result[@"content"][@"token"][@"expiry"] integerValue];
        self.isLogin= YES;
    } else {
        // error
        self.isLogin = NO;
        self.errorMessage = _loginErrors[self.errorCode];
    }
}

- (BOOL)isValidateAccessToken
{
    return [[NSDate date] timeIntervalSince1970] * 1.1 > self.expiredTime;
}

@end
