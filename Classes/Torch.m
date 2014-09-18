//
//  Torch.m
//  Loderunners
//  Torch object - with lights
//
//  Created by Igor on 04/08/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Torch.h"
#import "CCAnimation.h"

@implementation Torch
{
    CCSprite* lightmap;
    ALSource* soundSource;
    ALBuffer* effectBuffer;
}

-(id)init {
    self = [super init];
    return self;
}

-(id)initWithName:(NSString *)name andSound:(NSString *)soundName andPosition:(CGPoint)point{
    self = [super init];
    if(!self) return nil;
    self.name = name;
    self.soundName = soundName;
    [self load];
    [self setPosition:point];
    [soundSource setPosition:alpoint(point.x, point.y, -100)];
    
    return self;
}


-(void)load {
    NSMutableArray* torchFrames = [NSMutableArray array];
    
    int start_frame = rand()%8;
    for(int i=0;i<10;i++) {
        [torchFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"torch-small%d.png", start_frame++]]];
        start_frame %=10;
    }
    
    _torchAnimation = [CCAnimation animationWithSpriteFrames: torchFrames delay: 0.05f];
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:_torchAnimation];
    
    [self setSpriteFrame:[torchFrames objectAtIndex:0]];
    [[self texture] setAntialiased:NO];
    //[self setScale:0.5];
    
    [self runAction:[CCActionRepeatForever actionWithAction:animationAction]];
    
    
    effectBuffer = [[OpenALManager sharedInstance] bufferFromFile:_soundName reduceToMono:YES];
    
    soundSource = [ALSource source];
    [soundSource setBuffer:effectBuffer];
    //[soundSource setPosition:alpoint(point.x, point.y, -100)];
    [soundSource setReferenceDistance: 5];
    [soundSource setMaxDistance:1000];
    
    [soundSource play:effectBuffer loop:YES];
    
    lightmap = [CCSprite spriteWithImageNamed:@"lightmap1.png"];

    
}

-(CCSprite*) getLightMap {
    return lightmap;
}


@end
