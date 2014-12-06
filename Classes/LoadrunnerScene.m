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

#import "OpenALManager.h"

#import "CCShader.h"



// -----------------------------------------------------------------------
#pragma mark - LodeRunnerScene
// -----------------------------------------------------------------------


@implementation LoadrunnerScene
{
//private properties
    CCRenderTexture* lightmap;
    NSInteger oscillator;
    
    CCNode* mainScene;  //main scene node
    float screen_width, screen_height;
    
    NSMutableArray* runnersList; //runners list including main character
    
    BOOL debugSpeed; //speed optimization (disable lightmapping...)
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
    
    debugSpeed = YES;
    
    
    //set screen width and height variables
    //[[CCDirector sharedDirector]];
    screen_height = 640;
    screen_width = 1136;
    
    //create lightSources list
    //self.lightSources = [NSMutableArray array];
    runnersList = [NSMutableArray array];
    
    
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
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"fire.plist"];
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
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"torch-small.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"teleport.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"teleport_light.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"mine.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"explosion.plist"];

    
    //load game map (should be xml file in the future
    
    
    //_levelScene  = [[CCNode alloc] init];
    //_levelScene = [[CCSprite alloc] init];
    mainScene = [[CCNode alloc] init];
    
    //init lightmap;
    lightmap = [CCRenderTexture renderTextureWithWidth:screen_width height:screen_height];
    [lightmap setAutoDraw:YES];
    [lightmap.sprite setAnchorPoint:ccp(0,0)];

    
    //init level texture. We are going to draw all scene on this texture and apply a shaders to it
    _levelTexture = [CCRenderTexture renderTextureWithWidth: screen_width height:screen_height];
    if(!debugSpeed) _levelTexture.sprite.shader = [CCShader shaderNamed:@"lightsShader"];
    _levelTexture.sprite.shaderUniforms[@"u_lightTexture"] = lightmap.sprite.texture;
    
    [_levelTexture setAutoDraw:YES];
    [_levelTexture.sprite setAnchorPoint:ccp(0,0)];
    
    [_levelTexture addChild: mainScene];
    
    
    self.levelMap = [RunnerTiledMap runnerTiledMapWithFile:@"level1.tmx"];
    [_levelMap setAnchorPoint:ccp(0,0)];
    [_levelMap setPosition:ccp(0,0)]; //520 340
    [mainScene addChild:self.levelMap];
    //[_levelTexture addChild:self.levelMap];
    
    //DEPRECATE
    //add light sources from the map
    //[_lightSources addObjectsFromArray: [_levelMap getLightSources]];
    
    @try {
        _mainPlayer = [[Player alloc] init];
        [_mainPlayer setPosition: ccp(288,96)];
        //[mainScene addChild:_mainPlayer];
        //[_levelTexture addChild:_mainPlayer];
        [_levelMap addChild:_mainPlayer z: 10];
        [runnersList addObject:_mainPlayer];
    } @catch (NSException *e) {
        CCLOG(@"Error in creating mainPlayer");
    }
    
    
    //set OpenAL listener position
    [[[[OpenALManager sharedInstance] currentContext] listener] setPosition:alpoint(288,96,0)];
    
    
    @try {
        _monster1 = [[Monster alloc] initWithMap:self.levelMap andPrey:_mainPlayer];
        [_monster1 setPosition: ccp(300,50)];
        [_monster1 setColor:[CCColor colorWithRed:1 green:0 blue:0 alpha:0.9]];
        //[mainScene addChild:_monster1];
        //[_levelTexture addChild:_monster1];
        [_levelMap addChild:_monster1 z: 10];
        [runnersList addObject:_monster1];
    } @catch (NSException *e) {
        CCLOG(@"Error in creating monster1");
    }
    
    @try {
        _monster2 = [[Monster alloc] initWithMap:self.levelMap andPrey:_mainPlayer];
        [_monster2 setPosition: ccp(320,280)];
        //[_levelScene addChild:_monster2];
        [runnersList addObject:_monster2];
    } @catch (NSException *e) {
        CCLOG(@"Error in creating monster2");
    }
    
    [_monster1 DEBUGset];
    
    
    [self addChild:_levelTexture];
    
    _controlLayer = [[ControlLayer alloc] initWithRunner:_mainPlayer andMap: _levelMap];
    [self  addChild:_controlLayer];
    
    
    oscillator = 0;

    
    // done
	return self;
}



-(CCSprite *)lightTextureWithColor:(ccColor4F)bgColor textureWidth:(float)textureWidth textureHeight:(float)textureHeight {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureWidth height:textureHeight];
    CCSprite* l = [CCSprite spriteWithImageNamed:@"lightmap1.png"];
    [l setAnchorPoint:ccp(0,0)];
    [l setPosition:ccp(300,300)];
    
    [rt addChild:l];
    [rt setAutoDraw:YES];
    
    [rt.sprite setBlendMode:[CCBlendMode blendModeWithOptions: @{CCBlendFuncSrcColor:@(GL_DST_COLOR),CCBlendFuncDstColor:@(GL_ZERO),}]];
    
    //[_levelScene addChild:rt];
    
    // 2: Call CCRenderTexture:begin
    //[rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    //[l visit];
    
    //[rt end];
    
    // 5: Create a new Sprite from the texture
    //CCSprite * ret = [CCSprite spriteWithTexture:rt.sprite.texture];
    //[ret addChild:l];
    //[ret setBlendMode:[CCBlendMode blendModeWithOptions: @{CCBlendFuncSrcColor:@(GL_DST_COLOR),CCBlendFuncDstColor:@(GL_ZERO),}]];
    

    
    //ret.shader = [CCShader shaderNamed:@"lightsShader"];
    //CCTexture* noise = [CCTexture textureWithFile:@"Noise-hd.png"];
    //noise.texParameters = &(ccTexParams){GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    
    //ret.shaderUniforms[@"u_NoiseTexture"] = noise;
    //ret.shaderUniforms[@"u_LightTexture"] = light;
    
    
    return nil;
}

/**
 *  Generate a lightmap for the scene
 **/
-(void) genLights {
    
    if(debugSpeed) return;
    
    CGPoint playerOffset = [self convertToWorldSpace: [mainScene convertToWorldSpace: [_mainPlayer position]]];
    CGPoint worldOffset = [self convertToWorldSpace:[mainScene convertToWorldSpace: ccp(0,0)]];
    
    //update lights
    CCSprite* playerLight = [CCSprite spriteWithImageNamed:@"lightmap1.png"];
    [playerLight setPosition:ccp(playerOffset.x*2, playerOffset.y*2)];

    worldOffset.x *= 2;
    worldOffset.y *= 2;
    
    NSMutableArray *lightSources = [_levelMap getLightSources];
    NSUInteger amounts = [lightSources count];
    [lightmap beginWithClear:0 g:0 b:0 a:1];
        for(NSUInteger i=0;i<amounts;i++) {
            CGPoint pos = [(CCSprite*)lightSources[i] position];
            pos.x = pos.x*2 + worldOffset.x;
            pos.y = pos.y*2 + worldOffset.y;
            if(pos.x > -200 & pos.x < (screen_width+200)) {
                CCSprite* light  = [lightSources[i] getLightMap];
                if(light!=nil) {
                    [light setPosition: pos];
                    [light setScale:(1.5+ sinf((rand()%4+oscillator++)/60)/25 + 0.005*(rand()%5))];
                    [light visit]; //slow down on iOS emulation
                }
            }
        }
        [playerLight visit];
    [lightmap end];
    
    _levelTexture.sprite.shaderUniforms[@"u_lightTexture"] = lightmap.sprite.texture;
         oscillator++;
}

-(void) update:(CCTime)delta {
    
    //scroll the map
    float leftEdge = (screen_width - [_levelMap widthInPoints])/2;
    if([mainScene position].x <= 0 && [mainScene position].x >= leftEdge) {
        CGPoint worldCoord = [self convertToWorldSpace: [mainScene convertToWorldSpace: [_mainPlayer position]]];
        if(worldCoord.x > 360) {
            //scroll the map left
            [mainScene setPosition:ccp((int)([mainScene position].x-1.5),[mainScene position].y)];
        }
        
        if(worldCoord.x <180) {
            //scroll right
            [mainScene setPosition:ccp((int)([mainScene position].x+5),[mainScene position].y)];
        }
    }
    
    //fix mainScene position
    if([mainScene position].x > 0) [mainScene setPosition:ccp(0,[mainScene position].y)];
    if([mainScene position].x < leftEdge) [mainScene setPosition:ccp(leftEdge,[mainScene position].y)];
    

    for(int i=0;i< [runnersList count];i++) [self updateRunner: runnersList[i]];
    
    //updated teleports
    [_levelMap updateTeleportsByRunner: runnersList];
    
    //update OpenAL listener position
    [[[[OpenALManager sharedInstance] currentContext] listener] setPosition:alpoint([_mainPlayer position].x,[_mainPlayer position].y,0)];
    
    //generate a lightmap
    [self genLights];
}

-(void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform {
    //CCLOG(@"Call draw function");
    
}

/**
 *  update runner state (falling, landing and so on)
 *  @param runner - pointer to a Runner class
 **/
-(void) updateRunner:(Runner *)runner {
    
    //check if the runner is still in scene frame
    CGPoint playerPos = [runner position];
    int width = [runner boundingBox].size.width;
    //int height = [runner boundingBox].size.height;

    
    
    if(playerPos.x < width/4) {
        playerPos.x = width/4;
        [runner setPosition: playerPos];
    }
    if(playerPos.y < 32 - FLOOR_HEIGHT) {
        playerPos.y = 32 - FLOOR_HEIGHT;
        [runner setPosition: playerPos];
    }
    if(playerPos.x > ([_levelMap getMapWidth] - width/4)) {
        playerPos.x = [_levelMap getMapWidth] - width/4;
        [runner setPosition: playerPos];
    }
    if(playerPos.y > ([_levelMap getMapHeight] - 1)) {
        playerPos.y = [_levelMap getMapHeight] - 1;
    }
    
    //update the main scene
    u_int32_t tile = [_levelMap getTileAtPosition:playerPos];
    CGPoint pos = [_levelMap getTilePosWithPoint:playerPos];
    
    //check if the player should fall
    if((![runner isJumping] && [_levelMap getTileAtPosition:[runner position]] == 0 && playerPos.y>31) || (tile==11 && (playerPos.x < pos.x + 4 || playerPos.x > pos.x + 28))) {
        if([runner currentDirection] != UP) {
            [runner fall];
            return;
        }
    }
    if([runner isFalling]) {
        //check if the player should land
        
        if([_levelMap getTileAtPosition:playerPos]!=0 && playerPos.y < ([_levelMap getTilePosWithPoint:playerPos].y)) {
            [runner land];
            
            //fix player y position
            CGPoint ppos = [runner position];
            ppos.y = [_levelMap getTilePosWithPoint:playerPos].y-2;
            [runner setPosition:ppos];
        }
    }
    if([runner currentAction] == CLIMB_ACTION) {
        
        //check if the player reaches the bottom of a  ladder
        CGPoint pos = [_levelMap getTilePosWithPoint:playerPos];
        
        if([_levelMap getTileAtPosition: playerPos] == 10 || [_levelMap getTileAtPosition: playerPos] == 13 ) {
            if(playerPos.y < pos.y - 2) {
                [runner stopAllActions];
                //fix play pos
                playerPos.y = pos.y - 2;
                [runner setPosition:playerPos];
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
            [runner setPosition:playerPos];
            CCLOG(@"Player [%f] pos:[%f] lower_pos:[%f]", playerPos.y, pos.y,lower_position.y);
            [runner stopAllActions];
        }
    }
}



//-(void) addLightSources:(NSSet *)object {
    //[self.lightSources addObject: object];
//}

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
