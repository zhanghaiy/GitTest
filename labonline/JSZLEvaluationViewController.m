//
//  JSZLEvaluationViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JSZLEvaluationViewController.h"
#import "JSZLEvaluationCell.h"


@interface JSZLEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_evalueTableV;
    UIView *downV;//底部评价View
    NSArray *_dataArray;// 模拟数据 为了计算cell高度
}
@end

@implementation JSZLEvaluationViewController
#define kDownViewHeight 40
#define kSendButtonWidth 60
#define kTextFieldTag 100
#define kCellHeight 70

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"技术专栏评价界面";
    self.view.backgroundColor = [UIColor whiteColor];
    // 左侧返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 25, 26)];
    [button setBackgroundImage:[UIImage imageNamed:@"aniu_07.png"] forState:UIControlStateNormal];
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
    
    
    _dataArray = @[@"我们每一个生活在这个世界的人，总有一个思维时刻在催促着你前行，在前进的路上我们总是自觉或不自觉地调整着自己努力的方向。因为我们正在明白，在你的面前始终有一个你目前无法达到的目标，这个目标就象一剂强心针，将你的肾上腺素调到最亢奋的状态。以至于我们常常在目标之中却无端地失去了目标。",@"写的不错。。。。。。",@"一般般",@"因为我们正在明白，在你的面前始终有一个你目前无法达到的目标，这个目标就象一剂强心针，将你的肾上腺素调到最亢奋的状态。以至于我们常常在目标之中却无端地失去了目标"];
    _evalueTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-kDownViewHeight) style:UITableViewStylePlain];
    _evalueTableV.delegate = self;
    _evalueTableV.dataSource = self;
    [self.view addSubview:_evalueTableV];
    
    downV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kDownViewHeight, kScreenWidth, kDownViewHeight)];
    downV.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:downV];
    // 文本框
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-kSendButtonWidth-30, kDownViewHeight-10)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.delegate = self;
    textField.tag = kTextFieldTag;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    [downV addSubview:textField];
    // 发送按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(kScreenWidth-kSendButtonWidth-10, 5, kSendButtonWidth, kDownViewHeight-10)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1] forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor whiteColor];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.borderWidth = 1;
    sendButton.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downV addSubview:sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 发送按钮点击事件
- (void)sendButtonClicked:(UIButton *)btn
{
     //发送按钮
    NSLog(@"发送按钮点击事件");
    // 收键盘
    UITextField *textField = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    [textField resignFirstResponder];
    // 提交评论 提交成功后重新网络请求 刷新数据（可以看到自己评论的）
//    NSString *evaluContent = textField.text;
    
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    NSLog(@"enterSearchViewController");
}

#pragma mark - UITextFieldDelegate
#pragma mark --收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --空白收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    [textField resignFirstResponder];
}

#pragma mark --notification handler
// 键盘升起时 downV 跟着升起
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSLog(@"UIKeyboardDidShowNotification");
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect rect = downV.frame;
    rect.origin.y += yOffset;
    [UIView animateWithDuration:duration animations:^{
        downV.frame = rect;
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EvaluCell";
    JSZLEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JSZLEvaluationCell" owner:self options:0] lastObject];
    }
    cell.cellHeight = [self countCellHeightOfIndex:indexPath.row];
    cell.evaluationLable.text = [_dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self countCellHeightOfIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 根据文字计算高度
- (NSInteger)countCellHeightOfIndex:(NSInteger)index
{
    // 根据索引找到当前cell的数据str 暂时假数据
    NSString *cellString = [_dataArray objectAtIndex:index];
    NSInteger textWidth = kScreenWidth-kCellHeight;
    CGRect rect = [cellString boundingRectWithSize:CGSizeMake(textWidth, 99999)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    NSInteger height = rect.size.height+35;
    if (height<=kCellHeight)
    {
        return kCellHeight;
    }
    else
    {
        return height;
    }
}

#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
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
