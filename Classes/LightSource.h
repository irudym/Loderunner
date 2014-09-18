//
//  LightSource.h
//  Loderunners
//
//  Created by Igor on 07/09/14.
//  Copyright (c) 2014 Cloud2Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@protocol LightSource <NSObject>

@required
-(CCSprite*) getLightMap;

@end
