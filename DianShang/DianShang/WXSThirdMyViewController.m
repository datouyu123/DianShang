//
//  WXSThirdMyViewController.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/31.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSThirdMyViewController.h"
#import "WXSThirdMySetupController.h"
#import "RDVTabBarController.h"
#import "WXSThirdMyAvatarAndNameTableViewCell.h"
#import "PersonalMessage.h"
#import "deliveryAddress.h"
#import "MJExtension.h"
#import "Good.h"

@interface WXSThirdMyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation WXSThirdMyViewController

#pragma mark - Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化tableView
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor= CONTROLLER_BG_COLOR;
    [self.view addSubview:self.tableView];
    //防止view被自定义navigationbar挡住
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        // For insetting with a navigation bar
        UIEdgeInsets insets = UIEdgeInsetsMake(NAVIGATIONBAR_H, 0, 0, 0);
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
////    //防止tableview多几行
////    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
//    //设置tableview背景色
//    [self.tableView setBackgroundColor:CONTROLLER_BG_COLOR];
    
    [self test];
}

- (void) test
{
    [PersonalMessage setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"addrs" : @"deliveryAddress",
                 
                 };
    }];
    //1.定义一个字典
    NSDictionary *dict = @{
                           @"userName" : @"391426555@qq.com",
                           @"password" : @"888888",
                           @"nickName" : @"superman",
                           @"sex" : @(Male),
                           @"birthDate" : @"1993-06-25",
                           @"addrs" : @[
                                   @{
                                       @"name" : @"好帅",
                                       
                                       @"phoneNO" : @"18106989110",
                                       
                                       @"area" : @"北京市海淀区",
                                       @"address" : @"4-1"
                                       },
                                   
                                   @{
                                       @"name" : @"张玮",
                                       
                                       @"phoneNO" : @"13398910422",
                                       
                                       @"area" : @"海南省海口市龙华区",
                                       @"address" : @"5-1"
                                       }
                                   
                                   ]
                           };
    PersonalMessage *personal = [PersonalMessage objectWithKeyValues:dict];
    //存档
    [PersonalMessage save:personal];
    
//    NSString * file = [NSHomeDirectory() stringByAppendingPathComponent:@"personal"];
//    NSLog(@"%@",file);
//    // 归档
//    [NSKeyedArchiver archiveRootObject:personal toFile:file];
    // 解档
    PersonalMessage *p = [PersonalMessage defaultPersonal];
    
    //PersonalMessage *p = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    NSLog(@"username = %@, password = %@, nickName = %@",p.userName, p.password, p.nickName);
    for (deliveryAddress *d in p.addrs) {
        NSLog(@"aadress name = %@, phoneNO = %@, area = %@, address = %@", d.name, d.phoneNO, d.area, d.address);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //自定义navigationbar
    [self styleNavBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom navigationbar
- (void)styleNavBar {
    // 1. hide the existing nav bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // 2. create a new nav bar and style it
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), NAVIGATIONBAR_H)];
    //[newNavBar setBarTintColor:[UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0]];
    
    // 3. add a new navigation item w/title to the new nav bar
    UINavigationItem *titleItem = [[UINavigationItem alloc] init];
    titleItem.title = @"我的";
    [newNavBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    //设置按钮
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"设置  " style:UIBarButtonItemStylePlain target:self action:@selector(toSetup)];
    right.tintColor = [UIColor grayColor];
    titleItem.rightBarButtonItem=right;
    
    
    [newNavBar setItems:@[titleItem]];
    // 4. add the nav bar to the main view
    [self.view addSubview:newNavBar];
}

- (void)toSetup
{
    WXSThirdMySetupController *msController = [[WXSThirdMySetupController alloc] init];
    //进入商品详情页隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    //设置cdpController.view背景色为浅灰色，原来默认为透明，切换时视觉上会出现卡顿
    msController.view.backgroundColor = [UIColor lightGrayColor];

    [self.navigationController pushViewController:msController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
        return 2;
    return  0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WXSThirdMyAvatarAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier1"];
        if (cell == nil) {
            cell = [[WXSThirdMyAvatarAndNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier1"];
        }
        PersonalMessage *p = [PersonalMessage defaultPersonal];
        [cell setPerson:p];
        return cell;
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier2"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier2"];
            }
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, (50-16)/2, 105, 16)];
            label.backgroundColor=[UIColor clearColor];
            label.textAlignment=0;
            label.text=@"我的订单";
            [cell.contentView addSubview:label];
            
            UILabel *myLabel=[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_W-22-80, (50-16)/2, 80, 16)];
            myLabel.backgroundColor=[UIColor clearColor];
            myLabel.font = [UIFont systemFontOfSize:12.0f];
            myLabel.textColor = [UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0];
            myLabel.textAlignment=0;
            myLabel.text=@"查看所有订单";
            [cell.contentView addSubview:myLabel];

            //右侧辅助箭头
            UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_W-22, (50-22)/2, 12, 22)];
            arrow.image=[UIImage imageNamed:@"enter_icon"];
            [cell.contentView addSubview:arrow];
            return cell;
        }
        else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier3"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier3"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            float interval = (IPHONE_W - 35 * 4 -30 * 2)*1.0/3.0;
            NSLog(@"interval=%f",interval);
            //待付款按钮
            UIButton *waitToPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [waitToPayButton setFrame:CGRectMake(30.f, 10.f, 35.f, 35.f)]; // SET the values for your wishes
            //  [_button setCenter:CGPointMake(128.f, 128.f)]; // SET the values for your wishes
            //让文字可以超出bounds范围
            [waitToPayButton setClipsToBounds:false];
            [waitToPayButton setBackgroundImage:[UIImage imageNamed:@"wait_to_pay"] forState:UIControlStateNormal]; // SET the image name for your wishes
            [waitToPayButton setTitle:@"待付款" forState:UIControlStateNormal];
            [waitToPayButton.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
            [waitToPayButton setTitleColor:[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0] forState:UIControlStateNormal]; // SET the colour for your wishes
            [waitToPayButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -45.f, 0.f)]; // SET the values for your wishes
            [waitToPayButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside]; // you can ADD the action to the button as well like
            [cell.contentView addSubview:waitToPayButton];
            
            //待收货按钮
            UIButton *waitTodeliveryButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [waitTodeliveryButton setFrame:CGRectMake(30.0+35.0+interval, 10.f, 35.f, 35.f)]; // SET the values for your wishes
            // [_button setCenter:CGPointMake(128.f, 128.f)]; // SET the values for your wishes
            //让文字可以超出bounds范围
            [waitTodeliveryButton setClipsToBounds:false];
            [waitTodeliveryButton setBackgroundImage:[UIImage imageNamed:@"wait_to_delivery"] forState:UIControlStateNormal]; // SET the image name for your wishes
            [waitTodeliveryButton setTitle:@"待收货" forState:UIControlStateNormal];
            [waitTodeliveryButton.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
            [waitTodeliveryButton setTitleColor:[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0] forState:UIControlStateNormal]; // SET the colour for your wishes
            [waitTodeliveryButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -45.f, 0.f)]; // SET the values for your wishes
            [waitTodeliveryButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside]; // you can ADD the action to the button as well like
            [cell.contentView addSubview:waitTodeliveryButton];
            //待评价按钮
            UIButton *waitToEvaluateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [waitToEvaluateButton setFrame:CGRectMake(30.0+35.0+interval+35.0+interval, 10.f, 35.f, 35.f)]; // SET the values for your wishes
            // [_button setCenter:CGPointMake(128.f, 128.f)]; // SET the values for your wishes
            //让文字可以超出bounds范围
            [waitToEvaluateButton setClipsToBounds:false];
            [waitToEvaluateButton setBackgroundImage:[UIImage imageNamed:@"wait_to_evaluate"] forState:UIControlStateNormal]; // SET the image name for your wishes
            [waitToEvaluateButton setTitle:@"待评价" forState:UIControlStateNormal];
            [waitToEvaluateButton.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
            [waitToEvaluateButton setTitleColor:[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0] forState:UIControlStateNormal]; // SET the colour for your wishes
            [waitToEvaluateButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -45.f, 0.f)]; // SET the values for your wishes
            [waitToEvaluateButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside]; // you can ADD the action to the button as well like
            [cell.contentView addSubview:waitToEvaluateButton];
            //待退货按钮
            UIButton *waitToReturnButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [waitToReturnButton setFrame:CGRectMake(IPHONE_W-30-35, 10.f, 35.f, 35.f)]; // SET the values for your wishes
            // [_button setCenter:CGPointMake(128.f, 128.f)]; // SET the values for your wishes
            //让文字可以超出bounds范围
            [waitToReturnButton setClipsToBounds:false];
            [waitToReturnButton setBackgroundImage:[UIImage imageNamed:@"wait_to_return"] forState:UIControlStateNormal]; // SET the image name for your wishes
            [waitToReturnButton setTitle:@"待退货" forState:UIControlStateNormal];
            [waitToReturnButton.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
            [waitToReturnButton setTitleColor:[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0] forState:UIControlStateNormal]; // SET the colour for your wishes
            [waitToReturnButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -45.f, 0.f)]; // SET the values for your wishes
            [waitToReturnButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside]; // you can ADD the action to the button as well like
            [cell.contentView addSubview:waitToReturnButton];
            
            return cell;
        }
        
    }
    
    return nil;
    
    
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 80;
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 50;
        }
        return 68;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - get

//-(UITableView *)tableView
//{
//    if (_tableView == nil)
//    {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H)
//                                                 style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}

@end
