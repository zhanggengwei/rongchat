//
//  RCIMWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

extern const float RCIMInitialProgressValue;
extern const float RCIMInteractiveProgressValue;
extern const float RCIMFinalProgressValue;

typedef void (^RCIMWebViewProgressBlock)(float progress);
@protocol RCIMWebViewProgressDelegate;
@interface RCIMWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, njk_weak) id<RCIMWebViewProgressDelegate>progressDelegate;
@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) RCIMWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol RCIMWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(RCIMWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

