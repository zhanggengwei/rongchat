//
//  Mp3Recorder.h
//  BloodSugar
//
//  v0.8.5 Created by PeterPan on 14-3-24.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCIMRecoarderDelegate <NSObject>
- (void)failRecord;
- (void)beginConvert;
- (void)endConvertWithData:(NSData *)audioData withTimeInterval:(CGFloat)timeInterval;

@end

@interface RCIMRecoarder : NSObject
@property (nonatomic, weak) id<RCIMRecoarderDelegate> delegate;

- (id)initWithDelegate:(id<RCIMRecoarderDelegate>)delegate;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end
