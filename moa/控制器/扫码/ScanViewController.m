//
//  ScanViewController.m
//  moa
//
//  Created by liangkai.zheng on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "ScanViewController.h"
#import "PayInfoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DYAppearance.h"
#import "DYLoadingViewManager.h"
#import "MOATradeInfoAdapter.h"
#import "Toast+UIView.h"
#import "MOATradeDetailViewController.h"

typedef NS_ENUM(NSInteger, EAlertViewType) {
    eAlertViewTradecheck = 1,           // 交易确认
    eAlertViewTradeFailed,              // 交易失败
    eAlertViewTradeSuccess,             // 交易成功
};

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
/**
 *	@brief	连接摄像头
 */
@property (strong, nonatomic) AVCaptureSession *session;

/**
 *	@brief	显示需要扫的二维码信息
 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *layer;

@property (strong, nonatomic) MOATradeInfoAdapter *adapter;

@property (strong, nonatomic) NSString* qrCodeString;

@end

@implementation ScanViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用餐刷卡";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self beginScanQR];
}

#pragma mark - Method
- (void)beginScanQR
{
    // 1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    // 2.添加输入设备(数据从摄像头输入)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    // 3.添加输出数据(示例对象-->类对象-->元类对象-->根元类对象)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    // 3.1.设置输入元数据的类型(类型是二维码数据)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 4.添加扫描图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    // 5.开始扫描
    [session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate functions
// 当扫描到数据时就会执行该方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        //获得扫描数据，最后一个时最新扫描的数据
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        
        NSLog(@"扫描二维码的结果：%@", object.stringValue);
        
        self.qrCodeString = object.stringValue;
        [self stopScanQR];
        [self checkForTrade];
//        PayInfoViewController *vc = [[PayInfoViewController alloc] initWithNibName:@"PayInfoViewController" bundle:[NSBundle mainBundle]];
//        
//        vc.hotelQRCode = object.stringValue;
//        
//        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        NSLog(@"没有扫描到数据");
    }
}

- (void)stopScanQR
{
    // 停止扫描
    [self.session stopRunning];
    
    // 将预览图层移除
    [self.layer removeFromSuperlayer];
}

- (MOATradeInfoAdapter *)adapter
{
    
    if (_adapter == nil) {
        
        _adapter = [MOATradeInfoAdapter shareInstance];
    }
    return _adapter;
}

- (void)delayBack
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)delayNavToTradeListVC
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray* vcArray = [self.navigationController viewControllers].mutableCopy;
        [vcArray removeLastObject];
        
        MOATradeDetailViewController* vc = [[MOATradeDetailViewController alloc] init];
        [vcArray addObject:vc];
        [self.navigationController setViewControllers:vcArray animated:YES];
    });
}

- (void)payWithCode:(NSString*)qrCode
{
    WS(weakSelf);
    
    showLoadingAtWindow;
    
    [self.adapter addTransWithRestaurant:@"888cf414-a270-11e6-b99a-02730bb67404RES_" QRString:qrCode ResultBlock:^(id data, NSError *error) {
        dismisLoadingFromWindow;
        
        if (error == nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", dic);
            if ([dic[@"message"] isEqualToString:@"Quota error"]) {
//                [weakSelf.view makeToast:@"配额用完了" duration:2 position:@"center"];
//                [weakSelf delayBack];
                [weakSelf showFailed:@"配额用完了"];
            }
            else if ([dic[@"message"] isEqualToString:@"Qrcode error"]) {
//                [weakSelf.view makeToast:@"二维码不正确" duration:2 position:@"center"];
//                [weakSelf delayBack];
                [weakSelf showFailed:@"二维码不正确"];
            }
            else if ([dic[@"result"] isEqualToString:@"success"]){
//                [weakSelf.view makeToast:@"交易成功" duration:2 position:@"center"];
                [weakSelf showSuccess];
            }
            else {
                [weakSelf.view makeToast:@"未知错误，请稍后重试" duration:3 position:@"center"];
                [weakSelf delayBack];
            }
        }
        else {
            [weakSelf delayBack];
        }
    }];
}

- (void)checkForTrade {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认交易？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = eAlertViewTradecheck;
    [alert show];
}

- (void)showFailed:(NSString *)failString
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:failString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = eAlertViewTradeFailed;
    [alert show];
}

- (void)showSuccess
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"交易成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"查看交易", nil];
    alert.tag = eAlertViewTradeSuccess;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == eAlertViewTradecheck) {
        if (buttonIndex == 1) { // 确认交易
            [self payWithCode:self.qrCodeString];
        }
        else {
            [self beginScanQR];
        }
    }
    else if (alertView.tag == eAlertViewTradeFailed) {
        [self beginScanQR];
    }
    else if (alertView.tag == eAlertViewTradeSuccess) {
        if (buttonIndex == 1) {
            MOATradeDetailViewController* vc = [[MOATradeDetailViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [self beginScanQR];
        }
    }
}
@end
