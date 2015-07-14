//
//  ASScroll.h
//  ScrollView Source control
//
//  Created by Ahmed Salah on 12/14/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIPageControl.h>


@interface ASScroll : UIView<UIScrollViewDelegate>
{
    float previousTouchPoint;
    UIPageControl *pageControl;
    
    
    
//    暂时不添加定制的PageControl
//    CustomPageController *pageControl;
    
    
    /*!
     *  @author Xianyu, 15-02-02 16:02:12
     *
     *  滚动图title添加
     */
    //NSArray *titleArray;
    UILabel *noteTitle;
    int currentPageIndex;
    UIView *noteView;

    
    
    BOOL didEndAnimate;
}
@property (retain ,nonatomic) UIScrollView * scrollview ;
@property (retain ,nonatomic) NSMutableArray *arrOfImages;
@property (retain ,nonatomic) NSArray *titleArray;

- (void)startAnimatingScrl;
- (void)cancelScrollAnimation;

//-(void)initTitle:(NSArray *)titleArr;

//-(void)fingerTapEvent:(UITapGestureRecognizer *)sender;

//+(void)initTitleArray:(NSArray *)titleArr;

-(NSString *)shotTitle:(NSString *) toShotTitle;

@end
