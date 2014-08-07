//
//  GameplayTutorial.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameplayTutorial.h"
#import "PlayBar_Protected.h"

@implementation GameplayTutorial {
    
    CCNode *_lineArrow; //Used for an arrow pointing to a line
    CCNode *_leftColorArrow; //An arrow that points to a sprecified color on the left playBar
    CCNode *_rightColorArrow; //An arrow that points to a specified color on the right playBar
    CCNode *_boxArrow; //An arrow that points to the hit box a given moments
    CCNode *_scoreArrow; //An arrow that points to the score
    
    CCScene *_tutorialStart; //Begining tutorial sceen
    CCScene *_missedColorScene; //Show the missed color scene in spritebuilder
    CCScene *_tutorialPrimaryColors; //the first tutorial scene for basic instructions
    CCScene *_tutorialScoring;   //explain scoring a point
    CCScene *_tutorialHitBox; //explain that the hit box changes colors depending on the color pressed
    CCScene *_tutorialPractice; //Used to notify user of practice time
    CCScene *_tutorialWhites; //screne for explaining whites
    CCScene *_tutorialMixing; //scene for explaining color mixing
    CCScene *_tutorialDone; // finish the tutorial
    
    CCLabelTTF *_missedColorMessage; // Holds what is said when the color is missed
    CCLabelTTF *_messageOnScoring; //Shows the message for scoring and practice round
    
    BOOL isRightBarOnScreen; //To see whether or not the right playBar is on the screne yet or not
    
    BOOL didPrimaryColorsDisplay; //Check to see whether or not the first tutorial has been displayed yet
    BOOL isTheirFirstPoint; //Check to see wether or not the player has already gotten their first point
    BOOL didPracticeStart; //Checks whether the player has passed through on the next screen of the tutorial after scoring
    BOOL didHitbox; //See's if the hitBox tutorial has ran
    BOOL isFirstWhiteLine; //Checks wether the white line tutorial has played
    BOOL isFirstMix; //Checks whether the mixing color tutorial has ran
    BOOL didWhitesStart; // Checks to see if the first white came out
    BOOL didMixingStart; //checks if mixing colors is on the screen
    BOOL didGreen, didPurple, didOrange; // check if the player has now hit all the colors
    BOOL didFinalScreen; //Check to see if final screen started
}

#pragma mark - On StartUp

- (void) onEnter {
    
    [super onEnter];
    
    //remove the right playbar to teach the player basic controls
    [self removeChild:self.playBarRight cleanup:NO];
    //We just removed the rightBar from the screen so set isRightBarOnScreen to NO
    isRightBarOnScreen = NO;
    
    [self tutorialStarts];
    
}

//Overwrite the this method to do nothing so we start spawning lines at a
//  different time
- (void) spawnNewLineForFirstTime {
    return;
}

- (void) tutorialStarts {
    
    //Stop the line from moving
    self.paused = YES;
    
    //Make it so the player can't hit the pause button because it wigs out
    self.pauseButton.userInteractionEnabled = NO;
    self.pauseButton.visible = NO;
    self.scoreLabel.visible = NO;
    
    _tutorialStart = [CCBReader loadAsScene:@"Tutorials/TutorialStartUp" owner:self];
    
    [self addChild:_tutorialStart];
    
    self.userInteractionEnabled = YES;
    [self scheduleOnce:@selector(startUpGameByPressingColor) delay:2.5f];
    
    
}

- (void) resetScoreDifficulty {
    
    //Reset the score and game difficulty specifically for the tutorial
    self.score = 0;
    self.currentGameDifficulty = GameTutorialPrimaryColors;
    
}

#pragma mark - Update Methods

-(void) update:(CCTime)delta {
    
    [super update:delta];
    
    for (Line *line in self.lines) {

        //Check to see if the first tutorial has been displayed
        if (!didPrimaryColorsDisplay) {
            if (line.position.y <= self.hitBox.position.y) {
                didPrimaryColorsDisplay = YES;
                [self tutorialPrimaryColors:line];
            }
        }
        
        //Check if whites have started
        if (!didWhitesStart) {
            //chek if the lines color is white and the line is at the middle of the hitBox
            if (line.linesColor == ActiveColorNone && line.position.y <= self.hitBox.position.y) {
                //Whites have know started
                didWhitesStart = YES;
                //run the white lines tutorial
                [self tutorialWhites:line];
            }
        }
        if (!didMixingStart) {
            //check if the lines color is green, orange, or purple
            switch (line.linesColor) {
                case ActiveColorGreen:
                case ActiveColorOrange:
                case ActiveColorPurple:
                    if (line.position.y <= self.hitBox.position.y) {
                        //now we are mixing colors
                        didMixingStart = YES;
                        //run the mixing colors tutorial
                        [self tutorialMixingColors:line];
                    }
                    break;
                //default do nothing
                default:
                    break;
            }
        }
        
        switch (line.linesColor) {
            //check off all the colors that have been gone through
            case ActiveColorOrange:
                didOrange = YES;
                break;
            case ActiveColorPurple:
                didPurple = YES;
                break;
            case ActiveColorGreen:
                didGreen = YES;
                break;
            //Do nothing if none of the conditions are met
            default:
                break;
        }
    }
    
    //Check to see if the point tutorial has ran yet
    if (!isTheirFirstPoint) {
        //make sure that the score is only 1
        if (self.score >= 1) {
            //Let the program know that we ran the this already
            isTheirFirstPoint = YES;
            //run the tutorail for scoring
            [self tutorialScoring];
        }
    }
    
    //Check if the lines array is empty
    if (!self.lines || !self.lines.count) {
//        //check if we havent ran the hit box screen
//        if (!didHitbox) {
//            //We now started hit box tutorial
//            didHitbox = YES;
//            //Run the hitbox tutorial
//            [self tutorialHitBox];
//        }
        //check to see if every color has been spawned
        if (didPurple && didGreen && didOrange && !didFinalScreen) {
            didFinalScreen = YES;
            [self endTutorial];
        }
    }
}

- (void) updateGameDifficulty {
    
    if (self.currentGameDifficulty == GameTutorialPrimaryColors && self.score >=7) {
        self.currentGameDifficulty = GameTutorialWhite;
    }
    
    else if (self.currentGameDifficulty == GameTutorialWhite &&self.score >= 14) {
        self.currentGameDifficulty = GameTutorialMixingColors;
    }
    
}

//Overwrite line speed to do nothing for the tutorial so the line speed stays the same
- (void) updateLineSpeed {
    
    return;
    
}

#pragma mark - In the begining...

- (void) tutorialPrimaryColors: (Line *) firstLine {
    
    //Stop the line from moving
    self.paused = YES;
    
    //Make it so the player can't hit the pause button because it wigs out
    self.pauseButton.userInteractionEnabled = NO;
    self.pauseButton.visible = NO;
    self.scoreLabel.visible = NO;
    
    _tutorialPrimaryColors = [CCBReader loadAsScene:@"Tutorials/TutorialPrimaryColors" owner:self];
    
    [self positionLeftButtonArrow:firstLine];
    
    [self positionLineArrow:firstLine];
    
    [self addChild:_tutorialPrimaryColors];
    
    [self scheduleOnce:@selector(startUpGameByPressingColor) delay:2.5];

}

#pragma mark - Scoring

- (void) tutorialScoring {
    
    //Stop the line from moving
    self.paused = YES;
    
    //Make it so the player can't hit the pause button because it wigs out
    self.pauseButton.userInteractionEnabled = NO;
    
    //Load in the scene for the tutorial
    _tutorialScoring = [CCBReader loadAsScene:@"Tutorials/TutorialScoring" owner:self];
    
    //Add in the scene for scoring
    [self addChild:_tutorialScoring];
    
    //Enable user interaction so they can touch anywhere to continue
    self.userInteractionEnabled = YES;
    [self scheduleOnce:@selector(colorPressedInsteadOfScreen) delay:2.5f];
}

- (void) tutorialHitBox {
    
    didHitbox = YES;
    
    //Stop the line from moving
    self.paused = YES;
    
    self.pauseButton.visible = NO;
    self.scoreLabel.visible = NO;
    
    //Load in the scene for the tutorial
    _tutorialHitBox = [CCBReader loadAsScene:@"Tutorials/TutorialHitBox" owner:self];
    
    //Add in the scene for scoring
    [self addChild:_tutorialHitBox];
    
    //Enable user interaction so they can touch anywhere to continue
    self.userInteractionEnabled = YES;
    [self scheduleOnce:@selector(colorPressedInsteadOfScreen) delay:2.5f];
    
}

//- (void) practiceRounds {
//    //We are now going through the practice round
//    didPracticeStart = YES;
//    
//    //Load in the scene for the tutorial
//    _tutorialPractice = [CCBReader loadAsScene:@"Tutorials/TutorialStartPractice" owner:self];
//    
//    //add in the tutorial for practicing
//    [self addChild:_tutorialPractice];
//    
//    //enable user interaction so that the player can press anywhere to continue
//    self.userInteractionEnabled = YES;
//    [self scheduleOnce:@selector(colorPressedInsteadOfScreen) delay:2.5f1.f];
//
//    
//}

- (void) keepSpawningNewLine {
    
    //check to see if all the colors have now been spawned if not continue to next if
    if (!didGreen || !didOrange || !didPurple) {
        
        [super keepSpawningNewLine];

    }
    
}

//We override this function to not do anything because we dont want any score achievements to be
//  eraned in tutorials
- (void) updateScoreAchievements {
    
    return;
    
}

#pragma mark -  Handling Whites

- (void) tutorialWhites: (Line *) whiteLine {
    
    //pause the game
    self.paused = YES;
    //make it so the player cant press or see the pause button
    self.pauseButton.visible = NO;
    self.pauseButton.userInteractionEnabled = NO;
    //clean up the screen and make it look not cluttered
    self.scoreLabel.visible = NO;
    //let touches on the screen continue the game
    self.userInteractionEnabled = YES;
    [self scheduleOnce:@selector(colorPressedInsteadOfScreen) delay:2.5f];

    
    //load up the tutorial
    _tutorialWhites = [CCBReader loadAsScene:@"Tutorials/TutorialWhite" owner:self];
    
    //position the line for the white line
    [self positionLineArrow:whiteLine];
    
    //add the scene
    [self addChild:_tutorialWhites];
    
    
}

#pragma mark - Mixing Colors

- (void) tutorialMixingColors: (Line *) mixedLine {
    
    //pause the game
    self.paused = YES;
    //make it so the player cant press or see the pause button
    self.pauseButton.visible = NO;
    self.pauseButton.userInteractionEnabled = NO;
    //clean up the screen and make it look not cluttered
    self.scoreLabel.visible = NO;
    
    //load up the tutorial
    _tutorialMixing = [CCBReader loadAsScene:@"Tutorials/TutorialMixingColors" owner:self];
    
    //Add the playBar on the right
    [self addChild:self.playBarRight];
    isRightBarOnScreen = YES;
    
    //position the arrow pointing at the line
    [self positionLineArrow:mixedLine];
    //position the button arrows
    [self positionBothButtonArrows:mixedLine];
    
    //add the scene
    [self addChild:_tutorialMixing];
    
    [self scheduleOnce:@selector(startUpGameByPressingColor) delay:2.5];

    
}

#pragma mark - Missing

- (void) loser: (Line *) losingLine {
    
    //Stop the line from moving
    self.paused = YES;
    
    //Make it so the player can't hit the pause button because it wigs out
    self.pauseButton.userInteractionEnabled = NO;
    self.pauseButton.visible = NO;
    self.scoreLabel.visible = NO;
    
    //Load the scene telling the player that they hit the wrong color
    _missedColorScene = [CCBReader loadAsScene:@"Tutorials/TutorialMissedColor" owner:self];
    
    //if the right Bar is on the screen add the arrows poistions
    if (isRightBarOnScreen) {
        //Set both arrows positions prompting the player which color to press
        [self positionBothButtonArrows:losingLine];
        
    } else {
        [_rightColorArrow removeFromParent];
        [self positionLeftButtonArrow:losingLine];
    }
    
    //add the notification to the screen
    [self addChild:_missedColorScene];
    
    if (losingLine.linesColor == ActiveColorNone) {
        _missedColorMessage.string = [NSString stringWithFormat:@"For White lines you let go of\neverything!"];
        [self scheduleOnce:@selector(startUpGameByPressingColor) delay:0.1f];
    } else {
        [self scheduleOnce:@selector(startUpGameByPressingColor) delay:0.1f];
    }
    
}

#pragma mark - Position Arrows

- (void) positionLeftButtonArrow: (Line *) line {
    
    //Holds the position of which ever box we want the arrow to point at
    CGPoint boxPosition;
    
    //Depending on the lines color update the arrows position to the correct color box
    switch (line.linesColor) {
        //For Red and Orange point the arrow at the Red Box
        case ActiveColorRed:
        case ActiveColorOrange: {
            boxPosition = self.playBarLeft.redBox.positionInPoints;
            boxPosition = [self.playBarLeft convertToWorldSpace:boxPosition];
            boxPosition = [_leftColorArrow.parent convertToNodeSpace:boxPosition];
            
            _leftColorArrow.position = boxPosition;
        }
            break;
        //For Blue and Purple point the arrow at the Blue Box
        case ActiveColorBlue:
        case ActiveColorPurple:{
            boxPosition = self.playBarLeft.blueBox.positionInPoints;
            boxPosition = [self.playBarLeft convertToWorldSpace:boxPosition];
            boxPosition = [_leftColorArrow.parent convertToNodeSpace:boxPosition];
            
            _leftColorArrow.position = boxPosition;
        }
            break;
        //For Yellow and Green point the arrow at the Yellow Box
        case ActiveColorYellow:
        case ActiveColorGreen:{
            boxPosition = self.playBarLeft.yellowBox.positionInPoints;
            boxPosition = [self.playBarLeft convertToWorldSpace:boxPosition];
            boxPosition = [_leftColorArrow.parent convertToNodeSpace:boxPosition];
            
            _leftColorArrow.position = boxPosition;
        }
            break;

        default:
            //Remove the Arrow from its parent
            [_leftColorArrow removeFromParent];
            break;
    }
    
}

-(void) positionBothButtonArrows: (Line *) line {
    
    [self positionLeftButtonArrow:line];
    
    //Holds the position of which ever box we want the arrow to point at
    CGPoint boxPosition;
    
    //Depending on the lines color update the arrows position to the correct color box
    switch (line.linesColor) {
            //For Red and Orange point the arrow at the Red Box
        case ActiveColorYellow:
        case ActiveColorOrange: {
            boxPosition = self.playBarRight.yellowBox.positionInPoints;
            boxPosition = [self.playBarRight convertToWorldSpace:boxPosition];
            boxPosition = [_rightColorArrow.parent convertToNodeSpace:boxPosition];
            
            _rightColorArrow.position = boxPosition;
        }
            break;
            //For Blue and Purple point the arrow at the Blue Box
        case ActiveColorRed:
        case ActiveColorPurple:{
            boxPosition = self.playBarRight.redBox.positionInPoints;
            boxPosition = [self.playBarRight convertToWorldSpace:boxPosition];
            boxPosition = [_rightColorArrow.parent convertToNodeSpace:boxPosition];
            
            _rightColorArrow.position = boxPosition;
        }
            break;
            //For Yellow and Green point the arrow at the Yellow Box
        case ActiveColorBlue:
        case ActiveColorGreen:{
            boxPosition = self.playBarRight.blueBox.positionInPoints;
            boxPosition = [self.playBarRight convertToWorldSpace:boxPosition];
            boxPosition = [_rightColorArrow.parent convertToNodeSpace:boxPosition];
            
            _rightColorArrow.position = boxPosition;
        }
            break;
            
        default:
            //Remove the Arrow from its parent
            [_rightColorArrow removeFromParent];
            break;
    }
    
}

- (void) positionLineArrow: (Line *) line {
    
    CGPoint arrowPosition = ccp(line.position.x+(line.contentSize.width/3), line.position.y+(line.contentSize.height/2));
    _lineArrow.position = arrowPosition;
    
}

#pragma mark - Finished

- (void) endTutorial {
    
    self.pauseButton.visible = NO;
    self.pauseButton.userInteractionEnabled = NO;
    self.scoreLabel.visible = NO;
    
    _tutorialDone = [CCBReader loadAsScene:@"Tutorials/TutorialDone"];
    
    [self addChild:_tutorialDone];
    
    self.userInteractionEnabled = YES;
    [self scheduleOnce:@selector(colorPressedInsteadOfScreen) delay:2.5f];
    
}

- (void) backToMenu {
    
    CCScene *gameStart = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameStart];
    
    //Save that the tutorial has been done
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"TutroialHasRan"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}

#pragma mark - User Interactions

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [self tutorialRemoval];
    
}

- (void) colorPressedInsteadOfScreen {
    switch (self.currentColorBeingPressed) {
            //Check if a color was pressed
        case ActiveColorRed:
        case ActiveColorBlue:
        case ActiveColorYellow:
        case ActiveColorGreen:
        case ActiveColorOrange:
        case ActiveColorPurple:
            //if so run tutorial removal
            [self tutorialRemoval];
            //return method to stop it from rescheduling itself later
            return;
            break;
            
        default:
            break;
    }
    
    //Reschedule this method to check again for color being pressed
    [self unschedule:@selector(colorPressedInsteadOfScreen)];
    [self schedule:@selector(colorPressedInsteadOfScreen) interval:0.1f];
}

- (void) startUpGameByPressingColor {
    
    //Go through the lines to check if the player is now hitting the right color again
    for (Line *line in self.lines) {
        CGFloat lineMaxY = CGRectGetMaxY(line.boundingBox);
        CGFloat hitBoxMaxY = CGRectGetMaxY(self.hitBox.boundingBox);
        //check if the line is at half height and the top is above the hit box
        if (line.position.y <= self.hitBox.position.y && (lineMaxY + 4) >= hitBoxMaxY ) {
            if (line.linesColor == self.currentColorBeingPressed) {
                //resume the game
                self.paused = NO;
                //reveal the pause button and what not again
                self.pauseButton.visible = YES;
                self.pauseButton.userInteractionEnabled = YES;
                self.scoreLabel.visible = YES;
                //unschedule itself if we have met the condition
                [self unschedule:@selector(startUpGameByPressingColor)];
                //scenes to remove after color is pressed
                [_missedColorScene removeFromParent];
                [_tutorialPrimaryColors removeFromParent];
                [_tutorialMixing removeFromParent];
                 //stop running so we dont reschedule this method after
                return;
            }
        }
    }
    
    //reschedule so we run this again
    [self unschedule:@selector(startUpGameByPressingColor)];
    [self scheduleOnce:@selector(startUpGameByPressingColor) delay:0.1f];
}

- (void) tutorialRemoval {
    
    //disable user interaction so screen presses wont
    //  bug out
    self.userInteractionEnabled = NO;
    [self unschedule:@selector(colorPressedInsteadOfScreen)];
    
    //The first conditional is made to remove the last turorial ran
    //  this method removes all the tutorials that activate user interaction
    //  starting with last to first so that way the conditional statements exucte
    //  starting with the first tutorial and when a newer tutorial comes, the program doesn't
    //  try and remove the old one anymore
    if (didOrange && didGreen && didPurple) {
        [self backToMenu];
    }
    
    //check if whites have started
    else if (didWhitesStart) {
        //resume Game with pause activated
        self.paused = NO;
        self.pauseButton.userInteractionEnabled = YES;
        //Add the stuff we removed in the whites tutorial
        self.pauseButton.visible = YES;
        self.scoreLabel.visible = YES;
        //remove the white tutorial
        [_tutorialWhites removeFromParent];
        //stop the code so the rest doesn't start
        return;
    }
    
//    //if the practice is now starting
//    else if (didPracticeStart) {
//        //Show the HUD again
//        self.pauseButton.visible = YES;
//        self.scoreLabel.visible = YES;
//        self.paused = NO;
//        self.pauseButton.userInteractionEnabled = YES;
//        //spawn a new line to start with an delay so that it can
//        //  wait for the count down to finish
//        [self scheduleOnce:@selector(spawnNewLine) delay:4.f];
//        [_tutorialPractice removeFromParent];
//    }
    
    //Check if the Hitbox tutorial ran
    else if (didHitbox) {
        
        //remove the hit box tutorial
        [_tutorialHitBox removeFromParent];
        //Show the HUD again
        self.pauseButton.visible = YES;
        self.scoreLabel.visible = YES;
        self.paused = NO;
        self.pauseButton.userInteractionEnabled = YES;
//        //Let the user know we are now starting practice rounds
//        [self practiceRounds];
        
    }
    
    //Check if we are now within the first point tutorial
    else if (isTheirFirstPoint) {
        [_tutorialScoring removeFromParent];
        //resume the tutorial
        [self tutorialHitBox];
    }
    
    else {
        //remove these scenes to continue
        [_tutorialStart removeFromParent];
        //Stop the line from moving
        self.paused = NO;
        //Make it so the player can't hit the pause button because it wigs out
        self.pauseButton.visible = YES;
        self.pauseButton.userInteractionEnabled = YES;
        self.scoreLabel.visible = YES;
        
        [self spawnNewLine];
    
    }
    
}

- (void) loadPauseScreen {
    
    //Save the Gameplay scene
    self.pauseMenu = [CCBReader loadAsScene:@"PauseMenuTutorial" owner:self];
    //Display pause box on top of the current scene
    [self addChild: self.pauseMenu];
    
}

@end
