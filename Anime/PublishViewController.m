//
//  PublishViewController.m
//  Anime
//
//  Created by wang on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "PublishViewController.h"
#import <BmobSDK/BmobProFile.h>

@interface PublishViewController ()
@property(strong,nonatomic)NSMutableArray *urlArray;
@end

@implementation PublishViewController
//添加键盘监听事件
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    self.center =self.view.center;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"发帖";
    //初始化数组
    self.dataArr=[NSMutableArray arrayWithCapacity:0];
    
    //UICollection
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake((KScreenWidth-4*10)/3.0, (KScreenWidth-4*10)/3.0);
    layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=10;
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, (KScreenWidth-4*10)/3.0+20) collectionViewLayout:layout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.contentOffset=CGPointMake(0, 64);
    self.collectionView.scrollEnabled=NO;
    //图片选择器
    self.pickerController=[[UIImagePickerController alloc] init];
    self.pickerController.delegate=self;
    self.pickerController.allowsEditing=NO;
    
    //发布按钮
    UIBarButtonItem *publish=[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(Publish)];
    self.navigationItem.rightBarButtonItem=publish;
    
    //文本框
    self.commentTextView=[[UITextView alloc] initWithFrame:CGRectMake(0, self.collectionView.frame.size.height+self.collectionView.frame.origin.y, WIDTH, 175)];
    self.commentTextView.scrollEnabled=YES;
    self.commentTextView.editable=YES;
    self.commentTextView.layer.borderColor=[[UIColor grayColor] CGColor];
    self.commentTextView.layer.borderWidth=1;
    self.commentTextView.delegate=self;
    self.commentTextView.font=[UIFont fontWithName:@"Arial" size:18.0];
    self.commentTextView.returnKeyType=UIReturnKeyDefault;
    self.commentTextView.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.commentTextView];
    //UITextView没有UITextField中的提示语句属性placeholder
    self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 270, 40)];
    self.lab1.text = @"请输入您要发布的文字";
    self.lab1.backgroundColor = [UIColor clearColor];
    self.lab1.textColor = [UIColor lightGrayColor];
    if (self.commentTextView.text.length == 0) {
        self.lab1.hidden = NO;
    }else{
        self.lab1.hidden = YES;
    }
    [self.commentTextView addSubview:self.lab1];
    
    //背景颜色
    self.commentTextView.backgroundColor=[UIColor colorWithRed:253/255.0 green:245/255.0 blue:230/255.0 alpha:1.0];
    //隐藏键盘
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    UIBarButtonItem *hide=[[UIBarButtonItem alloc] initWithTitle:@"隐藏" style:UIBarButtonItemStyleDone target:self action:@selector(keyboardDidHidden:)];
    UIBarButtonItem *fixed=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items=@[fixed,hide];
    [self.commentTextView setInputAccessoryView:toolBar];
    
    //遮罩视图
    self.shadeView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.shadeView.backgroundColor=[UIColor blackColor];
    self.shadeView.alpha=0.0;
    [self.view addSubview:self.shadeView];
    //遮罩提醒
    self.hud=[[ MBProgressHUD alloc] initWithView:self.shadeView];
    self.hud.mode=MBProgressHUDModeAnnularDeterminate;
    [self.shadeView addSubview:self.hud];
    
}
#pragma mark 键盘的弹出
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject=[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:0.02];
    if (self.view.frame.size.width==320)
    {
        if ([self.commentTextView isFirstResponder]) {
            self.view.center=CGPointMake(self.center.x, self.center.y-145);
        }
        
    }
    [UIView commitAnimations];
}
#pragma mark 隐藏键盘
-(void)keyboardDidHidden:(NSNotification *)notification
{
    if ([self.commentTextView isFirstResponder]) {
        [self.commentTextView resignFirstResponder];
        self.view.center=self.center;
    }
}
#pragma mark 发布的实现
static int count=0;
-(void)Publish
{
    [self.commentTextView resignFirstResponder];
    
    
    
    
    //发布弹框
    if([self.commentTextView.text isEqualToString:@""]&&self.commentTextView.text.length==0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统通知" message:@"请输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=1110;
        [alert show];
    }
    else
    {
        //确认发布弹窗
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统通知" message:@"是否发布" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag=2222;
        [alert show];
    }
}
//按确认键发布成功
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1110)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
    else if (alertView.tag==1111)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag==2222)
    {
        if (buttonIndex==0)
        {
            //遮罩视图
            self.shadeView.alpha=0.5;
            //将HUD加到遮罩视图上
            
            self.hud.labelText=@"您的数据正在上传，请稍候";
            //有选择图片的帖子发布
            if (self.dataArr.count!=0)
            {
                count=0;
                self.urlArray=[NSMutableArray arrayWithCapacity:0];
                [self.hud show:YES];
                self.hud.progress=0;
                [self uploadImg];
                
                
            }
            else
            {
                //未添加图片的帖子发布
                BmobObject *post=[BmobObject objectWithClassName:@"Social"];
                BmobUser *currentUser=[BmobUser getCurrentUser];
                [post setObject:currentUser forKey:@"username"];
                [post setObject:self.commentTextView.text forKey:@"content"];
                [post setObject:@0 forKey:@"contentCount"];
                [self.hud hide:YES];
                [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful)
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统通知" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert.tag=1111;
                        [alert show];
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统通知" message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            }
        }
    }
    
}
//加载图片
-(void)uploadImg{
    //获取选择图片 并转换成NSData类型
    UIImage *str=self.dataArr[count];
    UIImage *scale=[self scaleImage:str toScale:0.5];
    NSData *data=UIImageJPEGRepresentation(scale, 1);
    [BmobProFile uploadFileWithFilename:@"picture" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        
            if (isSuccessful)
            {
                [self.urlArray addObject:file.url];
                count++;
                //若已上传个数小于总数，则继续上传
                if (count<self.dataArr.count) {
                    [self uploadImg];
                    
                }else{
                    //保存信息到BMOB服务器
                    BmobObject *post=[BmobObject objectWithClassName:@"Social"];
                    BmobUser *currentUser=[BmobUser getCurrentUser];
                    [post setObject:currentUser forKey:@"username"];
                    [post setObject:self.commentTextView.text forKey:@"content"];
                    [post setObject:@0 forKey:@"contentCount"];
                    [post setObject:self.urlArray forKey:@"picture"];
                    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        
                        
                    }];
                    //发布完成提示窗
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统通知" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag=1111;
                    [alert show];
                }
                //隐藏HUD
                
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统通知" message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        
    } progress:^(CGFloat progress) {
        //上传进度条
        float xx=progress/(float)self.dataArr.count;
//        NSLog(@"%.2f",xx);
        self.hud.progress=count/(float)self.dataArr.count+xx;
        
        if (self.hud.progress==1) {
            [self.hud hide:YES];
        }
    }];
    
    
    
}
//textView是否更改的方法
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        self.lab1.hidden = NO;
    }
    else
    {
        self.lab1.hidden = YES;
    }
}
#pragma mark collection的实现
//选择图片个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArr.count>2) {
        return self.dataArr.count;
    }else{
        return self.dataArr.count+1;
    }
    
}
//内容加载
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier=@"cell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor whiteColor];
    if (indexPath.item==self.dataArr.count) {
        //显示添加图片
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-4*10)/3.0, (KScreenWidth-4*10)/3.0)];
        imgView.image=[UIImage imageNamed:@"add"];
        [cell.contentView addSubview:imgView];
    }else{
        //显示选择图片
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth-4*10)/3.0, (KScreenWidth-4*10)/3.0)];
        imgView.image=self.dataArr[indexPath.item];
        [cell.contentView addSubview:imgView];
    }
    return cell;
}
//选择图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //取消第一响应
    [self.commentTextView resignFirstResponder];
    if (indexPath.item==self.dataArr.count) {
        //如果选择加号按钮 则进入选图模式
        UIActionSheet *actSheet=[[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
        [actSheet showInView:self.view];
    }
    //点击已选图片删除图片
    else{
        if (self.dataArr.count==3) {
            [self.dataArr addObject:[UIImage imageNamed:@"add"]];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:3 inSection:0]]];
            [self.dataArr removeObjectAtIndex:3];
            [self.dataArr removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }else{
            [self.dataArr removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        
    }
}
//选择图片按钮
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //选择使用相机还是相册
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex==0) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.pickerController.sourceType=sourceType;
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }else if (buttonIndex==1){
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.pickerController.sourceType=sourceType;
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
//图片选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.dataArr addObject:info[@"UIImagePickerControllerOriginalImage"]];
        if (self.dataArr.count<=2) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.dataArr.count-1 inSection:0]]];
        }else{
            [self.collectionView reloadData];
        }
    }];
}
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
