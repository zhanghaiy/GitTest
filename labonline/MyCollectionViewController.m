//
//  MyCollectionViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionCell.h"


@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myCollectionTableView;
}

@end

@implementation MyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _myCollectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, kScreenHeight-80) style:UITableViewStylePlain];
    _myCollectionTableView.delegate = self;
    _myCollectionTableView.dataSource = self;
    _myCollectionTableView.showsVerticalScrollIndicator = NO;
    _myCollectionTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _myCollectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myCollectionTableView];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"";
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCollectionCell" owner:self options:0] lastObject];
        cell.target = self;
        cell.action = @selector(deleteMyCollection:);
    }
    
    return cell;
}

- (void)deleteMyCollection:(MyCollectionCell *)cell
{
   // 删除收藏
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
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
