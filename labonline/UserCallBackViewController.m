//
//  UserCallBackViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/9.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "UserCallBackViewController.h"
#import "AFNetworkTool.h"


@interface UserCallBackViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView *textV;
}
@end

@implementation UserCallBackViewController
#define kTextViewHeight 150
#define kMarkLableHeight 20
#define kSendButtonHeight 30

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([DeviceManager deviceVersion]>=7)
    {
        //界面调整
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    NavigationButton *leftBtn = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 36) andBackImageWithName:@"返回角.png"];
    leftBtn.delegate = self;
    leftBtn.action = @selector(backLastPage);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    textV = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, kTextViewHeight)];
    textV.delegate = self;
    textV.keyboardType = UIKeyboardTypeNamePhonePad;
    textV.font = [UIFont systemFontOfSize:kOneFontSize];
    textV.layer.masksToBounds = YES;
    textV.layer.cornerRadius = 5;
    textV.layer.borderColor = [UIColor colorWithWhite:230/255.0 alpha:1].CGColor;
    textV.layer.borderWidth = 1;
    textV.scrollEnabled = YES;
    textV.text = @"提点小建议";
    [self.view addSubview:textV];
    
    UILabel *markLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+kTextViewHeight, kScreenWidth-20, kMarkLableHeight)];
    markLab.text = @"不超过500字";
    markLab.textAlignment = NSTextAlignmentRight;
    markLab.font = [UIFont systemFontOfSize:kThreeFontSize];
    markLab.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
    [self.view addSubview:markLab];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendBtn setFrame:CGRectMake(10, 5+kTextViewHeight+kMarkLableHeight+20, kScreenWidth-20, kSendButtonHeight)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    sendBtn.titleLabel.font =[ UIFont systemFontOfSize:kOneFontSize];
    [sendBtn setTitleColor:[UIColor colorWithWhite:150/255.0 alpha:1] forState:UIControlStateNormal];
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 5;
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor colorWithWhite:230/255.0 alpha:1].CGColor;
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}

- (void)sendBtnClicked
{
        NSDictionary *paramDic = @{@"userid":kUserId,@"feedbackcontent":textV.text};
        [AFNetworkTool postJSONWithUrl:kUserCallBackUrl parameters:paramDic success:^(id responseObject) {
           // 用户提交反馈成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if ([dic objectForKey:@"respCode"])
            {
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertV show];
            }
        } fail:^{
            //
        }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textV resignFirstResponder];
}

- (void)backLastPage
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
