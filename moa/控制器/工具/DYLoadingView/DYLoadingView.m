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
//  DYLoadingView.m
//  IntelligenceResearchReport
//
//  Created by liangkai.zheng on 16/8/24.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYLoadingView.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "DYDefine.h"
#import "DYAppearance.h"

@interface DYLoadingView()
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation DYLoadingView
- (MBProgressHUD *)hud
{
    
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.mode  = MBProgressHUDModeIndeterminate;
        _hud.yOffset = -50.0f;
        _hud.color =DYAppearanceColor(@"H13", 0.5);
        _hud.userInteractionEnabled = NO;
    }
    
    return _hud;
}

- (instancetype)init
{
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = DYAppearanceColor(@"H13", 0.0);
    }
    
    return self;
}

- (void)showLoadingAtView:(UIView *)superView
                WithFrame:(CGRect)frame
          WithLoadingType:(eLoadingViewType)type
{
    
    if (superView == nil) {
        return;
    }
    
    if (![superView.subviews containsObject:self]) {
        
        [superView addSubview:self];
    }
    
    if (CGRectIsNull(frame)) {
        
        [self setFrame:CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height)];

    } else {
        
        [self setFrame:frame];
    }
    
    [self setFrame:CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height)];
    [superView bringSubviewToFront:self];
    
    switch (type) {
        case eLoadingViewTypeDefault:
            [self.hud show:YES];
            break;
            
        default:
            [self.hud show:YES];
            break;
    }
}

- (void)dismiss
{
    
    [self removeFromSuperview];
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
    return;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}
@end
