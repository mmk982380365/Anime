//
//  HomePageTableViewCell.m
//  Anime
//
//  Created by 马鸣坤 on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "HomePageTableViewCell.h"

@interface HomePageTableViewCell ()
/**
 *  资讯图片
 */
@property (strong,nonatomic) UIImageView *mainImage;
/**
 *  资讯标题
 */
@property (strong,nonatomic) UILabel *titleLbl;
/**
 *  资讯时间
 */
@property (strong,nonatomic) UILabel *timeLbl;
/**
 *  资讯发布平台
 */
@property (strong,nonatomic) UILabel *webLbl;
/**
 *  资讯发布作者
 */
@property (strong,nonatomic) UILabel *authorLbl;
/**
 *  资讯内容
 */
@property (strong,nonatomic) UILabel *contentLbl;

@end

@implementation HomePageTableViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建视图
        [self createView];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //创建视图
        [self createView];
    }
    return self;
}
//创建视图
-(void)createView{
    //        self.titleLbl=[[UILabel alloc] initWithFrame:CGRectMake((CellSpace/375.0)*KScreenWidth, CellSpace, KScreenWidth*(375-2*CellSpace)/375.0, 50)];
    //资讯标题标签初始化
    self.titleLbl=[[UILabel alloc] initWithFrame:myRect(CellSpace,CellSpace,375-2*CellSpace,50)];
    self.titleLbl.textColor=[UIColor colorWithRed:0.141 green:0.561 blue:0.788 alpha:1.000];
    self.titleLbl.numberOfLines=2;
    self.titleLbl.font=[UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.titleLbl];
    //        self.timeLbl=[[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth*(CellSpace/375.0), CellSpace+50, (160/375.0)*KScreenWidth, 30)];
    //资讯时间标签初始化
    self.timeLbl=[[UILabel alloc] initWithFrame:myRect(CellSpace, CellSpace+50, 160, 30)];
    if (KScreenWidth==320) {
        self.timeLbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        self.timeLbl.font=[UIFont systemFontOfSize:13];
    }else{
        self.timeLbl.font=[UIFont systemFontOfSize:14];
    }
//    self.timeLbl.font=Font(13);
    [self.contentView addSubview:self.timeLbl];
    //        self.webLbl=[[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth*(CellSpace+160)/375.0, CellSpace+50, (90/375.0)*KScreenWidth, 30)];
    //资讯发布平台标签初始化
    self.webLbl=[[UILabel alloc] initWithFrame:myRect(CellSpace+160, CellSpace+50, 90, 30)];
    if (KScreenWidth==320) {
        self.webLbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        self.webLbl.font=[UIFont systemFontOfSize:13];
    }else{
        self.webLbl.font=[UIFont systemFontOfSize:14];
    }
    self.webLbl.textColor=[UIColor orangeColor];
    [self.contentView addSubview:self.webLbl];
    //        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth*(CellSpace+250)/375.0, CellSpace+50, (30/375.0)*KScreenWidth, 30)];
    //‘作者’标签初始化
    UILabel *lbl=[[UILabel alloc] initWithFrame:myRect(CellSpace+250, CellSpace+50, 30, 30)];
    if (KScreenWidth==320) {
        lbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        lbl.font=[UIFont systemFontOfSize:13];
    }else{
        lbl.font=[UIFont systemFontOfSize:14];
    }
    lbl.text=@"作者:";
    [self.contentView addSubview:lbl];
    //        self.authorLbl=[[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth*(CellSpace+280)/375.0, CellSpace+50, (75/375.0)*KScreenWidth, 30)];
    //资讯发布作者标签初始化
    self.authorLbl=[[UILabel alloc] initWithFrame:myRect(CellSpace+280, CellSpace+50, 75, 30)];
    if (KScreenWidth==320) {
        self.authorLbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        self.authorLbl.font=[UIFont systemFontOfSize:13];
    }else{
        self.authorLbl.font=[UIFont systemFontOfSize:14];
    }
    self.authorLbl.textColor=[UIColor orangeColor];
    [self.contentView addSubview:self.authorLbl];
//    self.mainImage=[[UIImageView alloc] initWithFrame:CGRectMake(3*CellSpace, CellSpace+80, 315, (375-6*CellSpace)*0.618)];
    //资讯图片视图初始化
    self.mainImage=[[UIImageView alloc] initWithFrame:myRect(3*CellSpace, CellSpace+80, (375-6*CellSpace), KScreenWidth*(375-6*CellSpace)/375.0*0.618)];
    [self.contentView addSubview:self.mainImage];
    //资讯内容标签初始化
    self.contentLbl=[[UILabel alloc] initWithFrame:myRect(CellSpace, (375-6*CellSpace)*0.618+2*CellSpace+80, 375-2*CellSpace, 80)];
    self.contentLbl.numberOfLines=0;
    [self.contentView addSubview:self.contentLbl];
}

-(void)setModel:(News *)model{
    _model=model;
    //设置资讯标题
    self.titleLbl.text=model.title;
    //设置资讯时间
    self.timeLbl.text=model.titleData[@"time"];
    //设置资讯发布平台
    self.webLbl.text=model.titleData[@"channel"];
    //设置资讯发布作者
    self.authorLbl.text=model.titleData[@"author"];
    //设置资讯图片
    if (model.imgData!=nil) {
        self.mainImage.image=[UIImage imageWithData:model.imgData];
    }else{
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"iconfont-tupian"]];
    }
//    self.mainImage.frame=myRect(3*CellSpace, CellSpace+80, (375-6*CellSpace), (375-6*CellSpace)*300/200);
    
    //获取资讯内容占用大小
    CGSize size=[model.content boundingRectWithSize:CGSizeMake(KScreenWidth-CellSpace*2, 11111) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLbl.font} context:nil].size;
    //更新资讯内容标签视图大小
    self.contentLbl.frame=CGRectMake(CellSpace, KScreenWidth*(375-6*CellSpace)/375.0*0.618+2*CellSpace+80, size.width, size.height);
    //设置资讯内容
    self.contentLbl.text=model.content;
    //设置单元格高度
    self.cellHeight=size.height+KScreenWidth*(375-6*CellSpace)/375.0*0.618+2*CellSpace+80+CellSpace;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSeparatorStyleNone;
    // Configure the view for the selected state
}

@end
