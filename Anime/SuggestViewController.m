//
//  SuggestViewController.m
//  RentBike
//
//  Created by wang on 15/10/20.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import "SuggestViewController.h"

@interface SuggestViewController ()

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    //在导航栏右侧添加一个提交按钮
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(clickDown)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    //文本框
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 84,WIDTH -20, HEIGHT*0.2083333333)];
    self.textView.scrollEnabled=YES;
    self.textView.editable=YES;
    self.textView.layer.borderColor=[[UIColor grayColor] CGColor];
    self.textView.layer.borderWidth=1;
    self.textView.delegate=self;
    self.textView.font=[UIFont fontWithName:@"Arial" size:18.0];
    self.textView.returnKeyType=UIReturnKeyDefault;
    self.textView.layer.cornerRadius=10;
    self.textView.textAlignment = NSTextAlignmentLeft;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view addSubview:self.textView];
    //UITextView没有UITextField中的提示语句属性placeholder
    self.placeLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 85, WIDTH -24, 42)];
    self.placeLbl.text = @"请写下您宝贵的意见和建议，我们将努力改进（不少于五个字）";
    self.placeLbl.numberOfLines=2;
    self.placeLbl.backgroundColor = [UIColor clearColor];
    self.placeLbl.textColor = [UIColor lightGrayColor];
    if (self.textView.text.length == 0) {
        self.placeLbl.hidden = NO;
    }else{
        self.placeLbl.hidden = YES;
    }
    [self.view addSubview:self.placeLbl];
    
    //手机号
    self.phoneNumberTxt=[[UITextField alloc] initWithFrame:CGRectMake(10, 84+HEIGHT*0.229166667, WIDTH-20, 40)];
    self.phoneNumberTxt.placeholder=@"请留下手机号码，以便我们回复您";
    self.phoneNumberTxt.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneNumberTxt.delegate=self;
    self.phoneNumberTxt.layer.cornerRadius=10;
    self.phoneNumberTxt.layer.borderWidth=1;
    self.phoneNumberTxt.layer.borderColor=[[UIColor grayColor] CGColor];
    self.phoneNumberTxt.font=[UIFont fontWithName:@"Arial" size:18.0];
    [self.view addSubview:self.phoneNumberTxt];
    
//    背景颜色
    self.textView.backgroundColor=[UIColor colorWithRed:253/255.0 green:245/255.0 blue:230/255.0 alpha:1.0];
    self.phoneNumberTxt.backgroundColor=[UIColor colorWithRed:253/255.0 green:245/255.0 blue:230/255.0 alpha:1.0];
}
//点击提交按钮
-(void)clickDown
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否提交您的建议" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
//弹窗点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        if (self.text==nil||[self.text isEqualToString:@""]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入内容！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            alert.tag=110;
            [alert show];

        }
        else if (self.phoneNumberTxt.text.length!=11){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"手机号应为11位！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            alert.tag=110;
            [alert show];
        }
        else{
            BmobObject *contentObj=[BmobObject objectWithClassName:@"Advice"];
            [contentObj setObject:self.text forKey:@"advice"];
            [contentObj setObject:self.phoneNumberTxt.text forKey:@"phoneNumber"];
            [contentObj saveInBackground];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}
//解决键盘自动回缩
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag==110) {
        [self.textView resignFirstResponder];
        [self.textView becomeFirstResponder];
    }
}
//textView是否更改的方法
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeLbl.hidden = NO;
    }else{
        self.placeLbl.hidden = YES;
    }
    self.text=textView.text;
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
//自动弹出键盘
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
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
