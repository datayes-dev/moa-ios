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
//  DYAuthorityChangePasswordDataSource.m
//  IntelligenceResearchReport
//
//  Created by yun.shu on 16/7/26.
//

#import "DYAuthorityChangePasswordDataSource.h"

@implementation DYAuthorityChangePasswordDataSource

+ (NSString*)descriptionOfAuthResult:(NSString*)result
{
    static NSDictionary* resultDic = nil;
    if (resultDic == nil) {
        resultDic = @{@"SUCCESS":@"密码修改成功",
                      @"FAIL":@"旧密码输入不正确",
                      @"INVALID":@"参数错误",
                      @"NOTEXIST":@"账号不存在",
                      @"LOCKED":@"账号已锁",
                      @"CODE_REQUIRED":@"需要输入验证码",
                      @"INVALID_CODE":@"验证码错误",      // 验证码失效
                      @"ERROR_CODE":@"验证码错误",
                      @"403":@""};
    }
    return resultDic[result];
}

// 修改密码
- (void)requestChangeOldPassword:(NSString *)oldPassword forNewPassword:(NSString *)newPassword captcha:(NSString*)captcha resultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eAuthChangePassword
                    parameters:@{@"oldPassword": oldPassword,
                                 @"newPassword": newPassword,
                                 @"captcha": captcha}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data, error);
                       });
                   }];
}


@end
