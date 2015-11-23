//
//  BaseViewController.m
//  PocketCookBook
//
//  Created by wkf on 15/9/23.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置视图的背景色
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.000 green:0.771 blue:0.908 alpha:1.000]};
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
