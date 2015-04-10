//
//  NetManager.m
//  labonline
//
//  Created by cocim01 on 15/4/10.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "NetManager.h"
#import "AFHTTPRequestOperation.h"

@implementation NetManager

- (void)requestDataWithUrlString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"AFHttpRequestOperation成功");
         // save Data
         self.downLoadData = operation.responseData;
         // 回调
         [self callBack];
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"AFHttpRequestOperation错误");
         _failError = error;
         [self callBack];
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)callBack
{
    if ([self.delegate respondsToSelector:self.action])
    {
        [_delegate performSelector:_action withObject:self afterDelay:NO];
    }
}

@end
