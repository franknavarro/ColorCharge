//
//  GameplayTutorial.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameplayTutorial.h"

@implementation GameplayTutorial

- (void) resetScoreDifficulty {
    
    //Reset the score and game difficulty specifically for the tutorial
    self.score = 0;
    self.currentGameDifficulty = GameTutorialPrimaryColors;
    
}

- (void) looser {
    
    //Prompt player to hit the right color
    
}

@end
