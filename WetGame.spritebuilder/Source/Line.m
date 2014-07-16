//
//  Line.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Line.h"
#import "Gameplay.h"

//Saves in the last Active color of the line
static ActiveColor *previousActiveColor;
static BOOL firstLineDone;

@implementation Line {
    //A code connnection for the ColorNode of the line in Spritebuilder
    CCNodeColor *_color;
}

- (void) setRandomColor {
    
    switch ([Gameplay getGameDifficulty]) {
            
        case GameEasy:
            [self spawnOnEasy];
            break;
            
        case GameMedium: case GameHard:
            [self spawnOnMediumAndHard];
            break;
            
        case GameIntense: case GameExpert:
            [self spawnOnIntense];
            break;
            
        case GameHowAreYouStillPlaying:
            [self spawnOnHowAreYouStillPlaying];
            break;
    }
    
}

-(void)spawnOnEasy {
    //Get a random integer from 0-8
    int randomNumber = arc4random()%9;
    
    //Set Red Line if the integer is between 0-2
    if(randomNumber <= 1) {
        //Change the lines color to red
        [self changeToNewColor:ActiveColorRed];
    }
    
    //Set Blue Line
    else if(randomNumber <= 3) {
        //Change the color to blue
        [self changeToNewColor:ActiveColorBlue];
    }
    
    //Set Yellow Line
    else if (randomNumber <= 5) {
        //Change the color to yellow
        [self changeToNewColor:ActiveColorYellow];
    }
    
    else if (!firstLineDone) {
        //Change the color to yellow
        [self changeToNewColor:ActiveColorYellow];
        firstLineDone = YES;
    }
    //Set White Line
    else if (randomNumber == 6) {
        //Change the color to white
        [self changeToNewColor:ActiveColorNone];
    }
    
    //Set the color to the previous color
    else {
        [self changeToNewColor:previousActiveColor];
    }
}

-(void) spawnOnMediumAndHard {
    
    //Get a random integer from 0-18
    int randomNumber = arc4random()%19;
    
    //Set Red Line if the integer is between 0-2
    if(randomNumber <= 2) {
        //Change the lines color to red
        [self changeToNewColor:ActiveColorRed];
    }
    
    //Set Blue Line
    else if(randomNumber <= 5) {
        //Change the color to blue
        [self changeToNewColor:ActiveColorBlue];
    }
    
    //Set Yellow Line
    else if (randomNumber <= 8) {
        //Change the color to yellow
        [self changeToNewColor:ActiveColorYellow];
    }
    
    //Set Purple Line
    else if (randomNumber <= 10) {
        //Change the color to purple
        [self changeToNewColor:ActiveColorPurple];
    }
    
    //Set Green Line
    else if (randomNumber <= 12) {
        //change the color to green
        [self changeToNewColor:ActiveColorGreen];
    }
    
    //Set Orange Line
    else if (randomNumber <= 14) {
        //change the color to orange
        [self changeToNewColor:ActiveColorOrange];
    }
    
    //Set White Line
    else if (randomNumber == 15) {
        //Change the color to white
        [self changeToNewColor:ActiveColorNone];
    }
    
    //Set the color to the previous color
    else {
        [self changeToNewColor:previousActiveColor];
    }
}

-(void) spawnOnIntense {
    
    //Get a random integer from 0-21
    int randomNumber = arc4random()%22;
    
    //Set Red Line if the integer is between 0-2
    if(randomNumber <= 2) {
        //Change the lines color to red
        [self changeToNewColor:ActiveColorRed];
    }
    
    //Set Blue Line
    else if(randomNumber <= 5) {
        //Change the color to blue
        [self changeToNewColor:ActiveColorBlue];
    }
    
    //Set Yellow Line
    else if (randomNumber <= 8) {
        //Change the color to yellow
        [self changeToNewColor:ActiveColorYellow];
    }
    
    //Set Purple Line
    else if (randomNumber <= 11) {
        //Change the color to purple
        [self changeToNewColor:ActiveColorPurple];
    }
    
    //Set Green Line
    else if (randomNumber <= 14) {
        //change the color to green
        [self changeToNewColor:ActiveColorGreen];
    }
    
    //Set Orange Line
    else if (randomNumber <= 17) {
        //change the color to orange
        [self changeToNewColor:ActiveColorOrange];
    }
    
    //Set White Line
    else if (randomNumber <=19) {
        //Change the color to white
        [self changeToNewColor:ActiveColorNone];
    }
    
    //Set the color to the previous color
    else {
        [self changeToNewColor:previousActiveColor];
    }

    
}

-(void) spawnOnHowAreYouStillPlaying {
    //Get a random integer from 0-9
    int randomNumber = arc4random()%10;
    
    //Set Red Line if the integer is between 0-2
    if(randomNumber == 0) {
        //Change the lines color to red
        [self changeToNewColor:ActiveColorRed];
    }
    
    //Set Blue Line
    else if(randomNumber == 1) {
        //Change the color to blue
        [self changeToNewColor:ActiveColorBlue];
    }
    
    //Set Yellow Line
    else if (randomNumber == 2) {
        //Change the color to yellow
        [self changeToNewColor:ActiveColorYellow];
    }
    
    //Set Purple Line
    else if (randomNumber <= 4) {
        //Change the color to purple
        [self changeToNewColor:ActiveColorGreen];
    }
    
    //Set Green Line
    else if (randomNumber <= 6) {
        //change the color to green
        [self changeToNewColor:ActiveColorPurple];
    }
    
    //Set Orange Line
    else if (randomNumber <= 8) {
        //change the color to orange
        [self changeToNewColor:ActiveColorOrange];
    }
    
    //Set White Line
    else if (randomNumber == 9) {
        //Change the color to white
        [self changeToNewColor:ActiveColorNone];
    }

}

- (void) changeToNewColor: (ActiveColor) newColor {
    
    switch (newColor) {
            
        case ActiveColorBlue: {
            //Set the lines color to blue
            [_color setColor:[CCColor colorWithRed:0.f green:0.f blue:1.f]];
        }
            break;
    
        case ActiveColorRed: {
            //Set the current color to Red
            [_color setColor:[CCColor colorWithRed:1.f green:0.f blue:0.f]];
        }
            break;
    
        case ActiveColorYellow: {
            //Set the current color to yellow
            [_color setColor:[CCColor colorWithRed:1.f green:1.f blue:0.f]];
        }
            break;
    
        case ActiveColorPurple: {
            //Set the current color to purple
            [_color setColor:[CCColor colorWithRed:0.4f green:0.17f blue:0.56f]];
        }
            break;
    
        case ActiveColorGreen: {
            //Set the current color to green
            [_color setColor:[CCColor colorWithRed:0.f green:1.f blue:0.f]];
        }
            break;
            
        case ActiveColorOrange: {
            //Set the current color to orange
            [_color setColor:[CCColor colorWithRed:1.f green:0.58f blue:0.11f]];
        }
            break;
            
        case ActiveColorNone: {
            //Set the current color to white
            [_color setColor:[CCColor colorWithRed:1.f green:1.f blue:1.f]];
        }
            break;
    }
    
    //Save what the lines current color is
    self.linesColor = newColor;
    
    //Check to see if the color is the same as the one before it
    if (self.linesColor == previousActiveColor) {
        //if so set the same color as before varible to true
        self.sameColorAsBefore = YES;
    } else {
        //if not set the same color as before variable to false
        self.sameColorAsBefore = NO;
    }
    
    //the previous color is now the new lines color
    previousActiveColor = self.linesColor;
    
}

@end
