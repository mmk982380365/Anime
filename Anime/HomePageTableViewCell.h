//
//  HomePageTableViewCell.h
//  Anime
//
//  Created by 马鸣坤 on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#define CellSpace 10

@interface HomePageTableViewCell : UITableViewCell
/**
 *  数据模型
 */
@property (strong,nonatomic) News *model;
/**
 *  单元格高度
 */
@property (assign,nonatomic) float cellHeight;
@end
