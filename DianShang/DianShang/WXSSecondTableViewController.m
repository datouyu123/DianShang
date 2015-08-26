//
//  WXSSecondTableViewController.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/24.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSSecondTableViewController.h"
#import "FMDBHelper.h"
#import "Post.h"
#import "Good.h"
#import "WXSSecondTableViewCell.h"

@interface WXSSecondTableViewController ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (readwrite, nonatomic, strong) NSMutableArray *goods;

@end

@implementation WXSSecondTableViewController

#pragma mark - Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.goods = [[NSMutableArray alloc] init];
    //防止tableview多几行
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //设置cell.imageView不挡住分隔线
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //[[FMDBHelper sharedFMDBHelper] emptyDatabaseByName:@"SHOPPING_CART_TABLE"];
    self.goods = [NSMutableArray arrayWithArray:[[FMDBHelper sharedFMDBHelper] selectFromSHOPPING_CART_TABLE]];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [[FMDBHelper sharedFMDBHelper] deleteFromSHOPPING_CART_TABLE:post.postID];
            break;
        }
        default:
            break;
    }
}

@end
