//
//  PaySuccessViewController.m
//  moa
//
//  Created by datayes on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "MOATradeDetailViewController.h"
#import "MOATradeInfoAdapter.h"

@interface PaySuccessViewController ()
@property (strong, nonatomic) MOATradeInfoAdapter *adapter;

@end

@implementation PaySuccessViewController

#pragma mark - Property Init
- (MOATradeInfoAdapter *)adapter
{
    
    if (_adapter == nil) {
        
        _adapter = [MOATradeInfoAdapter shareInstance];
    }
    
    return _adapter;
}

#pragma mark - View's Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    DYCellDataItem *item = [self.adapter getLastTradeInfo];
    
    self.priceLab.text = item.price;
    self.timeLab.text = item.timeStamp;
    self.restaurantNameLab.text = item.hotelName;
}

#pragma mark - Actions

-(IBAction)okBtnClicked:(id)sender
{
    
    [self leftButtonClick:nil];
}

-(IBAction)historyListBtnClicked:(id)sender
{
    
    MOATradeDetailViewController *vc = [[MOATradeDetailViewController alloc] initWithNibName:@"MOATradeDetailViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
