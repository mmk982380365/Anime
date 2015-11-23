//
//  NewsTableViewCell.m
//  Anime
//
//  Created by 马鸣坤 on 15/11/4.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell ()
/**
 *  回复者标签
 */
@property (strong,nonatomic) UILabel *replyUserLbl;
/**
 *  回复时间标签
 */
@property (strong,nonatomic) UILabel *replyTimeLbl;
/**
 *  回复内容标签
 */
@property (strong,nonatomic) UILabel *commentLbl;
@end

@implementation NewsTableViewCell
//初始化
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
    //回复者标签初始化
    self.replyUserLbl=[[UILabel alloc] initWithFrame:myRect(margin3, margin3, 160, 30)];
    [self.contentView addSubview:self.replyUserLbl];
    //回复时间初始化
    self.replyTimeLbl=[[UILabel alloc] initWithFrame:myRect(375-60-margin3, margin3, 60, 30)];
    self.replyTimeLbl.textColor=[UIColor grayColor];
    [self.contentView addSubview:self.replyTimeLbl];
    //回复内容标签初始化
    self.commentLbl=[[UILabel alloc] initWithFrame:myRect(4*margin3, margin3*2+30, 375-5*margin3, 0)];
    self.commentLbl.numberOfLines=0;
    self.commentLbl.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.commentLbl];
}
//从字典获取信息
-(void)setViewWithDic:(NSDictionary *)dic{
    //从字典中取出回复者姓名
    if (dic[@"replyUser"]) {
        BmobQuery *query=[BmobQuery queryForUser];
        [query getObjectInBackgroundWithId:dic[@"replyUser"] block:^(BmobObject *object, NSError *error) {
            self.replyUserLbl.text=[object objectForKey:@"name"];
        }];
    }
    //从字典中取出回复时间
    if (dic[@"replyTime"]) {
        NSDate *date=dic[@"replyTime"];
        //格式化时间显示  格式为 月份-第几天 小时:分钟
        NSDateFormatter *fm=[[NSDateFormatter alloc] init];
        [fm setDateFormat:@"MM-dd HH:mm"];
        self.replyTimeLbl.text=[fm stringFromDate:date];
    }
    //从字典中取出回复内容
    if (dic[@"comment"]) {
        NSString *comment=dic[@"comment"];
        //获取文字所需大小
        CGSize size=[comment boundingRectWithSize:CGSizeMake(KScreenWidth*(375-5*margin3)/375.0, 11111) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        //重新设置标签大小
        self.commentLbl.frame=myRect(4*margin3, margin3*2+30, 375-5*margin3, size.height);
        //设置文字内容
        self.commentLbl.text=comment;
        //计算单元格高度
        self.cellHeight=margin3*3+30+size.height;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
