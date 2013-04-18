//
//  Article.m
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#include <libxml/xmlreader.h>

#import "Article.h"

int ArticleReadCallback(NSData *context, char *buffer, int len) {
    return 0;
}

@implementation Article

+ (NSArray *)parseArticlesFromFeed:(NSData *)feedData {
    xmlTextReaderPtr reader = xmlReaderForMemory([feedData bytes], [feedData length], NULL, NULL, XML_PARSE_NONET | XML_PARSE_NOCDATA);
    NSArray *articles = nil;

    if (reader != NULL) {
        NSMutableArray *mutableArticles = [NSMutableArray array];
        Article *article = nil;
        int success = xmlTextReaderRead(reader);

        articles = [NSMutableArray array];

        while (success == 1) {
            int nodeType = xmlTextReaderNodeType(reader);

            // Only stop on nodes, see http://www.gnu.org/software/dotgnu/pnetlib-doc/System/Xml/XmlNodeType.html
            if (nodeType == 1) {
                xmlChar *name = xmlTextReaderName(reader);
                int depth = xmlTextReaderDepth(reader);

                if (depth == 2) {
                    // Look for an item
                    // <rss>
                    //   <channel>
                    //     <item>
                    if (xmlStrncmp(name, BAD_CAST "item", 4) == 0) {
                        if (article != nil) [mutableArticles addObject:article];
                        article = [Article new];
                    } else {
                        if (article != nil) [mutableArticles addObject:article];
                        article = nil;
                    }
                } else if (article != nil && depth == 3) {
                    if (xmlStrncmp(name, BAD_CAST "title", 5) == 0) {
                        // Look for a title
                        // <rss>
                        //   <channel>
                        //     <item>
                        //       <title>
                        xmlChar *title = NULL;

                        xmlTextReaderRead(reader);
                        title = xmlTextReaderValue(reader);

                        if (title != NULL) {
                            article.title = [NSString stringWithCString:(const char *)title encoding:NSUTF8StringEncoding];
                            xmlFree(title);
                        }
                    } else if (xmlStrncmp(name, BAD_CAST "link", 4) == 0) {
                        // Look for a link
                        // <rss>
                        //   <channel>
                        //     <item>
                        //       <link>
                        xmlChar *rawURL = NULL;

                        xmlTextReaderRead(reader);
                        rawURL = xmlTextReaderValue(reader);

                        if (rawURL != NULL) {
                            NSString *rawURLString = [NSString stringWithCString:(const char *)rawURL encoding:NSUTF8StringEncoding];

                            if ([rawURLString length] > 0) {
                                article.linkURL = [NSURL URLWithString:rawURLString];
                            }

                            xmlFree(rawURL);
                        }
                    } else if (xmlStrncmp(name, BAD_CAST "media:content", 13) == 0) {
                        // Look for a picture
                        // <rss>
                        //   <channel>
                        //     <item>
                        //       <media:content url="http://graphics8.nytimes.com/images/2013/04/16/technology/bits-amazonmusic/bits-amazonmusic-thumbStandard.jpg" medium="image" width="75" height="75"/>
                        while (xmlTextReaderMoveToNextAttribute(reader) == 1) {
                            xmlChar *attributeName = xmlTextReaderName(reader);

                            if (xmlStrncmp(attributeName, BAD_CAST "url", 3) == 0) {
                                xmlChar *rawURL = xmlTextReaderValue(reader);

                                if (rawURL != NULL) {
                                    NSString *rawURLString = [NSString stringWithCString:(const char *)rawURL encoding:NSUTF8StringEncoding];

                                    if ([rawURLString length] > 0) {
                                        article.imageURL = [NSURL URLWithString:rawURLString];
                                    }

                                    xmlFree(rawURL);
                                }

                                if (attributeName != NULL) xmlFree(attributeName);
                                break;
                            }

                            if (attributeName != NULL) xmlFree(attributeName);
                        }
                    }

                }

                if (name != NULL) xmlFree(name);
            }

            success = xmlTextReaderRead(reader);
        }

        xmlFree(reader);

        if (article != nil) {
            [mutableArticles addObject:article];
        }

        articles = [NSArray arrayWithArray:mutableArticles];
    }

    return articles;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Article %@>", self.title];
}

@end
