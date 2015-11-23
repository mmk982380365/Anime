//
//  MainTabBarController.h
//  PocketCookBook
//
//  Created by wkf on 15/9/23.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "MeViewController.h"
#import "CommunityViewController.h"
#import "HomePageViewController.h"

@interface MainTabBarController : UITabBarController
/**
 *  首页页面
 */
@property(nonatomic,strong) BaseNavigationController *n1;
/**
 *  首页页面
 */
@property (strong,nonatomic) HomePageViewController *homePageVc;
/**
 *  社区页面
 */
@property(nonatomic,strong) BaseNavigationController *n2;
/**
 *  社区页面
 */
@property (strong,nonatomic) CommunityViewController *communityVc;
/**
 *  个人中心页面
 */
@property(nonatomic,strong) BaseNavigationController *n3;
/**
 *  个人中心页面
 */
@property (strong,nonatomic) MeViewController *meVc;
@end
