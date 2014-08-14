
//
//  Gameplay.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay_Protected.h"
#import "Color.h"
#import "GameOver.h"
#import "AppDelegate.h"
#import "GameCenterFiles.h"

//Defines how fast the lines will fall down the screen and how quickly they will appear at the top of the screen
struct LineSpeed {
    
    double fallVelocity; //fall speed
    double spawnSpeed; //spawn speed at the top of the screen
    
};

@implementation Gameplay {
    
    NSMutableArray *_backgroundBoxes;

    CCNode *_lineSpawner; //Add the lines to the scene onto the scene through this node that encompases the screen size

    CCSprite *_bottomHitBox;
    
    CCLabelTTF *_countDownLabel; //count down timer when paused
    
    CCParticleExplosion *_scoreParticles;
    
    int _addToScore; //used for when encountering a longer line the amount of points added for the length of the line
    
    //Game speeds are a fall velocity with a respawn time of whatever second
    struct LineSpeed currentLineSpeed;
    
    CCNode *_background;
    CCNodeColor *_backgroundColor;
    CCNodeColor *_hideParticlesColor;
//    CCNodeColor *_leftMask;
//    CCNodeColor *_rightMask;
    
    //Used to test time signature and wether the timing of the lines crossing the hit box was on beat
    CCNode *oldBlock; //block that help keeps time with music
    CCNode *oldTestBlock; //block the helps keep time with line
    BOOL rightPosition; //Used to tell position in relation to oldBlock
    BOOL leftTestPosition; //Used to tell position in relation to oldTestBlock
    
    BOOL isGameOver; // check to see if the game is over
    
    BOOL isBoxGrey; //used to make box flash between grey and currentColor
    
    BOOL first, second, thrid;
    
}

#pragma mark - Setting Up the Start

- (instancetype)init
{
    self = [super init];
    if (self) {
        //Initialize the self.lines array
        //NOTE TO SELF: [NSMutableArray array] is the same as [[alloc]init] for an array
        self.lines = [NSMutableArray array];
        
        _backgroundBoxes = [NSMutableArray array];
        
    }
        return self;
}

//As soon as the file is loaded
-(void) didLoadFromCCB {
    
    //Set the currentLine speed to slow settings
    currentLineSpeed.fallVelocity = -150.f;
    currentLineSpeed. spawnSpeed = 1.31f;
    
    //set the color Selection Delagte to call the updatePressedColor method within Gameplay(self)
    self.playBarRight.colorSelectionDelegate = self;
    self.playBarLeft.colorSelectionDelegate = self;
    
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    appDelegate.gameplayScene = self;
    
    //Set background to offset white
    [Color changeObject:_backgroundColor withOffSetColor:ActiveColorNone];
    [Color changeObject:_hideParticlesColor withOffSetColor:ActiveColorNone];
    
    [self resetScoreDifficulty];
    
}

- (void) onEnter {
    
    [super onEnter];
    
    [self resetScoreDifficulty];
}

- (void)onEnterTransitionDidFinish {
    
    [super onEnterTransitionDidFinish];
    
    [self spawnNewLineForFirstTime];
    
    //[[OALSimpleAudio sharedInstance] playBg:@"ProjectGame1.mp3" volume:1.f pan:0.f loop:YES];
    
    [self spawnNewBackgroundBox];
    
//    //This was used for test to see if block would stay in time
//    [self schedule:@selector(displayBlock) interval:1.f];
    
}

//The reason this is its own method is because in the tutorial we want the
//  first line to spawn at a different time so we overwrite this in the tutorial
//  to do nothing so we can start spawning lines when we want
- (void) spawnNewLineForFirstTime {
    //Start by spawning a line that calls its self again with a delay
    [self spawnNewLine];
}

- (void) resetScoreDifficulty {
    
    //Reset the score and game difficulty every time the gameplay scene is entered
    self.score = 0;
    self.currentGameDifficulty = GameEasy;
    
}

- (void) spawnNewBackgroundBox {
    
    //Check to make sure its not GameOver
    if (!isGameOver) {
        //Get the screensize
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
        
        //Create a new box to spawn
        CCNode *newBox = [CCBReader load:@"BackgroundBox"];
        
        //randomly get an x and y position on the screen to get a boxes position
        int xPosition = arc4random() % (int)screenSize.width;
        int yPosition = arc4random() % (int)screenSize.height;
        
        //set up the boxes position to the new random spot
        newBox.position = ccp(xPosition, yPosition);
        
        //put the box on the screen
        [_background addChild:newBox];
        
        //add the box to an array
        [_backgroundBoxes addObject:newBox];
        
        //Check if there are 4 or more boxes remove the first
        if ([_backgroundBoxes count] >= 4) {
            [_backgroundBoxes removeObjectAtIndex:0];
        }
        
        CCLOG(@"%lu", (unsigned long)[_backgroundBoxes count]);
        
        //Unschedule and schedule to make a new box
        [self unschedule:@selector(spawnNewBackgroundBox)];
        [self scheduleOnce:@selector(spawnNewBackgroundBox) delay:2.f];
    }

    //If it is gameOver get rid of all the background boxes
    else {
        [_backgroundBoxes removeAllObjects];
    }
}

#pragma mark - Update Methods

- (void) playScoreSound: (ActiveColor) scoreColor {
    
    switch (scoreColor) {
            
        case ActiveColorBlue:
            [[OALSimpleAudio sharedInstance] playEffect:@"MarimbaCLow.mp3"];
            break;
            
        case ActiveColorRed:
            [[OALSimpleAudio sharedInstance] playEffect:@"MarimbaELow.mp3"];
            break;
            
        case ActiveColorYellow:
            [[OALSimpleAudio sharedInstance] playEffect:@"MarimbaGLow.mp3"];
            break;
            
        case ActiveColorGreen:
            [[OALSimpleAudio sharedInstance] playEffect:@"MarimbaE.mp3"];
            break;
            
        case ActiveColorPurple:
            [[OALSimpleAudio sharedInstance] playEffect:@"MarimbaG.mp3"];
            break;
            
        case ActiveColorOrange:
            [[OALSimpleAudio sharedInstance] playEffect:@"MarimbaCHigh.mp3"];
            break;
            
        case ActiveColorNone:
            [[OALSimpleAudio sharedInstance] playEffect:@"MarimbaC.mp3"];
            break;
            
        default:
            break;
    }
    
    
}

//calls every frame
- (void) update:(CCTime)delta {
    
    //An array to keep track of which lines we now have to remove from the game once it i outside of the scene
    NSMutableArray *removeFromLines = [NSMutableArray array];
    
    //Run through the lines to check if the line's color is being pressed
    for (Line *line in self.lines) {

        
        //if it is gameOver dont move the line or chek if we lost already
        if (!isGameOver) {
            //check to see if the player has lost
            [self checkLosingCondition:line];
            
            [self updateBackground];
            
            //make the lines scroll down the screen
            line.position = ccp(line.position.x, line.position.y + currentLineSpeed.fallVelocity * delta);
        }

    
        //If the line is completely outside the screen add it to the array of lines to be taken out
        if (line.position.y < -(line.boundingBox.size.height)) {
            [removeFromLines addObject:line];
        }
        
        if (line.position.y <= CGRectGetMaxY(self.hitBox.boundingBox) && !line.sameColorAsBefore) {
            if (self.currentColorBeingPressed == line.linesColor && !line.soundPlayed) {
                [self playScoreSound:line.linesColor];
                line.soundPlayed = YES;
            }
        }
        
////********************************************************************************************
////Simulate Game For ScreenShots
//        
//        CGFloat bottom = CGRectGetMinY(self.hitBox.boundingBox) - 25;
//        int mid = self.hitBox.position.y;
//        
//        if (line.position.y < bottom && CGRectGetMaxY(line.boundingBox) > CGRectGetMaxY(self.hitBox.boundingBox) && self.score >= 152 && !first) {
//            first = YES;
//        }
//        
//        else if (line.position.y < mid && CGRectGetMaxY(line.boundingBox) > CGRectGetMaxY(self.hitBox.boundingBox) && self.score >= 107
//                 && !second) {
//            second = YES;
//            if (self.hitBox.currentBoxColor != line.linesColor) {
//                [Color changeObject:_bottomHitBox withColor:line.linesColor];
//                [self.hitBox updateBoxColor:line.linesColor];
//            }
//
//        }
//        
//        else if (line.position.y < bottom && CGRectGetMaxY(line.boundingBox) > CGRectGetMaxY(self.hitBox.boundingBox) && self.score >= 61 && !thrid) {
//            thrid = YES;
//        }
//
////********************************************************************************************

        
        //Keep track of how many exisiting lines there are
        //CCLOG(@"%d", self.lines.count);
    }
    
    //delete the line from self.lines array by going through the array of lines we want to get rid of
    for (Line *removeLine in removeFromLines) {
        //Remove the line
        [self.lines removeObject:removeLine];
        //Delete it from the scene
        [removeLine removeFromParent];
    }
    
    //Keep count of how many objects are in lines
    int n = (int)[self.lines count];
    //Iterate through every object in the array self.lines in order to add up score
    for (int i=0; i<n; i++) {
        //Saves the current line into a variable of the object Line
        Line *line = self.lines[i];
        //If the top of the line is less than or equal to the middle of the hit box then go onto next check
        if (CGRectGetMaxY(line.boundingBox) <= self.hitBox.position.y) {
            //Make sure the score for this line has not yet been counted
            if (!line.scoreCounted) {
                //Check to see if another line after exists within the array
                if ([self.lines count] > 1) {
                    //Save the line after the current one being checked into a variable
                    Line *lineAfter = self.lines[i+1];
                    //Make sure that the cuurent lines color and the color of the line after arent the same
                    if (line.linesColor != lineAfter.linesColor) {
                        //If so update the score and let the game know that the score has been counted for this line
                        line.scoreCounted = YES;
                        //Increment the score by one for the line that  was scored
                        self.score++;
                        //Add the amount extra for longer lines
                        self.score+=_addToScore;
                        //Reset the value for adding to score for longer lines
                        _addToScore = 0;
                        //Update the score value
                        self.scoreLabel.string = [NSString stringWithFormat:@"%i", self.score];
                        [self updateScoreAchievements];
                    } else {
                        //If so update the score and let the game know that the score has been counted for this line
                        line.scoreCounted = YES;
                        _addToScore++;
                    }
                } else {
                    line.scoreCounted = YES;
                    //Increment the score by one for the line that  was scored
                    self.score++;
                    //Update the score value
                    self.scoreLabel.string = [NSString stringWithFormat:@"%i", self.score];

                }
            }
        }
      }

        //        //Use visuals and audio to check the beat at which a line hits the middle of the self.hitBox
        //        //Check to see if the line is at or a little bellow the middle of self.hitBox
        //        if (line.position.y <= self.hitBox.position.y && !line.passedMidBox) {
        //            //Check to see if another after exists
        //            if (self.lines[i+1]) {
        //                //Save the line after the current one being checked into a variable
        //                Line *lineAfter = self.lines[i+1];
        //                //Make sure that the cuurent lines color and the color of the line after arent the same
        //                if (line.linesColor != lineAfter.linesColor) {
        //                    //Set the line has already passed the middle of the self.hitBox
        //                    line.passedMidBox = TRUE;
        //                    //Test the beat that the line is going at with a visual
        //                    [self displayTestTimeBlock];
        //                    //Play snare to test the beat that the line is going at with audio
        //                    [[OALSimpleAudio sharedInstance] playEffect:@"1Snare.m4a"];
        //                }
        //            }
        //
        //        }
}

- (void) playParticles {
    CCParticleSystem *scoreParticles = (CCParticleSystem *)[CCBReader load:@"TouchParticles"];
    
    scoreParticles.autoRemoveOnFinish = YES;
    
    scoreParticles.position = _scoreLabel.position;
    
    //Add the particle
    [self addChild:scoreParticles z:_scoreLabel.zOrder-1];
    
}

-(void) updatePressedColor {
    
    //if we hit a gameOver dont update the color just stop
    if (isGameOver) {
        return;
    }
    
    //If one button pressed is red and one button pressed is blue than set the current color being pressed to purple
    if ((self.playBarLeft.currentColorPressed == ActiveColorRed && self.playBarRight.currentColorPressed == ActiveColorBlue) ||
        (self.playBarLeft.currentColorPressed == ActiveColorBlue && self.playBarRight.currentColorPressed == ActiveColorRed)) {
        
        self.currentColorBeingPressed = ActiveColorPurple;
        CCLOG(@"Current Color pressed is Purple");
        
    //If one button pressed is red and one button pressed is yellow than set the current color being pressed to orange
    } else if ((self.playBarLeft.currentColorPressed == ActiveColorRed && self.playBarRight.currentColorPressed == ActiveColorYellow) ||
               (self.playBarLeft.currentColorPressed == ActiveColorYellow && self.playBarRight.currentColorPressed == ActiveColorRed)) {
        
        self.currentColorBeingPressed = ActiveColorOrange;
        CCLOG(@"Current Color pressed is Orange.");
        
    //If one button pressed is blue and one button pressed is yellow than set the current color being pressed to green
    } else if ((self.playBarLeft.currentColorPressed == ActiveColorBlue && self.playBarRight.currentColorPressed == ActiveColorYellow) ||
               (self.playBarLeft.currentColorPressed == ActiveColorYellow && self.playBarRight.currentColorPressed == ActiveColorBlue)) {
        
        self.currentColorBeingPressed = ActiveColorGreen;
        CCLOG(@"Current Color pressed is Green");
        
    //If one of the buttons being pressed is red and none of the above are true than set the current color being pressed to red
    } else if (self.playBarLeft.currentColorPressed == ActiveColorRed || self.playBarRight.currentColorPressed == ActiveColorRed) {
        
        self.currentColorBeingPressed = ActiveColorRed;
        CCLOG(@"Current Color pressed is Red");
        
    //If one of the buttons being pressed is blue and none of the above are true than set the current color being pressed to blue
    } else if (self.playBarLeft.currentColorPressed == ActiveColorBlue || self.playBarRight.currentColorPressed == ActiveColorBlue) {
        
        self.currentColorBeingPressed = ActiveColorBlue;
        CCLOG(@"Current Color pressed is Blue");
        
    //If one of the buttons being pressed is yellow and none of the above are true than set the current color being pressed to yellow
    } else if (self.playBarLeft.currentColorPressed == ActiveColorYellow || self.playBarRight.currentColorPressed == ActiveColorYellow) {
        
        self.currentColorBeingPressed = ActiveColorYellow;
        CCLOG(@"Current Color pressed is Yellow");
        
    //If none of the above are true than no colors are being pressed
    } else {
        
        self.currentColorBeingPressed = ActiveColorNone;
        CCLOG(@"Current Color pressed is White");
        
    }
    
    //Update the box's color to the current color being pressed unless the current color being pressed is already the boxes color
    if (self.hitBox.currentBoxColor != self.currentColorBeingPressed) {
        [Color changeObject:_bottomHitBox withColor:self.currentColorBeingPressed];
        [self.hitBox updateBoxColor:self.currentColorBeingPressed];
    }
    
    
}

- (void) updateGameDifficulty {
    
    //The reason the change difficulty is in the spawn new line method is because when it was in the
    //  update method it would have a buffer time to stop and restart spawn new line faster and then
    //  a gap would appear in when the speed increases,but in spawn new line it gets updated right
    //  after a new line has already spawned so then it keeps a constant flow of spawning
    if (self.currentGameDifficulty == GameEasy && self.score >=7) {
        self.currentGameDifficulty = GameMedium;
    }
    
    else if (self.currentGameDifficulty == GameMedium && self.score >=50) {
        self.currentGameDifficulty = GameHard;
    }
    
    else if (self.currentGameDifficulty == GameHard && self.score >= 100) {
        self.currentGameDifficulty = GameExpert;
    }
    
    else if (self.currentGameDifficulty == GameExpert && self.score >= 150) {
        self.currentGameDifficulty = GameIntense;
    }
    
    else if (self.currentGameDifficulty == GameIntense && self.score >=200) {
        self.currentGameDifficulty = GameHowAreYouStillPlaying;
    }
    
}

-(void) updateLineSpeed {
    
    //Only upadate the velocity if it less than or equal to 320
    if (currentLineSpeed.fallVelocity > -400) {
        //Increase the velocity downwards by 2.5
        currentLineSpeed.fallVelocity = (currentLineSpeed.fallVelocity - 2.5f);
        //Get the SpawnSpeed by dividing the distance of the line length by the velocity
        // and giving the spawn speed a little buffer time of 0.02 second
        currentLineSpeed.spawnSpeed = (fabs(200.0f/currentLineSpeed.fallVelocity) - 0.03f);
    }
    else if (currentLineSpeed.fallVelocity > -500) {
        //Increase the velocity downwards by 2.5
        currentLineSpeed.fallVelocity = (currentLineSpeed.fallVelocity - 0.05f);
        //Get the SpawnSpeed by dividing the distance of the line length by the velocity
        // and giving the spawn speed a little buffer time of 0.02 second
        currentLineSpeed.spawnSpeed = (fabs(200.0f/currentLineSpeed.fallVelocity) - 0.03f);
    }
    
    CCLOG(@"%f", currentLineSpeed.fallVelocity);
}

- (void) updateBackground {
    
    //Run through lines
    for (Line *line in self.lines) {
        //check if a line is passing through the middle of the hitBox
        if (line.position.y  <= CGRectGetMaxY(self.hitBox.boundingBox) - 4 &&
            CGRectGetMaxY(line.boundingBox) > CGRectGetMaxY(self.hitBox.boundingBox)) {
            
            [Color changeObject:_backgroundColor withOffSetColor:line.linesColor];
            [Color changeObject:_hideParticlesColor withOffSetColor:line.linesColor];
//            [Color changeObject:_leftMask withOffSetColor:line.linesColor];
//            [Color changeObject:_rightMask withOffSetColor:line.linesColor];
        
        }
    }
    
}

- (void) updateScoreAchievements {
    
    // if gameCenter was not activated dont run any of the achievements updater so dont activate achievements
    if (![GameCenterFiles isGameCenterActivated]) {
        return;
    }
    
    //Go through the scores and check for the achievement conditions
    //  We set a ranged value because players can get more than one point at a time
    //  So we check within a range to see if the player has gotten the score or a little over
    switch (self.score) {
        case 777 ... 778:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score777" percentComplete:100.0f];
            break;
            
        case 500 ... 501:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score500" percentComplete:100.0f];
            break;
           
        case 300 ... 301:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score300" percentComplete:100.0f];
            break;
            
        case 200 ... 201:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score200" percentComplete:100.0f];
            break;
            
        case 150 ... 151:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score150" percentComplete:100.0f];
            break;
            
        case 100 ... 101:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score100" percentComplete:100.0f];
            break;
            
        case 75 ... 76:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score75" percentComplete:100.0f];
            break;
            
        case 50 ... 51:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score50" percentComplete:100.0f];
            break;
            
        case 25 ... 26:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score25" percentComplete:100.0f];
            break;
            
        case 5 ... 6:
            [[GameCenterFiles getGameCenterManager] reportAchievementIdentifier:@"score5" percentComplete:100.0f];
            break;
    }
}

#pragma mark - Spawning Line

//This method puts in a new line at the top of the screen to be scrolled down
- (void) spawnNewLine {
    
    //initialize a new line
    Line *newLine = (Line*)[CCBReader load:@"Line"];
    
    //Randomly sets the color of the new line
    [newLine setRandomColor:self.currentGameDifficulty];
    
////********************************************************************************************
////Simulate Game For ScreenShots
//
//    [newLine spawnSimulation];
//    
////********************************************************************************************

    
    //add the new line to the array of lines to be scrolled through
    [self.lines addObject:newLine];
    //add the line to the sceen
    [_lineSpawner addChild:newLine];
    //get the size of the current screen
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    //poistion the new line at half of the screen width at the very top of the screen
    newLine.position = ccp(screenSize.width/2, screenSize.height);
    
    //if the next line is the same color as that before it make the front black line
    //  not visible on it and make sure that we already past the first line
    if ([Line isFirstLineDone]) {
        if (newLine.sameColorAsBefore) {
            newLine.frontOfLine.opacity = 0.f;
        }
    }

    //Check to see if the Difficulty needs to go up
    [self updateGameDifficulty];
    
    //update the speed the line moves
    [self updateLineSpeed];
    
    //Spawn a new line
    [self keepSpawningNewLine];
    
}

//Schedules spawnNewLine again
- (void) keepSpawningNewLine {
    
    //if it isnt gameOver keep spawning dem lines
    if (!isGameOver) {
        //unschedule and then reschedule spawnNewLine with a delay
        [self unschedule:@selector(spawnNewLine)];
        [self scheduleOnce:@selector(spawnNewLine) delay:currentLineSpeed.spawnSpeed];
    }
    
}

#pragma mark - Losing

- (void) checkLosingCondition: (Line *) line {
    
    //If the bottom of the line has passed the bottom of the hitbox and the top of the line has not reached the top of the hit box yet
    //  check to see if the right color is being pressed
    if (line.position.y < CGRectGetMinY(self.hitBox.boundingBox) && CGRectGetMaxY(self.hitBox.boundingBox)+5 < CGRectGetMaxY(line.boundingBox))
    {
        if (line.linesColor != self.currentColorBeingPressed) {
            CCLOG(@"Player Lost");
            //call in the gameover scene
            [self loser:line];
        }
        
////********************************************************************************************
////Simulate Game For ScreenShots
//
////        //Update the box's color to the current color being pressed unless the current color being pressed is already the boxes color
//        if (self.hitBox.currentBoxColor != line.linesColor) {
//            [Color changeObject:_bottomHitBox withColor:line.linesColor];
//            [self.hitBox updateBoxColor:line.linesColor];
//        }
////********************************************************************************************
        
    }
    
}

//Switches to the Gameover scene
- (void) loser: (Line *) losingLine {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"YouSuck.mp3"];
    
    //We've reached the end friends
    isGameOver = YES;

    
    //make it so the user can't touch the pause button
    self.pauseButton.userInteractionEnabled = NO;
    
    //Save the GameOver scene
    GameOver *newScene = (GameOver *)[CCBReader load:@"GameOver" owner:self];
    //Set the final score in the gameOver Scene to be the users current score
    newScene.finalScore = self.score;
    newScene.losingLine = losingLine;
    newScene.colorPressed = self.currentColorBeingPressed;
    
    //Make the box flash between grey and active color so player knows where they lost
    [self schedule:@selector(makeBoxFlash) interval:0.2f];
    
    //run block of code after 1.5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //stop making the box flash
        [self unschedule:@selector(makeBoxFlash)];
        //add the new gameover scene
        [self addChild:newScene];
        
    });
    
}

- (void) makeBoxFlash {
    
    if (self.currentColorBeingPressed != ActiveColorNone) {
        //check if the box is grey
        if (isBoxGrey) {
            //if it is make it the current color
            [Color changeObject:_bottomHitBox withColor:self.currentColorBeingPressed];
            [self.hitBox updateBoxColor:self.currentColorBeingPressed];
        } else {
            //if not change the color to grey
            [Color changeObject:_bottomHitBox withColor:ActiveColorGrey];
            [self.hitBox updateBoxColor:ActiveColorGrey];
            
        }
    } else {
        
        //check if the box is grey
        if (isBoxGrey) {
            //if it is make it the current color
            [Color changeObject:_bottomHitBox withColor:self.currentColorBeingPressed];
            [self.hitBox updateBoxColor:self.currentColorBeingPressed];
        } else {
            //if not change the color to grey
            [Color changeObject:_bottomHitBox withOffSetColor:ActiveColorGrey];
            [self.hitBox updateWhiteBoxAtEnd];
            
        }
        
    }
    
    
    //invert after the color is chnaged
    isBoxGrey = !isBoxGrey;
    
}


#pragma mark - Pausing

- (void) pause {
    
    //if it is gameOver dont display the pause menu
    if (isGameOver) {
        return;
    }
    
    CCLOG(@"Paused Pressed");
    
    //pause the whole game
    self.paused = TRUE;
    
    if (self.paused) {
        
        [self unschedule:@selector(countDown)];
    }
    
    //Reset the colors being pressed because they never get cancelled when paused is pressed
    self.playBarLeft.currentColorPressed = ActiveColorNone;
    self.playBarRight.currentColorPressed = ActiveColorNone;
    self.currentColorBeingPressed = ActiveColorNone;
    
    //update the hit box to be the new color being pressed (aka white)
    [Color changeObject:_bottomHitBox withColor:self.currentColorBeingPressed];
    [self.hitBox updateBoxColor:self.currentColorBeingPressed];
    
    [self loadPauseScreen];
    
    [[OALSimpleAudio sharedInstance] stopBg];
}

- (void) loadPauseScreen {
    
    //Save the Gameplay scene
    self.pauseMenu = [CCBReader loadAsScene:@"PauseMenu" owner:self];
    //Display pause box on top of the current scene
    [self addChild: self.pauseMenu];
    
}

- (void) backToMenu {
    
    CCScene *newScene = [CCBReader loadAsScene:@"MainScene"];
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];

    
}

- (void) resume {
    
    [self removeSceneBeforeCountDownStarts];
    
    //set our countdown number to 3
    self.countDownNumber = 3;
    
    //Start the countdown number
    _countDownLabel.string = [NSString stringWithFormat:@"%i", self.countDownNumber];
    
    //Start counting down with a delay to give a fluid start
    [self schedule:@selector(countDown) interval:0.75f];
    
}

- (void) countDown {
    
    //if we still have numbers to count down to update the countdown label
    if (self.countDownNumber > 1) {
        //Decrease the count down number
        self.countDownNumber--;
        //Update count down label to show new number
        _countDownLabel.string = [NSString stringWithFormat:@"%i", self.countDownNumber];
    } else {
        //Set the countdown label to be noting
        _countDownLabel.string = @"";
        //resume the game
        [self unschedule:@selector(countDown)];
        self.pauseButton.userInteractionEnabled = YES;
        self.paused = FALSE;
        //[[OALSimpleAudio sharedInstance] playBg:@"ProjectGame1.mp3" volume:1.f pan:0.f loop:YES];
    }
    
    
}

- (void) removeSceneBeforeCountDownStarts {
    //rmemove the pause screen to resume to the game
    [self.pauseMenu removeFromParent];
}

////Test the beats of the line
//-(void) displayTestTimeBlock {
//    //Create CCNodeColor to represent the visual for the beats the line is going at
//    CCNodeColor* nodeBlock = (CCNodeColor*) [CCBReader load:@"TestTime"];
//    //Check to see if the block is on the left sided position
//    if (leftTestPosition) {
//        //if so diplay the blick on the right
//        nodeBlock.position = ccp(30.0f, 80.0f);
//    } else {
//        //if not display it on the left
//        nodeBlock.position = ccp(100.0f, 80.0f);
//    }
//    
//    //reverse the value of the left position so we have the new current position of the block
//    leftTestPosition = !leftTestPosition;
//    
//    //Addd the new created Node to the scene
//    [self addChild:nodeBlock];
//    
//    //Make sure old test block exists
//    if (oldTestBlock)
//        //remive the old block from the screen
//        [oldTestBlock removeFromParent];
//    
//    //set teh new node block just created to the old test block
//    oldTestBlock = nodeBlock;
//    
//}
//
////Test the beat that the music is going at with a visual
//- (void)displayBlock {
//    //Create a new CCNodeColor for the visual
//    CCNodeColor* nodeBlock = (CCNodeColor*) [CCBReader load:@"TestTime"];
//    //Check to see wether there is a block already on the right position
//    if (rightPosition) {
//        //if so set this new block on the left
//        nodeBlock.position = ccp(100.0f, 20.0f);
//    } else {
//        //if not set this new block on the right
//        nodeBlock.position = ccp(30.0f, 20.0f);
//    }
//    
//    //Reverse the value of right position so we have wich side the new block is at
//    rightPosition = !rightPosition;
//    
//    //add the newly created node to the scene
//    [self addChild:nodeBlock];
//    
//    //check to see wether an old block exists
//    if (oldBlock) {
//        //remove the old block from the scene
//        [oldBlock removeFromParent];
//    }
//    
//    //Set the newly placed block as the now old block
//    oldBlock = nodeBlock;
//}

@end
