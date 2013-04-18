//
//  NewsViewController.m
//  Bits
//
//  Created by Frédéric Sagnes on 18/04/13.
//  Copyright (c) 2013 teapot apps. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@property (strong) NSOperationQueue *imagesDownloadQueue;

- (void)refresh;

@end

@implementation NewsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];

    if (self) {
        self.imagesDownloadQueue = [[NSOperationQueue alloc] init];
        self.title = @"Bits Blog";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                               action:@selector(refresh)];
    }

    return self;
}

- (void)refresh {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    cell.textLabel.text = @"There’s Something About Smartwatches";
    cell.imageView.image = [UIImage imageNamed:@"Icon.png"];

    {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://graphics8.nytimes.com/images/2013/04/17/technology/17bits-wrist/17bits-wrist-thumbStandard.jpg"]];

        [NSURLConnection sendAsynchronousRequest:request queue:self.imagesDownloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
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
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://bits.blogs.nytimes.com/2013/04/17/smartwatches/"]];
    UIViewController *webViewController = [UIViewController new];
    UIWebView *webView = [UIWebView new];

    webViewController.title = @"There’s Something About Smartwatches";
    webViewController.view = webView;
    [webView loadRequest:request];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
