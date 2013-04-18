//
//  URLCache.h
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLCache : NSURLCache

+ (URLCache *)sharedURLCache;

@property BOOL forceCachedRequests;

@end
