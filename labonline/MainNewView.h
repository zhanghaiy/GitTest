//
//  MainNewView.h
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNewView : UIView

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,strong) NSArray *imageDataArray;// 模拟数据
@property (nonatomic,assign) NSInteger clickImageIndex;

@end
