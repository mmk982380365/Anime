//
//  AnimateViewController.h
//  Anime
//
//  Created by 马鸣坤 on 15/11/10.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animate.h"
@interface AnimateViewController : UIViewController
@property (strong,nonatomic) Animate *animate;
@property(strong,nonatomic) NSMutableArray *arrayData;
@property(strong,nonatomic) NSMutableArray *arrayCell;
@end
