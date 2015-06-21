//
//  Lift.h
//  Loderunners
//
//  Created by Igor on 28/12/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "CCSprite.h"
#import "LightSource.h"
#import "Switchable.h"

@interface Lift : CCSprite <LightSource, Switchable>

-(id) init;
-(id) initWithPosition: (CGPoint) position;
-(void) setToPosition: (CGPoint) toPosition;

-(void) active: (CCNode*) runner;

-(void) turn:(BOOL)onoff;

@end
