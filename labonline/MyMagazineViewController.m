//
//  MyMagazineViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyMagazineViewController.h"
#import "WangQiCell.h"


@interface MyMagazineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myMagazineTableV;
}
@end

@implementation MyMagazineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的杂志";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _myMagazineTableV = [[UITableView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, kScreenHeight-80) style:UITableViewStylePlain];
    _myMagazineTableV.delegate = self;
    _myMagazineTableV.dataSource = self;
    _myMagazineTableV.showsVerticalScrollIndicator = NO;
    _myMagazineTableV.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _myMagazineTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myMagazineTableV];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cell";
    WangQiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WangQiCell" owner:self options:0] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
