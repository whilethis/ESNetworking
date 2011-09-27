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
		
		_internetReachability = [Reachability reachabilityForInternetConnection];
	}
	return self;
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

@end
