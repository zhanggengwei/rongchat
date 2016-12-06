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
    arr = [self setDataTest:arr];
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
          
                if(![self.indexArr containsObject:[pinYin substringToIndex:1]])
                {
                     [self.indexArr addObject:[pinYin substringToIndex:1]];
                }
                NSArray * pre_Arr = [self.contactDict objectForKey:[pinYin substringToIndex:1]];
                if(pre_Arr==nil)
                {
                    pre_Arr = [NSArray new];
                }
                pre_Arr=[pre_Arr arrayByAddingObject:baseInfo];
                pre_Arr = [pre_Arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    return [((PPUserBaseInfo *)obj1).user.nickname compare:((PPUserBaseInfo *)obj2).user.nickname];
                    
                    
                }];
                
                [self.contactDict setValue:pre_Arr forKey:[pinYin substringToIndex:1]];
               
                
            }else
            {
                if(![self.indexArr containsObject:[pinYin substringToIndex:1]])
                {
                    [self.indexArr addObject:[pinYin substringToIndex:1]];
                }
                NSArray * pre_Arr = [self.contactDict objectForKey:@"#"];
                if(pre_Arr==nil)
                {
                    pre_Arr = [NSArray new];
                }
                pre_Arr = [pre_Arr arrayByAddingObject:baseInfo];
                pre_Arr = [pre_Arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    return [((PPUserBaseInfo *)obj1).user.nickname compare:((PPUserBaseInfo *)obj2).user.nickname];
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
        
     
    }];

 
    
}

#pragma mark 测试的数据
- (NSArray *)setDataTest:(NSArray *)arr
{
    
    NSString * name = @"赵 钱 孙 李 周 吴 郑 王 冯 陈 褚 卫 蒋 沈 韩 杨 戚 谢 邹 喻   柏 水 窦 章 云 苏 潘 葛 奚 范 彭 郎 富察 费莫 蹇 称 诺 来 多 繁 戊 朴 回 毓 税 荤 靖 绪 愈 硕 牢 买 但 巧 枚 撒 泰 秘 亥 绍 以 壬 森 斋 释 奕 姒 朋 求 羽 用 占 真 穰 翦 闾 漆 贵 代 贯 旁 崇 栋 告 休 褒 谏 锐 皋 闳 在 歧 禾 示 是 委 钊 频 嬴 呼 大 威 昂 律 冒 保 系 抄 定 化 莱 校 么 抗 祢 綦 悟 宏 功 庚 务 敏 捷 拱 兆 丑 丙 畅 苟 随 类 卯 俟 友 答 乙 允 甲 留 尾 佼 玄 乘 裔 延 植 环 矫 赛 昔 侍 度 旷 遇 偶 前 由 咎 塞 敛 受 泷 袭 衅 叔 圣 御 夫 仆 镇 藩 邸 府 掌 首 员 焉 戏 可 智 尔 凭 悉 进 笃 厚 仁 业 肇 资 合 仍 九 衷 哀 刑 俎 仵 圭 夷 徭 蛮 汗 孛 乾 帖 罕 洛 淦 洋 邶 郸 郯 邗 邛 剑 虢 隋 蒿 茆 菅 苌 树 桐 锁 钟 机 盘 铎 斛 玉 线 针 箕 庹 绳 磨 蒉 瓮 弭 刀 疏 牵 浑 恽 势 世 仝 同 蚁 止 戢 睢 冼 种 涂 肖 己 泣 潜 卷 脱 谬 蹉 赧 浮 顿 说 次 错 念 夙 斯 完 丹 表 聊 源 姓 吾 寻 展 出 不 户 闭 才 无 书 学 愚 本 性 雪 霜 烟 寒 少 字 桥 板 斐 独 千 诗 嘉 扬 善 揭 祈 析 赤 紫 青 柔 刚 奇 拜 佛 陀 弥 阿 素 长 僧 隐 仙 隽 宇 祭 酒 淡 塔 琦 闪 始 星 南 天 接 波 碧 速 禚 腾 潮 镜 似 澄 潭 謇 纵 渠 奈 风 春 濯 沐 茂 英 兰 檀 藤 枝 检 生 折 登驹 骑 貊 虎 肥 鹿 雀 野 禽 飞 节 宜 鲜 粟 栗 豆 帛 官 布 衣 藏 宝 钞 银 门 盈 庆 喜 及 普 建 营 巨 望 希 道 载 声 漫 犁 力 贸 勤 革 改 兴 亓 睦 修 信 闽 北 守 坚 勇 汉 练 尉 士 旅 五 令 将 旗 军 行 奉 敬 恭 仪 母 堂 丘 义 礼 慈 孝 理 伦 卿 问 永 辉 位 让 尧 依 犹 介 承 市 所 苑 杞 剧 第 零 谌 招 续 达 忻 六 鄞 战 迟 候 宛 励 粘 萨 邝 覃 辜 初 楼 城 区 局 台 原 考 妫 纳 泉 老 清 德 卑 过 麦 曲 竹 百 福 言 第五 佟 爱 年 笪 谯 哈 墨 南宫 赏 伯 佴 佘 牟 商 西门 东门 左丘 梁丘 琴 后 况 亢 缑 帅 微生 羊舌 海 归 呼延 南门 东郭 百里 钦 鄢 汝 法 闫 楚 晋 谷梁 宰父 夹谷 拓跋 壤驷 乐正 漆雕 公西 巫马 端木 颛孙 子车 督 仉 司寇 亓官 鲜于 锺离 盖 逯 库 郏 逢 阴 薄 厉 稽 闾丘 公良 段干 开 光 操 瑞 眭 泥 运 摩 伟 铁 迮";
    NSArray  * nameArr = [name componentsSeparatedByString:@" "];
    
    for (int i = 0; i <=100; i++)
    {
        PPUserBaseInfo * info = [PPUserBaseInfo  new];
        info.user = [PPUserBase new];
        info.user.nickname = [NSString stringWithFormat:@"%@%@%@",nameArr[arc4random()%nameArr.count],nameArr[arc4random()%nameArr.count],nameArr[arc4random()%nameArr.count]];
        
        arr = [arr arrayByAddingObject:info];
    }
    return arr;
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
        PPUserBaseInfo * info = arr[indexPath.row];
        [cell setLeftIconImageNamed:info.user.portraitUri andRightContentLabel:info.user.nickname];
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
    PPUserBaseInfo * info = arr[indexPath.row];
    
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
