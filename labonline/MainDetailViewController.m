//
//  MainDetailViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/31.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainDetailViewController.h"
#import "MainListViewController.h"
#import "MenuViewController.h"


#define kBackViewTag 55
#define kMagazineCoverButtonTag 56
#define KCoverButtonWidth 115
#define KCoverButtonHeight 135
#define kDownLoadButtonTag 88
#define kBrowseButtonTag 89
#define kWangQiButtonTag 90


@interface MainDetailViewController ()<UIScrollViewDelegate>

@end

@implementation MainDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    self.title = @"杂志名";
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // 左侧返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 35, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"返回角.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"aniu_09.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(enterSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 底部背景
    NSInteger backViewWidth = kScreenWidth-10;
    NSInteger backViewheight = kScreenHeight-64-30;
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(5, 5, backViewWidth, backViewheight)];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.masksToBounds = YES;
    backV.layer.cornerRadius = 5;
    backV.tag = kBackViewTag;
    [self.view addSubview:backV];
    
    // 可滑动
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:backV.bounds];
    scrollV.backgroundColor = [UIColor clearColor];
    scrollV.delegate = self;
    scrollV.showsVerticalScrollIndicator = NO;
    [backV addSubview:scrollV];
    
    // 杂志封面
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton setFrame:CGRectMake(10, 10, KCoverButtonWidth, KCoverButtonHeight)];
    [coverButton setBackgroundImage:[UIImage imageNamed:@"wangqi.png"] forState:UIControlStateNormal];
    coverButton.tag = kMagazineCoverButtonTag;
    [scrollV addSubview:coverButton];
    // 基本信息
    // 标题
    UILabel *cateLable = [[UILabel alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 15,backViewWidth-20-KCoverButtonWidth, 20)];
    cateLable.text = @"期刊分类标题";
    cateLable.textAlignment = NSTextAlignmentLeft;
    cateLable.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1];
    cateLable.font = [UIFont systemFontOfSize:kOneFontSize];
    [scrollV addSubview:cateLable];
    // 期刊
    UILabel *qiKanLable = [[UILabel alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 35,backViewWidth-20-KCoverButtonWidth, 20)];
    qiKanLable.text = @"期刊数：2015年2月刊";
    qiKanLable.textAlignment = NSTextAlignmentLeft;
    qiKanLable.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    qiKanLable.font = [UIFont systemFontOfSize:kTwoFontSize];
    [scrollV addSubview:qiKanLable];
    
    // 收藏
    UILabel *shouCangLable = [[UILabel alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 55,backViewWidth-20-KCoverButtonWidth, 20)];
    shouCangLable.text = @"收藏：10次";
    shouCangLable.textAlignment = NSTextAlignmentLeft;
    shouCangLable.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    shouCangLable.font = [UIFont systemFontOfSize:kTwoFontSize];
    [scrollV addSubview:shouCangLable];
    // 大小
    UILabel *sizeLable = [[UILabel alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 75,backViewWidth-20-KCoverButtonWidth, 20)];
    sizeLable.text = @"大小：10M";
    sizeLable.textAlignment = NSTextAlignmentLeft;
    sizeLable.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    sizeLable.font = [UIFont systemFontOfSize:kTwoFontSize];
    [scrollV addSubview:sizeLable];
    
    UIImageView *youLanImgV = [[UIImageView alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 97,16, 15)];
    youLanImgV.image = [UIImage imageNamed:@"游览.png"];
    [scrollV addSubview:youLanImgV];
    // 游览数
    UILabel *youLanLable = [[UILabel alloc]initWithFrame:CGRectMake(40+KCoverButtonWidth, 99,backViewWidth-20-KCoverButtonWidth, 15)];
    youLanLable.text = @"3215";
    youLanLable.textAlignment = NSTextAlignmentLeft;
    youLanLable.textColor = [UIColor colorWithRed:232/255.0 green:21/255.0 blue:37/255.0 alpha:1];
    youLanLable.font = [UIFont systemFontOfSize:kTwoFontSize];
    [scrollV addSubview:youLanLable];
    // 按钮公用属性
    UIColor *borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    UIColor *backColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    UIColor *textColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
    //下载
    UIButton *downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downLoadButton setFrame:CGRectMake(KCoverButtonWidth+20, 120, 48, 22)];
    [downLoadButton setTitle:@"下载" forState:UIControlStateNormal];
    downLoadButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    [downLoadButton setTitleColor:textColor forState:UIControlStateNormal];
    downLoadButton.layer.masksToBounds = YES;
    downLoadButton.layer.cornerRadius = 10;
    downLoadButton.layer.borderColor = borderColor.CGColor;
    downLoadButton.layer.borderWidth = 1;
    downLoadButton.backgroundColor = backColor;
    downLoadButton.tag = kDownLoadButtonTag;
    [downLoadButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:downLoadButton];
    //阅读
    UIButton *browseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [browseButton setFrame:CGRectMake(KCoverButtonWidth+20+55, 120, 48, 22)];
    [browseButton setTitle:@"阅读" forState:UIControlStateNormal];
    [browseButton setTitleColor:textColor forState:UIControlStateNormal];
    browseButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    browseButton.layer.masksToBounds = YES;
    browseButton.layer.cornerRadius = 10;
    browseButton.layer.borderColor = borderColor.CGColor;
    browseButton.layer.borderWidth = 1;
    browseButton.backgroundColor = backColor;
    browseButton.tag = kBrowseButtonTag;
    [browseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:browseButton];
    // 往期
    UIButton *wangQiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wangQiButton setFrame:CGRectMake(KCoverButtonWidth+20+55+55, 120, 48, 22)];
    [wangQiButton setTitle:@"往期" forState:UIControlStateNormal];
    [wangQiButton setTitleColor:textColor forState:UIControlStateNormal];
    wangQiButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    wangQiButton.layer.masksToBounds = YES;
    wangQiButton.layer.cornerRadius = 10;
    wangQiButton.layer.borderColor = borderColor.CGColor;
    wangQiButton.layer.borderWidth = 1;
    wangQiButton.backgroundColor = backColor;
    wangQiButton.tag = kWangQiButtonTag;
    [wangQiButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:wangQiButton];
    
    
    NSString *desStr = @"    美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n   美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n   美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n   美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n     美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。";
    CGRect rect = [desStr boundingRectWithSize:CGSizeMake(backViewWidth-20, 99999)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kOneFontSize]} context:nil];
    UILabel *desLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 150,backViewWidth-20, rect.size.height)];
    desLab.text = desStr;
    desLab.textAlignment = NSTextAlignmentLeft;
    desLab.numberOfLines = 0;
    desLab.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    desLab.font = [UIFont systemFontOfSize:kTwoFontSize];
    [scrollV addSubview:desLab];
    
    if (backViewheight-150-rect.size.height<=10)
    {
        scrollV.contentSize = CGSizeMake(0, 150+rect.size.height+20);
    }
}

- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag)
    {
        case kWangQiButtonTag:
        {
            // 往期
            MenuViewController *menuVC=[[MenuViewController alloc] init];
            [self.navigationController pushViewController:menuVC animated:YES];
        }
            break;
        case kBrowseButtonTag:
        {
            // 文章列表
            MainListViewController *listVC = [[MainListViewController alloc]init];
            [self.navigationController pushViewController:listVC animated:YES];
        }
            break;
        case kDownLoadButtonTag:
        {
            // 下载
        }
            break;
        default:
            break;
    }
}

- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    NSLog(@"enterSearchViewController");
    NSLog(@"111");
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
