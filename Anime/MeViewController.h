//
//  MeViewController.h
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import <Bmob.h>
#import "MeTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "UIButton+WebCache.h"
#import "SuggestViewController.h"
#import "LoginViewController.h"
#import "MyLoginViewController.h"
#import "NewsViewController.h"
@interface MeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

/**
 *  个人Table
 */
@property(nonatomic,strong)UITableView * meTableView;

/**
 *  头部视图
 */
@property(nonatomic,strong)UIView * headView;

/**
 *  头部视图图片
 */
@property(nonatomic,strong)UIImageView * headImage;

/**
 *  用户名显示框
 */
@property(nonatomic,strong)UILabel * userNameLable;

/**
 *  登陆按钮
 */
@property(strong,nonatomic)UIButton * loginBtn;
@end
