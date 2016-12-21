//
//  RCIMZoomingScrollView.h
//  RCIMPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCIMPhotoProtocol.h"
#import "RCIMTapDetectingImageView.h"
#import "RCIMTapDetectingView.h"

#import <DACircularProgress/DACircularProgressView.h>

//@class RCIMPhotoBrowser, RCIMPhoto, RCIMCaptionView;
@class RCIMPhoto, RCIMCaptionView;

@protocol RCIMZoomingScrollViewDelegate;

@interface RCIMZoomingScrollView : UIScrollView <UIScrollViewDelegate, RCIMTapDetectingImageViewDelegate, RCIMTapDetectingViewDelegate> {
	
//	RCIMPhotoBrowser *__weak _photoBrowser;
    id<RCIMPhoto> _photo;
	
    // This view references the related caption view for simplified handling in photo browser
    RCIMCaptionView *_captionView;
    
	RCIMTapDetectingView *_tapView; // for background taps
    
    DACircularProgressView *_progressView;
    
    UIImageView *_loadingError;
}

@property (nonatomic, strong) RCIMTapDetectingImageView *photoImageView;
@property (nonatomic, strong) RCIMCaptionView *captionView;
@property (nonatomic, strong) id<RCIMPhoto> photo;

//- (id)initWithPhotoBrowser:(RCIMPhotoBrowser *)browser;
- (id)initWithPhotoDelegate:(id<RCIMZoomingScrollViewDelegate>)photoDelegate;
- (void)displayImage;
- (void)displayImageFailure;
- (void)setProgress:(CGFloat)progress forPhoto:(RCIMPhoto*)photo;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;

- (void)animateImage;

@end

@protocol RCIMZoomingScrollViewDelegate <NSObject>

@required
- (UIImage *)imageForPhoto:(id<RCIMPhoto>)photo zoomingScrollView:(RCIMZoomingScrollView *)zoomingScrollView;

@optional
- (UIColor *)trackTintColorForZoomingScrollView:(RCIMZoomingScrollView *)zoomingScrollView;
- (UIColor *)progressTintColorForZoomingScrollView:(RCIMZoomingScrollView *)zoomingScrollView;
- (CGFloat)animationDurationForZoomingScrollView:(RCIMZoomingScrollView *)zoomingScrollView;

- (void)singleTapInZoomingScrollView:(RCIMZoomingScrollView *)zoomingScrollView;
- (void)doubleTapInZoomingScrollView:(RCIMZoomingScrollView *)zoomingScrollView;
- (void)longTapInZoomingScrollView:(RCIMZoomingScrollView *)zoomingScrollView;

@end
