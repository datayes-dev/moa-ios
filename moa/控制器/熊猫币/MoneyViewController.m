//
//  MoneyViewController.m
//  moa
//
//  Created by 鄢彭超 on 16/9/20.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MoneyViewController.h"
#import "DYMoneyDataSource.h"
#import "MoneyTableViewCell.h"
#import "SDAutoLayout.h"

@interface DYMoneyCellDataItem : NSObject

@property (nonatomic, strong)NSString* titleText;
@property (nonatomic, strong)NSString* detailText;

@end

@implementation DYMoneyCellDataItem

@end

@interface MoneyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *	@brief	存放cell的信息的数组（可变数组）
 */
@property (nonatomic, strong)NSMutableArray* cellDataArray;

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"熊猫币";
    [self addLeftButtonWithImage:[UIImage imageNamed:@"back"] hightLightImage:nil caption:nil];
    self.cellDataArray = [NSMutableArray array];
    [self.tableView registerClass:[MoneyTableViewCell class] forCellReuseIdentifier:@"MoneyTableViewCell"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 98;
    
    [self getWalletInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDelegate functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

#pragma mark - UITableViewDataSource functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取cell高度
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyTableViewCell"];
    
    if ([self.cellDataArray count] > indexPath.row) {
        DYMoneyCellDataItem* item = self.cellDataArray[indexPath.row];
        [cell.mainLabel setText:item.titleText];
        [cell.subLabel setText:item.detailText];
        
        [cell setupAutoHeightWithBottomView:cell.subLabel bottomMargin:10];
    }
    
    return cell;
}

#pragma mark - request functions

- (void)getWalletInfo
{
    [[DYMoneyDataSource shareInstance] getWalletInfoWithResultBlock:^(id data, NSError *error) {
        if (error != nil && [error.localizedDescription containsString:@"(404)"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.5f* NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self createNewWallet];
            });
        }
        else {
            NSString* username = data[@"username"];
            NSString* address = data[@"address"];
            
            DYMoneyCellDataItem* item = [DYMoneyCellDataItem new];
            item.titleText = @"用户信息";
            item.detailText = [NSString stringWithFormat:@"username:%@\naddress:%@", username, address];
            
            [self.cellDataArray addObject:item];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.5f* NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getWalletDetailInfo];
            });
        }
    }];
}

- (void)createNewWallet
{
    [[DYMoneyDataSource shareInstance] createNewWalletWithResultBlock:^(id data, NSError *error) {
        if (error == nil && data != nil && [data isKindOfClass:[NSDictionary class]]) {
            NSString* username = data[@"username"];
            NSString* secret = data[@"secret"];
            NSString* address = data[@"address"];
            
            DYMoneyCellDataItem* item = [DYMoneyCellDataItem new];
            item.titleText = @"新建了钱包";
            item.detailText = [NSString stringWithFormat:@"username:%@\nsecret:%@\naddress:%@", username, secret, address];
            
            [self.cellDataArray addObject:item];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.5f* NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getWalletDetailInfo];
            });
        }
    }];
}

- (void)getWalletDetailInfo
{
    [[DYMoneyDataSource shareInstance] getWalletDetailInfoWithResultBlock:^(id data, NSError *error) {
        if (error == nil && data != nil && [data isKindOfClass:[NSDictionary class]]) {
            NSString* PANDA = data[@"PANDA"];
            NSString* ETHER = data[@"ETHER"];
            
            DYMoneyCellDataItem* item = [DYMoneyCellDataItem new];
            item.titleText = @"钱包详情";
            item.detailText = [NSString stringWithFormat:@"PANDA:%@\nETHER:%@", PANDA, ETHER];
            
            [self.cellDataArray addObject:item];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1.5f* NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getWalletPaymentsInfo];
            });
        }
    }];
}

- (void)getWalletPaymentsInfo
{
    [[DYMoneyDataSource shareInstance] getWalletPaymentsInfoWithResultBlock:^(id data, NSError *error) {
        if (error == nil && data != nil && [data isKindOfClass:[NSArray class]]) {
            NSArray* array = data;
            
            DYMoneyCellDataItem* item = [DYMoneyCellDataItem new];
            item.titleText =  @"分割线：以下是交易历史----------------------------";
            item.detailText = @"";
            [self.cellDataArray addObject:item];
            
            for (NSDictionary* dic in array) {
                NSString* currency = dic[@"currency"];
                NSString* amount = dic[@"amount"];
                NSString* block = dic[@"block"];
                
                NSString* hash = dic[@"hash"];
                NSString* source_account = dic[@"source_account"];
                NSString* destination_account = dic[@"destination_account"];
                NSString* issuer = dic[@"issuer"];
                
                DYMoneyCellDataItem* item = [DYMoneyCellDataItem new];
                item.titleText = [NSString stringWithFormat:@"amount:%@(currency:%@) block:%@", amount, currency, block];
                item.detailText = [NSString stringWithFormat:@"hash:%@\nsource_account:%@\ndestination_account:%@\nissuer:%@", hash, source_account, destination_account, issuer];
                
                [self.cellDataArray addObject:item];
            }
            
            [self.tableView reloadData];
        }
    }];
}

@end
