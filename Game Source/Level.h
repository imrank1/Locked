

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"
#import "Soldier.h"
#import "Enemy.h"
//#import "Bullet.h"

#pragma mark GameLayer Class
@interface Level : CCLayer <UIAccelerometerDelegate>
{
	SpaceManager *smgr;
	cpCCSprite *ballSprite;
	CCLabel *bulletsAvailable;
	CCLabel *energyLabel;
	CCLabel *timerLabel;
	CCLabel *gameOverLabel;
	ccTime timer;
	CCLabel *reloadLabel;
	//Sprite *soldier;
	Soldier *soldier;
	cpShape *soldierBody;
	NSMutableArray *bullets;
	cpShape *upperRect; 	
	cpShape *lowerRect; 	
	cpShape *leftRect; 	
	cpShape *rightRect;
	BOOL bossReleased;
	Enemy *boss;
	
}
- (int) handleCollisionWithShape:(cpShape*)shape1
						  shape2:(cpShape*)shape2;

-(void) updateBulletCount ;
@end

