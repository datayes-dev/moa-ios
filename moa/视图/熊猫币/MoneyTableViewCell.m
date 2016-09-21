//
//  MoneyTableViewCell.m
//  moa
//
//  Created by 鄢彭超 on 16/9/21.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MoneyTableViewCell.h"
#import "SDAutoLayout.h"

@implementation MoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    self.mainLabel = titleLabel;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:contentLabel];
    self.subLabel = contentLabel;
    
    CGFloat margin = 10;
    
    titleLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .heightIs(20);
    
    contentLabel.sd_layout
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .topSpaceToView(titleLabel, margin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:contentLabel bottomMargin:margin];
}

@end
