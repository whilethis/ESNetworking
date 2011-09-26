//
//  WebViewController.m
//
//  Created by Doug Russell
//  Copyright (c) 2011 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "WebViewController.h"
#import "SampleNetworkManager.h"

@interface WebViewController ()
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation WebViewController
@synthesize webView=_webView;

#pragma mark - View lifecycle

- (void)loadView
{
	self.webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.webView.scalesPageToFit = YES;
	self.view = self.webView;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.titleView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	NSURL *url = [NSURL URLWithString:@"http://www.43folders.com/2009/03/25/blogs-turbocharged"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	ESHTTPOperation *op = 
	[ESHTTPOperation newHTTPOperationWithRequest:request
											work:nil 
									  completion:^(ESHTTPOperation *op) {
										  if (op.error)
										  {
											  [(UIProgressView *)self.navigationItem.titleView setProgress:0.0];
											  [self.webView loadHTMLString:[NSString stringWithFormat:@"<H2>BAD THING!!!</H2><p>%@</p>", op.error] baseURL:nil];
										  }
										  else
										  {
											  [(UIProgressView *)self.navigationItem.titleView setProgress:1.0];
											  [self.webView loadData:op.responseBody 
															MIMEType:@"text/html" 
													textEncodingName:[NSString localizedNameOfStringEncoding:NSUTF8StringEncoding] 
															 baseURL:[NSURL URLWithString:@"http://www.43folders.com"]];
										  }
									  }];
	[op setDownloadProgressBlock:^(NSUInteger totalBytesRead, NSUInteger totalBytesExpectedToRead) {
		[(UIProgressView *)self.navigationItem.titleView setProgress:((float)totalBytesRead/(float)totalBytesExpectedToRead)];
	}];
	[[SampleNetworkManager sharedManager] addOperation:op];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
