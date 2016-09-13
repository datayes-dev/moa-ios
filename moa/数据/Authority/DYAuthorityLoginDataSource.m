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
//  DYAuthorityLoginDataSource.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/22.
//

#import "DYAuthorityLoginDataSource.h"
#import "DYErrorHelper.h"


@interface UserLoginData () {
    NSDictionary *_passportTypes;
}

@end

@implementation UserLoginData

+ (NSString*)grantTypeString:(GrantType)grantType
{
    switch (grantType) {
        case Password:
            return @"password";
        case RefreshToken:
            return @"refresh_token";
        case Permanent:
            return @"permanent";
        case RefreshPermanent:
            return @"refresh_permanent";
        case Anonymous:
            return @"anonymous";
        case Wechat:
            return @"wechat";
        case WechatCorp:
            return @"wechat_corp";
            
        default:
            return @"";
    }
    
}

- (NSDictionary *)generateLoginParameters {
    NSMutableDictionary *paras = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UserLoginData grantTypeString:self.grantType], @"grant_type", nil];
    switch (self.grantType) {
        case Password:
            paras[@"username"] = self.userName;
            paras[@"password"] = self.password;
            if(self.captcha) {
                paras[@"captcha"] = self.captcha;
            }
            if (self.tenant) {
                paras[@"tenant"] = self.tenant;
            }
            break;
        case RefreshToken:
            paras[@"refresh_token"] = self.refreshToken;
            break;
            
        default:
            paras = nil;
            break;
    }
    return paras;
}

@end



static DYAuthorityLoginDataSource* _sharedAuthorityLoginDataSource = nil;

@interface DYAuthorityLoginDataSource () {
    NSDictionary* _OAuth2Errors;
}

@end

@implementation DYAuthorityLoginDataSource

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAuthorityLoginDataSource = [[DYAuthorityLoginDataSource alloc] init];
    });
    
    return _sharedAuthorityLoginDataSource;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        _OAuth2Errors = @{ @(InvalidPassword) : @"密码错误", //invalid credential
                           @(NotExist) : @"用户名不存在",//notExisting account/refresh token
                           @(CodeRequired) : @"您的账号不安全，请要输入验证码"};//CODE_REQUIRED
        _userLoginData = [[UserLoginData alloc] init];
}
return self;
}

// 登录
- (void)requestUserNameLoginWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    __weak typeof(self) weakSelf = self;
    
    [self sendRequestWithMsgId:eAuthLogin parameters:[self.userLoginData generateLoginParameters] canUsingCache:NO forceReload:NO resultBlock:^(id data, NSError *error) {
        [weakSelf dealWithResultData:data error:error resultBlock:resultBlock];
    }];
//    [self sendJsonRequestWithMsgId:eInterfaceAuthLogin
//                           andPath:nil
//                        parameters:[self.userLoginData generateLoginParameters]
//                 canUsingCache:NO forceReload:NO
//               withRequestType:eRequestMethodTypePost
//               withResultBlock:^(id data, NSError *error) {
//                   [weakSelf dealWithResultData:data error:error resultBlock:resultBlock];
//               }];
}

// 登出
- (void)requestLogoutWithAccessToken:(NSString*)accessToken resultBlock:(DYInterfaceResultBlock)resultBlock
{
//    __weak typeof(self) weakSelf = self;
//    [self sendJsonRequestWithMsgId:eInterfaceAuthLogin
//                           andPath:nil
//                        parameters:@{@"token" : accessToken}
//                     canUsingCache:NO forceReload:NO
//                   withRequestType:eRequestMethodTypeGet
//                   withResultBlock:^(id data, NSError *error) {
//                       [weakSelf dealWithResultData:data error:error resultBlock:resultBlock];
//                   }];
}


- (void)dealWithResultData:(id)data error:(NSError *)error resultBlock:(DYInterfaceResultBlock)resultBlock
{
    NSError *reponseError = nil;
    if (data[@"errcode"]) {
        NSInteger errorCode = [data[@"errcode"] integerValue];
        NSString* translatedMessage = _OAuth2Errors[@(errorCode)];
        reponseError = [[NSError alloc] initWithDomain:kAuthorityrErrorDomain
                                                  code:errorCode
                                              userInfo:@{@"message" : translatedMessage ? translatedMessage : @"登录失败"}];
    }
    else if (data[@"code"])
    {
        NSInteger errorCode = [data[@"code"] integerValue];
        NSString* translatedMessage = _OAuth2Errors[@(errorCode)];
        reponseError = [[NSError alloc] initWithDomain:kAuthorityrErrorDomain
                                                  code:errorCode
                                              userInfo:@{@"message" : translatedMessage ? translatedMessage : @"登录失败"}];
    }
    dispatch_async(dispatch_get_main_queue(), ^{ resultBlock(data, reponseError); });

}

@end
