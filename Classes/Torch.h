//
//  Torch.h
//  Loderunners
//
//  Created by Igor on 04/08/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//


#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "OpenALManager.h"

#import "LightSource.h"

@interface Torch : CCSprite <LightSource>

-(id) init;
-(id) initWithName: (NSString*) name andSound: (NSString*)soundName andPosition: (CGPoint)point;
-(void)load;

-(CCSprite*) getLightMap;

@property CCAnimation* torchAnimation;
@property NSString *name;
@property NSString *soundName;

@end
