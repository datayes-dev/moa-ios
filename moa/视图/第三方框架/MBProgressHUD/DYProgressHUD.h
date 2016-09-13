//
//  DYProgressHUD.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/26.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYProgressHUD : NSObject

// 单例
+ (DYProgressHUD *)shareInstance;

#pragma mark - 仅文字提示
/**
 * 显示提示文字
 *
 * @param view
 */
+ (void)showProgressHUDInView:(UIView *)view message:(NSString *)message;

/**
 *  显示提示文字
 *
 *  @param view    view
 *  @param message message
 *  @param yOffset toastView - Y的偏移值
 */
+ (void)showProgressHUDInView:(UIView *)view
                      message:(NSString *)message
                      yOffset:(CGFloat)yOffset;


#pragma mark - 自定义图片(图上文字下)
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
 *  自定义图片
 *
 *  @param view    view
 *  @param image   image
 *  @param message 提示文字
 */
+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message;

/**
 *  自定义图片
 *
 *  @param view         view
 *  @param image        image
 *  @param message      message
 *  @param durationTime duration
 */
+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
                     durationTime:(double)durationTime;

/**
 *  自定义图片
 *
 *  @param view    view
 *  @param image   image
 *  @param message message
 *  @param yOffset toastView的Y偏移值
 */
+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
                          yOffset:(CGFloat)yOffset;

/**
 *  自定义图片
 *
 *  @param view         view
 *  @param image        image
 *  @param message      message
 *  @param durationTime duration
 *  @param yOffset      toastView的Y偏移值
 */
+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
                     durationTime:(double)durationTime
                          yOffset:(CGFloat)yOffset;


#pragma mark - 显示菊花
/**
 * 显示菊花
 *
 * @param view
 */
+ (void)showWaitingIndicatorInView:(UIView *)view;

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


#pragma mark - 仅显示提示文字
/**
 *  仅显示提示文字
 *
 *  @param view    view
 *  @param message message
 */
+ (void)showToastInView:(UIView *)view message:(NSString *)message;


/**
 *  仅显示提示文字
 *
 *  @param view            view
 *  @param message         message
 *  @param backgroundColor 背景颜色
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor;

/**
 *  仅显示提示文字
 *
 *  @param view     view
 *  @param message  message
 *  @param position toast显示位置
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
               position:(id)position;

/**
 *  仅显示提示文字
 *
 *  @param view         view
 *  @param message      message
 *  @param durationTime durationTime
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime;

/**
 *  仅显示提示文字
 *
 *  @param view      view
 *  @param message   message
 *  @param alpha     alpha
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha;

/**
 *  仅显示提示文字
 *
 *  @param view         view
 *  @param message      message
 *  @param durationTime durationTime
 *  @param position     toast显示位置
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime
               position:(id)position;

/**
 *  仅显示提示文字
 *
 *  @param view            view
 *  @param message         message
 *  @param alpha           alpha
 *  @param durationTime    durationTime
 *  @param position        toast显示位置
 *  @param backgroundColor 背景颜色
 */
+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha
           durationTime:(CGFloat)durationTime
               position:(id)position
        backgroundColor:(UIColor *)backgroundColor;

#pragma mark - 自定义图片（图左文字右）
/**
 *  自定义图片 （图左文字右）
 *
 *  @param view    view
 *  @param image   image
 *  @param message message
 */
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message;

/**
 *  自定义图片 （图左文字右）
 *
 *  @param view     view
 *  @param image    image
 *  @param message  message
 *  @param position toast显示位置
 */
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
               position:(id)position;

/**
 *  自定义图片 （图左文字右）
 *
 *  @param view         view
 *  @param image        image
 *  @param message      message
 *  @param durationTime durationTime
 */
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
           durationTime:(CGFloat)durationTime;

/**
 *  自定义图片 （图左文字右）
 *
 *  @param view            view
 *  @param image           image
 *  @param message         message
 *  @param backgroundColor backgroundColor
 *  @param alpha           alpha
 */
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
         toastViewAlpha:(CGFloat)alpha;

/**
 *  自定义图片 （图左文字右）
 *
 *  @param view            view
 *  @param image           image
 *  @param message         message
 *  @param backgroundColor backgroundColor
 *  @param durationTime    durationTime
 *  @param position        toast显示位置
 */
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
           durationTime:(CGFloat)durationTime
               position:(id)position;

/**
 *  自定义图片 （图左文字右）
 *
 *  @param view            view
 *  @param image           image
 *  @param message         message
 *  @param backgroundColor backgroundColor
 *  @param alpha           alpha
 *  @param durationTime    durationTime
 *  @param position        toast显示位置
 */
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
         toastViewAlpha:(CGFloat)alpha
           durationTime:(CGFloat)durationTime
               position:(id)position;
@end
