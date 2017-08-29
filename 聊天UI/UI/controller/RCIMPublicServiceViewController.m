//
//  RCIMPublicServiceViewController.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMPublicServiceViewController.h"
#import "RCIMPublicServiceProfile.h"
#import "RCIMPublicServiceCell.h"

@interface RCIMPublicServiceViewController ()

@end

@implementation RCIMPublicServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公众号";
    NSArray * (^indexsContactListBlock)(NSArray<RCIMPublicServiceProfile *> * arr) = ^(NSArray<RCIMPublicServiceProfile *> * arr)
    {
        NSMutableArray * contactlistResults = [NSMutableArray new];
        NSMutableDictionary * results = [NSMutableDictionary new];
        [arr enumerateObjectsUsingBlock:^(RCIMPublicServiceProfile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![results objectForKey:obj.indexChar])
            {
                NSMutableArray * indexContactLists = [NSMutableArray arrayWithObject:obj];
                [results setObject:indexContactLists forKey:obj.indexChar];
            }else
            {
                NSMutableArray * indexContactLists = [results objectForKey:obj.indexChar];
                [indexContactLists addObject:obj];
            }
        }];
        NSArray * indexKeys = [[results allKeys]sortedArrayUsingSelector:@selector(compare:)];
        [indexKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray<RCIMPublicServiceProfile *> * userInfoArray = results[obj];
            NSArray * sortArray = [userInfoArray sortedArrayUsingComparator:^NSComparisonResult(RCIMPublicServiceProfile *   obj1, RCIMPublicServiceProfile * obj2) {
                return [obj1.model.name compare:obj2.model.name];
            }];
            [contactlistResults addObject:@{obj:sortArray}];
        }];
        return  contactlistResults;
    };
    self.cellClass = [RCIMPublicServiceCell class];
    NSArray * publicServiceList = [[RCIMClient sharedRCIMClient]getPublicServiceList];
    NSLog(@"publicServiceList ==%@",publicServiceList);
    NSMutableArray * array = [NSMutableArray new];
    [publicServiceList enumerateObjectsUsingBlock:^(RCPublicServiceProfile * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HanyuPinyinOutputFormat * outFormat = [HanyuPinyinOutputFormat new];
        outFormat.caseType = CaseTypeLowercase;
        outFormat.toneType =ToneTypeWithoutTone;
        outFormat.vCharType = VCharTypeWithUUnicode;
        [PinyinHelper toHanyuPinyinStringWithNSString:obj.name withHanyuPinyinOutputFormat:outFormat withNSString:@"" outputBlock:^(NSString *pinYin) {
            char indexChar = [[[pinYin substringToIndex:1]uppercaseString]characterAtIndex:0];
            if(indexChar<'A'||indexChar>'Z')
            {
                indexChar = '#';
            }
            RCIMPublicServiceProfile * data = [RCIMPublicServiceProfile new];
            data.model = obj;
            data.indexChar = [NSString stringWithFormat:@"%c",indexChar];
            [array addObject:data];
            if(array.count==publicServiceList.count)
            {
              self.dataSource = indexsContactListBlock(array);
            }
            
        }];
    }];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
