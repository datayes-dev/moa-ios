//
//  DYProgressHUD.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/26.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYProgressHUD.h"
#import "MBProgressHUD.h"
#import "DYAppearance.h"

#define kTipsViewHeight 36
#define kHideDelayTime 30
#define kDurationTime 1.0
#define kIndicatorViewAlpha 0.6
#define kToastViewAlpha 0.9

#define DY_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

static const CGFloat DYToastPadding = 10.0;
static const NSString * DYToastDefaultPosition = @"bottom";
static const NSString * DYToastCenterPosition = @"center";

@interface MBProgressHUD (HideGesture1)

- (void)addGestureToHideProgressHUD;
@end

@implementation MBProgressHUD (HideGesture1)

- (void)addGestureToHideProgressHUD
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProgressHUD:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void)hideProgressHUD:(UIGestureRecognizer *)gesture
{
    [self hide:YES];
}
@end




@interface DYProgressHUD()

{
    NSMutableArray *_array;
}

@end

@implementation DYProgressHUD
#pragma mark - 单例
+ (DYProgressHUD *)shareInstance
{
    static DYProgressHUD *progressHUD;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressHUD = [[DYProgressHUD alloc]init];
    });
    return progressHUD;
}

#pragma mark - 仅文字提示
// 仅文字提示
+ (void)showProgressHUDInView:(UIView *)view message:(NSString *)message
{
    [[DYProgressHUD shareInstance]showProgressHUDInView:view message:message yOffset:0];
}

+ (void)showProgressHUDInView:(UIView *)view message:(NSString *)message yOffset:(CGFloat)yOffset
{
    [[DYProgressHUD shareInstance]showProgressHUDInView:view message:message yOffset:yOffset];
}

- (void)showProgressHUDInView:(UIView *)view message:(NSString *)message yOffset:(CGFloat)yOffset
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    hud.color = DYAppearanceColor(@"H13", kIndicatorViewAlpha);
    hud.margin = 10.0f;
    hud.detailsLabelFont = DYAppearanceBoldFont(@"T5");
    if (!yOffset)
        hud.yOffset = -50.f;
    else
        hud.yOffset = yOffset;
    
    hud.removeFromSuperViewOnHide = YES;
    [hud addGestureToHideProgressHUD];

    NSTimeInterval time = 0.2*message.length;
    if (message.length < 5) {
        time = 1;
    }
    else if (message.length <10){
        time = 2;
    }
    else if (message.length <20){
        time = 4;
    }
    else
    {
        time = 5;
    }
    [hud hide:YES afterDelay:time];
}

#pragma mark - 自定义图片(图上文字下)
// 显示对勾图片
+ (void)showRightIndicatorInView:(UIView *)view message:(NSString *)message
{
    [[DYProgressHUD shareInstance]showRightIndicatorInView:view message:message];
}

- (void)showRightIndicatorInView:(UIView *)view message:(NSString *)message
{
    [self showCustomIndicatorInView:view image:[UIImage imageNamed:@"successTip"] message:message durationTime:0 yOffset:0];
}

// 显示叉号图片
+ (void)showErrorIndicatorInView:(UIView *)view message:(NSString *)message
{
    [[DYProgressHUD shareInstance]showErrorIndicatorInView:view message:message];
}

- (void)showErrorIndicatorInView:(UIView *)view message:(NSString *)message
{
    [self showCustomIndicatorInView:view image:[UIImage imageNamed:@"error"] message:message durationTime:0 yOffset:0];
}

// 自定义图片
+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
{
    [[DYProgressHUD shareInstance]showCustomIndicatorInView:view image:image message:message durationTime:0 yOffset:0];
}

+ (void)showCustomIndicatorInView:(UIView *)view
                             image:(UIImage *)image
                           message:(NSString *)message
                      durationTime:(double)durationTime
{
    [[DYProgressHUD shareInstance]showCustomIndicatorInView:view image:image message:message durationTime:durationTime yOffset:0];
}

+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
                          yOffset:(CGFloat)yOffset
{
    [[DYProgressHUD shareInstance]showCustomIndicatorInView:view image:image message:message durationTime:0 yOffset:yOffset];
}

+ (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
                     durationTime:(double)durationTime
                          yOffset:(CGFloat)yOffset
{
    [[DYProgressHUD shareInstance]showCustomIndicatorInView:view image:image message:message durationTime:durationTime yOffset:yOffset];
}

- (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
                     durationTime:(double)durationTime
                          yOffset:(CGFloat)yOffset
{
    [self hideWaiting];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode  = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.detailsLabelText = message;
    hud.yOffset = yOffset;
    hud.color = DYAppearanceColor(@"H13", kIndicatorViewAlpha);
    hud.detailsLabelFont = DYAppearanceBoldFont(@"T5");
    hud.removeFromSuperViewOnHide = YES;
    [hud addGestureToHideProgressHUD];
    
    if (!durationTime) {
        durationTime = kDurationTime;
    }
    [hud hide:YES afterDelay:durationTime];
}


#pragma mark - 显示菊花（类方法）
// 显示菊花
+ (void)showWaitingIndicatorInView:(UIView *)view
{
    [[DYProgressHUD shareInstance]showWaitingIndicatorInView:view withHideDelayTime:kHideDelayTime];
}

// 显示菊花，并在指定时间内关闭
+ (void)showWaitingIndicatorInView:(UIView *)view withHideDelayTime:(NSTimeInterval)delayTime
{
    [[DYProgressHUD shareInstance]showWaitingIndicatorInView:view withHideDelayTime:delayTime];
}

// 显示菊花并且可以点击消失
+ (void)showWaitingIndicatorCanTouchInView:(UIView *)view
{
    [[DYProgressHUD shareInstance]showWaitingCanTouchInView:view];
}

// 显示菊花并且不能点击消失
+ (void)showWaitingNotTouchInView:(UIView *)view
{
    [[DYProgressHUD shareInstance]showWaitingNotTouchInView:view];
}

// 隐藏菊花
+ (void)hideWaiting
{
    [[DYProgressHUD shareInstance]hideWaiting];
}


#pragma mark - 显示菊花（对象方法）
- (id)init
{
   self =  [super init];
    if (self) {
        _array = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)showWaitingIndicatorInView:(UIView *)view
{
    [self hideWaiting];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode  = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -50.0f;
    hud.color =DYAppearanceColor(@"H13", kIndicatorViewAlpha);
    hud.userInteractionEnabled = YES;
    [hud addGestureToHideProgressHUD];
    [_array addObject:hud];
}

- (void)showWaitingIndicatorInView:(UIView *)view withHideDelayTime:(NSTimeInterval)delayTime
{
    [self hideWaiting];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode  = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -50.0f;
    hud.color =DYAppearanceColor(@"H13", kIndicatorViewAlpha);
    hud.userInteractionEnabled = YES;
    [hud addGestureToHideProgressHUD];
    [_array addObject:hud];
    
    [self performSelector:@selector(hideWaiting) withObject:self afterDelay:delayTime];
}

- (void)showWaitingCanTouchInView:(UIView *)view
{
    [self hideWaiting];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode  = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -50.0f;
    hud.color =DYAppearanceColor(@"H13", kIndicatorViewAlpha);
    hud.userInteractionEnabled = YES;
    [hud addGestureToHideProgressHUD];
    [_array addObject:hud];
}

- (void)showWaitingNotTouchInView:(UIView *)view
{
    [self hideWaiting];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode  = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = -50.0f;
    hud.color =DYAppearanceColor(@"H13", kIndicatorViewAlpha);
    hud.userInteractionEnabled = NO;
    [hud addGestureToHideProgressHUD];
    [_array addObject:hud];
    
    [self performSelector:@selector(hideWaiting) withObject:self afterDelay:kHideDelayTime];
}

- (void)hideWaiting
{
    for (MBProgressHUD *hud in _array){
        [hud hide:YES];
    }
    
    [_array removeAllObjects];
}

#pragma mark - 仅显示提示文字
// 仅显示提示文字
+ (void)showToastInView:(UIView *)view message:(NSString *)message
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:nil message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:0 position:DYToastCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:nil message:message toastBackGroundColor:backgroundColor];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:0 position:DYToastCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
               position:(id)position
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:nil message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:0 position:position];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:nil message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:durationTime position:DYToastCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:nil message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:alpha duration:0 position:DYToastCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
           durationTime:(CGFloat)durationTime
               position:(id)position
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:nil message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:durationTime position:position];
}

+ (void)showToastInView:(UIView *)view
                message:(NSString *)message
                  alpha:(CGFloat)alpha
           durationTime:(CGFloat)durationTime
               position:(id)position
        backgroundColor:(UIColor *)backgroundColor
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:nil message:message toastBackGroundColor:backgroundColor];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:alpha duration:durationTime position:position];
}

#pragma mark - 自定义图片（图左文字右）
// 自定义图片 （图左文字右）
+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:image message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:0 position:DYToastCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
               position:(id)position
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:image message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:0 position:position];
}

+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
           durationTime:(CGFloat)durationTime
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:image message:message toastBackGroundColor:nil];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:0 duration:durationTime position:DYToastCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
         toastViewAlpha:(CGFloat)alpha
{
    UIView *toast = [[DYProgressHUD shareInstance] toastInView:view image:image message:message toastBackGroundColor:backgroundColor];
    [[DYProgressHUD shareInstance] showToast:toast onView:view alpha:alpha duration:0 position:DYToastCenterPosition];
}

+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
           durationTime:(CGFloat)durationTime
               position:(id)position
{
    UIView *toast = [[DYProgressHUD shareInstance]toastInView:view image:image message:message toastBackGroundColor:backgroundColor];
    [[DYProgressHUD shareInstance]showToast:toast onView:view alpha:0 duration:durationTime position:position];
}

+ (void)showToastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
         toastViewAlpha:(CGFloat)alpha
           durationTime:(CGFloat)durationTime
               position:(id)position
{
    UIView *toast = [[DYProgressHUD shareInstance]toastInView:view image:image message:message toastBackGroundColor:backgroundColor];
    [[DYProgressHUD shareInstance]showToast:toast onView:view alpha:alpha duration:durationTime position:position];
}

#pragma mark - Private Methods
// 创建toast
- (UIView *)toastInView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
   toastBackGroundColor:(UIColor *)backgroundColor
{
    if (image == nil && message == nil) {
        return nil;
    }
    
    UIImageView *imageView = nil;
    UILabel *messageLabel = nil;
    
    // toastView
    UIView *toastView = [[UIView alloc] init];
    if (!backgroundColor) {
        toastView.backgroundColor = DYAppearanceColor(@"B4",kToastViewAlpha);
    }
    toastView.layer.cornerRadius = 3;
    
    // imageView
    if (image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(DYToastPadding, DYToastPadding, image.size.width, image.size.height);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    if (imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = DYToastPadding;
    }else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    // messageLabel
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.text = message;
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = DYAppearanceColor(@"W1",1.0);
        messageLabel.font = DYAppearanceFont(@"T3");
        
        CGFloat toastMaxWidth = 0.8;
        CGSize maxSizeMessage = CGSizeMake((view.bounds.size.width * toastMaxWidth) - imageWidth, view.bounds.size.height * toastMaxWidth);
        NSDictionary *attributes = @{NSFontAttributeName:messageLabel.font};
        CGRect expectedRectMessage = [message boundingRectWithSize:maxSizeMessage options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedRectMessage.size.width, expectedRectMessage.size.height);
    }
    
    CGFloat labelWidth, labelHeight,labelLeft, labelTop;
    if (messageLabel != nil) {
        labelWidth = messageLabel.bounds.size.width;
        labelHeight = messageLabel.bounds.size.height;
        labelLeft = imageLeft + imageWidth + DYToastPadding;
        labelTop = DYToastPadding;
    }else {
        labelWidth = labelHeight = labelLeft = labelTop = 0.0;
    }
    
    // toastView frame
    CGFloat toastViewW = MAX((imageWidth + (DYToastPadding * 2)),labelLeft + labelWidth + DYToastPadding);
    CGFloat toastViewH = MAX((labelHeight + DYToastPadding + labelTop), (imageHeight + (DYToastPadding * 2)));
    toastView.frame = CGRectMake(0, 0, toastViewW, toastViewH);
    
    // messageLabel frame
    if (messageLabel != nil) {
        messageLabel.frame = CGRectMake(labelLeft, labelTop, labelWidth, labelHeight);
        [toastView addSubview:messageLabel];
    }
    
    // imageView frame
    if (imageView != nil) {
        CGRect imageViewF = imageView.frame;
        imageViewF.origin.y = (toastView.frame.size.height - imageHeight) * 0.5;
        imageView.frame = imageViewF;
        [toastView addSubview:imageView];
    }
    
    return toastView;
}

// 显示toast
- (void)showToast:(UIView *)toast onView:(UIView *)superView alpha:(CGFloat)alpha duration:(CGFloat)durationTime position:(id)point {
    toast.center = [self centerPointForPosition:point withToast:toast withView:superView];
    [superView addSubview:toast];
    
    if (!alpha) {
        alpha = 1.0;
    }
    toast.alpha = alpha;
    
    // animation
    if (!durationTime) {
        durationTime = kDurationTime;
    }
    
    [UIView animateWithDuration:durationTime
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:durationTime
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
}

// toast frame
- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast withView:(UIView *)view {
    if([point isKindOfClass:[NSString class]]) {
        
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(view.bounds.size.width/2, (toast.frame.size.height / 2) + DYToastPadding);
            
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(view.bounds.size.width/2, (view.bounds.size.height - (toast.frame.size.height / 2)) - DYToastPadding);
            
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            return CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
            
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    NSLog(@"Warning: Invalid position for toast.");
    return [self centerPointForPosition:DYToastDefaultPosition withToast:toast withView:view];
}


@end
