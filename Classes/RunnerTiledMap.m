//
//  RunnerTiledMap.m
//  Loderunners
//
//  Add backgound image support to cocos2d tilemap class
//  Created by Igor on 30/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "RunnerTiledMap.h"

@implementation RunnerTiledMap

{
    NSMutableArray* lightSources;
}


+(id) runnerTiledMapWithFile:(NSString*)tmxFile
{
	id map = [[self alloc] initWithFile:tmxFile];
    return map;
}

-(id) initWithFile:(NSString *)tmxFile {
    //you should load that data from XML file
    //map: filename.tmx
    //map_layer: map
    //background: bk.png
    
    self = [super initWithFile: tmxFile];
    
    [self loadBackground:@"background.png"];
    [self setMapLayer:[self layerNamed:@"map"]];
    
    NSAssert([self objectGroupNamed:@"objects"] != nil, @"tile map has no object layer");
    
    
    NSMutableArray* objects = [[self objectGroupNamed:@"objects"] objects];
    
    lightSources = [NSMutableArray array];
    
    //load objects from object layer
    NSInteger x, y;
    for(int i=0; i<[objects count];i++) {
        //run through objects and their properties
        x = [[objects[i] valueForKey:@"x"] integerValue];
        y = [[objects[i] valueForKey:@"y"] integerValue];
        
        if([[objects[i] valueForKey:@"name"] isEqual:@"torch"]) {
            CCLOG(@"Add torch(%ld,%ld,%@)",(long)x,y,[objects[i] valueForKey:@"file"]);
            Torch* torch = [[Torch alloc] initWithName:[objects[i] valueForKey:@"file"] andSound:[objects[i] valueForKey:@"sound"] andPosition:ccp(x,y)];
            [self addChild:torch];
            [lightSources addObject: torch];
        }
        
    }

    return self;
}

/**
 *@function load objects from "objectsGroup"
 **/
-(void) loadObjects {
    
}

-(NSMutableArray*) getLightSources {
    return lightSources;
}


-(void) loadBackground: (NSString*) filename {
    _background = [CCSprite spriteWithImageNamed:filename];
    [_background setPosition:ccp(0,0)];
    [_background setAnchorPoint:ccp(0,0)];
    [self addChild:_background z: -1];
}

/**
 *  Return tile ID at provided postion
 *  the function automaticaly convert coco2d coords to tilemap coords
 *  @param pos - coco2d position
 *  @return tile ID
 */
-(u_int32_t) getTileAtPosition: (CGPoint) pos {
    return [_mapLayer tileGIDAt:[_mapLayer tileCoordinateAt:pos]];
}


/**
 *  Return tile ID at provided tilemap postion
 *  @param pos - tilemap position (i,j)
 *  @return tile ID
 */
-(u_int32_t) getTile: (CGPoint) pos {
    if(pos.x < 0 || pos.y < 0) return 0;
    return [_mapLayer tileGIDAt:pos];
}

/** 
 *  Get x,y coord of the tile on the scene which contains point Position
 */
-(CGPoint) getTilePosWithPoint:(CGPoint)point {
    CGPoint pos = [_mapLayer positionAt:[_mapLayer tileCoordinateAt:point]];
    return pos;
}

-(float) getMapHeight {
    return [self mapSize].height*[self tileSize].height;
}

-(float) getMapWidth {
    return [self mapSize].width*[self tileSize].width;
}

-(void) setTile:(uint32_t) gid atPosition :(CGPoint)pos {
    [[self mapLayer] setTileGID: gid at:[_mapLayer tileCoordinateAt:pos]];
}

/**
 *  Return the position in tile coordinates of the tile specified by position in points (cocos2d).
 *
 *  @param position Position in points.
 *  @return Coordinate of the tile at that position.
 */
-(CGPoint) getTileCoordinateAt:(CGPoint)pos {
    return [_mapLayer tileCoordinateAt:pos];
}

-(float) getMapWidthInTiles {
    return [self mapSize].width;
}

-(float) getMapHeightInTiles {
    return [self mapSize].height;
}

-(CGPoint) getPositionAt:(CGPoint)pos {
    if(pos.x>=0 && pos.y>=0 && pos.x<[_mapLayer layerSize].width && pos.y<[_mapLayer layerSize].height)
        return [_mapLayer positionAt:pos];
    else return ccp(1,1);
}

+(BOOL) isLadder:(u_int32_t)GID {
    return (GID >= 10 && GID <= 13);
}

@end
