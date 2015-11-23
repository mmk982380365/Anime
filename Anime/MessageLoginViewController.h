//
//  MessageLoginViewController.h
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "RegisteredViewController.h"
#import "MeViewController.h"
#import "ForgetPasswordViewController.h"
#import <BmobSMS.h>
@interface MessageLoginViewController : BaseViewController<UITextFieldDelegate>
/**
 *  手机号文本
 */
@property(strong,nonatomic) UITextField * phoneNumberTxt;
/**
 *  验证码文本
 */
@property(strong,nonatomic) UITextField * smsCodeTextField;
/**
 *  发送验证码按钮
 */
@property(strong,nonatomic) UIButton * sendBtn;
/**
 *  登陆按钮
 */
@property(strong,nonatomic) UIButton * loginBtn;
/**
 *  短信密码登陆按钮
 */
@property(strong,nonatomic) UIButton * serviceBtn;
/**
 *  忘记密码按钮
 */
@property(strong,nonatomic) UIButton * forgetPasswordBtn;
/**
 *  倒计时
 */
@property (assign,nonatomic) int time;
/**
 *  时间控件
 */
@property (strong,nonatomic) NSTimer *timer;

@end
