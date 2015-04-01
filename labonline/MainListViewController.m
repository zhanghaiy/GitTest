//
//  MainListViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/31.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainListViewController.h"
#import "MainListCell.h"
#import "JiShuZhuanLanDetailViewController.h"

@interface MainListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_listTableView;
    NSArray *_listArray;
}
@end

@implementation MainListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    self.title = @"杂志名";
    self.view.backgroundColor = [UIColor whiteColor];
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
    
//    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    _listArray = @[@"心脑血管疾病预防",@"宝洁医疗诊断相机设计",@"心脑血管疾病预防",@"医学世界",@"心脑血管疾病预防"];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight-10) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_listTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    MainListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[MainListCell alloc]init];
        cell.target = self;
        cell.action = @selector(enterDetail:);
    }
    cell.listArray = _listArray;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据文章数确定cell高度
    return 30*_listArray.count+5;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark - 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 70, 25)];
    lab.text = @"生物检验";
    lab.textColor = [UIColor redColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 2;
    lab.font = [UIFont systemFontOfSize:12];
    [view addSubview:lab];
    return view;
}


- (void)enterDetail:(MainListCell *)cell
{
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
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
