#import "Level.h"
#import "cpConstraintNode.h"
#import "cpShapeNode.h"
//#import "Bullet.h"
#import "Splatter.h"
#import "GameSprite.h"
#import "SimpleAudioEngine.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "Enemy.h"
#import "TinyBeetle.h"
#import "DeathScene.h"
#import "Spider.h"
#import "Zombie.h"
#import "Boss.h"
#import "BeetleBoss.h"
#import "BigBeetle.h"
#import "Level2.h"
#define PI 3.14159265


@interface Level (PrivateMethods)
- (void) setupLayer;

@end

#define kBallCollisionType		1
#define kBulletCollisionType	2
#define kBoundaryCollisionType	3
#define kEnemyCollisionType     4
#define kLowerBoundaryCollisionType	5

#define kSoldierCollisionType	 6

#define kAccelerationThreshold 2.2
#define kUpdateInterval (1.0f/10.0f)

@implementation Level


/**
 init
 
 This is my Level's constructor. 
 
 
 
 **/
 
- (id) init
{
	[super init];
	//allow touches.
	isTouchEnabled = YES;
	
	[self setupLayer];

	return self;
}

/**
 
 dealloc
 
 The deconstructor. 
 
 TODO: Am I releasing everythign correctly?
 
 **/
- (void) dealloc
{	
	[smgr stop];
	[smgr release];
	[super dealloc];
}


-(void) setBackGround 
{
	
	CCSprite *bg = [[CCSprite spriteWithFile:@"background_2.jpg"]retain];
	[bg setPosition:cpv(160,240)];
	[self addChild:bg];
	
}


/**
 setupLayer
 
 This is the main method that sets up the layer. 
 
 1. Sets up the physics engine
 2. Sets the soldier on the screen
 3. Schedules calls to makeDogs to spawn enemies. 
 
 
 **/
- (void) setupLayer
{
	//Set up the physicis object
	smgr = [[SpaceManager alloc] init];
	//Set up the gravity. 
//	[smgr setGravity:cpv(0, -3.8*10)];
	[smgr setGravity:cpv(0, 0)];

	[self setBackGround];
	
		
	smgr.constantDt = 1.0/55.0;
	//Set up a sprite to represent my soldier. 
	//soldier = [[Sprite spriteWithFile:@"soldier.png"] retain];
	soldierBody = [smgr addRectAt:cpv(150,50) mass:STATIC_MASS width:50 height:50 rotation:0];
	soldierBody->collision_type = kSoldierCollisionType;
	
	
   soldier = [[Soldier alloc] initWithCPBody:soldierBody withManager:smgr];	
	 soldier.position = cpv(150,50);
	[self addChild:soldier];
	[soldier initHealth];
	
	//initialize my count of available bullets. 
	[soldier setBullets:100];
	
	//set up a label on the screen to show the number of bullets available. 
	bulletsAvailable = [CCLabel labelWithString: [NSString stringWithFormat:@" Bullets %d", [soldier getBullets] ]dimensions: CGSizeMake(180, 20) alignment: UITextAlignmentRight fontName:@"Arial" fontSize:20];	
reloadLabel = [CCLabel labelWithString: [NSString stringWithFormat:@" RELOAD!"] dimensions: CGSizeMake(180, 20) alignment: UITextAlignmentRight fontName:@"Arial" fontSize:20];	
timerLabel = [CCLabel labelWithString: [NSString stringWithFormat:@" Time %2.2f", timer]dimensions: CGSizeMake(180, 20) alignment: UITextAlignmentRight fontName:@"Arial" fontSize:20];		
energyLabel = [CCLabel labelWithString: [NSString stringWithFormat:@" Energy %d", [soldier getEnergy] ]dimensions: CGSizeMake(180, 20) alignment: UITextAlignmentRight fontName:@"Arial" fontSize:20];		
		
	gameOverLabel = [CCLabel labelWithString: [NSString stringWithFormat:@"Game Over"]dimensions: CGSizeMake(180, 20) alignment: UITextAlignmentRight fontName:@"Arial" fontSize:20];	
	
	[bulletsAvailable setPosition: cpv(180,20)]; 
	[reloadLabel setPosition:cpv(150,350)];
	[timerLabel setPosition:cpv(190,460) ];
	[energyLabel setPosition:cpv(40,20)];
	[gameOverLabel setPosition:cpv(160,240)];
	
	//add the label and soldier to the layer. 
	[self addChild:bulletsAvailable];
	[self addChild:reloadLabel];
	[self addChild:timerLabel];
	[self addChild:energyLabel];
	[self addChild:gameOverLabel];
	[reloadLabel setVisible:NO];
	[gameOverLabel setVisible:NO];

	
	
	
 
		
	
	//Set up invisible boundaries on the screen 
	upperRect = [smgr addRectAt:cpv(160,550) mass:STATIC_MASS width:330 height:1 rotation:0];
	
	leftRect = [smgr addRectAt:cpv(0,240) mass:STATIC_MASS width:1 height:495 rotation:0];

	rightRect = [smgr addRectAt:cpv(320,240) mass:STATIC_MASS width:1 height:495 rotation:0];
	
	lowerRect = [smgr addRectAt:cpv(160,0) mass:STATIC_MASS width:330 height:1 rotation:0];
	
	//Set collision types for them. 
	upperRect->collision_type = kBoundaryCollisionType;
	leftRect->collision_type = kBoundaryCollisionType;
	rightRect->collision_type = kBoundaryCollisionType;
	lowerRect->collision_type =kLowerBoundaryCollisionType;
	
	
	
	//start the physics engine.
	[smgr start]; 	
	
	[smgr addCollisionCallbackBetweenType:kSoldierCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemyAndSoldier:arbiter:space:)];
	
	//bullets should not collide with the lowerboundary
	[smgr ignoreCollionBetweenType:kBulletCollisionType otherType:kLowerBoundaryCollisionType ];
	//bullets should not collide with the player ..this should never happen anyways
		[smgr ignoreCollionBetweenType:kBulletCollisionType otherType:kSoldierCollisionType ];
	//bullets should not collide with each other. 
		[smgr ignoreCollionBetweenType:kBulletCollisionType otherType:kBulletCollisionType ];
	//enemies should not collide with each other
	//[smgr ignoreCollionBetweenType:kEnemyCollisionType otherType:kEnemyCollisionType ];
	
	
	//setup sounds
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"m16.mp3"];


	[self startLevelSpecifics];
	//Start timer indicator
	[self schedule: @selector(step:)];
	
}


/**
 Use this function overloaded for level specifics
 
 
 **/
-(void) startLevelSpecifics 
{
	
	//Start a schedular to make an enemey
	[self schedule: @selector(makeBeetle:) interval:3];
	[self schedule: @selector(makeSpiders:) interval:2];
	//[self schedule: @selector(makeZombies:) interval:4];
	//[self makeBoss];
	
	//	[self makeBeetleBoss];
	
}
/**
 
 Updates the timer
 
 
 **/
-(void) step:(ccTime) delta 
{
 timer+=delta;	
	[timerLabel setString:[NSString stringWithFormat:@"Timer %2.0f", timer]];
	
	if ( [soldier getEnergy] == 0 ) 
	{
		//soldier died
		//play somthing to show the soldier dieing...
		//[[Director sharedDirector] pause];
		
		[gameOverLabel setVisible:YES];
		DeathScene *deathScene = [[DeathScene alloc] init] ;
		[[CCDirector sharedDirector] replaceScene:deathScene];
		
	}
	
	if ( timer > 5 && bossReleased == NO) 
	{
		//[self unschedule:@selector(makeSpiders:)];
	//	[self unschedule:@selector(makeBeetle:)];
		[self makeSpiderBoss];
		bossReleased = YES;
	}
	
	if ( bossReleased ) 
	{
		if ( [boss getEnergy] == 0 ) 
		{
			//advance to next level...
			
			[CCMenuItemFont setFontSize:20];
			[CCMenuItemFont setFontName:@"Helvetica"];
			
			//[[SimpleAudioEngine sharedEngine] preloadEffect:@"TheNextStep.wav"];
			
			CCMenuItem *nextLevel = [CCMenuItemFont itemFromString:@"Level 2" target:self selector:@selector(startLevel2:)];			
			
			
			CCMenu *menu = [CCMenu menuWithItems:nextLevel, nil];
			[menu  setPosition:cpv(160, 240)];
			
			[menu alignItemsVertically];
			[self addChild:menu];
			
		}
		 
		
		
	}

	
	
	 
}
-(void)startLevel2: (id)sender {
	
	Level2 * gs = [Level2 node];
	///[Director useFastDirector];
    [[CCDirector sharedDirector] replaceScene:gs];
	//[appStoreUrl release];
}

/**
 decreaseSoldierEnergy
 
 Use to decrease Energy
 
 
 **/
-(void) decreaseSoldierEnergy:(int) amt {
	[soldier decreaseEnergy:10];
}

/**
 
 makeBeetle 
 
 
 makes beetles and places them on screen....at randomn x positions. 
 
 
 **/
-(void) makeBeetle:(ccTime) delta 
{
	int xpSwitch = (arc4random() % 3) + 1;
	int xPos;
	int yPos;
	switch (xpSwitch) {
		case 1:
			xPos = -100;
			yPos = (arc4random() % 50) + 490;
			break;
		case 2:
			xPos=370;
			yPos = (arc4random() % 50) + 490;
			break;
		case 3:
			xPos= arc4random ( ) % 320 ;
			yPos = 500;
			break;
			
		default:
			xPos= arc4random ( ) % 320 ;
			yPos= 500;
	}
	
	cpShape *beetle = [smgr addRectAt:cpv(xPos,yPos) mass:STATIC_MASS width:100 height:100 rotation:0];
	
	cpShape *rightBeetle = [smgr addRectAt:cpv(xPos+50,yPos) mass:STATIC_MASS width:50 height:70 rotation:0];
	
	cpShape *leftBeetle = [smgr addRectAt:cpv(xPos-50,yPos) mass:STATIC_MASS width:50 height:70 rotation:0];
	
	
	beetle->collision_type = kEnemyCollisionType;
	
	rightBeetle->collision_type = kEnemyCollisionType;
	leftBeetle->collision_type = kEnemyCollisionType;
		
	
	TinyBeetle *rBeetle =[[TinyBeetle alloc] initWithCPBody:rightBeetle withManager:smgr];
	
	TinyBeetle *lBeetle =[[TinyBeetle alloc] initWithCPBody:leftBeetle withManager:smgr];
		
	
	BigBeetle *bigBeetle = [[BigBeetle alloc] initWithCPBody:beetle withManager:smgr];
	//connect up a collision handler between bullets and dogs
	[smgr addCollisionCallbackBetweenType:kBulletCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemy:arbiter:space:)];
	
	
	[smgr addCollisionCallbackBetweenType:kLowerBoundaryCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemyHitGoal:arbiter:space:)];
	
	//add the dog to the layer. 
	[self addChild:bigBeetle];
	
	[self addChild:rBeetle];
	[self addChild:lBeetle];

	
	int xGoal = arc4random() % 315;
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:5 position:ccp(xGoal,50)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(moveFinished:)];
	
	[bigBeetle runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	id rightActionMove = [CCMoveTo actionWithDuration:5 position:ccp(xGoal+50,50)];
	id rightActionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(moveFinished:)];
	[rBeetle runAction:[CCSequence actions:rightActionMove, rightActionMoveDone, nil]];
	id leftActionMove = [CCMoveTo actionWithDuration:5 position:ccp(xGoal-50,50)];
	id leftActionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(moveFinished:)];
	[lBeetle runAction:[CCSequence actions:leftActionMove, leftActionMoveDone, nil]];
}


-(void)moveFinished:(id)sender {
	
	Enemy *enemy = (Enemy*) sender;
	if ( enemy.position.x > 100 && enemy.position.x <200 ) 
	{
		Splatter *splatter = [[Splatter spriteWithFile:@"blood_1.png"] retain];
		splatter.position = cpv ( enemy.position.x,enemy.position.y ) ;
		[enemy.parent addChild: splatter z:0];
		[splatter runAction: [CCSequence actions:[CCFadeOut actionWithDuration:1],[CCCallFunc actionWithTarget:splatter selector:@selector(removeFromParent)],nil]];
		
		
	}
	[enemy cleanUpAndRemove];
	
}


/**
 
 makeSpiders 
 
 
 makes spiders and places them on screen....at randomn x positions. 
 
 
 **/
-(void) makeSpiders:(ccTime) delta 
{
	int xpSwitch = (arc4random() % 3) + 1;
	int xPos;
	int yPos;
	switch (xpSwitch) {
		case 1:
			xPos = -100;
			yPos = (arc4random() % 50) + 490;
			break;
		case 2:
			xPos=370;
			yPos = (arc4random() % 50) + 490;
			break;
		case 3:
			xPos= arc4random ( ) % 320 ;
			yPos = 500;
			break;
			
		default:
			xPos= arc4random ( ) % 320 ;
			yPos= 500;
	}
	
	cpShape *spider = [smgr addRectAt:cpv(xPos,yPos) mass:STATIC_MASS width:100 height:100 rotation:0];
	
		spider->collision_type = kEnemyCollisionType;
	
	
	Spider *mySpider =[[Spider alloc] initWithCPBody:spider  withManager:smgr];
	
	
	[smgr addCollisionCallbackBetweenType:kBulletCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemy:arbiter:space:)];
	
	
	[smgr addCollisionCallbackBetweenType:kLowerBoundaryCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemyHitGoal:arbiter:space:)];
	
	//add the dog to the layer. 
	[self addChild:mySpider];
		
	
}


-(void) makeBossChildSpiders:(id)sender {

	
	
	cpShape *spider1 = [smgr addRectAt:cpv(150,350) mass:STATIC_MASS width:100 height:100 rotation:0];
	cpShape *spider2 = [smgr addRectAt:cpv(155,350) mass:STATIC_MASS width:100 height:100 rotation:0];
	cpShape *spider3 = [smgr addRectAt:cpv(160,350) mass:STATIC_MASS width:100 height:100 rotation:0];
	
	
	spider1->collision_type = kEnemyCollisionType;
	spider2->collision_type = kEnemyCollisionType;
	spider3->collision_type = kEnemyCollisionType;
	
	Spider *mySpider1 =[[Spider alloc] initWithCPBody:spider1  withManager:smgr];
	Spider *mySpider2 =[[Spider alloc] initWithCPBody:spider2  withManager:smgr];
	Spider *mySpider3 =[[Spider alloc] initWithCPBody:spider3  withManager:smgr];
	
	
	[smgr addCollisionCallbackBetweenType:kBulletCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemy:arbiter:space:)];
	
	
	[smgr addCollisionCallbackBetweenType:kLowerBoundaryCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemyHitGoal:arbiter:space:)];
	
	//add the dog to the layer. 
	[self addChild:mySpider1];
	[self addChild:mySpider2];
	[self addChild:mySpider3];
	
	
}



-(void) makeBeetleBoss
{
	
	
	cpShape *bossShape = [smgr addRectAt:cpv(160,500) mass:STATIC_MASS width:100 height:100 rotation:0];
	
	bossShape->collision_type = kEnemyCollisionType;
	
	
	boss =[[BeetleBoss alloc] initWithCPBody:bossShape  withManager:smgr];
	
	
	
	[smgr addCollisionCallbackBetweenType:kBulletCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemy:arbiter:space:)];
	
	
	[smgr addCollisionCallbackBetweenType:kLowerBoundaryCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemyHitGoal:arbiter:space:)];
	
	[boss setPosition:cpv(160,400)];
	//add the dog to the layer. 
	[self addChild:boss];
	
}


/**
 
 makeBoss
  
 **/
-(void) makeSpiderBoss
{
	
	
	cpShape *bossShape = [smgr addRectAt:cpv(160,500) mass:STATIC_MASS width:100 height:100 rotation:0];
	
	bossShape->collision_type = kEnemyCollisionType;
	
	
	boss =[[Boss alloc] initWithCPBody:bossShape  withManager:smgr];
	
	
	[smgr addCollisionCallbackBetweenType:kBulletCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemy:arbiter:space:)];
	
	
	[smgr addCollisionCallbackBetweenType:kLowerBoundaryCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemyHitGoal:arbiter:space:)];
	[boss setPosition:cpv(160,600)];
	//add the dog to the layer. 
	[self addChild:boss];
	// Create the actions
	id actionMoveCenter = [CCMoveTo actionWithDuration:2 position:ccp(160,400)];
	id actionMoveRight = [CCMoveTo actionWithDuration:2 position:ccp(600,300)];
	id actionMoveLeft = [CCMoveTo	actionWithDuration:2 position:ccp(-600,300)];
	id rotateRight =  [CCRotateBy actionWithDuration:0.5  angle:-90];
	id rotateUpLeft =  [CCRotateBy actionWithDuration:0.5  angle:-225];
	id rotateLeftDown = [CCRotateBy actionWithDuration:0.5 angle:-315];
	id rotateReset = [CCRotateBy actionWithDuration:0.5 angle:-45];
	id actionMoveUp = [CCMoveTo actionWithDuration:2 position:ccp(160,600)];
	id makeChildSpiders = [CCCallFuncN actionWithTarget:self selector:@selector(makeBossChildSpiders:)];
	
	id actionMove = [CCRepeatForever actionWithAction:[CCSequence actions:actionMoveCenter,/* makeChildSpiders,*/rotateRight,actionMoveRight,rotateUpLeft,actionMoveUp,rotateLeftDown,actionMoveLeft,rotateRight,actionMoveCenter,nil]];
	
	
	[boss runAction:actionMove];
	
}



/**
 
 makeZombies
 
 
 makes zombies and places them on screen....at randomn x positions. 
 
 
 **/
-(void) makeZombies:(ccTime) delta 
{
	
	int xpSwitch = (arc4random() % 3) + 1;
	int xPos;
	int yPos;
	switch (xpSwitch) {
		case 1:
			xPos = -100;
			yPos = (arc4random() % 50) + 490;
			break;
		case 2:
			xPos=370;
			yPos = (arc4random() % 50) + 490;
			break;
		case 3:
			xPos= arc4random ( ) % 320 ;
			yPos = 500;
			break;
			
		default:
			xPos= arc4random ( ) % 320 ;
			yPos= 500;
	}
	
	//create the dog shape
	cpShape *zBody = [smgr addRectAt:cpv(xPos,yPos) mass:STATIC_MASS width:100 height:100 rotation:0];
	
	zBody->collision_type = kEnemyCollisionType;
	
	
	Zombie *zombie =[[Zombie alloc] initWithCPBody:zBody  withManager:smgr];
	
	
	[smgr addCollisionCallbackBetweenType:kBulletCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemy:arbiter:space:)];
	
	
	[smgr addCollisionCallbackBetweenType:kLowerBoundaryCollisionType 
								otherType:kEnemyCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithEnemyHitGoal:arbiter:space:)];
	
	//add the dog to the layer. 
	[self addChild:zombie];
	
	
}



#pragma mark Touch Functions

/**
 
 ccTouchesBegan 
 
 Handles the touches on the screen 
 
 1) Rotates the soldier graphic in the direction that the user touched
 2) Fires a bullet in the direction that the user touched.
 
 
 - (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {	
 //Calculate a vector based on where we touched and where the ball is
 CGPoint pt = [self convertTouchToNodeSpace:[touches anyObject]];
 CGPoint forceVect = ccpSub(pt, ballSprite.position);
 
 //cpFloat len = cpvlength(forceVect);
 //cpVect normalized = cpvnormalize(forceVect);
 
 //This applys a one-time force, pretty much like firing a bullet
 [ballSprite applyImpulse:ccpMult(forceVect, 1)];
 
 return YES;
 }
 
 

 **/


- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	//Calculate a vector based on where we touched and where the ball is
	//UITouch *touch = [touches anyObject];
	CGPoint point = [self convertTouchToNodeSpace:[touches anyObject]];
    
    //point =  [[CCDirector sharedDirector] convertCoordinate: point];
	double x1 = 140 ;
	double y1 = 90;
	double y2 = point.y;
	double x2 = point.x;
	
	double soldierAngle ;
	
	
	cpVect gunPos ;
	gunPos = cpv ( 140,90 ) ;
	
	/*
	if ( y2 < 50 && x2 <150) 
	{
		//prevent from rotating past -90 degrees
		gunPos = cpv ( 165,70 ) ;
		
	}
	else if  ( y2 < 50 && x2 >150) 
	{
		// prevent from rotating past 90 degrees
		gunPos = cpv ( 165,45 ) ;
	}
	else if ( x2 < 150 ) 
	{
		//if user touched greater than 150 
		gunPos = cpv ( 165,60 ) ;
		
	}
	else if ( x2 > 150 ) 
	{
		//if user touched less than 180
		gunPos = cpv ( 165,45 ) ;
		
		
	}
	*/
	
	
	soldierAngle = atan2 ( (x2-x1),(y2-y1))*180/PI;
	
	[soldier runAction:[CCRotateTo actionWithDuration:0
											  angle:soldierAngle]];
	
	//if i have bullets available
	if ( [soldier getBullets ] >0)
	{
		
		//create a bullet and fire it in the direction of the touch. 
		CGPoint pt = [self convertTouchToNodeSpace:[touches anyObject]];
		CGPoint forceVect = ccpSub(pt, gunPos);

			
	//	cpShape *bullet = [smgr addCircleAt:gunPos mass:0.5 radius:5 ];
		
		
	cpShape *bullet = 	[smgr addRectAt:gunPos mass:5 width:5 height:5 rotation:-CC_DEGREES_TO_RADIANS(soldierAngle)];

		
			bullet->collision_type = kBulletCollisionType;
	        
			cpCCSprite *ballS= [ cpCCSprite spriteWithShape:bullet file:@"bullet.png"];
		//[ballS ignoreRotation:YES];
		//create a collision handler between the bullet and the boundary. 
		[smgr addCollisionCallbackBetweenType:kBoundaryCollisionType 
								otherType:kBulletCollisionType 
								   target:self 
									 selector:@selector(handleCollisionWithBullet:arbiter:space:)];
	
	
		[self addChild:ballS];
	//[[SimpleAudioEngine sharedEngine] playEffect:@"m16.mp3"];
		[ballS applyForce:ccpMult(forceVect, 40)];
		[soldier decreaseBullets:1];
		
		[self updateBulletCount ];
		
	}
	
	
	return YES;

	
}


-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event	{
	
	[self ccTouchesBegan:touches withEvent:event];
}


/**
 Update Bullets Count 
 
 Decrements the bullet count and updates the view. Also initialzes listening of the accelerometer to listen for shakes when player is out of bullets. 
 
 **/
-(void) updateBulletCount 
{

	
	[bulletsAvailable setString:[NSString stringWithFormat:@"Bullets %d", [soldier getBullets]]];
	

	
	if ( [soldier getBullets] == 0 )
	{
		
	  
		//[self addChild:reloadLabel];
		[reloadLabel setVisible:YES];
		UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
		accel.delegate = self;
		accel.updateInterval = kUpdateInterval;
		
	}
	
}
 
/**
 
 Handles shaking of the device to relaod bullets. 

 
 **/
-(void)accelerometer:(UIAccelerometer *)accelerometer
didAccelerate:(UIAcceleration *)acceleration 
{
	if ( [soldier getBullets] == 0 ) 
	{
		if ( acceleration.x > kAccelerationThreshold 
			|| acceleration.y > kAccelerationThreshold
			|| acceleration.z > kAccelerationThreshold ) 
		{
			[soldier setBullets:100] ;
			[reloadLabel setVisible:NO];
		//	[self removeChild:reloadLabel cleanup:NO];
			[self removeChild:bulletsAvailable	cleanup:NO];
			bulletsAvailable = [CCLabel labelWithString: [NSString stringWithFormat:@" Bullets %d", [soldier getBullets]] dimensions: CGSizeMake(180, 20) alignment: UITextAlignmentRight fontName:@"Arial" fontSize:20];		
			[bulletsAvailable setPosition: cpv(180,20)]; 
			//	[bulletsAvailable setRGB:0:0:0];
			[self addChild:bulletsAvailable];
		}
		
		
	}
	
}
 


/************** COLLISION HANDLING***********************/


/****
 The following function handles collisions with bullets and the game boundary 
 ie it gets rid of bullets that go off the screen 
 
 ******/
 
- (int) handleCollisionWithBullet:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	
	if ( moment == COLLISION_BEGIN ) 
	{
	CP_ARBITER_GET_SHAPES(arb,boundary,bullet);
	
	cpCCSprite* sprite = (cpCCSprite*)bullet->data;
	
	if (sprite)
	{
		[sprite.parent removeChild:sprite cleanup:NO];
		//[smgr scheduleToRemoveAndFreeShape:bullet];
		bullet->data = nil;
	}
			}
	return YES;
}


- (int) handleCollisionWithEnemyHitGoal:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	
	if ( moment == COLLISION_BEGIN ) 
	{
	CP_ARBITER_GET_SHAPES(arb,boundary,enemyHitGoal);
	
	//NSLog(@"Had a Collision!");
	cpCCSprite* sprite = (cpCCSprite*)enemyHitGoal->data;
	
	if (sprite)
	{
		[sprite.parent removeChild:sprite cleanup:NO];
		[smgr scheduleToRemoveAndFreeShape:enemyHitGoal];
		enemyHitGoal->data = nil;
	}
	
	//NSLog(@"Dog hit the boundary!");
	}
	return YES;
}



/****
 The following function handles collisions with bullets and the enemies 
 
 
 ******/
- (int) handleCollisionWithEnemy:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	
	if ( moment == COLLISION_BEGIN ) 
	{
		
	
	CP_ARBITER_GET_SHAPES(arb,shape,enemy);
	
		
		
	Enemy* sprite = (Enemy*)enemy->data;
	[sprite decreaseEnergy:50];
	
	id tintAction = [CCTintBy actionWithDuration:0.5 red:139 green:35 blue:35];
	[sprite runAction:tintAction];
	if ( [sprite getEnergy] == 0 )
	{
	
		if (sprite)
		{
			[sprite.parent removeChild:sprite cleanup:NO];
			//[smgr scheduleToRemoveAndFreeShape:enemy];
			enemy->data = nil;
			int rSplatter = (arc4random() % 4) + 1;
			Splatter *splatter;
			switch (rSplatter) {
				case 1:
					splatter = [[Splatter spriteWithFile:@"blood_1.png"] retain];
					break;
				case 2:
					splatter = [[Splatter spriteWithFile:@"blood_2.png"] retain];
					break;
				case 3:
					splatter = [[Splatter spriteWithFile:@"blood_3.png"] retain];
					break;
				case 4:
					splatter = [[Splatter spriteWithFile:@"blood_4.png"] retain];
					break;
				default:
					break;
			}
			splatter.position = cpv ( arb->contacts->p.x, arb->contacts->p.y ) ;
			[self addChild: splatter z:0];
			[splatter runAction: [CCSequence actions:[CCFadeOut actionWithDuration:1],[CCCallFunc actionWithTarget:splatter selector:@selector(removeFromParent)],nil]];
		}
		
	}
		
		CCSprite* shapeSprite = (CCSprite*)shape->data;
		if (shapeSprite)
		{
			[shapeSprite.parent removeChild:shapeSprite cleanup:NO];
			//[smgr scheduleToRemoveAndFreeShape:shape];
			shape->data = nil;
		}
		
		
				}
	return YES;
	
}

/****
 The following function handles collisions with the soldier and the enemies 
 
 
 ******/
- (int) handleCollisionWithEnemyAndSoldier:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	
	if ( moment == COLLISION_BEGIN ) 
	{
	CP_ARBITER_GET_SHAPES(arb, shape, enemyAndSoldier);
	
	cpCCSprite* sprite = (cpCCSprite*)enemyAndSoldier->data;
	if (sprite)
	{
		[sprite.parent removeChild:sprite cleanup:NO];
		[smgr scheduleToRemoveAndFreeShape:enemyAndSoldier];
		enemyAndSoldier->data = nil;
	}
	/*
	Splatter *splatter = [[Splatter spriteWithFile:@"blood_1.png"] retain];
	splatter.position = cpv ( arb->contacts->p.x, arb->contacts->p.y ) ;
	[self addChild: splatter z:0];
	[splatter runAction: [CCSequence actions:[CCFadeOut actionWithDuration:1],[CCCallFunc actionWithTarget:splatter selector:@selector(removeFromParent)],nil]];
*/
	[soldier decreaseEnergy:10];
	[energyLabel setString:[NSString stringWithFormat:@"Energy %d",[soldier	getEnergy]]];
	

	}
	return YES;
}






@end

