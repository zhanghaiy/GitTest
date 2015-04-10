//
//  MainViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainViewController.h"

#import "DeviceManager.h"       // 版本信息
#import "LeftViewController.h"  // 左侧
#import "ShowPicture.h"         // 放大图View
#import "PictureShowView.h"     // 轮播图 View
#import "MainNewView.h"         // 最新杂志View
#import "JSZLCateView.h"        // 技术专栏分类

#import "MainDetailViewController.h"            // 主页详情（杂志详情）
#import "JiShuZhuanLanViewController.h"         // 技术专栏
#import "JiShuZhuanLanDetailViewController.h"   // 技术专栏详情
#import "JiShuZhuanLanMoreViewController.h"     // 技术专栏更多
#import "SettingCenterViewController.h"         // 设置
#import "SearchViewController.h"                // 搜索
#import "PersonCenterViewController.h"          // 下拉刷新
#import "YRSideViewController.h"                // 侧滑
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface MainViewController ()<LeftViewControllerDelegate,UIScrollViewDelegate>
{
    UIScrollView *_backScrollV;
}
@end

@implementation MainViewController
// 图片轮播View高度
#define kTopImageShowViewHeight 150
// 最新杂志View 高度
#define kMainNewViewHeight 240
// 技术专栏分类单位行高
#define kJSZLAloneHeight 80
// 技术专栏头部高度
#define kJSZLHeadHeight 40

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([DeviceManager deviceVersion]>=7)
    {
        //界面调整
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:216/255.0 green:0 blue:0 alpha:1]}];
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.title = @"医检在线";
    
    //在导航视图底添加分割线
    UIView *navDividingLine = [[UIView alloc] init];
    if (navDividingLine != nil)
    {
        navDividingLine.frame = CGRectMake(0, 0, kScreenWidth, 1);
        navDividingLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:navDividingLine];
    }

    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30) andBackImageWithName:@"tubiao_04.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popToLeftMenu);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchVC);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    _backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65)];
    _backScrollV.delegate =self;
    [self.view addSubview:_backScrollV];
    
     // 图片轮播View
    PictureShowView *pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, kTopImageShowViewHeight)];
    pictureV.imageInfoArray = @[@"",@"",@"",@"",@""];
    pictureV.target = self;
    pictureV.action = @selector(pictureShowMethod:);
    [_backScrollV addSubview:pictureV];
    
    // 最新杂志
    MainNewView *mainNewV = [[[NSBundle mainBundle]loadNibNamed:@"MainNewView" owner:self options:0] lastObject];
    mainNewV.frame = CGRectMake(5, 15+kTopImageShowViewHeight, kScreenWidth-10, kMainNewViewHeight);
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
    jSZLCateV.frame = CGRectMake(5, 25+kTopImageShowViewHeight+kMainNewViewHeight, kScreenWidth-10, jSZLHeight);
    jSZLCateV.cateDataArray = cateArray;
    jSZLCateV.target = self;
    jSZLCateV.action = @selector(enterJSZLVireController:);
    [_backScrollV addSubview:jSZLCateV];
    
    _backScrollV.contentSize = CGSizeMake(kScreenWidth, 50+kTopImageShowViewHeight+kMainNewViewHeight+jSZLHeight);
    _backScrollV.showsVerticalScrollIndicator = NO;
}

#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
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
- (void)enterSearchVC
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
//            SettingCenterViewController *settingVC = [[SettingCenterViewController alloc]init];
//            [self.navigationController pushViewController:settingVC animated:YES];
            LoginViewController *loginVC=[[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }

}


#pragma mark - 放大图片
- (void)enLargeImage:(MainNewView *)mainNewView
{
    self.navigationController.navigationBarHidden = YES;
    ShowPicture *pictureV = [[ShowPicture alloc]initWithFrame:self.view.bounds];
    [pictureV setSelectedIndex:mainNewView.clickImageIndex andImageDataArray:mainNewView.imageDataArray];
    pictureV.target = self;
    pictureV.action = @selector(pictureCallBack:);
    [self.view addSubview:pictureV];
}

- (void)pictureCallBack:(ShowPicture *)picV
{
    [picV removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
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
