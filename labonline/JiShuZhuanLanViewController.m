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
#import "JiShuZhuanLanSubView.h"
#import "JiShuZhuanLanMoreViewController.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "NetManager.h"
#import "PDFBrowserViewController.h"

@interface JiShuZhuanLanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *jiShuZhuanLanTableView;
    NSArray *_articleListArray;
}
@end

@implementation JiShuZhuanLanViewController
#define kImageShowViewHeight 150
#define kCellHeight 245
#define kCellBaseHeight 45
#define kCellAloneArticalHeight 40



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
    pictureV.target = self;
    pictureV.imageInfoArray = @[];
    pictureV.action = @selector(pictureShowMethod:);
    pictureV.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:pictureV];
    
    jiShuZhuanLanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65) style:UITableViewStylePlain];
    jiShuZhuanLanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    jiShuZhuanLanTableView.delegate = self;
    jiShuZhuanLanTableView.dataSource = self;
    jiShuZhuanLanTableView.showsVerticalScrollIndicator = NO;
    jiShuZhuanLanTableView.tableHeaderView = headerV;
    [self.view addSubview:jiShuZhuanLanTableView];
    
    [self requestMainDataWithURLString:kJSZLUrlString];
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
    if (netManager.downLoadData)
    {
        // 成功
        // 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        _articleListArray = [[dict objectForKey:@"data"] objectForKey:@"articleList"];
        [jiShuZhuanLanTableView reloadData];
    }
    else
    {
        // 失败
    }
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articleListArray.count>=5?5:_articleListArray.count;
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
    cell.dataIndex = indexPath.row;
    cell.articleDict = [_articleListArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - 图片轮播-->进入详情
- (void)pictureShowMethod:(PictureShowView *)pictureShowV
{
    NSDictionary *dict = [[pictureShowV.imageInfoArray objectAtIndex:pictureShowV.imageIndex] objectForKey:@"articleinfo"];
    
    if ([[dict objectForKey:@"urlpdf"] length]>5)
    {
        // PDF 跳转PDF页面
        NSLog(@"跳转PDF页面");
        PDFBrowserViewController *pdfBrowseVC = [[PDFBrowserViewController alloc]init];
        pdfBrowseVC.filePath = [dict objectForKey:@"urlpdf"];
        [self.navigationController pushViewController:pdfBrowseVC animated:YES];
    }
    else if ([[dict objectForKey:@"urlhtml"] length]>5)
    {
        // html
        JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
        if ([[dict objectForKey:@"urlvideo"] length]>5)
        {
            // 视频
            detailVC.vidioUrl = [dict objectForKey:@"urlvideo"];
        }
        detailVC.articalID = [dict objectForKey:@"articleid"];
        detailVC.htmlUrl = [dict objectForKey:@"urlhtml"];
        detailVC.titleStr = [dict objectForKey:@"type"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -- 跳转到技术专栏详情界面
- (void)enterDetailViewController:(JiShuZhuanLanSubView *)jszlSubV
{
    if ([[jszlSubV.subDict objectForKey:@"urlpdf"] length]>5)
    {
        // PDF 跳转PDF页面
        NSLog(@"跳转PDF页面");
        PDFBrowserViewController *pdfBrowseVC = [[PDFBrowserViewController alloc]init];
        pdfBrowseVC.filePath = [jszlSubV.subDict objectForKey:@"urlpdf"];
        [self.navigationController pushViewController:pdfBrowseVC animated:YES];
    }
    else if ([[jszlSubV.subDict objectForKey:@"urlhtml"] length]>5)
    {
        // html
        JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
        if ([[jszlSubV.subDict objectForKey:@"urlvideo"] length]>5)
        {
            // 视频
            detailVC.vidioUrl = [jszlSubV.subDict objectForKey:@"urlvideo"];
        }
        detailVC.articalID = [jszlSubV.subDict objectForKey:@"articleid"];
        detailVC.htmlUrl = [jszlSubV.subDict objectForKey:@"urlhtml"];
        detailVC.titleStr = [jszlSubV.subDict objectForKey:@"type"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark --跳转到技术专栏更多界面
- (void)enterMoreViewController:(JiShuZhuanLanCell *)cell
{
    // 进入更多
    // 更多 跳转页面
    JiShuZhuanLanMoreViewController *moreVC = [[JiShuZhuanLanMoreViewController alloc]init];
//    moreVC.moreArticalDict = [_articleListArray objectAtIndex:cell.dataIndex];
    moreVC.typeId = [[_articleListArray objectAtIndex:cell.dataIndex] objectForKey:@"type_id"];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArr = [[_articleListArray objectAtIndex:indexPath.row] objectForKey:@"article"];
    NSInteger count = (subArr.count>5)?5:subArr.count;
    NSLog(@"%ld",count);
    return kCellBaseHeight + kCellAloneArticalHeight*count;
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
