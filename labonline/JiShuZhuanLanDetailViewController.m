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
#import "NetManager.h"
#import "PathManager.h"
#import "UIView+Category.h"


@interface JiShuZhuanLanDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *_webV;
    BOOL _collection;
    BOOL _downLoadVidio;
}
@end

@implementation JiShuZhuanLanDetailViewController

#define kToolBarHeight 60
#define kSubItemsTag 68

- (void)setArticalDic:(NSDictionary *)articalDic
{
    _articalDic = articalDic;
    _articalID = [_articalDic objectForKey:@"articleid"];
    _htmlUrl = [_articalDic objectForKey:@"urlhtml"];
    _titleStr = [_articalDic objectForKey:@"type"];
}


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
    
    _downLoadVidio = NO;
    _collection = NO;
}

#pragma mark - 网络请求
#pragma mark -- 开始请求
- (void)requestMainDataWithURLString:(NSString *)urlStr
{
    NetManager *netManager = [[NetManager alloc]init];
    netManager.delegate = self;
    netManager.action = @selector(requestFinished:);
    [netManager requestDataWithUrlString:urlStr];
}

#pragma mark --网络请求完成
- (void)requestFinished:(NetManager *)netManager
{
    if (_collection)
    {
        _collection = NO;
        // 收藏
        if (netManager.downLoadData)
        {
            // 成功
            // 解析
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
            if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
            {
                // 收藏成功
                [self createAlertViewWithMessage:@"收藏成功"];
            }
            else
            {
                [self createAlertViewWithMessage:@"收藏失败"];
            }
        }
        else
        {
            // 失败
        }
    }
    else if (_downLoadVidio)
    {
       // 下载
        _downLoadVidio = NO;
        UIView *loadingV = [self.view viewWithTag:1111];
        [loadingV removeFromSuperview];
        NSString *fileName = [[_vidioUrl componentsSeparatedByString:@"/"] lastObject];
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",[PathManager getCatePathWithType:VidioPath],fileName];
        NSLog(@"~~~~~~~~~文件下载~~~~~~~~~%@~~~~~~~~~~~~~~~",toPath);
        if (toPath)
        {
           BOOL exit = [netManager.downLoadData writeToFile:toPath atomically:YES];
            if (exit)
            {
                [self createAlertViewWithMessage:@"文件下载成功"];
                NSDictionary *currentDownloadVidio = @{@"VidioName":fileName,@"VidioPath":toPath,@"title":[_articalDic objectForKey:@"title"],@"type":[_articalDic objectForKey:@"type"]};
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *downloadVidioArray = [[NSMutableArray alloc]init];
                [downloadVidioArray addObject:currentDownloadVidio];
                if ([defaults objectForKey:@"VidioList"])
                {
                    NSLog(@"本地已有缓存视频");
                    NSArray *savedArray = [defaults objectForKey:@"VidioList"];
                    for (NSDictionary *dic in savedArray)
                    {
                        [downloadVidioArray addObject:dic];
                    }
                }
                [defaults setObject:downloadVidioArray forKey:@"VidioList"];
                [defaults synchronize];
            }
            else
            {
                [self createAlertViewWithMessage:@"文件写入本地失败"];
            }
        }
        else
        {
            [self createAlertViewWithMessage:@"文件存储路径不存在"];
        }
    }
    else
    {
        [self createAlertViewWithMessage:@"文件下载失败"];
    }
    
}

- (void)createAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertV show];
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
            _collection = YES;
            NSString *urlStr = [NSString stringWithFormat:@"%@?userid=%@&articleid=%@",kCollectionUrl,kUserId,_articalID];
            [self requestMainDataWithURLString:urlStr];
        }
            break;
        case 1:
        {
            // 评价
            JSZLEvaluationViewController *jszlEvaluVC = [[JSZLEvaluationViewController alloc]init];
            jszlEvaluVC.articalId = _articalID;// 9185
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
            _downLoadVidio = YES;
            if ([_vidioUrl length])
            {
                // 下载视频
                [self requestMainDataWithURLString:_vidioUrl];
                // 加载View
                UIView *loadingV = [UIView createLoadingView];
                loadingV.tag = 1111;
                loadingV.center = CGPointMake(kScreenWidth/2, kScreenHeight*1/2);
                [self.view addSubview:loadingV];
            }
            else
            {
                [self createAlertViewWithMessage:@"暂无视频"];
            }
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
