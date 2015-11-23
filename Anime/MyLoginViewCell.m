//
//  MyLoginViewCell.m
//  Anime
//
//  Created by wood on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "MyLoginViewCell.h"

@implementation MyLoginViewCell

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
    //内容lable
    self.contentLable =[[UILabel alloc]initWithFrame:CGRectMake(25, 0, KScreenWidth-50, KScreenHeight/15)];
    self.contentLable.font =[UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:self.contentLable];
    
    //分隔线
    self.view1 =[[UIView alloc]initWithFrame:CGRectMake(25, self.contentLable.frame.size.height-1, KScreenWidth-50, 1)];
    self.view1.backgroundColor =[UIColor colorWithWhite:0.8 alpha:0.3];

    [self.contentView addSubview:self.view1];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
