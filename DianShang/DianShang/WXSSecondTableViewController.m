//
//  WXSSecondTableViewController.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/24.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSSecondTableViewController.h"
#import "WXSCommodityDetailsPageController.h"
#import "RDVTabBarController.h"
#import "FMDBHelper.h"
#import "Post.h"
#import "Good.h"
#import "WXSSecondTableViewCell.h"

@interface WXSSecondTableViewController ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>
{
    //定义商品详情页控制器
    WXSCommodityDetailsPageController *cdpController;
}

@property (readwrite, nonatomic, strong) NSMutableArray *goods;
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation WXSSecondTableViewController

#pragma mark - Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //防止view被自定义navigationbar挡住
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        // For insetting with a navigation bar
        UIEdgeInsets insets = UIEdgeInsetsMake(NAVIGATIONBAR_H, 0, 0, 0);
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    //初始化显示数组
    self.goods = [[NSMutableArray alloc] init];
    //tableview添加到控制器视图
    [self.view addSubview:self.tableView];
    //防止tableview多几行
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //设置cell.imageView不挡住分隔线
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableView.allowsMultipleSelectionDuringEditing=YES;
    //[self.tableView setEditing:YES animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //自定义navigationbar
    [self styleNavBar];
    //设置scrollview下边距
    if (self.controllerType != 100) {
        self.tableView.contentInset = UIEdgeInsetsMake(NAVIGATIONBAR_H, 0, RDVTABBAR_H, 0);
    }
    //[[FMDBHelper sharedFMDBHelper] emptyDatabaseByName:@"SHOPPING_CART_TABLE"];
    self.goods = [NSMutableArray arrayWithArray:[[FMDBHelper sharedFMDBHelper] selectFromSHOPPING_CART_TABLE]];
    //判断购物车是否为空
    if (!self.goods.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, 100)];
        label.text = @"主人快去挑些宝贝吧";
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_empty"]];
        image.frame = CGRectMake(0, 0, IPHONE_W, IPHONE_H);
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H - NAVIGATIONBAR_H - RDVTABBAR_H)];
        [self.tableView.tableHeaderView addSubview:label];
        [self.tableView.tableHeaderView addSubview:image];
        
        [label sizeToFit];
        label.center = CGPointMake(self.tableView.tableHeaderView.bounds.size.width/2,self.tableView.tableHeaderView.bounds.size.height/2 + 30);
        [image sizeToFit];
        image.center = CGPointMake(self.tableView.tableHeaderView.bounds.size.width/2,self.tableView.tableHeaderView.bounds.size.height/2 - 70);
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //如果是点击ta进入购物车页显示tabbar
    if (self.controllerType == 100) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
    else{
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    }
    
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
    titleItem.title = @"购物车";
    [newNavBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    //搜索按钮
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllInCart)];
    right.tintColor = [UIColor grayColor];
    titleItem.rightBarButtonItem=right;
    
    if (self.controllerType == 100) {
        UIImage *backButtonImage = [UIImage imageNamed:@"back_icon"];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
        backBarButtonItem.tintColor = [UIColor grayColor];
        titleItem.leftBarButtonItem = backBarButtonItem;
    }
    
    [newNavBar setItems:@[titleItem]];
    // 4. add the nav bar to the main view
    [self.view addSubview:newNavBar];
}

- (void)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//清空购物车
- (void)deleteAllInCart
{
    [[FMDBHelper sharedFMDBHelper] emptyDatabaseByName:@"SHOPPING_CART_TABLE"];
    self.goods = [NSMutableArray arrayWithArray:[[FMDBHelper sharedFMDBHelper] selectFromSHOPPING_CART_TABLE]];
    //判断购物车是否为空
    if (!self.goods.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, 100)];
        label.text = @"主人快去挑些宝贝吧";
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_empty"]];
        image.frame = CGRectMake(0, 0, IPHONE_W, IPHONE_H);
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H - NAVIGATIONBAR_H - RDVTABBAR_H)];
        [self.tableView.tableHeaderView addSubview:label];
        [self.tableView.tableHeaderView addSubview:image];
        
        [label sizeToFit];
        label.center = CGPointMake(self.tableView.tableHeaderView.bounds.size.width/2,self.tableView.tableHeaderView.bounds.size.height/2 + 30);
        [image sizeToFit];
        image.center = CGPointMake(self.tableView.tableHeaderView.bounds.size.width/2,self.tableView.tableHeaderView.bounds.size.height/2 - 70);
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.goods count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WXSSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[WXSSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;

    }
    //加上下面这段cell的label会再第二次出现以后消失
//    else
//    {
//        //防止字体有重绘阴影
//        while ([cell.contentView.subviews lastObject] != nil)
//        {
//            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//            NSLog(@"%@",[cell.contentView.subviews lastObject]);
//        }
//    }
    Post *post = [self.goods objectAtIndex:indexPath.row];
    [cell setGoods:post];
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//单元格选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cdpController = [[WXSCommodityDetailsPageController alloc] init];
    //进入商品详情页隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    //设置cdpController.view背景色为浅灰色，原来默认为透明，切换时视觉上会出现卡顿
    cdpController.view.backgroundColor = [UIColor lightGrayColor];
    //将post实体数据传入详情页
    NSLog(@"%ld",(long)indexPath.item);
    
    cdpController.post = [self.goods objectAtIndex:indexPath.row];
    //
    NSLog(@"!!%@",cdpController.post.good.goodTitle);
    [self.navigationController pushViewController:cdpController animated:YES];
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
//        case 0:
//        {
//            NSLog(@"More button was pressed");
//            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//            [alertTest show];
//            
//            [cell hideUtilityButtonsAnimated:YES];
//            break;
//        }
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            Post *post = [self.goods objectAtIndex:cellIndexPath.row];
            [self.goods removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            //判断购物车是否为空
            if (!self.goods.count) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, 100)];
                label.text = @"主人快去挑些宝贝吧";
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_empty"]];
                image.frame = CGRectMake(0, 0, IPHONE_W, IPHONE_H);
                self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H - NAVIGATIONBAR_H - RDVTABBAR_H)];
                [self.tableView.tableHeaderView addSubview:label];
                [self.tableView.tableHeaderView addSubview:image];
                
                [label sizeToFit];
                label.center = CGPointMake(self.tableView.tableHeaderView.bounds.size.width/2,self.tableView.tableHeaderView.bounds.size.height/2 + 30);
                [image sizeToFit];
                image.center = CGPointMake(self.tableView.tableHeaderView.bounds.size.width/2,self.tableView.tableHeaderView.bounds.size.height/2 - 70);            }
            else
            {
                self.tableView.tableHeaderView = nil;
            }
            //本地数据库删除该条记录
            [[FMDBHelper sharedFMDBHelper] deleteFromSHOPPING_CART_TABLE:post.postID];
            break;
        }
        default:
            break;
    }
}

#pragma mark - get

-(UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H)
                                                    style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
