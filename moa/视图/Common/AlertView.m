//
//  AlertView
//  moa
//
//  Created by yun.shu on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "AlertView.h"
#import "DYAppearance.h"

@implementation AlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = DYAppearanceColor(@"W1", 1.0);
    self.tipTitle.text = @"提示";
    self.tipTitle.textColor = DYAppearanceColor(@"H13", 1.0);
    self.tipTitle.font = DYAppearanceFont(@"T5");
    
    self.tipDescLabel.text = @"您已经完成密码重置，5秒后跳转已登录界面";
    self.tipDescLabel.textColor = DYAppearanceColor(@"H5", 1.0);
    self.tipDescLabel.font = DYAppearanceFont(@"T2");
    
    [self.ok setTitle: @"确定" forState:UIControlStateNormal];
    [self.ok setTitleColor:DYAppearanceColor(@"B1", 1.0) forState:UIControlStateNormal];
    [self.ok.titleLabel setFont:DYAppearanceFont(@"T5")];
    
    self.lineView.backgroundColor = DYAppearanceColor(@"H2", 1.0);
}

- (IBAction)okBtn:(UIButton *)sender {
    [self.delegate dismiss];
    [self.delegate popToRootVC];
}
@end
