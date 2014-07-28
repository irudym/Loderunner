//
//  Task.h
//  Loderunners
//
//  Created by Igor on 26/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Runner.h"

@interface Task : NSObject

-(id) init;
-(id) initWithTask: (ActionTags) task andPoint: (CGPoint) point;
+(id) createTask: (ActionTags) task withPoint: (CGPoint) point;

@property float x;
@property float y;
@property ActionTags taskType;

@end
