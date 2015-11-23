//
//  CommunityTableViewCell.h
//  Anime
//
//  Created by lxf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Social.h"
@interface CommunityTableViewCell : UITableViewCell

/**
 *  用户昵称
 */
@property (strong,nonatomic) UILabel *userName;

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
*  评论数
*/
@property (strong,nonatomic) UILabel *commentCountLbl;
/**
 *  数据
 */
@property (strong,nonatomic) Social *model;

@end
