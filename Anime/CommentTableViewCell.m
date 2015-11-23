//
//  CommentTableViewCell.m
//  Anime
//
//  Created by lxf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "SJAvatarBrowser.h"
#import "UIImageView+WebCache.h"

@interface CommentTableViewCell ()<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)BOOL isShow;
@property (strong,nonatomic)UITableView *moreTableView;
@end

@implementation CommentTableViewCell

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
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake((KScreenWidth-80-4*10)/3.0, (KScreenWidth-80-4*10)/3.0);
    layout.minimumInteritemSpacing=10;
    layout.minimumLineSpacing=10;
    layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.backgroundView=nil;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgcell2"];
    [self.contentView addSubview:self.collectionView];
}
//发帖主题
-(void)setContentLabelModel:(Social *)model
{
    self.userNameLbl.text=[model.username objectForKey:@"name"];
    NSDate *currentDate=[NSDate date];
    NSDate *postTime=model.updatedAt;
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
    self.timeLbl.text=str;
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:[model.username objectForKey:@"iconImg"]]];
    self.cellHeight=0;
    //文本赋值
    self.contentLbl.text=model.content;
    CGSize size=[model.content boundingRectWithSize:CGSizeMake(KScreenWidth-120, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLbl.font} context:nil].size;
    
    self.contentLbl.frame=CGRectMake(60, 60, KScreenWidth-80, size.height);
    
    //图片赋值
    
    if (model.picture.count==0) {
        self.cellHeight =size.height+60+10;
    }else{
        self.collectionView.frame=CGRectMake(60, 60+size.height, (KScreenWidth-80), (KScreenWidth-80-4*10)/3.0+20);
        self.arr=[NSMutableArray arrayWithCapacity:0];
        [self.arr addObjectsFromArray:model.picture];
        [self.collectionView reloadData];
        self.cellHeight =size.height+60+20+(KScreenWidth-80-4*10)/3.0+20;
    }
}

#pragma mark collectionView代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //图片个数
    return self.arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier=@"imgcell2";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //设置图片
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-80-4*10)/3.0, (KScreenWidth-80-4*10)/3.0)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.arr[indexPath.item]]];
    [cell.contentView addSubview:imgView];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    //设置点击放大
    if ([(UIImageView *)cell.contentView.subviews[0] image]) {
        [SJAvatarBrowser showImage:cell.contentView.subviews[0]];
    }
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

//评论 赋值 并自动换行 ,计算出cell的高度
-(void)setCommentLabelModel:(Comment *)model{
    [self creatReportView];
    self.userNameLbl.text =[model.username objectForKey:@"name"];
    
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
    self.contentLbl.text =model.postContent;
    //获取文本所需要的大小
    CGSize size =[model.postContent boundingRectWithSize:CGSizeMake(KScreenWidth-120, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLbl.font} context:nil].size;
    self.contentLbl.frame=CGRectMake(60, 60, KScreenWidth-80, size.height);
    self.cellHeight =size.height+60+10;
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
    if([self.delegate conformsToProtocol:@protocol(CommentTableViewCellDelegate)]){
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
