//
//  PaySuccessViewController.h
//  moa
//
//  Created by datayes on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOAViewController.h"

@interface PaySuccessViewController : MOAViewController

@property (nonatomic,weak)IBOutlet UIImageView *successImg;
@property (nonatomic,weak)IBOutlet UILabel *successLab;
@property (nonatomic,weak)IBOutlet UILabel *restaurantNameLab;
@property (nonatomic,weak)IBOutlet UILabel *priceLab;
@property (nonatomic,weak)IBOutlet UILabel *timeLab;
@property (nonatomic,weak)IBOutlet UIButton *okBtn;
@property (nonatomic,weak)IBOutlet UIButton *historyListBtn;


@end
