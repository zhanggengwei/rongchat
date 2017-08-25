//
//  PPDataDef.h
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface NSObject (DATABASE)

@end


@interface PPDataDef : MTLModel <MTLJSONSerializing>

@end

@interface PPTokenDef : PPDataDef

@property (nonatomic,strong) NSString * indexId;
@property (nonatomic,strong) NSString * token;

@end

@interface PPPersonal : PPDataDef
@property (nonatomic,strong) NSString * leftIconName;
@property (nonatomic,strong) NSString * rightIconName;
@property (nonatomic,strong) NSString * content;

@end

@interface PPUserBaseInfo : RCUserInfo

@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * region;
@property (nonatomic,copy) NSString * displayName;
@property (nonatomic,copy) NSString * indexChar;
@property (nonatomic,copy) NSString * nickNameWord;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * updatedAt;
@property (nonatomic,assign) NSInteger isBlack;
@property (nonatomic,assign) NSInteger status;


@end

@interface PPUploadImageToken : PPDataDef
@property (nonatomic,strong) NSString * target;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * domain;

@end

@interface PPCountryDef : PPDataDef

@property (nonatomic,assign) NSInteger country_id;
@property (nonatomic,strong) NSString * country_code;
@property (nonatomic,strong) NSString * country_name_en;
@property (nonatomic,strong) NSString * country_name_cn;
@property (nonatomic,strong) NSString * ab;

@end

@interface PPVertifyDef : PPDataDef
@property (nonatomic,strong) NSString * verification_token;
@end


@interface RCContactGroupMember : RCUserInfo
@property (nonatomic,copy) NSString * groupId;//组合主键
@end


//群组信息
@interface RCContactGroup : PPDataDef

@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * groupId;
@property (nonatomic,copy) NSString * portraitUri;//群组头像
@property (nonatomic,strong) NSArray<RCContactGroupMember *> * members;
@end



//网络请求使用的类
@interface RCUserInfoBaseData : PPDataDef
@property (nonatomic,copy) NSString * region;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * portraitUri;
@end

@interface RCUserInfoData : PPDataDef
@property (nonatomic,copy) NSString * displayName;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * updatedAt;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) RCUserInfoBaseData * user;
@end




