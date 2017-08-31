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
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    if ([mapping objectForKey:@"indexId"]) {
        [mapping setObject:@"id"forKey:@"indexId"];
    }
    return mapping;
}
@end

@implementation PPPersonal
@end
@implementation PPUploadImageToken

@end


@implementation PPCountryDef

@end

@implementation PPVertifyDef


@end

@implementation RCContactGroupMember

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

- (NSString *)placeImage
{
    return _placeImage?_placeImage:@"";
}
-(NSComparisonResult)compare:(RCUserInfoData *)data{
    return self.updatedAt<data.updatedAt;
}
- (NSInteger)timeIntervalByDateString:(NSString *)time
{
    if(time==nil)
    {
        return [[NSDate date]timeIntervalSince1970];
    }
    NSString * dateTimeString = [time stringByReplacingOccurrencesOfString:@"Z" withString:@" UTC"];
    NSInteger timeInterval = [[NSDate lcck_dateWithString:dateTimeString formatString:@"yyyy-MM-dd'T'HH:mm:ss.SSS Z"]timeIntervalSince1970];
    return timeInterval;
}


@end

@implementation RCContactGroupData
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    if ([mapping objectForKey:@"indexId"]) {
        [mapping setObject:@"id"forKey:@"indexId"];
    }
    return mapping;
}

@end

@implementation PPTContactGroupModel
@end
