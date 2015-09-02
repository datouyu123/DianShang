//
//  PersonalMessage.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/31.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "PersonalMessage.h"
#import "MJExtension.h"

static PersonalMessage * personal = nil;
@implementation PersonalMessage
// NSCoding实现
MJExtensionCodingImplementation

//+ (NSDictionary *)objectClassInArray
//{
//    return @{
//             @"addrs" : @"deliveryAddress",
//             
//             };
//}

//单实例化
+ (PersonalMessage *)defaultPersonal
{
    //加锁
    @synchronized (self)
    {
        if (personal == nil) {
            personal = [[super alloc]init];
            personal.userName = [[NSString alloc] init];
            personal.password = [[NSString alloc] init];
            personal.nickName = [[NSString alloc] init];
            personal.avatarImage = [[NSString alloc] init];
            personal.birthDate = [[NSString alloc] init];
            personal.addrs = [[NSArray alloc] init];
            
            NSString * file = [NSHomeDirectory() stringByAppendingPathComponent:@"personal"];
            // 解档
            personal = [NSKeyedUnarchiver unarchiveObjectWithFile:file];

            
        }
    }
    return personal;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (personal == nil) {
            personal = [super allocWithZone:zone];
            return  personal;
        }
    }
    return nil;
}

+ (void)save:(PersonalMessage *)person{
    NSString * file = [NSHomeDirectory() stringByAppendingPathComponent:@"personal"];
    NSLog(@"%@",file);
    // 归档
    [NSKeyedArchiver archiveRootObject:person toFile:file];
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.userName = [[NSString alloc] init];
        self.password = [[NSString alloc] init];
        self.nickName = [[NSString alloc] init];
        
        
        self.userName = [attributes valueForKeyPath:@"userName"];
        self.password = [attributes valueForKeyPath:@"password"];
        self.nickName = [attributes valueForKeyPath:@"nickName"];
        
    }
    return self;
}

@end
