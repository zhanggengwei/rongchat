//
//  RCIMMemberView.m
//  rongchat
//
//  Created by VD on 2017/9/2.
//  Copyright © 2017年 vd. All rights reserved.
//
#define RCIMMEMBER_ITEM_WIDTH (SCREEN_WIDTH-100)/4.0
#define RCIMMEMBER_ITEM_HEIGHT (RCIMMEMBER_ITEM_WIDTH +20)
#define RCIM_ITEM_MARGIN 10
#import "RCIMMemberView.h"
#import "UIImage+RCIMExtension.h"


@interface RCIMContactGroupCollectionCell : UICollectionViewCell
@property (nonatomic,strong) RCIMContactGroupMemberModel * model;
@end

@implementation RCIMContactGroupCollectionCell
{
    UIImageView * _avatarImageView;
    UILabel * _nameLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_avatarImageView];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
        }];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = UIColorFromRGB(0x727272);
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.centerX.mas_equalTo(self.contentView);
            make.height.mas_equalTo(self.contentView.mas_width).multipliedBy(1);
        }];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _nameLabel.text= @"";
}

- (void)setModel:(RCIMContactGroupMemberModel *)model
{
    UIImage * avatarImage = RCIM_PLACE_ARATARIMAGE;
    SD_LOADIMAGE(_avatarImageView, model.userInfo.user.portraitUri, avatarImage);
    _nameLabel.text = model.userInfo.user.name;
}
@end



@implementation RCIMContactGroupMemberModel

@end
@interface RCIMMemberView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation RCIMMemberView


- (instancetype)init
{
    if(self = [super init])
    {
        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.left.mas_equalTo(self.mas_left).mas_offset(20);
            make.top.mas_equalTo(self.mas_top).mas_offset(20);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.scrollEnabled = NO;
        
    }
    return self;
}

- (void)setDataSource:(NSArray<RCIMContactGroupMemberModel *> *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}
+ (CGFloat)contentViewHeight:(NSInteger)itemCount
{
    NSInteger line = itemCount%4?itemCount/4 + 1:itemCount/4;
    return (RCIMMEMBER_ITEM_HEIGHT+RCIM_ITEM_MARGIN) * line + 30;
}
- (UICollectionView *)collectionView
{
    if(_collectionView==nil)
    {
        
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(RCIMMEMBER_ITEM_WIDTH,RCIMMEMBER_ITEM_HEIGHT);
        layout.minimumLineSpacing = RCIM_ITEM_MARGIN;
        layout.minimumInteritemSpacing = RCIM_ITEM_MARGIN;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[RCIMContactGroupCollectionCell class] forCellWithReuseIdentifier:@"RCIMContactGroupCollectionCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCIMContactGroupCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCIMContactGroupCollectionCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

@end
