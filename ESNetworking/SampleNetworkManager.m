//
//  SampleNetworkManager.m
//  ESNetworking
//
//  Created by Doug Russell on 9/26/11.
//  Copyright (c) 2011 Doug Russell. All rights reserved.
//

#import "SampleNetworkManager.h"
#import "Reachability.h"

@interface SampleNetworkManager ()
@property (strong, nonatomic) NSOperationQueue *networkTransferQueue;
@end

@implementation SampleNetworkManager
{
@private
	Reachability *_internetReachability;
}
@synthesize networkTransferQueue=_networkTransferQueue;

+ (id)sharedManager
{
	static SampleNetworkManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[[self class] alloc] init];
	});
	return sharedManager;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_networkTransferQueue = [NSOperationQueue new];
		[_networkTransferQueue setMaxConcurrentOperationCount:4];
		[_networkTransferQueue addObserver:self forKeyPath:@"operationCount" options:0 context:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
		_internetReachability = [Reachability reachabilityForInternetConnection];
		[_internetReachability startNotifier];
	}
	return self;
}

- (void)dealloc // bit unnecessary, but nice for book keeping
{
	[_internetReachability stopNotifier];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ((object == self.networkTransferQueue) && [keyPath isEqualToString:@"operationCount"])
	{
		if ([self.networkTransferQueue operationCount])
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		else
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	else
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)addOperation:(ESHTTPOperation *)op
{
	[self.networkTransferQueue addOperation:op];
}

- (BOOL)hasInternets
{
	return [_internetReachability isReachable];
}

// Respond to changes in reachability
- (void)reachabilityChanged:(NSNotification *)notification
{
	Reachability *curReach = (Reachability *)[notification object];
	NetworkStatus netStatus = [curReach currentReachabilityStatus];	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(noConnectionAlert) object:nil];
	switch (netStatus) {
		case kNotReachable:
			[self performSelector:@selector(noConnectionAlert) withObject:nil afterDelay:4.0];
			break;
		case kReachableViaWWAN:
		case kReachableViaWiFi:
			break;
	}
}

- (void)noConnectionAlert
{
	if (![self hasInternets])
	{
		[[[UIAlertView alloc] initWithTitle:@"NO INTERNET CONNECTION" 
									message:@"This Application requires an active internet connection. Please connect to wifi or cellular data network for full application functionality." 
								   delegate:nil 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil] show];
	}
}

@end
