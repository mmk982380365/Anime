//
//  SuggestViewController.h
//  RentBike
//
//  Created by wang on 15/10/20.
//  Copyright (c) 2015年 sdzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Bmob.h>
@interface SuggestViewController : BaseViewController<UITextViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
/**
 *  文本框
 */
@property(strong,nonatomic)UITextView *textView;
/**
 *  占位符
 */
@property(strong,nonatomic)UILabel *placeLbl;
/**
 *  文字
 */
@property(nonatomic,strong) NSString *text;

/**
 *  手机号文本
 */
@property(strong,nonatomic) UITextField *phoneNumberTxt;

@end
