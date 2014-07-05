//
//  RunnerTiledMap.h
//  Loderunners
//
//  Created by Igor on 30/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "CCTiledMap.h"
#import "cocos2d.h"

@interface RunnerTiledMap : CCTiledMap 

+(id) runnerTiledMapWithFile:(NSString*)tmxFile;
-(void) loadBackground: (NSString*) filename;

/**
 *  Return tile ID at provided postion
 *  the function automaticaly convert coco2d coords to tilemap coords
 *  @param pos - coco2d position
 *  @return tile ID
 */
-(u_int32_t) getTileAtPosition: (CGPoint) pos;

-(CGPoint) getTilePosWithPoint: (CGPoint) pos;

-(float) getMapWidth;
-(float) getMapHeight;

@property CCSprite* background;
@property CCTiledMapLayer* mapLayer;

@property float widthInPoints, heightInPoints;

@end
