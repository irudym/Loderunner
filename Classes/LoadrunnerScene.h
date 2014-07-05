//
//  HelloWorldScene.h
//  Loderunners
//
//  Created by Igor on 23/06/14.
//  Copyright Cloud2Logic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Player.h"
#import "ControlLayer.h"
#import "RunnerTiledMap.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface LoadrunnerScene : CCScene

// -----------------------------------------------------------------------

+ (LoadrunnerScene *)scene;
- (id)init;

-(void) update:(CCTime)delta;

@property Player *mainPlayer;
@property ControlLayer* controlLayer;
@property RunnerTiledMap* levelMap;

@property CCNode* levelScene;

// -----------------------------------------------------------------------
@end