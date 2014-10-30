//
//  BarPie.m
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BarPie.h"

@implementation BarPie
@synthesize isPassed;
@synthesize downBar = _downBar;
@synthesize upBar = _upBar;

- (id)initSpeed:(float)speed locationX:(float)locationX groundH:(float)groundH
{
    if(self = [super init])
    {
        _winSize = [[CCDirector sharedDirector]winSize];
        _speed = speed;
        _locationX = locationX;
        _groundH = groundH;
        
        self.isPassed = NO;
        _downBar = [CCSprite spriteWithFile:@"down_bar.png"];
        _upBar = [CCSprite spriteWithFile:@"up_bar.png"];
        [_downBar setPosition:CGPointMake(_locationX, 0)];
        [_upBar setPosition:CGPointMake( _locationX,0)];
        [self setRandomY];
        [self addChild:_downBar];
        [self addChild:_upBar];
    }
    return  self;
}
#define GAP 100
#define ERROR 10
- (void)setRandomY
{
    
    //NSLog(@"%f",(float)(rand()%100)/100);
    float base = _winSize.height-[_upBar contentSize].height-GAP/2;
    base = base>_groundH+GAP/2+ERROR?base:_groundH+GAP/2+ERROR;
    float top = [_downBar contentSize].height+GAP/2;
    float top1 = _winSize.height-GAP/2-ERROR;
    top = top < top1?top:top1;
    float range = top-base;
    float height = ((float)(rand()%100)/100)*(range)+base;    
//    [_downBar setPosition:CGPointMake(_locationX,[_downBar contentSize].height/2-([_downBar contentSize].height-height+30))];
    [_downBar setPosition:CGPointMake([_downBar position].x,-[_downBar contentSize].height/2+height-GAP/2)];
    NSLog(@"height:%f\n",height);
    
    [_upBar setPosition:CGPointMake([_upBar position].x, [_upBar contentSize].height/2+height+GAP/2)];
}
- (void)setPositionX:(float)positionx
{
    [_downBar setPosition:CGPointMake(positionx,[_downBar position].y)];
    [_upBar setPosition:CGPointMake(positionx, [_upBar position].y)];
    
}

- (float)getPositionX
{
    return [_downBar position].x;
}
+ (float)getWidth
{
    return 52;
}

@end
