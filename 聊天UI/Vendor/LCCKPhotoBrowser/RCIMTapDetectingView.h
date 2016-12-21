//
//  RCIMTapDetectingView.h
//  RCIMPhotoBrowser
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCIMTapDetectingViewDelegate;

@interface RCIMTapDetectingView : UIView {
	id <RCIMTapDetectingViewDelegate> __weak tapDelegate;
}
@property (nonatomic, weak) id <RCIMTapDetectingViewDelegate> tapDelegate;
- (void)handleSingleTap:(UITouch *)touch;
- (void)handleDoubleTap:(UITouch *)touch;
- (void)handleTripleTap:(UITouch *)touch;
@end

@protocol RCIMTapDetectingViewDelegate <NSObject>
@optional
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;
@end
