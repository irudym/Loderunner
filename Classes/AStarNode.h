//
//  AStarNode.h
//  Loderunners
//
//  Created by Igor on 28/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AStarNode : NSObject

-(id) init;
-(id) initWithStart: (CGPoint) start andParent: (id) node;

-(int) calculateFCost;
-(void) setPoint: (CGPoint) point;

@property id parentNode;
@property int i,j;
@property int tileType;
@property int FCost;
@property int HCost;
@property int GCost;

@end
