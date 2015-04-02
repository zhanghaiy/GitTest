//
//  MainListCell.h
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainListCell : UITableViewCell

@property (nonatomic,strong) NSArray *listArray;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@end
