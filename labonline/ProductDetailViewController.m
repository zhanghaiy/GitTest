//
//  ProductDetailViewController.m
//  labonline
//
//  Created by 引领科技 on 15/5/5.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "NetManager.h"

@interface ProductDetailViewController ()<UIWebViewDelegate>{
    UIWebView *_webView;
    NSString *_urlstring;
    NSString *_productID;// 产品id
    BOOL _addReadCounts; // 是否再增加阅读数
    BOOL _netRequesting;
}

@end

@implementation ProductDetailViewController

#define kMainPreButtonWidth 60

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 40) andBackImageWithName:@"返回角.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(backToPrePage);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSURL *url;
    _urlstring=[_proDetail objectForKey:@"urlhtml"];
    _productID=[_proDetail objectForKey:@"productid"];
    url = [NSURL URLWithString:_urlstring];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    [self createHomePageBTN];
    [self upReadCounts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma 生成首页按钮
-(void)createHomePageBTN{
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setFrame:CGRectMake(kScreenWidth-kMainPreButtonWidth-10, kScreenHeight-kMainPreButtonWidth-20, kMainPreButtonWidth, kMainPreButtonWidth)];
    [preButton setTitle:@"首页" forState:UIControlStateNormal];
    [preButton setTitleColor:[UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    preButton.layer.masksToBounds = YES;
    preButton.layer.cornerRadius = preButton.frame.size.width/2;
    preButton.layer.borderWidth = 2;
    preButton.layer.borderColor = [UIColor colorWithRed:215/255.0 green:104/255.0 blue:121/255.0 alpha:1].CGColor;
    preButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [preButton addTarget:self action:@selector(preButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preButton];
}
#pragma 首页按钮点击事件
- (void)preButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 增加阅读数
- (void)upReadCounts
{
    // 增加阅读数
    _addReadCounts = YES;
    [self requestMainDataWithURLString:[NSString stringWithFormat:kAddProductReadCountsUrl,_productID]];
}

#pragma mark - 网络请求
#pragma mark -- 开始请求
- (void)requestMainDataWithURLString:(NSString *)urlStr
{
    _netRequesting = YES;
    NetManager *netManager = [NetManager getShareManager];
    netManager.delegate = self;
    netManager.action = @selector(requestFinished:);
    [netManager requestDataWithUrlString:urlStr];
}
#pragma mark --网络请求完成
- (void)requestFinished:(NetManager *)netManager
{
    _netRequesting = NO;
    if (_addReadCounts) // 增加阅读数
    {
        _addReadCounts = NO;
    }
}
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
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
