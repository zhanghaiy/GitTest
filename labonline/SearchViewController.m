//
//  SearchViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"


@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_moNiDataArray;// 标签的数据
    NSArray *_searchDataArray;//模拟搜索回来的数据
    UITextField *searchTextField;
    NSInteger _markHeaderHeight;
    UITableView *_tableV;
    UIView *touView;
}
@end

@implementation SearchViewController
#define kTouViewHeight 35
#define kMarkButtonTag 66

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 36) andBackImageWithName:@"返回角.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popBack);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    searchTextField.delegate = self;
    searchTextField.textColor = [UIColor redColor];
    searchTextField.font = [UIFont systemFontOfSize:kOneFontSize];
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = searchTextField;
    
    UIButton *searchBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBUtton setFrame:CGRectMake(0, 0, 50, 25)];
    [searchBUtton setTitle:@"搜文章" forState:UIControlStateNormal];
    searchBUtton.layer.masksToBounds = YES;
    searchBUtton.layer.cornerRadius = 10;
    searchBUtton.titleLabel.font =[UIFont systemFontOfSize:kTwoFontSize];
    searchBUtton.backgroundColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    [searchBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBUtton addTarget:self action:@selector(searchMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBUtton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _moNiDataArray = @[@"耳鼻",@"口腔",@"肿瘤研究",@"临床医师",@"医生",@"宝洁医疗诊断"];
    touView  = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kTouViewHeight)];
    NSInteger jugeWidth = 10;
    NSInteger hang = 0;
    for (int i = 0; i < _moNiDataArray.count; i ++)
    {
        NSInteger currentWidth = [self heightFromText:[_moNiDataArray objectAtIndex:i]];
        if (jugeWidth+currentWidth > kScreenWidth-10)
        {
            jugeWidth = 10;
            hang ++;
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[_moNiDataArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:128/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(jugeWidth, 5+kTouViewHeight*hang, currentWidth, kTouViewHeight-10)];
        btn.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = (kTouViewHeight-10)/2;
        btn.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
        btn.tag = kMarkButtonTag + i;
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [touView addSubview:btn];
        jugeWidth += currentWidth+20;
    }
    _markHeaderHeight = kTouViewHeight*(hang+1);
    touView.frame = CGRectMake(0, 70, kScreenWidth, _markHeaderHeight);
    
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.tableHeaderView = touView;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableV];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:self options:0] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLable.text = [_searchDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 标签点击事件
- (void)buttonClicked:(UIButton *)btn
{
    searchTextField.text = [_moNiDataArray objectAtIndex:btn.tag - kMarkButtonTag];
}

#pragma mark - 计算宽度
- (NSInteger)heightFromText:(NSString *)text
{
     CGRect rect = [text boundingRectWithSize:CGSizeMake(9999, 20)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kOneFontSize]} context:nil];
    NSLog(@"%f",rect.size.width);
    NSInteger width = rect.size.width+10;
    return width;
}

#pragma mark - 搜索
- (void)searchMethod
{
    // 搜索
    _searchDataArray = @[@"宝洁医疗诊断相机设计",@"心脑血管疾病",@"临床医学实验汇总",@"宝洁医疗诊断相机设计",@"宝洁医疗诊断相机设计",@"宝洁医疗诊断相机设计",@"心脑血管疾病",@"临床医学实验汇总",@"宝洁医疗诊断相机设计",@"宝洁医疗诊断相机设计"];
    [_tableV reloadData];
    _tableV.tableHeaderView = nil;
    [searchTextField resignFirstResponder];
}

#pragma mark - 返回上一页
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchTextField resignFirstResponder];
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
