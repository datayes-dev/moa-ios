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


@end

