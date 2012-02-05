//
//  LockedAppDelegate.m
//  Locked
//
//  Created by Imran Khawaja on 3/19/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "LockedAppDelegate.h"
#import "cocos2d.h"
#import "MainMenu.h"

@implementation LockedAppDelegate
#pragma mark GameDelegate Methods
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[application setIdleTimerDisabled:YES];
	
	// NEW: Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	//[Director useFastDirector];
	//[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	//[[Director sharedDirector] setDisplayFPS:YES];
	
	[[CCDirector sharedDirector] attachInWindow:window];	
	
	[window makeKeyAndVisible];
	
	//Scene *game = [Scene node];
	//MenuScene *menu = [MenuScene node];
	//GameLayer *layer = [GameLayer node];
	//[game addChild:menu];
	[[CCDirector sharedDirector] runWithScene:[MainMenu node]];
	//	[[Director sharedDirector] runWithScene:menu];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
}

-(void)dealloc
{
	[window release];
	[super dealloc];
}


-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}


-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	//[[TextureMgr sharedTextureMgr] removeAllTextures];
}


@end

