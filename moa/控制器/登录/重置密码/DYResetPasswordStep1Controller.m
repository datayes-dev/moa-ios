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
//  DYResetPasswordStep1Controller.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/3/26.
//

#import "DYResetPasswordStep1Controller.h"

#import "DYResetPasswordStep2Controller.h"
#import "DYAuthorityRegisterDataSource.h"
#import "DYAuthorityResponseHelper.h"
//#import "NSString+Verify.h"
#import "DYTextField.h"
#import "DYMessageDefine.h"
#import "AppDelegate.h"
#import "DYAuthorityResetPasswordDataSource.h"
#import "DYProgressHUD.h"
#import "DYAppearance.h"

#define kResetStep2Identify @"SetPSStep2Identify"
#define ToastDefaultDuration 1.0

@interface DYResetPasswordStep1Controller ()<UITextFieldDelegate>
{
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *verCodeKeyLabel;

@property (weak, nonatomic) IBOutlet UIView *inputRootView;
@property (weak, nonatomic) IBOutlet DYTextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeButton;
@property (weak, nonatomic) IBOutlet DYTextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (nonatomic, strong) DYAuthorityResetPasswordDataSource *dataSource;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSString *tokenString;
@end

@implementation DYResetPasswordStep1Controller

-(UIAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    return _alertView;
}

- (DYAuthorityResetPasswordDataSource *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[DYAuthorityResetPasswordDataSource alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self setupSubViews];
    [self startTime];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"重置密码";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.phoneNumberTextField becomeFirstResponder];
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
    self.phoneKeyLabel.text = @"手机号";
    self.verCodeKeyLabel.text = @"验证码";
    [self.checkCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.checkCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    // 按钮
    self.checkCodeButton.layer.cornerRadius = 2;
    self.checkCodeButton.layer.masksToBounds = YES;
    self.nextStepButton.layer.cornerRadius = 4;
    self.nextStepButton.layer.masksToBounds = YES;
    
    UIImage* image =[UIImage imageNamed:@"loginbtn2bg.png"];
    UIImage* loginbtn2selbg =[UIImage imageNamed:@"loginbtn2selbg.png"];
    UIImage* loginbtn2disbg =[UIImage imageNamed:@"loginbtn2disbg.png"];
    [self.nextStepButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];//未按下时背景颜色
    [self.nextStepButton setBackgroundImage:[loginbtn2selbg stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateHighlighted];//按下时背景颜色
    [self.nextStepButton setBackgroundImage:[loginbtn2disbg stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateDisabled];//不能点击时背景颜色
    
    [self.nextStepButton setEnabled:NO];
    
    [self.checkCodeButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];//未按下时背景颜色
    [self.checkCodeButton setBackgroundImage:[loginbtn2selbg stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateHighlighted];//按下时背景颜色
    [self.checkCodeButton setBackgroundImage:[loginbtn2disbg stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateDisabled];
    
    self.phoneNumberTextField.maxCharaterNumber = kDYInputMobilePhoneNumMaxCount;
    self.checkCodeTextField.maxCharaterNumber  =kDYVerifyCodeMaxCount;
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldChange1:) forControlEvents:UIControlEventEditingChanged];
    [self.checkCodeTextField addTarget:self action:@selector(textFieldChange1:) forControlEvents:UIControlEventEditingChanged];
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.checkCodeTextField.placeholder = @"6位验证码";
    self.phoneNumberTextField.placeholder = @"11位手机号";
    self.phoneNumberTextField.keyboardType =UIKeyboardTypeNumberPad;
    self.checkCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - Timer Method

-(void) startTime
{
    if (delegate.timeout>0){
        [self gettime];
        [self.checkCodeButton setEnabled:NO];
        
    }
    if (self.phoneNumberTextField.text.length<11)
        [self.checkCodeButton setEnabled:NO];
}

-(void) gettime
{
    if (delegate.timeout<=0)
        delegate.timeout  = 61;
    
    if(delegate.queue!=nil){
        dispatch_source_cancel(delegate._timer);
        delegate.queue=nil;
        delegate. _timer=nil;
    }
    self.checkCodeButton.enabled = NO;
    delegate.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    delegate. _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,delegate.queue);
    dispatch_source_set_timer(delegate._timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    WS(weakSelf);
    dispatch_source_set_event_handler(delegate._timer, ^{
        if(delegate.timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(delegate._timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.checkCodeButton setEnabled:YES];
                [weakSelf.checkCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
                weakSelf.checkCodeButton.titleLabel.text = @"获取验证码";
                
            });
        }else{
            int seconds = delegate.timeout-1;
            NSString *strTime = [NSString stringWithFormat:@"剩余%d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.checkCodeButton setTitleColor:DYAppearanceColor(@"W1", 1.0) forState:UIControlStateDisabled];
                weakSelf.checkCodeButton.titleLabel.text =strTime;
                [weakSelf.checkCodeButton setTitle:strTime forState:UIControlStateDisabled];
                
            });
            delegate.timeout--;
        }
    });
    dispatch_resume(delegate._timer);
}



#pragma mark - UITextField actions
- (void)textFieldChange1 :(UITextField*) textfield
{
    if (textfield==self.phoneNumberTextField) {
        if (self.phoneNumberTextField.text.length >=11&&delegate.timeout<=0){
            self.checkCodeButton.enabled = YES;
        }
        else{
            self.checkCodeButton.enabled = NO;
        }
    }
    if (self.phoneNumberTextField.text.length >=11 && self.checkCodeTextField.text.length >=6) {
        self.nextStepButton.enabled = YES;
    }
    else{
        self.nextStepButton.enabled = NO;
    }
}


#pragma mark - actions
- (IBAction)checkCodeButtonClicked:(id)sender
{
    [self.phoneNumberTextField resignFirstResponder];
    [self.checkCodeTextField resignFirstResponder];
    // check mobile
    NSString* mobile = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
    if(!mobile || [mobile isEqualToString:@""]) {
        [DYProgressHUD showToastInView:self.view message:@"请输入手机号码" durationTime:ToastDefaultDuration];
        return;
    }
//    else if (![mobile checkMobilePhoneNo]){
//        [DYProgressHUD showToastInView:self.view message:@"手机号码不符合" durationTime:ToastDefaultDuration];
//        return;
//    }
    
    
    WS(weakSelf);
    DYAuthorityResetPasswordDataSource *dataSource = [[DYAuthorityResetPasswordDataSource alloc]init];
    [dataSource requestUserInfoWithMobile:mobile resultBlock:^(id data, NSError *error) {
        if (data != nil && error == nil) {
            NSDictionary *result = (NSDictionary *)data;
            long code = [[result objectForKey:@"code"] longValue];
            switch (code) {
                case 0:{
                    [dataSource requestMobileValidCodeWithResultBlock:^(id data, NSError *error) {//发送验证码
                        NSDictionary *result = (NSDictionary *)data;
                        long code = [[result objectForKey:@"code"] longValue];
                        if (code == 0) {
                            [weakSelf gettime];
                            [DYProgressHUD showToastInView:weakSelf.view message:@"验证码已发送" durationTime:ToastDefaultDuration];
                        }
                    }];
                    break;
                }
                    
                case 11:
                    delegate.timeout  = 0;
                    delegate.queue=nil;
                    delegate. _timer=nil;
                    [weakSelf.checkCodeButton setEnabled:YES];
                    [weakSelf.checkCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
                    [DYProgressHUD showToastInView:weakSelf.view message:@"您输入的手机号码或用户名不存在，请重新输入" durationTime:ToastDefaultDuration];
                    break;
                    
                default:
                    delegate.timeout  = 0;
                    delegate.queue=nil;
                    delegate. _timer=nil;
                    [weakSelf.checkCodeButton setEnabled:YES];
                    [weakSelf.checkCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
                    [DYProgressHUD showToastInView:weakSelf.view message:@"您输入的手机号码错误，请重新输入" durationTime:ToastDefaultDuration];
                    break;
            }
            
        }else if (error != nil){
            delegate.timeout  = 0;
            delegate.queue=nil;
            delegate. _timer=nil;
            [weakSelf.checkCodeButton setEnabled:YES];
            [weakSelf.checkCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
        }
    }];
}


- (IBAction)nextStepButtonClicked:(id)sender {
    [self.phoneNumberTextField resignFirstResponder];
    [self.checkCodeTextField resignFirstResponder];
    NSString* validCode = [self.checkCodeTextField.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
    WS(weakSelf);
    [self.dataSource requestResetTokenWithValidCode:validCode resultBlock:^(id data, NSError *error) {
        self.tokenString = nil;
        if (data != nil && error == nil) {
            long code = [[data objectForKey:@"code"] longValue];
            switch (code) {
                case 0:{
                    weakSelf.tokenString = [data objectForKey:@"data"];
                    [weakSelf performSegueWithIdentifier:kResetStep2Identify sender:weakSelf];
                    break;
                }
                    
                case 13:
                    [DYProgressHUD showToastInView:weakSelf.view message:@"用户名不存在，请重新输入" durationTime:ToastDefaultDuration];
                    break;
                    
                case 18:
                    [DYProgressHUD showToastInView:weakSelf.view message:@"验证码错误，请重新获取"durationTime:ToastDefaultDuration];
                    break;
                    
                case 20:
                    [DYProgressHUD showToastInView:weakSelf.view message:@"验证码已过期，请重新获取" durationTime:ToastDefaultDuration];
                    break;
                    
                    
                default:
                    [DYProgressHUD showToastInView:weakSelf.view message:@"其他错误，请重新输入" durationTime:ToastDefaultDuration];
                    break;
            }
            
        }
        else if (error != nil){
            //
        }
        
    }];
}


#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.tokenString &&[segue.identifier isEqualToString:kResetStep2Identify]) {
            DYResetPasswordStep2Controller *reset2VC = segue.destinationViewController;
            reset2VC.tokenString = self.tokenString;
        }
}

@end
    
    
    
