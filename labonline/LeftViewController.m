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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger width = self.view.bounds.size.width;
    NSInteger height = self.view.bounds.size.height;
    
//    self.view.backgroundColor = [UIColor colorWithRed:41/255.0 green:70/255.0 blue:134/255.0 alpha:1];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgV.image = [UIImage imageNamed:@"左侧列.png"];
    imgV.userInteractionEnabled = YES;
    [self.view addSubview:imgV];
    
    UIImageView *headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 100, 90, 90)];
    headImgV.backgroundColor = [UIColor clearColor];
    headImgV.layer.masksToBounds = YES;
    headImgV.layer.cornerRadius = 45;
    headImgV.layer.borderWidth = 3;
    headImgV.layer.borderColor = [UIColor colorWithRed:162/255.0 green:203/255.0 blue:205/255.0 alpha:1].CGColor;
    [imgV addSubview:headImgV];
    
    UIButton *userImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userImageButton setFrame:CGRectMake(45, 105, 80, 80)];
    [userImageButton setBackgroundImage:[UIImage imageNamed:@"33.jpg"] forState:UIControlStateNormal];
    userImageButton.layer.masksToBounds = YES;
    userImageButton.layer.cornerRadius = 40;
    [imgV addSubview:userImageButton];
    
    _titleCateArray = [[NSMutableArray alloc]initWithObjects:@"PDF阅读",@"视频",@"技术专栏",@"首页",@"用户中心", nil];
    _cateTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 200, width-60-100, height-200) style:UITableViewStylePlain];
    _cateTableView.delegate = self;
    _cateTableView.dataSource = self;
    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cateTableView.backgroundColor = [UIColor clearColor];
    [imgV addSubview:_cateTableView];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleCateArray.count;
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
    cell.textLabel.text = [_titleCateArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // PDF阅读
        [self.delegate pushViewControllerWithResourceType:PDFType];
    }
    else if (indexPath.row == 1)
    {
        // 视频
        [self.delegate pushViewControllerWithResourceType:VidioType];
    }
    else if (indexPath.row == 2)
    {
        [self.delegate pushViewControllerWithResourceType:JiShuZhuanLan];
    }
    else if (indexPath.row == 3)
    {
        [self.delegate pushViewControllerWithResourceType:MainPage];
    }
    else if(indexPath.row == 4)
    {
        [self.delegate pushViewControllerWithResourceType:PersonCenter];
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
