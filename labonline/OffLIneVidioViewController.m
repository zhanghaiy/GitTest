//
//  OffLIneVidioViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "OffLIneVidioViewController.h"
#import "OffLineVidioCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface OffLIneVidioViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_vidioTableView;
     MPMoviePlayerViewController *_playerController;
}
@end

@implementation OffLIneVidioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"离线视频";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _vidioTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, kScreenHeight-80) style:UITableViewStylePlain];
    _vidioTableView.delegate = self;
    _vidioTableView.dataSource = self;
    _vidioTableView.showsVerticalScrollIndicator = NO;
    _vidioTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _vidioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_vidioTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cell";
    OffLineVidioCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OffLineVidioCell" owner:self options:0] lastObject];
        cell.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        cell.target = self;
        cell.action = @selector(playVidioButtonCallBack:);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)playVidioButtonCallBack:(OffLineVidioCell *)offLineCell
{
    // 播放离线视频
    NSLog(@"播放离线视频");
    NSString *audioPath = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"mp4"];
    [self playerPlayVidioWithPath:audioPath];
}

#pragma mark - 根据路径播放视频
- (void)playerPlayVidioWithPath:(NSString *)path
{
    if (path.length == 0)
    {
        NSLog(@"没有视频资源");
        return;
    }
    NSURL *vidioUrl;
    if ([path hasPrefix:@"http://"]||[path hasPrefix:@"https://"])
    {
        // 远程地址
        vidioUrl = [NSURL URLWithString:path];
    }
    else
    {
        // 本地路径
        vidioUrl = [NSURL fileURLWithPath:path];
    }
    if (_playerController == nil)
    {
        _playerController = [[MPMoviePlayerViewController alloc]initWithContentURL:vidioUrl];
        _playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentViewController:_playerController animated:YES completion:^{
            
        }];
    }
    [_playerController.moviePlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark- 播放结束
- (void)playFinished
{
    // 播放完毕
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    // 停止播放 并销毁
    if (_playerController)
    {
        [_playerController.moviePlayer stop];
        _playerController = nil;
    }
}

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
