//
//  Teleport.m
//  Loderunners
//
//  Created by Igor on 27/08/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Teleport.h"
#import "Runner.h"

@implementation Teleport

{
    BOOL activated;
    NSMutableArray* teleportFrames;
    CCSprite* lightmap;
    Runner* currentRunner;
    NSMutableArray* lightFrames;
    CCAnimation* lightAnimation;
}

@synthesize linkTo ,name, linkToName, mapPosition;

-(id) init {
    self = [super init];
    if(self == nil) return nil;
    
    self.linkTo = nil;
    
    [self setPosition: ccp(-1,-1)];
    activated = NO;
    
    [self setSpriteFrame: nil];
    teleportFrames = [NSMutableArray array];
    
    //add frames to the array
    for(int i=0;i<1;i++) {
        [teleportFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"teleport%d.png", i]]];
    }
    
    lightFrames = [NSMutableArray array];
    for(int i=0;i<7;i++) {
        [lightFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"teleport_light%d.png", i]]];
    }
    lightAnimation = [CCAnimation animationWithSpriteFrames:lightFrames delay:0.05f];
    
    
    [self setAnchorPoint:ccp(0,0.5)];
    
    //lightmap = nil;
    lightmap = [CCSprite spriteWithSpriteFrame:teleportFrames[0]];
    [lightmap setAnchorPoint:ccp(0,0.5)];
    
    return self;
}

-(id) initAtPosition:(CGPoint)pos withName:(NSString *)tName {
    self = [self init];
    if(self == nil) return nil;
    [self setMapPosition: pos];
    [self setName:tName];
    
    return self;
}

-(void)linkTeleport:(Teleport *)object {
    [self setLinkTo:object];
    [object setLinkTo: self];
}

-(void) activate {
    if(activated) return;
    CCLOG(@"Activate teleport [%@]",[self name]);
    activated = YES;
    [self setSpriteFrame:teleportFrames[0]];
    CCLOG(@"draw sprite at position: [%f,%f]",[self position].x, [self position].y);
}

-(void) deactivate {
    if(!activated) return;
    CCLOG(@"Deactivate teleport [%@]",[self name]);
    activated = NO;
    [self setSpriteFrame: nil];
}

-(void) runWithRunner:(Runner *)runner {
    currentRunner = runner;
    [runner lock];
    //show animation
    CCActionAnimate* light = [CCActionAnimate actionWithAnimation:lightAnimation];

    [self runAction:[CCActionSequence actions:light, [CCActionCallFunc actionWithTarget:self selector:@selector(followingTeleporation)],[light reverse], [CCActionCallFunc actionWithTarget:self selector:@selector(followingFrameFix)], nil]];
}

-(void) followingTeleporation {
    //
    
    CGPoint newPos = [linkTo position];
    //fix position
    newPos.x += 16;
    newPos.y -= 2;
    
    [currentRunner setPosition:newPos];
    [currentRunner unlock];
    currentRunner = nil;
}

-(void) followingFrameFix {
    [self setSpriteFrame: nil];
}

-(CCSprite*) getLightMap {
    if(activated) return lightmap;
    return nil;
}

-(void) setPosition:(CGPoint)position {
    [super setPosition:position];
    [lightmap setPosition:position];
}


@end
