//
//  JiShuZhuanLanDetailViewController.h
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "TencentOpenAPI.framework/Headers/QQApi.h"
#import "TencentOpenAPI.framework/Headers/QQApiInterface.h"
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"

@interface JiShuZhuanLanDetailViewController : UIViewController<WXApiDelegate>

@property (nonatomic,copy) NSString *vidioUrl;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *htmlUrl;
@property (nonatomic,copy) NSString *articalID;
@property (nonatomic,strong) NSDictionary *articalDic;

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL action;
@property(nonatomic, strong)TencentOAuth *tencentAuth;


@end
