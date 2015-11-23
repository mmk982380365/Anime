//
//  CommunityViewController.m
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommentViewController.h"
#import "PublishViewController.h"
#import "Social.h"
#import "LoginViewController.h"

@interface CommunityViewController ()
/**
 *  加载视图
 */
@property (strong,nonatomic) MBProgressHUD *hud;
/**
 *  是否刷新
 */
@property (assign,nonatomic) BOOL isRefreshing;
@end

@implementation CommunityViewController
static int pages = 1;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.isRefreshing=YES;
    [self loadData];
    
}
//读取数据
-(void)loadData
{
    self.isRefreshing=YES;
    [self searchData];
}

//下拉刷新方法
-(void)getMore
{
    if (self.isSearch) {
        
    }else
    {
        BmobQuery *query=[BmobQuery queryWithClassName:@"Social"];
        //声明该次查询需要将username关联对象信息一并查询出来
        [query includeKey:@"username"];
        //按updateAt进行降序排序
        [query orderByDescending:@"createdAt"];
        query.limit=10;
        query.skip=self.dataArray.count;
        NSMutableArray *result=[NSMutableArray arrayWithCapacity:0];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                Social *social=[[Social alloc] initFromBmobOjbect:obj];
                [result addObject:social];
            }
            [self.dataArray addObjectsFromArray:result];
            //刷新列表
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            if (array.count>0) {
                pages++;
            }
        }];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"漫区";
    [self createViews];
}
//发布帖子
-(void)fabiao
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        PublishViewController *publishVC=[[PublishViewController alloc] init];
        publishVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:publishVC animated:YES];

    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录以后即可发帖" delegate:self cancelButtonTitle:@"立即登录" otherButtonTitles:@"取消", nil];
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
//        NSLog(@"进入登陆页");
        LoginViewController *loginVc=[[LoginViewController alloc] init];
        loginVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVc animated:YES];
    }else if (buttonIndex==1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)hideKeyboard{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}
//创建视图
-(void)createViews
{
    //UITableView
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource =self;
    //下拉刷新
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //上拉刷新
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchData)];
    self.tableView.header=header;
    self.tableView.footer=footer;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:self.tableView];
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-114)];
    bgView.alpha=0.08;
    bgView.image=[UIImage imageNamed:@"homepage_background"];
    [self.view addSubview:bgView];
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    self.searchArray=[NSMutableArray arrayWithCapacity:0];
    //搜索栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, WIDTH/1.34, 35)];//allocate titleView
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.frame = CGRectMake(0, 0, WIDTH/1.34, 35);
    self.searchBar.layer.cornerRadius = 18;
    self.searchBar.layer.masksToBounds = YES;
    //    self.searchBar.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [self.searchBar.layer setBorderWidth:8];
    [self.searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    self.searchBar.placeholder = @"|搜索你想的东西";
    [titleView addSubview:self.searchBar];
    //键盘工具栏
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    UIBarButtonItem *hide=[[UIBarButtonItem alloc] initWithTitle:@"隐藏" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)];
    UIBarButtonItem *fixed=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items=@[fixed,hide];
    self.searchBar.inputAccessoryView=toolBar;
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    //发表按钮
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"发贴" style:UIBarButtonItemStylePlain target:self action:@selector(fabiao)];
    self.navigationItem.rightBarButtonItem=right;
    //加载视图
    UIImageView *loadView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    NSData *imgData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
    loadView.image=[UIImage sd_animatedGIFWithData:imgData];
    self.hud.customView=loadView;
    self.hud.detailsLabelColor=[UIColor grayColor];
    self.hud.detailsLabelText=@"努力加载中";
    self.hud.backgroundColor=[UIColor clearColor];
    self.hud.color=[UIColor clearColor];
    [self.hud show:YES];
    [self.view addSubview:self.hud];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.searchArray.count;
    }
    return self.dataArray.count;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置静态关键字
    static NSString *identifer =@"cell";
    CommunityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell ==nil) {
        cell=[[CommunityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    //设置显示内容
    if (self.isSearch) {
        cell.model=self.searchArray[indexPath.row];
    }else{
         cell.model=self.dataArray[indexPath.row];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击进入详情
    if (self.isSearch) {
        CommentViewController *commentVC=[[CommentViewController alloc] init];
        commentVC.hidesBottomBarWhenPushed=YES;
        commentVC.model =self.searchArray[indexPath.row];
        [self.navigationController pushViewController:commentVC animated:YES];
    }else{
        CommentViewController *commentVC=[[CommentViewController alloc] init];
        commentVC.hidesBottomBarWhenPushed=YES;
        commentVC.model =self.dataArray[indexPath.row];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
-(void)searchData{
    //模糊查询
    BmobQuery *query=[BmobQuery queryWithClassName:@"Social"];
    //声明该次查询需要将username关联对象信息一并查询出来
    [query includeKey:@"username"];
    //按updateAt进行降序排序
    [query orderByDescending:@"createdAt"];
    //正则表达搜查询
    NSMutableArray *tmparr=[NSMutableArray array];
    for (int i=0; i<self.searchBar.text.length; i++) {
        NSString *tmpStr=[self.searchBar.text substringWithRange:NSMakeRange(i, 1)];
        [tmparr addObject:tmpStr];
    }
    NSString *res=[tmparr componentsJoinedByString:@".*"];
    [query whereKey:@"content" matchesWithRegex:res];
    query.limit=10;
    if (self.isRefreshing) {
        query.skip=0;
    }else{
        query.skip=self.dataArray.count;
    }
    NSMutableArray *result=[NSMutableArray arrayWithCapacity:0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (self.isRefreshing) {
            [self.dataArray removeAllObjects];
            self.isRefreshing=NO;
        }
        for (BmobObject *obj in array) {
            Social *social=[[Social alloc] initFromBmobOjbect:obj];
            [result addObject:social];
        }
        [self.dataArray addObjectsFromArray:result];
        //刷新列表
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.isRefreshing=YES;
    [self searchData];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    self.isSearch=YES;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
