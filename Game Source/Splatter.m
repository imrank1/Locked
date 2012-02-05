//
//  Splatter.m
//  GameDemo
//
//  Created by Imran Khawaja on 9/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Splatter.h"


@implementation Splatter

- (void) removeFromParent{
	//CocosNode *parent=self.parent;
	[self.parent removeChild:self cleanup:YES];
}
@end
