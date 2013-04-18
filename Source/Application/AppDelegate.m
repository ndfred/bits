//
//  AppDelegate.m
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "URLCache.h"
#import "Reachability.h"

//#define REMOVE_CACHE
//#define GENERATE_SPLASHSCREEN_IMAGE

#ifdef GENERATE_SPLASHSCREEN_IMAGE
#import <QuartzCore/QuartzCore.h>
#endif

@interface AppDelegate ()

- (void)reachabilityDidChange;

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef REMOVE_CACHE
    {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *httpCachePath = [cachePath stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
        NSString *pdfCachePath = [cachePath stringByAppendingPathComponent:@"PDFs"];
        
        NSLog(@"Removing HTTP cache: %@", httpCachePath);
        [[NSFileManager defaultManager] removeItemAtPath:httpCachePath error:nil];
        NSLog(@"Removing PDF cache: %@", pdfCachePath);
        [[NSFileManager defaultManager] removeItemAtPath:pdfCachePath error:nil];
    }
#endif

    // Setup the URL cache
    [NSURLCache setSharedURLCache:[URLCache new]];

    // Setup reachability
    {
        Reachability *reachability = [Reachability reachabilityWithHostname:@"bits.blogs.nytimes.com"];

        self.reachability = reachability;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityDidChange)
                                                     name:kReachabilityChangedNotification
                                                   object:reachability];
        [reachability startNotifier];
        [self reachabilityDidChange];
    }

    // Setup the view controller
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[NewsViewController new]];

        window.rootViewController = navigationController;
        self.window = window;
        [window makeKeyAndVisible];
    }

#ifdef GENERATE_SPLASHSCREEN_IMAGE
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *rootView = window.rootViewController.view;
        CGRect frame = rootView.bounds;
        UIDevice *device = [UIDevice currentDevice];
        BOOL isLandscape = UIDeviceOrientationIsLandscape(device.orientation);
        BOOL isPad = (device.userInterfaceIdiom == UIUserInterfaceIdiomPad);
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat statusBarHeight = isPad ? (isLandscape ? statusBarFrame.size.width : statusBarFrame.size.height) : 0.0f;

        frame.origin.y += statusBarHeight;
        frame.size.height -= statusBarHeight;
        UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0.0);
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), - frame.origin.x, - frame.origin.y);
        [rootView.layer renderInContext:UIGraphicsGetCurrentContext()];

        {
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"Default"];

            if (frame.size.height + statusBarHeight == 568) {
                filePath = [filePath stringByAppendingString:@"-568h"];
            }

            if (isPad) {
                filePath = [filePath stringByAppendingString:isLandscape ? @"-Landscape" : @"-Portrait"];
            }

            if (window.screen.scale > 1.0f) {
                filePath = [filePath stringByAppendingString:@"@2x"];
            }

            if (isPad) {
                filePath = [filePath stringByAppendingString:@"~ipad"];
            } else {
                filePath = [filePath stringByAppendingString:@"~iphone"];
            }

            filePath = [filePath stringByAppendingString:@".png"];
            NSLog(@"Writing splash screen to path %@", filePath);
            [UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext()) writeToFile:filePath atomically:YES];
        }

        UIGraphicsEndImageContext();
    });
#endif

    return YES;
}

- (void)reachabilityDidChange {
    BOOL isReachable = [self.reachability isReachable];

    NSLog(@"Connection is now %@ (%@)", isReachable ? @"available" : @"unavailable", [self.reachability currentReachabilityString]);
    [[URLCache sharedURLCache] setForceCachedRequests:!isReachable];
}

@end
