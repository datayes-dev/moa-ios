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
//  DYAuthorityRegisterDataSource.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/21.
//

#import "DYAuthorityRegisterDataSource.h"
#import "DYErrorHelper.h"

@implementation MobileReqisterData

- (NSDictionary *)generateParameters {
    return @{ @"mobile" : self.mobile,
              @"username" : self.userName,
              @"password" : self.password,
              @"code" : self.validCode };
    
}

@end



static DYAuthorityRegisterDataSource* _sharedAuthorityRegisterDataSource = nil;

@implementation DYAuthorityRegisterDataSource

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAuthorityRegisterDataSource = [[DYAuthorityRegisterDataSource alloc] init];
    });
    
    return _sharedAuthorityRegisterDataSource;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mobileReqisterData = [[MobileReqisterData alloc] init];
    }
    return self;
}

// 手机注册
- (void)requestMobileRegisterWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    if ([self.mobileReqisterData.mobile length] <= 0 ||
        [self.mobileReqisterData.userName length] <= 0 ||
        [self.mobileReqisterData.password length] <= 0 ||
        [self.mobileReqisterData.validCode length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
        return ;
    }
    
    [self sendRequestWithMsgId:eAuthRegister
                    parameters:[self.mobileReqisterData generateParameters]
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
//    [self sendJsonRequestWithMsgId:eInterfaceAuthRegister
//                           andPath:nil
//                        parameters:[self.mobileReqisterData generateParameters]
//                     canUsingCache:NO forceReload:NO
//                   withRequestType:eRequestMethodTypePost
//                   withResultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
}

// 手机注册 获取手机验证码
- (void)requestRegisterMobileValidCodeWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    if ([self.mobileReqisterData.mobile length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
        return ;
    }
    
    [self sendRequestWithMsgId:eAuthRegisterSendValidCode
                    parameters:@{ @"mobile" : self.mobileReqisterData.mobile }
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
//    [self sendJsonRequestWithMsgId:eInterfaceAuthRegisterSendValidCode
//                           andPath:nil
//                        parameters:@{ @"mobile" : self.mobileReqisterData.mobile }
//                     canUsingCache:NO forceReload:NO
//                   withRequestType:eRequestMethodTypePost
//                   withResultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
}

// 手机注册 获取手机验证码(带图片验证码)
- (void)requestRegisterMobileValidCodeWithinImagecodeWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    if ([self.mobileReqisterData.mobile length] <= 0 ||
        [self.mobileReqisterData.imageValidateCode length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
        return ;
    }
    
    NSDictionary *paras = @{ @"mobile" : self.mobileReqisterData.mobile,
                             @"validateCode" : self.mobileReqisterData.imageValidateCode };
    [self sendRequestWithMsgId:eAuthRegisterSendValidCodeWithImage
                    parameters:paras
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            resultBlock(data, error);
                        });
                    }];
//    [self sendJsonRequestWithMsgId:eInterfaceAuthRegisterSendValidCodeWithImage
//                           andPath:nil
//                        parameters:paras
//                     canUsingCache:NO forceReload:NO
//                   withRequestType:eRequestMethodTypePost
//                   withResultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
}


// 手机注册 验证用户输入的验证码是否正确
- (void)requestRegisterValidateCodeWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    if ([self.mobileReqisterData.mobile length] <= 0 ||
        [self.mobileReqisterData.validCode length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
        return ;
    }
    
    NSDictionary *paras = @{ @"mobile" : self.mobileReqisterData.mobile,
                             @"code" : self.mobileReqisterData.validCode };
    [self sendRequestWithMsgId:eAuthRegisterValidateCode
                    parameters:paras
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
//    [self sendJsonRequestWithMsgId:eInterfaceAuthRegisterValidateCode
//                           andPath:nil
//                        parameters:paras
//                     canUsingCache:NO forceReload:NO
//                   withRequestType:eRequestMethodTypeGet
//                   withResultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
}

@end
