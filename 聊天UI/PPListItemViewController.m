//
//  PPListItemViewController.m
//  rongchat
//
//  Created by Donald on 16/12/15.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPListItemViewController.h"
#import "PPTZeroSelectListCell.h"
#import "PPListItem.h"
#import "PPImageUtil.h"
#import "UITableViewCell+addLineView.h"

@interface PPListItemViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSArray * p_listItems;
@property (nonatomic, strong) UIView * p_selectListView;
@property (nonatomic, strong) UITableView * p_selectListTableView;

@end

@implementation PPListItemViewController

- (instancetype)initWithItems:(NSArray<PPListItem *> *)items
{
    self = [super init];
    if(self)
    {
        self.p_listItems = items;
        self.alphaComponent = 0.25;
        self.rightMargain = 1;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:self.alphaComponent];
    
    [self p_createSelectListView];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss
{
    [self dismissWithAnimate:YES];
}

#pragma mark - public method

- (void)show
{
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0) {
        // iOS 8+
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }else{
        // iOS7
        UIViewController *root = self.p_showViewController;
        while (root.parentViewController) {
            root = root.parentViewController;
        }
        root.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    [self.p_showViewController presentViewController:self animated:YES completion:nil];
}

- (void)dismissWithAnimate:(BOOL)animate
{
    if (animate) {
        //设置缩放的原点(必须配置)
        //这个point，应该是按照比例来的。0是最左边，1是最右边
        [self setAnchorPoint:CGPointMake(0.9, 0) forView:self.p_selectListView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.p_selectListView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}
#pragma mark privateMethods
- (void)p_createSelectListView
{
    //root view
    CGFloat height = self.itemHeight * self.p_listItems.count;
    
    self.p_selectListView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.itemWidth - self.rightMargain,65,self.itemWidth,height + 10)];
    
    [self.view addSubview:self.p_selectListView];
    
    //background image
  
    UIImage * bgImage  = [PPImageUtil resizableImageWithName:@"MoreFunctionFrame"];
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:self.p_selectListView.bounds];
    bgImageView.layer.masksToBounds = YES;
    bgImageView.image = bgImage;
    [self.p_selectListView addSubview:bgImageView];
    self.p_selectListView.layer.masksToBounds = YES;
    
    //tableView
    self.p_selectListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.itemWidth, height) style:UITableViewStylePlain];
    [self.p_selectListTableView registerClass:[PPTZeroSelectListCell class] forCellReuseIdentifier:@"PPTZeroSelectListCell"];
    
    self.p_selectListTableView.layer.masksToBounds = YES;
    self.p_selectListTableView.delegate        = self;
    self.p_selectListTableView.dataSource      = self;
    self.p_selectListTableView.scrollEnabled   = NO;
    self.p_selectListTableView.backgroundColor = [UIColor clearColor];
    self.p_selectListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.p_selectListView addSubview:self.p_selectListTableView];
    
    
    if ([ self.p_selectListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [ self.p_selectListTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([ self.p_selectListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [ self.p_selectListTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //TapGesture
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    dismissTap.delegate = self;
    [self.view addGestureRecognizer:dismissTap];
}

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.p_selectListView]) {
        return NO;
    }
    return YES;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismissWithAnimate:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(listItemDidSelectedAtIndex:item:)])
    {
        [self.delegate listItemDidSelectedAtIndex:indexPath.row item:self.p_listItems[indexPath.row]];
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPTZeroSelectListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPTZeroSelectListCell"];
    PPListItem * item = self.p_listItems[indexPath.row];
    cell.textLabel.text = item.content;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if(indexPath.row != self.p_listItems.count - 1)
    {
        [cell addBottomLine];
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.p_listItems.count;
}


@end
