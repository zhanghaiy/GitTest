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
#define kAskViewWidth 220
#define kAskViewHeight 100
#define kAskViewTag 5656

#define kSureButtonTag 5757
#define kNOtSureButtonTag 5758
#define kSuresButtonHeight 60


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     // 阅读
     
}

#pragma mark - MyCollectionCell callBack
- (void)deleteMyCollection:(MyCollectionCell *)cell
{
    // 删除收藏
    [self createDeleteView];
}

#pragma mark - 删除弹出框
- (void)createDeleteView
{
    UIView *askV = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-kAskViewWidth)/2, (kScreenHeight-kAskViewWidth)/2, kAskViewWidth, kAskViewHeight)];
    askV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    askV.layer.masksToBounds = YES;
    askV.tag = kAskViewTag;
    askV.userInteractionEnabled = YES;
    askV.layer.cornerRadius = 5;
    askV.layer.borderColor = [UIColor colorWithRed:223/255.0 green:45/255.0 blue:82/255.0 alpha:1].CGColor;
    askV.layer.borderWidth = 1;
    [self.view addSubview:askV];
    
    NSInteger space = (kAskViewWidth-kSuresButtonHeight*2)/3;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = kSureButtonTag;
    [leftBtn setFrame:CGRectMake(space, 20, kSuresButtonHeight, kSuresButtonHeight)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [askV addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(kAskViewWidth-kSuresButtonHeight-space, 20, 60, 60)];
    rightBtn.tag = kNOtSureButtonTag;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [askV addSubview:rightBtn];
}

- (void)sureButtonClicked:(UIButton *)btn
{
    UIView *askV = (UIView *)[self.view viewWithTag:kAskViewTag];
    [askV removeFromSuperview];
    switch (btn.tag)
    {
        case kSureButtonTag:
        {
            // 删除
        }
            break;
        case kNOtSureButtonTag:
        {
            // 取消
        }
            break;
            
        default:
            break;
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
