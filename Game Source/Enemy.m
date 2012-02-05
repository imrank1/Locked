//
//  Enemy.m
//  OnSlaught
//
//  Created by Imran Khawaja on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Enemy.h"
#import "Splatter.h"

@implementation Enemy
@synthesize walkAnimation;

-(Enemy * ) initWithCPBody: (cpShape *) mainBody  withManager:(SpaceManager*)spaceManager {
	
	if(self != nil){
		
		self = [Enemy spriteWithShape:mainBody file:@"sumo1.png" ];
		
	//	rightBeetle =[Beetle spriteWithShape:right file:@"beetleTiny.png"];
//		leftBeetle =[Beetle spriteWithShape:left file:@"beetleTiny.png"];
//		frontBeetle =[Beetle spriteWithShape:front file:@"beetleTiny.png"];
//		
		[self setAutoFreeShape:YES];
	//	[rightBeetle setAutoFreeShape:YES];
//		[leftBeetle setAutoFreeShape:YES];
//		[frontBeetle setAutoFreeShape:YES];
		
		[self setSpaceManager:spaceManager];
//		[rightBeetle setSpaceManager:spaceManager];
//		[leftBeetle setSpaceManager:spaceManager];
//		[frontBeetle setSpaceManager:spaceManager];
//		
		frameCount = 0;
		[self setIgnoreRotation:YES];
	
		walkAnimation = [[CCAnimation alloc] initWithName:@"walkAnimation" delay:1 ];
		
		//Add each frame to the animation
		
		
		
		[walkAnimation addFrameWithFilename:@"sumo1.png"];
		[walkAnimation addFrameWithFilename:@"sumo2.png"];
		[walkAnimation addFrameWithFilename:@"sumo3.png"];
		[walkAnimation addFrameWithFilename:@"sumo4.png"];
		[walkAnimation addFrameWithFilename:@"sumo5.png"];
		[walkAnimation addFrameWithFilename:@"sumo6.png"];
		[walkAnimation addFrameWithFilename:@"sumo7.png"];
		[walkAnimation addFrameWithFilename:@"sumo8.png"];
		[walkAnimation addFrameWithFilename:@"sumo9.png"];
		[walkAnimation addFrameWithFilename:@"sumo10.png"];
		
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
	NSLog(@"in moveFinished in Beetle");
	
	if ( self.position.x > 100 && self.position.x <200 ) 
	{
		NSLog(@"hit the soldier");
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
		//[self.spaceManager scheduleToRemoveAndFreeShape:self.shape];
		self.shape = nil;
	}
}


-(void) animate: (ccTime) dt
{	
	//reset frame counter if its past the total frames
	if(frameCount > 9) frameCount = 0;
	
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
	
	
//	if ( self.position.x == xGoal && self.position.y ==70 ){
		if (  self.position.y ==70 ){
		NSLog(@"hit the goal!");
		
	}
}


/**
 move 
 
 
 **/
-(void) move: (ccTime) dt
{	
	
	int move = arc4random() % 3;
	switch (move) {
		case 1:
			[self applyForce:cpv(500,0)];
			break;
		case 2:
			[self applyForce:cpv(-500,0)];
		default:
			[self applyForce:cpv(-500,0)];
			break;
	}
	
}


-(int) getEnergy 
{
	
	return energy;
}

-(void) setEnergy:(int)amt
{
	
	energy = amt;
}


/**
 decreaseEnergy
 
 Use to decrease Energy
 
 
 **/
-(void) decreaseEnergy:(int) amt {
	
	@synchronized(self) {
		if ( energy != 0 )
		{
			
			energy = energy - amt;
			NSLog(@"my energy is now %d",energy);
		}
	}
}


-(void) dealloc 
{
	[walkAnimation release];
	[super dealloc];
	
}
