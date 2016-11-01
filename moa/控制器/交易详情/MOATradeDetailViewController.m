//
//  MOATradeDetailViewController.m
//  moa
//
//  Created by liangkai.zheng on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MOATradeDetailViewController.h"
#import "MOATradeInfoAdapter.h"
#import "MOATradeDetailTableViewCell.h"
#import "DYLoadingViewManager.h"

@interface MOATradeDetailViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MOATradeInfoAdapter *adapter;
@property (strong, nonatomic) NSArray *infoArray;
@end

@implementation MOATradeDetailViewController

- (MOATradeInfoAdapter *)adapter
{
    
    if (_adapter == nil) {
        
        _adapter = [MOATradeInfoAdapter shareInstance];
    }
    return _adapter;
}

- (NSArray *)infoArray
{
    
    if (_infoArray == nil) {
        
        _infoArray = [NSArray array];
    }
    return _infoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消费记录";
    [self addLeftButtonWithImage:[UIImage imageNamed:@"back"] hightLightImage:nil caption:nil];
    
    UINib *nib = [UINib nibWithNibName:@"MOATradeDetailTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MOATradeDetailTableViewCell"];
    
//    WS(weakSelf);
    
//    showLoadingAtWindow;
    
//    [self.adapter getTradeListInfoWithResultBlock:^(id data, NSError *error) {
//        
//        dismisLoadingFromWindow;
//        
//        if (error) {
//            return ;
//        }
//        
//        weakSelf.infoArray = (NSArray *)data;
//        
//        [weakSelf.tableView reloadData];
//    }];
    
    [self.adapter getTradeListInfoWithBeginDate:@"2016-11-01 00:00:00"
                                        endDate:@"2016-11-01 23:59:59"
                                          admin:@"zsddft@datayes.com"
                                    ResultBlock:^(id data, NSError *error) {
                                        //
                                    }];

    
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.infoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MOATradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOATradeDetailTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger count = [self.infoArray count];
    if (indexPath.row < count) {
        
        DYCellDataItem *item = self.infoArray[count - indexPath.row - 1];
        
        cell.hotelName.text = item.hotelName;
        cell.tradeDate.text = item.timeStamp;
        cell.cash.text = item.price;
    }
    
    return cell;
}

@end
