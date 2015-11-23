//
//  ReportViewController.h
//  Anime
//
//  Created by 马鸣坤 on 15/11/13.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Social.h"
#import "AnimateComment.h"
#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, ReportType){
    ReportTypePost,
    ReportTypeComment,
    ReportTypeAnimate
};

@interface ReportViewController : BaseViewController
@property(assign,nonatomic) ReportType type;
@property(strong,nonatomic)Comment *reportComment;
@property(strong,nonatomic)Social *reportSocial;
@property(strong,nonatomic)AnimateComment *reportAnimate;
@end
