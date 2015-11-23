//
//  UserNameViewController.m
//  Anime
//
//  Created by wood on 15/10/28.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "UserNameViewController.h"

@interface UserNameViewController ()

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"修改用户名";
    UIBarButtonItem * rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(updateUserName)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    UITableView * tableView =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    //容器视图
    self.aview =[[UIView alloc]initWithFrame:CGRectMake(20, 20, KScreenWidth-40, 50)];
    self.aview.layer.cornerRadius=4;
    self.aview.layer.borderWidth=1;
    self.aview.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    self.aview.backgroundColor =[UIColor whiteColor];
    [tableView addSubview:self.aview];
    
    //Lable
    UILabel * lable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.aview.frame.size.width/4, self.aview.frame.size.height)];
    lable.textAlignment =NSTextAlignmentCenter;
    lable.font =[UIFont boldSystemFontOfSize:20];
    lable.text =@"用户名:";
    [self.aview addSubview:lable];
    
    //用户名修改框
    self.userText =[[UITextField alloc]initWithFrame:CGRectMake(lable.frame.size.width, 0, self.aview.frame.size.width*0.75, self.aview.frame.size.height)];
    self.userText.text =self.userNameStr;
    self.userText.delegate =self;
    self.userText.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.userText.placeholder =@"限16个字符以内且不能为空";
    self.userText.returnKeyType =UIReturnKeyDone;
    [self.aview addSubview:self.userText];
    //添加点击事件
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
}


#pragma mark TextField设置
//点击空白部分隐藏键盘手势
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    self.aview.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    [self.view endEditing:YES];
}

//点击回车隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.aview.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

//键盘弹出
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.aview.layer.borderColor =[UIColor colorWithRed:0.988 green:0.294 blue:0.216 alpha:0.5].CGColor;
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 确定按钮设置
-(void)updateUserName{
    NSString *str=self.userText.text;
    if ([self charaCount:str]>16) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名限16个字符以内(汉字算2个字符),请重新输入!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([self charaCount:str]==0){
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名不能为空!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        BmobUser *currentUser=[BmobUser getCurrentUser];
        [currentUser setObject:str forKey:@"name"];
        
        [currentUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (error)
            {
//                NSLog(@"%@",error);
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}


#pragma mark 统计字符长度
-(int)charaCount:(NSString *)str {
    int countChinese=0;
    int countEnglish=0;
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            countChinese+=2;
        }else{
            countEnglish++;
        }
    }
    return countEnglish+countChinese;
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
