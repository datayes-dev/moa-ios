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
//  DYLoadingViewManager.h
//  IntelligenceResearchReport
//
//  Created by liangkai.zheng on 16/8/24.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYLoadingViewProtocol.h"

#define showLoadingAtWindow          [[DYLoadingViewManager shareInstance] showAtWindow:eLoadingViewTypeDefault];

#define dismisLoadingFromWindow      [[DYLoadingViewManager shareInstance] dismissFromWindow];

#define showLoadingAtView(view,key)  [[DYLoadingViewManager shareInstance] showLoadingAtView:view WithKey:key WithFrame:CGRectNull WithLoadingType:eLoadingViewTypeDefault];

#define dismissLoadingFromView(key)  [[DYLoadingViewManager shareInstance] dismissWithKey:key];

#define showDefaultLoadingView(view)  [[DYLoadingViewManager shareInstance] showLoadingAtView:view WithKey:nil WithFrame:CGRectNull WithLoadingType:eLoadingViewTypeDefault];

#define dismissDefaultLoadingView  [[DYLoadingViewManager shareInstance] dismissWithKey:nil];


@interface DYLoadingViewManager : NSObject

+ (instancetype)shareInstance;

- (void)showLoadingAtView:(UIView *)superView
                  WithKey:(NSString *)key
                WithFrame:(CGRect)frame
          WithLoadingType:(eLoadingViewType)type;

- (void)dismissWithKey:(NSString *)key;

- (void)showAtWindow:(eLoadingViewType)type;

- (void)dismissFromWindow;
@end
