//
//  JiShuZhuanLanViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanViewController.h"
#import "PictureShowView.h"
#import "JiShuZhuanLanCell.h"
#import "JiShuZhuanLanMoreViewController.h"
#import "JiShuZhuanLanDetailViewController.h"

@interface JiShuZhuanLanViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JiShuZhuanLanViewController
#define kImageShowViewHeight 250
#define kCellHeight 245



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"技术专栏";
    
    PictureShowView *pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, kImageShowViewHeight)];
    pictureV.imageInfoArray = @[@"",@"",@"",@"",@""];
    [self.view addSubview:pictureV];
    pictureV.backgroundColor = [UIColor whiteColor];
    
    UITableView *jiShuZhuanLanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kImageShowViewHeight+10, kScreenWidth, kScreenHeight-kImageShowViewHeight-10) style:UITableViewStylePlain];
    jiShuZhuanLanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    jiShuZhuanLanTableView.delegate = self;
    jiShuZhuanLanTableView.dataSource = self;
    jiShuZhuanLanTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:jiShuZhuanLanTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"JiShuZhuanLanCell";
    JiShuZhuanLanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JiShuZhuanLanCell" owner:self options:0] lastObject];
        cell.target = self;
        cell.jszlViewClickedAction = @selector(enterDetailViewController:);
        cell.buttonClickSelector = @selector(enterMoreViewController:);
    }

    return cell;
}

#pragma mark -- 跳转到技术专栏详情界面
- (void)enterDetailViewController:(JiShuZhuanLanCell *)cell
{
    // 进入详情
    JiShuZhuanLanDetailViewController *jSZLDetailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    jSZLDetailVC.titleStr = @"生物检验";
    [self.navigationController pushViewController:jSZLDetailVC animated:YES];
}
#pragma mark --跳转到技术专栏更多界面
- (void)enterMoreViewController:(JiShuZhuanLanCell *)cell
{
    // 进入更多
    // 更多 跳转页面
    JiShuZhuanLanMoreViewController *moreVC = [[JiShuZhuanLanMoreViewController alloc]init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
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
