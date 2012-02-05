//
//  Zombie.m
//  OnSlaught
//
//  Created by Imran Khawaja on 3/1/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Zombie.h"


@implementation Zombie

-(Zombie * ) initWithCPBody: (cpShape *) mainBody  withManager:(SpaceManager*)spaceManager {
	
	if(self != nil){
		
		self = [Zombie spriteWithShape:mainBody texture:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"zombie0.png"].texture];
		[self setAutoFreeShape:YES];
		
		
		[self setSpaceManager:spaceManager];
		
		frameCount = 0;
		
		NSMutableArray *animFrames = [NSMutableArray array];
		for(int i =0; i <= 29; i++) {
			
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"zombie%d.png",i]];
			[animFrames addObject:frame];
		}
		
		CCAnimation *animation = [CCAnimation animationWithName:@"forwardAnimation" delay:2 frames:animFrames];
		[self runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
		
		
		
		//[self setIgnoreRotation:YES];
		
		energy = 200;
	
	
		xGoal = arc4random() % 315;
		// Create the actions
		id actionMove = [CCMoveTo actionWithDuration:3 position:ccp(xGoal,50)];
		id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(moveFinished:)];
		
		[self runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
		
	}
		return self;
}





/**
 move 
 
 
 **/
-(void) move: (ccTime) dt
{	
	
	int move = arc4random() % 3;
	switch (move) {
		case 1:
			[self applyForce:cpv(200,0)];
			break;
		case 2:
			[self applyForce:cpv(-200,0)];
		default:
			[self applyForce:cpv(-200,0)];
			break;
	}
	
}


-(void) dealloc 
{
	[walkAnimation release];
	[super dealloc];
	
}
@end
