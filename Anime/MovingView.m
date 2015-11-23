//
//  MovingView.m
//  Anime
//
//  Created by 马鸣坤 on 15/11/2.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "MovingView.h"

@interface MovingView ()

@end

@implementation MovingView

- (instancetype)initWithFrame:(CGRect)frame buttonType:(UIButtonType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置默认不拖动
        _isDrag=NO;
        //按钮初始化
        self.btn=[UIButton buttonWithType:type];
        self.btn.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.btn addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [self.btn addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        
    }
    return self;
}
//设置标题
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [self.btn setTitle:title forState:state];
}
//设置图片
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [self.btn setImage:image forState:state];
}
//点击按钮事件
-(void)doClick:(UIButton *)btn{
    //若为拖动状态时 将自身移动到屏幕边缘
    if (self.isDrag) {
        _isDrag=NO;
//        NSLog(@"end    %f %f",self.center.x,self.center.y);
        //若按钮在右侧 则移动到右侧边缘
        if (self.center.x>=self.superview.frame.size.width/2.0) {
            //动画效果
            [UIView animateWithDuration:0.3 animations:^{
                self.center=CGPointMake(self.superview.frame.size.width-self.frame.size.width/2.0-10, self.center.y);
            }];
        }
        //若按钮在左侧 则移动到左侧边缘
        else{
            //动画效果
            [UIView animateWithDuration:0.3 animations:^{
                self.center=CGPointMake(self.frame.size.width/2.0+10, self.center.y);
            }];
        }
    }
    //若不是拖动状态 则执行代理
    else{
//        NSLog(@"ok");
        //判断代理是否遵循协议
        if ([self.delegate conformsToProtocol:@protocol(MovingViewDelegate)]) {
            [self.delegate buttonAction:self];
        }
    }
    
}
//拖动事件
- (void) dragMoving: (UIButton *)btn withEvent:(UIEvent *)event
{
    //设置拖动状态
    _isDrag=YES;
    //获取按钮位置
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.superview];
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    CGFloat btnx = self.frame.size.width/2;
    
    CGFloat btny = self.frame.size.height/2;
    
    
    
    if(x<=btnx)
        
    {
        
        point.x = btnx;
        
    }
    if (y<btny) {
        point.y=btny;
    }
    
    if(x >= self.superview.bounds.size.width - btnx)
        
    {
        
        point.x = self.superview.bounds.size.width - btnx;
        
    }
    if (y>=self.superview.bounds.size.height-btnx-60) {
        point.y = self.superview.bounds.size.height - btny-60;
    }
    
//    NSLog(@"fs:%f %f",x, btnx);
    //改变中心位置
    self.center = point;
    
//    NSLog(@"%f,,,%f",btn.center.x,btn.center.y);
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
