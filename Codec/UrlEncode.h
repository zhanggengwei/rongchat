//
//  UrlEncode.h
//  PRIS
//
//  Created by huangxiaowei on 10-12-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UrlEncode : NSObject {

}
+ (BOOL)needEncode:(NSString *)aStr;
+ (NSString *)encode:(NSString *)aStr;
+ (NSString *)encode:(NSString *)aStr usingEncoding:(NSStringEncoding)aEncoding;
@end

@interface OAuthPercentEncode : NSObject
{
}
+ (NSString *)encode:(NSString *)aStr;
@end;