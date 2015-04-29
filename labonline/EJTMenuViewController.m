//
//  EJTMenuViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EJTMenuViewController.h"
#import "EJTListViewController.h"
#import "MenuButton.h"

@interface EJTMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *leftArray;
    NSArray *rightArray;
    UITableView *leftTab;
    UITableView *rightTab;
    
}
@end

#define kOneBtnTag 10
#define kTwoBtnTag 11
#define kLeftTabTag 12
#define kRightTabTag 13

@implementation EJTMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    MenuButton *oneBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    [oneBtn setFrame:CGRectMake(0, 64, kScreenWidth/2, 30)];
    [oneBtn setTitle:@"菜单1" forState:UIControlStateNormal];
    [oneBtn addTarget:self action:@selector(oneMenu:) forControlEvents:UIControlEventTouchUpInside];
    oneBtn.backgroundColor = [UIColor whiteColor];
    oneBtn.tag = kOneBtnTag;
    [self.view addSubview:oneBtn];
    
    MenuButton *secBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    [secBtn setFrame:CGRectMake(kScreenWidth/2, 64, kScreenWidth/2, 30)];
    [secBtn setTitle:@"菜单2" forState:UIControlStateNormal];
    [secBtn addTarget:self action:@selector(secBtn:) forControlEvents:UIControlEventTouchUpInside];
    secBtn.backgroundColor = [UIColor whiteColor];
    secBtn.tag = kTwoBtnTag;
    [self.view addSubview:secBtn];
    
    leftArray = @[@[@"生化",@"血液",@"免疫"],@[@"接种仪",@"血培养仪"],@[@"菜单1",@"菜单2",@"菜单3",@"菜单4"],@[@"菜单1",@"菜单2",@"菜单3",@"菜单4",@"菜单5"],@[@"菜单1",@"菜单2",@"菜单3",@"菜单4",@"菜单5"],@[@"菜单1",@"菜单2",@"菜单3",@"菜单4",@"菜单5"],@[@"菜单1",@"菜单2",@"菜单3",@"菜单4",@"菜单5"],@[@"菜单1",@"菜单2",@"菜单3",@"菜单4",@"菜单5"]];
    rightArray = [leftArray objectAtIndex:0];
    
    leftTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth/2, kScreenHeight-94) style:UITableViewStylePlain];
    leftTab.delegate = self;
    leftTab.dataSource = self;
    leftTab.tag = kLeftTabTag;
    leftTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTab.layer.masksToBounds = YES;
    leftTab.layer.cornerRadius = 2;
    leftTab.layer.borderWidth = 1;
    leftTab.layer.borderColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1].CGColor;
    [self.view addSubview:leftTab];
    
    rightTab = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 94, kScreenWidth/2, kScreenHeight-94) style:UITableViewStylePlain];
    rightTab.delegate = self;
    rightTab.dataSource = self;
    rightTab.tag = kRightTabTag;
    rightTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTab.layer.masksToBounds = YES;
    rightTab.layer.cornerRadius = 2;
    rightTab.layer.borderWidth = 1;
    rightTab.layer.borderColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1].CGColor;
    [self.view addSubview:rightTab];
    
    leftTab.hidden = YES;
    rightTab.hidden = YES;
    leftTab.backgroundColor = [UIColor clearColor];
    rightTab.backgroundColor = [UIColor clearColor];
    
}


- (void)oneMenu:(MenuButton *)btn
{
    NSLog(@"oneMenu");
    
    if (btn.selected)
    {
        [self changButtonBackColorWithTag:btn.tag andSelected:NO];
    }
    else
    {
        [self changButtonBackColorWithTag:btn.tag andSelected:YES];
    }
    [self changeTableViewFrameWithTag:kLeftTabTag andCount:leftArray.count];
    leftTab.hidden = NO;
    [leftTab reloadData];
}

- (void)changButtonBackColorWithTag:(NSInteger)tag andSelected:(BOOL)selected
{
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    btn.selected = selected;
    if (selected)
    {
        [btn setBackgroundColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1]];
    }
    else
    {
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)secBtn:(MenuButton *)btn
{
    NSLog(@"secBtn");
    leftTab.hidden = YES;
    [self changButtonBackColorWithTag:kOneBtnTag andSelected:NO];
    rightArray = [leftArray objectAtIndex:0];
    [self changeTableViewFrameWithTag:kRightTabTag andCount:rightArray.count];
    rightTab.hidden = NO;
    [rightTab reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kLeftTabTag)
    {
        // left
        return leftArray.count;
    }
    else if (tableView.tag == kRightTabTag)
    {
        return rightArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    if (tableView.tag == kLeftTabTag)
    {
        // left
        cell.textLabel.text = [NSString stringWithFormat:@"菜单%ld",indexPath.row+1];//[leftArray objectAtIndex:indexPath.row];
    }
    else if (tableView.tag == kRightTabTag)
    {
        cell.textLabel.text = [rightArray objectAtIndex:indexPath.row];
    }
    
    // 选中后背景色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:217/255.0 green:0/255.0 blue:36/255.0 alpha:1];
    cell.selectedTextColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kLeftTabTag)
    {
        rightArray = [leftArray objectAtIndex:indexPath.row];
        [self changeTableViewFrameWithTag:kRightTabTag andCount:rightArray.count];
        rightTab.hidden = NO;
        [rightTab reloadData];
    }
    else
    {
        // 跳到下一界面
        EJTListViewController *eJTListVC = [[EJTListViewController alloc]init];
        eJTListVC.titleString = @"仪器";
        eJTListVC.type = 0;
        [self.navigationController pushViewController:eJTListVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (void)changeTableViewFrameWithTag:(NSInteger)tag andCount:(NSInteger)counts
{
    UITableView *tabV = (UITableView *)[self.view viewWithTag:tag];
    CGRect rect = tabV.frame;
    if (counts*35<rect.size.height)
    {
        rect.size.height = counts*35;
    }
    tabV.frame = rect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    leftTab.hidden = YES;
    rightTab.hidden = YES;
    [self changButtonBackColorWithTag:kOneBtnTag andSelected:NO];
    [self changButtonBackColorWithTag:kTwoBtnTag andSelected:NO];
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
