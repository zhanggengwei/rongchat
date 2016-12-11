//
//  RCContactUserInfo.m
//  rongchat
//
//  Created by vd on 2016/12/8.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCContactUserInfo.h"
#import "NSString+isValid.h"

@interface RCContactUserInfo ()
@property (nonatomic,strong) NSString * nickNameChar;
@property (nonatomic,strong) RCUserInfo * info;
@property (nonatomic,strong) NSString * name;

@end


@implementation RCContactUserInfo

- (instancetype)transFromPPUserBaseInfoToRCContactUserInfo:(PPUserBaseInfo *)baseInfo
{
     self.info = [[RCUserInfo alloc]initWithUserId:baseInfo.user.indexId name:([baseInfo.displayName isValid]?baseInfo.displayName:baseInfo.user.nickname) portrait:baseInfo.user.portraitUri];
    self.name = [baseInfo.displayName isValid]?baseInfo.displayName:baseInfo.user.nickname;
    HanyuPinyinOutputFormat * outputFormat = [[HanyuPinyinOutputFormat alloc]init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    [PinyinHelper toHanyuPinyinStringWithNSString:self.name withHanyuPinyinOutputFormat:outputFormat withNSString:@"" outputBlock:^(NSString *pinYin) {
        NSLog(@"pinYin  ===%@",pinYin);
        self.nickNameChar = [pinYin stringByReplacingOccurrencesOfString:@" " withString:@""];
    }];
    return self;
}

@end
