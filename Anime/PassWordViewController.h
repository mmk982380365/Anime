//
//  PassWordViewController.h
//  RentBike
//
//  Created by wang on 15/10/22.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "UIButton+WebCache.h"
#import <Bmob.h>
@interface PassWordViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
/**
 *  当前密码
 */
@property(strong,nonatomic)UITextField * currentPassword;

/**
 *  新密码1
 */
@property(strong,nonatomic)UITextField * updatePassword1;

/**
 *  新密码2
 */
@property(strong,nonatomic)UITextField * updatePassword2;

/**
 *   提交按钮
 */
@property(strong,nonatomic)UIButton * SubmitBtn;

/**
 *  当前边框颜色
 */
@property(strong,nonatomic)UIColor * currentColor;
@end
