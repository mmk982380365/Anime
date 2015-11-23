//
//  VideoListCollectionViewCell.h
//  Anime
//
//  Created by 马鸣坤 on 15/11/2.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animate.h"
#define margin2 2

@interface VideoListCollectionViewCell : UICollectionViewCell
/**
 *  数据模型
 */
@property (strong,nonatomic) Animate *model;
/**
 *  单元格大小
 */
@property (assign,nonatomic) CGSize size;
@end
