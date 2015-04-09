//
//  SettingCenterViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SettingCenterViewController.h"
#import "SettingCell.h"
#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "AboutMeViewController.h"
#import "ShareView.h"

@interface SettingCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *listtableV;
    NSMutableArray *_listArray;
    BOOL _upLoading;
}
@end

@implementation SettingCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统设置";
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    
    // 左侧返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 35, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"tubiao_04.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popToLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self makeUpDataArray];
    
    listtableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65) style:UITableViewStylePlain];
    listtableV.delegate = self;
    listtableV.dataSource = self;
    listtableV.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
//    listtableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    listtableV.separatorColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    [self.view addSubview:listtableV];
    
}
#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}
- (void)makeUpDataArray
{
    NSArray *textArray = @[@"夜间模式",@"清除缓存",@"分享给好友",@"版本更新",@"用户反馈",@"关于我们"];
    NSArray *imageNameArray = @[@"wifi.png",@"night.png",@"removeCache.png",@"share.png",@"fontSize.png",@"versionUpdate.png",@"UserFeedBack.png",@"about.png"];
    _listArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < textArray.count; i ++)
    {
        NSDictionary *dict = @{@"TEXT":[textArray objectAtIndex:i],@"ImageName":[imageNameArray objectAtIndex:i]};
        [_listArray addObject:dict];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdellIdentifer = @"SettingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingCell" owner:self options:0] lastObject];
    }
    [cell fillDataWithIndex:indexPath.row andDataArray:_listArray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            // 夜间模式
        }
            break;
        case 1:
        {
            // 清除缓存
        }
            break;
        case 2:
        {
            // 分享
            [self createShareView];
        }
            break;
        case 3:
        {
             // 版本更新
            // 首先判断当前的版本是否是最新版本
            NSInteger currentIndex = 0;// 1最新 0 不是最新
            _upLoading = currentIndex?NO:YES;
            NSString *title = @"版本升级";
            NSArray *messageArr = @[@"发现新版本",@"当前是最新版本"];
            NSArray *cancelTitleArr = @[@"升级",@"确定"];
            NSString *otherTitle = @"取消";
            [self  createAlertViewWithTitle:title Message:[messageArr objectAtIndex:currentIndex] cancelTitle:[cancelTitleArr objectAtIndex:currentIndex] otherTitle:currentIndex?nil:otherTitle];

        }
            break;
        case 4:
        {
            //用户反馈
        }
            break;
        case 5:
        {
            // 关于我们
            // 关于我们
            AboutMeViewController *aboutMeVC = [[AboutMeViewController alloc]init];
            [self.navigationController pushViewController:aboutMeVC animated:YES];
        }
            break;
        case 6:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 分享View
- (void)createShareView
{
    UIView *darkV = [[UIView alloc]initWithFrame:self.view.bounds];
    darkV.backgroundColor = [UIColor colorWithWhite:14/255.0 alpha:0.5];
    darkV.tag = 11223344;
    [self.view addSubview:darkV];
    
    ShareView *shareV = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:self options:0] lastObject];
    shareV.frame = CGRectMake(0, kScreenHeight-150, kScreenWidth, 150);
    shareV.backgroundColor = [UIColor colorWithWhite:248/255.0 alpha:1];
    shareV.target = self;
    shareV.action = @selector(shareCallBack);
    [self.view addSubview:shareV];
}

- (void)shareCallBack
{
    UIView *darkV = [self.view viewWithTag:11223344];
    [darkV removeFromSuperview];
    [self createAlertViewWithTitle:@"分享" Message:@"分享暂时未完成" cancelTitle:@"确定" otherTitle:nil];
}

#pragma mark - 警告框
- (void)createAlertViewWithTitle:(NSString *)title Message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            if (_upLoading)
            {
                // 升级
            }
            else
            {
               // 确定
            }
            break;
        case 1:
            // 取消
            
            break;
        default:
            break;
    }
    
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
