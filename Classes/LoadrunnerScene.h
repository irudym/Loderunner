//
//  HelloWorldScene.h
//  Loderunners
//
//  Created by Igor on 23/06/14.
//  Copyright Cloud2Logic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Player.h"
#import "Monster.h"
#import "ControlLayer.h"
#import "RunnerTiledMap.h"
#import "Torch.h"


#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface LoadrunnerScene : CCScene

// -----------------------------------------------------------------------

+ (LoadrunnerScene *)scene;
- (id)init;

-(void) update:(CCTime)delta;

-(CCSprite*) lightTextureWithColor: (ccColor4F)bgColor textureWidth:(float)textureWidth textureHeight:(float)textureHeight;


/**
 *  update runner state (falling, landing and so on)
 *  @param runner - pointer to a Runner class
 **/
-(void) updateRunner: (Runner*) runner;


/**
 *  Add a light source to the scene
 *  genLiightMap function creates lightmap image based on the list of sources
 *  @param  object - CCSprite object
 **/
//-(void) addLightSource: (CCSprite*) object;

/** 
 *  Generate a lightmap for the scene
 **/
-(void) genLights;

//override
-(void) draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform;


@property Player* mainPlayer;
@property Monster* monster1;
@property Monster* monster2;
@property Torch* torch;
@property ControlLayer* controlLayer;
@property RunnerTiledMap* levelMap;

//@property CCSprite* levelScene;
@property CCRenderTexture* levelTexture;

//light sources
@property NSMutableArray* lightSources;


// -----------------------------------------------------------------------
@end