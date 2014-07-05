//
//  ControlLayer.h
//  Loderunners
//
//  Created by Igor on 27/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "Runner.h"
#import "Player.h"
#import "ControlButton.h"
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import "RunnerTiledMap.h"

@interface ControlLayer : CCNode
-(id) initWithRunner: (Runner*) runner andMap: (RunnerTiledMap*) map;

-(void) rightButtonDown;
-(void) buttonUp;
-(void) leftButtonDown;
-(void) upButtonDown;
-(void) downButtonDown;

@property Runner* mainRunner;
@property RunnerTiledMap* mainMap;
@end
