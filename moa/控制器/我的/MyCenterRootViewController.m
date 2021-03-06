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
//  MyCenterRootViewController.m
//  IntelligenceResearchReport
//
//  Created by yun.shu on 16/7/19.
//

#import "MyCenterRootViewController.h"
#import "MOALoginViewController.h"
#import "DYUserInfoHeadView.h"
#import "DYLoginUserInfo.h"
#import "DYGetUserInfoDataSource.h"
#import "DYAuthTokenManager.h"
#import "UIButton+AFNetworking.h"
#import "DYAuthorityManager.h"
#import "DYAppearance.h"
#import "DYDefine.h"
#import "DYProgressHUD.h"
#import "DYAppConfigManager.h"

#import "ScanViewController.h"
#import "MOATradeDetailViewController.h"
#import "MoneyViewController.h"
#import "MyQRCodeViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "DYTools+AppInfo.h"
#import "MyTradeListViewController.h"
#import "DYTools+AppInfo.h"

#define kRowHeight 44

@interface MyCenterRootViewController ()

@property (nonatomic, strong) DYUserInfoHeadView *userInfoView;
@property (nonatomic, strong) NSArray *mineFunctionsArray;
@property (nonatomic, strong) NSArray *settingArray;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong)UIView* footerView;

@end

@implementation MyCenterRootViewController

#pragma mark - View's Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = DYAppearanceColor(@"H1", 1.0);
    self.title = [DYTools appDisplayName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.tableView setTableFooterView:self.footerView];
    [self addConcernedOption];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchUserInfo) name:kNotiAccessTokenAvailable object:nil];
    [self fetchUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiAccessTokenAvailable object:nil];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - private method
- (void)addConcernedOption
{
    _mineFunctionsArray = @[@{@"text":@"用餐刷卡", @"image":@"qrcode_2"},
                            @{@"text":@"消费记录", @"image":@"trade"},
                            @{@"text":@"熊猫币", @"image":@"money"},
                            @{@"text":@"我的二维码", @"image":@"qrcode"},
                            @{@"text":@"退出登录", @"image":@"logout2"}];
}

- (void)fetchUserInfo
{
    __weak __typeof(self)weakself = self;
    if ([DYAuthTokenManager shareInstance].isLogined) {
        if ([DYAuthTokenManager shareInstance].isAccessTokenValid) {
            [[DYGetUserInfoDataSource shareInstance] requestUserInfoResultBlock:^(id data, NSError *error) {
                DDLogDebug(@"UserInfo:%@", data);
                if (error == nil && data != nil) {
                    [DYLoginUserInfo shareInstance].userIdentityInfo = data;
                    [[DYLoginUserInfo shareInstance] parseFromDictionary];
                }
                [weakself.tableView reloadData];
            }];
        }
        else
        {
            [[DYAuthorityManager sharedInstance] refreshAccessTokenWithRefreshToken];
        }
        
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mineFunctionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
            return 1;
        case 2:
        case 3:
            return 0;
        case 4:
            return 1;
            
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = DYAppearanceColor(@"H13", 1.0);
    cell.textLabel.font = DYAppearanceFont(@"T4");
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next"]];
    arrow.frame = CGRectMake(0, 0, 7, 13);
    cell.accessoryView = arrow;
    
    // 设置cell的点击颜色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.contentView.frame];
    cell.selectedBackgroundView.backgroundColor = DYAppearanceColor(@"H1", 1.0);

    NSDictionary* dic = self.mineFunctionsArray[indexPath.section];
    cell.textLabel.text = dic[@"text"];
    cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            
            NSString * mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
                UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限，请去设置-->隐私-->相机，打开权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertC animated:YES completion:nil];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertC addAction:action];
                
            } else {
                
                ScanViewController *vc = [[ScanViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            break;
        }
        case 1:{
            MOATradeDetailViewController *vc = [[MOATradeDetailViewController alloc] initWithNibName:@"MOATradeDetailViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
//            MyTradeListViewController* tradeListVC = [[MyTradeListViewController alloc] init];
//            [self.navigationController pushViewController:tradeListVC animated:YES];
            break;
        }
            
        case 2: {
            MoneyViewController *vc = [[MoneyViewController alloc] initWithNibName:@"MoneyViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            MyQRCodeViewController *vc = [[MyQRCodeViewController alloc] initWithNibName:@"MyQRCodeViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:{
            [self logoutAccount];
            break;
        }
        
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 70: 10;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        DYUserInfoHeadView* userInfoView = nil;
        if (self.userInfoView == nil) {
            userInfoView = [DYUserInfoHeadView createUserInfoView];
            self.userInfoView = userInfoView;
        }
        else
        {
            userInfoView = self.userInfoView;
        }
        
        NSString* avatar = [DYLoginUserInfo shareInstance].avatar;
        if ([avatar isKindOfClass:[NSString class]] && [avatar length] > 0) {
            NSURL *avaterURL = [[DYLoginUserInfo shareInstance] avatarURL];
            [UIButton setSharedImageCache:[UIButton sharedImageCache]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:avaterURL];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            WS(weakSelf);
            [self.userInfoView.userPortraitButton setImageForState:UIControlStateNormal
                                                    withURLRequest:request
                                                  placeholderImage:nil
                                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [weakSelf.userInfoView.userPortraitButton setImage:image forState:UIControlStateNormal];
                                                                   [weakSelf.userInfoView.loadingIndicatorView stopAnimating];
                                                               });
                                                           } failure:^(NSError * _Nonnull error) {
                                                               [weakSelf.userInfoView.loadingIndicatorView stopAnimating];
                                                           }];
        }
        else {
            [userInfoView.userPortraitButton setImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
            
            // 如果没有用户昵称，代表这个数据还没有下发下来，如果昵称已经有了，代表数据已经有了，就不用转菊花了
            if ([[DYLoginUserInfo shareInstance].userName length] <= 0) {
                [self.userInfoView.loadingIndicatorView startAnimating];
            }
            else
            {
                [self.userInfoView.loadingIndicatorView stopAnimating];
            }
        }
        if ([[DYLoginUserInfo shareInstance].userName length] > 0) {
            [userInfoView.userNameLabel setText:[DYLoginUserInfo shareInstance].userName];
        }
        else {
            [userInfoView.userNameLabel setText:@"正在登录..."];
        }
        [userInfoView hasLogined:YES];
        return userInfoView;
    } else {
        return [[UIView alloc]init];
    }
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
        //[self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (UIView*)footerView
{
    if (_footerView == nil) {
        UILabel* labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 45)];
        [labelView setTextAlignment:NSTextAlignmentCenter];
        [labelView setTextColor:DYAppearanceColor(@"H3", 1.0)];
        [labelView setFont:DYAppearanceFont(@"T4")];
        [labelView setText:[NSString stringWithFormat:@"Version:%@.%@", [DYTools appVersion], [DYTools appBuildNumber]]];
        
        _footerView = labelView;
    }
    
    return _footerView;
}

@end
