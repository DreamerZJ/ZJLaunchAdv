//
//  AppDelegate.m
//  ZJLaunchAdv
//
//  Created by zhangjian on 2018/1/3.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "AppDelegate.h"
#import "ZJLaunchAdv.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    ZJLaunchAdv *adview = [ZJLaunchAdv zjLaunchImageView:^(ZJAdConfiguration *configuration) {
        
        configuration.adImageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514888829314&di=4588cc130055455689d5312922f59704&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fexp%2Fw%3D500%2Fsign%3D347c8932f2246b607b0eb274dbf91a35%2Fac345982b2b7d0a28681d3fccfef76094b369a03.jpg";
        configuration.adtype = ZJAdTypeLogo;
        configuration.skipBtnType = ZJSkipButtonTypeOvalTimeAndText;
        configuration.duration = 4;
        configuration.animationCircleColor = [UIColor greenColor];
        
    } action:^{
        NSLog(@"点击了跳过按钮！");
    } completion:^(BOOL finished) {
        NSLog(@"启动广告消失!");
    }];
    [self.window addSubview:adview];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
