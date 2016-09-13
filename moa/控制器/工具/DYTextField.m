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
//  DYTextField.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/22.
//

#import "DYTextField.h"

@implementation DYTextField


- (id)initWithCoder:(NSCoder *)aDecoder{
  self =   [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
- (void)awakeFromNib
{
    
}
- (id)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}


- (void)textFieldChange{
    if ( self.maxCharaterNumber > 0) {
        if (self.text.length > self.maxCharaterNumber) {
            self.text = [self.text substringToIndex:self.maxCharaterNumber];
        }
        return;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (self.passwordText) {
        if (action == @selector(paste:))//禁止粘贴
            return NO;
        if (action == @selector(select:))// 禁止选择
            return NO;
        if (action == @selector(selectAll:))// 禁止全选
            return NO;
        if (action == @selector(copy:))// 禁止复制
            return NO;
        if (action == @selector(cut:))// 禁止剪切
            return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
    
    return [super canPerformAction:action withSender:sender];
}
@end
