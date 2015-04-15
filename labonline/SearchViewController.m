//
//  SearchViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "AFNetworkTool.h"
#import "PDFBrowserViewController.h"
#import "JiShuZhuanLanDetailViewController.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_moNiDataArray;// 标签的数据
    NSArray *_searchDataArray;//模拟搜索回来的数据
    UITextField *searchTextField;
    NSInteger _markHeaderHeight;
    UITableView *_tableV;
    UIView *touView;
    BOOL _requestLable;
    NSInteger _markCellIndex;
    BOOL _addReadCounts;
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
    
    touView  = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, 1)];
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.tableHeaderView = touView;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableV];
    [self requestSubLabel];
}

#pragma mark - 请求标签
- (void)requestSubLabel
{
    [AFNetworkTool postJSONWithUrl:kSearchLableUrl parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
         NSLog(@"%@",dict);
         if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
         {
             _moNiDataArray = [[dict objectForKey:@"data"] objectForKey:@"labelList"];
             [self createSubLables];
             [_tableV reloadData];
         }
        
    } fail:^{
        NSLog(@"请求标签失败");
    }];
}


- (void)createSubLables
{
    NSInteger jugeWidth = 10;
    NSInteger hang = 0;
    for (int i = 0; i < _moNiDataArray.count; i ++)
    {
        NSDictionary *dic = [_moNiDataArray objectAtIndex:i];
        NSInteger currentWidth = [self heightFromText:[dic objectForKey:@"label"]];
        if (jugeWidth+currentWidth > kScreenWidth-10)
        {
            jugeWidth = 10;
            hang ++;
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[dic objectForKey:@"label"] forState:UIControlStateNormal];
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
}


#pragma mark - 列表 delegate
#pragma mark -- 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchDataArray.count;
}

#pragma mark -- 绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:self options:0] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [_searchDataArray objectAtIndex:indexPath.row];
    cell.titleLable.text = [dic objectForKey:@"title"];
    cell.detailLable.text = [dic objectForKey:@"type"];
    cell.LookCountLable.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"seenum"] integerValue]];
    if (_addReadCounts && indexPath.row == _markCellIndex)
    {
        cell.LookCountLable.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"seenum"] integerValue]+1];
    }
    return cell;
}

#pragma mark -- 去掉多余的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark -- 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -- 选中cell 进入详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _markCellIndex = indexPath.row;
    NSDictionary *dict = [_searchDataArray objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"urlpdf"] length]>5)
    {
        // PDF 跳转PDF页面
        NSLog(@"跳转PDF页面");
        PDFBrowserViewController *pdfBrowseVC = [[PDFBrowserViewController alloc]init];
        pdfBrowseVC.filePath = [dict objectForKey:@"urlpdf"];
        pdfBrowseVC.articalId = [dict objectForKey:@"articleid"];
        pdfBrowseVC.target = self;
        pdfBrowseVC.action = @selector(addReadCounts);
        [self.navigationController pushViewController:pdfBrowseVC animated:YES];
    }
    else if ([[dict objectForKey:@"urlhtml"] length]>5)
    {
        // html
        JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
        if ([[dict objectForKey:@"urlvideo"] length]>5)
        {
            // 视频
            detailVC.vidioUrl = [dict objectForKey:@"urlvideo"];
        }
        detailVC.delegate = self;
        detailVC.action = @selector(addReadCounts);
        detailVC.articalDic = dict;
        [self.navigationController pushViewController:detailVC animated:YES];
    }

}
#pragma mark - 增加阅读数
- (void)addReadCounts
{
    _addReadCounts = YES;
    [_tableV reloadData];
}

#pragma mark - 标签点击事件
- (void)buttonClicked:(UIButton *)btn
{
    searchTextField.text = [[_moNiDataArray objectAtIndex:btn.tag - kMarkButtonTag] objectForKey:@"label"];
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
    [searchTextField resignFirstResponder];
    NSDictionary *paramDic = @{@"labelid":@"1",@"label":searchTextField.text};
    [AFNetworkTool postJSONWithUrl:kSearchUrl parameters:paramDic success:^(id responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"respCode"] intValue] == 1000)
        {
            _searchDataArray = [[dic objectForKey:@"data"] objectForKey:@"resultList"];
            [_tableV reloadData];
            _tableV.tableHeaderView = nil;
        }
    } fail:^{
        NSLog(@"fail");
    }];
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
