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
//  DYTopView.m
//  IntelligenceResearchReport
//
//  Created by liangkai.zheng on 16/8/15.
//

#import "DYWindowLoadingView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "DYDefine.h"
#import "DYAppearance.h"
static DYWindowLoadingView *gTopView = nil;

@interface DYWindowLoadingView()

@property (nonatomic, weak) UIWindow *currentWindow;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation DYWindowLoadingView

#pragma mark - ShareInstance
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        gTopView = [[DYWindowLoadingView alloc] initWithFrame:CGRectMake(0, 0, DYScreenWidth, DYScreenHeight)];
        gTopView.backgroundColor = DYAppearanceColor(@"H13", 0.0);
    });
    
    return gTopView;
}

#pragma mark - Property Init
- (UIWindow *)currentWindow
{
    
    if (_currentWindow == nil) {
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        _currentWindow = [delegate window];
    }
    
    return _currentWindow;
}

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

#pragma mark - Public Method
- (void)show
{
    
    [self reloadContentView];

    if ([[self superview] isEqual:self.currentWindow]) {
        
        [self.currentWindow bringSubviewToFront:self];
        
    } else {
        
        [self.currentWindow addSubview:self];
    }
}

- (void)showWithType:(eLoadingViewType)type
{
    
    switch (type) {
        case eLoadingViewTypeDefault:
            [self show];
            break;
            
        default:
            break;
    }
}

- (void)showWithView:(UIView *)view
{
    [self setFrame:view.frame];
    [self layoutIfNeeded];
    [self layoutSubviews];
    [self show];
}

- (void)showWithframe:(CGRect)frame{
    [self setFrame:frame];
    [self layoutIfNeeded];
    [self layoutSubviews];
    [self show];
}


- (void)dismiss
{
    
    if ([[self superview] isEqual:self.currentWindow]) {
        
        [self.currentWindow sendSubviewToBack:self];
        
    } else {
        
        //do nothing...
    }
}

- (void)dismissView:(NSString *)key
{
    
    
}

- (void)reloadContentView
{
    
    if (self.delegate != nil) {
        //有delegate
        UIView *contentView = [self getContentView];
        
        if (contentView != nil && !CGRectIsEmpty([self getContentViewSize])){
            
            [contentView setFrame:[self getContentViewSize]];
        }
        
        if ([contentView superview] != self) {
            [self addSubview:contentView];
        }
        
    } else {
        
        //无delegate，则是默认
        [self.hud show:YES];
    }
    
}

#pragma mark - Delegate Method
- (UIView *)getContentView
{
    
    if ([self.delegate respondsToSelector:@selector(contentViewForTopView:)]) {
        
        return [self.delegate contentViewForTopView:self];
    }
    
    return nil;
}

- (CGRect)getContentViewSize
{
    
    if ([self.delegate respondsToSelector:@selector(contentViewSizeForTopView:)]) {
        
        return [self.delegate contentViewSizeForTopView:self];
    }
    
    return CGRectNull;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

@end
