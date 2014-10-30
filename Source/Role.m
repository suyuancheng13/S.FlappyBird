//
//  Role.m
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "Role.h"

@implementation Role
@synthesize JumpState;
@synthesize roleSpeed;
- (id)initWithAcceleration:(float)acceleration constspeed:(float)contspeed
{
    if(self = [super initWithFile:@"bird.png"])
    {
        self.JumpState = JumpDownState;
        _acceleration = acceleration;
        _constSpeed = contspeed;
        _speed =0;
        
    }
   return  self;
}
- (void)update
{
    [self RoleJump];

}
- (void)RoleJump
{
    switch (self.JumpState) {
        case JumpUpSate:
            [self RoleJumpUp];  
            break;
        case JumpDownState:
            [self RoleJumpDown];
            break;
        default:
            break;
    }
}
- (void)RoleJumpUp
{
    _speed = -_constSpeed;
    JumpState = JumpDownState;

}
- (void)RoleJumpDown
{
    [self setPosition:CGPointMake([self position].x,[self position].y-_speed)];
    _speed += _acceleration;
}
@end
