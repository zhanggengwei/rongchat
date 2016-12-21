//
//  RCIMPhotoBrowser.h
//  RCIMPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "RCIMPhoto.h"
#import "RCIMPhotoProtocol.h"
#import "RCIMCaptionView.h"

// Delgate
@class RCIMPhotoBrowser;
@protocol RCIMPhotoBrowserDelegate <NSObject>
@optional
- (void)photoBrowser:(RCIMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(RCIMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index;
- (void)photoBrowser:(RCIMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)index;
- (void)photoBrowser:(RCIMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex;
- (RCIMCaptionView *)photoBrowser:(RCIMPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
@end

// RCIMPhotoBrowser
@interface RCIMPhotoBrowser : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate> 

// Properties
@property (nonatomic, strong) id <RCIMPhotoBrowserDelegate> delegate;

// PageControl

//// Toolbar customization
//@property (nonatomic) BOOL displayToolbar;
//@property (nonatomic) BOOL displayCounterLabel;
//@property (nonatomic) BOOL displayArrowButton;
//@property (nonatomic) BOOL displayActionButton;
@property (nonatomic, strong) NSArray *actionButtonTitles;
//@property (nonatomic, weak) UIImage *leftArrowImage, *leftArrowSelectedImage;
//@property (nonatomic, weak) UIImage *rightArrowImage, *rightArrowSelectedImage;

// View customization
//@property (nonatomic) BOOL displayDoneButton;
@property (nonatomic) BOOL useWhiteBackgroundColor;
//@property (nonatomic, weak) UIImage *doneButtonImage;
@property (nonatomic, weak) UIColor *trackTintColor, *progressTintColor;

//@property (nonatomic, weak) UIImage *scaleImage;

//@property (nonatomic) BOOL arrowButtonsChangePhotosAnimated;

@property (nonatomic) BOOL forceHideStatusBar;
@property (nonatomic) BOOL usePopAnimation;
//@property (nonatomic) BOOL disableVerticalSwipe;

// defines zooming of the background (default 1.0)
@property (nonatomic) float backgroundScaleFactor;

// animation time (default .28)
@property (nonatomic) float animationDuration;

// Init
- (id)initWithPhotos:(NSArray *)photosArray;

//// Init (animated)
//- (id)initWithPhotos:(NSArray *)photosArray placeholderImageViews:(NSArray *)placeholderImageViews;

// Init with NSURL objects
- (id)initWithPhotoURLs:(NSArray *)photoURLsArray;

//// Init with NSURL objects (animated)
//- (id)initWithPhotoURLs:(NSArray *)photoURLsArray placeholderImageViews:(NSArray *)placeholderImageViews;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

// Get RCIMPhoto at index
- (id<RCIMPhoto>)photoAtIndex:(NSUInteger)index;

@end
