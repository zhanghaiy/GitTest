//
//  RemoveCacheManager.m
//  labonline
//
//  Created by cocim01 on 15/4/16.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "RemoveCacheManager.h"
#import "PathManager.h"


@implementation RemoveCacheManager

// 系统设置 清除缓存
+ (void)removeUserAllLocalCacheFile
{
    [self removeVidioNSUserDefaults];
    [self removePDFNSUserDefaults];
    [self removeUserPersonCacheWithType:VidioPath];
    [self removeUserPersonCacheWithType:PDFPath];
//    [self removeUserPersonCacheWithType:DataPath];
}

// 清除视频缓存记录
+ (void)removeVidioNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"VidioList"];
    [defaults synchronize];
}

// 清除PDF记录
+ (void)removePDFNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"PDFArray"];
    [defaults synchronize];
}

+ (void)removeUserPersonCacheWithType:(PathType)pathType
{
    NSString *path = [PathManager getCatePathWithType:pathType];
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
}

@end
