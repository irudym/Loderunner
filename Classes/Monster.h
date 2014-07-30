//
//  Monster.h
//  Loderunners
//
//  Created by Igor on 15/07/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Runner.h"
#import "RunnerTiledMap.h"

@interface Monster : Runner

-(id) init;
-(id) initWithMap: (RunnerTiledMap*) map andPrey: (Runner*) prey;

-(void)load;

-(void) updateAI;
-(void) update:(CCTime)delta;

-(void)DEBUGshowPath;
-(void)DEBUGset;

//override Runner functions
-(void) fall;


@property Runner* preyRunner;

@end
