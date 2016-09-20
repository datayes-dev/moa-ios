//
//  MoneyViewController.m
//  moa
//
//  Created by 鄢彭超 on 16/9/20.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MoneyViewController.h"
#import "DYMoneyDataSource.h"

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
    
    self.cellDataArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"defaultTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultTableViewCell"];
    }
    
    if ([self.cellDataArray count] > indexPath.row) {
        DYMoneyCellDataItem* item = self.cellDataArray[indexPath.row];
        [cell.textLabel setText:item.titleText];
        [cell.detailTextLabel setText:item.detailText];
    }
    
    return cell;
}

#pragma mark - request functions

- (void)getWalletInfo
{
    [[DYMoneyDataSource shareInstance] getWalletInfoWithResultBlock:^(id data, NSError *error) {
        if (error == nil && data != nil && [data isKindOfClass:[NSDictionary class]]) {
            NSString* code = data[@"code"];
            if ([code intValue] == 404) {
                [self createNewWallet];
            }
            else {
                [self getWalletDetailInfo];
            }
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
            item.titleText = username;
            item.detailText = [NSString stringWithFormat:@"%@(%@)", secret, address];
            
            [self.cellDataArray addObject:item];
            [self.tableView reloadData];
            
            [self getWalletDetailInfo];
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
            item.titleText = [NSString stringWithFormat:@"%@:%@", @"PANDA", PANDA];
            item.detailText = [NSString stringWithFormat:@"%@:%@", @"ETHER", ETHER];
            
            [self.cellDataArray addObject:item];
            [self.tableView reloadData];
            
            [self getWalletPaymentsInfo];
        }
    }];
}

- (void)getWalletPaymentsInfo
{
    [[DYMoneyDataSource shareInstance] getWalletPaymentsInfoWithResultBlock:^(id data, NSError *error) {
        if (error == nil && data != nil && [data isKindOfClass:[NSArray class]]) {
            NSArray* array = data;
            
            for (NSDictionary* dic in array) {
                NSString* currency = dic[@"currency"];
                NSString* amount = dic[@"amount"];
                NSString* block = dic[@"block"];
                
                DYMoneyCellDataItem* item = [DYMoneyCellDataItem new];
                item.titleText = [NSString stringWithFormat:@"%@:(%@)", amount, currency];
                item.detailText = [NSString stringWithFormat:@"in block %@", block];
                
                [self.cellDataArray addObject:item];
            }
            
            [self.tableView reloadData];
        }
    }];
}

@end
