//
//  AppDelegate.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/9.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIViewController *viewController;
@property (retain,nonatomic) UITabBarController *tabBarCtr;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

