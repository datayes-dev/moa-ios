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
#import "RootViewController.h"
#import "MOALoginViewController.h"
//#import "DYUserInfoHeadView.h"
//#import "DYLoginUserInfo.h"
#import "DYGetUserInfoDataSource.h"
#import "DYAuthTokenManager.h"
#import "UIButton+AFNetworking.h"
//#import "DYChangePasswordViewController.h"
#import "DYTools+AppInfo.h"
#import "DYAuthorityDataSource.h"
#import "DYAuthorityResponseHelper.h"
#import "DYAuthorityManager.h"
//#import "DYLoginViewController.h"
//#import "DYAuthorizationStatus.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "DYAppearance.h"
#import "DYDefine.h"
#import "DYProgressHUD.h"
#import "ScanViewController.h"
#import "MOATradeDetailViewController.h"

#pragma mark - 退出账号相关
//#import "DYDataSyncHelper.h"
//#import "DYNoteInfoDataDBSync.h"
#import "DYAppNotification.h"
//#import "DYFavoriteStocksDataSource.h"
//#import "DYSearchViewDataSource.h"
//#import "DYStudyDetailDataSource.h"
#import "DYAppConfigManager.h"
//#import "InfoSubsciptionAdapter.h"
//#import "DYCompanyDataSync.h"

#define kRowHeight 44

@interface MyCenterRootViewController ()<UIActionSheetDelegate, UIGestureRecognizerDelegate>
{
    UIImage *_userHeadInfoImage;
}
@property (nonatomic, strong) UIImagePickerController *pickerController;

//@property (nonatomic, strong) DYUserInfoHeadView *userInfoView;
@property (nonatomic, strong) NSArray *mineFunctionsArray;
@property (nonatomic, strong) NSArray *settingArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, assign) BOOL isShowCell;

@end

@implementation MyCenterRootViewController

#pragma mark - View's Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = DYAppearanceColor(@"H1", 1.0);
    self.title = @"我的";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self addConcernedOption];
    [self fetchUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - notification
- (void)notifyCellRefresh:(NSNotification *)notify
{
    [self.tableView reloadData];
}


#pragma mark - private method
- (void)addConcernedOption
{
    _mineFunctionsArray = @[@"用餐刷卡"];
}

- (void)fetchUserInfo
{
    __weak __typeof(self)weakself = self;
    if ([DYAuthTokenManager shareInstance].isLogined) {
        if ([DYAuthTokenManager shareInstance].isAccessTokenValid) {
            [[DYGetUserInfoDataSource shareInstance] requestUserInfoResultBlock:^(id data, NSError *error) {
                DDLogDebug(@"UserInfo:%@", data);
                if (error == nil && data != nil) {
//                    [DYLoginUserInfo shareInstance].userIdentityInfo = data;
//                    [[DYLoginUserInfo shareInstance] parseFromDictionary];
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

#pragma mark - FooterView
- (BOOL)isLogin
{
    return [DYAuthTokenManager shareInstance].isLogined;
}

#pragma mark - actions

/*
- (void)setUserPortraitAction
{
    if ([DYAuthTokenManager shareInstance].isLogined)
    {
        if (IOS8_OR_LATER) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            WS(weakSelf);
            [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  if (![DYAuthorizationStatus checkCameraAuthorization]) {
                                                                      return;
                                                                  }
                                                                  weakSelf.pickerController.allowsEditing = YES;
                                                                  weakSelf.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                  [weakSelf presentViewController:weakSelf.pickerController animated:YES completion:nil];
                                                              }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"从手机相册选择"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  if (![DYAuthorizationStatus checkPhotoAuthorization]) {
                                                                      return;
                                                                  }
                                                                  
                                                                  weakSelf.pickerController.allowsEditing = YES;
                                                                  weakSelf.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                  [weakSelf presentViewController:weakSelf.pickerController animated:YES completion:nil];
                                                              }]];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
                [cancelAction setValue:DYAppearanceColor(@"H9", 1.0) forKey:@"_titleTextColor"];
            }
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
            [sheet showInView:self.view];
        
        }
    }
}
 */


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerController.allowsEditing = YES;
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
    else if (buttonIndex ==1) {
        _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickerController.allowsEditing = YES;
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return self.mineFunctionsArray.count;
            break;
            
        case 2:
        case 3:
            return 1;
            
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
//    DYBorderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[DYBorderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
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

    switch (indexPath.section) {
        case 0:
        case 1:
            cell.textLabel.text = self.mineFunctionsArray[indexPath.row];
            break;
            
        case 2:{
            cell.textLabel.text = @"消费记录";
            break;
        }
            
        case 3:{
            cell.textLabel.text = @"退出登录";
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        case 1:{
            ScanViewController *vc = [[ScanViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            MOATradeDetailViewController *vc = [[MOATradeDetailViewController alloc] initWithNibName:@"MOATradeDetailViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 3:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MOALoginViewController" bundle:[NSBundle mainBundle]];
            MOALoginViewController *loginVC = (MOALoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MOALoginViewController"];
            [self.navigationController pushViewController:loginVC animated:YES];
            break;
        }
        
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        return 10;
    }else {
        return section == 1 ? 70: 10;
    }
}

/*
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        DYUserInfoHeadView* userInfoView = nil;
        if (self.userInfoView == nil) {
            userInfoView = [DYUserInfoHeadView createUserInfoView];
            self.userInfoView = userInfoView;
        }
        else
        {
            userInfoView = self.userInfoView;
        }
        [userInfoView.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        
        if ([DYAuthTokenManager shareInstance].isLogined) {
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
            
            // 移除之前的事件
            [userInfoView.userPortraitButton removeTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            [userInfoView.userPortraitButton addTarget:self action:@selector(setUserPortraitAction) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [userInfoView.userPortraitButton setImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
            [self.userInfoView.loadingIndicatorView stopAnimating];
            
            // 未登录状态点击头像进入登录页面
            [userInfoView.userPortraitButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if ([DYAuthTokenManager shareInstance].isLogined) {
            if ([[DYLoginUserInfo shareInstance].userName length] > 0) {
                [userInfoView.userNameLabel setText:[DYLoginUserInfo shareInstance].userName];
            }
            else {
                [userInfoView.userNameLabel setText:DYInterStr(@"MineVC_18",@"正在登录...")];
            }
            [userInfoView hasLogined:YES];
        }
        else
        {
            [userInfoView hasLogined:NO];
        }
        
        return userInfoView;
    } else {
        return [[UIView alloc]init];
    }
    
}
 */


#pragma mark --UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (![type isEqualToString:@"public.image"]) {
        return;
    }
    NSData *imageData = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        _userHeadInfoImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString *extension = [[info objectForKey:UIImagePickerControllerReferenceURL] pathExtension];
        if ([extension isEqualToString:@"JPG"]) {
            imageData = UIImageJPEGRepresentation(_userHeadInfoImage, 1.0);
        } else {
            imageData = UIImagePNGRepresentation(_userHeadInfoImage);
        }
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _userHeadInfoImage = [info objectForKey:UIImagePickerControllerEditedImage];
        imageData = UIImagePNGRepresentation(_userHeadInfoImage);
    }
//    [SandyBoxManager addPublicObject:imageData key:kUserInfoHeadImageKey];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadAvatar:imageData];
}

//上传头像
- (void)uploadAvatar:(NSData*)avatarData
{
    //压缩照片
    UIImage* tempShowImg=[UIImage imageWithData:avatarData];
    UIGraphicsBeginImageContext(CGSizeMake(200, 200*tempShowImg.size.height/tempShowImg.size.width));
    [tempShowImg drawInRect:CGRectMake(0, 0, 200, 200*tempShowImg.size.height/tempShowImg.size.width)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    avatarData=UIImageJPEGRepresentation(scaledImage,0.8);
    
    if ([avatarData length] > 0) {
        [DYProgressHUD showWaitingIndicatorInView:self.view withHideDelayTime:30];
        __weak __typeof(self)weakSelf = self;
        NSString *encodedAvata  = [avatarData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        [[DYAuthorityDataSource shareInstance] requestAddBase64Picture:encodedAvata resultBlock:^(id data, NSError *error) {
            [DYProgressHUD hideWaiting];
            if(error) {
                [DYProgressHUD showToastInView:weakSelf.view message:@"头像设置未成功" position:@"bottom"];
            } else {
                [DYProgressHUD showToastInView:weakSelf.view message:@"头像设置成功" position:@"bottom"];
            }
            
//            [DYLoginUserInfo shareInstance].avatar = data[@"data"];
            [weakSelf.tableView reloadData];
        }];
    }
}



@end
