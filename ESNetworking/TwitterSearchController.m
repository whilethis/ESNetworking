//
//  TwitterSearchController.m
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

#import "TwitterSearchController.h"
#import "SampleNetworkManager.h"
#import "Tweet.h"

@interface TwitterSearchController ()
@property (strong, nonatomic) NSArray *results;
@end

@implementation TwitterSearchController
@synthesize results=_results;

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) 
	{
		self.title = @"Twitter";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)pollTwitter
{
	UIActivityIndicatorView *pinWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pinWheel];
	[pinWheel startAnimating];
	NSString *urlString = @"http://search.twitter.com/search.json?q=Test";
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	__weak TwitterSearchController *weakSelf = self;
	__weak UINavigationItem *navigationItem = self.navigationItem;
	ESJSONOperation *op = 
	[ESJSONOperation newJSONOperationWithRequest:request 
										 success:^(ESJSONOperation *op, id JSON) {
											 navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																															   target:weakSelf 
																															   action:@selector(refresh:)];
											 // This should really be done off the main thread, but it's fine for this sample
											 NSMutableArray *results = [NSMutableArray new];
											 for (NSDictionary *dictionary in [JSON objectForKey:@"results"])
											 {
												 Tweet *tweet = [Tweet newWithDictionary:dictionary];
												 if (tweet)
													 [results addObject:tweet];
											 }
											 [weakSelf setResults:results];
											 [[weakSelf tableView] reloadData];
										 } failure:^(ESJSONOperation *op) {
											 navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																															   target:weakSelf 
																															   action:@selector(refresh:)];
											 Tweet *tweet = [Tweet new];
											 tweet.user = @"Error";
											 tweet.text = @"Unable to complete search";
											 [weakSelf setResults:[NSArray arrayWithObject:tweet]];
											 [[weakSelf tableView] reloadData];
										 }];
	[[SampleNetworkManager sharedManager] addOperation:op];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self pollTwitter];
}

- (void)refresh:(id)sender
{
	// If the users internet connection is down, they've most likely already been alerted, 
	// but we'll remind them any time they initiate an action that requires a connection
	if (![[SampleNetworkManager sharedManager] hasInternets])
		[[SampleNetworkManager sharedManager] noConnectionAlert];
	[self pollTwitter];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
	Tweet *tweet = [self.results objectAtIndex:indexPath.row];
	cell.textLabel.text = tweet.user;
	cell.detailTextLabel.text = tweet.text;
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
