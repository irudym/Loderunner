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


@interface Torch : CCSprite

-(id) init;
-(id) initWithName: (NSString*) name andSound: (NSString*)soundName andPosition: (CGPoint)point;
-(void)load;

@property CCAnimation* torchAnimation;
@property NSString *name;
@property NSString *soundName;

@end
