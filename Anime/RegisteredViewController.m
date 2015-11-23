//
//  RegisteredViewController.m
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "RegisteredViewController.h"

@interface RegisteredViewController ()

@end

@implementation RegisteredViewController

//添加键盘监听事件
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.center=self.registerView.center;
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
}

//键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    //获取键盘高度
    NSValue *keyboardObject=[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    //调整replyView位置
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:0.2];
    if ([self.registerView.nameTextField isFirstResponder]) {
        self.registerView.center=CGPointMake(self.center.x, self.center.y);
    }else if ([self.registerView.phoneNumTextField isFirstResponder]) {
        self.registerView.center=CGPointMake(self.center.x, self.center.y-80);
        
    }else if ([self.registerView.userPwdTextField isFirstResponder]) {
        self.registerView.center=CGPointMake(self.center.x, self.center.y-120);
    }
    else if ([self.registerView.smsCodeTextField isFirstResponder]) {
        self.registerView.center=CGPointMake(self.center.x, self.center.y-220);
    }
    [UIView commitAnimations];
}

//键盘隐藏时
-(void)keyboardDidHidden:(NSNotification *)notification
{
    //调整replyView位置
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:0.2];
    //设置replyView下移
    self.registerView.center=self.center;
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"注册";
    self.view.backgroundColor =[UIColor whiteColor];
    [self createViews];
}

//创建子视图
-(void)createViews
{
    
    //注册视图
    self.registerView =[[RegisterView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 330)];
    [self.view addSubview:self.registerView];
    
    //注册按钮
    self.registerBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerBtn.frame =CGRectMake(WIDTH*0.0533333333, 430, WIDTH-WIDTH*0.1066666667, HEIGHT*0.07496251);
    self.registerBtn.backgroundColor =[UIColor redColor];
    [self.registerBtn setBackgroundColor:[UIColor blueColor]];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerBtn.layer.cornerRadius =10.0;
    [self.registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(confirmRegistration) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
}


//确认注册
-(void)confirmRegistration
{
    //判断输入手机号是否为11位数字
    NSString *str =self.registerView.phoneNumTextField.text;
    NSString *regex =@"[0-9]{11}";
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (self.registerView.phoneNumTextField.text.length!=0&&![predicate evaluateWithObject:str]) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的手机号格式错误,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.registerView.nameTextField.text.length==0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.registerView.phoneNumTextField.text.length==0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.registerView.userPwdTextField.text.length==0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.registerView.userPwdTextField.text.length>0 && self.registerView.userPwdTextField.text.length<6){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度不够!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.registerView.smsCodeTextField.text.length==0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        //判断手机号是否已注册
        BmobQuery *query =[BmobUser query];
        [query whereKey:@"mobilePhoneNumber" equalTo:self.registerView.phoneNumTextField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
         {
             if (array.count==0)
             {
                 //注册用户
                 BmobUser *bUser =[[BmobUser alloc] init];
                 [bUser setUsername:self.registerView.phoneNumTextField.text];
                 [bUser setPassword:self.registerView.userPwdTextField.text];
                 [bUser setMobilePhoneNumber:self.registerView.phoneNumTextField.text];
                 [bUser setObject:self.registerView.nameTextField.text forKey:@"name"];
                 [bUser setObject:@"http://file.bmob.cn/M02/6E/30/oYYBAFY5dVKAHF3BAAE5lpLQE-c5689412" forKey:@"iconImg"];
                 [bUser signUpOrLoginInbackgroundWithSMSCode:self.registerView.smsCodeTextField.text block:^(BOOL isSuccessful, NSError *error) {
                     if(isSuccessful)
                     {
                         UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
                         
                         [self.navigationController popToRootViewControllerAnimated:YES];;
                     }
                     else
                     {
                         UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败,请检查验证码是否正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }];
             }
             else if(array.count>0)
             {
                 
                 UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号已注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
    }
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
