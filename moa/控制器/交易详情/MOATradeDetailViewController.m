//
//  MOATradeDetailViewController.m
//  moa
//
//  Created by liangkai.zheng on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MOATradeDetailViewController.h"
#import "MOATradeInfoAdapter.h"

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
    // Do any additional setup after loading the view from its nib.
    
    WS(weakSelf);
    
    [self.adapter getTradeListInfoWithResultBlock:^(id data, NSError *error) {
        
        weakSelf.infoArray = (NSArray *)data;
        
        [weakSelf.tableView reloadData];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeListInfo"];
    
    
    if (indexPath.row < [self.infoArray count]) {
        
        DYCellDataItem *item = self.infoArray[indexPath.row];
        
        cell.textLabel.text = item.detailText;
    }
    
    return cell;
}

@end
