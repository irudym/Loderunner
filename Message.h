//
//  Message.h
//  Loderunners
//
//  Created by Igor on 06/12/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

#define MSG_EXPLOSION 100


@protocol Message <NSObject>

@required
-(void) sendMessage: (int)type withPosition: (CGPoint) position;

@end
