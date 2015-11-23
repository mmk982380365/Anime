//
//  MyLoginViewController.h
//  RentBike
//
//  Created by wang on 15/10/23.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "UIButton+WebCache.h"
#import <Bmob.h>
#import <BmobProFile.h>
#import "MyLoginViewCell.h"
#import "UserNameViewController.h"
@interface MyLoginViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

/**
 *  tableView
 */
@property(strong,nonatomic)UITableView *tableView;
/**
 *  照片选择器
 */
@property(strong,nonatomic)UIImagePickerController *pickerController;
/**
 *  退出按钮
 */
@property(strong,nonatomic)UIButton *logOutBtn;
/**
 *  数据
 */
@property(strong,nonatomic)NSMutableArray *dataArr;
/**
 *  HUD
 */
@property(strong,nonatomic)MBProgressHUD *hud;

@end
