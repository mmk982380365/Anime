//
//  VideoListCollectionViewCell.m
//  Anime
//
//  Created by 马鸣坤 on 15/11/2.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "VideoListCollectionViewCell.h"

@interface VideoListCollectionViewCell ()
@property (strong,nonatomic) UIImageView *imgView;
@property (strong,nonatomic) UILabel *titleLbl;
@property (strong,nonatomic) UILabel *actorLbl;
@property (strong,nonatomic) UILabel *playTimeLbl;
@property (strong,nonatomic) UILabel *introduceLbl;
@end

@implementation VideoListCollectionViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建界面
        [self createView:self.frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建界面
        [self createView:frame];
    }
    return self;
}
//创建界面
-(void)createView:(CGRect)frame{
    //设置背景
    self.backgroundView=nil;
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    //创建动漫图片视图
    self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(margin2, margin2, frame.size.width-2*margin2, (frame.size.width-2*margin2)*1.5)];
    [self.contentView addSubview:self.imgView];
    //创建动漫标题标签
    self.titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(margin2, margin2*2+(frame.size.width-2*margin2)*1.5, frame.size.width-2*margin2, 50)];
    self.titleLbl.font=[UIFont systemFontOfSize:18];
    self.titleLbl.textColor=[UIColor orangeColor];
    self.titleLbl.numberOfLines=2;
    [self.contentView addSubview:self.titleLbl];
    //创建动漫声优标签
    self.actorLbl=[[UILabel alloc] initWithFrame:CGRectMake(margin2, self.titleLbl.frame.origin.y+self.titleLbl.frame.size.height, frame.size.width-2*margin2, 35)];
    self.actorLbl.font=[UIFont systemFontOfSize:12];
    self.actorLbl.numberOfLines=2;
    [self.contentView addSubview:self.actorLbl];
    //创建放映时间标签
    self.playTimeLbl=[[UILabel alloc] initWithFrame:CGRectMake(margin2, self.actorLbl.frame.size.height+self.actorLbl.frame.origin.y, frame.size.width-2*margin2, 20)];
    self.playTimeLbl.font=[UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.playTimeLbl];
    //创建动漫介绍标签
    self.introduceLbl=[[UILabel alloc] initWithFrame:CGRectMake(margin2, self.playTimeLbl.frame.size.height+self.playTimeLbl.frame.origin.y, frame.size.width-2*margin2, 0)];
    self.introduceLbl.numberOfLines=0;
    self.introduceLbl.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.introduceLbl];
}
//重写model的set方法，设置model时更新界面
-(void)setModel:(Animate *)model{
    _model=model;
    //设置动漫图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    //设置动漫标题
    self.titleLbl.text=model.title;
    //设置动漫声优列表
    self.actorLbl.text=model.actor;
    //设置上映时间
    self.playTimeLbl.text=model.playTime;
    //获取动漫简介占用大小
    CGSize lblSize=[model.introduce boundingRectWithSize:CGSizeMake(self.frame.size.width-2*margin2, 11111) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    //更新动漫简介标签视图大小
    self.introduceLbl.frame=CGRectMake(margin2, self.playTimeLbl.frame.size.height+self.playTimeLbl.frame.origin.y, lblSize.width, lblSize.height);
    //设置动漫简介内容
    self.introduceLbl.text=model.introduce;
    //设置单元格高度
    self.size=CGSizeMake(self.frame.size.width, lblSize.height+self.introduceLbl.frame.origin.y+margin2);
    //添加背景
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    bgView.layer.borderColor=[[UIColor colorWithRed:1.000 green:0.982 blue:0.872 alpha:1.000] CGColor];
    bgView.layer.borderWidth=1;
    bgView.layer.cornerRadius=5;
    self.backgroundView=bgView;
}
@end
