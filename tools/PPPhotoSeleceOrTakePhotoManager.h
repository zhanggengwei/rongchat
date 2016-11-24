//
//  PPPhotoSeleceOrTakePhotoManager.h
//  rongchat
//
//  Created by vd on 2016/11/24.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,PPPhotoSeleceOrTakePhotoManagerStyle) {
    PPPhotoSeleceOrTakePhotoManagerSelectPhoto,
    PPPhotoSeleceOrTakePhotoManagerTakeCarema
};

@protocol PPPhotoSeleceOrTakePhotoManagerDelegate <NSObject>
@optional
- (void)PPPhotoSeleceOrTakePhotoManagerSelectImage:(UIImage *)image;

@end

@interface PPPhotoSeleceOrTakePhotoManager : NSObject

@property (nonatomic,weak) id<PPPhotoSeleceOrTakePhotoManagerDelegate> delegate;
- (void)takeCaremaController:(UIViewController *)currentController;

- (void)selectPhotoController:(UIViewController *)currentController;



@end
