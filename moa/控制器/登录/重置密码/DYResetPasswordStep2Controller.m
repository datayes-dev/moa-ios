/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  DYResetPasswordStep2Controller.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/3/26.
//

#import "DYResetPasswordStep2Controller.h"
#import "DYAuthorityRegisterDataSource.h"
//#import "AlertView.h"
//#import "DYMessageDefine.h"
//#import "NSString+Verify.h"
#import "AppDelegate.h"
//#import "LewPopupViewAnimationSpring.h"
#import "DYAuthorityResetPasswordDataSource.h"
#import "DYAuthTokenManager.h"
#import "DYLoginViewController.h"
#import "DYAppearance.h"
#import "DYProgressHUD.h"

#define ToastDefaultDuration 1.0

@interface DYResetPasswordStep2Controller ()<UIAlertViewDelegate>
{
    UIAlertView * alertView;
    __block int timeout; //倒计时时间
}
@property (weak, nonatomic) IBOutlet UIView *inputRootView;
@property (weak, nonatomic) IBOutlet UILabel *pswKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *hideOrShowButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (strong, nonatomic) DYAuthorityResetPasswordDataSource *dataSource;
@property (strong, nonatomic) UIAlertView* alert;

@property (nonatomic)BOOL isEyeopen;

@end


@implementation DYResetPasswordStep2Controller

#pragma mark - Property Init
- (DYAuthorityResetPasswordDataSource *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[DYAuthorityResetPasswordDataSource alloc] init];
    }
    return _dataSource;
}

- (UIAlertView *)alert{
    if (_alert == nil) {
        _alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    return _alert;
}

#pragma mark --Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.passwordTextField.passwordText = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"重置密码";
    if (self.passwordTextField.text.length>0){
        return;
    }
    [self.passwordTextField becomeFirstResponder];
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DDLogDebug(@"%s",__FUNCTION__);
}

- (void)setupSubViews
{
    self.title = @"设置密码";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.pswKeyLabel.text = @"密码";
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    // 按钮
    self.nextStepButton.layer.cornerRadius = 4;
    self.nextStepButton.layer.masksToBounds = YES;
    UIImage* image =[UIImage imageNamed:@"loginbtn2bg.png"];
    UIImage* loginbtn2selbg =[UIImage imageNamed:@"loginbtn2selbg.png"];
    UIImage* loginbtn2disbg =[UIImage imageNamed:@"loginbtn2disbg.png"];
    [self.nextStepButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];//未按下时背景颜色
    [self.nextStepButton setBackgroundImage:[loginbtn2selbg stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateHighlighted];//按下时背景颜色
    [self.nextStepButton setBackgroundImage:[loginbtn2disbg stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateDisabled];//不能点击时背景颜色
    [self.nextStepButton setEnabled:NO];
     [self.nextStepButton setTitle:@"确定" forState:UIControlStateNormal];

    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:@"8~20位，必须包括字母、数字和符号"
                                                    
                                                    attributes:@{
                                                                 NSForegroundColorAttributeName:[DYAppearance colorWithRGB:0xC7C7CD ],
                                                                 NSFontAttributeName:[UIFont systemFontOfSize:10]
                                                                 }
                                                    ];


//    self.passwordTextField.maxCharaterNumber = kDYLoginPswMaxCount;
    [self.passwordTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark - actions

- (void)textFieldChange
{
    // 判断是否有中文
    for(int i=0; i< [self.passwordTextField.text length];i++){
        int a = [self.passwordTextField.text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            NSString *ChineseStr = [self.passwordTextField.text substringFromIndex:i];
            ChineseStr = @"";
            NSString *inputStr = [self.passwordTextField.text substringToIndex:i];
            self.passwordTextField.text = [inputStr stringByAppendingString:ChineseStr];
        }
    }
    
    if (self.passwordTextField.text.length >=6) {
        [self.nextStepButton setEnabled:YES];
    }
    else{
        [self.nextStepButton setEnabled:NO];
    }
}

- (IBAction)hideOrShowButtonClicked:(id)sender
{
    self.isEyeopen = !self.isEyeopen;
    NSString *string = [self.passwordTextField.text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
    
    
    if (self.isEyeopen) {
        [self.hideOrShowButton setImage:[UIImage imageNamed:@"eyeopen"] forState:UIControlStateNormal];
    }
    else
    {
        [self.hideOrShowButton setImage:[UIImage imageNamed:@"eyeclose"] forState:UIControlStateNormal];
    }
    self.passwordTextField.secureTextEntry = !self.isEyeopen;
    self.passwordTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.passwordTextField.text = string;
    [self.tableView reloadData];
}

- (IBAction)nextStepButtonClicked:(id)sender
{
    [self.passwordTextField resignFirstResponder];
    NSString* password = [self.passwordTextField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceCharacterSet]];
//    if (password.length <kDYLoginPswMinCount) {
//        [DYProgressHUD showToastInView:self.view message:@"密码长度过短" durationTime:ToastDefaultDuration];
//        return;
//    }
//    else if (![password checkLoginPassword]){
//        [DYProgressHUD showToastInView:self.view message:@"密码设置有误" durationTime:ToastDefaultDuration];
//        return;
//    }
    
    // check check code here
    WS(weakSelf);
    [self.dataSource requestResetPassword:password withToken:self.tokenString resultBlock:^(id data, NSError *error) {
        if (data != nil && error == nil) {
            long code = [[data objectForKey:@"code"] longValue];
            switch (code) {
                case 0:
                    [weakSelf showCleanAlert];
                    [weakSelf gettime];
                    [weakSelf.passwordTextField resignFirstResponder];
                    break;
                    
                    
                case 12:
                    [DYProgressHUD showToastInView:weakSelf.view
                                           message:@"密码无效，请重试"
                                      durationTime:ToastDefaultDuration];
                    break;
                    
                case 6:
                    [DYProgressHUD showToastInView:weakSelf.view
                                           message:@"已超时，请重试"
                                      durationTime:ToastDefaultDuration];
                    break;
                    
                case 19:
                    [DYProgressHUD showToastInView:weakSelf.view
                                           message:@"密码格式错误，请重试"
                                      durationTime:ToastDefaultDuration];
                    break;
                    
                default:
                    break;
            }
        }else if (error != nil){
            
        }
    }];
}

-(void) gettime{
    if(timeout<=0)
        timeout=6;
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    WS(weakSelf);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf dismiss];
                [weakSelf popToRootVC];
            });
        }else{
            int seconds = timeout-1;
            NSString *strTime = [NSString stringWithFormat:@"%d秒", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                alertView.ok.titleLabel.text =strTime;
//                [alertView.ok setTitle:strTime forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

- (UIView *)customAlerView{
    if (alertView == nil) {
        NSBundle *bundle = [NSBundle mainBundle];
        // 由于没有用到xib文件中的Owner，所以这里的owner传nil即可
        NSArray *objs = [bundle loadNibNamed:@"AlertView" owner:nil options:nil];
        alertView = [objs lastObject];
        alertView.layer.cornerRadius=5.0f;
        alertView.layer.masksToBounds=YES;
        
        alertView.delegate = self;
        if (![DYAuthTokenManager shareInstance].isLogined) {
//            [alertView.tipDescLabel setText:@"您已经完成密码重置"];
        }
        //        customAlerView = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil] lastObject];
    }
    return alertView;
}
- (void)showCleanAlert{
//    [self lew_presentPopupView: [self customAlerView] animation:[LewPopupViewAnimationSpring new] dismissed:^{
    
//    }];
    
    
}


- (void)popToRootVC
{
    if ([DYAuthTokenManager shareInstance].isLogined) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIViewController* loginVC = nil;
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[DYLoginViewController class]]) {
                loginVC = vc;
                break;
            }
        }
        
        if (loginVC != nil) {
            [self.navigationController popToViewController:loginVC animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)dismiss
{
    
//    [self lew_dismissPopupView];
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}
@end
