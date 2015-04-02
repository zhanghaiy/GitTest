//
//  MyCollectionCell.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell

- (void)awakeFromNib
{
    // Initialization code
    _titleLable.textColor = [UIColor  colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
    _fromLable.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1];
    _cateLable.textColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonClicked:(id)sender
{
    if ([_target respondsToSelector:_action])
    {
        [self.target performSelector:self.action withObject:self afterDelay:NO];
    }
}
@end
