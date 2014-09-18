//
//  Teleport.h
//  Loderunners
//  Teleport class
//
//  Created by Igor on 27/08/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "LightSource.h"
#import "Runner.h"

@interface Teleport : CCSprite <LightSource>

-(id)init;
-(id)initAtPosition: (CGPoint) pos withName: (NSString*) tName;
-(void)linkTeleport: (Teleport*) object;

/**
 * Activate teleport: when a runner gets to the teleport, switch lights on
 *
 **/
-(void) activate;
-(void) deactivate;


/**
 * show teleporting animation
 * and teleport provided runner
 **/
-(void) runWithRunner: (Runner*) runner;

-(void) followingTeleporation;
-(void) followingFrameFix;

-(CCSprite*) getLightMap;

//OVERRIDE
-(void) setPosition:(CGPoint)position;

@property Teleport* linkTo;
@property NSString *name;
@property NSString *linkToName;
@property CGPoint mapPosition;
@end
