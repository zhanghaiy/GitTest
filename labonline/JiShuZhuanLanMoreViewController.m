//
//  JiShuZhuanLanMoreViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanMoreViewController.h"
#import "JiShuZhuanLanMoreCell.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "SearchViewController.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "EGORefreshTableHeaderView.h"



@interface JiShuZhuanLanMoreViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *_tableView;
    NSArray *_articalArray;
    NSInteger _currentEnterCell;//进入的cell
    BOOL _addReadCounts;
    EGORefreshTableHeaderView *_refresV;
    BOOL _reloading;
}
@end

@implementation JiShuZhuanLanMoreViewController


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
    if (_reloading)
    {
        [self stopRefresh];
    }
    else
    {
        [self.view removeLoadingVIewInView:self.view andTarget:self];
    }
    if (netManager.downLoadData)
    {
        // 成功
        // 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        _articalArray = [[dict objectForKey:@"data"] objectForKey:@"article"];
        [_tableView reloadData];
    }
    else
    {
        // 失败
        [self.view addAlertViewWithMessage:@"请求不到数据，请重试" andTarget:self];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _reloading = NO;
    self.title = @"生物检验";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    // 设置左右按钮
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
    
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _addReadCounts = NO;

    // tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10,kScreenWidth, kScreenHeight-75) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    [self requestMainDataWithURLString:[NSString stringWithFormat:kJSZLMoreUrlString,_typeId]];
    [self createRefreshView];
}

#pragma mark - 返回上一页
- (void)popToPrePage
{
    // back
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    JiShuZhuanLanMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JiShuZhuanLanMoreCell" owner:self options:0] lastObject];
    }
    cell.subDict = [_articalArray objectAtIndex:indexPath.row];
    if (_addReadCounts&&(indexPath.row==_currentEnterCell))
    {
        cell.youLanCountsLable.text = [NSString stringWithFormat:@"%ld",[[[_articalArray objectAtIndex:indexPath.row] objectForKey:@"seenum"] integerValue]+1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentEnterCell = indexPath.row;
    NSDictionary *subDic = [_articalArray objectAtIndex:indexPath.row];
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.articalDic = subDic;
    detailVC.delegate = self;
    detailVC.action = @selector(addReadCounts);
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - 增加阅读数
- (void)addReadCounts
{
    _addReadCounts = YES;
    [_tableView reloadData];
}

#pragma mark --下拉刷新
- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [_tableView addSubview:_refresV];
    [_refresV refreshLastUpdatedDate];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (_reloading == NO)
    {
        _reloading = YES;
        [self requestMainDataWithURLString:[NSString stringWithFormat:kJSZLMoreUrlString,_typeId]];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [_refresV reloadInputViews];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresV egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresV egoRefreshScrollViewDidEndDragging:scrollView];
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
