//
//  CommentViewController.h
//  Anime
//
//  Created by lxf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import <BmobSDK/BmobPush.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobInstallation.h>
#import "Comment.h"
#import "Social.h"

@interface CommentViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

/**
 *  tableView
 */
@property (strong,nonatomic) UITableView *tableView;

/**
 *  评论栏
 */
@property (strong,nonatomic) UIView *replyView;

/**
 *  评论框
 */
@property (strong,nonatomic) UITextView *textView;

/**
 *  发送按钮
 */
@property (strong,nonatomic) UIButton *sendBtn;

/**
 *  回复内容
 */
@property (strong,nonatomic) NSString *replyContent;

/**
 *  数据数组
 */
@property (strong,nonatomic) NSMutableArray *dataArr;
/**
 *  自适应单元格的数组
 */
@property(strong,nonatomic) NSMutableArray *cellArr;
/**
 *  帖子
 */
@property(strong,nonatomic)Social *model;


@end
