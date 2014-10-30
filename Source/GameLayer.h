//
//  GameLayer.h
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Role.h"
#import "BarPie.h"
#import "CCButton.h"
#import "CDAudioManager.h"
#import "SimpleAudioEngine.h"
#define BARINTERVAL 60.0f

@interface GameLayer : CCLayer<CCButtonAction>
{
    Role        *_role;
    CCArray     *_barArrays;
    CCArray     *_groundArrays;
    BOOL        _isPaused;
    BOOL        _isTouchable;
    float       _groundSpeed;
    int         _score;
    CCLabelTTF  *_scoreBoard;
    CCLabelTTF  *_bestScoreBoard;
    CGSize      _winSize;
    int         _countdownNum;
    float       _length;
//    AVAudioPlayer *_audionPlayer;
    SystemSoundID   soundFileObject;
    SystemSoundID   overSound;
    SimpleAudioEngine   *_soundEngine;
    
    
}
@property(nonatomic,assign)float groundHeight;
+ (CCScene*)Scene;

/*
 initialize
 */
- (void)inInit;
- (void)initRole;
- (void)initCollision;
- (void)initScoBoard;
- (void)initGround;

/*
 count down action
 */
- (void)setCountDown:(NSInteger)seconds;
- (void)beginCountDown;
- (void)doneCountDown;
- (void)CountdownAnimation:(CCNode*)node;
/*
 Game state
 */
- (void)gameStart;
- (void)gameOver;
- (void)gameResume;

- (void)mainLoop;
/*
 update action
 */
- (void)updataRole;
- (void)updateBar;
- (void)updateCollision;
- (void)updateGround;
- (void)updateScore;

/*
 judge the collision
 */
- (BOOL)isCollisionWithAre;
- (BOOL)isCollisionWithBar;
- (BarPie*)getWillCollisionBar:(Role*)role;
/*
 *FIX bar's position and state to resume
 */
- (void)fixCollision;
@end
