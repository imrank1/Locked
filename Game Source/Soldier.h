//
//  Soldier.h
//  OnSlaught
//
//  Created by Imran Khawaja on 2/5/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "cpCCSprite.h"
#import "cpCCNode.h"

@interface Soldier : cpCCSprite<cpCCNodeProtocol> {
	
	//animation to play when the level completes
	CCAnimation *levelCompleteAnim;
	//animation to play when the soldier dies
	CCAnimation *deathAnimation;
	//energy starts at 100
	int energy ;
	//array to hold energy bar graphics.
	NSMutableArray *healthBars;
	int bullets ;

}
-(void) initHealth ;
@property (nonatomic, retain) CCAnimation *levelCompleteAnim;
@property (nonatomic, retain) CCAnimation *deathAnimation;
//@property int energy;
//@property int bullets;

@end
