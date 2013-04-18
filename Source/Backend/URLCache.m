//
//  URLCache.m
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import "URLCache.h"

@implementation URLCache

+ (URLCache *)sharedURLCache {
    URLCache *sharedURLCache = (URLCache *)[super sharedURLCache];

    NSAssert([sharedURLCache isKindOfClass:[self class]], @"URLCache isn't the default cache");

    return sharedURLCache;
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];

    if (cachedResponse != nil && [cachedResponse.response isKindOfClass:[NSHTTPURLResponse class]] && self.forceCachedRequests) {
        NSHTTPURLResponse *originalResponse = (NSHTTPURLResponse *)[cachedResponse response];
        NSHTTPURLResponse *alteredResponse = nil;
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[originalResponse allHeaderFields]];

        [headers removeObjectForKey:@"Cache-Control"];
        [headers removeObjectForKey:@"Vary"];
        [headers setObject:@"Thu, 01 Dec 2050 16:00:00 GMT" forKey:@"Expires"];
        alteredResponse = [[NSHTTPURLResponse alloc] initWithURL:[originalResponse URL]
                                                      statusCode:[originalResponse statusCode]
                                                     HTTPVersion:@"HTTP/1.1"
                                                    headerFields:headers];
        cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:alteredResponse
                                                                  data:[cachedResponse data]
                                                              userInfo:[cachedResponse userInfo]
                                                         storagePolicy:[cachedResponse storagePolicy]];
        NSLog(@"Forcing offline version for %@", [request URL]);
    } else {
        NSLog(@"Fetching %@", [request URL]);
    }

    return cachedResponse;
}

@end
