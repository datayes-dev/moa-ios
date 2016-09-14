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
    
    WS(weakSelf);
    [self.adapter getHotelInfoWith:self.hotelQRCode withBlock:^(id data, NSError *error) {
        
        NSDictionary *hotelInfo = (NSDictionary *)data;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString* hotelName = hotelInfo[@"name"];
            
            weakSelf.restName.text = hotelName;
        });
    }];
}

#pragma mark - init
- (void)initUI
{
    
    self.payBtn.layer.cornerRadius = 4;
    
    self.sumTextField.layer.borderColor = [DYAppearance colorWithRGB:0xF8721B].CGColor;
    self.sumTextField.delegate = self;
    [self.sumTextField setKeyboardType:UIKeyboardTypeNumberPad];
}


#pragma mark - Method
- (IBAction)payBtnClicked:(UIButton *)sender
{
    
    
}

@end
