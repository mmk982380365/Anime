//
//  CommentTableViewCell.h
//  Anime
//
//  Created by lxf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Social.h"

@protocol CommentTableViewCellDelegate <NSObject>
@optional
-(void)clickReportAtIndex:(NSIndexPath *)indexPath;
@end

@interface CommentTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

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
 *  图片列表
 */
@property (strong,nonatomic)UICollectionView *collectionView;
/**
 *  图片数组
 */
@property (strong,nonatomic) NSMutableArray *arr;

/**
 *  单元格高度
 */
@property(assign,nonatomic) float cellHeight;

@property(strong,nonatomic) UIButton *moreBtn;

@property(assign,nonatomic)id<CommentTableViewCellDelegate> delegate;
@property(strong,nonatomic)NSIndexPath *indexPath;
/**
 *  给帖子内容赋值并实现自动换行
 */
-(void)setContentLabelModel:(Social *)model;

/**
 *  给评论内容赋值并实现自动换行
 */
-(void)setCommentLabelModel:(Comment *)model;

@end
