//
//  PPImageUtil.h
//  PPDate
//
//  Created by bobo on 16/4/20.
//  Copyright © 2016年 郭远强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPImageUtil : NSObject

/**
 *  UIColor -》 UIImage
 *
 *  @param aColor 图片颜色
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromColor:(UIColor *)aColor;

/**
 *  UIView -》 UIImage ，指定scale
 *
 *  @param aView  需要截屏的view
 *  @param aScale 生成的image的scale
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)aView scale:(CGFloat)aScale;

/**
 *  UIView -》UIImage
 *
 *  @param aView 需要截屏的view
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)aView;

/**
 *  UIView -》 UIImage ，指定区域
 *
 *  @param theView 需要截屏的view
 *  @param aRect   截屏的范围
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)theView inRect:(CGRect)aRect;

//压缩图片
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;

+(void)showImage:(UIImageView *)avatarImageView;

+ (UIImage*)imageByScalingWithSimple:(UIImage*)image forSize:(CGSize)targetSize;

+ (UIImage*)imageByScalingWithSimple:(UIImage*)image aspectFillForSize:(CGSize)targetSize;

+ (UIImage *)imageCompressLargeImageToFitScreen: (UIImage *)image;

+ (UIImage *)imageCompressLargeImageToAspectFillScreen: (UIImage *)image;

// 返回拉伸后的图片
+ (UIImage *)resizableImageWithName:(NSString *)imageName;

// 生成一个image

@end
