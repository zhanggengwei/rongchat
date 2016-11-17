//
//  des.h
//
//  Created by qq zhang on 12-4-12.
//  Copyright (c) 2012年 netease. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface Des : NSObject {

}

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+ (NSString *) decryptUseDES:(NSString *)cipher key:(NSString *)key;
+ (void)test;

@end
