//
//  CommunityTableViewCell.m
//  Anime
//
//  Created by lxf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "CommunityTableViewCell.h"
#import "UIImageView+WebCache.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation CommunityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//自定义初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        //创建视图
        [self createViews];
    }
    return self;
}
//创建视图
-(void)createViews
{
    //用户昵称
    self.userName=[[UILabel alloc] initWithFrame:CGRectMake(80, 10, kScreenWidth-80, 30)];
    self.userName.font =[UIFont boldSystemFontOfSize:14];
    self.userName.textColor =[UIColor blackColor];
    self.userName.textAlignment =NSTextAlignmentLeft;
    [self.contentView addSubview:self.userName];
    
    //用户头像
    self.userAvatar =[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
    self.userAvatar.layer.cornerRadius =self.userAvatar.frame.size.width/2;
    self.userAvatar.layer.masksToBounds =YES;
    [self.contentView addSubview:self.userAvatar];
    
    //帖子内容
    self.contentLbl =[[UILabel alloc] initWithFrame:CGRectMake(80, 30, kScreenWidth-100, 60)];
    self.contentLbl.font =[UIFont systemFontOfSize:15];
    self.contentLbl.textColor =[UIColor blackColor];
    self.contentLbl.numberOfLines =2;
    [self.contentView addSubview:self.contentLbl];
    
    //时间
    self.timeLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 90, 200, 20)];
    self.timeLbl.font =[UIFont boldSystemFontOfSize:12];
    self.timeLbl.textColor =[UIColor grayColor];
    [self.contentView addSubview:self.timeLbl];
    
    //评论数
    self.commentCountLbl =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, 90, 80, 20)];
    self.commentCountLbl.font =[UIFont boldSystemFontOfSize:12];
    self.commentCountLbl.textColor =[UIColor grayColor];
    [self.contentView addSubview:self.commentCountLbl];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    NSURL *url=[NSURL URLWithString:[self.model.username objectForKey:@"iconImg"]];
    [self.userAvatar sd_setImageWithURL:url];
    
    //用户名
    self.userName.text=[self.model.username objectForKey:@"name"];
    
    //内容
    self.contentLbl.text =self.model.content;
    
    //评论数
    NSString *str =[NSString stringWithFormat:@"评论数:%d",[self.model.contentCount intValue]];
    self.commentCountLbl.text=str;
    
    //时间
    NSDate *currentDate=[NSDate date];
    NSDate *postTime=self.model.updatedAt;
    NSString *str1;
    //获取时间间隔
    NSTimeInterval time=[currentDate timeIntervalSinceDate:postTime]/60;
    if (time<60) {
        str1=[NSString stringWithFormat:@"时间:%d分钟前",(int)time];
    }else if (time>=60&&time<60*60*24){
        time/=60;
        str1=[NSString stringWithFormat:@"时间:%d小时前",(int)time];
    }else if (time>=60*60*24){
        time/=60*24;
        str1=[NSString stringWithFormat:@"时间:%d天前",(int)time];
    }
    self.timeLbl.text=str1;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
