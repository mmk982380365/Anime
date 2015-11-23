//
//  News.m
//  Anime
//
//  Created by 马鸣坤 on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "News.h"

@implementation News
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.title=dic[@"title"];
        self.content=dic[@"content"];
        self.imgUrl=dic[@"imgUrl"];
        self.titleData=dic[@"titleData"];
        self.link=dic[@"link"];
        if (dic[@"img"]) {
            self.imgData=dic[@"img"];
        }
    }
    return self;
}
@end
