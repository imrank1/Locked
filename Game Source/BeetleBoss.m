//
//  BeetleBoss.m
//  Locked
//
//  Created by Imran Khawaja on 3/28/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BeetleBoss.h"


@implementation BeetleBoss


-(BeetleBoss * ) initWithCPBody: (cpShape *) mainBody  withManager:(SpaceManager*)spaceManager {
	

	
	if(self != nil){
		
		self = [BeetleBoss spriteWithShape:mainBody texture:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bettleBoss_5.png"].texture];
		[self setAutoFreeShape:YES];
		
		
		[self setSpaceManager:spaceManager];
		
		frameCount = 0;
		
		NSMutableArray *animFrames = [NSMutableArray array];
		for(int i = 5; i <= 25; i++) {
			
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bettleBoss_%d.png",i]];
			[animFrames addObject:frame];
		}
		
		CCAnimation *animation = [CCAnimation animationWithName:@"forwardAnimation" delay:0.2f frames:animFrames];
		[self runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
		
		
		
		//[self setIgnoreRotation:YES];
		
		energy = 1600;
	}
	
	return self;
}
	
@end
