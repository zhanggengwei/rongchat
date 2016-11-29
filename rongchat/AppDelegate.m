//
//  AppDelegate.m
//  rongchat
//
//  Created by vd on 2016/11/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "AppDelegate.h"
#import "PPTabBarController.h"
#import "PPLoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIHGHT)];
    
    self.window.backgroundColor = [UIColor whiteColor];
    //self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loginStateChaned:) name:kPPObserverLoginSucess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loginStateChaned:) name:kPPObserverLogoutSucess object:nil];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:OBJC_APPIsLogin])
    {
       [PPTUserInfoEngine shareEngine];
        
       [self createTabbarController];
    }else
    {
        [[PPChatTools shareManager]deleteStoreItems];
        
        [self createLoginController];
    }
    [[PPChatTools shareManager]autoLogin];
    [[AMapServices sharedServices]setApiKey:KAppMapKey];
    [[PPLocationManager shareManager]requestLocation];
    NSLog(@"path = %@",NSHomeDirectory());
    
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable)
        {
            
            XIAlertView * alertView = [[XIAlertView alloc]initWithTitle:@"提示" message:@"网络似乎断开了连接" cancelButtonTitle:@"取消"];
            [alertView addButtonWithTitle:@"确定" style:XIAlertActionStyleDefault handler:^(XIAlertView *alertView, XIAlertButtonItem *buttonItem) {
                [alertView dismiss];
                if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
                {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    
                }
                
            }];
            [alertView show];
        }else if (status == AFNetworkReachabilityStatusUnknown)
        {
        }
    }];
    
    
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

#pragma mark

- (void)createTabbarController
{
    
    NSArray *  titleArray = @[@"微信",@"通讯录",@"发现",@"我的"];
    NSArray *  imageArray = @[@"tabbar_mainframe",@"tabbar_contacts",@"tabbar_discover",@"tabbar_me"];
    NSArray *  selImageArray = @[@"tabbar_mainframeHL",@"tabbar_contactsHL",@"tabbar_discoverHL",@"tabbar_meHL"];
    PPTabBarController * controller = [[PPTabBarController alloc]init:@[@"ViewController",@"PPContactListViewController",@"ViewController",@"PPMyViewController"] selectImageArr:selImageArray titleArr:titleArray normalImageArr:imageArray];
    [controller showPointMarkIndex:0];
    [controller showBadgeMark:100 index:1];
    self.window.rootViewController = controller;
    
}
- (void)createLoginController
{
    self.window.rootViewController = [PPLoginViewController new];
}

- (void)loginStateChaned:(NSNotification *)noti
{
    if([noti.name isEqualToString:kPPObserverLoginSucess])
    {
        [[NSUserDefaults standardUserDefaults]setObject:OBJC_APPIsLogin forKey:OBJC_APPIsLogin];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self createTabbarController];
    }else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:OBJC_APPIsLogin];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self createLoginController];
    }
}

@end
