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
+ (RACSignal *)converNameToPinyin:(NSString *)name
{
    if(name==nil)
    {
        name = @"NO KNOWN";
    }
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
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
            [subscriber sendNext:[NSString stringWithFormat:@"%c",ch]];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    return signal;
 
}
@end
