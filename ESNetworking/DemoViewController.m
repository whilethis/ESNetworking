//
//  DemoViewController.m
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

#import "DemoViewController.h"
#import "WebViewController.h"
#import "TwitterSearchController.h"
#import "ImageViewController.h"
#import "SampleNetworkManager.h"

@implementation DemoViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) 
	{
		self.title = @"Sample Operations";
    }
    return self;
}

#pragma mark - View lifecycle

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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Load Web Content";
			break;
		case 1:
			cell.textLabel.text = @"Twitter Search";
			break;
		case 2:
			cell.textLabel.text = @"Big Image";
			break;
		default:
			break;
	}
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	// If the users internet connection is down, they've most likely already been alerted, 
	// but we'll remind them any time they initiate an action that requires a connection
	if (![[SampleNetworkManager sharedManager] hasInternets])
		[[SampleNetworkManager sharedManager] noConnectionAlert];
	switch (indexPath.row) {
		case 0:
			[self.navigationController pushViewController:[WebViewController new] animated:YES];
			break;
		case 1:
			[self.navigationController pushViewController:[TwitterSearchController new] animated:YES];
			break;
		case 2:
			[self.navigationController pushViewController:[ImageViewController new] animated:YES];
			break;
		default:
			break;
	}
}

@end
