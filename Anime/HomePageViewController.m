//
//  HomePageViewController.m
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageTableViewCell.h"
#import "WebViewController.h"
#import "News.h"
#import "SvGifView.h"
#import "HGWaterFlow.h"
#import "VideoListCollectionViewCell.h"
#import "MovingView.h"
#import "SDWebImageManager.h"
#import "AnimateViewController.h"

typedef NS_ENUM(NSInteger, HomeType) {
    HomeTypeNews,
    HomeTypeVideoList
};

@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,HGWaterFlowDelegate,MovingViewDelegate>
@property (strong,nonatomic) UISegmentedControl *seg;
/**
 *  显示动漫咨询的列表
 */
@property (strong,nonatomic) UITableView *tableView;
/**
 *  动漫咨询数据源
 */
@property (strong,nonatomic) NSMutableArray *arrayData;
/**
 *  自适应高度所需数组
 */
@property (strong,nonatomic) NSMutableArray *cellData;
/**
 *  新番列表数据源
 */
@property (strong,nonatomic) NSMutableArray *dataArray;
/**
 *  新番列表单元格数组
 */
@property (strong,nonatomic) NSMutableArray *dataCell;
/**
 *  判断是否为刷新操作
 */
@property (assign,nonatomic) BOOL isRefresh;
/**
 *  列表类型
 */
@property (assign,nonatomic) HomeType homeType;
/**
 *  加载视图
 */
@property (strong,nonatomic) MBProgressHUD *hud;
/**
 *  新番列表
 */
@property (strong,nonatomic) UICollectionView *collectionView;
/**
 *  瀑布流视图
 */
@property (strong,nonatomic) HGWaterFlow *waterFlow;
/**
 *  可拖动的返回最上层按钮
 */
@property (strong,nonatomic) MovingView *movingView;
@end

@implementation HomePageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"漫讯";
    // Do any additional setup after loading the view.
    //获取当前月份
    NSDate *date=[NSDate date];
    NSDateFormatter *fm=[[NSDateFormatter alloc] init];
    [fm setDateFormat:@"MM"];
    NSString *monthStr=[fm stringFromDate:date];
    //通过月份判定几月番
    NSString *segTitle=@"1月新番";
    if ([monthStr intValue]>=1&&[monthStr intValue]<4) {
        segTitle=@"1月新番";
    }else if ([monthStr intValue]>=4&&[monthStr intValue]<7) {
        segTitle=@"4月新番";
    }else if ([monthStr intValue]>=7&&[monthStr intValue]<10) {
        segTitle=@"7月新番";
    }else if ([monthStr intValue]>=10) {
        segTitle=@"10月新番";
    }
    //导航栏选择器初始化
    self.seg=[[UISegmentedControl alloc] initWithItems:@[@"动漫资讯",segTitle]];
    self.seg.layer.cornerRadius=40;
    self.seg.selectedSegmentIndex=0;
    [self.seg addTarget:self action:@selector(segAct:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView=self.seg;
    //列表类型初始化
    self.homeType=HomeTypeNews;
    //是否刷新初始化
    self.isRefresh=NO;
    //数组初始化
    self.arrayData=[NSMutableArray arrayWithCapacity:0];
    self.cellData=[NSMutableArray arrayWithCapacity:0];
    
    //瀑布流布局初始化
    self.waterFlow=[[HGWaterFlow alloc] init];
    self.waterFlow.delegate=self;
    self.waterFlow.rowMargin=5;
    self.waterFlow.columnMargin=5;
    self.waterFlow.columsCount=2;
    self.waterFlow.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    //新番列表初始化
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.waterFlow];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    //新番列表背景图
    UIImageView *backgroundView=[[UIImageView alloc] initWithFrame:myRect(0, 0, 375, KScreenHeight)];
    backgroundView.image=[UIImage imageNamed:@"homepage_background"];
    backgroundView.alpha=0.08;
    backgroundView.contentMode=UIViewContentModeScaleToFill;
    self.collectionView.backgroundView=backgroundView;
    [self.collectionView registerClass:[VideoListCollectionViewCell class] forCellWithReuseIdentifier:@"videocell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.hidden=YES;
    //读取数据
    [self loadData];
    //资讯列表初始化
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-114) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    //资讯列表背景图
    UIImageView *backgroundView2=[[UIImageView alloc] initWithFrame:myRect(0, 0, 375, KScreenHeight)];
    backgroundView2.image=[UIImage imageNamed:@"homepage_background"];
    backgroundView2.alpha=0.08;
    backgroundView2.contentMode=UIViewContentModeScaleToFill;
    self.tableView.backgroundView=backgroundView2;
    self.tableView.backgroundColor=[UIColor clearColor];
    
    //下拉刷新初始化
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    //添加上拉刷新
    MJRefreshBackGifFooter *footer=[MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];
    self.tableView.footer=footer;
    
    self.tableView.header=header;
    //加载视图初始化
    self.hud=[[MBProgressHUD alloc] initWithView:self.tableView];
    self.hud.mode=MBProgressHUDModeCustomView;
    [self.tableView addSubview:self.hud];
    UIImageView *loadView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    //设置gif图片
    NSData *imgData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
    loadView.image=[UIImage sd_animatedGIFWithData:imgData];
    self.hud.customView=loadView;
    self.hud.detailsLabelColor=[UIColor grayColor];
    self.hud.detailsLabelText=@"努力加载中";
    self.hud.backgroundColor=[UIColor clearColor];
    self.hud.color=[UIColor clearColor];
    //显示加载视图
    [self.hud show:YES];
    //从本地数据库读取新闻信息
    [self loadDataFromDb];
    
    //初始化可拖动按钮
    self.movingView=[[MovingView alloc] initWithFrame:CGRectMake(KScreenWidth-60, KScreenHeight-120, 50, 50) buttonType:UIButtonTypeCustom];
    [self.movingView setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    self.movingView.alpha=0.6;
    self.movingView.delegate=self;
    [self.view addSubview:self.movingView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取当前月份
    NSDate *date=[NSDate date];
    NSDateFormatter *fm=[[NSDateFormatter alloc] init];
    [fm setDateFormat:@"MM"];
    NSString *monthStr=[fm stringFromDate:date];
    //通过月份判断几月番
    NSString *segTitle;
    if ([monthStr intValue]>=1&&[monthStr intValue]<4) {
        segTitle=@"1月新番";
    }else if ([monthStr intValue]>=4&&[monthStr intValue]<7) {
        segTitle=@"4月新番";
    }else if ([monthStr intValue]>=7&&[monthStr intValue]<10) {
        segTitle=@"7月新番";
    }else if ([monthStr intValue]>=10) {
        segTitle=@"10月新番";
    }
    //设置标题
    [self.seg setTitle:segTitle forSegmentAtIndex:1];
}
//从网络数据库加载数据
-(void)loadNewsData{
    //新建查询
    BmobQuery *query=[News query];
    query.limit=14;
    //分页查询
    if (self.isRefresh) {
        query.skip=0;
    }else{
        query.skip=self.arrayData.count;
    }
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //按照条件确定是否删除数组元素
        if (self.isRefresh) {
            self.isRefresh=NO;
            [self.arrayData removeAllObjects];
            [self.cellData removeAllObjects];
            //删除本地数据库内容
            [self deleteDb];
        }
        //加载数据
        for (BmobObject *object in array) {
            News *news=[[News alloc] initFromBmobOjbect:object];
            [self.arrayData addObject:news];
            HomePageTableViewCell *cell=[[HomePageTableViewCell alloc] init];
            cell.model=news;
            [self.cellData addObject:@(cell.cellHeight)];
            //保存数据到本地数据库
            NSDictionary *dic=@{@"title":news.title,@"link":news.link,@"imgUrl":news.imgUrl,@"content":news.content,@"titleData":news.titleData};
            //将数据写入本地数据库
            [self writeDB:dic];
            
        }
        //刷新列表
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        //隐藏加载状态
        [self.hud hide:YES];
    }];
}
//从本地数据库读取数据
-(void)loadDataFromDb{
    //获取数据库路径
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *toPath=[path stringByAppendingPathComponent:@"Anime.sqlite"];
    //创建数据库对象
    FMDatabaseQueue *db=[FMDatabaseQueue databaseQueueWithPath:toPath];
    //打开数据库
    [db inDatabase:^(FMDatabase *db) {
        //通过sql语句获取数据
        NSString *sql=[NSString stringWithFormat:@"select * from Homepages"];
        //获取查询结果
        FMResultSet *rs=[db executeQuery:sql];
        while ([rs next]) {
            NSString *title=[rs stringForColumn:@"title"];
            NSString *link=[rs stringForColumn:@"link"];
            NSString *imgUrl=[rs stringForColumn:@"imgUrl"];
            NSString *content=[rs stringForColumn:@"content"];
            NSString *time=[rs stringForColumn:@"time"];
            NSString *channel=[rs stringForColumn:@"channel"];
            NSString *author=[rs stringForColumn:@"author"];
            NSData *imgData=[rs dataForColumn:@"img"];
            NSDictionary *title_data=@{@"time":time,@"channel":channel,@"author":author};
            NSDictionary *dic;
            if (imgData) {
                dic=@{@"title":title,@"link":link,@"imgUrl":imgUrl,@"content":content,@"titleData":title_data,@"img":imgData};
            }else{
               dic=@{@"title":title,@"link":link,@"imgUrl":imgUrl,@"content":content,@"titleData":title_data}; 
            }
            
            //将获取的元素写入模型
            News *news=[[News alloc] initWithDictionary:dic];
            //将模型加入数组
            [self.arrayData addObject:news];
            //获取单元格高度
            HomePageTableViewCell *cell=[[HomePageTableViewCell alloc] init];
            cell.model=news;
            [self.cellData addObject:@(cell.cellHeight)];
        }
        //刷新界面
        if (self.arrayData.count==0) {
            [self.hud show:YES];
            [self refreshData];
        }else{
            [self.tableView reloadData];
            [self.hud hide:YES];
        }
    }];
}
//获取动漫新番列表数据
-(void)loadData{
    self.dataArray=[NSMutableArray arrayWithCapacity:0];//数组初始化
    self.dataCell=[NSMutableArray arrayWithCapacity:0];
    BmobQuery *query=[Animate query];//查询数据
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *object in array) {//获取数据
            Animate *model=[[Animate alloc] initFromBmobOjbect:object];
            [self.dataArray addObject:model];
            VideoListCollectionViewCell *cell=[[VideoListCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-5-2*10)/2.0, 0)];
            cell.model=model;
            [self.dataCell addObject:cell];//获取单元格高度
        }
        [self.collectionView reloadData];//刷新视图
    }];
}
#pragma mark movingView代理
-(void)buttonAction:(MovingView *)moving{
//    NSLog(@"top");
    //返回最上层
    if (self.tableView.hidden==NO) {
        if (self.arrayData.count!=0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else if (self.collectionView.hidden==NO){
        if (self.dataArray.count!=0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
    }
}
//导航栏的选择器时间控制
-(void)segAct:(UISegmentedControl *)seg{
    //显示资讯界面
    if (seg.selectedSegmentIndex==0) {
        
        self.tableView.hidden=NO;
        self.collectionView.hidden=YES;
    }
    //显示新番列表界面
    else{
        
        self.tableView.hidden=YES;
        self.collectionView.hidden=NO;
    }
}
//上拉刷新
-(void)getMore{
    //在小于30条记录前获取页面信息
    if (self.homeType==HomeTypeNews) {
        [self loadNewsData];
    }
}
//下拉刷新
-(void)refreshData{
    self.isRefresh=YES;
    [self loadNewsData];
}
#pragma mark collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;//数组个数
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier=@"videocell";
    VideoListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.model=self.dataArray[indexPath.item];//设置单元格显示
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击单元格跳转
    AnimateViewController *detailVc=[[AnimateViewController alloc] init];
    detailVc.hidesBottomBarWhenPushed=YES;
    detailVc.animate=self.dataArray[indexPath.item];
    [self.navigationController pushViewController:detailVc animated:YES];
}
#pragma mark waterFlow代理
-(CGFloat)waterFlow:(HGWaterFlow *)waterFlow heightForWidth:(CGFloat)width indexPath:(NSIndexPath *)indexPath{
    //返回每个单元格高度
    return [self.dataCell[indexPath.item] size].height;
}
#pragma mark tableView代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.homeType==HomeTypeNews) {
        HomePageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"homecell"];
        if (cell==nil) {
            cell=[[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homecell"];
        }
        //设置单元格背景
        cell.backgroundColor=[UIColor clearColor];
        //设置显示内容
        cell.model=self.arrayData[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"homecell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homecell"];
        }
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //返回数组个数
    if (self.homeType==HomeTypeNews) {
        return self.arrayData.count;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //返回每个单元格高度
    if (self.homeType==HomeTypeNews) {
        return [self.cellData[indexPath.row] floatValue];
    }else{
        return 100;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",[self.arrayData[indexPath.row] link]);
    //跳转资讯详情页面
    if (self.homeType==HomeTypeNews) {
        WebViewController *webVC=[[WebViewController alloc] init];
        webVC.request=[NSURLRequest requestWithURL:[NSURL URLWithString:[[self.arrayData[indexPath.row] link] stringByAppendingString:@"?pc=1"]]];
//        NSLog(@"%@",webVC.request.URL);
        webVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

//删除数据库中的内容
-(void)deleteDb{
    //获取数据库路径
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *toPath=[path stringByAppendingPathComponent:@"Anime.sqlite"];
    //创建数据库对象
    FMDatabaseQueue *db=[FMDatabaseQueue databaseQueueWithPath:toPath];
    //打开数据库
    [db inDatabase:^(FMDatabase *db) {
        //通过sql删除数据
        NSString *sql=[NSString stringWithFormat:@"delete from Homepages"];
        if ([db executeUpdate:sql]) {
//            NSLog(@"su");
        }
    }];
}
//写入数据库
-(void)writeDB:(NSDictionary *)dic{
    //获取数据库路径
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *toPath=[path stringByAppendingPathComponent:@"Anime.sqlite"];
    //创建数据库对象
    FMDatabaseQueue *db=[FMDatabaseQueue databaseQueueWithPath:toPath];
    //打开数据库
    [db inDatabase:^(FMDatabase *db) {
        //下载图片
        [[SDWebImageManager sharedManager] downloadImageWithURL:dic[@"imgUrl"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            NSData *data=UIImageJPEGRepresentation(image, 1);
            if (data) {
                //通过sql保存信息
                NSString *sql=[NSString stringWithFormat:@"insert into Homepages ('title','link','imgUrl','content','time','channel','author',img) values ('%@','%@','%@','%@','%@','%@','%@',?)",dic[@"title"],dic[@"link"],dic[@"imgUrl"],dic[@"content"],dic[@"titleData"][@"time"],dic[@"titleData"][@"channel"],dic[@"titleData"][@"author"]];
                if ([db executeUpdate:sql values:@[data] error:nil]) {
                    NSLog(@"sql suc");
                }
            }else{
                
                NSString *sql=[NSString stringWithFormat:@"insert into Homepages ('title','link','imgUrl','content','time','channel','author') values ('%@','%@','%@','%@','%@','%@','%@')",dic[@"title"],dic[@"link"],dic[@"imgUrl"],dic[@"content"],dic[@"titleData"][@"time"],dic[@"titleData"][@"channel"],dic[@"titleData"][@"author"]];
                if ([db executeUpdate:sql]) {
                    NSLog(@"sql suc");
                }
            }
            
        }];
        
        
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
