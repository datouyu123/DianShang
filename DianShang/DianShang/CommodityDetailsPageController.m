//
//  CommodityDetailsPageController.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/6.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  商品详情页

#import "CommodityDetailsPageController.h"
#import "RDVTabBarController.h"
#import "MJRefresh.h"

#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)
#define NAVIGATIONBAR_H (self.navigationController.navigationBar.frame.size.height)
#define TOOLBAR_H (toolbar.frame.size.height)
#define STATUSBAR_H ([[UIApplication sharedApplication] statusBarFrame].size.height)

@interface CommodityDetailsPageController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIWebViewDelegate>
{
    //动态定义工具栏
    UIToolbar *toolbar;
    UIButton *addToCartButton;
    UIButton *buyButton;
    UIBarButtonItem *addToCartItem;
    UIBarButtonItem *buyItem;
}

@property(strong,nonatomic)UIScrollView *cdpScrollView;
@property(strong,nonatomic)UITableView *cdpTableView;
@property(strong,nonatomic)UIWebView *cdpWebView;

@end

@implementation CommodityDetailsPageController

#pragma mark - Controller Life Cycle
- (void)viewDidLoad
{
    self.title = @"商品详情";
   
    //控件添加到视图上
    /**
     *  设置一个 UIScrollView 作为视图底层，并且设置分页为两页
     *  然后在第一个分页上添加一个 UITableView 并且设置表格能够上提加载（上拉操作即为让视图滚动到下一页）
     *  在第二个分页上添加一个 UIWebView 并且设置能有下拉刷新操作（下拉操作即为让视图滚动到上一页）
     */
    
    [self.view addSubview:self.cdpScrollView];
    [self.cdpScrollView addSubview:self.cdpTableView];
    [self.cdpScrollView addSubview:self.cdpWebView];
    [self.cdpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    //tableview和webview头部不被navigationbar挡住
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    //初始化toolbar
    addToCartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, TOOLBAR_H)];
    //addToCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addToCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    addToCartButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addToCartButton setBackgroundColor:[UIColor redColor]];
    
    //[addToCartButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"addx:%f\naddy:%f",addToCartButton.frame.origin.x,addToCartButton.frame.origin.y);
    NSLog(@"color=%@",addToCartButton.backgroundColor);
    addToCartItem = [[UIBarButtonItem alloc] initWithCustomView:addToCartButton];
    buyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, TOOLBAR_H)];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    buyButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
    buyItem = [[UIBarButtonItem alloc] initWithCustomView:buyButton];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 48.0, self.view.frame.size.width, 48.0)];
    [toolbar setItems:[NSArray arrayWithObjects:spaceItem, spaceItem, addToCartItem, buyItem, nil] animated:YES];
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
    header.lastUpdatedTimeLabel.hidden = YES;
    self.cdpWebView.scrollView.header = header;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //修改navigationbar背景颜色及title颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0],NSForegroundColorAttributeName,nil]];
    //修改navigationbar返回键颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
    //进入商品详情页隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    //设置scrollview下边距
    self.cdpTableView.contentInset = UIEdgeInsetsMake(0, 0, TOOLBAR_H+NAVIGATIONBAR_H+STATUSBAR_H+44, 0);
    self.cdpWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, TOOLBAR_H+NAVIGATIONBAR_H+STATUSBAR_H, 0);
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
    return 50;
}
//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.row];
    return cell;
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

-(UIWebView *)cdpWebView
{
    if (_cdpWebView == nil)
    {
        _cdpWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, IPHONE_H, IPHONE_W, IPHONE_H)];
        _cdpWebView.scrollView.delegate = self;
    }
    return _cdpWebView;
}


#pragma mark - UITableView Delegate

@end
