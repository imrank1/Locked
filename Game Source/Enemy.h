//
//  Enemy.h
//  OnSlaught
//
//  Created by Imran Khawaja on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "cpCCSprite.h"

@interface Enemy : cpCCSprite {
	CCAnimation *walkAnimation;
	int frameCount;
	int xGoal;
	int energy;
	
}

//-(Beetle *) initWithCPBody: (cpShape *) body;
-(Enemy * ) initWithCPBody: (cpShape *) mainBody withManager:(SpaceManager*)spaceManager;
-(void) decreaseEnergy:(int) amt;
-(int) getEnergy ;
@property (nonatomic, retain) CCAnimation *walkAnimation;

@end
