//
//  Level2.m
//  Locked
//
//  Created by Imran Khawaja on 3/28/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Level2.h"


@implementation Level2
- (id) init
{
	[super init];
	//allow touches.
	isTouchEnabled = YES;
	
	[self setupLayer];
	
	return self;
}

@end
