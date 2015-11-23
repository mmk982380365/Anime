//
//  RegisterView.m
//  Anime
//
//  Created by wkf on 15/10/27.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "RegisterView.h"
#import <BmobUser.h>
#import <BmobQuery.h>
#import <BmobSMS.h>
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define FieldHeight 40

@implementation RegisterView

//自定义初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor =[UIColor whiteColor];
        [self createViews];
    }
    return self;
}

//创建子视图
-(void)createViews{
    
    //用户名
    self.nameTextField =[[UITextField alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth-40, FieldHeight)];
    self.nameTextField.placeholder =@"用户名";
    self.nameTextField.textColor =[UIColor blackColor];
    self.nameTextField.delegate=self;
    self.nameTextField.layer.borderWidth=1.0f;
    self.nameTextField.returnKeyType=UIReturnKeyNext;
    self.nameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.nameTextField.layer setCornerRadius:10];
    [self addSubview:self.nameTextField];
    
    //手机号
    self.phoneNumTextField =[[UITextField alloc] initWithFrame:CGRectMake(20, 100, KScreenWidth-40, FieldHeight)];
    self.phoneNumTextField.placeholder =@"请输入手机号";
    self.phoneNumTextField.textColor =[UIColor blackColor];
    self.phoneNumTextField.delegate=self;
    self.phoneNumTextField.layer.borderWidth=1.0f;
    self.phoneNumTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneNumTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.phoneNumTextField.layer setCornerRadius:10];
    [self addSubview:self.phoneNumTextField];
    
    //密码
    self.userPwdTextField =[[UITextField alloc] initWithFrame:CGRectMake(20, 180, KScreenWidth-40, FieldHeight)];
    self.userPwdTextField.placeholder =@"请输入6~16位密码";
    self.userPwdTextField.delegate=self;
    self.userPwdTextField.textColor =[UIColor blackColor];
    self.userPwdTextField.secureTextEntry=YES;
    self.userPwdTextField.returnKeyType=UIReturnKeyNext;
    self.userPwdTextField.layer.borderWidth=1.0f;
    [self.userPwdTextField.layer setCornerRadius:10];
    self.userPwdTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self addSubview:self.userPwdTextField];
    
    
    //验证码
    self.smsCodeTextField =[[UITextField alloc] initWithFrame:CGRectMake(20, 260, KScreenWidth-100-40, FieldHeight)];
    self.smsCodeTextField.placeholder =@"请输入验证码";
    self.smsCodeTextField.textColor =[UIColor blackColor];
    self.smsCodeTextField.layer.borderWidth=1.0f;
    [self.smsCodeTextField.layer setCornerRadius:10];
    self.smsCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    [self addSubview:self.smsCodeTextField];
    
    //按钮
    self.smsCodeBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.smsCodeBtn.frame =CGRectMake(KScreenWidth-100, 260, 80, 40);
    [self.smsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.smsCodeBtn.backgroundColor =[UIColor blueColor];
    self.smsCodeBtn.layer.cornerRadius =5.0;
    [self.smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.smsCodeBtn addTarget:self action:@selector(requestSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.smsCodeBtn];
    
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.phoneNumTextField setInputAccessoryView:topView];
    [self  addSubview:self.phoneNumTextField];
    [self.smsCodeTextField setInputAccessoryView:topView];
    [self  addSubview:self.smsCodeTextField];
}

//获取验证码
-(void)requestSMSCode
{
    //判断输入手机号是否为11位数字
    NSString *str =self.phoneNumTextField.text;
    NSString *regex =@"[0-9]{11}";
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (self.phoneNumTextField.text.length!=0&&![predicate evaluateWithObject:str]) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的手机号格式错误,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.phoneNumTextField.text.length==0) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //查询手机号是否已存在
        BmobQuery *query =[BmobUser query];
        [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneNumTextField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count>0) {
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您注册的手机号已注册过,请直接登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else if (array.count==0){
                [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumTextField.text andTemplate:nil resultBlock:^(int number, NSError *error) {
                    
                }];
                self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                [self.smsCodeBtn setTitle:@"已发送 60s" forState:UIControlStateNormal];
                [self.smsCodeBtn setEnabled:NO];
                [self.smsCodeBtn setBackgroundColor:[UIColor grayColor]];
                [self.smsCodeBtn setAlpha:0.7];
                self.time =60;
            }
        }];
    }
    
}

//验证码倒计时
-(void)daojishi
{
    self.time--;
    NSString *str =[NSString stringWithFormat:@"已发送 %ds",self.time];
    [self.smsCodeBtn setTitle:str forState:UIControlStateNormal];
    if (self.time==0) {
        [self.smsCodeBtn setBackgroundColor:[UIColor blueColor]];
        [self.smsCodeBtn setAlpha:1.0];
        [self.smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.smsCodeBtn setEnabled:YES];
        //时间控件停止
        [self.timer invalidate];
    }
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    return YES;
}
//关闭键盘
-(void) dismissKeyBoard{
    [self.phoneNumTextField resignFirstResponder];
    [self.smsCodeTextField resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
