//
//  PPTool.m
//  rongChatDemo1
//
//  Created by vd on 2016/10/29.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPTool.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation PPTool
+ (CGSize)sizeWithString:(NSString *)aString font:(UIFont *)aFont constrainedToSize:(CGSize)aSize lineBreakMode:(NSLineBreakMode)aLineBreakMode
{
    CGSize returnSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        CGSize boundedSize = [aString boundingRectWithSize:aSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:aFont} context:nil].size;
        returnSize.width = ceilf(boundedSize.width);
        returnSize.height = ceilf(boundedSize.height);
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        returnSize = [aString sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:aLineBreakMode];
#pragma clang diagnostic pop
    }
    return returnSize;
    
}


+ (UIImage *)resizableImageWithName:(NSString *)imageName
{
    UIImage *norImage = [UIImage imageNamed:imageName];
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    return newImage;
}
+ (UIImage *)imageFromView:(UIView *)aView scale:(CGFloat)aScale
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, aScale);
    //    [aView.layer renderInContext:UIGraphicsGetCurrentContext()]; // 此方法无法截取到视频
    [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageFromView:(UIView *)aView
{
    UIImage *image = [self imageFromView:aView scale:0.0f];
    return image;
}
+ (UIImage *)noScaleImageFromView:(UIView *)aView
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 1.0);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+ (UIImage *)imageFromView:(UIView *)theView inRect:(CGRect)aRect
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, theView.opaque, NO);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(aRect.origin.x*scale, aRect.origin.y*scale,
                             aRect.size.width*scale, aRect.size.height*scale);
    CGImageRef cgImg = CGImageCreateWithImageInRect([theImage CGImage], rect);
    UIImage* aImg = [UIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    return aImg;
}
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

//通过计算得到缩放系数
+ (UIImage*)imageByScalingWithSimple:(UIImage*)image forSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [image drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*)imageByScalingWithSimple:(UIImage*)image aspectFillForSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    //    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        //        if (widthFactor > heightFactor)
        //        {
        //            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        //        }
        //        else if (widthFactor < heightFactor)
        //        {
        //            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        //        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight)); // this will crop
    CGRect thumbnailRect = CGRectZero;
    //    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [image drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageCompressLargeImageToFitScreen: (UIImage *)image
{
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    UIImage *newImage = nil;
    
    //如果图片宽高有小于屏幕的，不压缩直接返回
    if (imageWidth <= SCREEN_WIDTH || imageHeight <= SCREEN_HEIGHT)
    {
        return image;
    }
    
    newImage = [self imageByScalingWithSimple:image forSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    return newImage;
}

+ (UIImage *)imageCompressLargeImageToAspectFillScreen: (UIImage *)image
{
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    UIImage *newImage = nil;
    
    //如果图片宽高有小于屏幕的，不压缩直接返回
    if (imageWidth <= SCREEN_WIDTH || imageHeight <= SCREEN_HEIGHT)
    {
        return image;
    }
    
    newImage = [self imageByScalingWithSimple:image aspectFillForSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    return newImage;
}
@end
