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

#define KHideDelayTime 30
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

+ (DYProgressHUD *)shareInstance
{
    static DYProgressHUD *progressHUD;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressHUD = [[DYProgressHUD alloc]init];
    });
    return progressHUD;
}

+ (void)showProgressHUDInView:(UIView *)view message:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    hud.color = DYAppearanceColor(@"H13", 0.5);
    hud.margin = 10.0f;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
    hud.yOffset = -50.f;
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



+ (void)showWaitingIndicatorInView:(UIView *)view
{
    [[DYProgressHUD shareInstance]showWaitingIndicatorInView:view withHideDelayTime:KHideDelayTime];
}

+ (void)showRightIndicatorInView:(UIView *)view message:(NSString *)message
{
    [[DYProgressHUD shareInstance]showRightIndicatorInView:view message:message];
}

- (void)showRightIndicatorInView:(UIView *)view message:(NSString *)message
{
    [self showCustomIndicatorInView:view image:[UIImage imageNamed:@"successTip"] message:message];
}

+ (void)showErrorIndicatorInView:(UIView *)view message:(NSString *)message
{
    [[DYProgressHUD shareInstance]showErrorIndicatorInView:view message:message];
}

- (void)showErrorIndicatorInView:(UIView *)view message:(NSString *)message
{
    [self showCustomIndicatorInView:view image:[UIImage imageNamed:@"error"] message:message];
}

- (void)showCustomIndicatorInView:(UIView *)view
                            image:(UIImage *)image
                          message:(NSString *)message
{
    [self hideWaiting];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode  = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.detailsLabelText = message;
    hud.color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7];
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
    hud.removeFromSuperViewOnHide = YES;
    [hud addGestureToHideProgressHUD];
    
    NSTimeInterval time = 0.2*message.length;
    time = 0.5;
    [hud hide:YES afterDelay:time];
}




+ (void)showWaitingIndicatorInView:(UIView *)view withHideDelayTime:(NSTimeInterval)delayTime
{
    [[DYProgressHUD shareInstance]showWaitingIndicatorInView:view withHideDelayTime:delayTime];
}

+ (void)showWaitingIndicatorCanTouchInView:(UIView *)view
{
    [[DYProgressHUD shareInstance]showWaitingCanTouchInView:view];
}
+ (void)showWaitingNotTouchInView:(UIView *)view
{
    [[DYProgressHUD shareInstance]showWaitingNotTouchInView:view];
}


+ (void)hideWaiting
{
    [[DYProgressHUD shareInstance]hideWaiting];
}




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
    hud.color =DYAppearanceColor(@"H13", 0.5);
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
    hud.color =DYAppearanceColor(@"H13", 0.5);
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
    hud.color =DYAppearanceColor(@"H13", 0.5);
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
    hud.color =DYAppearanceColor(@"H13", 0.5);
    hud.userInteractionEnabled = NO;
    [hud addGestureToHideProgressHUD];
    [_array addObject:hud];
    
    [self performSelector:@selector(hideWaiting) withObject:self afterDelay:KHideDelayTime];
}

- (void)hideWaiting
{
    for (MBProgressHUD *hud in _array){
        [hud hide:YES];
    }
    
    [_array removeAllObjects];
}



@end
