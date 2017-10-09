//
//  PPBaseTableViewController.h
//  rongchat
//
//  Created by VD on 2017/10/9.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PPCustomTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) UIImage * icon;
@property (nonatomic,assign) BOOL arrowHidden;
@property (nonatomic,strong) RACSubject * subject;
@property (nonatomic,assign) CGFloat icon_leftMargin;
@property (nonatomic,assign) CGFloat text_leftMargin;
@property (nonatomic,strong) NSString * detail;
@property (nonatomic,strong) UIImage * right_icon;
@property (nonatomic,strong) NSString * imageUrl;
@property (nonatomic,assign) CGSize right_iconSize;

@end

@interface PPBaseTableViewController : UITableViewController


@end
