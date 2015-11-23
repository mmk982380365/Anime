//
//  VideoListModel.h
//  Anime
//
//  Created by 马鸣坤 on 15/11/2.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animate : BmobObject
/**
 *  动漫图片
 */
@property (strong,nonatomic) NSString *img;
/**
 *  动漫声优
 */
@property (strong,nonatomic) NSString *actor;
/**
 *  动漫介绍
 */
@property (strong,nonatomic) NSString *introduce;
/**
 *  动漫放映时间
 */
@property (strong,nonatomic) NSString *playTime;
/**
 *  动漫标题
 */
@property (strong,nonatomic) NSString *title;
/**
 *  链接地址
 */
@property (strong,nonatomic) NSString *link;
/**
 *  动漫关键字
 */
@property (strong,nonatomic) NSString *keyword;
@end
