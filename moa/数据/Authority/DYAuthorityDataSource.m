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
//  DYAuthorityDataSource.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/17.
//

#import "DYAuthorityDataSource.h"

static DYAuthorityDataSource* _sharedAuthorityDataSource = nil;


@implementation DYAuthorityDataSource

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAuthorityDataSource = [[DYAuthorityDataSource alloc] init];
    });
    
    return _sharedAuthorityDataSource;
}

// 修改密码
- (void)requestChangePasswordUser:(NSString*)userName from:(NSString*)oldPassword to:(NSString *)newPassword resultBlock:(DYInterfaceResultBlock)resultBlock
{
//    NSDictionary *paras = @{ @"name" : userName,
//                             @"oldPassword" : oldPassword,
//                             @"newPassword" : newPassword };
//    [self sendRequestWithMsgId:eAuthChangePassword
//                    parameters:paras
//                 canUsingCache:NO
//                   forceReload:NO
//                   resultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
//    [self sendRequestWithMsgId:eInterfaceAuthChangePassword
//                 andParameters:paras
//                 canUsingCache:NO forceReload:NO
//               withRequestType:eRequestMethodTypeGet
//               withResultBlock:^(id data, NSError *error) {
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       resultBlock(data, error);
//                   });
//               }];
}
// 增加头像
- (void)requestAddBase64Picture:(NSString*)pictureData resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eAuthAddPicture
                    parameters:pictureData
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       if (error) {
                           resultBlock(nil, error);
                       }else {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               resultBlock(data, error);
                           });
                       }
                   }];
//    [self sendJsonRequestWithMsgId:eInterfaceAuthAddPicture andPath:nil parameters:pictureData canUsingCache:NO forceReload:NO withRequestType:eRequestMethodTypePost withResultBlock:^(id data, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            resultBlock(data, error);
//        });
//    }];
}


#pragma mark - 通用副本

// 通用副本 1：验证用户输入的验证码
//- (void)requestValidateCaptha:(NSString*)captha mobile:(NSString*)mobile resultBlock:(DYInterfaceResultBlock)resultBlock
//{
//    NSDictionary *paras = @{@"mobile" : mobile, @"captha" : captha};
//    [self sendRequestWithMsgId:eAppHand
//                    parameters:paras
//                 canUsingCache:NO
//                   forceReload:NO
//                   resultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
//    [self sendRequestWithMsgId:eInterfaceAppHand
//                 andParameters:paras
//                 canUsingCache:NO forceReload:NO
//               withRequestType:eRequestMethodTypeGet
//               withResultBlock:^(id data, NSError *error) {
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       resultBlock(data, error);
//                   });
//               }];
    
//}

// 通用副本 2：给手机发送验证码
//- (void)requestSendMobileValidCodeWithMobile:(NSString*)mobile captcha:(NSString*)captha resultBlock:(DYInterfaceResultBlock)resultBlock
//{
//    NSDictionary *paras = @{@"mobile" : mobile, @"captha" : captha};
//    [self sendRequestWithMsgId:eAppHand
//                    parameters:paras
//                 canUsingCache:NO
//                   forceReload:NO
//                   resultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
//    [self sendRequestWithMsgId:eInterfaceAppHand
//                 andParameters:paras
//                 canUsingCache:NO forceReload:NO
//               withRequestType:eRequestMethodTypeGet
//               withResultBlock:^(id data, NSError *error) {
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       resultBlock(data, error);
//                   });
//               }];
//}


// 通用副本 3：获取重设密码的token（所需的验证码从通用复本2得到）
//- (void)requestResetPasswordToken:(NSString*)code resultBlock:(DYInterfaceResultBlock)resultBlock
//{
//    NSDictionary *paras = @{ @"code" : code};
//    [self sendRequestWithMsgId:eAppHand
//                    parameters:paras
//                 canUsingCache:NO
//                   forceReload:NO
//                   resultBlock:^(id data, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           resultBlock(data, error);
//                       });
//                   }];
//    [self sendRequestWithMsgId:eInterfaceAppHand
//                 andParameters:paras
//                 canUsingCache:NO forceReload:NO
//               withRequestType:eRequestMethodTypeGet
//               withResultBlock:^(id data, NSError *error) {
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       resultBlock(data, error);
//                   });
//               }];
//}



@end
