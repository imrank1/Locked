//
//  MainMenu.m
//  OnSlaught
//
//  Created by Imran Khawaja on 2/5/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MainMenu.h"
#import "chipmunk.h"
#import "Level.h"
#import "Level2.h"

@implementation MainMenu
- (id) init {
    self = [super init];
    if (self != nil) {
		// Sprite * bg = [Sprite spriteWithFile:@"home-screen-no-buttons.png"];
        //[bg setPosition:cpv(240, 160)];
        //[self addChild:bg z:0];
        [self addChild:[MainMenuLayer node] z:1];
        //[SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.1;
		//	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.wav" loop:true];
    }
    return self;
}
@end

@implementation MainMenuLayer
- (id) init {
    self = [super init];
    if (self != nil) {
		
        [CCMenuItemFont setFontSize:20];
        [CCMenuItemFont setFontName:@"Helvetica"];
		
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"TheNextStep.wav"];
		
		CCMenuItem *startGame = [CCMenuItemFont itemFromString:@"I'm Loaded Let's Go" target:self selector:@selector(startGame:)];
		CCMenuItem *instructions = [CCMenuItemFont itemFromString:@"How to Play" target:self selector:@selector(howToPlay:)];
		[self preLoadGraphics ];
	        CCMenu *menu = [CCMenu menuWithItems:startGame,instructions, nil];
		[menu  setPosition:cpv(160, 240)];
		
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

-(void)startGame: (id)sender {
	
	Level * gs = [Level node];
	
    [[CCDirector sharedDirector] replaceScene:gs];
	}


-(void)howToPlay: (id)sender {
	//	[[Director sharedDirector] pause ];
	//	
	//	
	//		[OpenFeint launchDashboard];
	//	
	
	
	
	UIAlertView* dialog = [[[UIAlertView alloc] init] retain];
	[dialog setDelegate:self];
	[dialog setTitle:@"How To Play...."];
	[dialog setMessage: [NSString stringWithFormat:@" You're the lone survivor soldier after your ship crashed on a mysterious planet. Armed with just your M16 it's your job to protect the civilians from an OnSlaught. Touch the screen to fire at the horrendous creatures coming after you. Shake the phone to reload. Get LockednLoaded!"]];
	[dialog addButtonWithTitle:@"Cool! Let's Go!"]; 
	
	CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0,
																40.0);
	[dialog setTransform: moveUp];
	[dialog show];
	[dialog release];
	//  
	
}

-(void) preLoadGraphics 
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spider.plist"];
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bigBeetle.plist"];
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zombie.plist"];

	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"smallBeetle.plist"];
	
	
	//Bosses
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spiderboss.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"beetleBoss.plist"];
	
	
}



@end

