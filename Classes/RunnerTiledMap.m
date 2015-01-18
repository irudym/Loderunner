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
    NSMutableArray* teleports; //array of teleports
    NSMutableArray* lifts; //array of lifts
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
    teleports = [NSMutableArray array];
    lifts = [NSMutableArray array];
    
    //load objects from object layer and put them to corresponding lists
    NSInteger x, y;
    for(int i=0; i<[objects count];i++) {
        //run through objects and their properties
        x = [[objects[i] valueForKey:@"x"] integerValue];
        y = [[objects[i] valueForKey:@"y"] integerValue];
        
        if([[objects[i] valueForKey:@"type"] isEqual:@"torch"]) {
            CCLOG(@"Add torch(%ld,%ld,%@)",(long)x,y,[objects[i] valueForKey:@"file"]);
            Torch* torch = [[Torch alloc] initWithName:[objects[i] valueForKey:@"file"] andSound:[objects[i] valueForKey:@"sound"] andPosition:ccp(x,y)];
            [self addChild:torch];
            [lightSources addObject: torch];
        } else if([[objects[i] valueForKey:@"type"] isEqual: @"lift"]) {
            CCLOG(@"Add lift(%ld,%ld,%@)",(long)x,y,[objects[i] valueForKey:@"name"]);
            //fix lift position;
            CGPoint coord = [self convertToMapCoord:ccp(x,y)];
            CCLOG(@"Lift MAP coord: (%f,%f)",coord.x,coord.y);
            
            
            CGPoint testP = [self convertToSceneCoord:ccp(11,9)];
            CCLOG(@"test point: %f,%f",testP.x, testP.y);
            
            CGPoint fcoord = [self convertToSceneCoord:coord];
            fcoord.x += 3;
            
            CCLOG(@"Lift SCENE coord: %f, %f",fcoord.x, fcoord.y);
            
            CGPoint toPos;
            toPos.x = [[objects[i] valueForKey:@"toI"] doubleValue];
            toPos.y = [[objects[i] valueForKey:@"toJ"] doubleValue];
            CCLOG(@"To pos: %f,%f", toPos.x, toPos.y);
            
            Lift* lift = [[Lift alloc] initWithPosition:fcoord];
            toPos = [self convertToSceneCoord:toPos];
            //fix to pos
            toPos.x += 3;
            [lift setToPosition:toPos];
            
            
            [self addChild: lift z:10];
            [lightSources addObject:lift];
            [lifts addObject:lift];
        } else if([[objects[i] valueForKey:@"type"] isEqual:@"teleport"]) {
            CGPoint coord = [self convertToMapCoord:ccp(x,y)];
            CCLOG(@"Add teleport(%f,%f)",coord.x,coord.y);
        
            Teleport* tel = [[Teleport alloc] initAtPosition:coord withName:[objects[i] valueForKey:@"name"]];
            //add sprite position on the scene
            [tel setPosition:[self convertToSceneCoord:coord]];
            
            [tel setLinkToName:[objects[i] valueForKey:@"linkTo"]];
            
            [self addChild:tel z:100];
            [teleports addObject:tel];
            [tel activate];
            
            CGPoint runnerPos = [self convertToSceneCoord:coord];
            runnerPos.x += [self tileSize].width/2;
            [tel setRunnerPosition: runnerPos];
            
            //add light source
            [lightSources addObject:tel];
        }
        
    }
    
    //update teleports (link them to each other)
    for(int i=0;i<[teleports count];i++) {
        if([teleports[i] linkTo] == nil) {
            Teleport* tel = [self getTeleportByName:[teleports[i] linkToName]];
            if(tel!=nil) {
                [teleports[i] setLinkTo:tel];
            } else CCLOG(@"ERROR: there is no teleport with name: %@ !",[teleports[i] linkToName]);
        }
    }
    
    //set wdith and height
    self.widthInPoints = [self getMapWidth]*2;
    self.heightInPoints = [self getMapHeight]*2;
    
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

/** DEPRICATED
 *  Return the position in tile coordinates of the tile specified by position in points (cocos2d).
 *
 *  @param position Position in points.
 *  @return Coordinate of the tile at that position.
 */
-(CGPoint) getTileCoordinateAt:(CGPoint)pos {
    return [_mapLayer tileCoordinateAt:pos];
}

/**
 *  Return the position in tile coordinates of the tile specified by position in points (cocos2d).
 *
 *  @param position Position in points.
 *  @return Coordinate of the tile at that position.
 */
-(CGPoint) convertToMapCoord:(CGPoint)pos
{
    return [_mapLayer tileCoordinateAt:pos];
}

/**
 *  Return the position in scene coordinates of the tile specified by position in Map coords (cocos2d).
 *
 *  @param position Position in map coords.
 *  @return scene coordinates 
 */
-(CGPoint) convertToSceneCoord:(CGPoint)pos
{
    return [_mapLayer positionAt:pos];
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


-(Teleport*) getTeleportByName:(NSString *)name {
    Teleport *tel;
    for(int i=0;i<[teleports count];i++) {
        tel = teleports[i];
        if([[tel name] isEqualToString: name]) {
            return tel;
        }
    }
    return nil;
}


/**
 * Return teleport (if it exists) at position in map coorfinates
 *
 *  @param  position - Position in map coordinates (i,j)
 *  @return pointer to a teleport or nil in case there is no a teleport at provide position
 */
-(Teleport*) getTeleportAt:(CGPoint)pos {
    Teleport* tel;
    
    for(int i=0;i<[teleports count];i++) {
        tel = teleports[i];
        if([tel mapPosition].x == pos.x && [tel mapPosition].y == pos.y) return tel;
    }
    return nil;
}

-(void) updateTeleportsByRunner:(NSMutableArray*)runners {
    BOOL activated;
    for(int tels=0;tels < [teleports count];tels++) {
        activated = NO;
        CGPoint tpos = [(Teleport*)teleports[tels] mapPosition];
        //check if anybody at the teleport
        for(int runs = 0;runs < [runners count];runs++) {
            CGPoint rpos = [self convertToMapCoord:[(CCSprite*)runners[runs] position]];
            if(rpos.x == tpos.x && rpos.y == tpos.y) {
                activated = YES;
                [teleports[tels] activate];
                break;
            }
        }
        if(!activated) [teleports[tels] deactivate];
    }
}


-(void) sendMessage:(int)type withPosition:(CGPoint)position {
    switch(type) {
        case MSG_EXPLOSION : {
            //CCLOG(@"EXPLOSION in map!!! at position: %f,%f",position.x,position.y);
            [self destroyTileAtPosition:position];
        } break;
    }
}

-(u_int32_t) destroyTileAtPosition:(CGPoint)position {
    CGPoint mapPos = [self convertToMapCoord:position];
    
    u_int32_t tile = [_mapLayer tileGIDAt:mapPos];
    
    //NSMutableDictionary* properties = [self propertiesForGID:tile];
    //CCLOG(@"Tile: %d properties: destroyable = %@", tile,[[self propertiesForGID:tile] valueForKey:@"destroyable"]);
    
    if([[self propertiesForGID:tile] valueForKey:@"destroyable"] == nil) [_mapLayer removeTileAt:mapPos];
       
    return tile;
}

-(void) addChild:(CCNode *)child z:(NSInteger)z {
    [super addChild:child z:z];
    if([child conformsToProtocol:@protocol(LightSource)]) {
        CCLOG(@"Adding light source");
        [lightSources addObject:child];
    }
}

-(void) removeChild:(CCNode *)child {
    
    if([child conformsToProtocol:@protocol(LightSource)]) {
        CCLOG(@"Remove light source");
        [lightSources removeObject:child];
    }
    [super removeChild:child];
}

/**
 * Return lift object (if it exists) at position in map coordinates
 *
 *  @param  position - Position in map coordinates (i,j)
 *  @return pointer to a lift or nil in case there is no a lift at provide position
 */
-(Lift*) getLiftAt: (CGPoint) pos {
    Lift* lift;
    CGPoint mapPos;
    
    for(int i=0;i<[lifts count];i++) {
        lift = lifts[i];
        mapPos = [self convertToMapCoord:[lift position]];
        //CCLOG(@"lift mapPos[%f,%f] , scenePos[%f,%f]",mapPos.x, mapPos.y, [lift position].x, [lift position].y);
        if(mapPos.x == pos.x && mapPos.y == pos.y) return lift;
    }
    return nil;
}

@end
