//
//  RemoveCacheManager.m
//  labonline
//
//  Created by cocim01 on 15/4/16.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "RemoveCacheManager.h"

@implementation RemoveCacheManager

// 系统设置 清除缓存
+ (void)removeAllCache
{
    [self removeVidioCache];
}

// 当用户在程序之外删掉视频时 要删除沙盒记录
+ (void)removeVidioCache
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"VidioList"];// 清除视频缓存
    [defaults synchronize];
}

@end
