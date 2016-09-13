//
//  DYProgressHUD.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/26.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYProgressHUD : NSObject

+ (DYProgressHUD *)shareInstance;

/**
 * 显示字
 *
 * @param view
 */
+ (void)showProgressHUDInView:(UIView *)view message:(NSString *)message;

/**
 * 显示菊花
 *
 * @param view
 */
+ (void)showWaitingIndicatorInView:(UIView *)view;

/**
 * 显示对勾图片
 *
 * @param view
 */
+ (void)showRightIndicatorInView:(UIView *)view message:(NSString *)message;

/**
 * 显示叉号图片
 *
 * @param view
 */
+ (void)showErrorIndicatorInView:(UIView *)view message:(NSString *)message;

/**
 *	@brief	显示菊花，并在指定时间内关闭
 *
 *	@param 	view 	在这个view上显示
 *	@param 	delayTime 	延时关闭的时间
 */
+ (void)showWaitingIndicatorInView:(UIView *)view withHideDelayTime:(NSTimeInterval)delayTime;

/**
 * 显示菊花并且可以点击消失
 *
 * @param view
 */
+ (void)showWaitingIndicatorCanTouchInView:(UIView *)view;

/**
 * 显示菊花并且不能点击消失
 *
 * @param view
 */
+ (void)showWaitingNotTouchInView:(UIView *)view;


/**
 * 隐藏菊花
 */
+ (void)hideWaiting;

@end
