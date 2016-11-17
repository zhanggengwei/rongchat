//
//  PPHTTPManager.m
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPHTTPManager.h"
#import <AFNetworking/AFNetworking.h>


@implementation PPHTTPManager
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        
        /*
         manager.responseSerializer = [AFHTTPResponseSerializer serializer];
         
         NSDictionary * dict = @{
         @"region" : region,
         @"phone" : phone,
         @"password" : passWord};
         
         
         
         */

        self.requestSerializer.HTTPShouldHandleCookies = YES;
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
       // [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^( AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success) {
            success(operation, [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
        }

    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^( AFHTTPRequestOperation *operation, NSError * error)
    {
        if (failure) {
            failure(operation, error);
        }

    };
    return [super HTTPRequestOperationWithRequest:request success:successBlock failure:failureBlock];
}


- (NSDictionary *)paramsWithQuery:(NSString *)aQuery
{
    if (aQuery.length <= 0)
    {
        return nil;
    }
    
    NSArray *kvPairs = [aQuery componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *kvPair in kvPairs)
    {
        NSArray *kvArr = [kvPair componentsSeparatedByString:@"="];
        if ([kvArr count] > 1)
        {
            NSString *value = [kvArr objectAtIndex:1];
            //url解码
            value =  [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:value forKey:[kvArr firstObject]];
            
        }
    }
    return params;
}

@end


@implementation NSDictionary (description)

- (NSString *)descriptionWithPrefix:(NSMutableString *)prefix
{
    if (!prefix) {
        prefix = [[NSMutableString alloc] init];
    }
    NSArray *allKeys = [self allKeys];
    NSString *curPrefix = [NSString stringWithString:prefix];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@{\n", curPrefix];
    for (NSString *key in allKeys) {
        id value = self[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            [prefix appendFormat:@"\t"];
            NSString *valueString = [value descriptionWithPrefix:prefix];
            [str appendFormat:@"%@\t\"%@\" : %@\n", curPrefix, key, valueString];
        }else if ([value isKindOfClass:[NSArray class]])
        {
            [prefix appendFormat:@"\t"];
            [str appendFormat:@"%@\t\"%@\" : (",curPrefix, key];
            int i = 0;
            for (id subValue in value) {
                NSString *substring = [subValue descriptionWithPrefix:prefix];
                if (i == 0) {
                    [str appendFormat:@"\n%@",substring];
                }else
                {
                    [str appendFormat:@", \n%@", substring];
                }
                i ++;
            }
            [str appendFormat:@"\n%@\t)\n", curPrefix];
        }else
        {
            [str appendFormat:@"%@\t\"%@\" : \"%@\"\n",curPrefix, key, value];
        }
    }
    [str appendFormat:@"%@}", curPrefix];
    
    return str;
}
@end
