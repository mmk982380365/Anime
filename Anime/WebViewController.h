//
//  WebViewController.h
//  10.28_t1_JS
//
//  Created by 马鸣坤 on 15/10/28.
//  Copyright (c) 2015年 lamco. All rights reserved.
//

#import "BaseViewController.h"
#define margin 10

@interface WebViewController : BaseViewController
/**
 *  读取数据的网页
 */
@property(strong,nonatomic) UIWebView *webView;
/**
 *  网页请求
 */
@property (strong,nonatomic) NSURLRequest *request;
@end
