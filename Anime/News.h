//
//  News.h
//  Anime
//
//  Created by 马鸣坤 on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : BmobObject
/**
 *  资讯标题
 */
@property(strong,nonatomic) NSString *title;
/**
 *  资讯信息
 */
@property (strong,nonatomic) NSDictionary *titleData;
/**
 *  资讯内容
 */
@property (strong,nonatomic) NSString *content;
/**
 *  资讯图片
 */
@property (strong,nonatomic) NSString *imgUrl;
/**
 *  资讯链接
 */
@property(strong,nonatomic) NSString *link;
/**
 *  资讯图片
 */
@property (strong,nonatomic) NSData *imgData;
/**
 *  使用字典初始化
 *
 *  @param dic 字典
 *
 *  @return 实例对象
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
