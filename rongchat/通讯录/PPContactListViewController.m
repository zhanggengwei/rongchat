//
//  PPContactListViewController.m
//  rongchat
//
//  Created by vd on 2016/11/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPContactListViewController.h"
#import "PPContactListCell.h"
#import "PPMessageViewController.h"
#import "RCUserInfo+nickNameChar.h"

@interface PPContactListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * array;
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) NSMutableDictionary * contactDict;
@property (nonatomic,strong) NSMutableArray * indexArr;

@end

@implementation PPContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"新的朋友",@"群聊",@"标签",@"公众号"];
    self.imageArray = @[@"plugins_FriendNotify",@"add_friend_icon_addgroup",@"Contact_icon_ContactTag",@"add_friend_icon_offical"];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerClass:[PPContactListCell class] forCellReuseIdentifier:@"PPContactListCell"];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
    self.indexArr = [NSMutableArray new];
    
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.tableView.sectionIndexColor = [UIColor grayColor];
    
    
    // self.tableView.sectionIndexMinimumDisplayRowCount = 6;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"contacts_add_friend") style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
 
    self.navigationItem.rightBarButtonItem = rightItem;
    self.contactDict = [NSMutableDictionary new];
    
    [[PPTUserInfoEngine shareEngine] addObserver:self forKeyPath:@"contactList" options:NSKeyValueObservingOptionNew context:nil];
    [self loadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kMainBackGroundColor;
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[PPTUserInfoEngine shareEngine] removeObserver:self forKeyPath:@"contactList"];
}

- (void)loadData
{
    NSArray * arr = [PPTUserInfoEngine shareEngine].contactList;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RCUserInfo * baseInfo = obj;
        if(![self.indexArr containsObject:[baseInfo.nickNameChar substringToIndex:1]])
        {
            [self.indexArr addObject:[baseInfo.nickNameChar substringToIndex:1]];
        }
        if([baseInfo.nickNameChar characterAtIndex:0] >='A'&&[baseInfo.nickNameChar characterAtIndex:0]<='Z')
        {
            NSArray * pre_Arr = [self.contactDict objectForKey:[baseInfo.nickNameChar substringToIndex:1]];
            if(pre_Arr==nil)
            {
                pre_Arr = [NSArray new];
            }
            pre_Arr=[pre_Arr arrayByAddingObject:baseInfo];
            pre_Arr = [pre_Arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [((RCUserInfo *)obj1).name compare:((RCUserInfo *)obj2).name];
                
                
            }];
            
            [self.contactDict setValue:pre_Arr forKey:[baseInfo.nickNameChar substringToIndex:1]];
        }else
        {
            if(![self.indexArr containsObject:[baseInfo.nickNameChar substringToIndex:1]])
            {
                [self.indexArr addObject:[baseInfo.nickNameChar substringToIndex:1]];
            }
            NSArray * pre_Arr = [self.contactDict objectForKey:@"#"];
            if(pre_Arr==nil)
            {
                pre_Arr = [NSArray new];
            }
            pre_Arr = [pre_Arr arrayByAddingObject:baseInfo];
            pre_Arr = [pre_Arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [((RCUserInfo *)obj1).name compare:((RCUserInfo *)obj2).name];
            }];
            [self.contactDict setValue:pre_Arr forKey:@"#"];
        }
     
            if(idx==arr.count-1)
            {

                self.indexArr = [NSMutableArray arrayWithArray:[self.indexArr sortedArrayUsingSelector:@selector(compare:)]];
                [self.indexArr insertObject:UITableViewIndexSearch atIndex:0];
                [self.tableView reloadData];
             
            }

    }];

 
    
}





- (void)sortPinyin
{
    
}





-(void)addFriend
{
//    PPAddFriendViewController * controller = [PPAddFriendViewController new];
//    controller.hidesBottomBarWhenPushed = true;
//    self.navigationController.pushViewController(controller, animated: true);
}



#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPContactListCell *  cell = [tableView dequeueReusableCellWithIdentifier:@"PPContactListCell"];
    
    if(indexPath.section==0)
    {
        //- (void)setLeftIconImageNamed:(NSString *)imageName andRightContentLabel:(NSString *)content
        NSString  * imageName = self.imageArray[indexPath.row];
        
        NSString * content = self.array[indexPath.row];
        
        [cell setLeftIconImageNamed:imageName andRightContentLabel:content];
    }else
    {
        NSString * key = self.indexArr[indexPath.section];
        NSArray * arr = [self.contactDict objectForKey:key];
        RCUserInfo * info = arr[indexPath.row];
        [cell setLeftIconImageNamed:info.portraitUri andRightContentLabel:info.name];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 4;
    }
    NSString * key = self.indexArr[section];
    NSArray * arr = [self.contactDict objectForKey:key];
    return arr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.contactDict.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * key = self.indexArr[indexPath.section];
    NSArray * arr = [self.contactDict objectForKey:key];
    RCUserInfo * info = arr[indexPath.row];
    
//    PPMessageViewController * conversationController = [[PPMessageViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:info.user.indexId];
  //  conversationController.hidesBottomBarWhenPushed = YES;
   // [self.navigationController pushViewController:conversationController animated:YES];
    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return nil;
    }
    return  self.indexArr[section];
    
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArr;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(0 == index)
    {
   
        return -1;
    }
    else
    {
        //因为返回的值是section的值。所以减1就是与section对应的值了
        return index-1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}



@end
