//
//  Soldier.m
//  OnSlaught
//
//  Created by Imran Khawaja on 2/5/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Soldier.h"


@implementation Soldier
//@synthesize bullets;
//@synthesize energy;


-(Soldier * ) initWithCPBody: (cpShape *) body  withManager:(SpaceManager*)spaceManager {
	
	if(self != nil){
		
		self = [Soldier spriteWithShape:body file:@"soldier.png" ];
		bullets = 100;
		energy = 100;
		[self setAutoFreeShape:YES];
		[self setSpaceManager:spaceManager];
		
		
			}

	return self;
}

-(void) initHealth 
{
	
	healthBars = [[NSMutableArray alloc] init];
	int yPos =400;
	for (int i = 1; i<11; i++) {
		 CCSprite *hbar = [CCSprite spriteWithFile:@"health_bar.png"];
		[healthBars addObject: hbar];
		[hbar setPosition:cpv(300,yPos)];
		[self.parent addChild:hbar];
		yPos += 5;
//		NSLog(@"added health bar %d",i);
	}
	
}

-(int) getBullets 
{
	
	return bullets;
}

-(void) setBullets:(int)amt
{
	bullets = amt;
	
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
		CCSprite *hbar = [healthBars objectAtIndex: [healthBars count] -1];  
		// take out the last one
		if ( hbar )
		{
			[hbar setVisible:NO];
			[healthBars removeObjectAtIndex:[healthBars count] -1];
			[self.parent removeChild:hbar cleanup:YES];
		}
	}
	}
}

/**
 
 decreaseBullets 
 
 Use to decrease soldier bullets
 
 
 **/
-(void) decreaseBullets:(int) amt {
	
	bullets = bullets - amt;
}



@end
