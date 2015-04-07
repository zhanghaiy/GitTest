//
//  SettingCenterViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SettingCenterViewController.h"
#import "SettingCell.h"


@interface SettingCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *listtableV;
    NSMutableArray *_listArray;
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
    [button setFrame:CGRectMake(0, 0, 35, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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

- (void)makeUpDataArray
{
    NSArray *textArray = @[@"Wifi环境下加载图片",@"夜间模式",@"清除缓存",@"分享给好友",@"字体大小",@"版本更新",@"用户反馈",@"关于我们"];
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
    cell.cellIndex = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDict = [_listArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

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
