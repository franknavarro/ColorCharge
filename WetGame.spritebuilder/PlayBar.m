//
//  PlayBar.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PlayBar_Protected.h"

@implementation PlayBar {
    
    //keeps track of the last touch
    UITouch *activeTouch;
    //holds in all the touches
    NSMutableArray *playerTouches;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //initialize the array
        playerTouches = [NSMutableArray array];
    }
    return self;
}

- (void) onEnter {
    [super onEnter];
    //Turn on user interaction
    self.userInteractionEnabled = YES;
    //Use multiTouch for cleaner presses between buttons
    self.multipleTouchEnabled = YES;
}

//Check to see which color was initially touched
- (void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
    
    //the active touch is now the most recently pressed touch
    activeTouch = touch;
    //add this new touch to the array
    [playerTouches addObject:touch];
    //check which color was touched and assign it as the current color touched
    [self whichColorWasTouched:touch];
}

//Check to see where the new touch is and what color it is touching
- (void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    //Check to see if the touch moved is the current active touch
    if ([touch isEqual:activeTouch]) {
        //get the color of the touch that moved
        [self whichColorWasTouched:touch];
    }
}

//If the touch ended than no colors are being touched
- (void) touchEnded:(CCTouch *)touch withEvent:(UIEvent *)event {
    
    //get the position in the array of saved touches for the current touch
    //  let go
    int objectPosition = [playerTouches indexOfObject:touch];
    
    //remove this touch from the array
    [playerTouches removeObject:touch];
    
    //Check if the array is empty if so then no color is being touched
    if (!playerTouches || !playerTouches.count) {
        //Let program know that no color is being touched
        [self noColorsAreBeingTouched];
    }
    //Check to make sure that touches position was not 0 in the array
    else if (objectPosition) {
        //give priority to the last touched color
        [self whichColorWasTouched:[playerTouches objectAtIndex:(objectPosition-1)]];
    }
    
}

//Check to see which color was touched
-(void) whichColorWasTouched:(CCTouch *) touch {
    
    //Get the location of the touch within the PlayBar
    CGPoint touchLocation = [touch locationInNode:self];
    
    //If the touch is within the red's area set _redTouched to YES
    if (CGRectContainsPoint(self.redBox.boundingBox, touchLocation)) {
        self.currentColorPressed = ActiveColorRed;
    }
    //If the touch is within the blue's area set _blueTouched to YES
    else if (CGRectContainsPoint(self.blueBox.boundingBox, touchLocation )) {
        self.currentColorPressed = ActiveColorBlue;
    }
    //If the touch is within the yellow's area set _yellowTouched to YES
    else if (CGRectContainsPoint(self.yellowBox.boundingBox, touchLocation)) {
        self.currentColorPressed = ActiveColorYellow;
    }
    //If the touch is within none of the PlayBars set that no colors are being touched
    //This is more of a check for the touchMoved method to make sure that the color changes if it is dragged out side the PlayBar
    else {
        [self noColorsAreBeingTouched];
    }
    
    //call update pressed Color so we know the new color
    [self.colorSelectionDelegate updatePressedColor];

}

//No colors where touched so set the active color to nothing
-(void) noColorsAreBeingTouched {
    
    self.currentColorPressed = ActiveColorNone;
    
    //Call update Pressed color so we know the new color
    [self.colorSelectionDelegate updatePressedColor];
    

}



@end
