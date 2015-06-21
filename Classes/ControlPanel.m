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
{
    BOOL status;
    CCAnimation* switchOn;
    CCAnimation* panelAnimation;
}

@synthesize linkToName;
@synthesize linkTo;


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
    
    NSMutableArray *panelOnFrames = [NSMutableArray array];
    [panelOnFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"switch0.png"]];
    for(int i=0;i<2;i++) {
        [panelOnFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"switch-on%d.png", i]]];
    }
    switchOn = [CCAnimation animationWithSpriteFrames:panelOnFrames delay:0.1f];
    
    [self setSpriteFrame:[panelFrames objectAtIndex:0]];
    [self setPosition: position];
    
    panelAnimation = [CCAnimation animationWithSpriteFrames: panelFrames delay: 0.5f];
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation: panelAnimation]]];
    
    status = NO;
    
    return self;
}

-(void) activate {
    
    //if current action is not nil return
    
    
    status = !status;
    CCLOG(@"Activate control panel and switch object: %@ %d",[self linkToName], status);
    [linkTo turn: status];
    if(status) {
        [self stopAllActions];
        [self runAction:[CCActionAnimate actionWithAnimation:switchOn]];
    } else {
        CCActionAnimate *action = [CCActionAnimate actionWithAnimation: switchOn];
        [self runAction: [CCActionSequence actionOne:[action reverse] two:[CCActionCallFunc actionWithTarget:self selector:@selector(startAnim)]]];
    }
}

-(void) startAnim {
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation: panelAnimation]]];
}


@end
