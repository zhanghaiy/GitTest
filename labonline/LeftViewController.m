//
//  LeftViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_titleCateArray;
    UITableView *_cateTableView;
}
@end

@implementation LeftViewController
#define kLeftHeight 240
#define kImageHeight 80
#define kCircleHeight 90
#define kCellHeight 40
#define kSettingButtonHeight 25


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgV.image = [UIImage imageNamed:@"左侧列.png"];
    imgV.userInteractionEnabled = YES;
    [self.view addSubview:imgV];
    
    UIImageView *headImgV = [[UIImageView alloc]initWithFrame:CGRectMake((kLeftHeight-kCircleHeight)/2, 30, kCircleHeight, kCircleHeight)];
    headImgV.backgroundColor = [UIColor clearColor];
    headImgV.layer.masksToBounds = YES;
    headImgV.layer.cornerRadius = kCircleHeight/2;
    headImgV.layer.borderWidth = 3;
    headImgV.layer.borderColor = [UIColor colorWithRed:162/255.0 green:203/255.0 blue:205/255.0 alpha:1].CGColor;
    [imgV addSubview:headImgV];
    
    UIButton *userImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userImageButton setFrame:CGRectMake((kLeftHeight-kImageHeight)/2, 30+(kCircleHeight-kImageHeight)/2, kImageHeight, kImageHeight)];
    [userImageButton setBackgroundImage:[UIImage imageNamed:@"33.jpg"] forState:UIControlStateNormal];
    userImageButton.layer.masksToBounds = YES;
    userImageButton.layer.cornerRadius = kImageHeight/2;
    [imgV addSubview:userImageButton];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40+kCircleHeight, kLeftHeight-20, 30)];
    nameLab.text = @"愤怒的老牛";
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:15];
    [imgV addSubview:nameLab];
    
    _titleCateArray = [[NSMutableArray alloc]initWithObjects:@"首页",@"技术专栏",@"杂志",@"用户中心", nil];
    _cateTableView = [[UITableView alloc]initWithFrame:CGRectMake(-5, 80+kCircleHeight, kLeftHeight-10, kScreenHeight-kCircleHeight-180) style:UITableViewStylePlain];
    _cateTableView.delegate = self;
    _cateTableView.dataSource = self;
    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cateTableView.backgroundColor = [UIColor clearColor];
    [imgV addSubview:_cateTableView];
    
    
    // 设置按钮
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(20, kScreenHeight-80, kSettingButtonHeight, kSettingButtonHeight)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(25+kSettingButtonHeight, kScreenHeight-80, 60, kSettingButtonHeight)];
    lable.text = @"设置";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:kOneFontSize];
    lable.userInteractionEnabled = YES;
    [self.view addSubview:lable];
    
    UITapGestureRecognizer *tapSettingLable = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setButtonClicked)];
    [lable addGestureRecognizer:tapSettingLable];
}

- (void)setButtonClicked
{
    [self.delegate pushViewControllerWithIndex:SettingCenter];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleCateArray.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdendifer = @"CateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifer];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifer];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_titleCateArray objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    cell.layer.borderColor = [UIColor colorWithRed:120/255.0 green:170/255.0 blue:179/255.0 alpha:1].CGColor;
    cell.layer.borderWidth = 1;
    cell.textLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    cell.backgroundColor = [UIColor clearColor];
    // 选中后背景色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:148/255.0 green:191/255.0 blue:196/255.0 alpha:0.7];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kLeftHeight, 10)];
    return footV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate pushViewControllerWithIndex:indexPath.section];
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
