//
//  AppDelegate.h
//  moa
//
//  Created by 鄢彭超 on 16/9/12.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFileLogger.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)DDFileLogger *fileLogger;

@property  dispatch_queue_t queue ;
@property  dispatch_source_t _timer;
@property   __block int timeout; //倒计时时间
@end

