//
//  Role.h
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
enum{
    JumpUpSate,
    JumpDownState
};
@interface Role : CCSprite
{
    float       _acceleration;
    float       _constSpeed;
    float       _speed;
}
@property(nonatomic,assign)int JumpState;
@property(nonatomic,assign)float roleSpeed;
- (id)initWithAcceleration:(float)acceleration constspeed:(float)contspeed;
- (void)update;
- (void)RoleJump;
- (void)RoleJumpUp;
- (void)RoleJumpDown;
@end
