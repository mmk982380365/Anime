//
//  PassWordViewController.m
//  RentBike
//
//  Created by wang on 15/10/22.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()

@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改密码";
    //调用密码重置页面初始化方法
    [self initpasswordView];
}
//调用密码重置页面初始化方法
-(void)initpasswordView
{
    //底部视图
    UITableView * tableview =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableview];
    
    //当前密码
    self.currentPassword =[[UITextField alloc]initWithFrame:CGRectMake(15, 15, KScreenWidth-30, 40)];
    self.currentPassword.borderStyle =UITextBorderStyleRoundedRect;
    self.currentPassword.layer.cornerRadius=4;
    self.currentPassword.layer.borderWidth=1;
    self.currentPassword.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    self.currentPassword.placeholder =@"请输入当前密码";
    self.currentPassword.delegate =self;
    self.currentPassword.secureTextEntry=YES;
    self.currentPassword.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.currentPassword.returnKeyType =UIReturnKeyNext;
    self.currentPassword.tag =1;
    [tableview addSubview:self.currentPassword];
    
    //新密码1
    self.updatePassword1 =[[UITextField alloc]initWithFrame:CGRectMake(15, self.currentPassword.frame.origin.y+self.currentPassword.frame.size.height+15, self.currentPassword.frame.size.width, self.currentPassword.frame.size.height)];
    self.updatePassword1.borderStyle =UITextBorderStyleRoundedRect;
    self.updatePassword1.layer.cornerRadius=4;
    self.updatePassword1.layer.borderWidth=1;
    self.updatePassword1.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    self.updatePassword1.placeholder =@"请输入6-16位新密码";
    self.updatePassword1.delegate =self;
    self.updatePassword1.secureTextEntry=YES;
    self.updatePassword1.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.updatePassword1.returnKeyType =UIReturnKeyNext;
    self.updatePassword1.tag =2;
    [tableview addSubview:self.updatePassword1];
    
    //新密码2
    self.updatePassword2 =[[UITextField alloc]initWithFrame:CGRectMake(15, self.updatePassword1.frame.origin.y+self.updatePassword1.frame.size.height+15, self.currentPassword.frame.size.width, self.currentPassword.frame.size.height)];
    self.updatePassword2.borderStyle =UITextBorderStyleRoundedRect;
    self.updatePassword2.layer.cornerRadius=4;
    self.updatePassword2.layer.borderWidth=1;
    self.updatePassword2.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    self.updatePassword2.placeholder =@"确认新密码";
    self.updatePassword2.delegate =self;
    self.updatePassword2.secureTextEntry=YES;
    self.updatePassword2.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.updatePassword2.returnKeyType =UIReturnKeyGo;
    self.updatePassword2.tag =3;
    [tableview addSubview:self.updatePassword2];
    //添加点击事件
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];


    //密码提交按钮
    self.SubmitBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.SubmitBtn.frame =CGRectMake(15, self.updatePassword2.frame.origin.y+self.updatePassword2.frame.size.height+15, self.currentPassword.frame.size.width, self.currentPassword.frame.size.height);
    self.SubmitBtn.layer.cornerRadius=4;
    [self.SubmitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.SubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.SubmitBtn.backgroundColor =[UIColor colorWithWhite:0.55 alpha:0.5];
    [self.SubmitBtn addTarget:self action:@selector(passwordSubmit) forControlEvents:UIControlEventTouchUpInside];
    [tableview addSubview:self.SubmitBtn];
}


#pragma mark TextField设置

//键盘弹出
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==1) {
        textField.layer.borderColor =[UIColor colorWithRed:0.988 green:0.294 blue:0.216 alpha:0.5].CGColor;
        self.updatePassword1.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
        self.updatePassword2.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    }
    else if (textField.tag==2){
        textField.layer.borderColor =[UIColor colorWithRed:0.988 green:0.294 blue:0.216 alpha:0.5].CGColor;
        self.currentPassword.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
        self.updatePassword2.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    }
    else {
        textField.layer.borderColor =[UIColor colorWithRed:0.988 green:0.294 blue:0.216 alpha:0.5].CGColor;
        self.currentPassword.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
        self.updatePassword1.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    }
    return YES;
}

//点击空白部分隐藏键盘手势
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    self.currentPassword.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    self.updatePassword1.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    self.updatePassword2.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
    [self.view endEditing:YES];
}

//点击键盘返回按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==1) {
        [textField resignFirstResponder];
        textField.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
        [self.updatePassword1 becomeFirstResponder];
    }
    else if (textField.tag==2){
        [textField resignFirstResponder];
        textField.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
        [self.updatePassword2 becomeFirstResponder];
    }
    else {
        textField.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:0.3].CGColor;
        [textField resignFirstResponder];
        [self passwordSubmit];
    }
    return YES;
}

//密码提交
-(void)passwordSubmit
{
    //是否有空密码
    if (self.currentPassword.text.length==0||self.updatePassword1.text.length==0||self.updatePassword2.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码不能为空,请输入密码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    //是否两次输入不一致
    else if (![self.updatePassword1.text isEqualToString:self.updatePassword2.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"两次密码输入不同,请重新输入!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
    }
    //新旧密码是否相同
    else if ([self.currentPassword.text isEqualToString:self.updatePassword2.text])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新密码不能与原密码相同，请重新输入!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
    }
    //新密码格式是否正确
    else if (self.updatePassword2.text.length<6 || self.updatePassword2.text.length>16)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入符合正确格式(6-16位)的密码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    //确认修改密码
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确定新密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag=2222;
        [alert show];
    }
}
//弹窗的按键的实现
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2222){
        if (buttonIndex==1){
            [[BmobUser getCurrentUser] updateCurrentUserPasswordWithOldPassword:self.currentPassword.text newPassword:self.updatePassword2.text block:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful==YES){
//                NSLog(@"bbbbb");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
//                NSLog(@"%@",error);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"旧密码输入不正确(是否忽略大小写),请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                }
            }];
        }
    }
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
