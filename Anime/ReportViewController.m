//
//  ReportViewController.m
//  Anime
//
//  Created by 马鸣坤 on 15/11/13.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()<UITextViewDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
/**
 *  文本框
 */
@property(strong,nonatomic) UITextView *textView;
/**
 *  UITextView没有UITextField中的提示语句属性placeholder
 */
@property(strong,nonatomic) UILabel *lab1;
/**
 *  文本的属性
 */
@property(nonatomic,strong) NSString *text;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}
-(void)createView{
    //在导航栏右侧添加一个提交按钮
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(dianji)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    self.title=@"主题内容";
    
    //文本框
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0,WIDTH , HEIGHT)];
    self.textView.scrollEnabled=YES;
    self.textView.editable=YES;
    self.textView.layer.borderColor=[[UIColor grayColor] CGColor];
    self.textView.layer.borderWidth=1;
    self.textView.delegate=self;
    self.textView.font=[UIFont fontWithName:@"Arial" size:18.0];
    self.textView.returnKeyType=UIReturnKeyDefault;
    self.textView.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.textView];
    
    //UITextView没有UITextField中的提示语句属性placeholder
    self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 270, 40)];
    self.lab1.text = @"请输入您要举报的内容";
    self.lab1.backgroundColor = [UIColor clearColor];
    self.lab1.textColor = [UIColor lightGrayColor];
    if (self.textView.text.length == 0) {
        self.lab1.hidden = NO;
    }else{
        self.lab1.hidden = YES;
    }
    [self.textView addSubview:self.lab1];
    
    //背景颜色
    self.textView.backgroundColor=[UIColor colorWithRed:253/255.0 green:245/255.0 blue:230/255.0 alpha:1.0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击提交按钮的方法
-(void)dianji
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否提交您的信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=989;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==989){
        if(buttonIndex==1)
        {
            if (self.text==nil||[self.text isEqualToString:@""]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入内容！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
            }else{
                BmobObject *reportObj=[BmobObject objectWithClassName:@"Report"];
                if(self.type==ReportTypeComment){
                    [reportObj setObject:self.reportComment forKey:@"reportComment"];
                }else if(self.type==ReportTypePost){
                    [reportObj setObject:self.reportSocial forKey:@"reportSocial"];
                }else{
                    [reportObj setObject:self.reportAnimate forKey:@"reportAnimate"];
                }
                [reportObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if(isSuccessful){
                        UIAlertController *alert=[UIAlertController alertControllerWithTitle:ALERTTITLE message:@"您的举报信息已提交，请等待工作人员的处理结果" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAct=[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert addAction:okAct];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
        }
    }
}

//自动弹出键盘
-(void)viewWillAppear:(BOOL)animated
{
    //    [super viewWillAppear:animated];//
    [self.textView becomeFirstResponder];
}

//textView是否更改的方法
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.lab1.hidden = NO;
    }else{
        self.lab1.hidden = YES;
    }
    self.text=textView.text;
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
