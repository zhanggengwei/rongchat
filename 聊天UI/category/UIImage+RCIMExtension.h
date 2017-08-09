//
//  UIImage+RCIMExtension.h
//  LeanCloudChatKit-iOS
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/5/7.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSBundle+RCIMExtension.h"

@interface UIImage (RCIMExtension)

- (UIImage *)RCIM_imageByScalingAspectFill;
/*!
 * @attention This will invoke `CGSize kMaxImageViewSize = {.width = 200, .height = 200};`.
 */
- (UIImage *)RCIM_imageByScalingAspectFillWithOriginSize:(CGSize)originSize;

- (UIImage *)RCIM_imageByScalingAspectFillWithOriginSize:(CGSize)originSize
                                               limitSize:(CGSize)limitSize;

+ (UIImage *)RCIM_imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName bundleForClass:(Class)aClass;
+ (UIImage *)RCIM_imageNamed:(NSString *)name;

- (UIImage *)RCIM_scalingPatternImageToSize:(CGSize)size;

@end
