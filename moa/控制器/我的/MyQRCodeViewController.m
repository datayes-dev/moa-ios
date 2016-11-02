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
#import "MOALoginViewController.h"
#import "DYAuthTokenManager.h"
#import "DYAppConfigManager.h"
#import "DYDefine.h"
#import "DYInterfacePropertiesManager.h"
#import "UIImageView+AFNetworking.h"
#import "DYLoadingViewManager.h"

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
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(DYScreenWidth - 32));
    }];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self addRightButtonWithImage:nil caption:@"退出登录" action:@selector(logout)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    showLoadingAtWindow
    
    NSURL *avaterURL = [self avatarURL];
    
    NSMutableURLRequest* mRequest = [NSMutableURLRequest requestWithURL:avaterURL
                                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                        timeoutInterval:30];
    
    if ([DYAuthTokenManager shareInstance].isLogined) {
        if ([DYAuthTokenManager shareInstance].isAccessTokenValid) {
            NSString* accessToken = [DYAuthTokenManager shareInstance].accessToken;
            NSString* accessTokenWithHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
            
            [mRequest addValue:accessTokenWithHeader forHTTPHeaderField:@"Authorization"];
        }
    }
    
    [self.qrCodeImageView setImageWithURLRequest:mRequest
                                placeholderImage:[UIImage imageNamed:@"loading"]
                                         success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                             [weakSelf.qrCodeImageView setImage:image];
                                             dismisLoadingFromWindow;
                                             [weakSelf.qrCodeButton setEnabled:YES];
                                         } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                             [weakSelf.qrCodeImageView setImage:[UIImage imageNamed:@"error"]];
                                             dismisLoadingFromWindow;
                                             [weakSelf.qrCodeButton setEnabled:YES];
                                         }];
}

- (NSURL*)avatarURL {
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    NSString *baseUrl = nil;
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
            baseUrl = [DYInterfacePropertiesManager shareInstance].qaAuthorityUrl;
            break;
            
        case eCurrentEnvTypeQA:
            baseUrl = [DYInterfacePropertiesManager shareInstance].qaAuthorityUrl;
            break;
            
        case eCurrentEnvTypeStag:
            baseUrl = [DYInterfacePropertiesManager shareInstance].stageAuthorityUrl;
            break;
            
        case eCurrentEnvTypeProduct:
            baseUrl = [DYInterfacePropertiesManager shareInstance].productAuthorityUrl;
            break;
            
        default:
            break;
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, @"meal_ticket/qrcode/user"]];
}

- (void)setupTimer
{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:60*60 target:self selector:@selector(requestQRCode) userInfo:nil repeats:YES];
    [timer fire];
    self.timer = timer;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)logout
{
    [self logoutAccount];
}

- (void)logoutAccount {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认退出当前帐号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { // 退出
        [[DYAuthTokenManager shareInstance] logout];
        [[DYAppConfigManager shareInstance] saveIntoFile];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MOALoginViewController" bundle:[NSBundle mainBundle]];
        MOALoginViewController *loginVC = (MOALoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MOALoginViewController"];
        [self.navigationController setViewControllers:@[loginVC] animated:YES];
    }
}
@end
