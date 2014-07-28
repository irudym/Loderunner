//
//  TaskList.h
//  Loderunners
//
//  Queue of tasks
//
//  Created by Igor on 26/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Task.h"

@interface TaskList : NSObject

-(id) init;

-(void)addTask: (Task*) task;
-(Task*) getTask;
-(bool) isEmpty;

/**
 *  Remove last last from the list
 *  @return new size of the list 
 **/
-(NSInteger) removeLast;

@end
