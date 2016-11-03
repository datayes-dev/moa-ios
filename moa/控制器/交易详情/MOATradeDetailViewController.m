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
#import "DYDefine.h"

@interface MOATradeDetailViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MOATradeInfoAdapter *adapter;
@property (strong, nonatomic) NSArray *infoArray;
@property (nonatomic)NSUInteger infoCount;
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
    
    WS(weakSelf);
    
    showLoadingAtWindow;
    
    NSString* dateString = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString* beginDateTime = [NSString stringWithFormat:@"%@ 00:00:00", dateString];
    NSString* endDateTime = [NSString stringWithFormat:@"%@ 23:59:59", dateString];
    
    [self.adapter getLatestTradeListInfoWithBeginDate:beginDateTime endDate:endDateTime ResultBlock:^(id data, NSError *error) {
        dismisLoadingFromWindow;
        
        if (error) {
            return ;
        }
        
        NSArray* array = data[@"data"];
        NSMutableArray* mArray = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSDictionary* dic in array) {
            NSString* time_stamp = dic[@"time_stamp"];
            NSString* user = dic[@"id"];
            
            DingTradeInfoItem* item = [[DingTradeInfoItem alloc] init];
            item.time_stamp = time_stamp;
            item.user = user;
            
            [mArray addObject:item];
        }
        
        weakSelf.infoCount = [data[@"count"] integerValue];
        weakSelf.infoArray = mArray;
        [weakSelf.tableView reloadData];
    }];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
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
        
        DingTradeInfoItem *item = self.infoArray[count - indexPath.row - 1];
        
        cell.hotelName.text = item.user;
        cell.tradeDate.text = item.time_stamp;
        cell.cash.text = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DYScreenWidth, 22)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"今天一共有%lu笔交易，以下为最新%lu条", (unsigned long)self.infoCount, (unsigned long)self.infoArray.count];
    
    return label;
}

@end
