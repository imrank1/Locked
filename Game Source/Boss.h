//
//  Boss.h
//  OnSlaught
//
//  Created by Imran Khawaja on 3/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "cpCCSprite.h"
#import "Enemy.h"

@interface Boss : Enemy {
	CCAnimation *forwardAnimation;
	CCAnimation *backwardAnimation;
//	int frameCount;
//	int energy;
}
-(Boss * ) initWithCPBody: (cpShape *) mainBody withManager:(SpaceManager*)spaceManager;
-(void) decreaseEnergy:(int) amt;
-(int) getEnergy ;
@property (nonatomic, retain) CCAnimation *forwardAnimation;
@property (nonatomic, retain) CCAnimation *backwardAnimation;
@end
