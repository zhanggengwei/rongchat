//
//  PPDataDef.m
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPDataDef.h"

@implementation PPDataDef
@end
@implementation PPTokenDef

@end

@implementation PPPersonal
@end

@implementation PPUserBaseInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    if ([mapping objectForKey:@"userId"]) {
        [mapping setObject:@"id"forKey:@"userId"];
    }
    return mapping;
}
@end


@implementation PPUploadImageToken

@end


@implementation PPCountryDef

@end

@implementation PPVertifyDef


@end

@implementation RCContactGroupMember

@end

@implementation RCContactGroup

@end
