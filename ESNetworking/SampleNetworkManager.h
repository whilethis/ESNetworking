//
//  SampleNetworkManager.h
//  ESNetworking
//
//  Created by Doug Russell on 9/26/11.
//  Copyright (c) 2011 Doug Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESHTTPOperation.h"
#import "ESJSONOperation.h"

@interface SampleNetworkManager : NSObject

+ (id)sharedManager;
- (void)addOperation:(ESHTTPOperation *)op;

@end
