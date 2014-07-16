//
//  PlayBar.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PlayBar.h"

@implementation PlayBar {
    CCNode *_redBox;
    CCNode *_blueBox;
    CCNode *_yellowBox;
}

- (void) onEnter {
    [super onEnter];
    //Turn on user interaction
    self.userInteractionEnabled = YES;
}

//Check to see which color was initially touched
- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self whichColorWasTouched:touch];
}

//Check to see where the new touch is and what color it is touching
- (void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self whichColorWasTouched:touch];
}

//If the touch is dragged off the screen than no colors are being touched
-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self noColorsAreBeingTouched];
}

//If the touch ended than no colors are being touched
- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self noColorsAreBeingTouched];
}

//Check to see which color was touched
-(void) whichColorWasTouched:(UITouch *) touch {
    
    //Get the location of the touch within the PlayBar
    CGPoint touchLocation = [touch locationInNode:self];
    
    //If the touch is within the red's area set _redTouched to YES
    if (CGRectContainsPoint(_redBox.boundingBox, touchLocation)) {
        self.currentColorPressed = ActiveColorRed;
    }
    //If the touch is within the blue's area set _blueTouched to YES
    else if (CGRectContainsPoint(_blueBox.boundingBox, touchLocation )) {
        self.currentColorPressed = ActiveColorBlue;
    }
    //If the touch is within the yellow's area set _yellowTouched to YES
    else if (CGRectContainsPoint(_yellowBox.boundingBox, touchLocation)) {
        self.currentColorPressed = ActiveColorYellow;
    }
    //If the touch is within none of the PlayBars set that no colors are being touched
    //This is more of a check for the touchMoved method to make sure that the color changes if it is dragged out side the PlayBar
    else {
        [self noColorsAreBeingTouched];
    }

}

//No colors where touched so set all values to NO
-(void) noColorsAreBeingTouched {
    
    self.currentColorPressed = ActiveColorNone;

}



@end
