//
//  AppDelegate.m
//  moa
//
//  Created by 鄢彭超 on 16/9/12.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "AppDelegate.h"
#import "MOANavigationViewController.h"
#import "RootViewController.h"
#import "DYLogFormatter.h"
#import "MOALoginViewController.h"
#import "DYAuthTokenManager.h"
#import "MyCenterRootViewController.h"

const DDLogLevel ddLogLevel = DDLogLevelAll;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupDDLog];
    UIViewController* rootVC = nil;
    if ([DYAuthTokenManager shareInstance].isLogined) {
        rootVC = [[MyCenterRootViewController alloc]init];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MOALoginViewController" bundle:[NSBundle mainBundle]];
        rootVC = (MOALoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MOALoginViewController"];
    }
    
    MOANavigationViewController *navigation = [[MOANavigationViewController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = navigation;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [navigation moaNavBarStyle];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - local functions

- (void)setupDDLog
{
    
    //log formatter
    DYLogFormatter *formatter = [[DYLogFormatter alloc] init];
    
    //输出到console
    [DDTTYLogger sharedInstance].logFormatter = formatter;
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Initialize File Logger
    _fileLogger = [[DDFileLogger alloc] init];
    _fileLogger.logFormatter = formatter;
    
    // Configure File Logger
    [_fileLogger setMaximumFileSize:(1024 * 1024)];
    [_fileLogger setRollingFrequency:(3600.0 * 24.0)];
    [[_fileLogger logFileManager] setMaximumNumberOfLogFiles:1];
    [DDLog addLogger:_fileLogger];
    
}

- (NSString *)getFileLoggerPath
{
    return [[_fileLogger currentLogFileInfo] filePath];
}

@end
