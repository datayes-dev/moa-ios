//
//  AlertView
//  moa
//
//  Created by yun.shu on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlertViewDelegate <NSObject>
#pragma mark 提示框回掉
@optional
- (void) dismiss;
- (void) popToRootVC;
@end
@interface AlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipTitle;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *ok;//确定
- (IBAction)okBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *tipDescLabel;
@property (nonatomic, weak)  id <AlertViewDelegate> delegate;


@end

