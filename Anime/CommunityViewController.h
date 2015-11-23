//
//  CommunityViewController.h
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "BaseViewController.h"
#import "CommunityTableViewCell.h"
#define WIDTH  self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height
@interface CommunityViewController : BaseViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

/**
 *  搜索栏
 */
@property (strong,nonatomic) UISearchBar *searchBar;

/**
 *  tableView
 */
@property (strong,nonatomic) UITableView *tableView;

/**
 *  数据数组
 */
@property (strong,nonatomic) NSMutableArray *dataArray;

/**
 *  搜索数据数组
 */
@property (strong,nonatomic) NSMutableArray *searchArray;
/**
 *  是否是搜索状态
 */
@property(assign,nonatomic) BOOL isSearch;
/**
 *  读取数据
 */
-(void)loadData;

@end
