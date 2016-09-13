//
//  MOALoginViewController.h
//  moa
//
//  Created by yun.shu on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USER_NAME_KEY       @"userNameKey"
#define LOGIN_SUCCESS_NOTIFY_KEY   @"loginSuccessNotifyKey"

extern NSString *visitLoginName;

@interface MOALoginViewController : UIViewController<UITextFieldDelegate>

@end
