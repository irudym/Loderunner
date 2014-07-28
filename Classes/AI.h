//
//  AI.h
//  Loderunners
//
//  Created by Igor on 26/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunnerTiledMap.h"
#import "TaskList.h"
#import "AStarNode.h"

@interface AI : NSObject

-(id) initWithMap: (RunnerTiledMap*) map;

-(TaskList*) findPathFrom: (CGPoint)startP to: (CGPoint) endP;

-(AStarNode*) checkPoint: (CGPoint) point inList: (NSMutableArray*) list;

-(NSMutableArray*) getPathList;


@end
