//
//  Player.m
//  Loderunners
//
//  Created by Igor on 26/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id)init
{
    self = [super initWithName: @"player"];
    [self setMoveSpeed:10];
    
    //load additinal frames, animations, and action
    
    NSMutableArray* duckLeftFrames = [NSMutableArray array];
    NSMutableArray* duckRightFrames = [NSMutableArray array];
    for(int i=3;i<6;i++) {
        [duckRightFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"%@-landing-right%d.png", [self name], i]]];
        [duckLeftFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"%@-landing-left%d.png", [self name], i]]];
    }
    
    _duckFrames = [NSMutableArray array];
    [_duckFrames addObject: duckRightFrames[0]];
    [_duckFrames addObject: duckLeftFrames[0]];
    
    _duckAnimation = [NSMutableArray array];
    [_duckAnimation addObject:[CCAnimation animationWithSpriteFrames:duckRightFrames delay: 0.1f]];
    [_duckAnimation addObject:[CCAnimation animationWithSpriteFrames:duckLeftFrames delay: 0.1f]];
    
    _duckAction = [NSMutableArray array];
    for(int i=0;i<2;i++)
        [_duckAction addObject:[CCActionAnimate actionWithAnimation:_duckAnimation[i]]];
    
    return self;
}

-(void) duck {
    if([self isDuck] || self.currentDirection == UP || self.currentAction == STEPTO_ACTION || self.nextAction == CLIMB_ACTION) return;
    if([self currentAction]!=NONE) {
        [self setNextAction:DUCK_ACTION];
        return;
    }
    
    [self setCurrentAction: DUCK_ACTION];
    [self runAction: [CCActionSequence actionOne: [_duckAction[self.currentDirection] reverse] two: [CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
    _ducked = YES;
}


-(void) followingAction {
    
    if(self.nextAction == DUCK_ACTION) {
        self.currentAction = NONE;
        if(self.currentDirection!=UP) [self duck]; else [self idle];
        return;
    }
    
    [super followingAction];
}

-(void) idle {
    self.currentAction = NONE;
    if(self.isDuck && self.currentDirection!=UP) [self setSpriteFrame: self.duckFrames[self.currentDirection]];
        else [super idle];
}

-(void) stop {
    if(self.isDuck) {
        _ducked = NO;
        //stand up
        self.currentAction = DUCK_ACTION;
        self.nextAction = NONE;
        if(self.currentDirection!=UP) [self runAction: [CCActionSequence actionOne:_duckAction[self.currentDirection] two:[CCActionCallFunc actionWithTarget:self selector:@selector(followingAction)]]];
    } else [super stop];
}



@end
