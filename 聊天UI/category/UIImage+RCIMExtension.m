//
//  UIImage+RCIMExtension.m
//  LeanCloudChatKit-iOS
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/5/7.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "UIImage+RCIMExtension.h"
#import "RCIMImageManager.h"


@implementation NSBundle (MyCategory)

+ (NSString *)RCIM_pathForResource:(NSString *)name
                            ofType:(NSString *)extension {
    // First try with the main bundle
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSString * path = [mainBundle pathForResource:name
                                           ofType:extension];
    if (path) {
        return path;
    }
    
    // Otherwise try with other bundles
    NSBundle * bundle;
    for (NSString * bundlePath in [mainBundle pathsForResourcesOfType:@"bundle"
                                                          inDirectory:nil])
    {
        bundle = [NSBundle bundleWithPath:bundlePath];
        path = [bundle pathForResource:name
                                ofType:extension];
        if (path)
        {
            return path;
        }
    }
    
    NSLog(@"No path found for: %@ (.%@)", name, extension);
    return nil;
}

@end

@implementation UIImage (RCIMExtension)

#pragma mark -
#pragma mark - public Methods

- (UIImage *)RCIM_imageByScalingAspectFill {
    CGSize kMaxImageViewSize = {.width = 200, .height = 200};
    CGSize originSize = ({
        CGFloat width = self.size.width;
        CGFloat height = self.size.height;
        CGSize size = CGSizeMake(width, height);
        size;
    });
    UIImage *resizedImage = [self RCIM_imageByScalingAspectFillWithOriginSize:originSize limitSize:kMaxImageViewSize];
    return resizedImage;
}

- (UIImage *)RCIM_imageByScalingAspectFillWithOriginSize:(CGSize)originSize {
    CGSize kMaxImageViewSize = {.width = 200, .height = 200};
    UIImage *resizedImage = [self RCIM_imageByScalingAspectFillWithOriginSize:originSize limitSize:kMaxImageViewSize];
    return resizedImage;
}

- (UIImage *)RCIM_imageByScalingAspectFillWithOriginSize:(CGSize)originSize
                                               limitSize:(CGSize)limitSize {
    if (originSize.width == 0 || originSize.height == 0) {
        return self;
    }
    CGFloat aspectRatio = originSize.width / originSize.height;
    CGFloat width;
    CGFloat height;
    //胖照片
    if (limitSize.width / aspectRatio <= limitSize.height) {
        width = limitSize.width;
        height = limitSize.width / aspectRatio;
    } else {
        //瘦照片
        width = limitSize.height * aspectRatio;
        height = limitSize.height;
    }
    return [self RCIM_scaledToSize:CGSizeMake(width, height)];
}

+ (UIImage *)RCIM_imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName bundleForClass:(Class)aClass {
    if (imageName.length == 0) return nil;
    if ([imageName hasSuffix:@"/"]) return nil;
    NSBundle *bundle = [NSBundle lcck_bundleForName:bundleName class:aClass];
    RCIMImageManager *manager = [RCIMImageManager defaultManager];
    UIImage *image = [manager getImageWithName:imageName
                                     inBundle:bundle];
    if (!image) {
        //`-getImageWithName` not work for image in Access Asset Catalog
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

+ (UIImage *)RCIM_imageNamed:(NSString *)imageName {
    RCIMImageManager *manager = [RCIMImageManager defaultManager];
    UIImage *image = [manager getImageWithName:imageName];
    if (!image) {
        //`-getImageWithName` not work for image in Access Asset Catalog
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

#pragma mark -
#pragma mark - Private Methods

- (UIImage *)RCIM_scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)RCIM_scalingPatternImageToSize:(CGSize)size {
    CGFloat scale = 0.0f;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (CGSizeEqualToSize(self.size, size) == NO) {
        CGFloat widthFactor = size.width / self.size.width;
        CGFloat heightFactor = size.height / self.size.height;
        scale = (widthFactor > heightFactor ? widthFactor : heightFactor);
        width  = self.size.width * scale;
        height = self.size.height * scale;
        y = (size.height - height) * 0.5;
        
        x = (size.width - width) * 0.5;
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(x, y, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) {
        RCLog(@"绘制指定大小的图片失败");
        return self;
    }
    return newImage ;
}

@end

