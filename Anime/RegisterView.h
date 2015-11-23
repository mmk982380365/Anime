//
//  RegisterView.h
//  Anime
//
//  Created by wkf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView<UITextFieldDelegate>

/**
 *  用户名框
 */
@property (strong,nonatomic) UITextField *nameTextField;

/**
 *  手机号框
 */
@property (strong,nonatomic) UITextField *phoneNumTextField;

/**
 *  设置密码
 */
@property (strong,nonatomic) UITextField *userPwdTextField;

/**
 *  验证码
 */
@property (strong,nonatomic) UITextField *smsCodeTextField;

/**
 *  验证码按钮
 */
@property (strong,nonatomic) UIButton *smsCodeBtn;

/**
 *  时间控件
 */
@property (strong,nonatomic) NSTimer *timer;

/**
 *  倒计时
 */
@property (assign,nonatomic) int time;

@end
