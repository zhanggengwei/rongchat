//
//  RCIMWeakReference.m
//  Kuber
//
//  v0.8.5 Created by Kuber on 16/4/29.
//  Copyright © 2016年 Huaxu Technology. All rights reserved.
//

#import "RCIMWeakReference.h"

RCIMWeakReference makeRCIMWeakReference(id object) {
    __weak id weakref = object;
    return ^{
        return weakref;
    };
}

id weakReferenceNonretainedObjectValue(RCIMWeakReference ref) {
	return ref ? ref() : nil;
}
