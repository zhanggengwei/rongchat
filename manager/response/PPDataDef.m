//
//  PPDataDef.m
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPDataDef.h"

@implementation PPDataDef
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    if ([mapping objectForKey:@"userId"]) {
        [mapping setObject:@"id"forKey:@"userId"];
    }
    return mapping;
}
@end
@implementation PPTokenDef

@end

@implementation PPPersonal
@end

@implementation PPUserBaseInfo
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


@implementation RCUserInfoBaseData
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    if ([mapping objectForKey:@"userId"]) {
        [mapping setObject:@"id"forKey:@"userId"];
    }
    
    if ([mapping objectForKey:@"name"]) {
        [mapping setObject:@"nickname"forKey:@"name"];
    }
    return mapping;
}
@end

@implementation RCUserInfoData

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[RCUserInfoBaseData class]];
}
@end
