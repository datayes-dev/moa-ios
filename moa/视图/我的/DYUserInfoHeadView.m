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
//  DYUserInfoHeadView.m
//  IntelligenceResearchReport
//
//  Created by yun.shu on 16/7/25.
//

#import "DYUserInfoHeadView.h"
#import "DYAppearance.h"

@implementation DYUserInfoHeadView

- (void)awakeFromNib
{
    self.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    self.userNameLabel.font = DYAppearanceFont(@"T5");
    self.userNameLabel.textColor = DYAppearanceColor(@"H13", 1.0);
    self.loginButton.titleLabel.font = DYAppearanceFont(@"T5");
    [self.loginButton setTitleColor:DYAppearanceColor(@"H13", 1.0) forState:UIControlStateNormal];
    self.userPortraitButton.clipsToBounds = YES;
    [self.loginButton setTitle:@"注册/登录" forState:UIControlStateNormal];
    self.userPortraitButton.layer.cornerRadius = self.userPortraitButton.frame.size.width * 0.5;
}

+ (id)createUserInfoView
{
    UINib *nib = [UINib nibWithNibName:@"DYUserInfoHeadView" bundle:[NSBundle mainBundle]];
    NSArray *nibs = [nib instantiateWithOwner:nil options:nil];
    if ([nibs count] > 0) {
        return nibs[0];
    }
    return nil;
}

//是否已经成功登录
- (void)hasLogined:(BOOL)isSuccess
{
    if (isSuccess) {
        self.loginButton.hidden = YES;
        self.userInfoArrow.hidden = YES;
        self.userNameLabel.hidden =NO;
    }
    else{
        self.loginButton.hidden = NO;
        self.userInfoArrow.hidden = NO;
        self.userNameLabel.hidden =YES;
        [self.userPortraitButton setImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
    }
}

@end
