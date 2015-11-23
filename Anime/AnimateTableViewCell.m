//
//  AnimateTableViewCell.m
//  Anime
//
//  Created by 马鸣坤 on 15/11/10.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "AnimateTableViewCell.h"

@interface AnimateTableViewCell ()<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)BOOL isShow;
@property (strong,nonatomic)UITableView *moreTableView;

@end

@implementation AnimateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
//自定义初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        //创建视图
        [self createViews];
    }
    return self;
}

//创建子视图
-(void)createViews
{
    //用户昵称
    self.userNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(75,10, KScreenWidth-80, 30)];
    self.userNameLbl.font =[UIFont boldSystemFontOfSize:15];
    self.userNameLbl.textColor =[UIColor blackColor];
    self.userNameLbl.textAlignment =NSTextAlignmentLeft;
    [self.contentView addSubview:self.userNameLbl];
    
    //用户头像
    self.userAvatar =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
    self.userAvatar.layer.cornerRadius =27;
    self.userAvatar.layer.masksToBounds =YES;
    self.userAvatar.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:self.userAvatar];
    
    //帖子内容
    self.contentLbl =[[UILabel alloc] initWithFrame:CGRectMake(75, 40, KScreenWidth-75, 0)];
    self.contentLbl.font =[UIFont systemFontOfSize:15];
    self.contentLbl.textColor =[UIColor blackColor];
    self.contentLbl.numberOfLines =0;
    [self.contentView addSubview:self.contentLbl];
    
    //时间
    self.timeLbl =[[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth-100, 5, 90, 40)];
    self.timeLbl.font =[UIFont boldSystemFontOfSize:12];
    self.timeLbl.textAlignment =NSTextAlignmentLeft;
    self.timeLbl.textColor =[UIColor grayColor];
    [self.contentView addSubview:self.timeLbl];
    [self creatReportView];
}

//评论 赋值 并自动换行 ,计算出cell的高度
-(void)setCommentLabelModel:(AnimateComment *)model{
    self.userNameLbl.text =[model.username objectForKey:@"name"];
    //设置时间
    NSDate *currentDate=[NSDate date];
    NSDate *postTime=model.createdAt;
    NSString *str;
    NSTimeInterval timeInt=[currentDate timeIntervalSinceDate:postTime]/60;
    if (timeInt<60) {
        str=[NSString stringWithFormat:@"%d分钟前",(int)timeInt];
    }else if (timeInt>=60&&timeInt<60*60*24){
        timeInt/=60;
        str=[NSString stringWithFormat:@"%d小时前",(int)timeInt];
    }else if (timeInt>=60*60*24){
        timeInt/=60*24;
        str=[NSString stringWithFormat:@"%d天前",(int)timeInt];
    }
    self.timeLbl.text =str;
    
    self.cellHeight =0;
    
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:[model.username objectForKey:@"iconImg"]]];
    
    //文本赋值
    self.contentLbl.text =model.content;
    //获取文本所需要的大小
    CGSize size =[model.content boundingRectWithSize:CGSizeMake(KScreenWidth-120, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLbl.font} context:nil].size;
    self.contentLbl.frame=CGRectMake(60, 60, KScreenWidth-80, size.height);
    self.cellHeight =size.height+60+10;
}
-(void)creatReportView{
    if(self.moreBtn==nil){
        self.moreBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    self.moreBtn.frame=CGRectMake(KScreenWidth-40, 5, 30, 40);
    self.moreBtn.tintColor=[UIColor grayColor];
    self.isShow=NO;
    [self.moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setImage:[UIImage imageNamed:@"iconfont-more"] forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:@"iconfont-more"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.moreBtn];
    if(self.moreTableView==nil){
        self.moreTableView=[[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth-80, 45, 70, 25) style:UITableViewStylePlain];
    }
    self.moreTableView.delegate=self;
    self.moreTableView.dataSource=self;
    [self.contentView addSubview:self.moreTableView];
    self.moreTableView.hidden=YES;
}

-(void)showMore{
    if(self.isShow==YES){
        self.isShow=NO;
        self.moreTableView.hidden=YES;
    }else{
        self.isShow=YES;
        self.moreTableView.hidden=NO;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    lbl.text=@"举报";
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont systemFontOfSize:12];
    [cell.contentView addSubview:lbl];
    //write code
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate conformsToProtocol:@protocol(AnimateTableViewCellDelegate)]){
        if([self.delegate respondsToSelector:@selector(clickReportAtIndex:)]){
            [self.delegate clickReportAtIndex:self.indexPath];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
