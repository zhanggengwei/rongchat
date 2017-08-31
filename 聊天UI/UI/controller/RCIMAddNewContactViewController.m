//
//  RCIMAddNewContactViewController.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMAddNewContactViewController.h"
#import "RCIMAddContactTableViewCell.h"
#import "RCIMAddContactModel.h"

@interface RCIMAddNewContactViewController ()

@end

@implementation RCIMAddNewContactViewController

- (void)viewDidLoad {
    self.style = UITableViewStyleGrouped;
    [super viewDidLoad];
    self.title = @"添加朋友";
    self.cellClass = [RCIMAddContactTableViewCell class];
    RCIMAddContactModel * model1 = [RCIMAddContactModel new];
    model1.title = @"雷达加朋友";
    model1.detail = @"添加身边的朋友";
    
    RCIMAddContactModel * model2 = [RCIMAddContactModel new];
    model2.title = @"面对面建群";
    model2.detail = @"与身边的朋友进入同一个群聊";
    
    RCIMAddContactModel * model3 = [RCIMAddContactModel new];
    model3.title = @"扫一扫";
    model3.detail = @"扫描二维码图片";
    
    
    RCIMAddContactModel * model4 = [RCIMAddContactModel new];
    model4.title = @"手机联系人";
    model4.detail = @"添加通讯录中的朋友";
    
    RCIMAddContactModel * model5 = [RCIMAddContactModel new];
    model5.title = @"公众号";
    model5.detail = @"获取更多的资讯和服务";
    self.dataSource = @[@{@"":@[model1,model2,model3,model4,model5]}];
    
    // Do any additional setup after loading the view.
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
