//
//  EditSubViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EditSubViewController.h"



@interface EditSubViewController ()<UITextFieldDelegate>

@end

@implementation EditSubViewController
#define kTextFieldTag 123


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@编辑",[_dataDict objectForKey:@"Title"]];
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:215/255.0 green:0 blue:0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastPage)];
    self.navigationItem.leftBarButtonItem = leftItem;
    // 右侧完成按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(alertFinished)];
    self.navigationItem.rightBarButtonItem = rightItem;

    UIView *alertBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    alertBackV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:alertBackV];
    
    UILabel *cateLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
    cateLab.text = [_dataDict objectForKey:@"Title"];
    cateLab.font = [UIFont systemFontOfSize:kOneFontSize];
    cateLab.textAlignment = NSTextAlignmentLeft;
    cateLab.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1];
    [alertBackV addSubview:cateLab];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, kScreenWidth-140, 30)];
    textField.tag = kTextFieldTag;
    textField.font = [UIFont systemFontOfSize:kOneFontSize];
    textField.textColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1];
    textField.clearButtonMode=UITextFieldViewModeAlways;
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.delegate = self;
    textField.text = [_dataDict objectForKey:@"Content"];
    [alertBackV addSubview:textField];
}

#pragma mark - 返回上一页
- (void)backToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 修改完成
- (void)alertFinished
{
    // 修改完成
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *textF = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    [textF resignFirstResponder];
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
