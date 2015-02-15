//
//  ControlPanel.m
//  Loderunners
//
//  Created by Igor on 18/01/15.
//  Copyright (c) 2015 Cloud2Logic. All rights reserved.
//

#import "ControlPanel.h"
#import "CCAnimation.h"

@implementation ControlPanel


-(id)init {
    self = [super init];
    return self;
}

-(id) initWithPosition:(CGPoint)position {
    self = [super init];
    if(!self) return nil;
    
    NSMutableArray* panelFrames = [NSMutableArray array];
    
    for(int i=0; i<4; i++) {
        [panelFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"switch%d.png", i]]];
    }
    
    [self setSpriteFrame:[panelFrames objectAtIndex:0]];
    [self setPosition: position];
    
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames: panelFrames delay: 0.5f]]]];
    
    return self;
}


@end
