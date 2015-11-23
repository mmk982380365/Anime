//
//  CommunityModel.m
//  Anime
//
//  Created by lxf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "Social.h"

@implementation Social

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self=[super self];
    if (self) {
        self.content =dictionary[@"content"];
        self.contentCount =dictionary[@"contentCount"];
        self.picture=dictionary[@"picture"];
}
    return self;
}

@end
