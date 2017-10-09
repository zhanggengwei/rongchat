//
//  PPBaseTableViewController.m
//  rongchat
//
//  Created by VD on 2017/10/9.
//  Copyright © 2017年 vd. All rights reserved.
//



#import "PPBaseTableViewController.h"


@implementation PPCustomTableViewCell
{
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
    
    UIImageView * _rightIconImageView;
    UILabel * _detilLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.icon = nil;
    self.text = nil;
    self.icon_leftMargin = 0;
    self.detail = nil;
    self.right_icon = nil;
    self.text_leftMargin = 0;
}

- (void)createUI
{
    _iconImageView = [UIImageView new];
    _titleLabel = [UILabel new];
    
    _detilLabel = [UILabel new];
    _detilLabel.font = DETAIL_FONT_SIZE;
    _detilLabel.textColor = [UIColor grayColor];

    _rightIconImageView = [UIImageView new];
    _rightIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _rightIconImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_rightIconImageView];
    [self.contentView addSubview:_detilLabel];
    
    
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(self.icon_leftMargin);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImageView.mas_right).mas_offset(self.text_leftMargin);
        make.right.lessThanOrEqualTo(_detilLabel.mas_left).mas_offset(-50);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [_rightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [_detilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_rightIconImageView);
        make.right.mas_equalTo(_rightIconImageView.mas_left);
        make.width.lessThanOrEqualTo(@80);
    }];
    
    @weakify(self);
    [RACObserve(self,icon) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        _iconImageView.image = self.icon;
    }];
    [RACObserve(self, text)subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        _titleLabel.text = self.text;
    }];
    [RACObserve(self, icon_leftMargin)subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
              make.left.mas_equalTo(self.contentView.mas_left).mas_offset(self.icon_leftMargin);
        }];
    }];
    
    [RACObserve(self, text_leftMargin)subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImageView.mas_right).mas_offset(self.text_leftMargin);
        }];
    }];
    
    [RACObserve(self, right_icon)subscribeNext:^(id  _Nullable x) {
        _rightIconImageView.image = x;
    }];
    
    [RACObserve(self, detail)subscribeNext:^(id  _Nullable x) {
        _detilLabel.text = x;
    }];
    
    [[RACObserve(self, imageUrl) map:^id _Nullable(id  _Nullable value) {
        return value;
    }]subscribeNext:^(id  _Nullable x) {
       
        SD_LOADIMAGE(_rightIconImageView, x,nil);
    }];
    
    [RACObserve(self, right_iconSize) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [_rightIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.right_iconSize);
        }];
    }];
}

@end

@interface PPBaseTableViewController ()

@end

@implementation PPBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
