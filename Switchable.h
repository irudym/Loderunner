//
//  Switchable.h
//  Loderunners
//
//  Created by Igor on 16/05/15.
//  Copyright (c) 2015 Cloud2Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ON  YES
#define OFF NO


@protocol Switchable <NSObject>

@required
-(void)turn: (BOOL)onoff;

@end

