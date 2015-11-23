//
//  AppDelegate.m
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //注册bmob的AppKey
    [Bmob registerWithAppKey:@"f368e52879b105a194d1ca639dbbc8d7"];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"messageCount"]) {
        self.messageCount=[[NSUserDefaults standardUserDefaults] integerForKey:@"messageCount"];
    }else{
        self.messageCount=0;
    }
    //移动数据库
    [self moveDb];
    //推送注册
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc]init];
        categorys.identifier=@"com.lamco.Anime";
        
        UIUserNotificationSettings *userNotifiSetting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys,nil]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotifiSetting];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        //注册远程推送
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    //设置应用程序状态栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //初始化标签栏
    self.mainTBC=[[MainTabBarController alloc] init];
    self.window.rootViewController=self.mainTBC;
    //添加网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //初始化网络状态对象
    self.reachiability = [Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([self.reachiability currentReachabilityStatus]==ReachableViaWWAN) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:ALERTTITLE message:NETWORK3GWORKING delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
        [alertView show];
        
    }
    if (self.reachiability.currentReachabilityStatus==NotReachable) {
        self.isReachable=NO;
    }else{
        self.isReachable=YES;
    }
    //开始监听
    [self.reachiability startNotifier];
    return YES;
}
//移动数据库
-(void)moveDb{
    //获取沙盒中数据库地址
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *toPath=[path stringByAppendingPathComponent:@"Anime.sqlite"];
//    NSLog(@"%@",toPath);
    //获取附带数据库地址
    NSString *sourcePath=[[NSBundle mainBundle] pathForResource:@"Anime" ofType:@"sqlite"];
    //判断沙盒中是否存在数据库文件 如果不存在 则复制一份到沙盒中
    NSFileManager *manager=[NSFileManager defaultManager];
    if (![manager fileExistsAtPath:toPath]) {
        __autoreleasing NSError *err;
        [manager copyItemAtPath:sourcePath toPath:toPath error:&err];
    }
}
//监听处理
-(void)reachabilityChanged:(NSNotification *)note{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    self.status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    self.isReachable = YES;
    
    switch (self.status) {
        case NotReachable:
        {
            //无网络
            
            self.isReachable = NO;
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:ALERTTITLE message:NETWORKNOTWORKING delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
            [alertView show];
        }
            break;
        case ReachableViaWiFi:
        {
            //无线网
            self.isReachable = YES;
            
        }
            break;
        case ReachableViaWWAN:
        {
            //数据网
            self.isReachable = YES;
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:ALERTTITLE message:NETWORK3GWORKING delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil];
            [alertView show];
            
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error);
}
//推送监听
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //注册成功后上传Token至服务器
    BmobInstallation  *currentIntallation = [BmobInstallation currentInstallation];
    [currentIntallation setDeviceTokenFromData:deviceToken];
    [currentIntallation saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
    }];
    //将deviceToken保存至本地
    [[NSUserDefaults standardUserDefaults] setObject:currentIntallation.deviceToken forKey:@"deviceToken"];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //获取推送消息
    if ([userInfo[@"type"] intValue]==0) {
        //将消息写入数据库
        [self writeToDB:userInfo];
        NSLog(@"%@",userInfo);
        BmobUser *currentUser=[BmobUser getCurrentUser];
        BmobQuery *query=[BmobQuery queryWithClassName:@"msgCount"];
        [query includeKey:@"username"];
        [query whereKey:@"username" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count!=0) {
                BmobObject *obj=array[0];
                self.messageCount=[[obj objectForKey:@"messageCount"] intValue];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.messageCount];
                [[NSUserDefaults standardUserDefaults] setInteger:self.messageCount forKey:@"messageCount"];
                self.mainTBC.meVc.tabBarItem.badgeValue=[NSString stringWithFormat:@"%ld",(long)self.messageCount];
            }
        }];
        //        BmobUser *currentUser=[BmobUser getCurrentUser];
        //        [currentUser setObject:[NSNumber numberWithInteger:self.messageCount] forKey:@"messageCount"];
        //        [currentUser updateInBackground];
    }
}
//将消息写入数据库
-(void)writeToDB:(NSDictionary *)userInfo{
    //数据库地址
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *toPath=[path stringByAppendingPathComponent:@"Anime.sqlite"];
    //创建数据库对象
    FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:toPath];
    //打开数据库
    [queue inDatabase:^(FMDatabase *db) {
        //用sql语句添加数据
        NSString *sql=@"insert into Reply ('postId','replyUser','comment','postUser','replyTime') values (?,?,?,?,?)";
        __autoreleasing NSError *dbErr;
        if ([db executeUpdate:sql values:@[userInfo[@"postId"],userInfo[@"replyUser"],userInfo[@"comment"],userInfo[@"postUser"],[NSDate date]] error:&dbErr]) {
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSLog(@"end");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks thatwere paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}



@end
