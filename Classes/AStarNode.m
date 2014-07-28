//
//  AStarNode.m
//  Loderunners
//
//  Created by Igor on 28/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "AStarNode.h"

@implementation AStarNode

@synthesize FCost, HCost, GCost;
@synthesize parentNode;

-(id) init {
    self = [super init];
    if(!self) return (nil);
    self.parentNode = nil;
    return self;
}

-(id) initWithStart:(CGPoint)start andParent:(id)node {
    self = [self init];
    
    self.i = start.x;
    self.j = start.y;
    self.parentNode = node;
    
    return self;
}

-(int) calculateFCost {
    self.FCost = self.HCost + self.GCost;
    return self.FCost;
}

-(void) setPoint:(CGPoint)point {
    self.i = point.x;
    self.j = point.y;
}



@end
