//
//  GameSprite.m
//  GameDemo
//
//  Created by Imran Khawaja on 6/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameSprite.h"


@implementation GameSprite
@synthesize walkAnimation;

-(GameSprite * ) initWithCPBody: (cpShape *) body  withManager:(SpaceManager*)spaceManager {
	
	if(self != nil){
		
		self = [GameSprite spriteWithShape:body file:@"beetleSmall.png" ];
	
		[self setAutoFreeShape:YES];
		[self setSpaceManager:spaceManager];
		frameCount = 0;
		[self setIgnoreRotation:YES];
			
		//For some reason if you don't start the sprite with an image you can't display the			frames of an animation.
		//So we start it out with the first frame of our animation
		//	[self spriteWithFile:@"dog1.png"];
		
		//create an Animation object to hold the frame for the walk cycle
		walkAnimation = [[CCAnimation alloc] initWithName:@"walkAnimation" delay:0 ];
		
		//Add each frame to the animation
		
		
		
		[walkAnimation addFrameWithFilename:@"beetleSmall.png"];
		[walkAnimation addFrameWithFilename:@"beetleSmall.png"];
			
		//Add the animation to the sprite so it can access it's frames
		[self addAnimation:walkAnimation];

		
		[self schedule: @selector(animate:) ];
		
		[self runAction:[CCMoveTo actionWithDuration:2 position:ccp(160,70)]];
		
	/*	
		[self runAction:[RepeatForever actionWithAction:[Sequence actions:
														 [MoveTo actionWithDuration:2 position:ccp(160,70)],
														 [MoveTo actionWithDuration:2 position:ccp(160,140)], nil]]];
		*/
//		[self runAction:[RepeatForever actionWithAction:[Sequence actions:
	//															[MoveBy actionWithDuration:2 position:ccp(60,0)],
		//														[MoveBy actionWithDuration:2 position:ccp(-60,0)], nil]]];
		//[self schedule: @selector(move:)interval:1];
		//[self.parent	addChild:self];
		[self schedule: @selector(checkPosition:)interval:2];
	}
	//NSLog(@"inside Bullet initWithCpBody");
	return self;
}


-(void) animate: (ccTime) dt
{	
	//reset frame counter if its past the total frames
	if(frameCount > 1) frameCount = 0;
	
	//Set the display frame to the frame in the walk animation at the frameCount index
	[self setDisplayFrame:@"walkAnimation" index:frameCount];
	
	//Increment the frameCount for the next time this method is called
	frameCount = frameCount+1;
	
	
	
}





/**
 checkPosition 
 
 Checks to see if the dog has reached its goal
 
 **/
-(void) checkPosition: (ccTime) dt
{	
 

	if ( self.position.x == 160 && self.position.y ==70 ){
		NSLog(@"hit the goal!");
		
	}
}




-(void) dealloc 
{
	[walkAnimation release];
	[super dealloc];
	
}

@end
