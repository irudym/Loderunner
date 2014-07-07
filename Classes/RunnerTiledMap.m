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


+(id) runnerTiledMapWithFile:(NSString*)tmxFile
{
    //you should load that data from XML file
    //map: filename.tmx
    //map_layer: map
    //background: bk.png
    
	id map = [[self alloc] initWithFile:tmxFile];
    [map loadBackground:@"background.png"];
    [map setMapLayer:[map layerNamed:@"map"]];
    
    return map;
}


-(void) loadBackground: (NSString*) filename {
    _background = [CCSprite spriteWithImageNamed:filename];
    [_background setPosition:ccp(0,0)];
    [_background setAnchorPoint:ccp(0,0)];
    [self addChild:_background z:-1];
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
 *  Get x,y coord of the tile on the scene which contain point Position
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

@end
