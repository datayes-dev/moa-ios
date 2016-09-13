//
//  PromptView.h
//  HowbuyFund
//
//  Created by tiannu on 14-6-3.
//  Copyright (c) 2014年 howbuy.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Prompt_Delay_Time 2.0

@interface PromptView : UIView

+ (void)showOnView:(UIView *)superview withPrompt:(NSString *)promt;
+ (void)showWithPrompt:(NSString *)promt;
+ (void)showWithPrompt:(NSString *)promt
       complection:(void (^)(void))block; // Show on window.

/* 展示提示 */
- (void)showPromptView:(UIView *)superView
             detailStr:(NSString *)tempDetailStr;

- (void)showPromptView:(UIView *)superView
             detailStr:(NSString *)tempDetailStr
           complection:(void (^)(void))block;

@end
