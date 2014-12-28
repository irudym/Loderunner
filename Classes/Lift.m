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
}

-(id) init {
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"lift0.png"]];
    if(self) {
        lightmap = [CCSprite spriteWithImageNamed:@"lift-lightmap.png"];
        [lightmap setAnchorPoint:ccp(0,1)];
        [self setAnchorPoint:ccp(0,1)];
    }
    return self;
}

-(id) initWithPosition:(CGPoint) position {
    self = [self init];
    if(self == nil) return nil;
    
    [self setPosition: position];
    [lightmap setPosition:position];
    return self;
}

-(CCSprite*) getLightMap {
    return lightmap;
}

@end
