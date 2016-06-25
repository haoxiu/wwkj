//
//  AboutViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/7/23.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.navigationController.navigationBarHidden =NO;
    UIWebView *_webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _webView.backgroundColor =[UIColor whiteColor];
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    // 清除webView缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.view addSubview:_webView];
   [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://eswjdg.com/about.html"]]];
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(100,self.view.height -150, self.view.width -200,30)];
    btn.titleLabel.font =[UIFont systemFontOfSize:13];
    btn.backgroundColor =[UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1];
    [btn setTitle:@"联系我们" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)btnAction{

//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",0731-85569828];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:0731-85569828"]]];
    [self.view addSubview:callWebview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
