//
//  LoginViewController.h
//  labonline
//
//  Created by 引领科技 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@end
