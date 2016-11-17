//
//  PPSettingCell.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/2.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSettingCell : UITableViewCell
- (void)layoutContent:(NSString *)content textAligent:(NSTextAlignment)alignent;
- (void)layoutContent:(NSString *)content textAligent:(NSTextAlignment)alignent andDetailText:(NSString *)text;

@end
