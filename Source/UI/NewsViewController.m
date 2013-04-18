//
//  NewsViewController.m
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import "NewsViewController.h"
#import "Article.h"

@interface NewsViewController ()

@property NSArray *articles;
@property NSOperationQueue *downloadQueue;

- (void)refresh;

@end

@implementation NewsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];

    if (self) {
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.title = @"Bits Blog";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                               action:@selector(refresh)];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self refresh];
}

- (void)refresh {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bits.blogs.nytimes.com/feed/"]];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:self.downloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error == nil) {
            self.articles = [Article parseArticlesFromFeed:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    Article *article = [self.articles objectAtIndex:indexPath.row];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    cell.textLabel.text = article.title;
    cell.imageView.image = [UIImage imageNamed:@"Icon.png"];

    if (article.imageURL != nil) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:article.imageURL];

        [NSURLConnection sendAsynchronousRequest:request queue:self.downloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error == nil) {
                UIImage *image = [UIImage imageWithData:data];

                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                });
            }
        }];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = [self.articles objectAtIndex:indexPath.row];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:article.linkURL];
    UIViewController *webViewController = [UIViewController new];
    UIWebView *webView = [UIWebView new];

    webViewController.title = @"There’s Something About Smartwatches";
    webViewController.view = webView;
    [webView loadRequest:request];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
