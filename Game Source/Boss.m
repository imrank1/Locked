//
//  Boss.m
//  OnSlaught
//
//  Created by Imran Khawaja on 3/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Boss.h"
#import "Splatter.h"

@implementation Boss
@synthesize forwardAnimation;
@synthesize backwardAnimation;

-(Boss * ) initWithCPBody: (cpShape *) mainBody  withManager:(SpaceManager*)spaceManager {
	
	if(self != nil){

	self = [Boss spriteWithShape:mainBody texture:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"spiderBoss1.png"].texture];
		[self setAutoFreeShape:YES];
	
		
		[self setSpaceManager:spaceManager];
			
		frameCount = 0;
		
		NSMutableArray *animFrames = [NSMutableArray array];
		for(int i = 1; i < 15; i++) {
			
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"spiderBoss%d.png",i]];
			[animFrames addObject:frame];
		}
		
		CCAnimation *animation = [CCAnimation animationWithName:@"forwardAnimation" delay:0.2f frames:animFrames];
		[self runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
		
		
		
		//[self setIgnoreRotation:YES];
		
		energy = 200;
		}
	
	return self;
}


/**
 
 moveFinished
 
 Called when the enemy reaches its target.
 Check for collision with soldier 
 -if hit play an animation
 reduce energy
 then remove
 -otherwise make the enemey start swinging
 
 todo
 
 **/
-(void)moveFinished:(id)sender {
		
	if ( self.position.x > 100 && self.position.x <200 ) 
	{
	
		Splatter *splatter = [[Splatter spriteWithFile:@"blood_1.png"] retain];
		splatter.position = cpv ( self.position.x,self.position.y ) ;
		[self.parent addChild: splatter z:0];
		[splatter runAction: [CCSequence actions:[CCFadeOut actionWithDuration:1],[CCCallFunc actionWithTarget:splatter selector:@selector(removeFromParent)],nil]];
		
		
		[self.parent decreaseSoldierEnergy:10];
	}
	[self cleanUpAndRemove];
	
}

-(void) cleanUpAndRemove 
{
    if ( self ) 
	{
		
		[self.parent removeChild:self cleanup:NO];
		[self.spaceManager scheduleToRemoveAndFreeShape:self.shape];
		self.shape = nil;
	}
}


@end
