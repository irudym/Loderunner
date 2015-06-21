//
//  FirePipe.h
//  Loderunners
//
//  Created by Igor on 16/05/15.
//  Copyright (c) 2015 Cloud2Logic. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "CCSprite.h"
#import "Switchable.h"
#import "LightSource.h"

@interface FirePipe : CCSprite <LightSource, Switchable>

-(id)init;
-(id)initWithPosition: (CGPoint)position;

-(void)turn:(BOOL)onoff;

-(CCSprite*) getLightMap;

@end
