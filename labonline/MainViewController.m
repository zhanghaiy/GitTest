//
//  MainViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "VidioPlayerViewController.h"
// pdf
#import "PDFBrowserViewController.h"
// 轮播
#import "PictureShowView.h"
#import "MainCell.h"
// 技术专栏
#import "JiShuZhuanLanCell.h"
#import "JiShuZhuanLanSubView.h"
#import "JiShuZhuanLanMoreViewController.h"
#import "JiShuZhuanLanDetailViewController.h"
// Main
#import "MainDetailViewController.h"
// 下拉刷新
#import "EGORefreshTableHeaderView.h"
#import "PersonCenterViewController.h"

#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,LeftViewControllerDelegate,EGORefreshTableHeaderDelegate,MainCellDelegate>
{
    NSArray *_mainPageDataArray;
    NSArray *_jiShuZhuanLanDataArray;
    UITableView *_tableView;
    BOOL _homePage;
    //刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@end

@implementation MainViewController
#define kImageShowViewHeight 150
#define kMainPreButtonWidth 60
#define kMainCellHeight 200
#define kJiShuZhuanLanCellHeight 245
#define kShowImagesViewTag 333
#define kShowScrollViewTag 334
#define kPageControlTag 335
#define kImageButtonTag 112233

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _homePage = YES;
    self.title = @"医检在线";
    NSLog(@"测试");
    NSLog(@"1111");
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //修改标题颜色 其中 UITextAttributeTextColor和UITextAttributeFont 属性是文字颜色和字体
    UIColor *titleColor = [UIColor colorWithRed:215/255.0 green:0 blue:37/255.0 alpha:1];
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:titleColor, UITextAttributeTextColor,titleColor, UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,titleFont, UITextAttributeFont,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:paramDic];
    //左侧按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 35, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"tubiao_04.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popToLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"aniu_09.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(enterSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 图片轮播View
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kImageShowViewHeight+5)];
    PictureShowView *pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(12, 5, kScreenWidth-24, kImageShowViewHeight)];
    pictureV.imageInfoArray = @[@"",@"",@"",@"",@""];
    pictureV.target = self;
    pictureV.action = @selector(pictureShowMethod:);
    [headV addSubview:pictureV];
    
    // 表视图
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-74) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = headV;
    [self.view addSubview:_tableView];
    
    // 往期按钮
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setFrame:CGRectMake(kScreenWidth-kMainPreButtonWidth-10, kScreenHeight-kMainPreButtonWidth-74, kMainPreButtonWidth, kMainPreButtonWidth)];
    [preButton setTitle:@"往期" forState:UIControlStateNormal];
    [preButton setTitleColor:[UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    preButton.layer.masksToBounds = YES;
    preButton.layer.cornerRadius = preButton.frame.size.width/2;
    preButton.layer.borderWidth = 2;
    preButton.layer.borderColor = [UIColor colorWithRed:215/255.0 green:104/255.0 blue:121/255.0 alpha:1].CGColor;
    preButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [preButton addTarget:self action:@selector(preButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preButton];
    
    _reloading = NO;
    [self createHeaderView];
    
    //在导航视图底添加分割线
    UIView *navDividingLine = [[UIView alloc] init];
    if (navDividingLine != nil)
    {
        navDividingLine.frame = CGRectMake(0, 0, kScreenWidth, 1);
        navDividingLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:navDividingLine];
    }

}

#pragma mark - 图片轮播-->进入详情
- (void)pictureShowMethod:(PictureShowView *)pictureShowV
{
    // 进入技术专栏详情（通用的）
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.titleStr = @"文章详情";
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    NSLog(@"enterSearchViewController");
}

#pragma mark - LeftViewControllerDelegate(侧滑回到主页)
- (void)pushViewControllerWithResourceType:(ResourceType)type
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
//    LoginViewController *loginVC=(LoginViewController*)[[UIApplication sharedApplication] delegate];
//    YRSideViewController *sideViewController=[loginVC sideViewController];
    [sideViewController hideSideViewController:YES];
    
    if (type == PDFType)
    {
        // PDF阅读
        PDFBrowserViewController *pdfBrowseVC = [[PDFBrowserViewController alloc]init];
        pdfBrowseVC.fileName = @"PDF阅读";
        pdfBrowseVC.filePath = @"http://192.168.0.253:8080/regulatory/temp/abc.pdf";//[[NSBundle mainBundle]pathForResource:@"testPDF2" ofType:@"pdf"];
        [self.navigationController pushViewController:pdfBrowseVC animated:YES
         ];
    }
    else if (type == VidioType)
    {
        // 视频
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
        VidioPlayerViewController *vidioVC = [[VidioPlayerViewController alloc]init];
        vidioVC.vidioPath = path;
        [self.navigationController pushViewController:vidioVC animated:YES];
    }
    else if (type == JiShuZhuanLan)
    {
        _homePage = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self changeLanMu];
    }
    else if (type == MainPage)
    {
        _homePage = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self changeLanMu];
    }
    else if (type == PersonCenter)
    {
        PersonCenterViewController *personVC = [[PersonCenterViewController alloc]init];
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

#pragma mark - 往期按钮点击事件
- (void)preButtonClicked
{
    MenuViewController *menuVC=[[MenuViewController alloc] init];
    [self.navigationController pushViewController:menuVC animated:YES];
}

#pragma mark - UITableViewDelegate
#pragma mark --数据数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_homePage)
    {
        // 主页
//        return _mainPageDataArray.count;
        return 3;
    }
    else
    {
        // 技术专栏
//        return _jiShuZhuanLanDataArray.count;
        return 4;
    }
    return 0;
}

#pragma mark --cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_homePage)
    {
        return kMainCellHeight;
    }
    else
    {
        return kJiShuZhuanLanCellHeight;
    }
    return 0;
}

#pragma mark -- 绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_homePage)
    {
        // 主页
        static NSString *cellId = @"newsCell";
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MainCell" owner:self options:0] lastObject];
            cell.delegate=self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellId = @"JiShuZhuanLanCell";
        JiShuZhuanLanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JiShuZhuanLanCell" owner:self options:0] lastObject];
            cell.delegate = self;
            // 更多 参数JiShuZhuanLanCell
            cell.buttonClickSelector = @selector(moreInfoWithObject:);
            // 详情 参数JiShuZhuanLanSubView
            cell.jszlViewClickedAction = @selector(enterDetail:);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark -- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_homePage)
    {
        // 主页
        MainDetailViewController *mainDetailVC = [[MainDetailViewController alloc]init];
        [self.navigationController pushViewController:mainDetailVC animated:YES];
    }
}


#pragma mark - 主页方法
#pragma mark --MainCellDelegate
- (void)imageButtonClicked:(UIButton *)btn withDataArray:(NSArray *)array
{
    [self createShowImagesViewWithDataArray:array andIndex:btn.tag-kImageButtonTag];
}
#pragma mark --创建展示图片的View
- (void)createShowImagesViewWithDataArray:(NSArray *)array andIndex:(NSInteger)index
{
    self.navigationController.navigationBarHidden = YES;
    UIView *showImgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    showImgView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    showImgView.tag = kShowImagesViewTag;
    showImgView.backgroundColor = [UIColor colorWithRed:18/255.0 green:28/255.0 blue:31/255.0 alpha:1];
    [self.view addSubview:showImgView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, showImgView.frame.size.height)];
    scrollView.contentSize = CGSizeMake(kScreenWidth*array.count, kScreenWidth);
    scrollView.tag = kShowScrollViewTag;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
    [showImgView addSubview:scrollView];
    
    for (int i = 0; i < array.count; i ++)
    {
        UIImage *img = [UIImage imageNamed:[array objectAtIndex:i]];
        NSInteger imageWid = img.size.width;
        NSInteger imageHeight = img.size.height;
        if (imageWid>kScreenWidth-20||imageHeight>(kScreenHeight-120))
        {
            float level = (float)imageWid/(float)imageHeight;
            imageWid = kScreenWidth-20;
            imageHeight = imageWid/level;
        }
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*kScreenWidth+(kScreenWidth-imageWid)/2, (kScreenHeight-imageHeight)/2, imageWid, imageHeight)];
        imgV.image = img;
        [scrollView addSubview:imgV];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, showImgView.frame.size.height-50, 100, 10)];
    pageControl.tag = kPageControlTag;
    pageControl.numberOfPages = array.count;
    pageControl.currentPage = index;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    [showImgView addSubview:pageControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgVMethod)];
    [showImgView addGestureRecognizer:tap];
}

#pragma mark --tapMethod
- (void)tapImgVMethod
{
    self.navigationController.navigationBarHidden = NO;
    UIView *view = (UIScrollView *)[self.view viewWithTag:kShowImagesViewTag];
    [view removeFromSuperview];
}

#pragma mark - 技术专栏页面方法
#pragma mark --跳转到技术专栏更多界面
- (void)moreInfoWithObject:(JiShuZhuanLanCell *)cell
{
    // 更多 跳转页面
    JiShuZhuanLanMoreViewController *moreVC = [[JiShuZhuanLanMoreViewController alloc]init];
    [self.navigationController pushViewController:moreVC animated:YES];
}
#pragma mark -- 跳转到技术专栏详情界面
- (void)enterDetail:(JiShuZhuanLanSubView *)jszlSubView
{
    JiShuZhuanLanDetailViewController *jSZLDetailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    jSZLDetailVC.titleStr = @"生物检验";
    [self.navigationController pushViewController:jSZLDetailVC animated:YES];
}

#pragma mark - 切换栏目
- (void)changeLanMu
{
    if (_homePage)
    {
        // 主页
        self.title = @"医检在线";
    }
    else
    {
        // 技术专栏
        self.title = @"技术专栏";
    }
    [_tableView reloadData];

}
#pragma mark - 左侧菜单
-(void)popToLeftMenu{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}
#pragma mark - 下拉刷新
-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark --EGORefreshTableHeaderDelegate
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
        // 定时器模拟刷新（网络请求 请求回来后调stopRefresh）
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMetnod) userInfo:nil repeats:NO];
    }
    else
    {
        // 告诉用户正在加载
    }
}

- (void)timerMetnod
{
    [self stopRefresh];
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [_tableView reloadData];
}

#pragma mark --UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kShowScrollViewTag)
    {
        UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:kPageControlTag];
        pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
    }
    else
    {
        [_refreshHeaderView
         egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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
