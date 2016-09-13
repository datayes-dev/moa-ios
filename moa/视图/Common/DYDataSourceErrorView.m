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
//  DYDataSourceErrorView.m
//  IntelligenceResearchReport
//
//  Created by yun.shu on 16/5/12.
//

#import "DYDataSourceErrorView.h"
#import "Masonry.h"
#import "DYProgressHUD.h"
#import "DYDefine.h"
#import "DYAppearance.h"

@interface DYDataSourceErrorView()

@property(nonatomic,strong) UIWindow *myWindow;
@property(nonatomic,strong) UIImageView *guardImg;
@property(nonatomic,strong) UILabel *guardLabel;
@property(nonatomic,strong) UIButton *reloadBtn;

@end

@implementation DYDataSourceErrorView

+ (instancetype)shareInstance {
    static DYDataSourceErrorView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DYDataSourceErrorView alloc]initWithFrame:CGRectMake(0, 64, DYScreenWidth, DYScreenHeight)];
        instance.backgroundColor = [UIColor whiteColor];
    });
    
    return instance;
}

// 新建window，将运维模式的界面显示在新建的window上
- (void)showMyDatasourceErrorViewWithBlock:(BackSuccessBlock) backSuccessBlock {
    
    self->backBlock = backSuccessBlock;
    
    if (self.myWindow != nil) {
        self.myWindow.hidden = NO;
        return;
    }
    
    self.myWindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    self.myWindow.backgroundColor = [UIColor clearColor];
    
    [self setupUI];
    [self.myWindow addSubview:[DYDataSourceErrorView shareInstance]];
    [self.myWindow makeKeyAndVisible];
    
    [DYProgressHUD hideWaiting];
}

// 设置运维模式的 UI 界面
-(void)setupUI {
    
    // 维护图片
    UIImageView *guardImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"maintain"]];
    self.guardImg = guardImg;
    [self addSubview:self.guardImg];
    
    [self.guardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-120);
        make.centerX.equalTo(self);
    }];
    [self.guardImg sizeToFit];
    
    // 维护文字
    UILabel *guardLabel = [[UILabel alloc]init];
    guardLabel.text = @"维护中...请稍后尝试";
    guardLabel.textAlignment = NSTextAlignmentCenter;
    self.guardLabel = guardLabel;
    [self addSubview:self.guardLabel];
    
    [self.guardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guardImg.mas_bottom).offset(13);
        make.left.equalTo(self.guardImg);
        make.right.equalTo(self.guardImg);
    }];
    
    // 刷新按钮
    UIButton *reloadBtn = [[UIButton alloc]init];
    [reloadBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reloadBtn.backgroundColor = DYAppearanceColor(@"B1", 1.0);
    self.reloadBtn = reloadBtn;
    [self addSubview:self.reloadBtn];
    
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guardLabel.mas_bottom).offset(13);
        make.centerX.equalTo(self.guardLabel.mas_centerX);
        make.width.equalTo(@106);
        make.height.equalTo(@32);
    }];
    
    [self.reloadBtn addTarget:self action:@selector(didClickReloadDataBtn) forControlEvents:UIControlEventTouchUpInside];
}

// 刷新按钮点击事件
-(void)didClickReloadDataBtn {
    
    self.myWindow.hidden = YES;
    
    self->backBlock(10);
}

@end
