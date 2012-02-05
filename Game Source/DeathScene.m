//
//  DeathScene.m
//  OnSlaught
//
//  Created by Imran Khawaja on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "DeathScene.h"
#import "MainMenu.h"
#import "chipmunk.h"


@implementation DeathScene
- (id) init {
    self = [super init];
    if (self != nil) {
		// Sprite * bg = [Sprite spriteWithFile:@"home-screen-no-buttons.png"];
        //[bg setPosition:cpv(240, 160)];
        //[self addChild:bg z:0];
        [self addChild:[DeathSceneLayer node] z:1];
        //[SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.1;
		//	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.wav" loop:true];
    }
    return self;
}
@end

@implementation DeathSceneLayer
- (id) init {
    self = [super init];
    if (self != nil) {
		
        [CCMenuItemFont setFontSize:20];
        [CCMenuItemFont setFontName:@"Helvetica"];
		
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"TheNextStep.wav"];
		
		CCMenuItem *startGame = [CCMenuItemFont itemFromString:@"You Died!" target:self selector:@selector(startGame:)];
		CCMenuItem *restart = [CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(mainMenu:)];
		
		
		//  MenuItem *worldTour = [MenuItemImage itemFromNormalImage:@"world-tour.png" selectedImage:@"world-tour-dark.png"
		//														  target:self
		//														selector:@selector(startWorldTour:)];
		//		MenuItem *arcade = [MenuItemImage itemFromNormalImage:@"arcade-mode.png" selectedImage:@"arcade-mode-dark.png"
		//													   target:self
		//													 selector:@selector(startArcade:)];
		//		
		//MenuItem *goldrush = [MenuItemFont itemFromString:@"GoldRush"
		//												 target:self
		//											   selector:@selector(startGoldRush:)];
		//		
		// MenuItem *help = [MenuItemImage itemFromNormalImage:@"help-1.png" selectedImage:@"help-1-dark.png"
		//													 target:self
		//												   selector:@selector(help:)];
		//		MenuItem *hScore = [MenuItemImage itemFromNormalImage:@"high-score.png" selectedImage:@"high-score-dark.png"
		//													   target:self
		//													 selector:@selector(highScores:)];
        CCMenu *menu = [CCMenu menuWithItems:startGame,restart, nil];
		[menu  setPosition:cpv(160, 240)];
		
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

-(void)startGame: (id)sender {
		
}


-(void)mainMenu: (id)sender {
//	[[Director sharedDirector] runWithScene:[MainMenu node]];
	MainMenu *main = [MainMenu node];
	///[Director useFastDirector];
    [[CCDirector sharedDirector] replaceScene:main];	
}

@end
