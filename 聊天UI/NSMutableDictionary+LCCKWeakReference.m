//
//  NSMutableDictionary+RCIMWeakReference.m
//  Kuber
//
//  v0.8.5 Created by Kuber on 16/4/29.
//  Copyright © 2016年 Huaxu Technology. All rights reserved.
//

#import "NSMutableDictionary+RCIMWeakReference.h"
#import "RCIMWeakReference.h"

@implementation NSMutableDictionary (RCIMWeakReference)

- (void)lcck_weak_setObject:(id)anObject forKey:(NSString *)aKey {
    [self setObject:makeRCIMWeakReference(anObject) forKey:aKey];
}

- (void)lcck_weak_setObjectWithDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary.allKeys) {
        [self setObject:makeRCIMWeakReference(dictionary[key]) forKey:key];
    }
}

- (id)lcck_weak_getObjectForKey:(NSString *)key {
    return weakReferenceNonretainedObjectValue(self[key]);
}

@end
