//
//  Mine.m
//  Loderunners
//
//  Created by Igor on 30/11/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Mine.h"
#import "CCAnimation.h"
#import "Message.h"
#import "RunnerTiledMap.h"

@implementation Mine
{
   CCSprite* lightmap;
}


-(id) init {
    self = [super init];
    if(self) {
        [self load];
    }
    return self;
}

-(void) load {
    NSMutableArray* mineFrames = [NSMutableArray array];
    for(int i=0;i<8;i++) {
        [mineFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"mine%d.png", i]]];
    }
    
    NSMutableArray* explosionFrames = [NSMutableArray array];
    for(int i=0;i<39;i++)
        [explosionFrames addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"explosion%d.png", i]]];
    _explosionAnimation = [CCAnimation animationWithSpriteFrames: explosionFrames delay: 0.0125f];
    
    
    _mineAnimation = [CCAnimation animationWithSpriteFrames: mineFrames delay: 0.5f];
    [self setSpriteFrame:mineFrames[0]];
    CCActionAnimate* actionAnimate = [CCActionAnimate actionWithAnimation:_mineAnimation];

    [self runAction:[CCActionSequence actionOne:actionAnimate two:[CCActionCallFunc actionWithTarget:self selector:@selector(explode)]]];
    
    lightmap = nil;
    
}

-(void) explode {
    CCActionAnimate* expl = [CCActionAnimate actionWithAnimation:_explosionAnimation];
    [self setZOrder:500]; //move the explosion upfront
    
    //set lightmap
    lightmap = [CCSprite spriteWithImageNamed:@"lightmap1.png"];
    
    //[self runAction: expl];
    [self runAction: [CCActionSequence actionOne:expl two:[CCActionCallFunc actionWithTarget:self selector:@selector(deleteMine)]]];
    
    //send a message to map to remove a tile
    [((RunnerTiledMap*)[self parent]) sendMessage: MSG_EXPLOSION  withPosition: [self position]];
    
}

-(void) deleteMine {
    [[self parent] removeChild:self];
}

-(CCSprite*) getLightMap {
    return lightmap;
}



@end
