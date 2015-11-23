//
//  AnimateComment.h
//  Anime
//
//  Created by 马鸣坤 on 15/11/10.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "Animate.h"

@interface AnimateComment : BmobObject
/**
 *  用户名
 */
@property(strong,nonatomic) BmobUser *username;
/**
 *  评论
 */
@property(strong,nonatomic) NSString *content;
/**
 *  对象ID
 */
@property(strong,nonatomic) Animate *animateId;

@end
