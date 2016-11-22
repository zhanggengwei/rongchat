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
    if ([mapping objectForKey:@"indexId"]) {
        [mapping setObject:@"id"forKey:@"indexId"];
    }
    return mapping;
}
@end
@implementation PPTokenDef

@end

@implementation PPPersonal
@end

@implementation PPUserBase

@end

@implementation PPUserBaseInfo

+(NSValueTransformer *)userJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PPUserBase class]];
}
@end


@implementation PPUploadImageToken

@end


@implementation PPCountryDef

@end
