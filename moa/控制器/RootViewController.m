//
//  ViewController.m
//  moa
//
//  Created by 鄢彭超 on 16/9/12.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "RootViewController.h"
#import "ScanViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanQRCode:(UIButton *)sender
{
    
    ScanViewController *vc = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
