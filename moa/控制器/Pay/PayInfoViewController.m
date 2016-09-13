//
//  PayViewController.m
//  moa
//
//  Created by liangkai.zheng on 16/9/12.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "PayInfoViewController.h"
#import "DYAppearance.h"

@interface PayInfoViewController()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *restName;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation PayInfoViewController

#pragma mark - View life Cycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

#pragma mark - init
- (void)initUI
{
    
    self.payBtn.layer.cornerRadius = 4;
    
    self.sumTextField.layer.borderColor = [DYAppearance colorWithRGB:0xF8721B].CGColor;
    self.sumTextField.delegate = self;
    [self.sumTextField setKeyboardType:UIKeyboardTypeNumberPad];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

#pragma mark - Method
- (IBAction)payBtnClicked:(UIButton *)sender
{
    
    
}

@end
