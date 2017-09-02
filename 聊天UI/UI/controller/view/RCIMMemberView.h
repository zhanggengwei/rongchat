//
//  RCIMMemberView.h
//  rongchat
//
//  Created by VD on 2017/9/2.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCIMContactGroupMemberModel : NSObject

@property (nonatomic,strong) RCUserInfoData * userInfo;
@property (nonatomic,assign) BOOL addOrDel;


@end

@interface RCIMMemberView : UIView
@property (nonatomic,strong) NSArray<RCIMContactGroupMemberModel *> * dataSource;
+ (CGFloat)contentViewHeight:(NSInteger)itemCount;
@end
