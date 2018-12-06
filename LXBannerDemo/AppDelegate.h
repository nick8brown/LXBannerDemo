//
//  AppDelegate.h
//  LXBannerDemo
//
//  Created by LX Zeng on 2018/12/6.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

