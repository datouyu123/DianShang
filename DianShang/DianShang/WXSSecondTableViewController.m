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

@interface WXSSecondTableViewController ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, WXSSecondTableViewCellDelegate>
{
    //定义商品详情页控制器
    WXSCommodityDetailsPageController *cdpController;
    //工具栏
    UIToolbar *toolbar;
    //结算
    UIButton *settleAccountButton;
    UIBarButtonItem *settleAccountItem;
    //全选
    UIButton *selectAllButton;
    UIBarButtonItem *selectAllItem;
    UILabel *selectAllLabel;
    UIBarButtonItem *selectAllLabelItem;
    //总计
    UILabel *totalLabel;
    UIBarButtonItem *totalLabelItem;
    //总价
    float allPrice;
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
    //初始化toolbar
    settleAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W/3, TOOLBAR_H)];
    [settleAccountButton setTitle:@"买单" forState:UIControlStateNormal];
    settleAccountButton.titleLabel.font = [UIFont systemFontOfSize:16];
    settleAccountButton.backgroundColor = [UIColor orangeColor];
    [settleAccountButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    settleAccountItem = [[UIBarButtonItem alloc] initWithCustomView:settleAccountButton];
    selectAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, TOOLBAR_H)];
    selectAllLabel.text = @"全选";
    selectAllLabel.font = [UIFont boldSystemFontOfSize:14];
    selectAllLabel.textColor = [UIColor whiteColor];
    selectAllLabelItem = [[UIBarButtonItem alloc] initWithCustomView:selectAllLabel];
    selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [selectAllButton setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [selectAllButton setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [selectAllButton addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    selectAllItem = [[UIBarButtonItem alloc] initWithCustomView:selectAllButton];
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W/3, TOOLBAR_H)];
    totalLabel.text = @"总计:¥0.00";
    totalLabel.font = [UIFont boldSystemFontOfSize:14.0];
    totalLabel.textColor = [UIColor whiteColor];
    totalLabelItem = [[UIBarButtonItem alloc] initWithCustomView:totalLabel];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *fixItemSecond = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixItemSecond.width = -20;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, IPHONE_H - TOOLBAR_H, IPHONE_W, TOOLBAR_H)];
    [toolbar setItems:[NSArray arrayWithObjects:selectAllItem, selectAllLabelItem, totalLabelItem, spaceItem, settleAccountItem, fixItemSecond, nil] animated:YES];

    [toolbar setBarStyle:UIBarStyleBlack];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:toolbar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //自定义navigationbar
    [self styleNavBar];
    //设置scrollview下边距
    if (self.controllerType != 100) {
        self.tableView.contentInset = UIEdgeInsetsMake(NAVIGATIONBAR_H, 0, RDVTABBAR_H + TOOLBAR_H, 0);
    }
    else{
        self.tableView.contentInset = UIEdgeInsetsMake(NAVIGATIONBAR_H, 0, TOOLBAR_H, 0);
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
        //隐藏toolbar
        toolbar.hidden = YES;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
        //显示toolbar
        toolbar.hidden = NO;
        //计算总价
        [self totalPrice];
        //判断全选按钮状态
        for (int i=0; i<self.goods.count; i++)
        {
            Post *item = [self.goods objectAtIndex:i];
            if ([item.cartSelectedState isEqualToString:@"0"]) {
                selectAllButton.selected = NO;
                break;
            }
            if (i == self.goods.count - 1) {
                selectAllButton.selected = YES;
            }
        }
        
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
        //隐藏toolbar
        toolbar.hidden = YES;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
        //显示toolbar
        toolbar.hidden = NO;
        //判断全选按钮状态
        for (int i=0; i<self.goods.count; i++)
        {
            Post *item = [self.goods objectAtIndex:i];
            if ([item.cartSelectedState isEqualToString:@"0"]) {
                selectAllButton.selected = NO;
                break;
            }
            if (i == self.goods.count - 1) {
                selectAllButton.selected = YES;
            }
        }

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
        cell.wxsdelegate = self;

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

#pragma mark - 全选按钮事件
/**
 *  全选按钮事件
 *
 *  @param sender 全选按钮
 */
-(void)selectBtnClick:(UIButton *)sender
{
    //判断是否选中，是改成否，否改成是，改变图片状态
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
 
    //改变单元格选中状态
    for (int i=0; i<self.goods.count; i++)
    {
        Post *item = [self.goods objectAtIndex:i];
        if (button.selected) {
            item.cartSelectedState = @"1";
        }
        else
        {
            item.cartSelectedState = @"0";
        }
    }
    //计算总价
    [self totalPrice];
    //刷新表格
    [self.tableView reloadData];
    //更新本地数据库
    if (button.selected) {
        [[FMDBHelper sharedFMDBHelper] updateSHOPPING_CART_TABLESetCartSelectedState:@"1"];
    }
    else
        [[FMDBHelper sharedFMDBHelper] updateSHOPPING_CART_TABLESetCartSelectedState:@"0"];
}

#pragma mark - 计算总价
-(void)totalPrice
{
    //遍历整个数据源，然后判断如果是选中的商品，就计算总价（单价 * 商品数量）
    for ( int i =0; i<self.goods.count; i++)
    {
        Post *item = [self.goods objectAtIndex:i];
        if ([item.cartSelectedState isEqualToString:@"1"])
        {
            allPrice = allPrice + [item.addToCartNum intValue] * [item.good.goodPrice floatValue];
        }
    }
    
    //给总价文本赋值
    totalLabel.text = [NSString stringWithFormat:@"总计:¥%.2f",allPrice];
    NSLog(@"%f",allPrice);
    
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    allPrice = 0.0;
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
                image.center = CGPointMake(self.tableView.tableHeaderView.bounds.size.width/2,self.tableView.tableHeaderView.bounds.size.height/2 - 70);
                //隐藏toolbar
                toolbar.hidden = YES;
            }
            else
            {
                self.tableView.tableHeaderView = nil;
                //显示toolbar
                toolbar.hidden = NO;
                //判断全选按钮状态
                for (int i=0; i<self.goods.count; i++)
                {
                    Post *item = [self.goods objectAtIndex:i];
                    if ([item.cartSelectedState isEqualToString:@"0"]) {
                        selectAllButton.selected = NO;
                        break;
                    }
                    if (i == self.goods.count - 1) {
                        selectAllButton.selected = YES;
                    }
                }

            }
            //本地数据库删除该条记录
            [[FMDBHelper sharedFMDBHelper] deleteFromSHOPPING_CART_TABLE:post.postID];
            //[self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

#pragma mark - WXSSecondTableViewCellDelegate(radiobutton代理)

//实现radiobutton点击代理事件
-(void)radioBtnClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    Post *item = self.goods[index.row];
    if ([item.cartSelectedState isEqualToString:@"1"]) {
        item.cartSelectedState = @"0";
    }
    else{
        item.cartSelectedState = @"1";
    }
    //判断全选按钮状态
    for (int i=0; i<self.goods.count; i++)
    {
        Post *item = [self.goods objectAtIndex:i];
        if ([item.cartSelectedState isEqualToString:@"0"]) {
            selectAllButton.selected = NO;
            break;
        }
        if (i == self.goods.count - 1) {
            selectAllButton.selected = YES;
        }
    }
    
    //刷新
    [self.tableView reloadData];
    //计算总价
    [self totalPrice];
    //修改本地数据库
    [[FMDBHelper sharedFMDBHelper] updateSHOPPING_CART_TABLESetCartSelectedState:item.postID cartSelectedState:item.cartSelectedState];
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
