//
//  BarPie.h
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#define BarGap 50

@interface BarPie : CCNode
{
    float       _speed;
    CCSprite    *_downBar;
    CCSprite    *_upBar;
    float       _height;
    CGSize      _winSize;
    float       _locationX;
    //CCNode      *_parent;
    float       _groundH;
}
@property(nonatomic,assign)BOOL isPassed;
@property(nonatomic,readonly)CCSprite   *downBar;
@property(nonatomic,readonly)CCSprite   *upBar;
- (id)initSpeed:(float)speed locationX:(float)locationX groundH:(float)groundH;
- (void)update;
//- (BarPie*)getWillCollisionBar:(CGPoint)posion;
- (void)setRandomY;
- (void)setPositionX:(float)positionx;
- (float)getPositionX;
+ (float)getWidth;

@end
