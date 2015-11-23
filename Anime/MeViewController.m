//
//  MeViewController.m
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "MeViewController.h"
#import "AppDelegate.h"

@interface MeViewController ()
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) TencentOAuth *oAuth;
@end

@implementation MeViewController

//判断是否登录
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.hud show:YES];
    BmobQuery *query=[BmobQuery queryForUser];
    BmobUser *currentUser=[BmobUser getCurrentUser];
    if (currentUser) {
        [query getObjectInBackgroundWithId:currentUser.objectId block:^(BmobObject *object, NSError *error) {
            if ([object objectForKey:@"iconImg"]) {
                [self.headImage sd_setImageWithURL:[NSURL URLWithString:[object objectForKey:@"iconImg"]]];
                self.userNameLable.text=[currentUser objectForKey:@"name"];
            }
            else{
                self.headImage.image=[UIImage imageNamed:@"head"];
                self.userNameLable.text=[currentUser objectForKey:@"name"];
            }
            [self.hud hide:YES];
        }];
    }
    else{
        self.headImage.image=[UIImage imageNamed:@"head"];
        self.userNameLable.text=@"登陆/注册";
        [self.hud hide:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor =[UIColor colorWithRed:0.1 green:0.75 blue:0.7 alpha:1];
//    self.navigationController.navigationBarHidden =YES;
    self.title =@"个人中心";
    
    [self creatView];
    // Do any additional setup after loading the view.
}

//视图初始化方法
-(void)creatView{
    //个人Table初始化
    self.meTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    self.meTableView.dataSource =self;
    self.meTableView.delegate =self;
    self.meTableView.sectionHeaderHeight =0;
    self.meTableView.separatorStyle =UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.meTableView];
    
    //头部视图背景色
    UIView * backView =[[UIView alloc]initWithFrame:CGRectMake(0, -500, KScreenWidth, 500)];
    backView.backgroundColor =[UIColor colorWithRed:0.1 green:0.75 blue:0.7 alpha:1];
    [self.meTableView addSubview:backView];
    
    //头部视图初始化
    self.headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/3)];
    self.headView.backgroundColor =[UIColor colorWithRed:0.1 green:0.75 blue:0.7 alpha:1];
    [self.meTableView setTableHeaderView:self.headView];
    
    //头部视图图片初始化
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    self.headImage.center =CGPointMake(self.headView.center.x, self.headView.center.y-KScreenHeight/20);
//    self.headImage.backgroundColor =[UIColor whiteColor];
    self.headImage.clipsToBounds=YES;
    self.headImage.layer.cornerRadius=45;
    [self.headView addSubview:self.headImage];
    
    //用户名显示框
    self.userNameLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    self.userNameLable.center =CGPointMake(self.headImage.center.x, self.headImage.center.y+70);
    self.userNameLable.textAlignment =NSTextAlignmentCenter;
    self.userNameLable.textColor =[UIColor whiteColor];
//    self.userNameLable.backgroundColor =[UIColor whiteColor];
    [self.headView addSubview:self.userNameLable];
    
    //登陆按钮
    self.loginBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginBtn.frame =CGRectMake(0, 0, KScreenWidth, self.headView.frame.size.height);
    [self.loginBtn addTarget:self action:@selector(logins) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.loginBtn];
    
    self.hud=[[MBProgressHUD alloc] initWithView:self.view];
    self.hud.mode=MBProgressHUDModeCustomView;
    UIImageView *loadView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    NSData *imgData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
    loadView.image=[UIImage sd_animatedGIFWithData:imgData];
    self.hud.customView=loadView;
    self.hud.detailsLabelText=@"努力加载中";
    self.hud.detailsLabelColor=[UIColor blackColor];
    self.hud.color=[UIColor clearColor];
    [self.view addSubview:self.hud];
}



#pragma mark TableView设置

//分区设置
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

//行数设置
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    if (section ==1) {
        return 1;
    }
    if (section ==2) {
        return 1;
    }
    else{
        return 2;
    }
}



//单元格设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeTableViewCell * cell =[[MeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    if (indexPath.section ==1) {
        if (indexPath.row==0){
            cell.contentLable.text =@"我的消息";
            cell.iconImage.image=[UIImage imageNamed:@"我的消息.png"];
        }
        if (indexPath.row==2) {
            cell.view1.hidden =YES;
        }
    }
    else if (indexPath.section ==2) {
        cell.view1.hidden =YES;
        cell.contentLable.text =@"清除缓存";
         UILabel *sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100-20, 12, 100, 20)];
        sizeLabel.textAlignment=NSTextAlignmentRight;
        sizeLabel.font=[UIFont systemFontOfSize:14];
        sizeLabel.text=[self getImageCaCheSize];
        cell.iconImage.image=[UIImage imageNamed:@"清除缓存.png"];
        cell.accessoryView=sizeLabel;
    }
    else if (indexPath.section ==3) {
        if (indexPath.row==0) {
            cell.contentLable.text =@"意见反馈";
            cell.iconImage.image=[UIImage imageNamed:@"意见反馈.png"];
        }
        else{
            cell.contentLable.text =@"关于";
            cell.iconImage.image=[UIImage imageNamed:@"关于.png"];
        }
        if (indexPath.row==1) {
            cell.view1.hidden =YES;
        }
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1) {
        if (indexPath.row==0){
            //已登录
            if ([BmobUser getCurrentUser])
            {
                AppDelegate *tmpDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                tmpDelegate.mainTBC.meVc.tabBarItem.badgeValue=nil;
                tmpDelegate.messageCount=0;
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                BmobQuery *query=[BmobQuery queryWithClassName:@"msgCount"];
                [query whereKey:@"username" equalTo:[BmobUser getCurrentUser]];
                //                [query includeKey:@"username"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (array.count>0) {
                        BmobObject *obj=array[0];
                        [obj setObject:[NSNumber numberWithInteger:0] forKey:@"messageCount"];
                        [obj updateInBackground];
                    }
                    
                }];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"messageCount"];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                NewsViewController *news=[[NewsViewController alloc] init];
                news.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:news animated:YES];
            }
            //未登录
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag=111;
                [alert show];
            }
        }
    }
    else if (indexPath.section ==2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:@"清除后无法恢复,确定清除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=109;
        [alert show];

    }
    else if (indexPath.section ==3) {
        if (indexPath.row==0) {
            //已登录
            if ([BmobUser getCurrentUser])
            {
                SuggestViewController *suggest=[[SuggestViewController alloc] init];
                [self.navigationController pushViewController:suggest animated:YES];
            }
            //未登录
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag=111;
                [alert show];
            }

        }
        else{
            //关于
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"产品版本号" message:@"1.0.0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}


#pragma mark 登陆按钮方法
-(void)logins
{
//    NSLog(@"登陆按钮");
    //已登录
    if ([BmobUser getCurrentUser])
    {
        MyLoginViewController *loginVc=[[MyLoginViewController alloc] init];
        loginVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    //未登录 
    else
    {
        LoginViewController *loginVc=[[LoginViewController alloc] init];
        loginVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==109) {
        if (buttonIndex==1) {
            //使用SDWebImage内部的方法进行清除缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                //刷新表视图
                [self.meTableView reloadData];
            }];
        }
    }
    else if (alertView.tag==111) {
        if (buttonIndex==1) {
            LoginViewController *loginVc=[[LoginViewController alloc] init];
            loginVc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVc animated:YES];
            
        }
    }
}

#pragma mark - 计算当前应用程序缓存图片的大小
- (NSString *)getImageCaCheSize
{
    long long sum = 0;
    // 1.获取缓存图片所在的文件地址
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.hackemist.SDWebImageCache.default"];
    // 2.计算文件的大小
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 01 获取当前文件夹下所有的文件
    NSArray *subPaths = [fileManager subpathsAtPath:filePath];
    // 遍历所有图片的路径
    for (NSString *subPath in subPaths) {
        // 获取图片的完整路径
        NSString *imagePath = [filePath stringByAppendingPathComponent:subPath];
        // 获取当前图片的大小
        NSDictionary *imageDic = [fileManager attributesOfItemAtPath:imagePath error:nil];
        sum += [imageDic fileSize];
    }
    return [NSString stringWithFormat:@"%.2fM",sum / (1000.0 *1000.0)];
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
