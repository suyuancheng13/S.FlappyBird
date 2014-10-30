//
//  GameLayer.m
//  S_FlappyBird
//
//  Created by Suyuancheng on 14-10-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

#import <UIKit/UIKit.h>
@implementation GameLayer
@synthesize groundHeight;

+ (CCScene*)Scene
{
    CCScene *_scene = [[CCScene alloc]init];
    GameLayer *_game = [[GameLayer alloc]init];
    [_game inInit];
    [_scene addChild:_game];
    return _scene;
}


- (void)inInit
{
    _winSize = [[CCDirector sharedDirector]winSize];
    [self setTouchMode:kCCTouchesOneByOne];
    [self setTouchEnabled:NO];
    _isPaused = YES;

   
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"step" withExtension:@"caf"];
    NSURL *overS = [[NSBundle mainBundle]URLForResource:@"sound1" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)overS, &overSound);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundFileObject);
//    _soundEngine = [SimpleAudioEngine sharedEngine];
//   // [_soundEngine preloadBackgroundMusic:@"music.aifc"];
//    [_soundEngine playBackgroundMusic:@"music.aifc" loop:YES];
//    [_soundEngine setBackgroundMusicVolume:0.3];

  
    /*
     init
     */
    [self initRole];
    [self initGround];
    [self initScoBoard];
    [self initCollision];
    /*
     set the replay button
     */
    CCButton *replay = [[CCButton alloc]initWithTitle:@"Resume" size:CGSizeMake(100, 40)];
    [replay setTouchEnabled:YES];
    [replay setDelegate: self];
    [replay setPosition:CGPointMake(_winSize.width-[replay contentSize].width,_winSize.height-[replay contentSize].height)];
    [self addChild:replay];
    NSLog(@"width:%f",[replay contentSize].width);
    /*
     count down three to ready to start
     */
    [self setCountDown:3];
}
- (void)initRole
{
    _role = [[Role alloc ]initWithAcceleration:0.6 constspeed:5];
    [_role setPosition:CGPointMake(_winSize.width/5, _winSize.height*3/4)];
    [self addChild:_role z:1];
//    ccBezierConfig bezier;
//    bezier.controlPoint_1 = CGPointMake(0, 50);
//    bezier.controlPoint_2 = CGPointMake(0, 100);
//    bezier.endPosition = CGPointMake(50, 100);
//    [_role runAction:[CCBezierTo actionWithDuration:1 bezier:bezier]];
    
}
- (void)initCollision
{
   
    _length = [BarPie getWidth]+BARINTERVAL;
    int nums =  _winSize.width/(_length)+1;
    _barArrays = [[CCArray alloc]init];
    float X = _winSize.width/2;
    srand(time(NULL));
    for(int i=0;i<nums;i++)
    {
        BarPie *bar = [[BarPie alloc]initSpeed:_groundSpeed locationX:X groundH:self.groundHeight];
        [self addChild:bar z:0];
        X += _length;
        [_barArrays addObject:bar];
    }
    
}
- (void)initScoBoard
{
    _score = 0;
    _scoreBoard = [[CCLabelTTF alloc]initWithString:[NSString stringWithFormat:@"Score:%d",_score] fontName:@"CourierNewPSMT" fontSize:24];
    [_scoreBoard setColor:ccRED];
    [_scoreBoard setPosition:CGPointMake([_scoreBoard contentSize].width/2, _winSize.height-40)];
    [self addChild:_scoreBoard z:1];
    
    int bestScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"bestScore"];

    _bestScoreBoard = [[CCLabelTTF alloc]initWithString:[NSString stringWithFormat:@"BestScore:%d",bestScore] fontName:@"CourierNewPSMT" fontSize:24];
    [_bestScoreBoard setColor:ccc3(125, 22, 122)];
    [_bestScoreBoard setPosition:CGPointMake([_bestScoreBoard contentSize].width/2, _winSize.height-20)];
    [self addChild:_bestScoreBoard z:1];
}
- (void)initGround
{
    _groundArrays = [[CCArray alloc]init];
    _groundSpeed = 1.5;
    float _le = 0;
    for(int i=0;i<3;i++)
    {
        CCSprite *ground = [[CCSprite alloc]initWithFile:@"ground.png"];
        if(0==i)
        {
            [ground setPosition:CGPointMake(0, 0)];
            self.groundHeight = [ground contentSize].height/2;
        }
        else {
            _le+=[ground contentSize].width;
            [ground setPosition:CGPointMake(_le, 0)];
        }
        [_groundArrays addObject:ground];
        [self addChild:ground z:1];
    }
}

#pragma mark - count down 
#define countTag 100
- (void)setCountDown:(NSInteger)seconds
{
    _countdownNum = seconds;
    CCLabelTTF *countLabel = [[CCLabelTTF alloc]initWithString:[NSString stringWithFormat:@"%d",_countdownNum] fontName:@"Helvetica-Bold" fontSize:40];
    [countLabel setColor:ccRED];
    [countLabel setTag:countTag];
    [countLabel setPosition:CGPointMake(_winSize.width/2,_winSize.height/2)];
    [self addChild: countLabel];
    [self CountdownAnimation:countLabel];
    [self schedule:@selector(beginCountDown) interval:1];
                                                                                                    
}
- (void)beginCountDown
{
    _countdownNum--;
     CCLabelTTF *label = (CCLabelTTF*)[self getChildByTag:countTag];
    if(label){
        if(_countdownNum<1)
        {
            [label removeFromParent];
            [self unschedule:@selector(beginCountDown)];
            [self doneCountDown];
        }
        else {
            
            [label setString:[NSString stringWithFormat:@"%d",_countdownNum]];
            [self CountdownAnimation:label];
           // [self schedule:@selector(beginCountDown) ];
            
        }
    }
}
/*
 *the entrance to the game
 */
- (void)doneCountDown
{
    _isPaused=NO;
    [self setTouchEnabled:YES];
    [self schedule:@selector(mainLoop) interval:0.016f];
    
}
- (void)CountdownAnimation:(CCNode *)node
{
    [node runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5 scaleX:2 scaleY:2], [CCScaleTo actionWithDuration:0.05 scaleX:0.8 scaleY:0.9],nil]];
//    CCBezierTo
}
#pragma mark - game state 
#define MENUTAG 101
- (void)gameStart
{
}
- (void)roleDown
{
    [_role setPosition:CGPointMake([_role position].x, [_role position].y-3)];
    if([_role position].y<self.groundHeight+[_role contentSize].height/2)
        [self unschedule:@selector(roleDown)];

}
- (void)gameOver
{
    [self setTouchEnabled:NO];
    [self unschedule:@selector(mainLoop)];
    AudioServicesPlaySystemSound(overSound);
    [self schedule:@selector(roleDown) interval:0.016];


    CCMenu *menu = [[CCMenu alloc]init];
    CCMenuItemFont *over = [CCMenuItemFont itemWithString:@"GameOver" block:^(id sender)
                        {
                            [menu removeFromParent];
                        }];
    
    [over setFontSize:50];
    [over setColor:ccRED];
    
    [menu addChild:over];
    
    
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setTag:MENUTAG];
    [menu setPosition:ccp( _winSize.width/2, _winSize.height/2 )];
    [self addChild:menu];
  
//    [menu runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5 scaleX:1.1 scaleY:1.2], [CCScaleTo actionWithDuration:0.05 scaleX:1 scaleY:1],nil]];
}

- (void)gameResume
{
    CCNode *node = [self getChildByTag:MENUTAG];
    if(node)
    {
        [node removeFromParent];
    }
    [_role setPosition:CGPointMake(_winSize.width/5, _winSize.height*3/4)];
    [self fixCollision];
    
    int bestScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"bestScore"];
    if(bestScore < _score)
    {
        [[NSUserDefaults standardUserDefaults]setInteger:_score forKey:@"bestScore"];
        bestScore = _score;
    }
    _score = 0;
    [_scoreBoard setString:[NSString stringWithFormat:@"Score:%d",_score]];
    [_bestScoreBoard setString:[NSString stringWithFormat:@"BestScore:%d",bestScore]];
    [self setCountDown:3];

    
}
#pragma mark- ccbuttonaction event
- (void)onButtonClicked
{
    [self gameResume];
}
#pragma mark - the main loop of this game
- (void)mainLoop
{
 
    
    [self updateCollision];    
    [self updateGround];
    [self updateBar];
    [self updataRole];
    [self updateScore];
    //[self schedule:@selector(mainLoop) interval:0.16f];
}
#pragma mark-update action
- (void)updataRole
{
    //if([_role position].y>self.groundHeight/2+[_role contentSize].height)
    if([self isCollisionWithAre])
    {
        [self gameOver];
        return;        
    }
    if([self isCollisionWithBar])
    {
        [self gameOver];
        return;
    }
       [_role update];

}
- (void)updateBar
{
    if(0==[_barArrays count])
        return;
    int count = [_barArrays count];
    for (int i=0; i<count; i++)
    {
        BarPie *bar = [_barArrays objectAtIndex:i];
        if([bar getPositionX]<-[BarPie getWidth])
        {

            [bar setRandomY];
            [bar setIsPassed:NO];
            [bar setPositionX:[[_barArrays lastObject] getPositionX]+[BarPie getWidth]+BARINTERVAL];
            [_barArrays removeObjectAtIndex:i];
            [_barArrays addObject:bar];
        }
    }
}
- (void)updateCollision
{
    if(0==[_barArrays count])
        return;
    int count = [_barArrays count];
    for (int i=0; i<count; i++) {
        BarPie *bar = [_barArrays objectAtIndex:i];
        [bar setPositionX:[bar getPositionX]-_groundSpeed];
    }
}
- (void)updateGround
{
    if([_groundArrays count]==0)
        return;
    CCSprite *ground0 = [_groundArrays objectAtIndex:0];
    CCSprite *ground1 = [_groundArrays objectAtIndex:1];
    CCSprite *ground2 = [_groundArrays objectAtIndex:2];
    
    [ground0 setPosition:CGPointMake([ground0 position].x-_groundSpeed,[ground0 position].y )];
    [ground1 setPosition:CGPointMake([ground1 position].x-_groundSpeed,[ground1 position].y )];
    [ground2 setPosition:CGPointMake([ground2 position].x-_groundSpeed,[ground2 position].y )];

    if([ground0 position].x< -[ground0 contentSize].width)
    {
        [ground0 setPosition:CGPointMake([ground0 position].x+3*[ground0 contentSize].width,[ground0 position].y)];
        [_groundArrays removeObjectAtIndex:0];
        [_groundArrays addObject:ground0];
    }
    
}
- (void)updateScore
{
    [_scoreBoard setString:[NSString stringWithFormat:@"Score:%d",_score]];
}
#pragma mark- touch event
 -(BOOL)ccTouchBegan:(UITouch *)touches withEvent:(UIEvent *)event
{
    _role.JumpState = JumpUpSate;
   
    AudioServicesPlaySystemSound(soundFileObject);
    return YES;
}
#pragma mark - jude the role was whether collisioned
- (BarPie*)getWillCollisionBar:(Role *)role
{
    int count = [_barArrays count];
    float X = [role position].x+[role contentSize].width/2;
    
    for (int i = 0; i<count; i++) {
        BarPie *bar = [_barArrays objectAtIndex:i];
        if(X<[bar getPositionX]+[bar.downBar contentSize].width/2+[role contentSize].width+2*_groundSpeed)
        {
            return bar;
        }
    }
    
   return nil;
}
- (BOOL)isCollisionWithAre
{
    if([_role position].y<self.groundHeight+[_role contentSize].height/2)
        return YES;
    if([_role position].y>_winSize.height-[_role contentSize].height/2)
        return YES;
    return NO;
}
- (BOOL)isCollisionWithBar
{
    BarPie *bar = [self getWillCollisionBar:_role];
    CGPoint end = CGPointMake([_role position].x-[_role contentSize].width/2, [_role position].y-[_role contentSize].height/2);
    CGPoint start = CGPointMake([_role position].x+[_role contentSize].width/2, [_role position].y+[_role contentSize].height/2);
    CGPoint upBarPointL;
    upBarPointL.x = [bar.upBar position].x-[bar.upBar contentSize].width/2;
    upBarPointL.y = [bar.upBar position].y - [bar.upBar contentSize].height/2;
    CGPoint upBarPointR;
    upBarPointR.x = upBarPointL.x + [bar.upBar contentSize].width;
    upBarPointR.y = upBarPointL.y;
    
    CGPoint downBarPointL;
    downBarPointL.x = [bar.downBar position].x - [bar.downBar contentSize].width/2;
    downBarPointL.y = [bar.downBar position].y + [bar.downBar contentSize].height/2;
    CGPoint downBarPointR;
    downBarPointR.x = downBarPointL.x + [[bar downBar]contentSize].width;
    downBarPointR.y = downBarPointL.y;
    
    if(bar)
    {
        /*
         on the left hand of the bar
         */
        if(start.x>upBarPointL.x&&start.y> upBarPointL.y)
            return YES;
        if(start.x>downBarPointL.x&&end.y< downBarPointL.y)
            return YES;
        /*
         *on the middle of two bars
         */
        if(start.x>upBarPointL.x&&start.x<upBarPointR.x+[_role contentSize].width&&start.y>upBarPointL.y)
            return  YES;
        if(start.x>downBarPointL.x&&start.x<downBarPointR.x+[_role contentSize].width&&end.y<downBarPointL.y)
            return YES;
        if(end.x>downBarPointR.x)
        {
            if(!bar.isPassed)
            {
                bar.isPassed = YES;
                _score++;
            }
        }
        
//        if((start.x > upBarPointL.x&&start.x<upBarPointR.x+[_role contentSize].width)&&(( start.y>upBarPointL.y)||end.y<downBarPointL.y))
//            return YES;
//        /*
//         *on the right hand
//         */
//        if(end.x<upBarPointR.x&&start.y>upBarPointR.y)
//            return YES;
//        if(end.x<downBarPointR.x&&end.y<downBarPointR.y)
//            return YES;
    }
    else {
    
        return YES;
    }
    return NO;

}
#pragma mark - fix to resume
- (void)fixCollision
{
    int count = [_barArrays count];
    float X = _winSize.width/2;
    
    for(int i =0;i<count;i++)
    {
        BarPie *bar = [_barArrays objectAtIndex:i];
        [bar setPositionX:X];
        [bar setRandomY];
        bar.isPassed =NO;
        X+=_length;
    }
}
@end
