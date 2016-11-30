//
//  RJBackView.m
//  RJ91zhuanjiahao
//
//  Created by 123 on 16/4/7.
//  Copyright © 2016年 123. All rights reserved.
//

#import "RJBackView.h"
@implementation RJBackView
- (void)drawRect:(CGRect)rect
{
    for (int i =0; i < 3; i++)
    {
        [KPP_LINE_BACK_GROUND_COLOR set];
        UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0,45*(i+1), rect.size.width,0.7)];
        path.lineWidth = 0.7;
        [path fill];
    }
}

@end
