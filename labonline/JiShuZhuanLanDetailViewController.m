//
//  JiShuZhuanLanDetailViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanDetailViewController.h"
#import "JSZLEvaluationViewController.h"
#import "SearchViewController.h"

@interface JiShuZhuanLanDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *_webV;
}
@end

@implementation JiShuZhuanLanDetailViewController

#define kToolBarHeight 60
#define kSubItemsTag 68

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _titleStr;
    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 26) andBackImageWithName:@"aniu_07.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popToPrePage);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchViewController);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 底部工具栏
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight - kToolBarHeight, kScreenWidth, kToolBarHeight)];
    
    NSArray *imageArray = @[@"收藏.png",@"评价.png",@"分享.png",@"下载.png"];
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < imageArray.count; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, (kToolBarHeight-10)*0.7, kToolBarHeight-10)];
        [btn setBackgroundImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = kSubItemsTag + i;
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [itemArray addObject:item];
        
        if (i < imageArray.count-1)
        {
            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            [itemArray addObject:spaceItem];
        }
    }
    [toolBar setItems:itemArray animated:YES];
    toolBar.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:toolBar];
    
    // webView
    _webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-kToolBarHeight)];
    _webV.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_htmlUrl]];
    [self.view addSubview:_webV];
    [_webV loadRequest:request];
}

#pragma mark - 按钮点击事件
- (void)buttonClicked:(UIButton *)btn
{
    NSInteger index = btn.tag - kSubItemsTag;
    switch (index)
    {
        case 0:
        {
           // 收藏
        }
            break;
        case 1:
        {
            // 评价
            JSZLEvaluationViewController *jszlEvaluVC = [[JSZLEvaluationViewController alloc]init];
            [self.navigationController pushViewController:jszlEvaluVC animated:YES];
        }
            break;
        case 2:
        {
            // 分享
            
        }
            break;
        case 3:
        {
            // 下载
        }
            break;
        default:
            break;
    }
}

#pragma mark - 上一页
- (void)popToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
