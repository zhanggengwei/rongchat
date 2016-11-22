//
//  PPSelectAreaViewController.m
//  rongchat
//
//  Created by vd on 2016/11/22.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPSelectAreaViewController.h"
#import "PPSelectAreaViewCell.h"
#import "PPSelectAreaTableViewCell.h"
#import "PPLocationManager.h"
@interface PPSelectAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray * array;
@property (strong,nonatomic) PPLocationManager * locationManager;
@property (assign,nonatomic) NSInteger sections;


@end

@implementation PPSelectAreaViewController

+(instancetype)createPPSelectAreaViewController
{
    return [[UIStoryboard storyboardWithName:@"PPSelectArea" bundle:nil]instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [PPLocationManager shareManager];
    self.sections = (self.locationManager.regeoCode?1:0) + 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadData];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionFooterHeight = 0.01;
    
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark private Methods

- (void)loadData
{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"Country_Code" ofType:@"json"];

    NSError * error;
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    self.array = [MTLJSONAdapter modelsOfClass:[PPCountryDef class] fromJSONArray:arr error:&error];
    [self.tableView reloadData];
    
 
}

- (UIView *)createHeaderView:(NSString *)content
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UILabel * contentLabel = [UILabel new];
    [view addSubview:contentLabel];
    contentLabel.text = content;
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).mas_offset(16);
        make.height.mas_equalTo(16);
        make.bottom.mas_equalTo(view.mas_bottom).mas_offset(-5);
        make.width.mas_equalTo(@200);
    }];
    contentLabel.font = [UIFont systemFontOfSize:14];
    
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.sections == 2)
    {
        if(indexPath.section == 0)
        {
            PPSelectAreaViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPSelectAreaViewCell" forIndexPath:indexPath];
            [cell setContent:[NSString stringWithFormat:@"%@ %@",self.locationManager.regeoCode.province,self.locationManager.regeoCode.city]];
            
            return cell;
        }
        PPSelectAreaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPSelectAreaTableViewCell" forIndexPath:indexPath];
        PPCountryDef * country = self.array[indexPath.row];
        [cell setContent:country.country_name_cn];
        
        return cell;
    }
    
    PPSelectAreaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPSelectAreaTableViewCell" forIndexPath:indexPath];
    PPCountryDef * country = self.array[indexPath.row];
    [cell setContent:country.country_name_cn];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    if(self.sections == 2)
    {
        if(section == 0)
        {
            return 1;
        }
        return self.array.count;
    }else
    {
        return self.array.count;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.sections == 2)
    {
        if(section == 0)
        {
            return [self createHeaderView:@"定位到的位置"];
        }
        return [self createHeaderView:@"全部"];
    }
    return [self createHeaderView:@"全部"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


@end
