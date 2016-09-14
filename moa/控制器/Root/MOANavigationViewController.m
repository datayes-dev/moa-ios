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

@interface MOANavigationViewController ()

@end

@implementation MOANavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
@end
