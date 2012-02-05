//
//  GameSprite.h
//  GameDemo
//
//  Created by Imran Khawaja on 6/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "cpCCSprite.h"

@interface GameSprite : cpCCSprite {

	CCAnimation *walkAnimation;
	int frameCount;
		
}

-(GameSprite *) initWithCPBody: (cpShape *) body;

@property (nonatomic, retain) CCAnimation *walkAnimation;
	
	
	
@end
	
