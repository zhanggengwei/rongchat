//
//  PPDataDef.h
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RCIMContactStatus) {
    RCIMContactCustom=20,//好友
    RCIMContactRequestFriend=11// 请求称为好友
};

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

//网络请求使用的类
@interface RCUserInfoBaseData : PPDataDef
@property (nonatomic,copy) NSString * region;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * portraitUri;
@property (nonatomic,copy) NSString * indexChar;
@property (nonatomic,copy) NSString * nickNameWord;
@end

@interface RCUserInfoData : PPDataDef
@property (nonatomic,copy)  NSString * displayName;
@property (nonatomic,copy)  NSString * message;
@property (nonatomic,copy)  NSString * updatedAt;
@property (nonatomic,assign) BOOL isSelected;//ignore 
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) RCUserInfoBaseData * user;
@property (nonatomic,assign) BOOL enabled;
//默认头像
@property (nonatomic,strong) NSString * placeImage;
@property (nonatomic,strong) NSString * controllerName;
@end

@interface RCContactGroupData : PPDataDef

@property (nonatomic,strong) NSString * creatorId;
@property (nonatomic,strong) NSString * bulletin;
@property (nonatomic,strong) NSString * portraitUri;
@property (nonatomic,strong) NSString * deletedAt;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * indexId;
@property (nonatomic,assign) NSInteger maxMemberCount;
@property (nonatomic,assign) NSInteger memberCount;

@end

@interface PPTContactGroupModel : PPDataDef
@property (nonatomic,strong) RCContactGroupData * group;
@property (nonatomic,assign) NSInteger  role;
@end
