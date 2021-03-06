//
//  AppDelegate.h
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) Reachability *reachability;

+ (AppDelegate *)sharedDelegate;

@end
