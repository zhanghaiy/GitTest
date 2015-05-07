//
//  EJTListViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EJTListViewController.h"
#import "MenuButton.h"
#import "EJTListCell.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "ProductDetailViewController.h"

@interface EJTListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_firstMenuArray;
    NSMutableArray *_seconMenudArray;
    NSMutableArray *_thirdMenuArray;
//    NSArray *_firstMenuArray;
//    NSArray *_seconMenudArray;
//    NSArray *_thirdMenuArray;
    
    NSMutableArray *_mainArray;
    NSArray *_pXrray;
    
//    NSInteger _currentType;
    
    UITableView *_smallTabV;
    UITableView *_leftTabV;
    UITableView *_rightTabV;
    UITableView *_mainTabV;
    
    BOOL _paiXu;
}
@end

@implementation EJTListViewController

#define kLeftButtonTag 100
#define kRightButtonTag 102
#define kMiddleButtonTag 101

#define KleftTabTag 11
#define kRightTabTag 12
#define kSmallTabTag 13
#define kMainTabTag 14

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([DeviceManager deviceVersion]>=7)
    {
        //界面调整
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    if (_enterFormHome == NO)
    {
        // 左侧按钮
        NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 26) andBackImageWithName:@"aniu_07.png"];
        leftButton.delegate = self;
        leftButton.action = @selector(backToPrePage);
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else
    {
        NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 26) andBackImageWithName:nil];
        leftButton.delegate = self;
        leftButton.action = nil;
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchVC);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _paiXu = NO;
    _mainArray = [[NSMutableArray alloc]init];
    [self makeUpMenuArray];
    
    NSString *firstMenuTitle = [[[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    self.title = firstMenuTitle;
    
    NSString *secondStr=[[[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    NSString *thirdStr=[[_thirdMenuArray objectAtIndex:_thirdMenu] objectForKey:@"classifyname"];
    self.title=[secondStr stringByAppendingFormat:@" -> %@",thirdStr];
    
    MenuButton *leftBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = kLeftButtonTag;
    [leftBtn setFrame:CGRectMake(0, 0, kScreenWidth/3, 30)];
    [leftBtn setTitle:firstMenuTitle forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    NSString *secMenuString = [[[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    MenuButton *middleBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    middleBtn.tag = kMiddleButtonTag;
    [middleBtn setFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, 30)];
    [middleBtn setTitle:secMenuString forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:middleBtn];
    
    MenuButton *rigBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    rigBtn.tag = kRightButtonTag;
    [rigBtn setFrame:CGRectMake(kScreenWidth*2/3, 0, kScreenWidth/3, 30)];
    [rigBtn setTitle:@"排序" forState:UIControlStateNormal];
    [rigBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rigBtn];
    
    _leftTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 31, kScreenWidth/2, kScreenHeight-95) style:UITableViewStylePlain];
    _leftTabV.delegate = self;
    _leftTabV.dataSource = self;
    _leftTabV.tag = KleftTabTag;
    [self.view addSubview:_leftTabV];
    
    _rightTabV = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 31, kScreenWidth/2, kScreenHeight-95) style:UITableViewStylePlain];
    _rightTabV.delegate = self;
    _rightTabV.dataSource = self;
    _rightTabV.tag = kRightTabTag;
    [self.view addSubview:_rightTabV];
    
    _smallTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 31, kScreenWidth/3, kScreenHeight-95) style:UITableViewStylePlain];
    _smallTabV.delegate = self;
    _smallTabV.dataSource = self;
    _smallTabV.tag = kSmallTabTag;
    [self.view addSubview:_smallTabV];
    
    _leftTabV.hidden = YES;
    _rightTabV.hidden = YES;
    _smallTabV.hidden = YES;
    _leftTabV.backgroundColor = [UIColor clearColor];
    _rightTabV.backgroundColor = [UIColor clearColor];
    _smallTabV.backgroundColor = [UIColor clearColor];
    
    _leftTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTabV.layer.masksToBounds = YES;
    _leftTabV.layer.cornerRadius = 2;
    _leftTabV.layer.borderWidth = 1;
    _leftTabV.layer.borderColor = [UIColor colorWithRed:228/255.0 green:129/255.0 blue:138/255.0 alpha:1].CGColor;
    
    _rightTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTabV.layer.masksToBounds = YES;
    _rightTabV.layer.cornerRadius = 2;
    _rightTabV.layer.borderWidth = 1;
    _rightTabV.layer.borderColor = [UIColor colorWithRed:228/255.0 green:129/255.0 blue:138/255.0 alpha:1].CGColor;
    
    _smallTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _smallTabV.layer.masksToBounds = YES;
    _smallTabV.layer.cornerRadius = 2;
    _smallTabV.layer.borderWidth = 1;
    _smallTabV.layer.borderColor = [UIColor colorWithRed:228/255.0 green:129/255.0 blue:138/255.0 alpha:1].CGColor;
    
    _mainTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, kScreenHeight-100) style:UITableViewStylePlain];
    _mainTabV.delegate = self;
    _mainTabV.dataSource = self;
    _mainTabV.tag = kMainTabTag;
    _mainTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTabV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainTabV];
    
    _pXrray = @[@"时间",@"浏览量"];
    
    _classifyid = [[_thirdMenuArray objectAtIndex:_thirdMenu] objectForKey:@"classifyid"];
    [self startRequestMainData];
}

#pragma mark - 搜索
- (void)enterSearchVC
{
    // 搜索
    NSLog(@"enterSearchViewController");
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求产品信息列表
- (void)startRequestMainData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?classifyid=%@",kEJTProductListUrl,_classifyid];
    [self requestWithUrl:urlStr];
}

#pragma mark - 网络请求
- (void)requestWithUrl:(NSString *)urlString
{
    NetManager *manager = [NetManager getShareManager];
    manager.delegate = self;
    manager.action = @selector(requestFinished:);
    [manager requestDataWithUrlString:urlString];
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
}

#pragma mark - 网络回调
- (void)requestFinished:(NetManager *)netManager
{
    [self.view removeLoadingVIewInView:self.view andTarget:self];
    if (netManager.downLoadData)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        NSLog(@"%@",dict);
        if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
        {
            // 成功
            NSArray *productList = [[dict objectForKey:@"data"] objectForKey:@"productList"];
            NSLog(@"%@",productList);
            if (_mainArray.count)
            {
                [_mainArray removeAllObjects];
            }
            for (NSDictionary *dict in productList)
            {
                NSLog(@"%@",dict);
                [_mainArray addObject:dict];
            }
            [_mainTabV reloadData];
        }
        else
        {
            NSLog(@"%@",[dict objectForKey:@"remark"]);
        }
    }
}

#pragma mark - UITableView Delegate
#pragma mark -- 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == KleftTabTag)
    {
        // left
        return _seconMenudArray.count;
    }
    else if (tableView.tag == kRightTabTag)
    {
        return _thirdMenuArray.count;
    }
    else if (tableView.tag == kSmallTabTag)
    {
        if (_paiXu)
        {
            return _pXrray.count;
        }
        else
        {
            return _firstMenuArray.count;
        }
    }
    else if (tableView.tag == kMainTabTag)
    {
        return _mainArray.count;
    }
    return 0;
}

#pragma mark -- cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMainTabTag)
    {
        return 160;
    }
    return 35;
}

#pragma mark -- 绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMainTabTag)
    {
        static NSString *cellId = @"MainEJTCell";
        EJTListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EJTListCell" owner:self options:0] lastObject];
        }
        NSDictionary *dict = [_mainArray objectAtIndex:indexPath.row];
        NSLog(@"%@",dict);
        if ([[dict objectForKey:@"producticon"] length]>2)
        {
            [cell.imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"producticon"]] placeholderImage:[UIImage imageNamed:@"wangqi.png"]];
        }
        else
        {
            cell.imageV.image = [UIImage imageNamed:@"暂无图片.jpg"];
        }
        if ([[dict objectForKey:@"producttitle"] length]>2)
        {
            cell.titleLabel.text = [dict objectForKey:@"producttitle"];
        }
        if ([[dict objectForKey:@"company"] length]>2)
        {
            cell.qKLabel.text = [dict objectForKey:@"company"];//暂时公司
        }
        if ([dict objectForKey:@"seenum"] != nil)
        {
            cell.yLCountLabel.text = [NSString stringWithFormat:@"%ld",[[dict objectForKey:@"seenum"] integerValue]];
        }
        return cell;
    }
    else
    {
        static NSString *cellId = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = [UIFont systemFontOfSize:kOneFontSize];
        }
        // 选中后背景色
        cell.textLabel.textColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
        // 选中后背景色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:217/255.0 green:0/255.0 blue:36/255.0 alpha:1];
        cell.selectedTextColor = [UIColor whiteColor];
        switch (tableView.tag)
        {
            case KleftTabTag:
            {
                cell.textLabel.text = [[[_seconMenudArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"];
                NSLog(@"~~~~%@",[[[_seconMenudArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"]);
            }
                break;
            case kRightTabTag:
            {
                NSLog(@"%@",[_thirdMenuArray objectAtIndex:0]);
                cell.textLabel.text = [[_thirdMenuArray objectAtIndex:indexPath.row] objectForKey:@"classifyname"];
            }
                break;
            case kSmallTabTag:
            {
                if (_paiXu)
                {
                    cell.textLabel.text = [_pXrray objectAtIndex:indexPath.row];
                }
                else
                {
                    cell.textLabel.text = [[[_firstMenuArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"];
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

#pragma mark -- 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag)
    {
        case KleftTabTag:
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:kMiddleButtonTag];
            [btn setTitle:[[[_seconMenudArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"] forState:UIControlStateNormal];
            _seconMenu = indexPath.row;
            _thirdMenuArray = [[_seconMenudArray objectAtIndex:indexPath.row] objectForKey:@"submenus"];
            [self.view bringSubviewToFront:_rightTabV];
            _rightTabV.hidden = NO;
            [self changeTableViewFrameWithTag:_rightTabV.tag andCount:_thirdMenuArray.count];
            [_rightTabV reloadData];
        }
            break;
        case kRightTabTag:
        {
            // 网络请求
            _thirdMenu = indexPath.row;
            _leftTabV.hidden = YES;
            _rightTabV.hidden = YES;
            UIButton *btn = (UIButton *)[self.view viewWithTag:kMiddleButtonTag];
            [btn setTitle:[[_thirdMenuArray objectAtIndex:indexPath.row] objectForKey:@"classifyname"] forState:UIControlStateNormal];
            _classifyid = [[_thirdMenuArray objectAtIndex:indexPath.row] objectForKey:@"classifyid"];
            [self startRequestMainData];
            [self changeButtonSelectedWithButtonTag:kMiddleButtonTag];
            
            NSString *secondStr=[[[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
            NSString *thirdStr=[[_thirdMenuArray objectAtIndex:indexPath.row] objectForKey:@"classifyname"];
            self.title=[secondStr stringByAppendingFormat:@" -> %@",thirdStr];
        }
            break;
        case kSmallTabTag:
        {
            if (_paiXu)
            {
                NSString *titl = [_pXrray objectAtIndex:indexPath.row];
                UIButton *btn = (UIButton *)[self.view viewWithTag:102];
                [btn setTitle:titl forState:UIControlStateNormal];
                _smallTabV.hidden = YES;
                if (indexPath.row == 0)
                {
                    [self timeSort];
                    [_mainTabV reloadData];
                }
                else if (indexPath.row == 1)
                {
                    [self seenumberSort];
                    [_mainTabV reloadData];
                }
                [self changeButtonSelectedWithButtonTag:kRightButtonTag];
            }
            else
            {
                _firstMenu = indexPath.row;
                NSString *titl = [[[_firstMenuArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"];
                UIButton *btn = (UIButton *)[self.view viewWithTag:kLeftButtonTag];
                [btn setTitle:titl forState:UIControlStateNormal];
                self.title = titl;
                _smallTabV.hidden = YES;
                
                _seconMenudArray = [[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"submenus"];
                UIButton *btn2 = (UIButton *)[self.view viewWithTag:kMiddleButtonTag];
                [btn2 setTitle:[[[_seconMenudArray objectAtIndex:0] objectForKey:@"info"] objectForKey:@"classifyname"] forState:UIControlStateNormal];
                
                _classifyid = [[[_firstMenuArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyid"];
                [self startRequestMainData];
                [self changeButtonSelectedWithButtonTag:kLeftButtonTag];
            }
        }
            break;
        case kMainTabTag:
        {
            // 选中产品信息 进入产品详情
            NSDictionary *proD = [_mainArray objectAtIndex:indexPath.row];
            ProductDetailViewController *proDetail=[[ProductDetailViewController alloc] init];
            proDetail.proDetail=proD;
            [self.navigationController pushViewController:proDetail animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 去掉多余的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 组建菜单数据结构
- (void)makeUpMenuArray
{
    _firstMenuArray = [[NSMutableArray alloc]init];
    _seconMenudArray = [[NSMutableArray alloc]init];
    _thirdMenuArray = [[NSMutableArray alloc]init];

    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    _firstMenuArray = [defauls objectForKey:@"MENUARRAY"];
    NSLog(@"%@",_firstMenuArray);
    _seconMenudArray = [[[defauls objectForKey:@"MENUARRAY"] objectAtIndex:_firstMenu] objectForKey:@"submenus"];
    NSLog(@"%@",_seconMenudArray);
    _thirdMenuArray = [[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"submenus"];
    NSLog(@"%@",_thirdMenuArray);
}

#pragma mark - 触空白收起菜单
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    _smallTabV.hidden = YES;
    _leftTabV.hidden = YES;
    _rightTabV.hidden = YES;
    
}


#pragma mark - 菜单按钮被点击
- (void)buttonClicked:(MenuButton *)btn
{
    [self changeButtonSelectedWithButtonTag:btn.tag];
    switch (btn.tag)
    {
        case kLeftButtonTag:
        {
            if (btn.selected)
            {
                NSLog(@"一级分类");
                [self reloadSmallTableViewWithPaiXu:NO];
                [self changeTableViewFrameWithTag:_smallTabV.tag andCount:_firstMenuArray.count];
                [self makeTableViewAlone:NO];
            }
            else
            {
                _smallTabV.hidden = YES;
            }
            
        }
            break;
        case kMiddleButtonTag:
        {
            if (btn.selected)
            {
                NSLog(@"产品分类");
                [self makeTableViewAlone:YES];
                _seconMenudArray = [[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"submenus"];
                [self changeTableViewFrameWithTag:_leftTabV.tag andCount:_seconMenudArray.count];
                
                [self.view bringSubviewToFront:_leftTabV];
                _leftTabV.hidden = NO;
                [_leftTabV reloadData];
            }
            else
            {
                _leftTabV.hidden = YES;
                _rightTabV.hidden = YES;
            }
            
        }
            break;
        case kRightButtonTag:
        {
            if (btn.selected)
            {
                NSLog(@"排序");
                [self makeTableViewAlone:NO];
                [self reloadSmallTableViewWithPaiXu:YES];
                [self changeTableViewFrameWithTag:_smallTabV.tag andCount:_pXrray.count];
            }
            else
            {
                _smallTabV.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 改变按钮选中状态
- (void)changeButtonSelectedWithButtonTag:(NSInteger)tag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    if (btn.selected)
    {
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        btn.selected = YES;
        [btn setBackgroundColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1]];
    }
}

#pragma mark - 控制产品菜单、排序菜单、主菜单不能同时出现
- (void)makeTableViewAlone:(BOOL)product
{
    _smallTabV.hidden = product;
    _leftTabV.hidden = !product;
}

#pragma mark - 刷新一级分类（排序）列表（变换位置）
- (void)reloadSmallTableViewWithPaiXu:(BOOL)isPx
{
    _paiXu = isPx;
    [self.view bringSubviewToFront:_smallTabV];
    
    CGRect rect = _smallTabV.frame;
    if (isPx)
    {
        rect.origin.x = kScreenWidth*2/3;
    }
    else
    {
        rect.origin.x = 0;
    }
    _smallTabV.frame = rect;
    _smallTabV.hidden = NO;
    [_smallTabV reloadData];
}

#pragma mark - 根据数据改变菜单的高度
- (void)changeTableViewFrameWithTag:(NSInteger)tag andCount:(NSInteger)counts
{
    UITableView *tabV = (UITableView *)[self.view viewWithTag:tag];
    CGRect rect = tabV.frame;
    if (counts*35<kScreenHeight-100)
    {
        rect.size.height = counts*35;
    }
    else
    {
        rect.size.height = kScreenHeight-100;
    }
    tabV.frame = rect;
}

#pragma mark - 时间排序
- (void)timeSort
{
    for (int i = 0; i < _mainArray.count-1; i ++)
    {
        NSDictionary *dict = [_mainArray objectAtIndex:i];
        NSDate *date1 = [self stringChangToDate:[dict objectForKey:@"updatetime"]];
        for (int j = i +1; j < _mainArray.count; j++)
        {
            NSDictionary *dict2 = [_mainArray objectAtIndex:j];
            NSDate *date2 = [self stringChangToDate:[dict2 objectForKey:@"updatetime"]];
            if ([date1 compare:date2] == NSOrderedAscending)
            {
                [self exchangeObjectIndex:i andIndex:j];
            }
        }
    }
}
#pragma mark -- 交换位置（排序）
- (void)exchangeObjectIndex:(NSInteger)x andIndex:(NSInteger )y
{
    NSDictionary *dic = [_mainArray objectAtIndex:x];
    NSDictionary *dict2 = [_mainArray objectAtIndex:y];
    [_mainArray replaceObjectAtIndex:x withObject:dict2];
    [_mainArray replaceObjectAtIndex:y withObject:dic];
}

#pragma mark -- 字符串转时间
- (NSDate *)stringChangToDate:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    return inputDate;
}

#pragma mark - 浏览量排序
- (void)seenumberSort
{
    for (int i = 0; i < _mainArray.count-1; i ++)
    {
        NSDictionary *dict = [_mainArray objectAtIndex:i];
        NSInteger seenum1 = [[dict objectForKey:@"seenum"] integerValue];
        for (int j = i +1; j < _mainArray.count; j++)
        {
            NSDictionary *dict2 = [_mainArray objectAtIndex:j];
            NSInteger seenum2 = [[dict2 objectForKey:@"seenum"] integerValue];
            if (seenum1<seenum2)
            {
                [self exchangeObjectIndex:i andIndex:j];
            }
        }
    }
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
