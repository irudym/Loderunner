//
//  Mine.h
//  Loderunners
//
//  Created by Igor on 30/11/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "LightSource.h"

@interface Mine : CCSprite <LightSource>

-(id) init;
-(void) load;
-(void) explode;

//Remove the object from the scene
-(void) deleteMine;

@property CCAnimation* mineAnimation;
@property CCAnimation* explosionAnimation;

@end
