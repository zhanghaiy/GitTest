//
//  MyCommentViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentCell.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "JiShuZhuanLanDetailViewController.h"


@interface MyCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myCommentTableV;
    NSInteger _currentCellHeight;
    NSMutableArray *_myCommentArray;
    NSString *_userid;
}
@end

@implementation MyCommentViewController
#define kFooterViewHeight 40


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的评论";
    self.view.backgroundColor =[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
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
    
    
    _myCommentTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight-10-70) style:UITableViewStylePlain];
    _myCommentTableV.delegate = self;
    _myCommentTableV.dataSource = self;
    _myCommentTableV.backgroundColor = [UIColor clearColor];
    _myCommentTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myCommentTableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myCommentTableV];
    
//    _userid = kUserId;
//    NSString *urlStr = [NSString stringWithFormat:kMyEvaluationUrl,_userid];
//    [self requestDataWithUrlString:urlStr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _userid = kUserId;
    NSString *urlStr = [NSString stringWithFormat:kMyEvaluationUrl,_userid];
    [self requestDataWithUrlString:urlStr];
}

#pragma mark - 网络请求
#pragma mark --- 开始请求
- (void)requestDataWithUrlString:(NSString *)urlString
{
    NetManager *netManager = [[NetManager alloc]init];
    netManager.delegate = self;
    netManager.action = @selector(netManagerCallBack:);
    [netManager requestDataWithUrlString:urlString];
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
}
#pragma mark --- 网络回调
- (void)netManagerCallBack:(NetManager *)netManager
{
    [self.view removeLoadingVIewInView:self.view andTarget:self];
    // 我的评论列表
    if (netManager.failError)
    {
        // 失败
    }
    else if (netManager.downLoadData)
    {
        // 成功
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        NSInteger respCode = [[dic objectForKey:@"respCode"] integerValue];
        if (respCode == 1000)
        {
            // 成功
            NSArray *listArr = [dic objectForKey:@"list"];
            _myCommentArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in listArr)
            {
                [_myCommentArray insertObject:dic atIndex:0];
            }
            [_myCommentTableV reloadData];
        }
        else
        {
           
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EvaluCell";
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCommentCell" owner:self options:0] lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.cellHeight = _currentCellHeight;
    cell.evaluDict = [_myCommentArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *des = [[_myCommentArray objectAtIndex:indexPath.row] objectForKey:@"text"];
    NSInteger countHeight = [self countCellHeightOfString:des andWidth:kScreenWidth-100 andFontSize:kTwoFontSize];
    if (countHeight<=30)
    {
        _currentCellHeight = 125;
    }
    else
    {
        _currentCellHeight = countHeight + 95;
    }
    
    return _currentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[_myCommentArray objectAtIndex:indexPath.row] objectForKey:@"articleinfo"];
    if ([[dic objectForKey:@"urlhtml"] length]>5)
    {
        // html
        JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
        if ([[dic objectForKey:@"urlvideo"] length]>5)
        {
            // 视频
            detailVC.vidioUrl = [dic objectForKey:@"urlvideo"];
        }
        detailVC.articalDic = dic;
        [self.navigationController pushViewController:detailVC animated:YES];
    }

}


#pragma mark - 根据文字计算高度
- (NSInteger)countCellHeightOfString:(NSString *)text andWidth:(NSInteger)width andFontSize:(NSInteger)fontSize
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 99999)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.height+10;
}

#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
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
