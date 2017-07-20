//
//  RCMessageConversationModel.m
//  rongchat
//
//  Created by VD on 2017/7/20.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCMessageConversationModel.h"

@interface RCMessageConversationModel ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RCMessageConversationModel

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


@end
