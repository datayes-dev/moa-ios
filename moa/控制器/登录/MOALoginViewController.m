//
//  MOALoginViewController.m
//  moa
//
//  Created by yun.shu on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MOALoginViewController.h"
#import "DYAuthorityLoginDataSource.h"
#import "DYAuthorityManager.h"
#import "UIImageView+DatayesAuthority.h"
#import "DYAuthorityDataSource.h"
#import "DYAuthorityResponseHelper.h"
#import "DYAppNotification.h"
//#import "DYFavoriteInfoManager.h"
//#import "DYDataSyncHelper.h"

#import "DYAppConfigManager.h"
#import "DYAuthTokenManager.h"
#import "DYResetPasswordStep1Controller.h"
#import "DYProgressHUD.h"
#import "Masonry.h"
#import "RootViewController.h"
#import "MyCenterRootViewController.h"

#define ToastDefaultDuration 2.0

NSString *visitLoginName = @"visitLoginName";   // 记录访问登录界面的各个控制器名称


@interface MOALoginViewController (){
    bool isImageCheck;
}

@property (weak, nonatomic) IBOutlet UIView *inputRootView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIView *imageCheckRootView;
@property (weak, nonatomic) IBOutlet UITextField *imageCheckTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageCheckButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *hideOrShowPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic)BOOL isEyeopen;

@end

@implementation MOALoginViewController

#pragma mark - View's Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubViews];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.userNameTextField becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - UI Method
- (void)setupSubViews
{
    self.title = @"登录";
    // 登录按钮
    self.loginButton.layer.cornerRadius = 4;
    self.loginButton.layer.masksToBounds = YES;
    
    // 先隐藏图片验证码部分
    [self hideOrShowImageCheckPart:NO];
    [self.imageCheckButton addSubview:self.activityView];
    UIImage* image =[UIImage imageNamed:@"loginbtn2bg.png"];
    UIImage* image1 =[UIImage imageNamed:@"loginbtn2selbg.png"];
    UIImage* image2 =[UIImage imageNamed:@"loginbtn2disbg.png"];
    
    [self.loginButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];//未按下时背景颜色
    [self.loginButton setBackgroundImage:[image1 stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateHighlighted];//按下时背景颜色
    [self.loginButton setBackgroundImage:[image2 stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateDisabled];//不能点击时背景颜色
    
    self.userNameTextField.delegate = self;
    self.userNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.placeholder = @"手机号/用户名";
    [self.userNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.placeholder = @"请输入密码";
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.imageCheckTextField.delegate = self;
    self.imageCheckTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.imageCheckTextField.returnKeyType = UIReturnKeyDone;
    self.imageCheckTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.imageCheckTextField.placeholder = @"请输入验证码";
    [self.imageCheckTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.loginButton setTitle: @"登录" forState:UIControlStateNormal ];
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal ];
    
    self.loginButton.enabled = NO;
    
}

#pragma mark - actions

/**
 *	@brief	验证码获取按钮
 *
 *	@param 	sender
 */
- (IBAction)imageCheckButtnClicked:(id)sender
{
    [self.activityView startAnimating];
    NSArray* viewsArray = [self.imageCheckButton subviews];
    for (UIView* subView in viewsArray) {
        if (subView.tag == 1001) {
            [subView removeFromSuperview];
            break;
        }
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.imageCheckButton.bounds];
    imageView.tag = 1001;
    [imageView setAuthorityImage];
    [self.imageCheckButton addSubview:imageView];
}

/**
 *	@brief	隐藏显示密码Click
 *
 *	@param 	sender
 */
- (IBAction)hideOrShowPasswordButtonClicked:(id)sender

{
    self.isEyeopen = !self.isEyeopen;
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceCharacterSet]];
    self.passwordTextField.secureTextEntry = !self.isEyeopen;
    
    if (self.isEyeopen) {
        [self.hideOrShowPasswordButton setImage:[UIImage imageNamed:@"eyeopen"] forState:UIControlStateNormal];
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [self.hideOrShowPasswordButton setImage:[UIImage imageNamed:@"eyeclose"] forState:UIControlStateNormal];
        [self.passwordTextField becomeFirstResponder];
        
    }
    self.passwordTextField.text = password;
    if (self.passwordTextField.secureTextEntry) {
        [self.passwordTextField insertText:self.passwordTextField.text];
    }
}


/**
 *	@brief	登录按钮Clicked
 *
 *	@param 	sender
 */
- (IBAction)loginButtonClicked:(id)sender

{
    [self hideKeyboard];
    [self.activityView stopAnimating];
    NSString *userName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = self.passwordTextField.text;
    NSString *captcha = self.imageCheckTextField.text;
    
    NSString *tenant = nil;
    if ([userName containsString:@"@"]) {
        NSRange range = [userName rangeOfString:@"@"];
        tenant = [userName substringFromIndex:range.location + 1];  // 域名
        userName = [userName substringToIndex:range.location];      // 用户名
    }
    //check input
//    if (tenant == nil) {
//        [DYProgressHUD showToastInView:self.view message:@"用户名不正确"];
//        return;
//    }
    
    // 将用户名保存起来
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:USER_NAME_KEY];
    [userDefaults synchronize];
    
    __weak __typeof(self)weakSelf = self;
    [[DYAuthorityManager sharedInstance] requestAccessTokenWithUserName:userName password:password captcha:captcha tenant:tenant resultBlock:^(id data, NSError *error) {
        if (!error && data != nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userName forKey:USER_NAME_KEY];
            [userDefaults synchronize];

            [DYProgressHUD showToastInView:weakSelf.view message:@"登录中..." durationTime:ToastDefaultDuration];
            [weakSelf.loginButton setEnabled:NO];
//            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"root" bundle:[NSBundle mainBundle]];
//            RootViewController *rootVc = [storyboard instantiateViewControllerWithIdentifier:@"RootViewControllerIdentifier"];
//            [self.navigationController pushViewController:rootVc animated:YES];
            MyCenterRootViewController *centerVC = [[MyCenterRootViewController alloc]init];
            [self.navigationController pushViewController:centerVC animated:YES];

            //握手接口调用
//            [[DYAppNotification shareInstance]fetchAppLogin:YES NotificationWithResultBlock:^(id data, NSError *error) {
//                
//            }];

            //            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS_NOTIFY_KEY object:nil];
            
            //            [weakSelf ifNewRegisterUser];
        }
        else
        {
            // CodeRequired
            if (error.code == CodeRequired) {
                [weakSelf hideOrShowImageCheckPart:YES];
                if (captcha == nil || captcha.length <= 0) {
                    // errcode = -130; errmsg = CODE_REQUIRED
                    [DYProgressHUD showToastInView:weakSelf.view message:error.userInfo[@"message"] durationTime:ToastDefaultDuration];
                    
                }else {
                    // errcode = -130; errmsg = INVALID_CODE
                    [DYProgressHUD showToastInView:weakSelf.view message:@"验证码输入有误"durationTime:ToastDefaultDuration];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf imageCheckButtnClicked:nil];
                });
                
            }else {
                [weakSelf hideOrShowImageCheckPart:YES];
                [DYProgressHUD showToastInView:weakSelf.view message:error.userInfo[@"message"] durationTime:ToastDefaultDuration];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf imageCheckButtnClicked:nil];
                });
            }
        }
    }];
}


/**
 *	@brief	重置密码
 *
 *	@param 	sender
 */
- (IBAction)forgetPasswordButtonClicked:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"DYResetPasswordViewController" bundle:nil];
    DYResetPasswordStep1Controller* resetPwVC = [story instantiateViewControllerWithIdentifier:@"DYResetPasswordStep1Controller"];
    [self.navigationController pushViewController:resetPwVC animated:YES];
}


#pragma mark - local functions
- (void)hideOrShowImageCheckPart:(BOOL)show
{
    if (!show) {
        [self.imageCheckRootView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.inputRootView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@92);
        }];
    }
    else
    {
        isImageCheck = YES;
        if (self.imageCheckTextField.text.length!=4)
            self.loginButton.enabled = NO;
        
        [self.imageCheckRootView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@46);
        }];
        [self.inputRootView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@138);
        }];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (isImageCheck)
    {
        if (self.imageCheckTextField.text.length > 3 &&
            self.userNameTextField.text.length > 1 &&
            self.passwordTextField.text.length > 5)
            self.loginButton.enabled = YES;
        else
            self.loginButton.enabled = NO;
    }
    else
    {
        if(self.userNameTextField.text.length > 1 &&
           self.passwordTextField.text.length > 5)
            self.loginButton.enabled = YES;
        else
            self.loginButton.enabled = NO;
    }
}

/* 隐藏键盘 */
- (void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

/*
 - (void)ifNewRegisterUser
 {
 if ([DYAuthTokenManager shareInstance].isLogined) {
 WS(weakSelf);
 [[DYDataSyncHelper shareInstance] checkDataVersionWithType:eSyncDataFavoriteChannels withResultBlock:^(id data, NSError *error) {
 
 if (error) {
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [weakSelf.navigationController popViewControllerAnimated:YES];
 });
 return ;
 }
 NSInteger version = [[DYDataSyncHelper shareInstance] getVersionFromArray:(NSArray *)data forSyncType:eSyncDataFavoriteChannels];
 //本地无数据，且服务器端版本号为0，则是新用户，需要选择兴趣
 if (version == 0) {
 //新用户，判断是否有选择兴趣
 //                    if (![DYAppConfigManager shareInstance].hasChooseIntersting) {
 //                        DYInterstingViewController *vc = [DYInterstingViewController quickInitInstance];
 //                        [self.navigationController pushViewController:vc animated:YES];
 //                    }else{
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [weakSelf.navigationController popViewControllerAnimated:YES];
 });
 //                    }
 }
 else
 {
 [DYAppConfigManager shareInstance].hasChooseIntersting = YES;
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [weakSelf.navigationController popViewControllerAnimated:YES];
 });
 }
 }];
 }else{
 //        if (![DYAppConfigManager shareInstance].hasChooseIntersting) {
 //            DYInterstingViewController *vc = [DYInterstingViewController quickInitInstance];
 //            [self.navigationController pushViewController:vc animated:YES];
 //        }
 }
 }
 */


#pragma mark - UITextFieldDelegate functions
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passwordTextField) {
        if (textField.secureTextEntry) {
            [textField insertText:self.passwordTextField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString* mString = [NSMutableString stringWithString:textField.text];
    [mString replaceCharactersInRange:range withString:string];
    
    BOOL result = YES;
    
    if (textField == self.userNameTextField)
    {
        if (mString.length > 40)
            result = NO;
    }
    else if(textField == self.passwordTextField)
    {
        if ([mString length] > 20)
            result = NO;
    }
    else if(textField == self.imageCheckTextField)
    {
        if (mString.length > 4)
            result = NO;
    }
    
    return result;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userNameTextField isFirstResponder]) {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    
    if ([self.passwordTextField isFirstResponder] || [self.imageCheckTextField isFirstResponder]) {
        [self loginButtonClicked:nil];
        return YES;
    }
    
    return YES;
}


@end
