//
//  MyLoginViewController.m
//  RentBike
//
//  Created by wang on 15/10/23.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "MyLoginViewController.h"
#import "MeViewController.h"
#import "PassWordViewController.h"
#import "LoginViewController.h"
@interface MyLoginViewController ()
@property(assign,nonatomic)BOOL isQQLogin;
@end

@implementation MyLoginViewController

-(void)loadData{
    //判断是否登陆
    if ([BmobUser getCurrentUser])
    {
        BmobQuery *query=[BmobQuery queryForUser];
        [query getObjectInBackgroundWithId:[BmobUser getCurrentUser].objectId block:^(BmobObject *object, NSError *error) {
            //头像是否存在
            if (![[object objectForKey:@"iconImg"] isEqualToString:@""]||[object objectForKey:@"iconImg"])
            {
                NSDictionary *headDic=@{@"head":[object objectForKey:@"iconImg"]};
                [self.dataArr replaceObjectAtIndex:0 withObject:headDic];
            }
            //用户名是否存在
            if ([object objectForKey:@"name"])
            {
                NSDictionary *nameDic=@{@"UserName":[object objectForKey:@"name"]};
                [self.dataArr replaceObjectAtIndex:1 withObject:nameDic];
            }
            //手机号是否存在
            if ([object objectForKey:@"mobilePhoneNumber"])
            {
                NSMutableString *string=[NSMutableString stringWithString:[object objectForKey:@"mobilePhoneNumber"]];
                [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                NSString * str =[NSString stringWithFormat:@"已绑定手机号: %@",string];
                NSDictionary *phoneDic=@{@"PhoneNumber":str};
                [self.dataArr replaceObjectAtIndex:2 withObject:phoneDic];
            }
            if([object objectForKey:@"authData"]){
                self.isQQLogin=YES;
            }else{
                self.isQQLogin=NO;
            }
            //刷新
            [self.tableView reloadData];
            
        }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先登录" delegate:self cancelButtonTitle:@"立即登录" otherButtonTitles:@"取消", nil];
        alert.tag=1234;
        [alert show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的账户";
    //数据源
    UIImage *img=[UIImage imageNamed:@"head"];
    NSString * string =[NSString stringWithFormat:@"已绑定手机号  未绑定"];
    self.dataArr=[NSMutableArray arrayWithArray:@[@{@"head":img},@{@"UserName":[[BmobUser getCurrentUser] objectForKey:@"name"]},@{@"PhoneNumber":string}]];
    //初始化tableView
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.sectionHeaderHeight =0;
    self.tableView.sectionFooterHeight =0;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
//    [self.tableView setTableFooterView:self.logOutBtn];
    [self.view addSubview:self.tableView];
    self.hud=[[MBProgressHUD alloc] initWithView:self.view];
    self.hud.mode=MBProgressHUDModeDeterminate;
    [self.view addSubview:self.hud];
    
    //退出按钮
    self.logOutBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logOutBtn.frame=CGRectMake(30, KScreenHeight-70, KScreenWidth-60, 40);
    [self.logOutBtn setTitle:@"退出当前账户" forState:UIControlStateNormal];
    self.logOutBtn.backgroundColor =[UIColor whiteColor];
    [self.logOutBtn setTitleColor:[UIColor colorWithRed:0.988 green:0.294 blue:0.216 alpha:1.000] forState:UIControlStateNormal];
    [self.logOutBtn.layer setMasksToBounds:YES];
    [self.logOutBtn.layer setCornerRadius:3.0];
    [self.logOutBtn.layer setBorderWidth:1.0];
    self.logOutBtn.layer.borderColor =[UIColor colorWithWhite:0.7 alpha:0.5].CGColor;
    [self.logOutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logOutBtn];

}


#pragma mark tableView的实现
//分区设置
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else{
        if(self.isQQLogin){
            return 2;
        }
        return 4;
    }
}

//单元格设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyLoginViewCell * cell =[[MyLoginViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    //头像
    if (indexPath.row==0)
    {
        UIImageView * userImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenHeight/15-15, KScreenHeight/15-15)];
        if ([self.dataArr[0][@"head"] isKindOfClass:[UIImage class]])
        {
            userImage.image =self.dataArr[0][@"head"];
        }
        else{
            [userImage sd_setImageWithURL:[NSURL URLWithString:self.dataArr[0][@"head"]]];
        }
        cell.contentLable.text =@"修改头像";
        cell.accessoryView =userImage;
    }
    //用户名
    else if (indexPath.row==1)
    {
        cell.contentLable.text=@"修改用户名";
    }
    //手机号
    else if (indexPath.row==2)
    {
        cell.contentLable.text=@"修改账户密码";
    }
    else if (indexPath.row==3)
    {
        cell.accessoryType =UITableViewCellAccessoryNone;
        cell.contentLable.text=self.dataArr[2][@"PhoneNumber"];
        cell.view1.hidden =YES;
    }
    return cell;
}


//选择的单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark 头像的实现
    if(!self.isQQLogin){
        if(indexPath.row==0){
            //头像选择
            self.pickerController=[[UIImagePickerController alloc] init];
            self.pickerController.delegate=self;
            self.pickerController.allowsEditing=YES;
            UIActionSheet *actSheet=[[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
            [actSheet showInView:self.view];
        }
        //修改姓名
        else if(indexPath.row==1)
        {
            UserNameViewController * userNameView =[UserNameViewController new];
            userNameView.userNameStr =self.dataArr[1][@"UserName"];
            [self.navigationController pushViewController:userNameView animated:YES];
        }
        //修改密码
        else if (indexPath.row==2)
        {
            PassWordViewController *passWordVc=[[PassWordViewController alloc] init];
            [self.navigationController pushViewController:passWordVc animated:YES];
        }
    }
    
    
}


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KScreenHeight/15;
}


#pragma mark 退出按钮的实现
//按钮退出
-(void)logOut
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认退出吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=666;
    [alertView show];
}


#pragma mark alertView按键的实现
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==666)
    {
        //退出
        if (buttonIndex==1)
        {
            BmobUser *currentUser=[BmobUser getCurrentUser];
            [currentUser deleteForKey:@"deviceToken"];
            [currentUser updateInBackground];
            [BmobUser logout];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else if (alertView.tag==1234)
    {
        if (buttonIndex==0)
        {
            LoginViewController *loginVC=[[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


//实现图片选取
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex==0) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.pickerController.sourceType=sourceType;
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }
    else if (buttonIndex==1){
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.pickerController.sourceType=sourceType;
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }
    
}
//获取头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    NSLog(@"%@",info);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([BmobUser getCurrentUser]) {
            
            UIImage *head=info[@"UIImagePickerControllerEditedImage"];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [self.hud show:YES];
            NSData *data=UIImageJPEGRepresentation(head, 1);
            [BmobProFile uploadFileWithFilename:@"userheader" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
                BmobUser *currentUser=[BmobUser getCurrentUser];
                [currentUser setObject:file.url forKey:@"iconImg"];
                [currentUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                }];
                NSDictionary *headDic=@{@"head":file.url};
                [self.dataArr replaceObjectAtIndex:0 withObject:headDic];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
                MeViewController *vc=self.navigationController.viewControllers[0];
                [vc.headImage sd_setImageWithURL:[NSURL URLWithString:file.url]];
            } progress:^(CGFloat progress) {
                self.hud.progress=progress;
                if (progress==1) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
                    img.image=[UIImage imageNamed:@"37x-Checkmark"];
                    self.hud.customView=img;
                    self.hud.mode=MBProgressHUDModeCustomView;
                    self.hud.labelText=@"上传成功";
                    [self.hud hide:YES afterDelay:0.3];
                }
            }];
            
        }
    }];
    
}
//缓冲动画
-(void)userProgress:(NSNumber *)progress{
    
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
