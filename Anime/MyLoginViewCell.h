//
//  MyLoginViewCell.h
//  Anime
//
//  Created by wood on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MyLoginViewCell : UITableViewCell
/**
 *  内容
 */
@property(nonatomic,strong)UILabel * contentLable;

/**
 *  分隔线
 */
@property(nonatomic,strong)UIView * view1;


@end
