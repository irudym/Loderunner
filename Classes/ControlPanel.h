//
//  ControlPanel.h
//  Loderunners
//
//  Created by Igor on 18/01/15.
//  Copyright (c) 2015 Cloud2Logic. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "Switchable.h"


@interface ControlPanel : CCSprite

-(id) init;
-(id) initWithPosition: (CGPoint) position;

-(void) activate;

@property NSString* linkToName;
@property id linkTo;

@end
