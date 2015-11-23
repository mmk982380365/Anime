//
//  NewsViewController.m
//  Anime
//
//  Created by wkf on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "Social.h"
#import "CommentViewController.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  单元格列表
 */
@property (strong,nonatomic) UITableView *tableView;
/**
 *  消息数组
 */
@property (strong,nonatomic) NSMutableArray *dataArray;
/**
 *  单元格自适应高度数组
 */
@property (strong,nonatomic) NSMutableArray *cellArray;
@end

@implementation NewsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //读取数据
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建界面
    [self createView];
}
//读取数据
-(void)loadData{
    //初始化数组
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    self.cellArray=[NSMutableArray arrayWithCapacity:0];
    //本地数据库路径
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *toPath=[path stringByAppendingPathComponent:@"Anime.sqlite"];
    //初始化数据库对象
    FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:toPath];
    //查询数据
    [queue inDatabase:^(FMDatabase *db) {
        //获取当前用户的消息
        BmobUser *curUs=[BmobUser getCurrentUser];
        //通过sql语句获取数据
        NSString *sql=[NSString stringWithFormat:@"select * from Reply where postUser = '%@' ",curUs.objectId];
        FMResultSet *rs=[db executeQuery:sql];
        while ([rs next]) {
            NSString *postId=[rs stringForColumn:@"postId"];
            NSString *replyUser=[rs stringForColumn:@"replyUser"];
            NSString *comment=[rs stringForColumn:@"comment"];
            NSDate *replyTime=[rs dateForColumn:@"replyTime"];
            NSDictionary *dic=@{@"postId":postId,
                                @"replyUser":replyUser,
                                @"comment":comment,
                                @"replyTime":replyTime
                                };
            //向数组添加数据
            [self.dataArray addObject:dic];
            //创建自适应高度的单元格
            NewsTableViewCell *cell=[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newcellss"];
            [cell setViewWithDic:dic];
            [self.cellArray addObject:@(cell.cellHeight)];
        }
        //刷新列表
        [self.tableView reloadData];
        //如果有消息 则显示删除消息按钮
        if (self.dataArray.count>0) {
            UIBarButtonItem *delItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteNews)];
            self.navigationItem.rightBarButtonItem=delItem;
        }
    }];
}
//创建视图
-(void)createView{
    //列表初始化
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:self.tableView];
    //设置列表背景
    UIImageView *backgroundView2=[[UIImageView alloc] initWithFrame:myRect(0, 0, 375, KScreenHeight)];
    backgroundView2.image=[UIImage imageNamed:@"homepage_background"];
    backgroundView2.alpha=0.08;
    backgroundView2.contentMode=UIViewContentModeScaleToFill;
    self.tableView.backgroundView=backgroundView2;
    self.tableView.backgroundColor=[UIColor clearColor];
}
//删除记录
-(void)deleteNews{
    //弹出警告窗口确认信息
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:ALERTTITLE message:@"确认清除消息记录吗？" preferredStyle:UIAlertControllerStyleAlert];
    //确认按钮
    UIAlertAction *okAct=[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //获取路径
        NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *toPath=[path stringByAppendingPathComponent:@"Anime.sqlite"];
        //创建数据库对象
        FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:toPath];
        //执行操作
        [queue inDatabase:^(FMDatabase *db) {
            //通过sql语句删除记录
            NSString *sql=[NSString stringWithFormat:@"delete from reply where postUser = '%@'",[BmobUser getCurrentUser].objectId];
            if ([db executeUpdate:sql]) {
                //删除后提醒
                UIAlertController *alertController2=[UIAlertController alertControllerWithTitle:ALERTTITLE message:@"已删除" preferredStyle:UIAlertControllerStyleAlert];
                //确认按钮
                UIAlertAction *okAct2=[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    //读取数据库
                    [self loadData];
                }];
                [alertController2 addAction:okAct2];
                [self presentViewController:alertController2 animated:YES completion:nil];
            }
        }];
    }];
    [alertController addAction:okAct];
    //取消按钮
    UIAlertAction *cancelAct=[UIAlertAction actionWithTitle:ALERT_CANCEL style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAct];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark tableView代理

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建单元格
    NewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"newcellss"];
    if (cell==nil) {
        cell=[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newcellss"];
    }
    //write code
    //设置单元格显示内容
    [cell setViewWithDic:self.dataArray[indexPath.row]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //设置单元格个数
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取每个单元格高度
    return [self.cellArray[indexPath.row] floatValue];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前单元格对应的帖子对象
    NSString *objId=self.dataArray[indexPath.row][@"postId"];
    BmobQuery *query=[Social query];
    [query includeKey:@"username"];
    [query getObjectInBackgroundWithId:objId block:^(BmobObject *object, NSError *error) {
        Social *social=[[Social alloc] initFromBmobOjbect:object];
        //跳转到帖子详情页面
        CommentViewController *commentVc=[[CommentViewController alloc] init];
        commentVc.hidesBottomBarWhenPushed=YES;
        commentVc.model=social;
        [self.navigationController pushViewController:commentVc animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
