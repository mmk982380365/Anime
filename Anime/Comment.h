//
//  CommentModel.h
//  Anime
//
//  Created by wang on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "Social.h"

@interface Comment : BmobObject
/**
 *  用户名
 */
@property(strong,nonatomic) BmobUser *username;
/**
 *  评论
 */
@property(strong,nonatomic) NSString *postContent;
/**
 *  对象ID
 */
@property(strong,nonatomic) Social *postId;
/**
 *  自定义初始化评论数据
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
