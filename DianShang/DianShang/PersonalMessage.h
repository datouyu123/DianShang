//
//  PersonalMessage.h
//  DianShang
//
//  Created by 张伟颖 on 15/8/31.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  个人信息

#import <Foundation/Foundation.h>

//性别
typedef NS_ENUM(NSInteger, Sex)
{
    Male = 0,                         //男
    Female                            //女
};

@interface PersonalMessage : NSObject

@property (nonatomic, copy) NSString *userName; //用户名
@property (nonatomic, copy) NSString *password; //密码
@property (nonatomic, copy) NSString *nickName; //昵称
@property (nonatomic, copy) NSString *avatarImage; //头像
@property (nonatomic, assign) Sex sex;
@property (nonatomic, copy) NSString *birthDate;
@property (nonatomic, strong) NSArray *addrs; //收货地址数组

// 单实例化 解档
+ (PersonalMessage *)defaultPersonal;
// 存档
+ (void)save:(PersonalMessage *)person;

@end
