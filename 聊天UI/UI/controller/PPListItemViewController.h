//
//  PPListItemViewController.h
//  rongchat
//
//  Created by Donald on 16/12/15.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPListItem;
@protocol PPListItemViewControllerDelegate <NSObject>

- (void)listItemDidSelectedAtIndex:(NSInteger)index item:(PPListItem *)selectItem;

@end

@protocol PPListItemViewControllerDataSource <NSObject>

@end


@interface PPListItemViewController : UIViewController

@property (nonatomic,assign) CGFloat itemWidth;//default  80
@property (nonatomic,assign) CGFloat itemHeight;//default 50
@property (nonatomic,assign) CGFloat alphaComponent;//透明度 default 0.25
@property (nonatomic,strong) UIImage * image;//
@property (nonatomic,strong) UIColor * backColor;//
@property (nonatomic,assign) CGFloat rightMargain;

@property (nonatomic,weak) id <PPListItemViewControllerDelegate>delegate;
@property (nonatomic,weak) id <PPListItemViewControllerDataSource>dataSource;
@property (nonatomic,strong) UIViewController * p_showViewController;

-(instancetype)initWithItems:(NSArray<PPListItem *> *)items;

- (void)show;



@end
