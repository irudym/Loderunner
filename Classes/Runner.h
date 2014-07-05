//
//  Runner.h
//  Loderunners
//
//  Created by Igor on 23/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "CCSprite.h"
#import "CCAnimation.h"


typedef enum {
    RIGHT, LEFT, UP, DOWN
} Direction;

typedef enum {
    NONE, IDLE,  RUN_ACTION = 100, TURN_ACTION, STOP_ACTION, MOVE_ACTION, JUMP_ACTION, FALL_ACTION, CLIMB_ACTION, LANDING_ACTION, STEPTO_ACTION, DUCK_ACTION
} ActionTags;


@interface Runner : CCSprite

-(id) initWithName: (NSString*) name;
-(void) load;

-(void) runX: (float) x;
-(void) turn: (Direction) direct;
-(void) jump;
-(void) idle;
-(void) stop;
-(void) fall;
-(void) land;
-(void) climbY: (float) y;
-(void) stepTo: (CGPoint)point andClimbY: (float)y;

-(BOOL) isJumping;
-(BOOL) isFalling;

-(void) turnUp;

-(void) followingAction;

@property NSString *name;
@property CCAnimation* runRightAnimation;
@property CCAnimation* stopRightAnimation;
@property CCAnimation* runLeftAnimation;
@property CCAnimation* stopLeftAnimation;
@property CCAnimation* rotateAnimation;
@property CCAnimation* shortJumpRightAnimation;
@property CCAnimation* shortJumpLeftAnimation;
@property CCAnimation* landingRightAnimation;
@property CCAnimation* landingLeftAnimation;
@property CCAnimation* climbAnimation;
@property CCAnimation* turnUp2Left;
@property CCAnimation* turnUp2Right;

@property NSMutableArray* runAction;
@property NSMutableArray* stopAction;
@property CCAction* turnLeftAction;
@property NSMutableArray* shortJumpAction;
@property NSMutableArray* landingAction;
@property NSMutableArray* turnUpAction;
@property CCAction* climbAction;



@property Direction currentDirection;

@property NSMutableArray* runRightFrames;
@property NSMutableArray* runLeftFrames;
@property NSMutableArray* stopRightFrames;
@property NSMutableArray* stopLeftFrames;
@property NSMutableArray* standFrames;
@property NSMutableArray* rotateFrames;
@property NSMutableArray* shortJumpRightFrames;
@property NSMutableArray* shortJumpLeftFrames;
@property NSMutableArray* landingRightFrames;
@property NSMutableArray* landingLeftFrames;
@property NSMutableArray* climbFrames;

@property int moveSpeed;
@property int fallSpeed;
@property int jumpLength;

@property ActionTags nextAction;
@property CGPoint nextPosition;
@property Direction nextDirection;
@property ActionTags currentAction;

@end
