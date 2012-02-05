//
//  TinyBeetle.m
//  OnSlaught
//
//  Created by Imran Khawaja on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TinyBeetle.h"


@implementation TinyBeetle
//@synthesize walkAnimation;

-(TinyBeetle * ) initWithCPBody: (cpShape *) mainBody  withManager:(SpaceManager*)spaceManager {
	
	if(self != nil){
		
		if(self != nil){
			
			self = [TinyBeetle spriteWithShape:mainBody texture:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"beetle1.png"].texture];
			[self setAutoFreeShape:YES];
			
			
			[self setSpaceManager:spaceManager];
			
			frameCount = 0;
			
			NSMutableArray *animFrames = [NSMutableArray array];
			for(int i = 1; i <= 20; i++) {
				
				CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"beetle%d.png",i]];
				[animFrames addObject:frame];
			}
			
			CCAnimation *animation = [CCAnimation animationWithName:@"forwardAnimation" delay:0.2f frames:animFrames];
			[self runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
			
			
			
			//[self setIgnoreRotation:YES];
			
			energy = 50;
		}
		
	}
	//NSLog(@"inside Bullet initWithCpBody");
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
