//
//  WXSThirdMySetupController.m
//  DianShang
//
//  Created by 张伟颖 on 15/9/2.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSThirdMySetupController.h"

@interface WXSThirdMySetupController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation WXSThirdMySetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    //背景颜色
    self.view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, IPHONE_W, IPHONE_H) style:UITableViewStyleGrouped];
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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //自定义navigationbar
    [self styleNavBar];
    //使滑动返回手势在自定义的navbar上生效
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
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
    titleItem.title = @"设置";
    [newNavBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];

    UIImage *backButtonImage = [UIImage imageNamed:@"back_icon"];

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    backBarButtonItem.tintColor = [UIColor grayColor];

    titleItem.leftBarButtonItem = backBarButtonItem;

    [newNavBar setItems:@[titleItem]];
    // 4. add the nav bar to the main view
    [self.view addSubview:newNavBar];
}

- (void)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
    }
    else if (section==1)
    {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"setUpCell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setUpCell"];
    }
    
    
    //防止字体有重绘阴影
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    //图案标志
    if (indexPath.section==0)
    {
        if (indexPath.row==0){
            UIImageView *feedback=[[UIImageView alloc]initWithFrame:CGRectMake(10, (50-30)/2, 30, 30)];
            feedback.image=[UIImage imageNamed:@"feedback_icon"];
            [cell.contentView addSubview:feedback];
            
            UILabel *feedbackLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, (50-16)/2, 105, 16)];
            feedbackLabel.backgroundColor=[UIColor clearColor];
            feedbackLabel.textAlignment=0;
            feedbackLabel.text=@"意见反馈";
            [cell.contentView addSubview:feedbackLabel];
            //右侧辅助箭头
            UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_W-22, (50-22)/2, 12, 22)];
            arrow.image=[UIImage imageNamed:@"enter_icon"];
            [cell.contentView addSubview:arrow];
        }
        else{
            UIImageView *scoreNow=[[UIImageView alloc]initWithFrame:CGRectMake(10, (50-30)/2, 30, 30)];
            scoreNow.image=[UIImage imageNamed:@"To_score_icon"];
            [cell.contentView addSubview:scoreNow];
            
            UILabel *scoreNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, (50-16)/2, 105, 16)];
            scoreNowLabel.backgroundColor=[UIColor clearColor];
            scoreNowLabel.textAlignment=0;
            scoreNowLabel.text=@"现在去评分";
            [cell.contentView addSubview:scoreNowLabel];
            //右侧辅助箭头
            UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_W-22, (50-22)/2, 12, 22)];
            arrow.image=[UIImage imageNamed:@"enter_icon"];
            [cell.contentView addSubview:arrow];
        }
        
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UIImageView *aboutUs=[[UIImageView alloc]initWithFrame:CGRectMake(10, (50-30)/2, 30, 30)];
            aboutUs.image=[UIImage imageNamed:@"Q&A_icon"];
            [cell.contentView addSubview:aboutUs];
            
            UILabel *aboutUsLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, (50-16)/2, 105, 16)];
            aboutUsLabel.backgroundColor=[UIColor clearColor];
            aboutUsLabel.textAlignment=0;
            aboutUsLabel.text=@"关于我们";
            [cell.contentView addSubview:aboutUsLabel];
            //右侧辅助箭头
            UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_W-22, (50-22)/2, 12, 22)];
            arrow.image=[UIImage imageNamed:@"enter_icon"];
            [cell.contentView addSubview:arrow];
        }
        else{
            UIImageView *version=[[UIImageView alloc]initWithFrame:CGRectMake(10, (50-30)/2, 30, 30)];
            version.image=[UIImage imageNamed:@"new_version_icon"];
            [cell.contentView addSubview:version];
            
            UILabel *versionLable=[[UILabel alloc]initWithFrame:CGRectMake(50, (50-16)/2, 105, 16)];
            versionLable.backgroundColor=[UIColor clearColor];
            versionLable.textAlignment=0;
            versionLable.text=@"检测新版本";
            [cell.contentView addSubview:versionLable];
            
            //版本号
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            UILabel *versionNumber=[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_W-70, (50-12)/2, 60, 12)];
            versionNumber.backgroundColor=[UIColor clearColor];
            versionNumber.textAlignment=2;
            versionNumber.font=[UIFont systemFontOfSize:12];
            versionNumber.text=[NSString stringWithFormat:@"版本%@",currentVersion];
            versionNumber.textColor=[UIColor grayColor];
            [cell.contentView addSubview:versionNumber];
        }
    }
    else{
        UIImageView *quite=[[UIImageView alloc]initWithFrame:CGRectMake(10, (50-30)/2, 30, 30)];
        quite.image=[UIImage imageNamed:@"exit_icon"];
        [cell.contentView addSubview:quite];
        
        UILabel *quiteLable=[[UILabel alloc]initWithFrame:CGRectMake(50, (50-16)/2, 105, 16)];
        quiteLable.backgroundColor=[UIColor clearColor];
        quiteLable.textAlignment=0;
        quiteLable.text=@"退出当前账号";
        [cell.contentView addSubview:quiteLable];
    }
    return cell;
}

@end
