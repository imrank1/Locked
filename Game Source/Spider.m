//
//  Spider.m
//  OnSlaught
//
//  Created by Imran Khawaja on 3/1/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Spider.h"


@implementation Spider
-(Spider * ) initWithCPBody: (cpShape *) mainBody  withManager:(SpaceManager*)spaceManager {
	
	if(self != nil){
		
		self = [Spider spriteWithShape:mainBody file:@"spider1.png"];
		
		[self setAutoFreeShape:YES];
		
		[self setSpaceManager:spaceManager];
		frameCount = 0;
		[self setIgnoreRotation:YES];
		walkAnimation = [[CCAnimation alloc] initWithName:@"walkAnimation" delay:0 ];
		
		//Add each frame to the animation
		
		
		
		[walkAnimation addFrameWithFilename:@"spider1.png"];
		[walkAnimation addFrameWithFilename:@"spider2.png"];
		[walkAnimation addFrameWithFilename:@"spider3.png"];
		[walkAnimation addFrameWithFilename:@"spider4.png"];
		[walkAnimation addFrameWithFilename:@"spider5.png"];
		[walkAnimation addFrameWithFilename:@"spider6.png"];
		[walkAnimation addFrameWithFilename:@"spider7.png"];
		[walkAnimation addFrameWithFilename:@"spider8.png"];
		[walkAnimation addFrameWithFilename:@"spider9.png"];
		[walkAnimation addFrameWithFilename:@"spider10.png"];
		[walkAnimation addFrameWithFilename:@"spider11.png"];
		[walkAnimation addFrameWithFilename:@"spider12.png"];
		[walkAnimation addFrameWithFilename:@"spider13.png"];
		[walkAnimation addFrameWithFilename:@"spider14.png"];
		[walkAnimation addFrameWithFilename:@"spider15.png"];
		
		
		//Add the animation to the sprite so it can access it's frames
		[self addAnimation:walkAnimation];
		energy = 100;
		
		[self schedule: @selector(animate:) ];
		xGoal = arc4random() % 315;
		// Create the actions
		id actionMove = [CCMoveTo actionWithDuration:5 position:ccp(xGoal,50)];
		id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(moveFinished:)];
		
		[self runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
		
	}
	//NSLog(@"inside Bullet initWithCpBody");
	return self;
}




-(void) animate: (ccTime) dt
{	
	//reset frame counter if its past the total frames
	if(frameCount > 14) frameCount = 0;
	
	//Set the display frame to the frame in the walk animation at the frameCount index
	[self setDisplayFrame:@"walkAnimation" index:frameCount];
	
	//Increment the frameCount for the next time this method is called
	frameCount = frameCount+1;
	
	
	
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
