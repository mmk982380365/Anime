//
//  UserNameViewController.h
//  Anime
//
//  Created by wood on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import <Bmob.h>
#import "MBProgressHUD.h"
@interface UserNameViewController : BaseViewController<UITextFieldDelegate>

/**
 *  用户名
 */
@property(nonatomic,strong)NSString * userNameStr;

/**
 *  容器视图
 */
@property(nonatomic,strong)UIView * aview;

/**
 *  用户名修改框
 */
@property(nonatomic,strong)UITextField * userText;
@end
