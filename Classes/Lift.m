//
//  Lift.m
//  Loderunners
//
//  Created by Igor on 28/12/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Lift.h"

@implementation Lift
{
    CCSprite* lightmap;
    CGPoint position1;
    CGPoint position2;
}

-(id) init {
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"lift0.png"]];
    if(self) {
        lightmap = [CCSprite spriteWithImageNamed:@"lift-lightmap.png"];
        [lightmap setAnchorPoint:ccp(0,0.58f)];
        [self setAnchorPoint:ccp(0,0.58f)];
        
        //debug - show Anchor Point
        //CCDrawNode *drawNode = [[CCDrawNode alloc] init];
        //[drawNode drawDot:self.anchorPointInPoints radius:2.0f color:[CCColor colorWithRed:1 green:0 blue:0]];
        //[self addChild:drawNode];
    }
    return self;
}

-(id) initWithPosition:(CGPoint) position {
    self = [self init];
    if(self == nil) return nil;
    
    [self setPosition: position];
    [lightmap setPosition:position];
    
    position1 = position;
    
    return self;
}

-(CCSprite*) getLightMap {
    return lightmap;
}

-(void) setToPosition:(CGPoint) pos {
    position2 = pos;
}

-(void) active: (CCNode*) runner {
    
    //check if the lift is in an action mode
    if([self numberOfRunningActions] > 0) return;
    
    CGPoint sendToPosition = position2;
    if([self position].x == position2.x && [self position].y == position2.y) sendToPosition = position1;
    CCAction *action = [CCActionMoveTo actionWithDuration:1.0f position:sendToPosition];
    [self runAction:action];
    CGPoint sendRunner;
    sendRunner.x = [runner position].x;
    sendRunner.y = sendToPosition.y;
    CCAction* runnerAction = [CCActionMoveTo actionWithDuration:1.0f position:sendRunner];
    [runner runAction:runnerAction];
}

@end
