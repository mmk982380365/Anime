//
//  AnimateViewController.m
//  Anime
//
//  Created by 马鸣坤 on 15/11/10.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "AnimateViewController.h"
#import "AnimateTableViewCell.h"
#import "ReportViewController.h"

@interface AnimateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,AnimateTableViewCellDelegate>
/**
 *  评论列表
 */
@property (strong,nonatomic) UITableView *tableView;
/**
 *  上部简介视图
 */
@property (strong,nonatomic) UIView *headerView;
/**
 *  标题标签
 */
@property (strong,nonatomic) UILabel *titleLbl;
/**
 *  动漫图片
 */
@property (strong,nonatomic) UIImageView *animateView;
/**
 *  声优信息
 */
@property (strong,nonatomic) UILabel *actorLbl;
/**
 *  开播时间
 */
@property (strong,nonatomic) UILabel *playTimeLbl;
/**
 *  动漫简介标签
 */
@property (strong,nonatomic) UILabel *introduceLbl;
/**
 *  评论栏
 */
@property (strong,nonatomic) UIView *replyView;
/**
 *  评论框
 */
@property (strong,nonatomic) UITextView *textView;
/**
 *  发送按钮
 */
@property (strong,nonatomic) UIButton *sendBtn;
/**
 *  回复内容
 */
@property (strong,nonatomic) NSString *replyContent;
/**
 *  记录中心点
 */
@property (assign,nonatomic) CGPoint center;
/**
 *  是否要刷新
 */
@property (assign,nonatomic) BOOL isRefreshing;

@end

@implementation AnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化数组
    self.arrayData=[NSMutableArray arrayWithCapacity:0];
    self.arrayCell=[NSMutableArray arrayWithCapacity:0];
    //设置导航栏标题
    self.title=self.animate.title;
    //列表初始化
    self.tableView=[[UITableView alloc] initWithFrame:myRect(0, 0, 375, KScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    //列表背景图
    UIImageView *backgroundView=[[UIImageView alloc] initWithFrame:myRect(0, 0, 375, KScreenHeight)];
    backgroundView.image=[UIImage imageNamed:@"homepage_background"];
    backgroundView.alpha=0.08;
    backgroundView.contentMode=UIViewContentModeScaleToFill;
    self.tableView.backgroundView=backgroundView;
    //添加头部视图
    self.headerView=[[UIView alloc] initWithFrame:myRect(0, 0, 375, 355)];
    self.headerView.backgroundColor=[UIColor colorWithRed:0.867 green:0.914 blue:0.867 alpha:0.400];
    [self.tableView setTableHeaderView:self.headerView];
    //标题初始化
    self.titleLbl=[[UILabel alloc] initWithFrame:myRect(5, 5, 365, 30)];
    self.titleLbl.font=[UIFont systemFontOfSize:22];
    self.titleLbl.textColor=[UIColor orangeColor];
    [self.headerView addSubview:self.titleLbl];
    self.titleLbl.adjustsFontSizeToFitWidth=YES;
    self.titleLbl.text=self.animate.title;
    //图片初始化
    self.animateView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 300*0.618, 300)];
    [self.animateView sd_setImageWithURL:[NSURL URLWithString:self.animate.img]];
    [self.headerView addSubview:self.animateView];
    //声优标签初始化
    self.actorLbl=[[UILabel alloc] initWithFrame:CGRectMake(10+300*0.618, 40, KScreenWidth-(15+300*0.618), 30)];
    self.actorLbl.numberOfLines=2;
    self.actorLbl.font=[UIFont systemFontOfSize:12];
    [self.headerView addSubview:self.actorLbl];
    self.actorLbl.text=self.animate.actor;
    //上映时间标签初始化
    self.playTimeLbl=[[UILabel alloc] initWithFrame:CGRectMake(10+300*0.618, 70, KScreenWidth-(15+300*0.618), 20)];
    self.playTimeLbl.font=[UIFont systemFontOfSize:12];
    [self.headerView addSubview:self.playTimeLbl];
    self.playTimeLbl.adjustsFontSizeToFitWidth=YES;
    self.playTimeLbl.text=self.animate.playTime;
    //简介标签初始化
    self.introduceLbl=[[UILabel alloc] initWithFrame:CGRectMake(10+300*0.618, 90, KScreenWidth-(15+300*0.618), self.headerView.frame.size.height-(self.playTimeLbl.frame.size.height+self.playTimeLbl.frame.origin.y+5))];
    self.introduceLbl.numberOfLines=0;
    //根据设备类型设置字体大小
    UIFont *introFont=[UIFont systemFontOfSize:13];
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        if (KScreenWidth<375) {
            introFont=[UIFont systemFontOfSize:13];
        }else{
           introFont=[UIFont systemFontOfSize:15];
        }
    }else if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad){
        introFont=[UIFont systemFontOfSize:22];
    }
    self.introduceLbl.font=introFont;
    [self.headerView addSubview:self.introduceLbl];
    //设置标签大小
    CGFloat height=[self.animate.introduce boundingRectWithSize:CGSizeMake(self.introduceLbl.frame.size.width, self.introduceLbl.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:introFont} context:nil].size.height;
    self.introduceLbl.frame=CGRectMake(10+300*0.618, 90, KScreenWidth-(15+300*0.618), height);
    self.introduceLbl.text=self.animate.introduce;
    
    //回复
    self.replyView =[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
    self.replyView.backgroundColor =[UIColor colorWithWhite:0.869 alpha:1.000];
    self.replyView.tag =2015;
    [self.view addSubview:self.replyView];
    
    //textView
    self.textView =[[UITextView alloc] initWithFrame:CGRectMake(10, 5, KScreenWidth-100, 40)];
    self.textView.delegate =self;
    self.textView.font =[UIFont systemFontOfSize:16];
    self.textView.scrollEnabled =YES;
    self.textView.returnKeyType =UIReturnKeyDefault;
    self.textView.keyboardType =UIKeyboardTypeDefault;
    self.textView.editable=YES;
    self.textView.layer.cornerRadius =5.0;
    self.textView.layer.borderWidth=0;
    self.textView.textAlignment = NSTextAlignmentLeft;
    NSRange range=NSMakeRange([self.textView.text length]-1, 1);
    [self.textView scrollRangeToVisible:range];
    [self.replyView addSubview:self.textView];
    
    //自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDidHidden:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    //发送按钮
    self.sendBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendBtn.frame =CGRectMake(KScreenWidth-80, 5, 70, 40);
    self.sendBtn.backgroundColor =[UIColor colorWithRed:0.914 green:0.980 blue:0.914 alpha:1.000];
    self.sendBtn.layer.cornerRadius =10.0;
    self.sendBtn.tintColor =[UIColor colorWithRed:1.000 green:0.771 blue:0.908 alpha:1.000];
    [self.sendBtn setTitle:@"评论" forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(replyPost) forControlEvents:UIControlEventTouchUpInside];
    [self.replyView addSubview:self.sendBtn];
    //获取列表中心
    self.center=self.tableView.center;
    //获取评论
    [self refreshing];
    //上拉刷新
    MJRefreshAutoFooter *footer=[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadComment];
    }];
    //下拉刷新
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshing];
    }];
    self.tableView.footer=footer;
    self.tableView.header=header;

}
//读取评论
-(void)loadComment{
    BmobQuery *query=[AnimateComment query];
    query.limit=20;
    if (self.isRefreshing) {
        query.skip=0;
    }else{
        query.skip=self.arrayData.count;
    }
    //按时间降序排序
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"username,animateId"];
    //指定搜索范围
    [query whereKey:@"animateId" equalTo:self.animate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (self.isRefreshing&&array.count!=0) {
            self.isRefreshing=NO;
            [self.arrayCell removeAllObjects];
            [self.arrayData removeAllObjects];
        }
        //将获取的数据加入数组
        for (BmobObject *object in array) {
            AnimateComment *comment=[[AnimateComment alloc] initFromBmobOjbect:object];
            [self.arrayData addObject:comment];
            AnimateTableViewCell *cell=[[AnimateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"animateCell"];
            [cell setCommentLabelModel:comment];
            [self.arrayCell addObject:cell];
        }
        //刷新列表
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }];
}
//刷新列表
-(void)refreshing{
    self.isRefreshing=YES;
    [self loadComment];
}
//发送评论
-(void)replyPost
{
    //键盘消失
    if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
    if (!(self.textView.text==nil||[self.textView.text isEqualToString:@""]))
    {
        //发送数据
        [self sendData];
    }
}
//发送评论
-(void)sendData{
    //初始化数据类型
    AnimateComment *comment=[[AnimateComment alloc] init];
    comment.username=[BmobUser getCurrentUser];
    comment.content=self.replyContent;
    comment.animateId=self.animate;
    //发送数据到服务器
    [comment sub_saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"success");
            self.textView.text=@"";
            //发送完成后刷新列表
            [self refreshing];
        }
    }];
}

//添加键盘监听事件
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    //根据用户登录情况显示或隐藏消息窗口
    if ([BmobUser getCurrentUser])
    {
        self.replyView.hidden=NO;
    }
    else
    {
        self.replyView.hidden=YES;
    }
}
//键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    NSValue *keyboardObject=[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];//获取键盘高度
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    //调整replyView位置
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:0.3];
    self.tableView.center=CGPointMake(self.center.x, self.center.y-keyboardRect.size.height);
    //设置replyView上移
    [(UIView *)[self.view viewWithTag:2015] setFrame:CGRectMake(0, HEIGHT-50-keyboardRect.size.height, WIDTH, 50)];
    [UIView commitAnimations];
}
//键盘隐藏时
-(void)keyboardDidHidden:(NSNotification *)notification
{
    //调整replyView位置
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:0.3];
    self.tableView.center=self.center;
    //设置replyView下移
    [(UIView *)[self.view viewWithTag:2015] setFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    [_textView resignFirstResponder];
    [UIView commitAnimations];
}
#pragma mark textView代理
-(void)textViewDidChange:(UITextView *)textView
{
    self.replyContent =textView.text;
}

//控制输入文本的长度
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=100)
    {
        
        return  NO;
    }
    
    return YES;
}
#pragma mark tableView代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnimateTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"animateCell"];
    if (cell==nil) {
        cell=[[AnimateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"animateCell"];
    }
    //write code
    //设置单元格显示内容
    [cell setCommentLabelModel:self.arrayData[indexPath.row]];
    cell.indexPath=indexPath;
    cell.delegate=self;
    //设置单元格背景
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.arrayCell[indexPath.row] cellHeight];
}
-(void)clickReportAtIndex:(NSIndexPath *)indexPath{
    ReportViewController *reportVc=[[ReportViewController alloc] init];
    reportVc.type=ReportTypeAnimate;
    reportVc.reportAnimate=self.arrayData[indexPath.row];
    [self.navigationController pushViewController:reportVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
