//
//  ControlButton.h
//  Loderunners
//
//  Created by Igor on 27/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "CCSprite.h"

@interface ControlButton : CCSprite

-(id)init;

+(id)controlButtonWithImage: (NSString*) filename;

-(void) setButtonDownTarget: (SEL)func fromObject: (id)object;
-(void) setButtonUpTarget: (SEL)func fromObject: (id)object;

@property SEL func_down;
@property SEL func_up;
@property id obj_down;
@property id obj_up;

@end
