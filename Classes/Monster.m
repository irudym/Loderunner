//
//  Monster.m
//  Loderunners
//
//  Created by Igor on 15/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Monster.h"
#import "AI.h"

@implementation Monster
{
    AI* brains;
    TaskList* taskList;
    CCDrawNode *drawNode; //debug purposes
    RunnerTiledMap* mainMap;
}

@synthesize prayRunner;

-(id)init {
    self = [super initWithName: @"monster"];
    return self;
}

-(id) initWithMap:(RunnerTiledMap *)map andPray:(Runner *)pray {
    self = [super initWithName:@"player"]; //debug till I create monster sprites
    if(!self) return (nil);
    
    self.prayRunner = pray;
    
    brains = [[AI alloc] initWithMap:map];
    mainMap = map;
    taskList = nil;
    self.moveSpeed = 8;
    
    //DEBUG
    drawNode = [[CCDrawNode alloc] init];
    
    return self;
}

-(void)load {
    [super load];
}


-(void) updateAI {
    if([self currentAction] == NONE && taskList == nil) {
        //find the route
        taskList = [brains findPathFrom:self.position to:prayRunner.position];
        [self DEBUGshowPath];
    }
}

-(void)update:(CCTime)delta {
    if([self currentAction]!=NONE) return;
    
    if([taskList isEmpty]) {
        taskList = nil;
        return;
    }
    
    if(taskList!=nil && ![taskList isEmpty]) {
        Task* currentTask = [taskList getTask];

        if(currentTask.taskType == RUN_ACTION) {
            //add run action to runner
            [self runX:16+(currentTask.x - [self position].x)];
            [taskList removeLast];
        }
        if(currentTask.taskType == CLIMB_ACTION) {
            //CCLOG(@"Climb a ladder to %f", currentTask.y);
            [self climbY:(currentTask.y - [self position].y)];
            [taskList removeLast];
        }
        if(currentTask.taskType == JUMP_ACTION) {
            [self jump];
            [taskList removeLast];
        }
        
        if([self position].x == currentTask.x && [self position].y == currentTask.y) {
            //if(currentTask.taskType == RUN_ACTION) [self stop];
            if([taskList removeLast] == 0) //job is done!
            {
                //taskList = nil;
                return;
            }
        }

    }
}


-(void) DEBUGshowPath {
    
    [drawNode clear];
    
    NSMutableArray *path = [brains getPathList];
    CGPoint point;
    if(path!=nil && [path count]!=0) {
        for(NSInteger count = 0; count< [path count]; count++) {
            point = [mainMap getPositionAt:ccp([(AStarNode*)path[count] i],[(AStarNode*)path[count] j])];
            point.x += 16;
            point.y -=16;
            [drawNode drawDot:point radius:4.0f color:[CCColor colorWithRed:1 green:0 blue:0]];
        }
    }
}

-(void)DEBUGset {
    [[self parent] addChild:drawNode];
}






@end
