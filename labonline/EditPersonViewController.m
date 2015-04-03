//
//  EditPersonViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EditPersonViewController.h"
#import "PersonEditCell.h"
#import "EditSubViewController.h"

@interface EditPersonViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTableV;
    NSArray *_baseDataArray;
}
@end

@implementation EditPersonViewController
#define kHeadViewHeight 110
#define kHeadViewTag 888
#define kHeadImageButtonTAg 889
#define kHeadImageButtonHeight 80
#define kSubViewHeight 40
#define kSubViewTag 999
#define kLeftLableWidth 100

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人编辑";
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadViewHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setFrame:CGRectMake((kScreenWidth-kHeadImageButtonHeight)/2, (kHeadViewHeight-kHeadImageButtonHeight)/2, kHeadImageButtonHeight, kHeadImageButtonHeight)];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    imageBtn.layer.masksToBounds = YES;
    imageBtn.layer.cornerRadius = kHeadImageButtonHeight/2;
    imageBtn.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
    imageBtn.layer.borderWidth = 1;
    [headView addSubview:imageBtn];
    
    _baseDataArray = @[@{@"Title":@"昵称",@"Content":@"幸福的小猫米"},@{@"Title":@"手机号",@"Content":@"15210065926"},@{@"Title":@"E-mail",@"Content":@"845602196@qq.com"}];
    _myTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 1+kHeadViewHeight, kScreenWidth, kScreenHeight-200) style:UITableViewStylePlain];
    _myTableV.delegate = self;
    _myTableV.dataSource = self;
    _myTableV.showsVerticalScrollIndicator = NO;
    _myTableV.backgroundColor = [UIColor clearColor];
    _myTableV.separatorColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    [self.view addSubview:_myTableV];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baseDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSubViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PersonEditCell";
    PersonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonEditCell" owner:self options:0] lastObject];
    }
    NSDictionary *dict = [_baseDataArray objectAtIndex:indexPath.row];
    cell.titleLable.text = [dict objectForKey:@"Title"];
    cell.contentLable.text = [dict objectForKey:@"Content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditSubViewController *subVC = [[EditSubViewController alloc]init];
    [self.navigationController pushViewController:subVC animated:YES];
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
