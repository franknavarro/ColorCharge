//
//  PlayBar.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface PlayBar : CCNode

//Keep track of what buttons are touched
@property (assign) BOOL redTouched;
@property (assign) BOOL blueTouched;
@property (assign) BOOL yellowTouched;

@end
