//
//  ControlLayer.m
//  Loderunners
//
//  Created by Igor on 27/06/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import "ControlLayer.h"
#import "Teleport.h"


@implementation ControlLayer

-(id) initWithRunner: (Runner*) runner andMap:(RunnerTiledMap*) map
{
    self = [super init];
    if(self) {
        
        _mainRunner = runner;
        _mainMap = map;
        
        //enable touch handling
        self.userInteractionEnabled = TRUE;
        
        //add elements to the layer
        ControlButton *rightButton = [ControlButton controlButtonWithImage:@"arrow-hd.png"];
        [rightButton setPosition:ccp(520,40)];
        [rightButton setButtonDownTarget:@selector(rightButtonDown) fromObject:self];
        [rightButton setButtonUpTarget:@selector(buttonUp) fromObject:self];
        [self addChild:rightButton];
        
        ControlButton *leftButton = [ControlButton controlButtonWithImage:@"arrow-hd.png"];
        leftButton.flipX = YES;
        [leftButton setPosition:ccp(430,40)];
        [leftButton setButtonDownTarget:@selector(leftButtonDown) fromObject:self];
        [leftButton setButtonUpTarget:@selector(buttonUp) fromObject:self];
        [self addChild:leftButton];
        
        ControlButton* upButton = [ControlButton controlButtonWithImage:@"arrow-hd.png"];
        //upButton.rotationalSkewX = 90;
        [upButton setPosition:ccp(475,70)];
        [upButton setRotation:-90];
        [upButton setButtonDownTarget: @selector(upButtonDown) fromObject: self];
        [upButton setButtonUpTarget:@selector(buttonUp) fromObject:self];
        [self addChild:upButton];
        
        ControlButton *downButton = [ControlButton controlButtonWithImage:@"arrow-hd.png"];
        [downButton setPosition:ccp(475, 25)];
        [downButton setRotation:90];
        [downButton setButtonDownTarget:@selector(downButtonDown) fromObject:self];
        [downButton setButtonUpTarget:@selector(buttonUp) fromObject:self];
        [self addChild:downButton];
        
        ControlButton *actionButton = [ControlButton controlButtonWithImage:@"action-hd.png"];
        [actionButton setPosition:ccp(25,25)];
        [actionButton setButtonDownTarget:@selector(actionButtonDown) fromObject:self];
        [actionButton setButtonUpTarget:@selector(buttonUp) fromObject:self];
        [self addChild:actionButton];
        
    }
    return self;
}

-(void) rightButtonDown {
    //check if the right tile has a place to run from a ladder
    if([_mainRunner currentDirection] == UP) {
        CGPoint playerPos = [_mainRunner position];
        CGPoint currTile = [_mainMap getTileCoordinateAt:playerPos];
        if(currTile.x == [_mainMap getMapWidthInTiles] - 1) return;
        CGPoint nextTile = [_mainMap getPositionAt:ccp(currTile.x+1,currTile.y)];
        
        if([_mainMap getTileAtPosition:nextTile] !=0) {
            if(playerPos.y<nextTile.y-2) return;
        }
    }
    [_mainRunner runX: 1000];
}
//
-(void) buttonUp {
    CCLOG(@"ControlLayer: buttonUp");
    [_mainRunner stop];
}

-(void) leftButtonDown {
    //check if the right tile has a place to run from a ladder
    if([_mainRunner currentDirection] == UP) {
        CGPoint playerPos = [_mainRunner position];
        CGPoint currTile = [_mainMap getTileCoordinateAt:playerPos];
        if(currTile.x == 0) return;
        CGPoint nextTile = [_mainMap getPositionAt:ccp(currTile.x-1,currTile.y)];
        
        if([_mainMap getTileAtPosition:nextTile] !=0) {
            if(playerPos.y<nextTile.y-2) return;
        }
    }
    [_mainRunner runX: -1000];
}

-(void) downButtonDown {
    int tile = [_mainMap getTileAtPosition:[_mainRunner position]];
    CCLOG(@"downButtonDown: Tile at player position is: %d",tile);
    //
    if(tile == 13 || tile == 10 || tile == 11 || tile == 12) {
        float r_x = [_mainRunner position].x;
        CGPoint pos = [_mainMap getTilePosWithPoint:[_mainRunner position]];
        pos.x += 16;
        
        //move player close to the ladder, if the sprite is not too far from the middle of the tile
        if(fabs(pos.x - r_x)<5) {
            r_x = pos.x;
            [_mainRunner setPosition:ccp(r_x, [_mainRunner position].y)];
        }
        
        if(pos.x == r_x) {
            //CCLOG(@"Player:y :%f ",[_mainRunner position].y);
            //if(tile == 12 && (pos.y-4)  < [_mainRunner position].y) return;
            if([_mainRunner currentDirection] == UP) {
                [_mainRunner climbY:-1000];
            } else [_mainRunner stepTo:pos andClimbY:-1000];
        }
        else {
            if(fabsf(r_x-pos.x) > 16) [_mainRunner jump];
            else if((r_x > pos.x && [_mainRunner currentDirection] == LEFT) || (r_x < pos.x && [_mainRunner currentDirection] == RIGHT)) [_mainRunner stepTo:pos andClimbY:-1000]; else [(Player*)_mainRunner duck];
        }
    } else [(Player*)_mainRunner duck];
}

-(void) upButtonDown {
    int tile = [_mainMap getTileAtPosition:[_mainRunner position]];
    CCLOG(@"Tile at player position is: %d",tile);
    
    Teleport *teleport = [_mainMap getTeleportAt:[_mainMap convertToMapCoord:[_mainRunner position]]];
    //
    if(tile == 13 || tile == 10 || tile == 11 || tile == 12) {
        float r_x = [_mainRunner position].x;
        CGPoint pos = [_mainMap getTilePosWithPoint:[_mainRunner position]];
        pos.x += 16;
        
        //move player close to the ladder, if the sprite is not too far from the middle of the tile
        if(fabs(pos.x - r_x)<5) {
            r_x = pos.x;
            [_mainRunner setPosition:ccp(r_x, [_mainRunner position].y)];
        }
        
        if(pos.x == r_x) {
            CCLOG(@"Player:y :%f ",[_mainRunner position].y);
            if(tile == 12 && (pos.y-4)  < [_mainRunner position].y) return;
            if([_mainRunner currentDirection] == UP) {
                [_mainRunner climbY:1000];
            } else [_mainRunner stepTo:pos andClimbY:1000];
        }
        else {
            if(fabsf(r_x-pos.x) > 16) [_mainRunner jump];
            else if((r_x > pos.x && [_mainRunner currentDirection] == LEFT) || (r_x < pos.x && [_mainRunner currentDirection] == RIGHT)) [_mainRunner stepTo:pos andClimbY:1000]; else [_mainRunner jump];
        }
    } else
        if(teleport) { //teleport
            [teleport runWithRunner:_mainRunner];
        } else [_mainRunner jump];
}

-(void) actionButtonDown {
    [_mainRunner stop];
    [(Player*)_mainRunner duck];
    Mine* mine = [[Mine alloc] init];
    CGPoint pos = [_mainRunner position];
    pos.y -= 16;
    [mine setPosition: pos];
    [_mainMap addChild: mine z: 5] ;
}

-(void) actionButtonUp {

}


@end
