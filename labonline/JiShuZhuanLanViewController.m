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
#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"

@interface JiShuZhuanLanViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JiShuZhuanLanViewController
#define kImageShowViewHeight 150
#define kCellHeight 245



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"技术专栏";
    
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 设置左右按钮
    // 左侧按钮
    NavigationButton *leftButton;
    if (_enterFromHome)
    {
        leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30) andBackImageWithName:@"tubiao_04.png"];
        leftButton.action = @selector(popToLeftMenu);
    }
    else
    {
        leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 26) andBackImageWithName:@"aniu_07.png"];
        leftButton.action = @selector(popToPrePage);
    }
    leftButton.delegate = self;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchViewController);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, kImageShowViewHeight+10)];
    headerV.backgroundColor = [UIColor clearColor];
    PictureShowView *pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, kImageShowViewHeight)];
    pictureV.imageInfoArray = @[@"",@"",@"",@"",@""];
    pictureV.target = self;
    pictureV.action = @selector(pictureShowMethod:);
    pictureV.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:pictureV];
    
    UITableView *jiShuZhuanLanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65) style:UITableViewStylePlain];
    jiShuZhuanLanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    jiShuZhuanLanTableView.delegate = self;
    jiShuZhuanLanTableView.dataSource = self;
    jiShuZhuanLanTableView.showsVerticalScrollIndicator = NO;
    jiShuZhuanLanTableView.tableHeaderView = headerV;
    [self.view addSubview:jiShuZhuanLanTableView];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

#pragma mark - 图片轮播-->进入详情
- (void)pictureShowMethod:(PictureShowView *)pictureShowV
{
    // 进入技术专栏详情（通用的）
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.titleStr = @"文章详情";
    [self.navigationController pushViewController:detailVC animated:YES];
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

- (void)popToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}
- (void)enterSearchViewController
{
    // 进入搜索界面
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
