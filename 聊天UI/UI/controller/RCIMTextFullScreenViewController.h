//
//  RCIMFullScreenViewController.h
//  rongchat
//
//  Created by VD on 2017/8/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RCIMRemoveFromWindowHandler)(void);
@interface RCIMTextFullScreenViewController : UIViewController

@property (nonatomic, copy, readonly) NSString *text;

- (instancetype)initWithText:(NSString *)text;
- (void)setRemoveFromWindowHandler:(RCIMRemoveFromWindowHandler)removeFromWindowHandler;
@end
