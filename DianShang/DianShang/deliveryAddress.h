//
//  deliveryAddress.h
//  DianShang
//
//  Created by 张伟颖 on 15/9/1.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  收货地址

#import <Foundation/Foundation.h>

@interface deliveryAddress : NSObject

@property (nonatomic, strong) NSString *name;    //收货人
@property (nonatomic, strong) NSString *phoneNO; //电话
@property (nonatomic, strong) NSString *area;    //所在地区 省／市／区
@property (nonatomic, strong) NSString *address; //详细地址

@end
