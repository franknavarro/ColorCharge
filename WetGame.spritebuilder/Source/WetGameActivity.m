//
//  WetGameActivity.m
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 7/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WetGameActivity.h"

@implementation WetGameActivity

- (CCScene *)startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}

- (BOOL)onKeyUp:(int32_t)keyCode keyEvent:(AndroidKeyEvent *)event
{
    if (keyCode == AndroidKeyEventKeycodeBack)
    {
        [self finish];
    }
    return NO;
}


@end
