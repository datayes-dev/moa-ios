//
//  MyQRCodeViewController.m
//  moa
//
//  Created by 鄢彭超 on 2016/10/31.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "MOATradeInfoAdapter.h"
#import "Masonry.h"

@interface MyQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIButton *qrCodeButton;

@property (nonatomic, strong)MOATradeInfoAdapter* adapter;
@property (nonatomic, strong)NSTimer* timer;

@end

@implementation MyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"我的二维码";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.qrCodeImageView.bounds.size.width));
    }];
    [self setupTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopTimer];
}

- (MOATradeInfoAdapter *)adapter
{
    if (_adapter == nil) {
        _adapter = [MOATradeInfoAdapter shareInstance];
    }
    return _adapter;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)refreshQRCodeButtonClicked:(id)sender {
    [self requestQRCode];
}

- (void)requestQRCode
{
    WS(weakSelf);
    [weakSelf.qrCodeButton setEnabled:NO];
    
    [self.adapter getAllHotelsInfo:^(id data, NSError *error) {
        [weakSelf.qrCodeButton setEnabled:YES];
    }];
}

- (void)setupTimer
{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(requestQRCode) userInfo:nil repeats:YES];
    [timer fire];
    self.timer = timer;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
