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
//  DYAuthoritrResetPasswordDataSource.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/21.
//

#import "DYAuthorityResetPasswordDataSource.h"

static NSString *keyPassportTypeMobile = @"MOBILE";
static NSString *keyPassportTypeEmail = @"EMAIL";
static NSString *keyPassportTypeUserName = @"USERNAME";

@implementation DYAuthorityResetPasswordDataSource

// 根据手机获取该用户的信息(不需要图片验证码)
- (void)requestUserInfoWithMobile:(NSString*)mobile resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self requestUserInfoWithPassportId:mobile passportType:keyPassportTypeMobile imageValidateCode:nil resultBlock:resultBlock];
}

// 根据邮箱获取该用户的信息，不需要图片验证码
- (void)requestUserInfoWithEmail:(NSString*)email resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self requestUserInfoWithPassportId:email passportType:keyPassportTypeEmail imageValidateCode:nil resultBlock:resultBlock];
}


// 根据手机获取该用户的信息
- (void)requestUserInfoWithMobile:(NSString*)mobile imageValidateCode:(NSString*)imageValidateCode resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self requestUserInfoWithPassportId:mobile passportType:keyPassportTypeMobile imageValidateCode:imageValidateCode resultBlock:resultBlock];
}

// 根据邮箱获取该用户的信息
- (void)requestUserInfoWithEmail:(NSString*)email imageValidateCode:(NSString*)imageValidateCode resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self requestUserInfoWithPassportId:email passportType:keyPassportTypeEmail imageValidateCode:imageValidateCode resultBlock:resultBlock];
}


// 发送手机验证短信
- (void)requestMobileValidCodeWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eAuthResetPassport
                    parameters:@{@"passportType" : keyPassportTypeMobile}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
}

// 验证手机验证码，获取token
- (void)requestResetTokenWithValidCode:(NSString*)validCode resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eAuthResetValidation
                    parameters:@{@"code" : validCode}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
}

// 重置密码
- (void)requestResetPassword:(NSString *)newPassword withToken:(NSString*)token resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eAuthResetNewPassword
                    parameters:@{@"code" : token, @"password" : newPassword}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
}

/**
 *	@brief	发送修改密码邮件
 *
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestValidEmailWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eAuthResetGetUserInfo
                    parameters:@{@"passportType" : keyPassportTypeEmail}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
}

- (NSString *)getErrorMessageWithCode:(int)errorCode
{
    switch (errorCode) {
        case 6:
            return @"Token过期";
        case 8:
            return @"邮件发送失败";
        case 11:
            return @"账户（通行证）不存在";
        case 12:
            return @"Token无效";
        case 13:
            return @"用户/手机号不存在";
        case 16:
            return @"手机号码格式不正确";
        case 19:
            return @"密码格式错误";
        case 18:
            return @"验证码不正确";
        case 20:
            return @"验证码过期";
        case 26:
            return @"操作太频繁";
        case 33:
            return @"非法输入";
        case 37:
            return @"通行证类型不支持或用户无该通行证";
        case 38:
            return @"之前未输入图片验证码/验证码过期";
            
        default:
            return nil;
    }
}


// 获取该用户的信息
- (void)requestUserInfoWithPassportId:(NSString*)passortId passportType:(NSString*)passportType imageValidateCode:(NSString*)imageValidateCode resultBlock:(DYInterfaceResultBlock)resultBlock
{
    if (imageValidateCode) {
        [self sendRequestWithMsgId:eAuthResetGetUserInfo
                        parameters:@{@"passportId":passortId, @"passportType" : passportType, @"verifyCode" : imageValidateCode}
                     canUsingCache:NO
                       forceReload:NO
                       resultBlock:^(id data, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               resultBlock(data, error);
                           });
                       }];
    } else {
        [self sendRequestWithMsgId:eAuthResetGetUserInfoNoImageCode
                        parameters:@{@"passportId":passortId, @"passportType" : passportType}
                     canUsingCache:NO
                       forceReload:NO
                       resultBlock:^(id data, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               resultBlock(data, error);
                           });
                       }];
    }
}


/*
// 重置密码
- (void)requestResetPasswordWithToken:(NSString*)token password:(NSString*)password resultBlock:(DYInterfaceResultBlock)resultBlock
{
//    NSDictionary *paras = @{ @"token" : token,
//                             @"password" : password };
//    [self sendRequestWithMsgId:eAuthRetrievePassword
//                    parameters:paras
//                 canUsingCache:NO
//                   forceReload:NO
//                   resultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
//    [self sendRequestWithMsgId:eInterfaceAuthRetrievePassword
//                 andParameters:paras
//                 canUsingCache:NO forceReload:NO
//               withRequestType:eRequestMethodTypePost
//               withResultBlock:^(id data, NSError *error) {
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       resultBlock(data, error);
//                   });
//               }];

}


// 重置密码 获取手机验证码
- (void)requestResetMobileValidCode:(NSString*)mobile imageValidateCode:(NSString*)imageValidateCode resultBlock:(DYInterfaceResultBlock)resultBlock
{
//    NSDictionary *paras = @{ @"mobile" : mobile,
//                             @"validateCode" : imageValidateCode };
//    [self sendRequestWithMsgId:eAuthRetrieveSendValidCode
//                    parameters:paras
//                 canUsingCache:NO
//                   forceReload:NO
//                   resultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
//    [self sendRequestWithMsgId:eInterfaceAuthRetrieveSendValidCode
//                 andParameters:paras
//                 canUsingCache:NO forceReload:NO
//               withRequestType:eRequestMethodTypePost
//               withResultBlock:^(id data, NSError *error) {
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       resultBlock(data, error);
//                   });
//               }];
}



// 重置密码 根据手机验证码，获取重设token
- (void)requestResetTokenWithMobile:(NSString*)mobile validateCode:(NSString*)validateCode resultBlock:(DYInterfaceResultBlock)resultBlock
{
    
}
*/

@end
