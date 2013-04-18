//
//  AppDelegate.m
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window = window;
    [window makeKeyAndVisible];

    return YES;
}

@end
