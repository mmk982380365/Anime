//
//  MeTableViewCell.m
//  Anime
//
//  Created by wood on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "MeTableViewCell.h"

@implementation MeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化视图
        [self creatView];
//        self.backgroundColor=[UIColor clearColor];
        self.backgroundView=nil;
    }
    return self;
}

//视图初始化方法
-(void)creatView{
    //创建容器视图
    UIView * aView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.contentView.frame.size.height)];
//    aView.backgroundColor =[UIColor greenColor];
    [self.contentView addSubview:aView];
    
    //图标
    //容器视图
    UIView * bview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, aView.frame.size.height, aView.frame.size.height)];
    self.iconImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.iconImage.center =bview.center;
//    self.iconImage.backgroundColor =[UIColor redColor];
    [bview addSubview:self.iconImage];
    [aView addSubview:bview];
    
    //内容lable
    self.contentLable =[[UILabel alloc]initWithFrame:CGRectMake(bview.frame.size.width, 0, KScreenWidth-aView.frame.size.height, aView.frame.size.height)];
    self.contentLable.font =[UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:self.contentLable];
    
    //分隔线
    self.view1 =[[UIView alloc]initWithFrame:CGRectMake(aView.frame.size.height, self.contentView.frame.size.height-0.3, KScreenWidth-aView.frame.size.height, 0.3)];
    self.view1.backgroundColor =[UIColor lightGrayColor];
    self.view1.alpha =0.5;
    [aView addSubview:self.view1];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
