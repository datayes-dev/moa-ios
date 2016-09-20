//
//  MOANavigationViewController.m
//  moa
//
//  Created by liangkai.zheng on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MOANavigationViewController.h"
#import "UIImage+Creation.h"
#import "DYAppearance.h"

@interface MOANavigationViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation MOANavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WS(weakSelf);
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.delegate = weakSelf;
    self.interactivePopGestureRecognizer.enabled =NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moaNavBarStyle
{
    
    [self addNavBarStyleBackGroundColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)addNavBarStyleBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor
{
    [self.navigationBar setBackgroundImage:[UIImage pureimageWithColor:bgColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [[viewControllers lastObject] setHidesBottomBarWhenPushed:[viewControllers count] > 1];
    if ([viewControllers count] > 1) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    else
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super setViewControllers:viewControllers animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    UIViewController *controller = self.viewControllers.firstObject;
    controller.hidesBottomBarWhenPushed = YES; // Before push, we set root tab bar hide.
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([self.viewControllers count] == 2) {
        UIViewController *controller = self.viewControllers.firstObject;
        controller.hidesBottomBarWhenPushed = NO; // Before pop, we show root tab bar.
    }
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *controller = self.viewControllers.firstObject;
    if (viewController == controller) {
        controller.hidesBottomBarWhenPushed = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = self.viewControllers.firstObject;
    controller.hidesBottomBarWhenPushed = NO; // Before pop, we show root tab bar.
    
    return [super popToRootViewControllerAnimated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([navigationController.viewControllers count] > 1) {
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        else
        {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

@end
