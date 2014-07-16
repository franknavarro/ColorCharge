//
//  Gameplay.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Line.h"
#import "Playbar.h"
#import "Color.h"

//Defines how fast the lines will fall down the screen and how quickly they will appear at the top of the screen
struct LineSpeed {
    
    double fallVelocity; //fall speed
    double spawnSpeed; //spawn speed at the top of the screen
    
};

//Stores in the current Game Difficulty
static GameDifficulty currentGameDifficulty;
//keeps the score of the player
static int score;


@implementation Gameplay {
    
    NSMutableArray *_lines; //keeps track of all the lines running through the screen
    CCNode *_background; //used to add the line directly to the background so that the box is behind the
                         //    line
    
    //Both touch bars for checking the color the user is touching
    PlayBar *_playBarLeft;
    PlayBar  *_playBarRight;
    
    CCSprite *_hitBox; //Used for target area of hitting colors
    
    ActiveColor currentColorBeingPressed; //used to keep track of the current color being pressed
    
    CCLabelTTF *_scoreLabel; //shows the current score on the screen
    
    int _addToScore; //used for when encountering a longer line the amount of points added for the length of the line
    
    //Game speeds are a fall velocity with a respawn time of whatever second
    struct LineSpeed currentLineSpeed;
    
    //Used to test time signature and wether the timing of the lines crossing the hit box was on beat
    CCNode* oldBlock; //block that help keeps time with music
    CCNode* oldTestBlock; //block the helps keep time with line
    BOOL rightPosition; //Used to tell position in relation to oldBlock
    BOOL leftTestPosition; //Used to tell position in relation to oldTestBlock
    
}

//When the Gameplay is initialized initialize the _lines array
- (id)init
{
    //Conventional crap
    self = [super init];
    if (self) {
        //Initialize the _lines array
        //NOTE TO SELF: [NSMutableArray array] is the same as [[alloc]init] for an array
        _lines = [NSMutableArray array];
        
        //PreLoad Audio for Snare Testing
        //[[OALSimpleAudio sharedInstance] preloadEffect:@"1Snare.m4a"];
        
        
        
    }
    return self;
}

//As soon as the file is loaded
-(void) didLoadFromCCB {
    
    //Set the currentLine speed to slow settings
    currentLineSpeed.fallVelocity = -150.f;
    currentLineSpeed. spawnSpeed = 1.31f;
    
    [self schedule: @selector(updatePressedColor) interval:0.1f];
    
}

- (void) onEnter {
    
    [super onEnter];
    
    //Reset the score and game difficulty every time the gameplay scene loads in
    score = 0;
    currentGameDifficulty = GameEasy;
}

- (void)onEnterTransitionDidFinish {
    
    [super onEnterTransitionDidFinish];
    
    //Enable touches to be able to be read in
    self.userInteractionEnabled = YES;
    
    //Start playing the already preloaded Background music audio
    //[[OALSimpleAudio sharedInstance]playBg:@"GameSong.m4a"];
    
    //Start by spawning a line so that we don't have to wait for the interval that comes next
    [self spawnNewLine];
    //Spawn a new line with the delay of the spawn time
    [self scheduleOnce:@selector(spawnNewLine) delay:currentLineSpeed.spawnSpeed];
//    //This was used for test to see if block would stay in time
//    [self schedule:@selector(displayBlock) interval:1.f];
    
}

//calls every frame
- (void) update:(CCTime)delta {
    
    //Goes through every line in the array of lines to scroll them down the screen
    for (Line *line in _lines) {
        line.position = ccp(line.position.x, line.position.y + currentLineSpeed.fallVelocity * delta);
    }
    
    //An array to keep track of which lines we now have to remove from the game
    NSMutableArray *removeFromLines = [NSMutableArray array];
    
    //Goes through the lines in the array and adds them to another array to be deleted
    for (Line *line in _lines) {
        //If the line is completely outside the screen add it to the array of lines to be taken out
        if (line.position.y < -(line.boundingBox.size.height)) {
            [removeFromLines addObject:line];
        }
    }
    
    //delete the line from _lines array by going through the array of lines we want to get rid of
    for (Line *removeLine in removeFromLines) {
        //Remove the line
        [_lines removeObject:removeLine];
        //Delete it from the scene
        [removeLine removeFromParent];
    }
    
    //Keep count of how many objects are in lines
    int n = (int)[_lines count];
    //Iterate through every object in the array _lines in order to add up score
    for (int i=0; i<n; i++) {
        //Saves the current line into a variable of the object Line
        Line *line = _lines[i];
        //If the top of the line is less than or equal to the middle of the hit box then go onto next check
        if (CGRectGetMaxY([line boundingBox]) <= _hitBox.position.y) {
            //Make sure the score for this line has not yet been counted
            if (!line.scoreCounted) {
                //Check to see if another after exists
                if (_lines[i+1]) {
                    //Save the line after the current one being checked into a variable
                    Line *lineAfter = _lines[i+1];
                    //Make sure that the cuurent lines color and the color of the line after arent the same
                    if (line.linesColor != lineAfter.linesColor) {
                        //If so update the score and let the game know that the score has been counted for this line
                        line.scoreCounted = YES;
                        //Increment the score by one for the line that  was scored
                        score++;
                        //Add the amount extra for longer lines
                        score+=_addToScore;
                        //Reset the value for adding to score for longer lines
                        _addToScore = 0;
                        //Update the score value
                        _scoreLabel.string = [NSString stringWithFormat:@"%i", score];
                    } else {
                        //If so update the score and let the game know that the score has been counted for this line
                        line.scoreCounted = YES;
                        _addToScore++;
                    }
                }
            }
        }
        
        //        //Use visuals and audio to check the beat at which a line hits the middle of the _hitBox
        //        //Check to see if the line is at or a little bellow the middle of _hitBox
        //        if (line.position.y <= _hitBox.position.y && !line.passedMidBox) {
        //            //Check to see if another after exists
        //            if (_lines[i+1]) {
        //                //Save the line after the current one being checked into a variable
        //                Line *lineAfter = _lines[i+1];
        //                //Make sure that the cuurent lines color and the color of the line after arent the same
        //                if (line.linesColor != lineAfter.linesColor) {
        //                    //Set the line has already passed the middle of the _hitBox
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
    
    //Run through the lines to check if the line's color is being pressed
    for (Line *line in _lines) {
    
        //If the bottom of the line has passed the bottom of the hitbox and the top of the line has not reached the top of the hit box yet
        //  check to see if the right color is being pressed
        if (line.position.y <= CGRectGetMinY([_hitBox boundingBox]) && CGRectGetMaxY([_hitBox boundingBox]) < CGRectGetMaxY([line boundingBox]))
        {
            if (line.linesColor != currentColorBeingPressed) {
                [self looser];
            }
        }
    
            //Keep track of how many exisiting lines there are
            //CCLOG(@"%d", _lines.count);
    }
}


-(void) updatePressedColor {
    
    //If one button pressed is red and one button pressed is blue than set the current color being pressed to purple
    if ((_playBarLeft.currentColorPressed == ActiveColorRed && _playBarRight.currentColorPressed == ActiveColorBlue) ||
        (_playBarLeft.currentColorPressed == ActiveColorBlue && _playBarRight.currentColorPressed == ActiveColorRed)) {
        
        currentColorBeingPressed = ActiveColorPurple;
        CCLOG(@"Current Color pressed is Purple");
        
    //If one button pressed is red and one button pressed is yellow than set the current color being pressed to orange
    } else if ((_playBarLeft.currentColorPressed == ActiveColorRed && _playBarRight.currentColorPressed == ActiveColorYellow) ||
               (_playBarLeft.currentColorPressed == ActiveColorYellow && _playBarRight.currentColorPressed == ActiveColorRed)) {
        
        currentColorBeingPressed = ActiveColorOrange;
        CCLOG(@"Current Color pressed is Orange.");
        
    //If one button pressed is blue and one button pressed is yellow than set the current color being pressed to green
    } else if ((_playBarLeft.currentColorPressed == ActiveColorBlue && _playBarRight.currentColorPressed == ActiveColorYellow) ||
               (_playBarLeft.currentColorPressed == ActiveColorYellow && _playBarRight.currentColorPressed == ActiveColorBlue)) {
        
        currentColorBeingPressed = ActiveColorGreen;
        CCLOG(@"Current Color pressed is Green");
        
    //If one of the buttons being pressed is red and none of the above are true than set the current color being pressed to red
    } else if (_playBarLeft.currentColorPressed == ActiveColorRed || _playBarRight.currentColorPressed == ActiveColorRed) {
        
        currentColorBeingPressed = ActiveColorRed;
        CCLOG(@"Current Color pressed is Red");
        
    //If one of the buttons being pressed is blue and none of the above are true than set the current color being pressed to blue
    } else if (_playBarLeft.currentColorPressed == ActiveColorBlue || _playBarRight.currentColorPressed == ActiveColorBlue) {
        
        currentColorBeingPressed = ActiveColorBlue;
        CCLOG(@"Current Color pressed is Blue");
        
    //If one of the buttons being pressed is yellow and none of the above are true than set the current color being pressed to yellow
    } else if (_playBarLeft.currentColorPressed == ActiveColorYellow || _playBarRight.currentColorPressed == ActiveColorYellow) {
        
        currentColorBeingPressed = ActiveColorYellow;
        CCLOG(@"Current Color pressed is Yellow");
        
    //If none of the above are true than no colors are being pressed
    } else {
        
        currentColorBeingPressed = ActiveColorNone;
        CCLOG(@"Current Color pressed is White");
        
    }
    
}

//This method puts in a new line at the top of the screen to be scrolled down
- (void) spawnNewLine {
    
    //initialize a new line
    Line *newLine = (Line*)[CCBReader load:@"Line"];
    
    //Randomly sets the color of the new line
    [newLine setRandomColor];
    
    //add the new line to the array of lines to be scrolled through
    [_lines addObject:newLine];
    //add the line to the sceen
    [_background addChild:newLine];
    //get the size of the current screen
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    //poistion the new line at half of the screen width at the very top of the screen
    newLine.position = ccp(screenSize.width/2, screenSize.height);
    
    //The reason the change difficulty is in the spawn new line method is because when it was in the
    //  update method it would have a buffer time to stop and restart spawn new line faster and then
    //  a gap would appear in when the speed increases,but in spawn new line it gets updated right
    //  after a new line has already spawned so then it keeps a constant flow of spawning
    if (currentGameDifficulty == GameEasy && score >=7) {
        currentGameDifficulty = GameMedium;
    }
    
    else if (currentGameDifficulty == GameMedium && score >=20) {
        currentGameDifficulty = GameHard;
    }
    
    else if (currentGameDifficulty == GameHard && score >= 50) {
        currentGameDifficulty = GameExpert;
    }
    
    else if (currentGameDifficulty == GameExpert && score >= 75) {
        currentGameDifficulty = GameIntense;
    }
    
    else if (currentGameDifficulty == GameIntense && score >=100) {
        currentGameDifficulty = GameHowAreYouStillPlaying;
    }

    [self updateLineSpeed];
    //[self schedule:@selector(spawnNewLine) interval:currentLineSpeed.spawnSpeed];
    [self scheduleOnce:@selector(spawnNewLine) delay:currentLineSpeed.spawnSpeed];
    
}

-(void) updateLineSpeed {
    //Increase the velocity downwards by 2.5
    currentLineSpeed.fallVelocity = (currentLineSpeed.fallVelocity - 2.5f);
    //Get the SpawnSpeed by dividing the distance of the line length by the velocity
    // and giving the spawn speed a little buffer time of 0.02 second
    currentLineSpeed.spawnSpeed = (fabs(200.0f/currentLineSpeed.fallVelocity)) - 0.0255f;
    
}


//Switches to the Gameover scene
- (void) looser {
    
    //Stop music
    [[OALSimpleAudio sharedInstance] stopBg];
    //Save the Gameplay scene
    CCScene *newScene = [CCBReader loadAsScene:@"GameOver"];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene];
    
    
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

+(GameDifficulty) getGameDifficulty {
    return currentGameDifficulty;
}

+(int) getScore {
    return score;
}

@end
