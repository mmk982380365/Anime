//
//  AnimateTableViewCell.h
//  Anime
//
//  Created by 马鸣坤 on 15/11/10.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateComment.h"

@protocol AnimateTableViewCellDelegate<NSObject>
@optional
-(void)clickReportAtIndex:(NSIndexPath *)indexPath;
@end

@interface AnimateTableViewCell : UITableViewCell
/**
 *  用户昵称
 */
@property (strong,nonatomic) UILabel *userNameLbl;

/**
 *  用户头像
 */
@property (strong,nonatomic) UIImageView *userAvatar;

/**
 *  帖子内容
 */
@property (strong,nonatomic) UILabel *contentLbl;
/**
 *  时间
 */
@property (strong,nonatomic) UILabel *timeLbl;

/**
 *  单元格高度
 */
@property(assign,nonatomic) float cellHeight;

@property(strong,nonatomic) UIButton *moreBtn;

@property(assign,nonatomic)id<AnimateTableViewCellDelegate> delegate;
@property(strong,nonatomic)NSIndexPath *indexPath;
/**
 *  给评论内容赋值并实现自动换行
 */
-(void)setCommentLabelModel:(AnimateComment *)model;

@end
