
//
//  PPTabBarController.m
//  rongchat
//
//  Created by vd on 2016/11/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPTabBarController.h"
#import "RCIMNavigationController.h"
@interface PPButton : UIButton
@end
@implementation PPButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat newX = 0.0;
    CGFloat newY = 5.0;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height * TabBarImageTextScale - newY;
    return CGRectMake( newX, newY, newWidth,newHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat newX = 0;
    CGFloat newY = contentRect.size.height * TabBarImageTextScale;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height-contentRect.size.height*TabBarImageTextScale;
    return CGRectMake(newX,newY,newWidth,newHeight);
}
@end

@interface PPTabBarController ()

@property (nonatomic,assign) CGFloat tabBarHeight;

@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) NSArray * selImageArray;
@property (nonatomic,strong) NSArray * controllerArray;

@property (nonatomic,strong) UIView * customBar;
@property (nonatomic,strong) PPButton * seleBtn;
@end
@implementation PPTabBarController
- (instancetype)init:(NSArray *)controllerArray selectImageArr:(NSArray *)imageSelect titleArr:(NSArray *)titleArr normalImageArr:(NSArray *)imageArr
{
    if(self = [super init])
    {
        self.controllerArray = controllerArray;
        self.imageArray = imageArr;
        self.selImageArray = imageSelect;
        self.titleArray = titleArr;
        self.tabBarHeight = 49.0;
        [self addController];
        [self.tabBar addSubview:self.customBar];
        [self addTabBarButton];
        [self setupTabbarLine];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"fff");
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showControllerIndex:(NSInteger)index
{
    self.seleBtn.selected = false;
    PPButton * button = [self.customBar viewWithTag:(1000+index) ];
    button.selected = true;
    self.seleBtn = button;
    self.selectedIndex = index;
}

-(void)showBadgeMark:(NSInteger)badge index:(NSInteger)index
{
    UILabel *  numLabel = [self.customBar viewWithTag:(1020+index)];
    numLabel.hidden = false;
    CGRect nFrame = numLabel.frame;
    if (badge <= 0) {
        //隐藏角标
        [self hideMarkIndex:index];
    } else
    {
        if (badge > 0 && badge <= 9)
        {
            nFrame.size.width = TabBarNumberMarkD;
        } else if (badge > 9 && badge <= 19)
        {
            nFrame.size.width = TabBarNumberMarkD+5;
        } else
        {
            nFrame.size.width = TabBarNumberMarkD+10;
        }
        nFrame.size.height = TabBarNumberMarkD;
        numLabel.frame = nFrame;
        numLabel.layer.cornerRadius = TabBarNumberMarkD/2.0;
        numLabel.text = [NSString stringWithFormat:@"%ld",badge];
        if (badge > 99)
        {
            numLabel.text = @"99+";
        }
    }
}

/**
 *  设置小红点
 *
 *  - param: index 位置
 */
-(void)showPointMarkIndex:(NSInteger)index
{
    UILabel *  numLabel = [self.customBar viewWithTag:(1020+index)];
    numLabel.hidden = false;
    CGRect nFrame = numLabel.frame;
    nFrame.size.height = TabBarPointMarkD;
    nFrame.size.width = TabBarPointMarkD;
    numLabel.frame = nFrame;
    numLabel.layer.cornerRadius = TabBarPointMarkD/2.0;
    numLabel.text = @"";
}

/**
 *  影藏指定位置角标
 *
 *  - param: index 位置
 */
- (void) hideMarkIndex:(NSInteger)index
{
    UILabel * numLabel = [self.customBar viewWithTag:(1020+index)];
    numLabel.hidden = true;
}

- (void)removeTabBarButton
{
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UITabBarItem class]])
        {
            [obj removeFromSuperview];
        }
    }];
}
- (UIView *)customBar
{
    if(_customBar == nil)
    {
        CGFloat x = 0;
        CGFloat y = 49.0 - self.tabBarHeight;
        CGFloat width = SCREEN_WIDTH;
        CGFloat height = self.tabBarHeight;
        _customBar = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
        _customBar.backgroundColor = TabBarColor;
    }
    return _customBar;
}
-(void)addController
{
    NSMutableArray * navArray = [NSMutableArray new];
    [self.controllerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * className = obj;
        Class cls = NSClassFromString(className);
        UIViewController * controller = [cls new];
        controller.title = self.titleArray[idx];
        RCIMNavigationController * nav = [[RCIMNavigationController alloc]initWithRootViewController:controller];
        [navArray addObject:nav];
    }];
    self.viewControllers = navArray;
}
- (void)addTabBarButton
{
    NSInteger num = self.controllerArray.count;
    for (int i = 0;i<num;i++)
    {
        CGFloat  width = SCREEN_WIDTH;
        CGFloat  x = (width*1.0)/(num) * i;
        CGFloat  y = 0.0;
        CGFloat  w = width/(num*1.0);
        CGFloat  h = self.tabBarHeight;
        PPButton *  button = [[PPButton alloc]initWithFrame:CGRectMake(x,y,w,h)];
        button.tag = 1000+i;
        [button setTitleColor:TabBarTitleColor forState:UIControlStateNormal];
        [button setTitleColor:ColorTitleSel forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:TabBarTitleFontSize];
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.selImageArray[i]] forState:UIControlStateSelected];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.customBar addSubview:button];
        //默认选中
        if (i == 0)
        {
            button.selected = YES;
            self.seleBtn = button;
        }
        //角标
        UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width/2.0+6, 3, TabBarPointMarkD, TabBarPointMarkD)];
        numLabel.layer.masksToBounds = true;
        numLabel.layer.cornerRadius = 10;
        numLabel.backgroundColor = [UIColor redColor];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:13];
        numLabel.tag = 1020+i;
        numLabel.hidden = true;
        [button addSubview:numLabel];
    }
}
- (void)buttonClickAction:(UIButton *)sender
{
    NSInteger index = sender.tag-1000;
    [self showControllerIndex:index];
}
- (void)setupTabbarLine
{
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.backgroundImage = [UIImage new];
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.customBar addSubview:line];
}
- (void)dealloc
{
    NSLog(@"dealloc ==%@",[self class]);
}
@end
