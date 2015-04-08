//
//  LoginViewController.m
//  labonline
//
//  Created by 引领科技 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "LoginViewController.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        self = [storyboard instantiateViewControllerWithIdentifier:@"loginV"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userNameTxt.delegate=self;
    _passwordTxt.delegate=self;
    
//    if (_sideViewController==nil) {
//        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        YRSideViewController *sideViewController=[delegate sideViewController];
//        _sideViewController=sideViewController;
//    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doLogin:(id)sender {
//    MainViewController *mainViewController=[[MainViewController alloc] init];
//    //    mainViewController.view.backgroundColor=[UIColor grayColor];
//    
//    UINavigationController *mainNVC = [[UINavigationController alloc]initWithRootViewController:mainViewController];
//    
//    LeftViewController *leftViewController=[[LeftViewController alloc]initWithNibName:nil bundle:nil];
//    leftViewController.delegate=mainViewController;
//    //    leftViewController.view.backgroundColor=[UIColor brownColor];
//    
//    UIViewController *rightViewController=[[UIViewController alloc]initWithNibName:nil bundle:nil];
//    rightViewController.view.backgroundColor=[UIColor purpleColor];
//    
//    _sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
//    _sideViewController.rootViewController=mainNVC;
//    _sideViewController.leftViewController=leftViewController;
//    _sideViewController.rightViewController=rightViewController;
//    
//    
//    _sideViewController.leftViewShowWidth=240;
//    _sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
        //动画效果可以被自己自定义，具体请看api
    
    [self presentViewController:_sideViewController animated:YES completion:nil];
}
@end
