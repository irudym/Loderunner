//
//  TaskList.m
//  Loderunners
//
//  Created by Igor on 26/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "TaskList.h"

@implementation TaskList

{
    NSMutableArray* taskList;
}

-(id) init {
    self = [super init];
    if (!self) return(nil);
    
    taskList = [NSMutableArray array];
    
    return self;
}

-(void) addTask:(Task *)task {
    //[taskList addObject:task];
    [taskList insertObject:task atIndex:0];
}

/**
 *@function getTask - return last task from the list
 *@result   (Task*) pointer to the Task class
 */
-(Task*) getTask {
    NSInteger size = [taskList count];
    return taskList[size-1];
}

-(NSInteger) removeLast {
    [taskList removeLastObject];
    return [taskList count];
}

-(BOOL)isEmpty {
    return [taskList count] < 1;
}



@end
