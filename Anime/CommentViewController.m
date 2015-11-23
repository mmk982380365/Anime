//
//  CommentViewController.m
//  Anime
//
//  Created by lxf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "CommentViewController.h"
#import "ReportViewController.h"

#define  WIDTH self.view.frame.size.width
#define  HEIGHT self.view.frame.size.height
//动画时间
#define kAnimationDuration 0.2
//view高度
#define kViewHeight 56
#import "CommentTableViewCell.h"
@interface CommentViewController ()<CommentTableViewCellDelegate>
/**
 *  加载视图
 */
@property (strong,nonatomic) MBProgressHUD *hud;
@end

@implementation CommentViewController
static int pages=0;
-(void)createDataArray
{
    pages=0;
    self.dataArr=nil;
    self.dataArr=[NSMutableArray arrayWithCapacity:0];
    self.cellArr=[NSMutableArray arrayWithCapacity:0];
    CommentTableViewCell *cell=[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    [cell setContentLabelModel:self.model];
    [self.cellArr addObject:cell];
    [self loadSendData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    //tableView
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, -35, WIDTH, HEIGHT+22) style:UITableViewStyleGrouped];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
    
    
    //回复
    self.replyView =[[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    self.replyView.backgroundColor =[UIColor colorWithWhite:0.869 alpha:1.000];
    self.replyView.tag =2015;
    [self.view addSubview:self.replyView];
    
    //textView
    self.textView =[[UITextView alloc] initWithFrame:CGRectMake(10, 5, WIDTH-100, 40)];
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
    self.sendBtn.frame =CGRectMake(WIDTH-80, 5, 70, 40);
    self.sendBtn.backgroundColor =[UIColor colorWithRed:0.914 green:0.980 blue:0.914 alpha:1.000];
    self.sendBtn.layer.cornerRadius =10.0;
    self.sendBtn.tintColor =[UIColor colorWithRed:1.000 green:0.771 blue:0.908 alpha:1.000];
    [self.sendBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(replyPost) forControlEvents:UIControlEventTouchUpInside];
    [self.replyView addSubview:self.sendBtn];

    //初始化加载时的视图
    self.hud=[[MBProgressHUD alloc] initWithView:self.tableView];
    self.hud.mode=MBProgressHUDModeCustomView;
    [self.view addSubview:self.hud];
    UIImageView *loadView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    NSData *imgData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
    loadView.image=[UIImage sd_animatedGIFWithData:imgData];
    self.hud.customView=loadView;
    self.hud.detailsLabelColor=[UIColor grayColor];
    self.hud.detailsLabelText=@"努力加载中";
    self.hud.backgroundColor=[UIColor clearColor];
    self.hud.color=[UIColor clearColor];
    
    UIBarButtonItem *reportBtn=[[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStyleDone target:self action:@selector(reportToW)];
    self.navigationItem.rightBarButtonItem=reportBtn;
}

-(void)reportToW{
    ReportViewController *reportVc=[[ReportViewController alloc] init];
    reportVc.type=ReportTypePost;
    reportVc.reportSocial=self.model;
    [self.navigationController pushViewController:reportVc animated:YES];
}
//发送数据
-(void)sendData{
    //计算评论数
    BmobQuery *query=[BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"username,postId"];
    BmobObject *postObj=[BmobObject objectWithoutDatatWithClassName:@"Social" objectId:self.model.objectId];
    Social *social=[[Social alloc] initFromBmobOjbect:postObj];
    [query whereKey:@"postId" equalTo:postObj];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error)
        {
            int count=number+1;
            [postObj setObject:@(count) forKey:@"contentCount"];
            [postObj updateInBackground];
            //保存评论内容
            Comment *comment=[[Comment alloc] init];
            comment.postId=social;
            BmobUser *commentUser=[BmobUser getCurrentUser];
            comment.username=commentUser;
            comment.postContent=self.textView.text;
            [comment sub_saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //刷新界面
                    [self createDataArray];
                    //获取发帖人的deviceToken
                    BmobUser *postUser=self.model.username;
                    BmobQuery *query=[BmobQuery queryForUser];
                    [query getObjectInBackgroundWithId:postUser.objectId block:^(BmobObject *object, NSError *error) {
                        NSString *deviceToken=[object objectForKey:@"deviceToken"];
                        //如果deviceToken不为空则发送推送消息
                        if (deviceToken&&![deviceToken isEqualToString:@""]) {
                            BmobPush *push=[BmobPush push];
                            BmobQuery *query = [BmobInstallation query];
                            [query whereKey:@"deviceToken" equalTo:[object objectForKey:@"deviceToken"]];
                            [push setQuery:query];
                            BmobQuery *querys=[BmobQuery queryWithClassName:@"msgCount"];
                            [querys whereKey:@"username" equalTo:object];
                            [querys findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                                NSNumber *msgCount;
                                if (array.count!=0) {
                                    NSInteger tmpNum=[[array[0] objectForKey:@"messageCount"] integerValue];
                                    msgCount=[NSNumber numberWithInteger:tmpNum+1];
                                    BmobObject *obj=array[0];
                                    [obj setObject:msgCount forKey:@"messageCount"];
                                    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                        NSLog(@"%@",error);
                                    }];
                                    
                                }else{
                                    msgCount=[NSNumber numberWithInteger:1];
                                    BmobObject *us=[[BmobObject alloc] initWithClassName:@"msgCount"];
                                    [us setObject:msgCount forKey:@"messageCount"];
                                    [us setObject:object forKey:@"username"];
                                    [us saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                        NSLog(@"%@",error);
                                    }];
                                }
                                //设置推送消息内容
                                NSDictionary *messages=@{@"aps":@{@"alert":@"您有新短消息",
                                                                  @"sound": @"cheering.caf",
                                                                  @"badge":msgCount},
                                                         @"type":@0,
                                                         @"postId":self.model.objectId,
                                                         @"replyUser":commentUser.objectId,
                                                         @"comment":self.textView.text,
                                                         @"postUser":postUser.objectId
                                                         };
                                [push setData:messages];
                                [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {
                                        NSLog(@"su");
                                    }else{
                                        NSLog(@"%@",error);
                                    }
                                }];
                            }];    
                        }
                        self.textView.text=@"";
                    }];
                }
            }];
        }
    }];
}
//发送评论
-(void)replyPost
{
    if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
    if (!(self.textView.text==nil||[self.textView.text isEqualToString:@""]))
    {
        [self sendData];
    }
}
//读取评论
-(void)loadSendData
{
    [self.hud show:YES];
    BmobQuery *query=[BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"postId,username"];
    [query orderByDescending:@"updatedAt"];
     BmobObject *postObj=[BmobObject objectWithoutDatatWithClassName:@"Social" objectId:self.model.objectId];
     [query whereKey:@"postId" equalTo:postObj];
//    [query whereKey:@"isOk" equalTo:@(YES)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array)
        {
            for (BmobObject *object in array) {
              Comment *detail=[[Comment alloc] initFromBmobOjbect:object];
                [self.dataArr addObject:detail];
                //建立自适应单元格
                CommentTableViewCell *cell=[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
                [cell setCommentLabelModel:detail];
                [self.cellArr addObject:cell];
            }
            //刷新列表
            [self.tableView reloadData];
        }
        [self.hud hide:YES];
    }];

}
//添加键盘监听事件
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    [self createDataArray];
    if ([BmobUser getCurrentUser])
    {
         self.replyView.hidden=NO;
    }
    else
    {
        self.replyView.hidden=YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject=[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    //调整replyView位置
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
    
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
    [UIView setAnimationDuration:kAnimationDuration];
    
    //设置replyView下移
    [(UIView *)[self.view viewWithTag:2015] setFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    [_textView resignFirstResponder];
    
    [UIView commitAnimations];
}

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
//分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else
    {
        return self.dataArr.count;
    }
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return [self.cellArr[0] cellHeight];
    }
    else
    {
        return [self.cellArr[indexPath.row+1] cellHeight];
    }
}
//内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cellId";
    static NSString *identifier2=@"cellId2";
    CommentTableViewCell *cell;
    //第一个分区
    if (indexPath.section ==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell =[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setContentLabelModel:self.model];
    }
    //第二个分区
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell==nil)
        {
            cell =[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        [cell setCommentLabelModel:self.dataArr[indexPath.row]];
        cell.delegate=self;
        cell.indexPath=indexPath;
        cell.backgroundColor =[UIColor colorWithRed:242/255.0 green:245/255.0 blue:248/255.0 alpha:1.0];
    }
    return cell;
}
//header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    else
    {
        return 10;
    }
}

//footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0)
        
    {
        return 0;
    }
    else
    {
        return 0;
    }
}
-(void)clickReportAtIndex:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    ReportViewController *reportVc=[[ReportViewController alloc] init];
    reportVc.type=ReportTypeComment;
    reportVc.reportComment=self.dataArr[indexPath.row];
    [self.navigationController pushViewController:reportVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
