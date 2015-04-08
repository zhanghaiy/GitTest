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
#import "MainNewView.h"
#import "JSZLCateView.h"
#import "MainDetailViewController.h"
// 技术专栏
#import "JiShuZhuanLanViewController.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "JiShuZhuanLanMoreViewController.h"

#import "SettingCenterViewController.h"
// 下拉刷新
#import "PersonCenterViewController.h"

#import "SearchViewController.h"


#import "YRSideViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()<LeftViewControllerDelegate,UIScrollViewDelegate>
{
    UIScrollView *_backScrollV;
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

#define kMainNewViewHeight 240
#define kJSZLAloneHeight 80
#define kJSZLHeadHeight 40

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"医检在线";
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
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
    // right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"aniu_09.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(enterSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65)];
    _backScrollV.delegate =self;
    [self.view addSubview:_backScrollV];
    
     // 图片轮播View
    PictureShowView *pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, kImageShowViewHeight)];
    pictureV.imageInfoArray = @[@"",@"",@"",@"",@""];
    pictureV.target = self;
    pictureV.action = @selector(pictureShowMethod:);
    [_backScrollV addSubview:pictureV];
    
    // 最新杂志
    MainNewView *mainNewV = [[[NSBundle mainBundle]loadNibNamed:@"MainNewView" owner:self options:0] lastObject];
    mainNewV.frame = CGRectMake(5, 15+kImageShowViewHeight, kScreenWidth-10, kMainNewViewHeight);
    mainNewV.target = self;
    mainNewV.action = @selector(enLargeImage:);
    mainNewV.imageDataArray = @[@"12.jpg",@"pictureShow.png",@"文章缩略图.png",@"pictureShow.png",@"12.jpg"];
    [_backScrollV addSubview:mainNewV];
    
    UITapGestureRecognizer *tapMainV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterMagazineViewController:)];
    [mainNewV addGestureRecognizer:tapMainV];
    
    // 技术专栏
    // 先计算技术专栏的高度
    NSArray *cateArray = @[@"生物检验",@"物理研究",@"生物检验",@"物理研究",@"生物检验",@"物理研究"];// 模拟数据
    NSInteger hang = cateArray.count%4?cateArray.count/4+1:cateArray.count/4;
    NSInteger jSZLHeight = kJSZLHeadHeight + hang*kJSZLAloneHeight;
    JSZLCateView *jSZLCateV = [[[NSBundle mainBundle]loadNibNamed:@"JSZLCateView" owner:self options:0] lastObject];
    jSZLCateV.frame = CGRectMake(5, 25+kImageShowViewHeight+kMainNewViewHeight, kScreenWidth-10, jSZLHeight);
    jSZLCateV.cateDataArray = cateArray;
    jSZLCateV.target = self;
    jSZLCateV.action = @selector(enterJSZLVireController:);
    [_backScrollV addSubview:jSZLCateV];
    
    _backScrollV.contentSize = CGSizeMake(kScreenWidth, 50+kImageShowViewHeight+kMainNewViewHeight+jSZLHeight);
    _backScrollV.showsVerticalScrollIndicator = NO;
}

#pragma mark - 进入 MainDetailViewController
- (void)enterMagazineViewController:(UITapGestureRecognizer *)tap
{
    MainDetailViewController *mainDetailVC = [[MainDetailViewController alloc]init];
    mainDetailVC.iamgesArray = @[@"12.jpg",@"pictureShow.png",@"文章缩略图.png",@"pictureShow.png",@"12.jpg"];;
    [self.navigationController pushViewController:mainDetailVC animated:YES];
}

#pragma mark - 图片轮播-->进入详情
- (void)pictureShowMethod:(PictureShowView *)pictureShowV
{
    // 进入技术专栏详情（通用的）
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.titleStr = @"文章详情";
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - 进入技术专栏界面
- (void)enterJSZLVireController:(JSZLCateView *)jSZLCateView
{
    if (jSZLCateView.enterMoreVC)
    {
        // 更多界面
        JiShuZhuanLanMoreViewController *moreVC = [[JiShuZhuanLanMoreViewController alloc]init];
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    else
    {
        // 技术专栏主页
        JiShuZhuanLanViewController *jszlVC = [[JiShuZhuanLanViewController alloc]init];
        [self.navigationController pushViewController:jszlVC animated:YES];
    }
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    NSLog(@"enterSearchViewController");
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - LeftViewControllerDelegate(侧滑回到主页)
- (void)pushViewControllerWithIndex:(NSInteger)type
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController hideSideViewController:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    switch (type) {
        case MainPage:
        {
            
        }
            break;
        case JiShuZhuanLan:
        {
            JiShuZhuanLanViewController *jSZLViewController = [[JiShuZhuanLanViewController alloc]init];
            jSZLViewController.enterFromHome = YES;
            [self.navigationController pushViewController:jSZLViewController animated:YES];
        }
            break;
        case WangQi:
        {
            MenuViewController *menuVC=[[MenuViewController alloc] init];
            menuVC.enterFromHome = YES;
            [self.navigationController pushViewController:menuVC animated:YES];
        }
            break;
        case PersonCenter:
        {
            PersonCenterViewController *personVC = [[PersonCenterViewController alloc]init];
            [self.navigationController pushViewController:personVC animated:YES];
        }
            break;
        case SettingCenter:
        {
            SettingCenterViewController *settingVC = [[SettingCenterViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }

}


#pragma mark - 放大图片
- (void)enLargeImage:(MainNewView *)mainNewView
{
    [self createShowImagesViewWithDataArray:mainNewView.imageDataArray andIndex:mainNewView.clickImageIndex];
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

#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}

#pragma mark --UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kShowScrollViewTag)
    {
        UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:kPageControlTag];
        pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
    }
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
