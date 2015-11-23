//
//  RegisteredViewController.h
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterView.h"
#import <BmobUser.h>
#import <BmobQuery.h>
@interface RegisteredViewController : BaseViewController
/**
 *  注册视图
 */
@property (strong,nonatomic) RegisterView *registerView;
/**
 *  注册按钮
 */
@property (strong,nonatomic) UIButton *registerBtn;
/**
 *  中心点
 */
@property(assign,nonatomic) CGPoint center;
@end
