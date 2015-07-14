//
//  ASScroll.m
//  ScrollView Source control
//
//  Created by Ahmed Salah on 12/14/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import "ASScroll.h"

@interface ASScroll()
{
    float m_screen_wid;
    float m_screen_hei;
}
@end

@implementation ASScroll
@synthesize arrOfImages;


-(void)setTitleArray:(NSMutableArray *)arr{
    
    _titleArray = [NSArray arrayWithArray:arr];
    
    
    
    
    //add by xianyu
    //说明文字层
    
    for (UIView *view in [self subviews])
    {
        if (view.tag == 1111 || view.tag == 111) {
            [view removeFromSuperview];
            NSLog(@"\n目标出现\n");
        }
        
        
        
    }
    
    
//    int page = floor((scrollView.contentOffset.x - m_screen_wid) / m_screen_wid) + 1;

   
    
        //标题的高度
        noteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-12,self.bounds.size.width,32)];
        [noteView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, 32)];
    
    
        [noteTitle setText: [self shotTitle:[_titleArray objectAtIndex:0]]];
    
    
    
    NSString *sL = [[_titleArray objectAtIndex:0] copy];
    
    NSLog(@"\n标题:%@\n", sL);
    
    NSLog(@"\n标题长度：%@\n", [NSString stringWithFormat:@"%lu",(unsigned long)[sL length]]);
    
        [noteTitle setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
        [noteTitle setFont:[UIFont boldSystemFontOfSize:19]];
        [noteTitle setTextColor:[UIColor whiteColor]];
        
        
        
//        设置标签Tag，用于删除的时候进行识别
        [noteView setTag:111];
        
        [noteTitle setTag:1111];
        [noteView addSubview:noteTitle];
        
       
        
         [self addSubview:noteView];
        
    
    
    
    
    
    [self addSubview:pageControl];
    
   
   
    
   
    // [noteView release];

    
    //[self initTitle:_titleArray];
}


-(NSString *)shotTitle:(NSString *) toShotTitle{
    
    if ([toShotTitle length] > 15) {
        return [NSString stringWithFormat:@"%@%@", [toShotTitle substringWithRange:NSMakeRange(0, 14)],@"..."];
    }
    
    return toShotTitle;
    
}


/*
-(void)initTitle:(NSArray *)titleArr{
    
//    titleArray = [NSArray arrayWithObjects:@"这是萌球宠物的文章的测试标题！",@"22",@"33", nil];
    
    
    _titleArray = titleArr;
    
    
    
    
    //add by xianyu
    //说明文字层
    
    UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-25,self.bounds.size.width,25)];
    [noteView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    
    
    
    noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, 25)];
    [noteTitle setText:[_titleArray objectAtIndex:0]];
    [noteTitle setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
    [noteTitle setFont:[UIFont systemFontOfSize:17]];
    [noteTitle setTextColor:[UIColor whiteColor]];

    
    
    [noteView addSubview:noteTitle];
    
    [self addSubview:noteView];
    // [noteView release];

    
}
 
 
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
        m_screen_wid = frame.size.width;
        m_screen_hei = frame.size.height;
    }
    return self;
}

-(void)setArrOfImages:(NSMutableArray *)arr{
   
    
    for (UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    didEndAnimate = NO;
    
    arrOfImages = arr;
    pageControl = [[UIPageControl alloc] init];
//    pageControl.frame = CGRectMake(self.frame.origin.x + self.frame.size.width / 2 - arrOfImages.count * 10, self.frame.origin.y + self.frame.size.height - 20, arrOfImages.count * 20, 20);
    
    //开始定制PageControl  02.09
    
//    pageControl.frame = CGRectMake(self.frame.origin.x + self.frame.size.width / 2 - arrOfImages.count * 10, self.frame.size.height - 20, arrOfImages.count * 20, 20);
    
    pageControl.frame = CGRectMake(self.frame.origin.x + 130 + self.frame.size.width / 2 - arrOfImages.count * 10, self.frame.size.height - 6, arrOfImages.count * 20, 20);
    pageControl.numberOfPages = arrOfImages.count;
    pageControl.currentPage = 0;
    pageControl.alpha = 1.0;
    
    _scrollview = [[UIScrollView alloc] initWithFrame:self.frame];
    m_screen_wid = self.frame.size.width;
    m_screen_hei = self.frame.size.height;
    _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width * arrOfImages.count,_scrollview.frame.size.height);
    [_scrollview setDelegate:self];
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.pagingEnabled = YES;
    _scrollview.scrollEnabled = YES;
    for (int i =0; i<arrOfImages.count ; i++) {
       
        //来自咸鱼的更改，用于使用新的方式：UIImageView初始化ASSCroll  02.09
//        UIImageView * imageview = [[UIImageView alloc]initWithImage:[arrOfImages objectAtIndex:i]];
        //轮播图初始化成功！  02.09   by 咸鱼
        UIImageView * imageview = [arrOfImages objectAtIndex:i];
        [imageview setContentMode:UIViewContentModeScaleToFill];
        
        //图片的高度
        imageview.frame = CGRectMake(0.0, 0.0,_scrollview.frame.size.width , _scrollview.frame.size.height + 20);
        [imageview setTag:i+1];
        if (i !=0) {
            imageview.alpha = 0;
        }
        [self addSubview:imageview];
    }
    [pageControl addTarget:self
                    action:@selector(pgCntlChanged:)forControlEvents:UIControlEventValueChanged];
//    [self performSelector:@selector(startAnimatingScrl) withObject:nil afterDelay:3.0];
    
    
    
   
    
    
    [self addSubview:_scrollview];
    
    
   
    
//    [self addSubview:pageControl];
    
    
    

    
}



- (void)startAnimatingScrl
{
    if (!didEndAnimate) {
        if (arrOfImages.count) {
            [_scrollview scrollRectToVisible:CGRectMake(((pageControl.currentPage + 1) % arrOfImages.count)*_scrollview.frame.size.width, 0, _scrollview.frame.size.width, _scrollview.frame.size.height) animated:YES];
            [pageControl setCurrentPage:((pageControl.currentPage +1)%arrOfImages.count)];
            [self performSelector:@selector(startAnimatingScrl) withObject:nil  afterDelay:3.0];
        }
    }
}
- (void)cancelScrollAnimation{
    didEndAnimate = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimatingScrl) object:nil];
}

- (void)pgCntlChanged:(UIPageControl *)sender {
    [_scrollview scrollRectToVisible:CGRectMake(sender.currentPage*_scrollview.frame.size.width, 0, _scrollview.frame.size.width, _scrollview.frame.size.height) animated:YES];
    [self cancelScrollAnimation];
}

-(void)dealloc{
    [self cancelScrollAnimation];
    noteView = nil;
    noteTitle = nil;

}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelScrollAnimation];
    previousTouchPoint = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [pageControl setCurrentPage:_scrollview.bounds.origin.x/_scrollview.frame.size.width];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //添加文字切换  02.09
    
    //CGFloat pageWidth = scrollView.frame.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    int page = floor((scrollView.contentOffset.x - m_screen_wid) / m_screen_wid) + 1;
    currentPageIndex=page;
    
    //pageControl.currentPage=(page-1);
    int titleIndex=page;
    if (titleIndex==[_titleArray count]) {
        titleIndex=0;
    }
   
    
    if (titleIndex<0) {
        titleIndex=0;
    }
    
    [noteTitle setText:[self shotTitle:[_titleArray objectAtIndex:titleIndex]]];
    
    
    //添加文字切换结束
    
    
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    
//    int page = floor((scrollView.contentOffset.x - m_screen_wid) / m_screen_wid) + 1;
    

    // 获取当前页码
    page = floor((scrollView.contentOffset.x - m_screen_wid) / m_screen_wid) + 1;
    float OldMin = m_screen_wid * page;
    int Value = scrollView.contentOffset.x - OldMin;
    int widTemp = m_screen_wid;
    float alpha = (Value % widTemp) / m_screen_wid;

    
    
    if (previousTouchPoint > scrollView.contentOffset.x)
        page = page+2;
    else
        page = page+1;
    
    UIView *nextPage = [scrollView.superview viewWithTag:page+1];
    UIView *previousPage = [scrollView.superview viewWithTag:page-1];
    UIView *currentPage = [scrollView.superview viewWithTag:page];
    
    if(previousTouchPoint <= scrollView.contentOffset.x){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = 1-alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = alpha;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 0;
    }else if(page != 0){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = 0;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 1-alpha;
    }
    if (!didEndAnimate && pageControl.currentPage == 0) {
        
        for (UIView * imageView in self.subviews){
            if (imageView.tag !=1 && [imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 0;
            else if([imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 1 ;
        }
        
        
        
    }
    
}

@end
