//
//  Player.h
//  Loderunners
//
//  Created by Igor on 26/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Runner.h"
#import <UIKit/UIKit.h>

@interface Player : Runner
-(id)init;

/**
 *  To duck the runner, to avoid somethin of place a bomb
 */
-(void) duck;

-(void) followingAction;
-(void) idle;
-(void) stop;

@property NSMutableArray* duckAnimation;
@property NSMutableArray* duckAction;
@property NSMutableArray* duckFrames;

@property (getter = isDuck) BOOL ducked;

@end
