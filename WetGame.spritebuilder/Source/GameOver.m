//
//  GameOver.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Gameplay.h" //imported to access the score
#import "NSUserDefaults+Encryption.h"

@implementation GameOver {
    
    CCLabelTTF *_finalScoreLabel;
    CCLabelTTF *_finalScoreNumber;
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_highScoreNumber;
    CCLabelTTF *_gameOverLabel;
    
    CCButton *_restartButton;
    CCButton *_menuButton;
    
    //All the lines that shoot up in the end
    CCNodeColor *_finishLine1;
    CCNodeColor *_finishLine2;
    CCNodeColor *_finishLine3;
    CCNodeColor *_finishLine4;
    CCNodeColor *_finishLine5;
    NSMutableArray *_finishLines;
    
}

-(void) didLoadFromCCB {
    
    //initialize the array of finish lines with the finish lines
    _finishLines = [NSMutableArray arrayWithObjects:_finishLine1, _finishLine2, _finishLine3, _finishLine4, _finishLine5,  nil];
    
}

-(void) onEnter {
//    
//    _restartButton.visible = NO;
//    _menuButton.visible = NO;
    
    _highScoreNumber.opacity = 0.f;
    _highScoreLabel.opacity = 0.f;
    _finalScoreNumber.opacity = 0.f;
    _finalScoreLabel.opacity = 0.f;
    _gameOverLabel.opacity = 0.f;
    
    [super onEnter];

    //Get the encrypted high score
    NSNumber *getHighScore = [[NSUserDefaults standardUserDefaults] objectEncryptedForKey:@"HighScore"];
    
    //stores the integer for the highscore
    int highScore;
    
    //if the highscore is not nil
    if (getHighScore) {
        //store the current highscore in the local variable of highscore
        highScore = [getHighScore intValue];
    } else {
        //if it is nil set highscore to 0
        highScore = 0;
    }
    
    //if the current final score is greater than the current high score than display the final score in highscore instead and
    //save the highscore encrypted status
    if (self.finalScore > highScore) {
        //Encrypt the highscore in NSUserDefaults to save it
        [[NSUserDefaults standardUserDefaults] setObjectEncrypted:@(self.finalScore) forKey:@"HighScore"];
        //Display finalScore as highScore
        _highScoreNumber.string = [NSString stringWithFormat:@"%i", self.finalScore];
    } else {
        //Display current highScore
        _highScoreNumber.string = [NSString stringWithFormat:@"%i", highScore];
    }
    
    //Display the current final score
    _finalScoreNumber.string = [NSString stringWithFormat:@"%i", self.finalScore];
    
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:0.5f];
    
    [_gameOverLabel runAction:fadeIn];
    
    //change the color to the line that you lost on
    [self changeColorForFinishLines: self.loosingLine];
    [self scheduleOnce:@selector(runFinishLines) delay:0.35f];
    [self scheduleOnce:@selector(showLabels) delay:1.5f];
    
    
}

- (void) changeColorForFinishLines: (Line *) loosingLine {
    
    for (CCNodeColor *currentFinishLine in _finishLines) {
        currentFinishLine.cascadeColorEnabled = YES;
        [Color changeObject:currentFinishLine withColor:loosingLine.linesColor];
    }
    
}

- (void) runFinishLines {
    
    //Check to make sure there are still lines in the array to move
    if (_finishLines && _finishLines.count) {
        
        //Get a random number index of the array
        int indexCount = (int)[_finishLines count];
        int randomNumberForIndex;
        
        //If there is only 1 object then dont pick a random line but rather the first line in the array
        if (indexCount == 1) {
            randomNumberForIndex = 0;
        } else {
            //pick a random index value in the array
            randomNumberForIndex = arc4random() % indexCount;
        }
        
        //set the current moving line with the randomly picked line
        CCNode *currentFinishLine = [_finishLines objectAtIndex:randomNumberForIndex];
        
        //set up where the line moves to
        CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:1.f position:ccp(currentFinishLine.position.x, 1.0f)];
        //add an elastic effect to the move
        CCActionEase *moveToWithEase = [CCActionEaseIn actionWithAction:moveTo rate:10.f];
        
        //make the line move with that action
        [currentFinishLine runAction:moveToWithEase];
        
        //remove the line from the array so that we know which lines are left to move
        [_finishLines removeObject:currentFinishLine];
        
        //re run this to move another line
        [self unschedule:@selector(runFinishLines)];
        [self scheduleOnce:@selector(runFinishLines) delay:0.1f];
    }
    
    else {
        //if there are no more lines in the array then just stop this method
        [self unschedule:@selector(runFinishLines)];
    }
    
}


- (void) showLabels {
    
    CCActionFadeIn *fadeIn1 = [CCActionFadeIn actionWithDuration:0.5f];
    CCActionFadeIn *fadeIn2 = [CCActionFadeIn actionWithDuration:0.5f];
    CCActionFadeIn *fadeIn3 = [CCActionFadeIn actionWithDuration:0.5f];
    CCActionFadeIn *fadeIn4 = [CCActionFadeIn actionWithDuration:0.5f];
    
    [_finalScoreLabel runAction:fadeIn1];
    [_finalScoreNumber runAction:fadeIn2];
    [_highScoreLabel runAction:fadeIn3];
    [_highScoreNumber runAction:fadeIn4];
    
    
}

- (void) restart {
    
    //Save the Gameplay scene
    CCScene *newScene = [CCBReader loadAsScene:@"Gameplay"];
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
    
}

- (void) backToMenu {
    
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    [[CCDirector sharedDirector] presentScene:mainMenu withTransition:transition];
    
}

@end
