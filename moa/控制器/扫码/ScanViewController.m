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

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
/**
 *	@brief	连接摄像头
 */
@property (strong, nonatomic) AVCaptureSession *session;

/**
 *	@brief	显示需要扫的二维码信息
 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *layer;

@end

@implementation ScanViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
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
        
        // 停止扫描
        [self.session stopRunning];
        
        // 将预览图层移除
        [self.layer removeFromSuperlayer];
        
        PayInfoViewController *vc = [[PayInfoViewController alloc] initWithNibName:@"PayInfoViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        NSLog(@"没有扫描到数据");
    }
}
@end
