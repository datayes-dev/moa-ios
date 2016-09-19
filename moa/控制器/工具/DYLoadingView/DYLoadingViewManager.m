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
//  DYLoadingViewManager.m
//  IntelligenceResearchReport
//
//  Created by liangkai.zheng on 16/8/24.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYLoadingViewManager.h"
#import "Masonry.h"
#import "DYLoadingView.h"
#import "DYWindowLoadingView.h"
#import "DYDefine.h"
#import "DYAppearance.h"
#define kDefauleKeyStr @"kDefauleKeyStr"

static DYLoadingViewManager *gDYLoadingViewManager = nil;

@interface DYLoadingViewManager()

@property (nonatomic, strong) NSMutableDictionary *loadingDic;

@end

@implementation DYLoadingViewManager
#pragma mark - property Init
//- (NSMutableDictionary *)loadingDic
//{
//    
//    if (_loadingDic == nil) {
//        
//        _loadingDic = [NSMutableDictionary dictionary];
//    }
//    return _loadingDic;
//}

#pragma mark - ShareInstance
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gDYLoadingViewManager = [[DYLoadingViewManager alloc] init];
        gDYLoadingViewManager.loadingDic =[NSMutableDictionary dictionary];
    });
    
    return gDYLoadingViewManager;
}

#pragma mark - Show/Dismiss
- (void)showLoadingAtView:(UIView *)superView
                  WithKey:(NSString *)key
                WithFrame:(CGRect)frame
          WithLoadingType:(eLoadingViewType)type
{
    if (superView == nil) {
        return;
    }
    
    key = [key length] ? key : kDefauleKeyStr;
    
    DYLoadingView *top = [self generateViewWithKey:key];
    
    [top showLoadingAtView:superView WithFrame:frame WithLoadingType:type];
}

- (void)dismissWithKey:(NSString *)key
{
    
    key = [key length] ? key : kDefauleKeyStr;

    DYLoadingView *loadingView = [self getViewWithKey:key];
    
    [loadingView dismiss];
}


- (void)showAtWindow:(eLoadingViewType)type
{
    
    [[DYWindowLoadingView shareInstance] show];
}

- (void)dismissFromWindow
{
    
    [[DYWindowLoadingView shareInstance] dismiss];
}

#pragma mark - Save/get/generate
- (DYLoadingView *)getViewWithKey:(NSString *)key
{
    
    if ([key length] <= 0 || [[self.loadingDic allKeys] count] <= 0) {
        
        return nil;
    }
    
    for (NSString *keyvalue in [self.loadingDic allKeys]) {
        
        if ([keyvalue isEqualToString:key]) {
            
            return [self.loadingDic objectForKey:key];
        }
    }
    
    return nil;
}

- (BOOL)saveView:(UIView *)view WithKey:(NSString *)key
{
    if (view == nil || key == nil) {
        
        return NO;
    }
    
    [self.loadingDic setObject:view forKey:key];
    return YES;
}

- (DYLoadingView *)generateViewWithKey:(NSString *)key
{
    
    DYLoadingView *topView = [self getViewWithKey:key];
    
    if (topView == nil) {
        
        topView = [[DYLoadingView alloc] init];
        
        [self saveView:topView WithKey:key];
    }
    
    return topView;
}
@end
