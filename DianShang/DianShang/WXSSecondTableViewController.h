//
//  WXSSecondTableViewController.h
//  DianShang
//
//  Created by 张伟颖 on 15/8/24.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXSSecondTableViewController : UIViewController
/**
 *  controllerType判断购物车页面的类型，100代表点击详情页购物车按钮跳转，默认代表点击tabbar购物车按钮，两种布局稍有不同
 */
@property (nonatomic, assign) NSUInteger controllerType;

@end
