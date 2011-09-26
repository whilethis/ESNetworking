//
//  SampleNetworkManager.m
//  ESNetworking
//
//  Created by Doug Russell on 9/26/11.
//  Copyright (c) 2011 Doug Russell. All rights reserved.
//

#import "SampleNetworkManager.h"

@interface SampleNetworkManager ()
@property (strong, nonatomic) NSOperationQueue *networkTransferQueue;
@end

@implementation SampleNetworkManager
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
	}
	return self;
}

- (void)addOperation:(ESHTTPOperation *)op
{
	[self.networkTransferQueue addOperation:op];
}

@end
