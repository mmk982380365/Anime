//
//  ForgetPasswordViewController.m
//  Anime
//
//  Created by wkf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"忘记密码";
    
    [self creatView];
}
//创建子视图
- (void)creatView{

    //手机号框
    self.phoneNumTextField =[[UITextField alloc] initWithFrame:CGRectMake(20, 100, KScreenWidth-40, 40)];
    self.phoneNumTextField.placeholder =@"请输入手机号";
    self.phoneNumTextField.textColor =[UIColor blackColor];
    self.phoneNumTextField.delegate=self;
    self.phoneNumTextField.layer.borderWidth=1.0f;
    self.phoneNumTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneNumTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.phoneNumTextField.layer setCornerRadius:10];
    [self.view addSubview:self.phoneNumTextField];

    //验证码
    self.smsCodeTextField =[[UITextField alloc] initWithFrame:CGRectMake(20, 160, 150, 40)];
    self.smsCodeTextField.placeholder =@"请输入验证码";
    self.smsCodeTextField.textColor =[UIColor blackColor];
    self.smsCodeTextField.layer.borderWidth=1.0f;
    [self.smsCodeTextField.layer setCornerRadius:10];
    self.smsCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:self.smsCodeTextField];
    
    //验证码按钮
    self.smsCodeBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.smsCodeBtn.frame =CGRectMake(200, 160, KScreenWidth-230, 40);
    [self.smsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.smsCodeBtn.backgroundColor =[UIColor blueColor];
    self.smsCodeBtn.layer.cornerRadius =10.0;
    [self.smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.smsCodeBtn addTarget:self action:@selector(requestSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.smsCodeBtn];
    
    //密码
    self.userPwdTextField =[[UITextField alloc] initWithFrame:CGRectMake(20, 220, KScreenWidth-40, 40)];
    self.userPwdTextField.placeholder =@"请输入新6~16位密码";
    self.userPwdTextField.delegate=self;
    self.userPwdTextField.textColor =[UIColor blackColor];
    self.userPwdTextField.secureTextEntry=YES;
    self.userPwdTextField.returnKeyType=UIReturnKeyNext;
    self.userPwdTextField.layer.borderWidth=1.0f;
    [self.userPwdTextField.layer setCornerRadius:10];
    self.userPwdTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.userPwdTextField];
    
    //注册按钮
    self.submitBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitBtn.frame =CGRectMake(20, 300, KScreenWidth-40, 40);
    self.submitBtn.backgroundColor =[UIColor blueColor];
    self.submitBtn.tintColor =[UIColor whiteColor];
    self.submitBtn.layer.cornerRadius =10.0;
    [self.submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(confirmRegistration) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];

}

//请求验证码
-(void)requestSMSCode
{
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumTextField.text andTemplate:nil resultBlock:^(int number, NSError *error) {
        if (error) {
//                        NSLog(@"%@",error);
        } else {
        }
    }];
//        NSLog(@"发送验证码");
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
    [self.smsCodeBtn setTitle:@"已发送 60s" forState:UIControlStateNormal];
    [self.smsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.smsCodeBtn setEnabled:NO];
    [self.smsCodeBtn setBackgroundColor:[UIColor grayColor]];
    self.smsCodeBtn.layer.borderWidth =0;
    [self.smsCodeBtn setAlpha:0.7];
    self.time =60;
    
}

//验证码倒计时
-(void)daojishi
{
    self.time--;
    NSString *str =[NSString stringWithFormat:@"已发送 %ds",self.time];
    [self.smsCodeBtn setTitle:str forState:UIControlStateNormal];
    if (self.time==0) {
        [self.smsCodeBtn setAlpha:1.0];
        self.smsCodeBtn.layer.borderWidth =1;
        [self.smsCodeBtn setBackgroundColor:[UIColor blueColor]];
        [self.smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.smsCodeBtn setEnabled:YES];
        //时间控件停止
        [self.timer invalidate];
    }
}

//确认提交
-(void)confirmRegistration{
    //判断输入手机号是否为11位数字
    NSString *str =self.phoneNumTextField.text;
    NSString *regex =@"[0-9]{11}";
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (self.phoneNumTextField.text.length!=0&&![predicate evaluateWithObject:str]) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的手机号格式错误,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.phoneNumTextField.text.length==0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.smsCodeTextField.text.length==0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.userPwdTextField.text.length==0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.userPwdTextField.text.length>0 && self.userPwdTextField.text.length<6){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码为6~16位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //重置密码
        [BmobUser resetPasswordInbackgroundWithSMSCode:self.smsCodeTextField.text andNewPassword:self.userPwdTextField.text block:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
                //
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"输入验证码错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                //                NSLog(@"重置密码失败");
            }
        }];
    }

}
//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
