//
//  CommunityModel.h
//  Anime
//
//  Created by lxf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//


@interface Social : BmobObject

///**
// *  用户头像
// */
//@property (strong,nonatomic) NSString *userAvatar;

/**
 *  用户昵称
 */
@property (strong,nonatomic) BmobUser *username;

/**
 *  发帖内容
 */
@property (strong,nonatomic) NSString *content;

/**
 *  评论数
 */
@property (strong,nonatomic) NSNumber *contentCount;

/**
 *  图片集合
 */
@property (strong,nonatomic) NSArray *picture;

//自定义初始化方法
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
