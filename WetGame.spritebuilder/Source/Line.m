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
static int sameLineCount;
static BOOL firstLineDone;
static GameDifficulty gameDifficulty;

@implementation Line {
    //A code connnection for the ColorNode of the line in Spritebuilder
    CCNodeColor *_color;
    CCNodeColor *_shadow;
}

- (void) setRandomColor: (GameDifficulty) currentGameDifficulty {
    
    gameDifficulty = currentGameDifficulty;
    
    switch (currentGameDifficulty) {
            
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
            
        case GameTutorialPrimaryColors:
            [self spawnOnTutorialPrimaryColors];
            break;
            
        case GameTutorialWhite:
            [self spawnOnTutorialWhite];
            break;
            
        case GameTutorialMixingColors:
            [self spawnOnTutorialMixingColors];
            break;
    }
    
}

#pragma mark - Random Spawning for Game Difficulties

-(void)spawnOnEasy {
    //Get a random integer from 0-7
    int randomNumber = arc4random()%8;

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
    }
    //Set White Line
    else if (randomNumber == 6) {
        //Change the color to white
        [self changeToNewColor:ActiveColorNone];
    }
    
    //Set the color to the previous color
    else {
        [self changeToNewColor:previousActiveColor];
        sameLineCount++;
    }
}

-(void) spawnOnMediumAndHard {
    
    //Get a random integer from 0-17
    int randomNumber = arc4random()%18;
    
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
        sameLineCount++;
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
        sameLineCount++;
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

#pragma mark - Spawning Probabilities on Tutorials

- (void) spawnOnTutorialPrimaryColors {
    
    //Get a random integer from 0-5
    int randomNumber = arc4random()%7;
    
    //Only set the three primary colors based on the number but never spawn
    //  the same color twice in a row
    //Spawn Red
    if (randomNumber <= 1) {
        [self changeToNewColor:ActiveColorRed];
    }
    //Spawn Blue
    else if (randomNumber <= 3) {
        [self changeToNewColor:ActiveColorBlue];
    }
    //Spawn Yellow
    else if (randomNumber <= 5) {
        [self changeToNewColor:ActiveColorYellow];
    }
    //Default yellow if no other lines have spawned
    else if (!firstLineDone) {
        //Change the color to yellow
        [self changeToNewColor:ActiveColorYellow];
        firstLineDone = YES;
    }
    
    else {
        [self changeToNewColor:previousActiveColor];
    }
    
}

- (void) spawnOnTutorialWhite {
    
    //Get a random integer from 0-7
    int randomNumber = arc4random()%7;
    
    //Only set the three primary colors based on the number but never spawn
    //  the same color twice in a row
    //Spawn Red
    if (randomNumber == 0) {
        [self changeToNewColor:ActiveColorRed];
    }
    //Spawn Blue
    else if (randomNumber == 1) {
        [self changeToNewColor:ActiveColorBlue];
    }
    //Spawn Yellow
    else if (randomNumber == 2) {
        [self changeToNewColor:ActiveColorYellow];
    }
    //Spawn White
    else if (randomNumber <= 5) {
        [self changeToNewColor:ActiveColorNone];
    }
    //Try again if none of the condition are met
    else {
        [self changeToNewColor:previousActiveColor];
    }
    
}

- (void) spawnOnTutorialMixingColors {
    
    //Get a random integer from 0-14
    int randomNumber = arc4random()%18;
    
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
    
    //Set Purple Line
    else if (randomNumber <= 8) {
        //Change the color to purple
        [self changeToNewColor:ActiveColorPurple];
    }
    
    //Set Green Line
    else if (randomNumber <= 11) {
        //change the color to green
        [self changeToNewColor:ActiveColorGreen];
    }
    
    //Set Orange Line
    else if (randomNumber <= 14) {
        //change the color to orange
        [self changeToNewColor:ActiveColorOrange];
    }
    
    //Set White Line
    else if (randomNumber <= 16) {
        //Change the color to white
        [self changeToNewColor:ActiveColorNone];
    }
    
    //Set the color to the previous color
    else {
        [self changeToNewColor:previousActiveColor];
    }
}

#pragma mark - Change color

- (void) changeToNewColor: (ActiveColor) newColor {
    
    //since we are now changing the color of the line the first line has
    // to be done
    if (!firstLineDone) {
        firstLineDone = YES;
    }
    
    //if the same color line has now repeated more than 2 times then set
    //  the line instead to the the next color in the enum
    if (sameLineCount >= 1 && newColor == previousActiveColor) {
        //check to see if we are on easy
        if (gameDifficulty == GameEasy) {
            //if the new color is greater than yellow than set it to red
            if (newColor >= ActiveColorYellow) {
                newColor = ActiveColorRed;
            }
            //otherwise set to the next color
            else {
                newColor++;
            }
        //if we are on anything other than easy just increment the line color
        } else {
            if (newColor == ActiveColorOrange) {
                newColor--;
            } else {
                newColor++;
            }
        }
        
        //reset the same Line Count
        sameLineCount = 0;
        
    }
    
    //change the color of the object to the new color
    [Color changeObject:_color withColor:newColor];
    [Color changeObject:_shadow withOffSetColor:newColor];
    
    //Save what the lines current color is
    self.linesColor = newColor;
    
    //Check to see if the color is the same as the one before it
    if (self.linesColor == previousActiveColor) {
        //if so set the same color as before varible to true
        self.sameColorAsBefore = YES;
        //Keep track of how many of the same color we have had
        sameLineCount++;
    } else {
        //if not set the same color as before variable to false
        self.sameColorAsBefore = NO;
        //Reset the same line count because the color has changed
        sameLineCount = 0;
    }
    
    //the previous color is now the new lines color
    previousActiveColor = self.linesColor;
    
}

+ (void) resetFirstLineDone {
    
    firstLineDone = NO;
    
}

+ (BOOL) isFirstLineDone {
    
    return firstLineDone;
    
}

@end
