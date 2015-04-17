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
#import <AVFoundation/AVFoundation.h>
#import <QuickLook/QuickLook.h>


@interface JiShuZhuanLanDetailViewController ()<UIWebViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    UIWebView *_webV;
    
    BOOL _addReadCounts; // 是否在增加阅读数
    BOOL _isPDF; // 是否是PDF
    BOOL _haveVidio;// 是否有视频
    BOOL _downLoadVidio;// 是否在下载视频
    BOOL _collection; // 是否在网络请求--收藏
    NSString *_vidioUrl;
    NSString *_titleStr;
    NSString *_urlstring;
    NSString *_articalID;
    
    BOOL _back;
    QLPreviewController *previewController;
    NSURL *_fileUrl;
}
@end

@implementation JiShuZhuanLanDetailViewController

#define kToolBarHeight 60
#define kSubItemsTag 68

- (void)setArticalDic:(NSDictionary *)articalDic
{
    _articalDic = articalDic;
    _articalID = [_articalDic objectForKey:@"articleid"];
    if ([[_articalDic objectForKey:@"urlpdf"] length]>5)
    {
        _isPDF = YES;
        _urlstring = [_articalDic objectForKey:@"urlpdf"];
    }
    else if ([_articalDic objectForKey:@"urlhtml"])
    {
        _isPDF = NO;
       _urlstring = [_articalDic objectForKey:@"urlhtml"];
        if ([[_articalDic objectForKey:@"urlvideo"] length]>5)
        {
            // 视频
            _haveVidio = YES;
            _vidioUrl = [_articalDic objectForKey:@"urlvideo"];
        }
    }
    if ([_articalDic objectForKey:@"type"]) {
        _titleStr = [_articalDic objectForKey:@"type"];
    }
}


#pragma mark - 本地文件路径
// 自己写的
- (NSString*)localFilePath
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/LocalFile"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsPath isDirectory:&isDir];
    if (isDirExist == NO)
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir)
        {
            NSLog(@"Create Audio Directory Failed.");
        }
    }
    return documentsPath;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"文章详情";
    _downLoadVidio = NO;
    _collection = NO;
    
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
    // 判断本地是否存在pdf
    if (_isPDF)
    {
        NSString *path = [NSString stringWithFormat:@"%@/%@",[self localFilePath],[[NSURL URLWithString:_urlstring] lastPathComponent]];
        NSLog(@"%@",path);
        BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (exit)
        {
            _fileUrl = [NSURL fileURLWithPath:path];
        }
        else
        {
            _fileUrl = [NSURL URLWithString:_urlstring];
            [self upReadCounts];
        }
    }
    else
    {
        _fileUrl = [NSURL URLWithString:_urlstring];
        [self upReadCounts];
    }

    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-kToolBarHeight)];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:_fileUrl];
    [webView loadRequest:request];
}

- (void)upReadCounts
{
    // 增加阅读数
    _addReadCounts = YES;
    [self requestMainDataWithURLString:[NSString stringWithFormat:kAddReadCountsUrl,_articalID]];
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
            [self.view removeLoadingVIewInView:self.view andTarget:self];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
            if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
            {
                // 收藏成功
                [self createAlertViewWithMessage:@"收藏成功"];
            }
            else
            {
                [self createAlertViewWithMessage:[dict objectForKey:@"remark"]];
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
        [self.view removeLoadingVIewInView:self.view andTarget:self];
        if (netManager.downLoadData)
        {
            NSString *fileName = [[_vidioUrl componentsSeparatedByString:@"/"] lastObject];
            NSString *toPath = [NSString stringWithFormat:@"%@/%@",[PathManager getCatePathWithType:VidioPath],fileName];
            if (toPath)
            {
                BOOL exit = [netManager.downLoadData writeToFile:toPath atomically:YES];
                if (exit)
                {
                    [self createAlertViewWithMessage:@"文件下载成功"];
                    UIImage *image = [self getVidioImageWithVidioPath:toPath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                    NSDictionary *currentDownloadVidio = @{@"VidioName":fileName,@"VidioPath":toPath,@"title":[_articalDic objectForKey:@"title"],@"type":[_articalDic objectForKey:@"type"],@"image":imageData};
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *downloadVidioArray = [[NSMutableArray alloc]init];
                    [downloadVidioArray addObject:currentDownloadVidio];
                    if ([defaults objectForKey:@"VidioList"])
                    {
                        NSArray *savedArray = [defaults objectForKey:@"VidioList"];
                        for (NSDictionary *dic in savedArray)
                        {
                            [downloadVidioArray addObject:dic];
                        }
                    }
                    [defaults setObject:downloadVidioArray forKey:@"VidioList"];
                    [defaults synchronize];
                }
                else {
                    [self createAlertViewWithMessage:@"文件写入本地失败"];
                }
            }
            else {
                [self createAlertViewWithMessage:@"文件存储路径不存在"];
            }
        }
        else {
            [self createAlertViewWithMessage:@"文件下载失败,请检查网络"];
        }
    }
    else if (_addReadCounts)
    {
        _addReadCounts = NO;
    }
}

#pragma mark - 获取视频缩略图
- (UIImage *)getVidioImageWithVidioPath:(NSString *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
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
            [self.view addLoadingViewInSuperView:self.view andTarget:self];
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
            // 微信分享 文本
//            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//            req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
//            req.bText = YES;
//            req.scene = WXSceneSession;
//            
//            [WXApi sendReq:req];
            
            //微信分享链接
//            WXMediaMessage *message = [WXMediaMessage message];
//            message.title = @"aaaa";
//            message.description = @"bbbbbbbb";
//            [message setThumbImage:[UIImage imageNamed:@"wangqi.png"]];
//            
//            WXWebpageObject *ext = [WXWebpageObject object];
//            ext.webpageUrl = @"http://2pau.l.mob.com/W6Dy6";
//            
//            message.mediaObject = ext;
//            
//            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//            req.bText = NO;
//            req.message = message;
//            req.scene = WXSceneTimeline;
//            
//            [WXApi sendReq:req];
            
            //QQ分享链接
            NSString *url = @"http://2pau.l.mob.com/W6Dy6";
            //分享图预览图URL地址
            NSString *previewImageUrl = @"wangqi.png";
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:url]
                                        title: @"title"
                                        description:@"description"
                                        previewImageURL:[NSURL URLWithString:previewImageUrl]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //将内容分享到qq
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            //将内容分享到qzone
//            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
//            [self.tencentAuth logout:self];登出
            
//            AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            
        }
            break;
        case 3:
        {
            // 下载
            if (_isPDF)
            {
                // 下载PDF
                [self saveCurrentFile];
            }
            else
            {
                if (_haveVidio)
                {
                    _downLoadVidio = YES;
                    // 下载视频
                    NSString *currentVidioName = [[_vidioUrl componentsSeparatedByString:@"/"] lastObject];
                    if ([self localExitCurrentVidioName:currentVidioName])
                    {
                        [self createAlertViewWithMessage:@"本地已经存在该视频"];
                    }
                    else
                    {
                        [self requestMainDataWithURLString:_vidioUrl];
                        // 加载View
                        [self.view addLoadingViewInSuperView:self.view andTarget:self];
                    }
                }
                else
                {
                    [self createAlertViewWithMessage:@"暂无视频"];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)localExitCurrentVidioName:(NSString *)vidioName
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"VidioList"];
    for (NSDictionary *dic in arr)
    {
        NSString *fileName = [dic objectForKey:@"VidioName"];
        if ([fileName isEqualToString:vidioName])
        {
            // 本地已经存在
            return YES;
        }
    }
    return NO;
}

#pragma mark - 上一页
- (void)popToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([_delegate respondsToSelector:_action])
    {
        [_delegate performSelector:_action withObject:nil afterDelay:NO];
    }
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

#pragma mark 微信所用
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark 微信所用
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}


-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIWebViewDelegate
#pragma mark -- 失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

#pragma mark - 保存pdf
- (void)saveCurrentFile
{
    NSString *fileName = [[_urlstring componentsSeparatedByString:@"/"] lastObject];
    NSString *fileEnd = [[fileName componentsSeparatedByString:@"."] lastObject];
    if ([fileEnd isEqualToString:@"pdf"])
    {
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",[self localFilePath],fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath isDirectory:nil])
        {
            [self createAlertViewWithMessage:@"文件已经存在"];
        }
        else
        {
            NSURL *ressourcesUrl = [NSURL URLWithString:_urlstring];
            NSData *fileData = [NSData dataWithContentsOfURL:ressourcesUrl];
            if (fileName != nil)
            {
                NSError *error = nil;
                [fileData writeToFile:toPath options:NSDataWritingAtomic error:&error];
                if (error != nil)
                {
                    // 写入本地失败
                    [self createAlertViewWithMessage:[NSString stringWithFormat:@"文件：%@ 写入本地失败", fileName]];
                }
                else
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *pdfArray;
                    if ([defaults objectForKey:@"PDFArray"])
                    {
                        pdfArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PDFArray"]];
                    }
                    else
                    {
                        pdfArray = [[NSMutableArray alloc]init];
                    }
                    [pdfArray insertObject:_articalDic atIndex:0];
                    [defaults setObject:pdfArray forKey:@"PDFArray"];
                    [self createAlertViewWithMessage:[NSString stringWithFormat:@"文件：%@ 下载成功", fileName]];
                }
            }
        }
    }
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
