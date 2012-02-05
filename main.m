//
//  main.m
//  Locked
//
//  Created by Imran Khawaja on 3/19/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	int retVal = UIApplicationMain(argc, argv, nil, @"LockedAppDelegate");
	[pool release];
	return retVal;
}
