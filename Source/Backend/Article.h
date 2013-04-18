//
//  Article.h
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property NSString *title;
@property NSURL *linkURL;
@property NSURL *imageURL;

+ (NSArray *)parseArticlesFromFeed:(NSData *)feedData;

@end
