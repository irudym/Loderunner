//
//  Task.m
//  Loderunners
//
//  AI task implementation
//  Created by Igor on 26/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Task.h"

@implementation Task

-(id) init {
    self = [super init];
    if (!self) return(nil);
    return self;
}

-(id) initWithTask:(ActionTags)task andPoint:(CGPoint)point {
    self = [super init];
    if(!self) return (nil);
    
    self.x = point.x;
    self.y = point.y;
    self.taskType = task;
    
    return self;
}

+(id) createTask:(ActionTags)task withPoint:(CGPoint)point {
    return [[self alloc] initWithTask:task andPoint:point];
}


@end
