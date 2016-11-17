//
//  PPDataDef.h
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
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

@interface PPUserBase : PPDataDef
@property (nonatomic,strong) NSString * indexId;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * portraitUri;
@property (nonatomic,strong) NSString * region;

@end

@interface PPUserBaseInfo : PPDataDef
@property (nonatomic,strong) NSString * displayName;
@property (nonatomic,strong) NSString * message;
@property (nonatomic,strong) NSString * updatedAt;
@property (nonatomic,assign) NSInteger  status;
@property (nonatomic,strong) PPUserBase * user;

@end


@interface PPUploadImageToken : PPDataDef
@property (nonatomic,strong) NSString * target;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * domain;

@end

