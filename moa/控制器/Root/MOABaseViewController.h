//
//  MOABaseViewController.h
//  moa
//
//  Created by liangkai.zheng on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYAppearance.h"

@interface MOABaseViewController : UIViewController

- (UIButton *)addLeftButtonWithImage:(UIImage *)image hightLightImage:(UIImage *)hightImage caption:(NSString *)caption;

- (UIButton *)addRightButtonWithImage:(UIImage *)image caption:(NSString *)caption action:(SEL)action;

- (void)removeLeftButton;

- (void)removeRightButton;

@end
