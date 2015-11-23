//
//  LoginViewController.h
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "UIButton+WebCache.h"
#import <Bmob.h>
#import "MessageLoginViewController.h"
#import "RegisteredViewController.h"
#import "HomePageViewController.h"
#import "ForgetPasswordViewController.h"
#import "MyLoginViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>
/**
 *  用户名文本
 */
@property(strong,nonatomic) UITextField * userNameTxt;
/**
 *  密码文本
 */
@property(strong,nonatomic) UITextField * userPwdTextField;
/**
 *  打钩按钮
 */
@property(strong,nonatomic) UIButton * tickBtn;
/**
 *  记住密码标签
 */
@property(strong,nonatomic) UILabel * rememberPasswordLbl;
/**
 *  登陆按钮
 */
@property(strong,nonatomic) UIButton * loginBtn;
/**
 *  短信密码登陆按钮
 */
@property(strong,nonatomic) UIButton * messageBtn;
/**
 *  qq登陆按钮
 */
@property(strong,nonatomic) UIButton *QQBtn;
/**
 *  忘记密码按钮
 */
@property(strong,nonatomic) UIButton * forgetPasswordBtn;
/**
 *  加载视图
 */
@property(strong,nonatomic) MBProgressHUD *hud;
@end
