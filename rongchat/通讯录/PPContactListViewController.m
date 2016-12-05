//
//  PPContactListViewController.m
//  rongchat
//
//  Created by vd on 2016/11/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPContactListViewController.h"
#import "PPContactListCell.h"

@interface PPContactListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * array;
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) NSMutableDictionary * contactArray;
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
    [self.indexArr addObject:UITableViewIndexSearch];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.tableView.sectionIndexColor = [UIColor grayColor];
    
    
    // self.tableView.sectionIndexMinimumDisplayRowCount = 6;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"contacts_add_friend") style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
 
    self.navigationItem.rightBarButtonItem = rightItem;
    self.contactArray = [NSMutableDictionary new];
    
    [[PPTUserInfoEngine shareEngine] addObserver:self forKeyPath:@"contactList" options:NSKeyValueObservingOptionNew context:nil];
    [self loadData];
    
    
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
        PPUserBaseInfo * baseInfo = obj;
        HanyuPinyinOutputFormat * outputFormat = [[HanyuPinyinOutputFormat alloc]init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeUppercase];
        [PinyinHelper toHanyuPinyinStringWithNSString:baseInfo.user.nickname withHanyuPinyinOutputFormat:outputFormat withNSString:@"" outputBlock:^(NSString *pinYin) {
            NSLog(@"pinYin  ===%@",pinYin);
            if([pinYin characterAtIndex:0] >='A'&&[pinYin characterAtIndex:0]<='Z')
            {
                [self.contactArray setValue:baseInfo forKey:[pinYin substringToIndex:1]];
                [self.indexArr addObject:[pinYin substringToIndex:1]];
                
            }else
            {
                NSArray * arr = [self.contactArray objectForKey:@"#"];
                if(arr.count==0||arr==nil)
                {
                    [self.contactArray setValue:baseInfo forKey:@"#"];
                    [self.indexArr addObject:@"#"];
                }else
                {
                    
                }
            }
        }];
        [self.tableView reloadData];
    }];
    
}

#pragma mark 测试的数据
- (void)setDataTest
{
    
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
        NSString * key = self.indexArr[indexPath.section - 1];
        NSArray * arr = [self.contactArray objectForKey:key];
        PPUserBaseInfo * info = arr[indexPath.row];
        [cell setLeftIconImageNamed:@"" andRightContentLabel:info.user.nickname];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 4;
    }
    return self.contactArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.contactArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
