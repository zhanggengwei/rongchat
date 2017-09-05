//
//  PPHTTPResponse.m
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPHTTPResponse.h"

@implementation PPHTTPResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    if ([mapping objectForKey:@"indexId"]) {
        [mapping setObject:@"id"forKey:@"indexId"];
    }
    return mapping;
}
+ (id)responseWithError:(NSError *)aError
{
    PPHTTPResponse *response = [[[self class] alloc] init];
    response.message = [aError localizedDescription];
    return response;
}

@end

@implementation PPUserInfoTokenResponse
+ (NSValueTransformer *)resultJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PPTokenDef class]];
}

@end

@implementation PPUserFriendListResponse

+ (NSValueTransformer *)resultJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RCUserInfoData class]];
}
@end

@implementation PPUserBaseInfoResponse

+ (NSValueTransformer *)resultJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[RCUserInfoBaseData class]];
    
}

@end

@implementation PPUploadImageTokenResponse

+ (NSValueTransformer *)resultJSONTransformer
{
    return  [MTLJSONAdapter dictionaryTransformerWithModelClass:[PPUploadImageToken class]];
    
}

@end

@implementation PPLoginOrRegisterHTTPResponse

@end


@implementation PPJudgeVerificationResponse

+ (NSValueTransformer *)resultJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PPVertifyDef class]];
}
@end

@implementation PPContactGroupListResponse
//@property (nonatomic,strong) NSArray<RCContactGroupData>
+ (NSValueTransformer *)resultJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PPTContactGroupModel class]];
}

@end

@implementation PPContactGroupSingleResponse

+ (NSValueTransformer *)resultJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[RCContactGroupData class]];
}
@end
