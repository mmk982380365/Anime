//
//  NewsTableViewCell.h
//  Anime
//
//  Created by 马鸣坤 on 15/11/4.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  margin3 5

@interface NewsTableViewCell : UITableViewCell
/**
 *  单元格高度
 */
@property (assign,nonatomic) float cellHeight;
/**
 *  从字典获取信息
 *
 *  @param dic 信息字典
 */
-(void)setViewWithDic:(NSDictionary *)dic;
@end
