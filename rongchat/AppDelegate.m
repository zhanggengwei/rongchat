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
#import "PPImageUtil.h"
#import "LCCKInputViewPluginTakePhoto.h"
#import "LCCKInputViewPluginLocation.h"
#import "LCCKInputViewPluginPickImage.h"
#import "RCIMLocationManager.h"
#import <PinyinFormatter.h>
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
                                            selector:@selector(loginStateChaned:) name:RCIMLogoutSucessedNotifaction object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loginStateChaned:) name:RCIMLoginSucessedNotifaction object:nil];
    [[RCIMClient sharedRCIMClient]initWithAppKey:@"n19jmcy59f1q9"];
    if([PPTUserInfoEngine shareEngine].userId)
    {
       [self createTabbarController];
        [[PPDateEngine manager]connectRCIM];
        
//        [[RCIMClient sharedRCIMClient]connectWithToken:[PPTUserInfoEngine shareEngine].token success:^(NSString *userId) {
//           
//        } error:^(RCConnectErrorCode status) {
//            NSLog(@"dd");
//        } tokenIncorrect:^{
//            NSLog(@"dd");
//        }];
    }else
    {
        [self createLoginController];
    }
    [[AMapServices sharedServices]setApiKey:KAppMapKey];
    [[PPLocationManager shareManager]requestLocation];
    [[RCIMLocationManager shareManager]requestReGeocodeLocation:^(AMapLocationReGeocode *response, NSError *error) {
        
    }];
    NSLog(@"path = %@",NSHomeDirectory());
//    
    [[UINavigationBar appearance]setBackgroundImage:[PPImageUtil imageFromColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTranslucent:NO];
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];//导航栏字体颜色
    [[UINavigationBar appearance]setTintColor:kPPTWhiteColor];
   
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
    
    
  RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"%@",input);
            [subscriber sendNext:@"message"];
            [subscriber sendError:[NSError errorWithDomain:@"error.domain" code:504 userInfo:nil]];
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    [[command execute:@"aa"]subscribeNext:^(id x) {
        NSLog(@"aa====%@",x);
        
    } error:^(NSError *error) {
        NSLog(@"aa====%@",error);
    } completed:^{
        NSLog(@"aa==%@",@"completed");
    }];
    [[[command execute:@"aa"] map:^id(NSString * value) {
        return @([value isEqualToString:@"aa"]);
    
    }]subscribeNext:^(id x) {
        NSLog(@"x====");
    }];
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
   // [self registerRemoteNotification];
    [LCCKInputViewPluginTakePhoto registerSubclass];
    [LCCKInputViewPluginPickImage registerSubclass];
    [LCCKInputViewPluginLocation registerSubclass];
    
    //登陆成功后进行数据的储藏
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:RCIMLoginSucessedNotifaction object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self loginSucessed];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:RCIMLogoutSucessedNotifaction object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self logoutSucessed];
    }];
    NSLog(@"%@", [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies]);
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
    PPTabBarController * controller = [[PPTabBarController alloc]init:@[@"RCConversationListViewController",@"PPContactListViewController",@"ViewController",@"PPMyViewController"] selectImageArr:selImageArray titleArr:titleArray normalImageArr:imageArray];
    
    [RACObserve([PPTUserInfoEngine shareEngine], promptCount)subscribeNext:^(id  _Nullable x) {
        NSInteger count = [x integerValue];
        [controller showBadgeMark:count index:1];
    }];
    
    self.window.rootViewController = controller;
    
}
- (void)createLoginController
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.window.rootViewController = [PPLoginViewController new];
}

- (void)loginStateChaned:(NSNotification *)noti
{
    if([noti.name isEqualToString:RCIMLoginSucessedNotifaction])
    {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        [[NSUserDefaults standardUserDefaults]setObject:OBJC_APPIsLogin forKey:OBJC_APPIsLogin];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self createTabbarController];
    }else
    {
        [self createLoginController];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<"
                                             withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">"
                                             withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" "
                                             withString:@""];
    [[RCIMClient sharedRCIMClient]setDeviceToken:token];
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0)
{
    NSLog(@"error == %@",error);
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [application registerForRemoteNotifications];
}
- (void)registerRemoteNotification {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge |UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //    // 取得 APNs 标准信息内容
    //    //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //
    //    // IOS 7 Support Required
    //    [JPUSHService handleRemoteNotification:userInfo];
    //    completionHandler(UIBackgroundFetchResultNewData);
    
    //NewData就是使用新的数据 更新界面，响应点击通知这个动作
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)loginSucessed
{
    //加载好友的列表
//    [[[PPDateEngine manager].contactListCommand execute:nil]subscribeNext:^(id  _Nullable x) {
//        
//    } error:^(NSError * _Nullable error) {
//        
//    } completed:^{
//        
//    }];
//    //请求个人信息数据
//    [[[PPDateEngine manager].searchUserInfoCommand execute:nil]subscribeNext:^(id  _Nullable x) {
//        
//    } error:^(NSError * _Nullable error) {
//        
//    } completed:^{
//        
//    }];
    //好友列表的黑名单
    
    
    
}

- (void)logoutSucessed
{
    //清理数据
}
@end
