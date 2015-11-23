//
//  WebViewController.m
//  10.28_t1_JS
//
//  Created by 马鸣坤 on 15/10/28.
//  Copyright (c) 2015年 lamco. All rights reserved.
//

#import "WebViewController.h"
#import "SJAvatarBrowser.h"
#import "SvGifView.h"
#import <ImageIO/ImageIO.h>

@interface WebViewController ()<UIWebViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate>
/**
 *  判断是否第一次读数据
 */
@property (assign,nonatomic) BOOL isLoad;
/**
 *  文本数据
 */
@property (strong,nonatomic) NSMutableArray *textArray;
/**
 *  图片数据
 */
@property (strong,nonatomic) NSMutableArray *imgArray;
/**
 *  新闻标题
 */
@property (strong,nonatomic) NSString *newsTitle;
/**
 *  主页面
 */
@property (strong,nonatomic) UIScrollView *mainView;
/**
 *  新闻标题标签
 */
@property (strong,nonatomic) UILabel *newsTitleLbl;
/**
 *  发布时间标签
 */
@property (strong,nonatomic) UILabel *timeLbl;
/**
 *  来源地标签
 */
@property (strong,nonatomic) UILabel *channelLbl;
/**
 *  作者前的标签
 */
@property (strong,nonatomic) UILabel *lbl;
/**
 *  作者标签
 */
@property (strong,nonatomic) UILabel *authorLbl;
/**
 *  图片界面
 */
@property (strong,nonatomic) UICollectionView *imageCollectionView;
/**
 *  内容界面
 */
@property (strong,nonatomic) UILabel *contentLbl;
/**
 *  加载视图
 */
@property (strong,nonatomic) MBProgressHUD *hud;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建视图
    [self createView];
}
//创建视图
-(void)createView{
    //创建数组
    self.textArray=[NSMutableArray arrayWithCapacity:0];
    self.imgArray=[NSMutableArray arrayWithCapacity:0];
    //初始化判断值
    self.isLoad=YES;
    //初始化读取界面
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.webView.delegate=self;
    self.webView.mediaPlaybackRequiresUserAction=NO;
    [self.view addSubview:self.webView];
    self.webView.hidden=YES;
    //初始化主视图
    self.mainView=[[UIScrollView alloc] initWithFrame:myRect(0, 64, 375, KScreenHeight-64)];
    self.mainView.backgroundColor=[UIColor whiteColor];
    self.mainView.contentSize=CGSizeMake(self.mainView.frame.size.width, 100);
    [self.view addSubview:self.mainView];
    //初始化标题标签
    self.newsTitleLbl=[[UILabel alloc] initWithFrame:myRect(margin, margin, 375-2*margin, 60)];
    self.newsTitleLbl.font=[UIFont systemFontOfSize:22];
    self.newsTitleLbl.textColor=[UIColor colorWithRed:0.141 green:0.561 blue:0.788 alpha:1.000];
    self.newsTitleLbl.numberOfLines=2;
    [self.mainView addSubview:self.newsTitleLbl];
    //初始化时间标签
    self.timeLbl=[[UILabel alloc] initWithFrame:myRect(margin, margin+60, 170, 30)];
    if (KScreenWidth==320) {
        self.timeLbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        self.timeLbl.font=[UIFont systemFontOfSize:13];
    }else{
        self.timeLbl.font=[UIFont systemFontOfSize:14];
    }
    //    self.timeLbl.font=Font(13);
    [self.mainView addSubview:self.timeLbl];
    //初始化发布平台标签
    self.channelLbl=[[UILabel alloc] initWithFrame:myRect(margin+170, margin+60, 80, 30)];
    if (KScreenWidth==320) {
        self.channelLbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        self.channelLbl.font=[UIFont systemFontOfSize:13];
    }else{
        self.channelLbl.font=[UIFont systemFontOfSize:14];
    }
    self.channelLbl.textColor=[UIColor orangeColor];
    [self.mainView addSubview:self.channelLbl];
    //初始化‘作者’标签
    self.lbl=[[UILabel alloc] initWithFrame:myRect(margin+250, margin+60, 30, 30)];
    if (KScreenWidth==320) {
        self.lbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        self.lbl.font=[UIFont systemFontOfSize:13];
    }else{
        self.lbl.font=[UIFont systemFontOfSize:14];
    }
    [self.mainView addSubview:self.lbl];
    //初始化发布作者标签
    self.authorLbl=[[UILabel alloc] initWithFrame:myRect(margin+280, margin+60, 75, 30)];
    if (KScreenWidth==320) {
        self.authorLbl.font=[UIFont systemFontOfSize:11];
    }else if(KScreenWidth==375){
        self.authorLbl.font=[UIFont systemFontOfSize:13];
    }else{
        self.authorLbl.font=[UIFont systemFontOfSize:14];
    }
    self.authorLbl.textColor=[UIColor orangeColor];
    [self.mainView addSubview:self.authorLbl];
    //初始化流式布局
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.itemSize=CGSizeMake(KScreenWidth*(355)/375.0, 0.618*KScreenWidth*(355)/375.0);
    layout.minimumInteritemSpacing=10*KScreenWidth/375.0;
    layout.minimumLineSpacing=10*KScreenWidth/375.0;
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 10*KScreenWidth/375.0);
    //初始化图片列表
    self.imageCollectionView=[[UICollectionView alloc] initWithFrame:myRect(margin, margin+90, 375-margin, 0.618*KScreenWidth*(375-2*margin)/375.0) collectionViewLayout:layout];
    self.imageCollectionView.showsHorizontalScrollIndicator=NO;
    self.imageCollectionView.pagingEnabled=YES;
    self.imageCollectionView.delegate=self;
    self.imageCollectionView.dataSource=self;
    self.imageCollectionView.backgroundColor=[UIColor clearColor];
    self.imageCollectionView.backgroundView=nil;
    [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    [self.mainView addSubview:self.imageCollectionView];
    //初始化内容标签
    if (KScreenWidth<375) {
        self.contentLbl=[[UILabel alloc] initWithFrame:myRect(margin, margin+90+(375-2*margin)*0.618, 375-2*margin, 0)];
    }else{
        self.contentLbl=[[UILabel alloc] initWithFrame:myRect(margin, 3*margin+90+(375-2*margin)*0.618, 375-2*margin, 0)];
    }
    self.contentLbl.numberOfLines=0;
    self.contentLbl.font=[UIFont systemFontOfSize:16];
    [self.mainView addSubview:self.contentLbl];
    //初始化加载视图
    self.hud=[[MBProgressHUD alloc] initWithView:self.view];
    self.hud.mode=MBProgressHUDModeCustomView;
    UIImageView *loadingView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    loadingView.image=[UIImage sd_animatedGIFNamed:@"loading"];
    self.hud.customView=loadingView;
    self.hud.color=[UIColor clearColor];
    self.hud.detailsLabelText=@"正在努力加载中";
    self.hud.detailsLabelColor=[UIColor blackColor];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

#pragma mark collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArray.count;//图片个数
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier=@"imgCell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:myRect(0, 0, 355, 0.618*KScreenWidth*(355)/375.0)];//加载图片
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"iconfont-tupian"]];
    [cell.contentView addSubview:imgView];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    if ([(UIImageView *)cell.contentView.subviews[0] image]) {
        [SJAvatarBrowser showImage:cell.contentView.subviews[0]];//点击放大图片
    }
}

//-(void)carousel:(iCarousel * __nonnull)carousel didSelectItemAtIndex:(NSInteger)index{
//    if ([(UIImageView *)carousel.currentItemView.subviews[0] image]) {
//        [SJAvatarBrowser showImage:carousel.currentItemView.subviews[0]];
//    }
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView loadRequest:self.request];
}





#pragma mark webView代理
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([webView.request.URL.absoluteString isEqualToString:self.webView.request.URL.absoluteString]) {
        if (self.isLoad) {
            self.isLoad=NO;
            NSString *jsStr=[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('newstext')[0].childNodes.length"];
            for (int i=0; i<[jsStr intValue]; i++) {
                NSString *jsStr2=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('newstext')[0].childNodes[%d].nodeName",i]];//获取标签
                if ([jsStr2 isEqualToString:@"P"]) {
                    NSString *jsStr3=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('newstext')[0].childNodes[%d].childNodes[0].nodeValue",i]];//获取正文内容
                    if (![jsStr3 isEqualToString:@""]) {
                        [self.textArray addObject:jsStr3];
                    }
                    NSString *jsStr6=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('newstext')[0].childNodes[%d].childNodes[0].src",i]];//获取正文图片
                    if (![jsStr6 isEqualToString:@""]) {
                        [self.imgArray addObject:jsStr6];
                    }
                }
            }
            NSString *content=[self.textArray componentsJoinedByString:@"\n"];//拼接正文
            NSString *jsStr7=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('title')[0].childNodes[3].childNodes[0].nodeValue"]];//正文标题获取
            self.newsTitle=jsStr7;
            self.title=self.newsTitle;
            self.newsTitleLbl.text=self.newsTitle;
            NSString *jsStr8=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('source_text').childNodes[1].childNodes[0].nodeValue"]];//正文时间获取
            self.timeLbl.text=jsStr8;
            NSString *jsStr9=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('source_text').childNodes[1].childNodes[1].childNodes[0].nodeValue"]];//正文发布平台获取
            self.channelLbl.text=jsStr9;
            self.lbl.text=@"作者:";
            NSString *jsStr10=[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('source_text').childNodes[1].childNodes[3].childNodes[0].nodeValue"]];//正文发布作者获取
            self.authorLbl.text=jsStr10;
            CGSize contentSize=[content boundingRectWithSize:CGSizeMake(KScreenWidth*(375-2*margin)/375.0, 111111) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;//获取正文高度
                self.contentLbl.frame=CGRectMake(KScreenWidth*(margin)/375.0, 2*margin+90+KScreenWidth*0.618*(375-2*margin)/375.0, contentSize.width, contentSize.height);//刷新界面大小
                self.mainView.contentSize=CGSizeMake(KScreenWidth, 3*margin+90+0.618*KScreenWidth*(375-2*margin)/375.0+contentSize.height);
            self.contentLbl.text=content;//显示正文
            [self.imageCollectionView reloadData];//刷新图片数组
            [self.hud hide:YES];//隐藏加载视图
        }
    }
    
}
-(void)dealloc{
    //销毁网页
    self.webView=nil;
}
//-(void)setRequest:(NSURLRequest *)request{
//    _request=request;
//    
//}

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
