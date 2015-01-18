//
//  RunnerTiledMap.h
//  Loderunners
//
//  Created by Igor on 30/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "CCTiledMap.h"
#import "cocos2d.h"

#import "Torch.h"
#import "Teleport.h"
#import "Lift.h"

#import "Message.h"

#define FLOOR_HEIGHT 6
#define TILE_HIGHT 32

@interface RunnerTiledMap : CCTiledMap <Message>

+(id) runnerTiledMapWithFile:(NSString*)tmxFile;

-(id) initWithFile:(NSString *)tmxFile;
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


/** DEPRICATED
 *  Return the position in tile coordinates of the tile specified by position in points (cocos2d).
 *
 *  @param position Position in points.
 *  @return Coordinate of the tile at that position.
 */
-(CGPoint) getTileCoordinateAt: (CGPoint) pos;


-(CGPoint) convertToMapCoord: (CGPoint) pos;
-(CGPoint) convertToSceneCoord: (CGPoint) pos;

/**
 * Return teleport (if it exists) at position in map coorfinates
 *
 *  @param  position - Position in map coordinates (i,j)
 *  @return pointer to a teleport or nil in case there is no a teleport at provide position
*/
-(Teleport*) getTeleportAt: (CGPoint) pos;
-(Teleport*) getTeleportByName: (NSString*) name;

/**
 * Return lift object (if it exists) at position in map coorfinates
 *
 *  @param  position - Position in map coordinates (i,j)
 *  @return pointer to a lift or nil in case there is no a lift at provide position
 */
-(Lift*) getLiftAt: (CGPoint) pos;


/**
 * updated all teleports: activate them if case a runner at the teloport
 * deactivate a teleport if there is no runner at it
 **/
-(void) updateTeleportsByRunner:(NSMutableArray*) runners;


-(CGPoint) getPositionAt: (CGPoint) pos;

-(float) getMapWidth;
-(float) getMapHeight;
-(float) getMapWidthInTiles;
-(float) getMapHeightInTiles;

-(void) loadObjects;

//send message to map
-(void) sendMessage:(int)type withPosition:(CGPoint)position;

/**
 * Destroy tile at scene position
 *
 *  @param  position - Position in scene coordinates (x,y)
 *  @return 0 if tile was destroyed of tile ID otherwise
 */
-(u_int32_t) destroyTileAtPosition: (CGPoint)position;

/**
 *  Check if tile GID belongs to ladders tiles.
 *
 *  @pGID tile ID.
 *  @return YES or NO
 */
+(BOOL) isLadder: (u_int32_t) GID;
//+(BOOL) isTeleport: (u_int32_t) GID;

/** 
 * Return an array of light sources
 **/
-(NSMutableArray*) getLightSources;

/**
 * OVERRIDED method
 **/
-(void) addChild: (CCNode*) child z:(NSInteger)z;


/**
 * OVERRIDED method
 **/
-(void) removeChild: (CCNode*)child;


@property CCSprite* background;
@property CCTiledMapLayer* mapLayer;

@property float widthInPoints, heightInPoints;

@end
