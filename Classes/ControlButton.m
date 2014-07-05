//
//  ControlButton.m
//  Loderunners
//
//  Created by Igor on 27/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "ControlButton.h"

@implementation ControlButton

-(id) init
{
    self = [super init];
    _obj_down = nil;
    _obj_up = nil;
    return self;
}

+(id) controlButtonWithImage:(NSString *)filename {
    return [self spriteWithImageNamed:filename];
}


- (void)onEnter {
    [super onEnter];
    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(!_obj_down) return;
    [_obj_down performSelector: _func_down];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(!_obj_up) return;
    [_obj_up performSelector:_func_up];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // we want to know the location of our touch in this scene
    //CGPoint touchLocation = [touch locationInView: self.parent];
    //self.position = touchLocation;
}

-(void) setButtonDownTarget:(SEL)func fromObject:(id)object {
    _obj_down = object;
    _func_down = func;
}

-(void) setButtonUpTarget:(SEL)func fromObject:(id)object {
    _obj_up = object;
    _func_up = func;
}
@end
