//
//  RCIMContactDetailsViewController.m
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMContactDetailsViewController.h"

@interface RCIMContactDetailsViewController ()

@end

@implementation RCIMContactDetailsViewController

+ (instancetype)createViewController
{
    return [[UIStoryboard storyboardWithName:@"RCContact" bundle:nil]instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)dealloc
{
    NSLog(@"dd");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
