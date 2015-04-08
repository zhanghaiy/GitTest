//
//  SearchViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UITextFieldDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, kScreenWidth-90, 30)];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    searchTextField.delegate = self;
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:searchTextField];
    
    UIButton *searchBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBUtton setFrame:CGRectMake(kScreenWidth-70, 70, 60, 30)];
    [searchBUtton setTitle:@"搜文章" forState:UIControlStateNormal];
    searchBUtton.layer.masksToBounds = YES;
    searchBUtton.layer.cornerRadius = 15;
    searchBUtton.titleLabel.font =[UIFont systemFontOfSize:kOneFontSize];
    searchBUtton.backgroundColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    [searchBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:searchBUtton];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
