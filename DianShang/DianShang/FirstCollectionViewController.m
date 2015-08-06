//
//  FirstCollectionViewController.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/12.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "FirstCollectionViewController.h"
#import "CommodityDetailsPageController.h"
#import "RDVTabBarController.h"
#import "ASScroll.h"
#import "MainButtonCollectionViewCell.h"
#import "MainGoodsListCollectionViewCell.h"
#import "MainButtonbgView.h"
#import "MainButtonCVLayoutAttributes.h"
#import "MainHeaderView.h"
#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"
#import "FMDBHelper.h"
#import "Post.h"
#import "UIAlertView+AFNetworking.h"

static const CGFloat MJDuration = 2.0;

@interface FirstCollectionViewController ()
{
    //定义搜索按钮
    UIButton *searchButton;
    //定义扫一扫按钮
    UIButton *saoButton;

}
/*!
 用于添加AFNetworking
 */
@property (readwrite, nonatomic, strong) NSArray *posts;
@property (readwrite, nonatomic, strong) NSArray *postsLun;

@end

@implementation FirstCollectionViewController

static NSString * const reuseIdentifier1 = @"adCell";
static NSString * const reuseIdentifier2 = @"btnCell";
static NSString * const reuseIdentifier3 = @"contentCell";
static NSString * const reuseIdentifier4 = @"headerView";
//static NSString * const reuseIdentifier5 = @"headerView1";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier1];
    [self.collectionView registerClass:[MainButtonCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier2];
    [self.collectionView registerClass:[MainGoodsListCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier3];
    [self.collectionView registerClass:[MainHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier4];
    //[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier5];
    
    // Do any additional setup after loading the view.
    //背景颜色
    //self.collectionView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    //搜索按钮
    searchButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 100, 25, 25)];
    [searchButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem=right;
    
    //扫一扫按钮
    saoButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 100, 25, 25)];
    [saoButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [saoButton setImage:[UIImage imageNamed:@"sao.png"] forState:UIControlStateNormal];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:saoButton];
    self.navigationItem.leftBarButtonItem=left;
    
    //加载本地数据
    //[self loadLocalData];
    
    //添加刷新
    [self setupRefresh];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //修改navigationbar背景颜色及title颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    //进入商品详情页显示tabbar
    [[self rdv_tabBarController] setTabBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 加载本地数据
- (void)loadLocalData
{
    [[FMDBHelper sharedFMDBHelper] emptyDatabaseByName:@"GOODS_TABLE"];
    
    NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:50];
    
    for (int i = 0; i < 10; ++i) {
        
        Post *post;
        
        if (i%2) {
            
            post = [[Post alloc] initWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",(unsigned long)i ],@"tid", [NSString stringWithFormat:@"%@ %d",@"测试标题测试标题", i] ,@"title",@"http://120.24.168.8/iosapi/pic.jpg",@"coverimg",@"http://next17.me",@"url",@"item",@"type", nil] ];
            
        }
        else{
            
            post = [[Post alloc] initWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",(unsigned long)i ],@"tid", [NSString stringWithFormat:@"%@ %d",@"测试标题测试标题", i] ,@"title",@"http://120.24.168.8/iosapi/pic.jpg",@"coverimg",@"http://next17.me",@"url",@"item",@"type", nil] ];
        }
        [mutablePosts addObject:post];
    }
    [[FMDBHelper sharedFMDBHelper] insertIntoGOODS_TABLEWithArray:mutablePosts];
    
    
    
    //[[FMDBHelper sharedFMDBHelper] selectFromGOODS_TABLE:@"\'item\'"];
    
    self.posts =  [NSArray arrayWithArray:[[FMDBHelper sharedFMDBHelper] selectFromGOODS_TABLE:@"\'item\'"]];
    
    [self.collectionView reloadData];

}

#pragma mark UICollectionView 上下拉刷新
- (void)setupRefresh
{
    // 下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.collectionView.header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.collectionView.header beginRefreshing];
    /*self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0)), dispatch_get_main_queue(), ^{
            
            
            // 结束刷新
            [self.collectionView.header endRefreshing];
        });
     
        
    }];*/
    
    // 上拉刷新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            //[self.tableView reloadData];
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.collectionView.footer endRefreshing];
        });

    }];
}


#pragma mark 下拉刷新数据
- (void)loadNewData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"xiala" forKey:@"loadType"];
    /**
     *  商品列表接口
     *  地址:/e­commerce.php?0=itemid&1=list&token=
     *  方式:get 参数:itemid是一个商品的唯一识别码,uid(用户登录时需要,用于显示是否收藏)tag(标 签),参数为产品标签,type(1,2)
     *  (1表示下拉刷新,2表示上拉加载更多),sid(请求数据的 起始id)
     */
    [userDefaults setObject:@"0=itemid&1=list&tag=fruit&type=1&sid=0" forKey:@"loadAPI"];
    NSLog(@"Defaults: %@", userDefaults);
    [self reload:nil];
        
    // 拿到当前的下拉刷新控件，结束刷新状态
    //[self.collectionView.header endRefreshing];
    
}

#pragma mark -AFNetworkingPart

- (void)reload:(__unused id)sender
{
    NSLog(@"\n开始调用RELOAD\n");
    
    NSURLSessionTask *task = [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            
            NSLog(@"\n开始回调\n");
            
            NSLog(@"\n开始赋值给self.posts\n");
            
            self.posts = posts;
            //self.posts = [NSArray arrayWithArray:[[FMDBHelper sharedFMDBHelper] selectFromGOODS_TABLE:@"\'item\'"]];
            
            //更新轮播图的数据postsLun
            //            self.postsLun = [NSArray arrayWithArray:[[FMDBHelper sharedFMDBHelper] selectFromPOST_TABLE:@"\'最新\'" :@"\'lun\'"]];
            
            NSLog(@"\n开始POST LUN赋值\n");
            //self.postsLun = [NSArray arrayWithArray:[[FMDBHelper sharedFMDBHelper] selectFromPOST_TABLE:@"\'最新\'" :@"\'lun\'"]];
            
            NSLog(@"\n结束赋值\n");
            
            if ([ [[NSUserDefaults standardUserDefaults] stringForKey:@"loadType"] isEqualToString:@"xiala"]) {
                
                NSLog(@"\n重载tableView\n");
                //更新table的数据
                
                NSLog(@"\n开始RELOAD计时开始\n");
                [self.collectionView reloadData];
                NSLog(@"\n开始RELOAD计时结束\n");
                NSLog(@"\n重载结束\n");
                
                
                //刷新结束shangla
                [self.collectionView.header endRefreshing];
                NSLog(@"\n下拉结束\n");
                
                //[self performSelector:@selector(delayMethodNoticificationXiala) withObject:nil afterDelay:0.4f];
                
                }
            else
            {
                //刷新结束shangla
                [self.collectionView.header endRefreshing];
                NSLog(@"\n下拉结束\n");
            }
            }

    }];
    //刷新结束shangla
    [self.collectionView.header endRefreshing];
    NSLog(@"\n下拉结束\n");
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if(section == 1){
        return 6;
    }
    else
        return [self.posts count];
        //return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0)
    {
        /*
        轮播图使用ASSCroll实现
      
        :returns: <#return value description#>
        */
        ASScroll *asScroll = [[ASScroll alloc] initWithFrame:CGRectMake(0.0, 0.0, self.collectionView.frame.size.width, self.collectionView.frame.size.width * 0.25)];
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1 forIndexPath:indexPath];
      
        NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
        UIImage *image1 = [UIImage imageNamed:@"ad_1.jpg"];
        UIImage *image2 = [UIImage imageNamed:@"ad_2.jpg"];
        UIImage *image3 = [UIImage imageNamed:@"ad_3.jpg"];
        UIImageView *imageView1 = [[UIImageView alloc]initWithImage:image1];
        [imagesArray addObject:imageView1];
        UIImageView *imageView2 = [[UIImageView alloc]initWithImage:image2];
        [imagesArray addObject:imageView2];
        UIImageView *imageView3 = [[UIImageView alloc]initWithImage:image3];
        [imagesArray addObject:imageView3];

        [asScroll setArrOfImages:imagesArray];
        [cell.contentView addSubview:asScroll];
        
        return cell;
    
    }
    else if(indexPath.section == 1)
    {
        MainButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
        //cell.button.imageView.image = [UIImage imageNamed:@"sao.png"];
        [cell.layer setBorderWidth:2.0f];
        [cell.layer setBorderColor:[UIColor cyanColor].CGColor];
        [cell.layer setCornerRadius:25.0f];
        return cell;

    }
    else
    {
        MainGoodsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier3 forIndexPath:indexPath];
        [cell setGoods:[self.posts objectAtIndex:indexPath.row]];
        // Configure the cell
        
        return cell;

    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *reusableView = nil;
    //定义分栏标题
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 2){
        
        MainHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier4 forIndexPath:indexPath];
        //reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier5 forIndexPath:indexPath];
        headerView.layer.borderWidth = 1.0f;
        headerView.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor;
        NSString *title = @"抢购";
        headerView.nameLabel.text = title;
       
        //headerView.backgroundImage.image = headerImage;
        reusableView = headerView;
        //NSLog([NSString stringWithFormat:@"%@",reusableView.nameLabel.text]);
    }
    return reusableView;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//  点击元素响应方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        CommodityDetailsPageController *cdpController = [[CommodityDetailsPageController alloc] init];
        //cdpController.hidesBottomBarWhenPushed = YES;
        //进入商品详情页隐藏tabbar
        [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
        //设置cdpController.view背景色为白色，原来默认为透明，切换时视觉上会出现卡顿
        cdpController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:cdpController animated:YES];
    }
    
}

// 定制itemSize
- (CGSize)collectionView:(UICollectionView*)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width*0.25);
        
    }
    else if(indexPath.section == 1){
        return CGSizeMake(50, 50);
    }
    else
        return CGSizeMake(163, 163+50+30);
}

//  定义单元格所在行line之间的距离,前一行和后一行的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 30.0;
    }
    return 10.0;
}

//  定义每个元素的margin(边缘 上-左-下-右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 20, 0);
    }
    else if(section == 1)
        return UIEdgeInsetsMake(10, 30, 30, 30);
    
    return UIEdgeInsetsMake(5, 20, 20, 20);
    
}

// 定义section内cell间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 50.0f;
    }
    else
        return 6.0f;
}

//  设置页眉(水平滑动的时候设置width,垂直滑动的时候设置height)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 2)
        return CGSizeMake(collectionView.frame.size.width, 40);
    else
        return CGSizeZero;
}

//  设置页脚(水平滑动的时候设置width,垂直滑动的时候设置height)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
    
}



/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
