//
//  PPUpdatePassWordTableViewCell.h
//  rongchat
//
//  Created by vd on 2016/11/29.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PPUpdatePassWordTableViewCellStyle) {
    PPUpdatePassWordTableViewCellDisable,
    PPUpdatePassWordTableViewCellAble
};

@interface PPUpdatePassWordTableViewCell : UITableViewCell
@property (nonatomic,assign) PPUpdatePassWordTableViewCellStyle cellStyle;

- (void)setLeftContent:(NSString *)leftContent rightContent:(NSString *)rightcontent;

@property (nonatomic,copy) PPResponseBlock(blockText);



@end
