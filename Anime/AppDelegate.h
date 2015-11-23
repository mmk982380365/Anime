//
//  AppDelegate.h
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainTabBarController.h"
#import <Bmob.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  标签栏
 */
@property (strong,nonatomic) MainTabBarController *mainTBC;
/**
 *  检查网络状态对象
 */
@property (strong,nonatomic)Reachability *reachiability;
/**
 *  是否可用
 */
@property (assign,nonatomic)BOOL isReachable;
/**
 *  判定状态用的
 */
@property (assign,nonatomic)NetworkStatus status;
@property (assign,nonatomic) NSInteger messageCount;
@end

