//
//  FirstCollectionViewController.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/12.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "FirstCollectionViewController.h"
#import "ASScroll.h"
#import "MainButtonCollectionViewCell.h"

@interface FirstCollectionViewController ()
{
    //定义搜索按钮
    UIButton *searchButton;
    //定义扫一扫按钮
    UIButton *saoButton;
}

@end

@implementation FirstCollectionViewController

static NSString * const reuseIdentifier1 = @"adCell";
static NSString * const reuseIdentifier2 = @"btnCell";
static NSString * const reuseIdentifier3 = @"contentCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier1];
    [self.collectionView registerClass:[MainButtonCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier2];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier3];

    
    // Do any additional setup after loading the view.
    //背景颜色
    self.collectionView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
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
;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0)
    {
        /*
        轮播图使用ASSCroll实现
      
        :returns: <#return value description#>
        */
        ASScroll *asScroll = [[ASScroll alloc] initWithFrame:CGRectMake(0.0, 0.0, self.collectionView.frame.size.width, self.collectionView.frame.size.width * 0.3)];
        NSLog([NSString stringWithFormat:@"%.2f",self.collectionView.frame.size.width*0.3]);
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
        NSLog([NSString stringWithFormat:@"%.2f",cell.contentView.frame.size.height]);
        return cell;
    
    }
    else if(indexPath.section == 1)
    {
        MainButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
        //cell.label.text =@"sss";
        return cell;

    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier3 forIndexPath:indexPath];
        UIImage *image = [UIImage imageNamed:@"content.jpg"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        [cell.contentView addSubview:imageView];
        // Configure the cell
        
        return cell;

    }
    
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
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
    
    
}

// 定制itemSize
- (CGSize)collectionView:(UICollectionView*)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width*0.3);
        
    }
    else if(indexPath.section == 1){
        return CGSizeMake(100, 100);
    }
    else
        return CGSizeMake(163, 163);
}

//  定义单元格所在行line之间的距离,前一行和后一行的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 50.0;
}

//  定义每个元素的margin(边缘 上-左-下-右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 20, 0);
    
}

//  设置页眉(水平滑动的时候设置width,垂直滑动的时候设置height)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
    
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
