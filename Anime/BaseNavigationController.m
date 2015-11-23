//
//  BaseNavigationController.m
//  PocketCookBook
//
//  Created by wkf on 15/9/23.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏的背景色
    self.navigationBar.backgroundColor=[UIColor colorWithRed:0.546 green:0.988 blue:0.559 alpha:1];

    
    //设置导航栏的前景色
    self.navigationBar.tintColor=[UIColor colorWithRed:1.000 green:0.771 blue:0.908 alpha:1.000];
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
