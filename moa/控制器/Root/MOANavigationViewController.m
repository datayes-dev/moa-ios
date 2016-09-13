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
    [self addLeftButtonWithImage:@"back" hightLightImage:nil caption:nil];
}

- (void)addNavBarStyleBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor
{
    [self.navigationBar setBackgroundImage:[UIImage pureimageWithColor:bgColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


- (UIButton *)addLeftButtonWithImage:(UIImage *)image hightLightImage:(UIImage *)hightImage caption:(NSString *)caption
{
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *leftButton = nil;
    if (image && caption) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton setImage:image forState:UIControlStateNormal];
        [leftButton setImage:image forState:UIControlStateHighlighted];
        [leftButton setImage:image forState:UIControlStateSelected];
        
        [leftButton setTitle:caption forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[DYAppearance colorWithRGB:0x888888] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchDown];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        float title_Width = [caption boundingRectWithSize:CGSizeMake(50, 16) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{@"NSFontAttributeName":[UIFont boldSystemFontOfSize:16]} context:nil].size.width;
        float image_Width = image.size.width;
        
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [leftButton setFrame: CGRectMake(0, 0, title_Width + image_Width, 44)];
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else if (image){
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 44, 44);
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [leftButton setImage:image forState:UIControlStateNormal];
        [leftButton setImage:image forState:UIControlStateHighlighted];
        [leftButton setImage:image forState:UIControlStateSelected];
        if (caption != nil) {
            [leftButton setTitle:caption forState:UIControlStateNormal];
        }
        [leftButton setTitleColor:[DYAppearance colorWithRGB:0x780000] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        leftItem.title = @"";
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    else if (caption){
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame: CGRectMake(0, 0, 35, 44)];
        leftButton.backgroundColor = [UIColor clearColor];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftButton setTitle:caption forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    return leftButton;
}

- (void)leftButtonClick:(UIButton *)button
{
    [self popViewControllerAnimated:YES];
}
@end
