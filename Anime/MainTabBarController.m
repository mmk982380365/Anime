//
//  MainTabBarController.m
//  PocketCookBook
//
//  Created by wkf on 15/9/23.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题栏上设置图片文字颜色
    self.tabBar.barTintColor=[UIColor colorWithRed:0.922 green:0.973 blue:0.929 alpha:1.000];
    self.tabBar.tintColor=[UIColor colorWithRed:0.996 green:0.745 blue:0.902 alpha:1.000];
    
    //首页页面
    self.homePageVc=[[HomePageViewController alloc] init];
    self.n1=[[BaseNavigationController alloc] initWithRootViewController:self.homePageVc];
    self.homePageVc.title=@"漫讯";
    self.homePageVc.tabBarItem.image=[UIImage imageNamed:@"home"];
    
    
    //社区页面
    self.communityVc=[[CommunityViewController alloc] init];
    self.n2=[[BaseNavigationController alloc] initWithRootViewController:self.communityVc];
    self.communityVc.title=@"漫区";
    self.communityVc.tabBarItem.image=[UIImage imageNamed:@"people"];
    
    //个人中心页面
    self.meVc=[[MeViewController alloc] init];
    self.n3=[[BaseNavigationController alloc] initWithRootViewController:self.meVc];
    self.meVc.title=@"个人中心";
    self.meVc.tabBarItem.image=[UIImage imageNamed:@"user"];
    NSArray *viewControllers=@[self.n1,self.n2,self.n3];
    self.viewControllers=viewControllers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
