//
//  MOATradeDetailTableViewCell.h
//  moa
//
//  Created by liangkai.zheng on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOATradeDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *tradeDate;
@property (weak, nonatomic) IBOutlet UILabel *cash;

+ (NSString *)identifier;

@end
