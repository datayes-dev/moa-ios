//
//  ViewController.m
//  moa
//
//  Created by 鄢彭超 on 16/9/12.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "RootViewController.h"
#import "ScanViewController.h"
#import "MOANavigationViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)scanQRCode:(UIButton *)sender
{
    
    ScanViewController *vc = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
