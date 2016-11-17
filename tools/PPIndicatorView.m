//
//  PPIndicatorView.m
//  PPDate
//
//  Created by 郭远强 on 16/3/11.
//  Copyright © 2016年 郭远强. All rights reserved.
//

#import "PPIndicatorView.h"
#import "PPViewUtil.h"
#import "PPBaseViewController.h"

static UIWindow *gPPHighLevelWindow = nil;

#define kDAIndictorViewPlayDuration 1.0f

@implementation PPIndicatorView

- (id)initWithSingleView:(UIView *)aView
{
    if (aView == nil)
    {
        aView = [PPViewUtil mainWindow];
    }
    
    [PPIndicatorView hideAllHUDsForView:aView animated:NO];
    
    self = [super initWithView:aView];
    [self setOpacity:0.9];
    [aView addSubview:self];
    
    return self;
}

- (id)initWithView:(UIView *)aView
{
    if (aView == nil)
    {
        aView = [PPViewUtil mainWindow];
    }
    
    self = [super initWithView:aView];
    [self setOpacity:0.9];
    [aView addSubview:self];
    
    return self;
}

+ (UIWindow *)getHighLevelWindow
{
    if (gPPHighLevelWindow == nil)
    {
        gPPHighLevelWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [gPPHighLevelWindow setWindowLevel:UIWindowLevelAlert];
    }
    return gPPHighLevelWindow;
}

+ (PPIndicatorView *)showString:(NSString *)aString
{
    PPIndicatorView *HUD = [self showString:aString duration:kDAIndictorViewPlayDuration];
    return HUD;
}


+ (PPIndicatorView *)showCustomView:(UIView *)aCustomView inView:(UIView *)aView
{
    PPIndicatorView *HUD = [[PPIndicatorView alloc] initWithSingleView:aView];
    
    [aCustomView.layer setCornerRadius:4.0f];
    [HUD setMode:MBProgressHUDModeCustomView];
    [HUD setMargin:0.0f];
    [HUD setRemoveFromSuperViewOnHide:YES];
    [HUD setColor:[UIColor clearColor]];
    [HUD setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
    [HUD setCustomView:aCustomView];
    [HUD show:YES];
    
    return HUD;
}

+ (PPIndicatorView *)showAlertString:(NSString *)aString
{
    UIWindow *window = [self getHighLevelWindow];
    [window setHidden:NO];
    
    PPIndicatorView *HUD = [[PPIndicatorView alloc] initWithView:window];
    [HUD setMode:MBProgressHUDModeText];
    
    [HUD setDetailsLabelText:aString];
    [HUD setDetailsLabelFont:[UIFont systemFontOfSize:17.0f]];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep((unsigned int)kDAIndictorViewPlayDuration);
    } completionBlock:^{
        [HUD removeFromSuperview];
        if (window.subviews.count == 0)
        {
            [window setHidden:YES];
        }
    }];
    
    return HUD;
}


+ (PPIndicatorView *)showString:(NSString *)aString duration:(NSUInteger)aDuration
{
    PPIndicatorView *HUD = [self showString:aString duration:aDuration inView:nil];
    return HUD;
}

+ (PPIndicatorView *)showString:(NSString *)aString duration:(NSUInteger)aDuration inView:(UIView *)aView
{
    PPIndicatorView *HUD = [[PPIndicatorView alloc] initWithSingleView:aView];
    [HUD setMode:MBProgressHUDModeText];
    
    [HUD setDetailsLabelText:aString];
    [HUD setDetailsLabelFont:[UIFont systemFontOfSize:17.0f]];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep((unsigned int)aDuration);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
    return HUD;
}

#pragma mark - loading
+ (PPIndicatorView *)showLoading
{
    PPIndicatorView *HUD = [[PPIndicatorView alloc] initWithSingleView:nil];
    
    [HUD setMode:MBProgressHUDModeCustomView];
    [HUD setRemoveFromSuperViewOnHide:YES];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 24.0f, 24.0f)];
    customView.backgroundColor = [UIColor blackColor];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [customView addSubview:indicator];
    indicator.backgroundColor = [UIColor clearColor];
    [indicator startAnimating];
    [HUD setCustomView:customView];
    [HUD show:YES];
    
    return HUD;
}

+ (void)hideLoading
{
    [PPIndicatorView hideAllHUDsForView:[PPViewUtil mainWindow] animated:YES];
}

+ (PPIndicatorView *)showLoadingInView:(UIView *)aView
{
    PPIndicatorView *HUD = [[PPIndicatorView alloc] initWithSingleView:aView];
    
    [HUD setMode:MBProgressHUDModeCustomView];
    [HUD setRemoveFromSuperViewOnHide:YES];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 24.0f, 24.0f)];
    customView.backgroundColor = [UIColor blackColor];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [customView addSubview:indicator];
    indicator.backgroundColor = [UIColor clearColor];
    [indicator startAnimating];
    [HUD setCustomView:customView];
    [HUD show:YES];
    
    return HUD;
}

+ (void)hideLoadingInView:(UIView *)aView
{
    [PPIndicatorView hideAllHUDsForView:aView animated:YES];
}


@end
