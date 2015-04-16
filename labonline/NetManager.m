//
//  NetManager.m
//  labonline
//
//  Created by cocim01 on 15/4/10.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "NetManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@implementation NetManager

- (void)requestDataWithUrlString:(NSString *)urlString
{
    NSLog(@"~~~~~~~~~~requestDataWithUrlString");
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
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

//- (void)postRequestWithUrlString:(NSString *)urlStr withDict:(NSDictionary *)dict
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    // 设置请求格式
//    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    // 设置返回格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//        if (fail) {
//            fail();
//        }
//    }];
//}

- (void)callBack
{
    if ([self.delegate respondsToSelector:self.action])
    {
        [_delegate performSelector:_action withObject:self afterDelay:NO];
    }
}

@end
