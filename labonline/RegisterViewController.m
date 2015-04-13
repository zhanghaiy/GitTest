//
//  RegisterViewController.m
//  labonline
//
//  Created by 引领科技 on 15/4/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworkTool.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        self = [storyboard instantiateViewControllerWithIdentifier:@"registerV"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)DoRegister:(id)sender {
    NSString *username=_username.text;
    NSString *password=_password.text;
    NSString *nickname=_nickName.text;
    NSString *phone=_phone.text;
    NSString *email=_email.text;

    if (username.length==0||password.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登录" message:@"用户名密码不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
//        if ([self respondsToSelector:@selector(presentingViewController)]) {
//            [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];//ios5
//        } else {
//            [self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];//ios4
//        }
        
        NSString *loginUrl=[COCIM_INTERFACE_REG stringByAppendingFormat:@"?username=%@&password=%@&nickname=%@&phone=%@&email=%@",username,password,nickname,phone,email];
        [AFNetworkTool JSONDataWithUrl:loginUrl success:^(id json) {
            int respCode=[[json objectForKey:@"respCode"] intValue];
            if (respCode==1000) {
                //            NSDictionary *data=[[json objectForKey:@"userinfo"] objectAtIndex:0];
                //
                //            [um setValuesForKeysWithDictionary:data];
                //            NSLog(@"%@",um);
                
                NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
                [userDe setObject:username forKey:@"userName"];
                [userDe synchronize];
                
                //            [self presentViewController:_sideViewController animated:YES completion:nil];
//                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self respondsToSelector:@selector(presentingViewController)]) {
                    [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];//ios5
                } else {
                    [self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];//ios4
                }
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登录" message:@"用户名密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            // 提示:NSURLConnection异步方法回调,是在子线程
            // 得到回调之后,通常更新UI,是在主线程
            //        NSLog(@"%@", [NSThread currentThread]);
        } fail:^{
            NSLog(@"请求失败");
        }];
    }
}
@end
