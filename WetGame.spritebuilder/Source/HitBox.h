//
//  HitBox.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Color.h"

@interface HitBox : CCNode

@property (assign) ActiveColor currentBoxColor;

- (void) updateBoxColor: (ActiveColor) newColor;

@end
