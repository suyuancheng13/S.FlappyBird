//
//  HelloWorldLayer.h
//  Test
//
//  Created by Suyuancheng on 14-10-17.
//  Copyright __MyCompanyName__ 2014年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCButtonAction.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate,CCButtonAction>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
//- (void)startGame;
@end
