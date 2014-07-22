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
    CCLabelTTF *_highScoreLabel;
    
}

-(void) onEnter {
    
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
        _highScoreLabel.string = [NSString stringWithFormat:@"%i", self.finalScore];
    } else {
        //Display current highScore
        _highScoreLabel.string = [NSString stringWithFormat:@"%i", highScore];
    }
    
    //Display the current final score
    _finalScoreLabel.string = [NSString stringWithFormat:@"%i", self.finalScore];
    
    
}

- (void) restart {
    
    //Save the Gameplay scene
    CCScene *newScene = [CCBReader loadAsScene:@"Gameplay"];
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
    
}

@end
