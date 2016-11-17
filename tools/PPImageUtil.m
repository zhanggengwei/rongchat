//
//  PPImageUtil.m
//  PPDate
//
//  Created by bobo on 16/4/20.
//  Copyright © 2016年 郭远强. All rights reserved.
//

#import "PPImageUtil.h"
#import "PPColorUtil.h"

static NSMutableDictionary *colorImageDictionary = nil;

static CGRect oldframe;

static UIImage * saveImage = nil;

@implementation PPImageUtil

+ (UIImage *)imageFromColor:(UIColor *)aColor
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorImageDictionary = [[NSMutableDictionary alloc] init];
    });
    
    NSString *colorString = [PPColorUtil stringFromColor:aColor];
    UIImage *image = [colorImageDictionary objectForKey:colorString];
    if (image)
    {
        return image;
    }
    else
    {
        CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0f);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [aColor CGColor]);
        CGContextFillRect(context, rect);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [colorImageDictionary setObject:image forKey:colorString];
        return image;
    }
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

+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
#pragma mark 保存按钮消失
//    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showSaveBtn:)];
//    
//    [imageView addGestureRecognizer: longPress];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
+(void)showSaveBtn:(UILongPressGestureRecognizer * )Recognizer{

    
    UIView * backview = Recognizer.view.superview;
  
    NSArray * arr = backview.subviews;
  
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]]){
            [UIView animateWithDuration:1 animations:^{
                 ((UIButton *)obj).hidden = NO;
            }];
            return ;
            
        }else if ([obj isKindOfClass:[UIImageView class]]){
        
            saveImage = ((UIImageView *)obj).image;
        }
        
    }];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH - 80,CGRectGetMaxY(Recognizer.view.frame) + 10,70, 30);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [Recognizer.view.superview addSubview:btn];
    [btn addTarget:self
            action:@selector(saveImageAction:) forControlEvents:UIControlEventTouchUpInside];
}

+(void)saveImageAction:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    

}

+(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
   // [PPIndicatorView showString:message duration:1];
    
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
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
    if (imageWidth <= SCREEN_WIDTH || imageHeight <= SCREEN_WIDTH)
    {
        return image;
    }
    
    newImage = [self imageByScalingWithSimple:image forSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIHGHT)];
    
    return newImage;
}

+ (UIImage *)imageCompressLargeImageToAspectFillScreen: (UIImage *)image
{
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    UIImage *newImage = nil;
    
    //如果图片宽高有小于屏幕的，不压缩直接返回
    if (imageWidth <= SCREEN_WIDTH || imageHeight <= SCREEN_HEIHGHT)
    {
        return image;
    }
    
    newImage = [self imageByScalingWithSimple:image aspectFillForSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIHGHT)];
    
    return newImage;
}

+ (UIImage *)resizableImageWithName:(NSString *)imageName
{
    
    
    UIImage *norImage = [UIImage imageNamed:imageName];
    
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}

@end
