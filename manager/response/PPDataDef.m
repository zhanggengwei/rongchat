//
//  PPDataDef.m
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPDataDef.h"
#import "NSDate+RCIMDateTools.h"

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

- (NSString *)portraitUri
{
    if(_portraitUri==nil)
    {
        return @"";
    }
    return _portraitUri;
}

@end

@implementation RCUserInfoData

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[RCUserInfoBaseData class]];
}

- (void)setUpdatedAt:(NSString *)updatedAt
{
    _updatedAt = updatedAt;
    _updatedAt = [_updatedAt stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString * regex = @"^[1-9]\\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])\\s+(20|21|22|23|[0-1]\\d):[0-5]\\d:[0-5]\\d";
    NSRegularExpression * expression = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = [expression  rangeOfFirstMatchInString:_updatedAt options:NSMatchingReportProgress range:NSMakeRange(0, updatedAt.length)];
    if(range.location!= NSNotFound&&range.length)
    {
        _updatedAt = [_updatedAt substringWithRange:range];
    }
    NSLog(@"_updatedAt ==%@",_updatedAt);
    
}

- (NSString *)placeImage
{
    return _placeImage?_placeImage:@"";
}
-(NSComparisonResult)compare:(RCUserInfoData *)data{
    return [self timeIntervalByDateString:self.updatedAt]<[self timeIntervalByDateString:data.updatedAt];
}
- (NSInteger)timeIntervalByDateString:(NSString *)time
{
    if(time==nil)
    {
        return [[NSDate date]timeIntervalSince1970];
    }
    NSInteger timeInterval = [[NSDate lcck_dateWithString:time formatString:@"yyyy-MM-dd HH:mm:ss"]timeIntervalSince1970];
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
