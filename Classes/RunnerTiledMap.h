//
//  RunnerTiledMap.h
//  Loderunners
//
//  Created by Igor on 30/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "CCTiledMap.h"
#import "cocos2d.h"

#define FLOOR_HEIGHT 6
#define TILE_HIGHT 32

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


/**
 *  Return tile ID at provided tilemap postion
 *  @param pos - tilemap position (i,j)
 *  @return tile ID
 */
-(u_int32_t) getTile: (CGPoint) pos;


-(CGPoint) getTilePosWithPoint: (CGPoint) pos;
-(void) setTile: (uint32_t) gid atPosition: (CGPoint) pos;


/**
 *  Return the position in tile coordinates of the tile specified by position in points (cocos2d).
 *
 *  @param position Position in points.
 *  @return Coordinate of the tile at that position.
 */
-(CGPoint) getTileCoordinateAt: (CGPoint) pos;


-(CGPoint) getPositionAt: (CGPoint) pos;

-(float) getMapWidth;
-(float) getMapHeight;
-(float) getMapWidthInTiles;
-(float) getMapHeightInTiles;

@property CCSprite* background;
@property CCTiledMapLayer* mapLayer;

@property float widthInPoints, heightInPoints;

@end
