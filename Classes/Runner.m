//
//  Runner.m
//  Loderunners
//
//  Created by Igor on 23/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Runner.h"

@implementation Runner

{
    CCDrawNode *drawNode; //debug purposes
    NSInteger climbStopFrame;
    NSInteger climbStopLoop;
    BOOL locked;
}

@synthesize nextAction;
@synthesize nextPosition;
@synthesize nextDirection;
@synthesize currentAction;


-(id) initWithName:(NSString *)name
{
    self = [super init];
    if(self) {
        self.name = name;
        [self load];
    }
    
    locked = NO;
    
    return self;
}

-(void) load
{
    CCSpriteFrame *frame;
    
    CCLOG(@"Runner::load() : Loading %@ class", self.name);
    //load sprites animation
    
    _runRightFrames = [NSMutableArray array];
    _runLeftFrames = [NSMutableArray array];
    for(int i=0;i<12;i++) {
        [_runRightFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"%@-run-right%d.png", [self name], i]]];
        [_runLeftFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"%@-run-left%d.png", [self name], i]]];
    }
    
    _stopRightFrames = [NSMutableArray array];
    _stopLeftFrames = [NSMutableArray array];
    for(int i=0;i<3;i++) {
        [_stopRightFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-stop-right%d.png",[self name], i]]];
        [_stopLeftFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-stop-left%d.png",[self name], i]]];
    }
    
    _rotateFrames = [NSMutableArray array];
    for(int i=0;i<5;i++) {
        [_rotateFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-rotate%d.png",[self name], i]]];
    }
    
    
    _standFrames = [NSMutableArray array];
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-stand-right.png", [self name]]];
    if(frame==nil) {
        CCLOG(@"ERROR load %@-stand-right.png",[self name]);
    }
    [_standFrames addObject: frame];
    
    [_standFrames addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-stand-left.png", [self name]]]];
    
    [_standFrames addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-stand-back.png", [self name]]]];
    
    
    _shortJumpRightFrames = [NSMutableArray array];
    _shortJumpLeftFrames = [NSMutableArray array];
    for(int i=0;i<7;i++) {
        [_shortJumpRightFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-short-jump-right%d.png",[self name], i]]];
        [_shortJumpLeftFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-short-jump-left%d.png",[self name], i]]];
    }
    
    _landingRightFrames = [NSMutableArray array];
    _landingLeftFrames = [NSMutableArray array];
    for(int i=0;i<6;i++) {
        [_landingRightFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-landing-right%d.png",[self name], i]]];
        [_landingLeftFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-landing-left%d.png",[self name], i]]];
    }
    
    _climbFrames = [NSMutableArray array];
    for(int i=0;i<8;i++) {
        [_climbFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-climb%d.png",[self name], i]]];
    }
    
    NSMutableArray *turnUp2LeftFrames = [NSMutableArray array];
    NSMutableArray *turnUp2RightFrames = [NSMutableArray array];
    int j=2;
    for(int i=2; i>=0;i--) {
        [turnUp2RightFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-rotate%d.png",[self name], i]]];
        [turnUp2LeftFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@-rotate%d.png",[self name], j++]]];
    }
    
    //update animations
    _runRightAnimation = [CCAnimation animationWithSpriteFrames: _runRightFrames delay: 0.1f];
    _stopRightAnimation = [CCAnimation animationWithSpriteFrames: _stopRightFrames delay: 0.1f];
    _rotateAnimation = [CCAnimation animationWithSpriteFrames: _rotateFrames delay: 0.08f];
    _runLeftAnimation = [CCAnimation animationWithSpriteFrames: _runLeftFrames delay: 0.1f];
    _stopLeftAnimation = [CCAnimation animationWithSpriteFrames: _stopLeftFrames delay: 0.1f];
    _shortJumpRightAnimation = [CCAnimation animationWithSpriteFrames: _shortJumpRightFrames delay: 0.1f];
    _shortJumpLeftAnimation = [CCAnimation animationWithSpriteFrames: _shortJumpLeftFrames delay: 0.1f];
    _landingRightAnimation = [CCAnimation animationWithSpriteFrames:_landingRightFrames delay: 0.1f];
    _landingLeftAnimation = [CCAnimation animationWithSpriteFrames:_landingLeftFrames delay: 0.1f];
    _climbAnimation = [CCAnimation animationWithSpriteFrames:_climbFrames delay: 0.1f];
    _turnUp2Left = [CCAnimation animationWithSpriteFrames: turnUp2LeftFrames delay: 0.08f];
    _turnUp2Right = [CCAnimation animationWithSpriteFrames: turnUp2RightFrames delay: 0.08f];
    
    //set initial sprite (always stand right)
    [self setSpriteFrame:[_standFrames objectAtIndex:0]];
    [self setAnchorPoint:ccp(0.5f,0.78f)];
    
    
    [self setCurrentDirection:RIGHT];
    
    [self setNextAction:NONE];
    [self setCurrentAction:NONE];

    _moveSpeed = 1;
    _fallSpeed = 10;
    _jumpLength = 48;
    
    //debug
    drawNode = [[CCDrawNode alloc] init];
    [drawNode drawDot:self.anchorPointInPoints radius:2.0f color:[CCColor colorWithRed:1 green:0 blue:0]];
    /*CGPoint polygon[4] =
    {
        CGPointMake(0, 0),
        CGPointMake(16, 0),
        CGPointMake(16, 32),
        CGPointMake(0, 32)
    };
    [drawNode drawPolyWithVerts:polygon count:4 fillColor:0 borderWidth:1 borderColor:[CCColor colorWithRed:1 green:0 blue:0]];
    */
    [self addChild:drawNode];
    
    //load Actions
    _runAction = [NSMutableArray array];
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:_runRightAnimation];
    CCAction* action = [CCActionRepeatForever actionWithAction:animationAction];
    [action setTag:RUN_ACTION];
    [_runAction addObject:action];
    
    animationAction = [CCActionAnimate actionWithAnimation:_runLeftAnimation];
    action = [CCActionRepeatForever actionWithAction:animationAction];
    [action setTag:RUN_ACTION];
    [_runAction addObject:action];
    

    _turnLeftAction = [CCActionAnimate actionWithAnimation:_rotateAnimation];
    _shortJumpAction = [NSMutableArray array];
    [_shortJumpAction addObject:[CCActionAnimate actionWithAnimation: _shortJumpRightAnimation]];
    [_shortJumpAction addObject:[CCActionAnimate actionWithAnimation: _shortJumpLeftAnimation]];
    
    _landingAction = [NSMutableArray array];
    [_landingAction addObject:[CCActionAnimate actionWithAnimation:_landingRightAnimation]];
    [_landingAction addObject:[CCActionAnimate actionWithAnimation:_landingLeftAnimation]];
    
    _turnUpAction = [NSMutableArray array];
    [_turnUpAction addObject:[CCActionAnimate actionWithAnimation:_turnUp2Right]];
    [_turnUpAction addObject:[CCActionAnimate actionWithAnimation:_turnUp2Left]];
    
    _stopAction = [NSMutableArray array];
    [_stopAction addObject:[CCActionAnimate actionWithAnimation:_stopRightAnimation]];
    [_stopAction addObject:[CCActionAnimate actionWithAnimation:_stopLeftAnimation]];
    
    animationAction =[CCActionAnimate actionWithAnimation:_climbAnimation];
    _climbAction = [CCActionRepeatForever actionWithAction:animationAction];
    
}

/**
 *  move (run) the runner by X points
 *  turn the runner in the necessary direction if needed
 */
 
-(void) runX: (float) x {
    //CCLOG(@"runX:%f currentAction: %d, nextAction: %d", x,currentAction, nextAction);
    if( currentAction!=NONE ) {
        nextAction = RUN_ACTION;
        nextPosition.x = x;
        return;
    }
    if((x > 0 && _currentDirection != RIGHT) || (x < 0 && _currentDirection != LEFT)) {
        nextAction = RUN_ACTION;
        nextPosition = [self position];
        nextPosition.x = x;
        if(x < 0) [self turn: LEFT]; else [self turn: RIGHT];
        return;
    }
    currentAction = RUN_ACTION;
    
    [self runAction:_runAction[_currentDirection]];
    
    CCAction* moveAction = [CCActionMoveBy actionWithDuration:[self moveSpeed] * fabs(x)/1000 position:ccp(x,0)];
    [moveAction setTag:MOVE_ACTION];
    //[self runAction:moveAction];
    [self runAction:[CCActionSequence actionOne:(CCActionFiniteTime*)moveAction two: [CCActionCallFunc actionWithTarget:self selector:@selector(stop)]]];
    
    nextAction = RUN_ACTION;
    nextPosition.x = x;
    
}

-(void) turn: (Direction) direct {
    
    if(_currentDirection == direct) return;
    
    if(currentAction!=NONE) {
        //CCLOG(@"turn: Change nextAction: %d to %d",nextAction, TURN_ACTION);
        nextAction = TURN_ACTION;
        nextDirection = direct;
        return;
    }
    //CCLOG(@"turn: %d",direct);
    currentAction = TURN_ACTION;
    
    if(_currentDirection!=UP && _currentDirection!=DOWN) {
        if(direct == LEFT) {
            [self runAction:[CCActionSequence actionOne:(CCActionFiniteTime*)_turnLeftAction two: [CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
        } else if(direct == RIGHT){
            [self runAction:[CCActionSequence actionOne: [(CCActionAnimate*)_turnLeftAction reverse] two :[CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
        } else if(direct == UP) {
            [self runAction:[CCActionSequence actionOne:[(CCActionAnimate*)_turnUpAction[_currentDirection] reverse] two:[CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
        }
    } else if(_currentDirection == UP) {
        //CCLOG(@"Turn runner: %d", direct);
        [self runAction:[CCActionSequence actionOne:(CCActionAnimate*)_turnUpAction[direct] two:[CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
    }
    _currentDirection = direct;
    
}

-(void) followingAction {
    //CCLOG(@"followinfAction: currentAction: %d  nextAction: %d", currentAction, nextAction);
    ActionTags action = nextAction;
    currentAction = NONE;
    nextAction = NONE;
    
    if(action == NONE) {
        [self idle];
    } else
    if(action == RUN_ACTION) {
        [self runX: nextPosition.x];
    } else
    if(action == JUMP_ACTION ) {
        [self jump];
    } else
    if(action == FALL_ACTION) {
        currentAction = NONE;
        [self fall];
    } else
    if(action == TURN_ACTION) {
        currentAction = NONE;
        [self turn:nextDirection];
    } else
    if(action == CLIMB_ACTION) {
        currentAction = NONE;
        [self climbY:nextPosition.y];
    } else
    if(action == STEPTO_ACTION) {
        [self stepTo:nextPosition andClimbY:nextPosition.y];
    } else
    if(action == STOP_ACTION) {
        [self stop];
    }
}

-(void) idle {
    [self setSpriteFrame:_standFrames[_currentDirection]];
    currentAction = NONE;
    climbStopFrame = 0;
}

-(void) stop {
    nextAction = NONE;
    if(currentAction == RUN_ACTION && _currentDirection != UP /*it never shoud be UP*/) {
        [self stopAllActions];
        //CCAction *action = nil;
        currentAction = STOP_ACTION;
        //if(_currentDirection == LEFT) action = _stopLeftAction; else action = _stopRightAction;
        [self runAction: [CCActionSequence actionOne:(CCActionFiniteTime*)_stopAction[_currentDirection] two: [CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
    }
    if(currentAction == JUMP_ACTION) {
        //[self stopActionByTag:JUMP_ACTION];
        [self stopAllActions];
        [self idle];
    }
    if(currentAction == CLIMB_ACTION) {
        //get current animation frame
        climbStopFrame = [(CCActionAnimate*)[(CCActionRepeatForever*) _climbAction innerAction] getNextFrame];
        
        [self stopAllActions];
        //[self idle];
        currentAction = NONE;
        //nextAction = NONE;
    }
}

-(void) jump {
    if(currentAction != NONE) {
        nextAction = JUMP_ACTION;
        return;
    }
    if(_currentDirection == UP || _currentDirection == DOWN) return;
    
    float jumpX = -_jumpLength;
    if(_currentDirection == RIGHT) {
        jumpX = _jumpLength;
    }
    
    currentAction = JUMP_ACTION;
    
    [self runAction:[CCActionSequence actionOne:(CCActionFiniteTime*)_shortJumpAction[_currentDirection] two: [CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
    
    CCAction* jumpByAction = [CCActionJumpBy actionWithDuration:0.5 position:ccp(jumpX,0) height:16 jumps:1];
    [jumpByAction setTag:JUMP_ACTION];
    [self runAction:jumpByAction];
}

-(BOOL) isJumping {
    return currentAction == JUMP_ACTION;
}

-(BOOL) isFalling {
    return currentAction == FALL_ACTION;
}

-(void) fall {
    if(currentAction == FALL_ACTION) return;
    if(currentAction == JUMP_ACTION) {
        return;
    }
    [self stopAllActions];
    [self idle];
    
    CCAction* fall = [CCActionEaseIn  actionWithAction:[CCActionMoveBy actionWithDuration:[self fallSpeed]/4 position:ccp(0,-1000)] rate: 2];
    [fall setTag:FALL_ACTION];
    
    [self runAction:fall];
    
    currentAction = FALL_ACTION;
}

-(void) land {
    [self stopAllActions];
    currentAction = LANDING_ACTION;
    
    //the _currentDirection should be LEFT or RIGHT!!!
    [self runAction:[CCActionSequence actionOne:_landingAction[_currentDirection] two:[CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
}

-(void) climbY: (float) y {
    
    if(currentAction!=NONE) {
        nextAction = CLIMB_ACTION;
        nextPosition.y = y;
        return;
    }
    if(_currentDirection!=UP) {
        [self turn:UP];
        nextAction = CLIMB_ACTION;
        nextPosition.y = y;
        return;
    }
    
    [self runAction:_climbAction];
    CCAction* climbBy = [CCActionMoveBy actionWithDuration:10.0f*(fabs(y)/1000) position:ccp(0,y)];
    [climbBy setTag:CLIMB_ACTION];
    
    //[self runAction:climbBy];
    [self runAction:[CCActionSequence actionOne:(CCActionFiniteTime*)climbBy two: [CCActionCallFunc actionWithTarget:self selector:@selector(stop)]]];
    
    
    currentAction = CLIMB_ACTION;
    
    //set start frame
    [(CCActionAnimate*)[(CCActionRepeatForever*) _climbAction innerAction] setNextFrame:climbStopFrame];
    
}

-(void) turnUp {
    currentAction = NONE;
    [self turn: UP];
}

/**
 * Move the runner to the point and start climbimg (it's needed before climbing a ladder to align the sprite in the middle of a tile
 *
 */
-(void) stepTo:(CGPoint)point andClimbY:(float)y {
    
    //CCLOG(@"StepT: [%f,%f]", point.x,point.y);
    if(currentAction!=NONE) {
        nextAction = STEPTO_ACTION;
        nextPosition.x = point.x;
        nextPosition.y = y;
        return;
    }
    if(_currentDirection != UP) {
        //turn the Runner in the right direction
        int runnerX = [self position].x;
        if((runnerX > point.x && _currentDirection == RIGHT) || (runnerX < point.x && _currentDirection == LEFT)) {
            //turn the runner to ladder
            nextAction = STEPTO_ACTION;
            nextPosition.x = point.x;
            nextPosition.y = y;
            if(_currentDirection == LEFT) [self turn:RIGHT]; else [self turn:LEFT];
            return;
        }
    }
    
    
    //if point.x == position.x just climb
    
    //fix runner position (if it's in [-2,+2] range)
    if([self position].x> point.x - 2 && [self position].x < point.x + 2) [self setPosition:ccp(point.x, [self position].y)];
    
    if(point.x == (int)([self position].x)) [self climbY:y];
    else {
        currentAction = STEPTO_ACTION;
        [self runAction:[CCActionSequence actionOne:_stopAction[_currentDirection] two:[CCActionCallFunc actionWithTarget:self selector:@selector(turnUp)]]];
        float shift = point.x - [self position].x;

        [self runAction:[CCActionMoveBy actionWithDuration:fabsf(shift)/64 position:ccp(shift,0)]];
        nextAction = CLIMB_ACTION;
        nextPosition.y = y;
    }
}

-(void) lock {
    locked = YES;
    [self stop];
    [self setCurrentAction:LOCKED_ACTION];
}

-(void) unlock {
    locked = NO;
    [self setCurrentAction: NONE];
}

-(BOOL) isLocked {
    return locked;
}




@end
