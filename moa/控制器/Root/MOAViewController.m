//
//  MOAViewController.m
//  moa
//
//  Created by liangkai.zheng on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MOAViewController.h"
#import "MOATradeDetailViewController.h"


@interface MOAViewController ()

@end

@implementation MOAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftButtonWithImage:[UIImage imageNamed:@"back"] hightLightImage:nil caption:nil];
    [self addRightButtonWithImage:nil caption:@"消费记录" action:@selector(toTradeDetail)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toTradeDetail
{
    
    MOATradeDetailViewController *vc = [[MOATradeDetailViewController alloc] initWithNibName:@"MOATradeDetailViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
