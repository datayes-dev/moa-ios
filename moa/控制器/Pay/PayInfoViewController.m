//
//  PayViewController.m
//  moa
//
//  Created by liangkai.zheng on 16/9/12.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "PayInfoViewController.h"
#import "DYAppearance.h"
#import "MOATradeInfoAdapter.h"
#import "PaySuccessViewController.h"
#import "DYAuthTokenManager.h"
#import "DYLoadingViewManager.h"
#import "Toast+UIView.h"

@interface PayInfoViewController()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *restName;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (strong, nonatomic) MOATradeInfoAdapter *adapter;

/**
 *	@brief	存放cell的信息的数组（可变数组）
 */
@property (nonatomic, strong)NSMutableArray* cellDataArray;

/**
 *	@brief	存放饭店列表的数组
 */
@property (nonatomic, strong)NSArray* hotelsArray;

@property (nonatomic, strong) NSDictionary *currentHotel;

@end

@implementation PayInfoViewController

#pragma mark - Property Init
- (MOATradeInfoAdapter *)adapter
{
    
    if (_adapter == nil) {
        
        _adapter = [MOATradeInfoAdapter shareInstance];
    }
    return _adapter;
}

#pragma mark - View life Cycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self getCurrentHotelInfo];
}

#pragma mark - init
- (void)initUI
{
    
    self.payBtn.layer.cornerRadius = 4;
    self.userName.text = [DYAuthTokenManager shareInstance].userName;
    self.sumTextField.layer.borderColor = [DYAppearance colorWithRGB:0xF8721B].CGColor;
    self.sumTextField.delegate = self;
    [self.sumTextField setKeyboardType:UIKeyboardTypeNumberPad];
}


#pragma mark - Method
- (void)getCurrentHotelInfo
{
    
    WS(weakSelf);
    
    self.currentHotel = nil;
    
    showLoadingAtWindow;
    
    [self.adapter getHotelInfoWith:self.hotelQRCode withBlock:^(id data, NSError *error) {
        
        dismisLoadingFromWindow;
        
        weakSelf.currentHotel = (NSDictionary *)data;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString* hotelName = weakSelf.currentHotel[@"name"];
            
            if ([hotelName length] > 0) {
                
                weakSelf.restName.text = hotelName;
                
            } else {
                
                weakSelf.restName.text = @"未知商家";
            }
            
        });
    }];
}

- (IBAction)payBtnClicked:(UIButton *)sender
{
    
    sender.enabled = NO;
    [self.sumTextField resignFirstResponder];
    
    NSString *price = self.sumTextField.text;
    NSString *hotelId = (NSString *)self.currentHotel[@"id"];
    
    WS(weakSelf);
    
    showLoadingAtWindow;
    
    [self.adapter makeDealWithPrice:price inHotel:hotelId andMemoInfo:nil andResultBlock:^(id data, NSError *error) {
        
        dismisLoadingFromWindow;
        
        sender.enabled = YES;
        
        if (error) {
            
            sender.enabled = NO;
            
            if (error.code == -1011) {
                
                [self.view makeToast:@"支付失败，您今天的额度或次数已超过限制" duration:2 position:@"center"];
                
            } else {
                
                [self.view makeToast:@"支付失败，请稍后再试" duration:2 position:@"center"];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self leftButtonClick:nil];
            });
            
            return;
            
        }
        
        DYCellDataItem *item = [DYCellDataItem new];
        item.hotelName = self.restName.text;
        item.price = price;
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        item.timeStamp = [dateFormatter stringFromDate:date];
        [weakSelf.adapter saveLastTradeInfo:item];
        
        PaySuccessViewController *vc = [[PaySuccessViewController alloc] initWithNibName:@"PaySuccessViewController" bundle:[NSBundle mainBundle]];

        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
