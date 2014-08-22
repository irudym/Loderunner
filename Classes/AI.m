//
//  AI.m
//  Loderunners
//  Path finding algoritm for monsters
//
//  Created by Igor on 26/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "AI.h"


@implementation AI
{
    RunnerTiledMap* mainMap;
    NSMutableArray* openList;
    NSMutableArray* closedList;
    NSMutableArray* pathList;
}


-(id) initWithMap:(RunnerTiledMap *)map {
    
    self = [super init];
    if (!self) return(nil);
    
    mainMap = map;
    
    openList = [NSMutableArray array];
    closedList = [NSMutableArray array];
    pathList = [NSMutableArray array];
    return self;
}


-(int) calculateGCost: (AStarNode*) node {
    AStarNode* checkNode = node;
    int GCost = [checkNode GCost];
    
    while(YES) {
        checkNode = [checkNode parentNode];
        if(checkNode == nil) break;
        GCost += [checkNode GCost];
    }
    return GCost;
}

/**
 *  Calculating distance to point
 *  @param  startP - point - start of the distance
 *  @param  endP - end distance
 *  @return (int) - distance calculation
 **/
-(int) heuristicFrom: (CGPoint)startP to: (CGPoint) endP {
    //return 10*(fabsf(startP.x - endP.x) + fabsf(startP.y - endP.y));
    return sqrtf(pow(startP.x - endP.x, 2)+pow(startP.y - endP.y,2));
}

/**
 *  Check if the point is already in the list
 *  @param  point - point to check
 *  @param  list - NSMutableArray where we need to find the provided point
 *  @return AStarNode* or null in case there is no point in the list
 **/
-(AStarNode*) checkPoint: (CGPoint) point inList: (NSMutableArray*) list {
    NSInteger listSize = [list count];
    
    for(NSInteger count = 0; count <listSize; count++) {
        if([(AStarNode*)list[count] i] == point.x && ((AStarNode*)list[count]).j == point.y) return list[count];
    }
    return nil;
}

/**
 * @function findPathFrom: to:
 *      find a path by using A* algorithm
 *      the function converts the cocos2s coords to tilema coords;
 *  @param  startP - start point in cocos2d
 *  @param  endP - end point
 **/

-(TaskList*) findPathFrom:(CGPoint)startP to:(CGPoint)endP {
    
    //convert coords
    startP = [mainMap getTileCoordinateAt:startP];
    endP = [mainMap getTileCoordinateAt:endP];
    //CCLOG(@"find a path from [%f,%f] to [%f,%f]",startP.x,startP.y, endP.x, endP.y);
    
    int count = 0;
    AStarNode* checkNode;
    CGPoint checkPoint;
    int checkGCost = 0;
    u_int32_t checkTile;
    AStarNode* node = [[AStarNode alloc] init];
    
    //clear lists
    [openList removeAllObjects];
    [closedList removeAllObjects];
    
    //just in case we are already there
    if(startP.x == endP.x && startP.y == endP.y) return nil;
    
    //add the start point to the closed list
    [node setPoint:startP];
    [node setFCost:0];
    [node setHCost:0];
    [node setGCost:0];
    
    [closedList addObject:node];
    
    
    //start the path creating
    while(YES) {
        //check the nearest points
        // X
        //XOX
        // X
        for(count = 0; count < 4; count++) {
            checkPoint.x = -1;
            checkPoint.y = -1;
            
            if(count == 0) {
                //UP
                if(node.j-1 > 0) {
                    checkTile = [mainMap getTile:ccp(node.i,node.j -1)];
                    if(checkTile != 0 && [RunnerTiledMap isLadder:checkTile] ) {
                        checkPoint.x = node.i;
                        checkPoint.y = node.j - 1;
                        checkGCost = 20;
                    }
                }
            }
            if(count == 1) {
                //LEFT
                if(node.i-1>=0)
                    if([mainMap getTile:ccp(node.i-1, node.j)]!=0 || (node.i-1>=1 & [mainMap getTile:ccp(node.i-1,node.j)]==0 & [mainMap getTile:ccp(node.i-2,node.j)]!=0 & [mainMap getTile: ccp(node.i,node.j)]!=11)) //where 10 is ladder?
                    {
                        checkPoint.x = node.i - 1;
                        checkPoint.y = node.j;
                        checkGCost = 10;
                    }
            }
            if(count == 2) {
                //DOWN
                if(node.j+1 < [mainMap getMapHeightInTiles]) {
                    checkTile = [mainMap getTile:ccp(node.i,node.j + 1)];
                    if(checkTile!=0 && [RunnerTiledMap isLadder:checkTile]) {
                        checkPoint.x = node.i;
                        checkPoint.y = node.j+1;
                        checkGCost = 20;
                    }
                }
            }
            if(count == 3) {
                //RIGHT
                if(node.i + 1 < [mainMap getMapWidthInTiles])
                    if([mainMap getTile:ccp(node.i+1, node .j)]!=0 || (node.i < [mainMap getMapWidthInTiles] - 2 && [mainMap getTile:ccp(node.i+1,node.j)]==0 && [mainMap getTile:ccp(node.i+2,node.j)]!=0 && [mainMap getTile:ccp(node.i,node.j)]!=11)) //where 13 is a ladder?
                    {
                        checkPoint.x = node.i + 1;
                        checkPoint.y = node.j;
                        checkGCost = 10;
                    }
            }
            
            if(checkPoint.x != -1 && [self checkPoint:checkPoint inList:closedList] == nil) {
                checkNode = [[AStarNode alloc] initWithStart:checkPoint andParent:node];
                
                
                //calculate H,G, and F values (F = H + G)
                //calculate path cost
                [checkNode setGCost: [self calculateGCost:node] + checkGCost];
                [checkNode setHCost:[self heuristicFrom:checkPoint to:endP]];
                [checkNode calculateFCost];
                
                //check if there is the same node in the openList
                AStarNode* vNode = [self checkPoint:checkPoint inList:openList];
                if(vNode != nil) {
                    //compare the part cost (G)
                    if([vNode GCost] < [checkNode GCost]) {
                        [vNode setParentNode:[node parentNode]];
                        int newG = 0;
                        if(vNode.i < [[vNode parentNode] i] || vNode.i > [[vNode parentNode] i]) newG = 10; else newG = 20;
                        [vNode setGCost: newG + [self calculateGCost:[node parentNode]]]; // +newG?
                    }
                } else [openList addObject:checkNode]; //add point to open list
            }
            
            
        }
        //search the node with the lowest F in the open list
        //add it to the closed list and remove it from the open list
        if([openList count]>0) {
            int minF = [(AStarNode*)(openList[0]) FCost];
            int minFcount = 0;
            
            for(count = 0; count < [openList count]; count++) {
                if([(AStarNode*)(openList[count]) FCost] < minF) {
                    minF = [(AStarNode*)(openList[count]) FCost];
                    minFcount = count;
                }
            }
            node = openList[minFcount];
            [closedList addObject:node];
            [openList removeObjectAtIndex:minFcount];
        } else break;
        if(node.i == endP.x && node.j == endP.y) break;
    }
    
    //if([node parentNode] == nil) return nil;
    
    //create a path for the taskList
    AStarNode* path = node;
    
    TaskList* list = [[TaskList alloc] init];
    
    [pathList removeAllObjects];
    
    while(path != nil) {
        CCLOG(@"Path point: [%d,%d]",path.i,path.j);
        [pathList insertObject:path atIndex:0];
        path = [path parentNode];
    }
    
    _lastPoint.x = [(AStarNode*)pathList[[pathList count] -1 ] i];
    _lastPoint.y = [(AStarNode*)pathList[[pathList count] -1 ] j];
    //convert ot scene coords
    _lastPoint = [mainMap getPositionAt:_lastPoint];
    _lastPoint.x +=16;
    
    
    count = 1;
    int checkCount = 1;
    BOOL needJump = NO;
    Task* task;
    NSInteger pathSize = [pathList count];
    int bypass = 0;
    while(count < pathSize) {
        //check if the runner can run horizontaly (I = constant)
        needJump = NO;
        checkCount = count;
        while(checkCount < pathSize && [(AStarNode*)pathList[checkCount-1] j] == [(AStarNode*)pathList[checkCount] j]) {
            if([mainMap getTile:ccp([(AStarNode*)pathList[checkCount] i],[(AStarNode*)pathList[checkCount] j])] == 0) {
                needJump = YES;
                //checkCount++;
                break;
            }
            checkCount++;
        }
        if(checkCount > count || needJump) {
            count = checkCount;
            checkCount--;
            
            CGPoint runPoint = ccp([(AStarNode*)pathList[checkCount] i]*32,[(AStarNode*)pathList[checkCount] j]);
            
            if(needJump) {
                //fix jump position: put the runner close to the edge
                //at first we need to detect the direction...
                
                if(checkCount < pathSize -1) //it always should be, but in case...
                {
                    if([(AStarNode*)pathList[checkCount] i] < [(AStarNode*)pathList[checkCount+1] i]) {
                        runPoint.x +=10;
                    } else runPoint.x -=10;
                }
            }
            
            task = [[Task alloc] initWithTask:RUN_ACTION andPoint:runPoint];
            [list addTask:task];
            CCLOG(@"Add task: %d:[%f,%f]",task.taskType, task.x, task.y);
            
            if(needJump) {
                count++;
                task = [[Task alloc] initWithTask:JUMP_ACTION andPoint:ccp([(AStarNode*)pathList[checkCount] i],[(AStarNode*)pathList[checkCount] j])];
                CCLOG(@"Add task: %d:[%f,%f]",task.taskType, task.x, task.y);
                [list addTask:task];

            }
        }
        //check if the runner can climb (J = constant)
        checkCount = count;
        while(checkCount < pathSize && [(AStarNode*)pathList[checkCount-1] i] == [(AStarNode*)pathList[checkCount] i]) {
            checkCount++;
        }
        if(checkCount > count) {
            count = checkCount;
            checkCount--;
            
            task = [[Task alloc] initWithTask:CLIMB_ACTION andPoint:[mainMap getPositionAt:ccp([(AStarNode*)pathList[checkCount] i],[(AStarNode*)pathList[checkCount] j])]];
            [list addTask:task];
            CCLOG(@"Add task: %d:[%f,%f]",task.taskType, task.x, task.y);
        }
        if(count == pathSize-1) break;
        if(bypass++>200) break;
    }
    return list;
}


-(NSMutableArray*) getPathList {
    return pathList;
}





@end
