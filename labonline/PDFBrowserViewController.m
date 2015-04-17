//
//  PDFBrowserViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/31.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "PDFBrowserViewController.h"
#import <QuickLook/QuickLook.h>
#import "AFNetworkTool.h"

@interface PDFBrowserViewController ()<UIWebViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    BOOL _back;
    QLPreviewController *previewController;
    NSURL *_fileUrl;
}
@end

@implementation PDFBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"PDF文件预览";
    _back = NO;
    // left
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 25, 26)];
    [button setBackgroundImage:[UIImage imageNamed:@"aniu_07.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popToPrePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // right
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(0, 0, 50, 30)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton setTitle:@"下载" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor colorWithRed:217/255.0 green:5/255.0 blue:41/255.0 alpha:1] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [AFNetworkTool JSONDataWithUrl:[NSString stringWithFormat:kAddReadCountsUrl,_articalId] success:^(id json) {
         NSLog(@"success");
    } fail:^{
        NSLog(@"fail");
    }];
    
    // 判断本地是否存在
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self localFilePath],[[NSURL URLWithString:_filePath] lastPathComponent]];
    BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (([_filePath hasPrefix:@"http://"]||[_filePath hasPrefix:@"https://"])&&(!exit))
    {
        // 网络
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight)];
        webView.delegate = self;
        [self.view addSubview:webView];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_filePath]];
        [webView loadRequest:request];
    }
    else
    {
        if (exit)
        {
            _fileUrl = [NSURL fileURLWithPath:path];
        }
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight)];
        webView.delegate = self;
        [self.view addSubview:webView];
        NSURLRequest *request = [NSURLRequest requestWithURL:_fileUrl];
        [webView loadRequest:request];
//        else
//        {
//            _fileUrl = [NSURL fileURLWithPath:_filePath];
//        }
//        previewController = [[QLPreviewController alloc] initWithNibName:nil bundle:nil];
//        previewController.dataSource = self;
//        previewController.delegate = self;
//        [self.navigationController pushViewController:previewController animated:NO];
    }
}

#pragma mark - 返回上一页
- (void)popToPrePage
{
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.target respondsToSelector:self.action])
    {
        [_target performSelector:_action withObject:nil afterDelay:NO];
    }
}

#pragma mark - 保存按钮
- (void)saveButtonClicked:(UIButton *)btn
{
    [self saveCurrentFile];
//    [self downLoadPdfFile];
}
/*
- (void)downLoadPdfFile
{
    NetManager *netManager = [[NetManager alloc]init];
    netManager.delegate = self;
    netManager.action = @selector(pdfDownloaded:);
    [netManager requestDataWithUrlString:_filePath];
}

- (void)pdfDownloaded:(NetManager *)netRequest
{
    NSLog(@"下载回来");
    if (netRequest.downLoadData)
    {
        //
        NSString *path = [NSString stringWithFormat:@"%@/%@",[self localFilePath],[[NSURL URLWithString:_filePath] lastPathComponent]];
        [netRequest.downLoadData writeToFile:path atomically:YES];
        NSLog(@"%@",path);
    }
}
*/
#pragma mark - UIWebViewDelegate
#pragma mark -- 失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

#pragma mark - QLPreviewController Delegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return _fileUrl;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller
{
    _back = YES;
    [self popToPrePage];
}

#pragma mark - 保存文档
- (void)saveCurrentFile
{
    NSURL *ressourcesUrl = [NSURL URLWithString:_filePath];
    NSString *fileExtension = [ressourcesUrl pathExtension];
    if ([fileExtension isEqualToString:@"pdf"]||[fileExtension isEqualToString:@"jpg"])
    {
        NSString *filename = [ressourcesUrl lastPathComponent];
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",[self localFilePath],filename];
        NSData *fileData = [NSData dataWithContentsOfURL:ressourcesUrl];
        if (filename != nil)
        {
            NSError *error = nil;
            [fileData writeToFile:toPath options:NSDataWritingAtomic error:&error];
            NSLog(@"%@",toPath);
            if (error != nil)
            {
                NSLog(@"Failed to save the file: %@", [error description]);
            }
            else
            {
                UIAlertView *filenameAlert = [[UIAlertView alloc] initWithTitle:@"保存文件到本地" message:[NSString stringWithFormat:@"文件：%@ 下载成功", filename] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [filenameAlert show];
            }
        }
        else
        {
            // 文件名为空
        }
    }else
    {
        // 文件类型不对
    }

}

#pragma mark - 本地文件路径
// 自己写的
- (NSString*)localFilePath
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingString:@"Documents/LocalFile"];
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


#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
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
