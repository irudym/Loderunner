//
//  FirePipe.m
//  Loderunners
//
//  Created by Igor on 16/05/15.
//  Copyright (c) 2015 Cloud2Logic. All rights reserved.
//

#import "FirePipe.h"
#import "CCAnimation.h"


@implementation FirePipe
{
    CCSprite *fire;
    CCAnimation* fireAnimation;
    CCActionAnimate* fireAction;
    CCSprite* lightmap;
}

-(id)init {
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"fpipe0.png"]];
    if(self == nil) return nil;
    
    NSMutableArray* fireFrames = [NSMutableArray array];
    id frame;
    for(int i=0;i<17;i++) {
        CCLOG(@"add fpipe-anim%d.png to frames", i);
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"fpipe-anim%d.png", i]];
        if(frame == nil) {
            CCLOG(@"ERROR load fpipe-anim%d.png frame!", i);
            break;
        }
        [fireFrames addObject: frame];
    }
    
    fire = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"fpipe-anim16.png"]];
    [fire setPosition:ccp(7.5,-14)];
    [self addChild: fire];
    fireAnimation = [CCAnimation animationWithSpriteFrames: fireFrames delay: 0.06f];
    fireAction = [CCActionAnimate actionWithAnimation:fireAnimation];
    
    return self;
}

-(id)initWithPosition:(CGPoint)position {
    self = [self init];
    if(self == nil) return nil;
    [self setPosition:position];
    return self;
}

-(void)turn:(BOOL)onoff {
    CCLOG(@"Acivate Fire Pipe!");
    [fire runAction:fireAction];
    //[self runAction:fireAction];
}

-(CCSprite*) getLightMap {
    return lightmap;
}

@end
