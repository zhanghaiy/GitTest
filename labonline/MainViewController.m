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
#import "RegisterViewController.h"

#import "NetManager.h"   // 网络请求

#import "PDFBrowserViewController.h"
#import "JiShuZhuanLanDetailViewController.h"

@interface MainViewController ()<LeftViewControllerDelegate,UIScrollViewDelegate>
{
    UIScrollView *_backScrollV;
    JSZLCateView *_jSZLCateV;
    PictureShowView *_pictureV;
    MainNewView *_mainNewV;
    NSDictionary *_newMagazineDict;
    NSMutableArray *_newMagazineImageArray;
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
    _pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, kTopImageShowViewHeight)];
    _pictureV.target = self;
    _pictureV.action = @selector(pictureShowMethod:);
    [_backScrollV addSubview:_pictureV];
    
    // 最新杂志
    _mainNewV = [[[NSBundle mainBundle]loadNibNamed:@"MainNewView" owner:self options:0] lastObject];
    _mainNewV.frame = CGRectMake(5, 15+kTopImageShowViewHeight, kScreenWidth-10, kMainNewViewHeight);
    _mainNewV.target = self;
    _mainNewV.action = @selector(enLargeImage:);
    [_backScrollV addSubview:_mainNewV];
    
    UITapGestureRecognizer *tapMainV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterMagazineViewController:)];
    [_mainNewV addGestureRecognizer:tapMainV];
    
    // 技术专栏
    // 先计算技术专栏的高度
    
    _jSZLCateV = [[[NSBundle mainBundle]loadNibNamed:@"JSZLCateView" owner:self options:0] lastObject];
    _jSZLCateV.frame = CGRectMake(5, 25+kTopImageShowViewHeight+kMainNewViewHeight, kScreenWidth-10, kJSZLAloneHeight);
    _jSZLCateV.target = self;
    _jSZLCateV.action = @selector(enterJSZLVireController:);
    [_backScrollV addSubview:_jSZLCateV];
    
    [self requestMainDataWithURLString:kMainUrlString];
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
        [self addControlsWithDictionary:[dict objectForKey:@"data"]];
    }
    else
    {
        // 失败
    }
}

#pragma mark --根据数据来添加UI控件
- (void)addControlsWithDictionary:(NSDictionary *)dict
{
    // 最新主题的数据
    _newMagazineDict = [[dict objectForKey:@"newMagazineList"] objectAtIndex:0];
    NSInteger imageCount = [[_newMagazineDict objectForKey:@"picturenum"] integerValue];
    _newMagazineImageArray = [[NSMutableArray alloc]init];
    for (int i = 1; i <= imageCount; i ++)
    {
        NSString *key = [NSString stringWithFormat:@"pictureurl%d",i];
        NSString *imageUrl = [_newMagazineDict objectForKey:key];
        [_newMagazineImageArray addObject:imageUrl];
    }
    _mainNewV.imageDataArray = _newMagazineImageArray;
    _mainNewV.mainMagazineDict = _newMagazineDict;
    
    // 轮播图片数据
    NSArray *pictureShowArray = [dict objectForKey:@"pictureList"];
    _pictureV.imageInfoArray = pictureShowArray;
    
    // 技术专栏标签
    NSArray *jSZLArray = [dict objectForKey:@"technologyList"];
    NSInteger hang = jSZLArray.count%4?jSZLArray.count/4+1:jSZLArray.count/4;
    NSInteger jSZLHeight = kJSZLHeadHeight + hang*kJSZLAloneHeight;
    CGRect rect = _jSZLCateV.frame;
    rect.size.height = jSZLHeight;
    _jSZLCateV.frame = rect;
    _jSZLCateV.cateDataArray = jSZLArray;
    
    // 改变scrollView可滑动
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
    mainDetailVC.imagesArray = _newMagazineImageArray;
    mainDetailVC.detailDict = _newMagazineDict;
    [self.navigationController pushViewController:mainDetailVC animated:YES];
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
        detailVC.htmlUrl = [dict objectForKey:@"urlhtml"];
        detailVC.titleStr = [dict objectForKey:@"type"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - 进入技术专栏界面
- (void)enterJSZLVireController:(JSZLCateView *)jSZLCateView
{
    NSLog(@"进入技术专栏界面");
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
    switch (type)
    {
        case MainPage:
        {
            // 主页
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
            case LogIn:
        {
            // 登陆
            LoginViewController *loginVC=[[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
            break;
        case Register:
        {
            // 注册
            RegisterViewController *registerVC = [[RegisterViewController alloc]init];
            [self presentViewController:registerVC animated:YES completion:nil];
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

#pragma mark - 删除图片展示View
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
