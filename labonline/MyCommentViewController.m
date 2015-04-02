//
//  MyCommentViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentCell.h"


@interface MyCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myCommentTableV;
    NSInteger _currentCellHeight;
    NSArray *_dataArray;
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
    // right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"aniu_09.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(enterSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _dataArray = @[@"我们每一个生活在这个世界的人，总有一个思维时刻在催促着你前行，在前进的路上我们总是自觉或不自觉地调整着自己努力的方向。因为我们正在明白，在你的面前始终有一个你目前无法达到的目标，这个目标就象一剂强心针，将你的肾上腺素调到最亢奋的状态。以至于我们常常在目标之中却无端地失去了目标。",@"写的不错。。。。。。",@"一般般因为我们正在明白，在你的面前始终有一个你目前无法达到的目标",@"因为我们正在明白，在你的面前始终有一个你目前无法达到的目标，这个目标就象一剂强心针，将你的肾上腺素调到最亢奋的状态。以至于我们常常在目标之中却无端地失去了目标"];
    _myCommentTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight-10-70) style:UITableViewStylePlain];
    _myCommentTableV.delegate = self;
    _myCommentTableV.dataSource = self;
    _myCommentTableV.backgroundColor = [UIColor clearColor];
    _myCommentTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myCommentTableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myCommentTableV];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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
    cell.desLable.text = [_dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger countHeight = [self countCellHeightOfString:[_dataArray objectAtIndex:indexPath.row] andWidth:kScreenWidth-100 andFontSize:kTwoFontSize];
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

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    NSLog(@"enterSearchViewController");
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
