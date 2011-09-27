//
//  ImageViewController.m
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

#import "ImageViewController.h"
#import "SampleNetworkManager.h"
#import "UIImage+ESAdditions.h"

@interface ImageViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ImageViewController
@synthesize imageView=_imageView;

#pragma mark - View lifecycle
- (void)loadView
{
	self.imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.imageView.backgroundColor = [UIColor blackColor];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.view = self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.titleView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	NSURL *url = [NSURL URLWithString:@"http://farm5.static.flickr.com/4114/4800356319_af057f6467_o.jpg"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	__weak UIProgressView *progressView = (UIProgressView *)self.navigationItem.titleView;
	__weak UIImageView *imageView = self.imageView;
	ESHTTPOperation *op = 
	[ESHTTPOperation newHTTPOperationWithRequest:request
											work:^id<NSObject>(ESHTTPOperation *op, NSError *__autoreleasing *error) {
												UIImage *image = [UIImage imageWithData:op.responseBody];
												UIImage *scaledImage = [image scaledToSize:imageView.bounds.size];
												return scaledImage;
											} 
									  completion:^(ESHTTPOperation *op) {
												if (op.error)
												{
													[progressView setProgress:0.0];
													[imageView setImage:nil];
												}
												else
												{
													[progressView setProgress:1.0];
													[imageView setImage:op.processedResponse];
												}
											}];
	op.maximumResponseSize = 10000000;
	[op setDownloadProgressBlock:^(NSUInteger totalBytesRead, NSUInteger totalBytesExpectedToRead) {
		[progressView setProgress:((float)totalBytesRead/(float)totalBytesExpectedToRead)];
	}];
	[[SampleNetworkManager sharedManager] addOperation:op];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.imageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
