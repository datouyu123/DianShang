//
//  WXSCommodityDetailsPageController.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/6.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  商品详情页
//  NAVIGATIONBAR_H = 44    TOOLBAR_H = 48  STATUSBAR_H = 20

#import "WXSCommodityDetailsPageController.h"
#import "RDVTabBarController.h"
#import "CNPPopupController.h"
#import "MJRefresh.h"
#import "ASScroll.h"
#import "WXSCommodityDetailsPageNameAndPriceCell.h"
#import "WXSCommodityDetailsPageScrollImagesCell.h"
#import "WXSCommodityDetailsPagePopupViewFirstCell.h"
#import "WXSCommodityDetailsPagePopupViewSecondCell.h"
#import "UIimageView+AFNetworking.h"
#import "Post.h"
#import "Good.h"


#define NAVIGATIONBAR_H (self.navigationController.navigationBar.frame.size.height)
#define TOOLBAR_H (48.0)
#define STATUSBAR_H ([[UIApplication sharedApplication] statusBarFrame].size.height)

@interface WXSCommodityDetailsPageController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIWebViewDelegate,CNPPopupControllerDelegate>
{
    //动态定义工具栏
    UINavigationBar *newNavBar;
    UIToolbar *toolbar;
    UIButton *addToCartButton;
    UIButton *buyButton;
    UIBarButtonItem *addToCartItem;
    UIBarButtonItem *buyItem;
}

@property (strong,nonatomic) UIScrollView *cdpScrollView;
@property (strong,nonatomic) UITableView *cdpTableView;
@property (strong,nonatomic) UITableView *popupTableView;
@property (strong,nonatomic) UIWebView *cdpWebView;
@property (nonatomic, strong) CNPPopupController *popupController;
//@property (nonatomic, strong) CNPPopupController *buyController;

@end

@implementation WXSCommodityDetailsPageController

#pragma mark - Controller Life Cycle
- (void)viewDidLoad
{
    //self.title = @"商品详情";
    //防止view被自定义navigationbar挡住
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        // For insetting with a navigation bar
        UIEdgeInsets insets = UIEdgeInsetsMake(64, 0, 0, 0);
        self.cdpScrollView.contentInset = insets;
        self.cdpScrollView.scrollIndicatorInsets = insets;
        self.cdpTableView.contentInset = insets;
        self.cdpTableView.scrollIndicatorInsets = insets;
        self.cdpWebView.scrollView.contentInset = insets;
        self.cdpWebView.scrollView.scrollIndicatorInsets = insets;
    }
    //控件添加到视图上
    /**
     *  设置一个 UIScrollView 作为视图底层，并且设置分页为两页
     *  然后在第一个分页上添加一个 UITableView 并且设置表格能够上提加载（上拉操作即为让视图滚动到下一页）
     *  在第二个分页上添加一个 UIWebView 并且设置能有下拉刷新操作（下拉操作即为让视图滚动到上一页）
     */
    
    [self.view addSubview:self.cdpScrollView];
    [self.cdpScrollView addSubview:self.cdpTableView];
    [self.cdpScrollView addSubview:self.cdpWebView];
    //[self.cdpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    //tableview和webview头部不被navigationbar挡住
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    //初始化toolbar
    addToCartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W/3, TOOLBAR_H)];
    NSLog(@"iphone_w=%f",IPHONE_W);
    //addToCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addToCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    addToCartButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addToCartButton setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0]];
    [addToCartButton addTarget:self action:@selector(showPopupFormSheet:) forControlEvents:UIControlEventTouchUpInside];
    //有利于传参，告诉点击按钮事件是“加入购物车按钮”，以弹出相应popview
    [addToCartButton setTag:100];
    NSLog(@"addx:%f\naddy:%f",addToCartButton.frame.origin.x,addToCartButton.frame.origin.y);
    NSLog(@"color=%@",addToCartButton.backgroundColor);
    addToCartItem = [[UIBarButtonItem alloc] initWithCustomView:addToCartButton];
    buyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W/3, TOOLBAR_H)];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    buyButton.backgroundColor = [UIColor orangeColor];
    [buyButton addTarget:self action:@selector(showPopupFormSheet:) forControlEvents:UIControlEventTouchUpInside];
    //有利于传参，告诉点击按钮事件是“立即购买按钮”，以弹出相应popview
    [buyButton setTag:200];
    buyItem = [[UIBarButtonItem alloc] initWithCustomView:buyButton];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *fixItemFirst = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixItemFirst.width = -10;
    UIBarButtonItem *fixItemSecond = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixItemSecond.width = -20;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 48.0, self.view.frame.size.width, 48.0)];
    [toolbar setItems:[NSArray arrayWithObjects:spaceItem, spaceItem, addToCartItem, fixItemFirst, buyItem, fixItemSecond, nil] animated:YES];
    [toolbar setBarStyle:UIBarStyleBlack];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:toolbar];
    //设置UITableView 上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.cdpScrollView.contentOffset = CGPointMake(0, IPHONE_H);
        } completion:^(BOOL finished) {
            //结束加载
            [self.cdpTableView.footer endRefreshing];
        }];
        
    }];
    // 设置文字
    [footer setTitle:@"上拉查看图文详情" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开查看图文详情" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    self.cdpTableView.footer = footer;
    
    //设置UIWebView 有下拉操作
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉执行对应的操作
        self.cdpScrollView.contentOffset = CGPointMake(0, 0);
        //结束加载
        [self.cdpWebView.scrollView.header endRefreshing];
    }];
    //设置文字
    [header setTitle:@"下拉回到商品详情" forState:MJRefreshStateIdle];
    [header setTitle:@"释放回到商品详情" forState:MJRefreshStatePulling];
    [header setTitle:@"" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.cdpWebView.scrollView.header = header;
    
    //防止tableview多几行
     [self.cdpTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.popupTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    //设置cell.imageView不挡住分隔线
    [self.popupTableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //自定义navigationbar
    [self styleNavBar];
    //使滑动返回手势在自定义的navbar上生效
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    //进入商品详情页隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    //设置scrollview下边距
    self.cdpTableView.contentInset = UIEdgeInsetsMake(64, 0, TOOLBAR_H+44, 0);
    self.cdpWebView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, TOOLBAR_H, 0);
    self.popupTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);;
    //初始化webview
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:self.post.good.goodURL]];
    
    [self.cdpWebView loadRequest:request];
    //
    NSLog(@"N=%f,T=%f,S=%f",NAVIGATIONBAR_H,TOOLBAR_H,STATUSBAR_H);
    //
}

#pragma mark - Custom NavigationBar
- (void)styleNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setBarTintColor:[UIColor whiteColor]];
    UINavigationItem *titleItem = [[UINavigationItem alloc] init];
    titleItem.title = @"商品详情";
    
    // BackButtonBlack is an image we created and added to the app’s asset catalog
    UIImage *backButtonImage = [UIImage imageNamed:@"back_icon"];
    
    // any buttons in a navigation bar are UIBarButtonItems, not just regular UIButtons. backTapped: is the method we’ll call when this button is tapped
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    // the bar button item is actually set on the navigation item, not the navigation bar itself.
    titleItem.leftBarButtonItem = backBarButtonItem;
    
    [newNavBar setItems:@[titleItem]];
    [self.view addSubview:newNavBar];
}


- (void)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PopupView Setting
- (void)showPopupFormSheet:(id)sender {
    if ([sender tag] == 100) {
        [self showPopupWithStyle:CNPPopupStyleActionSheet flag:100];
    }
    else if([sender tag] == 200)
    {
        [self showPopupWithStyle:CNPPopupStyleActionSheet flag:200];
    }
}

// flag: 判断点击的是“加入购物车”按钮还是“立即购买”按钮
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle flag:(NSInteger)i
{
    
    CNPPopupButton *okButton = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, 60)];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    //button.layer.cornerRadius = 4;
//    SecondViewController *svc = [[SecondViewController alloc] init];
//  svc.view.backgroundColor = [UIColor lightGrayColor];
    okButton.selectionHandler = ^(CNPPopupButton *button){
        
        [self.popupController dismissPopupControllerAnimated:YES];
        
//        
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [self.navigationController pushViewController:svc animated:YES];
////        });
//        
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[self.popupTableView, okButton]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll contentOffset=\n %@",scrollView.class);
    //判断哪个子视图在屏幕上
    CGRect thePosition = self.cdpTableView.frame;
    CGRect container = CGRectMake(self.cdpScrollView.contentOffset.x, self.cdpScrollView.contentOffset.y, self.cdpScrollView.frame.size.width, self.cdpScrollView.frame.size.height);
    if (CGRectIntersectsRect(thePosition, container)) {
        self.cdpScrollView.scrollsToTop = NO;
        self.cdpTableView.scrollsToTop = YES;
        self.cdpWebView.scrollView.scrollsToTop = NO;
        NSLog(@"scrollViewDidScroll contentOffset=1\n");
    }
    else
    {
        self.cdpScrollView.scrollsToTop = NO;
        self.cdpTableView.scrollsToTop = NO;
        self.cdpWebView.scrollView.scrollsToTop = YES;
        NSLog(@"scrollViewDidScroll contentOffset=2\n");

    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating contentOffset=\n");
    //判断哪个子视图在屏幕上
    CGRect thePosition = self.cdpTableView.frame;
    CGRect container = CGRectMake(self.cdpScrollView.contentOffset.x, self.cdpScrollView.contentOffset.y, self.cdpScrollView.frame.size.width, self.cdpScrollView.frame.size.height);
    if (CGRectIntersectsRect(thePosition, container)) {
        self.cdpScrollView.scrollsToTop = NO;
        self.cdpTableView.scrollsToTop = YES;
        self.cdpWebView.scrollView.scrollsToTop = NO;
    }
    else
    {
        self.cdpScrollView.scrollsToTop = NO;
        self.cdpTableView.scrollsToTop = NO;
        self.cdpWebView.scrollView.scrollsToTop = YES;
    }

}

#pragma mark - UITableView DataSource
//返回表格分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.cdpTableView]) {
        if (section == 0) {
            return 1;
        }
        return 1;
    }
    else if([tableView isEqual:self.popupTableView])
        return 2;
    else
        return 0;
}
//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.cdpTableView]) {
        static NSString *kCellIdentifier1 = @"ScrollPicCell";
        static NSString *kCellIdentifier2 = @"BriefIntroCell";
        
        if(indexPath.section == 0)
        {
            
            WXSCommodityDetailsPageScrollImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier1];
            
            if (cell == nil) {
                cell = [[WXSCommodityDetailsPageScrollImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier1];
            }
            else
            {
                //防止字体有重绘阴影
                while ([cell.contentView.subviews lastObject] != nil)
                {
                    [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            [cell setGoods:self.post];
            
            return cell;
        }
        else
        {
            WXSCommodityDetailsPageNameAndPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier2];
            if (cell == nil) {
                cell = [[WXSCommodityDetailsPageNameAndPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier2];
            }
            else
            {
                //防止字体有重绘阴影
                while ([cell.contentView.subviews lastObject] != nil)
                {
                    [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            [cell setGoods:self.post];
            return cell;
            
        }

    }
    else if([tableView isEqual:self.popupTableView])
    {
        static NSString *kCellIdentifier3 = @"PicAndPriceCell";
        static NSString *kCellIdentifier4 = @"StepperCell";
        if(indexPath.row == 0)
        {
            WXSCommodityDetailsPagePopupViewFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier3];
            
            if (cell == nil) {
                cell = [[WXSCommodityDetailsPagePopupViewFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier3];
            }
            else
            {
                //防止字体有重绘阴影
                while ([cell.contentView.subviews lastObject] != nil)
                {
                    [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            cell.closeButton.selectionHandler = ^(CNPPopupButton *button){
                
                [self.popupController dismissPopupControllerAnimated:YES];
            };
            [cell setGoods:self.post];
            return cell;
        }
        else
        {
            WXSCommodityDetailsPagePopupViewSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier4];
            
            if (cell == nil) {
                cell = [[WXSCommodityDetailsPagePopupViewSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier4];
            }
            else
            {
                //防止字体有重绘阴影
                while ([cell.contentView.subviews lastObject] != nil)
                {
                    [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
        
            return cell;
        }
    }
    else
        return nil;
}
//返回tableview分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.cdpTableView]) {
        return 2;
    }
    else if([tableView isEqual:self.popupTableView])
        return 1;
    else
        return 0;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.cdpTableView]) {
        if (indexPath.section == 0) {
            return IPHONE_W;
        }
        else if (indexPath.section == 1)
            return 100;
        
        return 0;
    }
    else if([tableView isEqual:self.popupTableView])
    {
        if (indexPath.row == 0) {
            return 100;
        }
        else if (indexPath.row == 1)
            return 64;
        return 0;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.cdpTableView]) {
        if (section==1)
        {
            return 10;
        }
        return 0.1;
    }
    else if([tableView isEqual:self.popupTableView])
    {
        return 0.1;
    }
    else
        return 0;
}

#pragma mark - get

-(UIScrollView *)cdpScrollView
{
    if (_cdpScrollView == nil)
    {
        _cdpScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H)];
        _cdpScrollView.contentSize = CGSizeMake(IPHONE_W, IPHONE_H * 2);
        //设置分页效果
        _cdpScrollView.pagingEnabled = YES;
        //禁用滚动
        _cdpScrollView.scrollEnabled = NO;
        
        _cdpScrollView.delegate = self;
    }
    return _cdpScrollView;
}

-(UITableView *)cdpTableView
{
    if (_cdpTableView == nil)
    {
        _cdpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H)
                                                    style:UITableViewStylePlain];
        _cdpTableView.delegate = self;
        _cdpTableView.dataSource = self;
    }
    return _cdpTableView;
}

-(UITableView *)popupTableView
{
    if (_popupTableView == nil)
    {
        _popupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, 200)
                                                    style:UITableViewStylePlain];
        _popupTableView.delegate = self;
        _popupTableView.dataSource = self;
    }
    return _popupTableView;
}

-(UIWebView *)cdpWebView
{
    if (_cdpWebView == nil)
    {
        _cdpWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, IPHONE_H, IPHONE_W, IPHONE_H)];
        _cdpWebView.scrollView.delegate = self;
    }
    return _cdpWebView;
}

@end
