//
//  CommentModel.m
//  Anime
//
//  Created by wang on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "Comment.h"

@implementation Comment
#pragma mark 自定义初始化评论数据
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.username=dic[@"username"];
        
        self.postContent=dic[@"comment"];
        
        if (dic[@"postId"]) {
            self.postId=dic[@"postId"];
        }
    }
    return self;
}

@end
