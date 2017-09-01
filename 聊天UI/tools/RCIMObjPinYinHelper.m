//
//  RCIMObjPinYinHelper.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMObjPinYinHelper.h"
#import <PinYin4Objc.h>

@implementation RCIMObjPinYinHelper
+ (void)converNameToPinyin:(NSString *)name block:(convertBlock)block
{
    HanyuPinyinOutputFormat * outFormat = [HanyuPinyinOutputFormat new];
    outFormat.caseType = CaseTypeLowercase;
    outFormat.toneType =ToneTypeWithoutTone;
    outFormat.vCharType = VCharTypeWithUUnicode;
    [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outFormat withNSString:@"" outputBlock:^(NSString *pinYin) {
        char ch = [[[pinYin substringToIndex:1]uppercaseString]characterAtIndex:0];
        if(ch<'A'||ch>'Z')
        {
            ch = '#';
        }
        if(block)
        {
            block([NSString stringWithFormat:@"%c",ch]);
        }
    }];
}
@end
