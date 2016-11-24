//
//  singleton.h
//  rongchat
//
//  Created by vd on 2016/11/24.
//  Copyright © 2016年 vd. All rights reserved.
//

#ifndef singleton_h
#define singleton_h

#define singleton_interface(class) + (instancetype)shared##class;

// .m
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}

#endif /* singleton_h */
