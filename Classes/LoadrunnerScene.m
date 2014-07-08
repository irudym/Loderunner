//
//  HelloWorldScene.m
//  Loderunners
//
//  Created by Igor on 23/06/14.
//  Copyright Cloud2Logic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "LoadrunnerScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - LodeRunnerScene
// -----------------------------------------------------------------------


@implementation LoadrunnerScene
{
//private properties
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (LoadrunnerScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f]];
    [self addChild:background];
    
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
    
    
    
    
    //load game pictures
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"run-right.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-stop-right.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-rotate.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-stand.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-run-left.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-stop-left.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-short-jump-right.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-short-jump-left.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-landing-right.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-landing-left.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"player-climb.plist"];
    
    
    //load game map (should be xml file in the future
    
    
    _levelScene  = [[CCNode alloc] init];
    
    
    
    self.levelMap = [RunnerTiledMap runnerTiledMapWithFile:@"testmap1.tmx"];
    @try {
        CCLOG(@"Tile at [1,1] : %d",[_levelMap getTileAtPosition: ccp(100,84)]);
    } @catch (NSException* e) {
        CCLOG(@"Error getting tile at position 0,0");
    }
    //[self addChild: self.levelMap];
    [_levelScene addChild:self.levelMap];
    
    
    @try {
        _mainPlayer = [[Player alloc] init];
        [_mainPlayer setPosition: ccp(100,210)];
        //[self addChild:_mainPlayer];
        [_levelScene addChild:_mainPlayer];
    } @catch (NSException *e) {
        CCLOG(@"Error in creating mainPlayer");
    }
    
    
    [self addChild:_levelScene];
    
    _controlLayer = [[ControlLayer alloc] initWithRunner:_mainPlayer andMap: _levelMap];
    [self  addChild:_controlLayer];
    

    // done
	return self;
}

-(void) update:(CCTime)delta {
    //scroll the map
    CGPoint worldCoord = [self convertToWorldSpace: [_levelScene convertToWorldSpace: [_mainPlayer position]]];
    
    if(worldCoord.x > 360) {
        //scroll the map left
        
        [_levelScene setPosition:ccp([_levelScene position].x-4,[_levelScene position].y)];
    }
    
    if(worldCoord.x <180) {
        //scroll right
        if([_levelScene position].x<0) [_levelScene setPosition:ccp([_levelScene position].x+4,[_levelScene position].y)];
    }

    
    //check if player is still in scene frame
    CGPoint playerPos = [_mainPlayer position];
    int width = [_mainPlayer boundingBox].size.width;
    int height = [_mainPlayer boundingBox].size.height;
    //float playerH = [_mainPlayer boundingBox].size.height;
    
    
    if(playerPos.x < width/4) {
        playerPos.x = width/4;
        [_mainPlayer setPosition: playerPos];
    }
    if(playerPos.y < 32 - FLOOR_HEIGHT) {
        playerPos.y = 32 - FLOOR_HEIGHT;
        [_mainPlayer setPosition: playerPos];
    }
    if(playerPos.x > ([_levelMap getMapWidth] - width/4)) {
        playerPos.x = [_levelMap getMapWidth] - width/4;
        [_mainPlayer setPosition: playerPos];
    }
    if(playerPos.y > ([_levelMap getMapHeight] - 1)) {
        playerPos.y = [_levelMap getMapHeight] - 1;
    }
    
    //update the main scene
    u_int32_t tile = [_levelMap getTileAtPosition:playerPos];
    CGPoint pos = [_levelMap getTilePosWithPoint:playerPos];
    
    //check if the player should fall
    if((![_mainPlayer isJumping] && [_levelMap getTileAtPosition:[_mainPlayer position]] == 0 && playerPos.y>31) || (tile==11 && (playerPos.x < pos.x + 4 || playerPos.x > pos.x + 28))) {
        if([_mainPlayer currentDirection] != UP) {
            [_mainPlayer fall];
            return;
        }
    }
    if([_mainPlayer isFalling]) {
        //check if the player should land
        
        if([_levelMap getTileAtPosition:playerPos]!=0 && playerPos.y < ([_levelMap getTilePosWithPoint:playerPos].y)) {
            [_mainPlayer land];
            
            //fix player y position
            CGPoint ppos = [_mainPlayer position];
            ppos.y = [_levelMap getTilePosWithPoint:playerPos].y-2;
            [_mainPlayer setPosition:ppos];
        }
    }
    if([_mainPlayer currentAction] == CLIMB_ACTION) {
        
        //check if the player reaches the bottom of a  ladder
        CGPoint pos = [_levelMap getTilePosWithPoint:playerPos];
        
        if([_levelMap getTileAtPosition: playerPos] == 10 || [_levelMap getTileAtPosition: playerPos] == 13 ) {
            if(playerPos.y < pos.y - 2) {
                [_mainPlayer stopAllActions];
                //fix play pos
                playerPos.y = pos.y - 2;
                [_mainPlayer setPosition:playerPos];
            }
        }
        
        //check if the player reaches the top of a ladder
        //the runner can move faster and skip the border of the tile, to take it into consideration we need to check lower position
        CGPoint lower_position = playerPos;
        lower_position.y -= 32;
        if(lower_position.y < 1) lower_position.y = 1;
        if([_levelMap getTileAtPosition:lower_position] == 12) {
            
            pos.y = (int)(lower_position.y/32)*32;
            
            playerPos.y = pos.y+30;
            [_mainPlayer setPosition:playerPos];
            CCLOG(@"Player [%f] pos:[%f] lower_pos:[%f]", playerPos.y, pos.y,lower_position.y);
            [_mainPlayer stopAllActions];
        }
    }
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
