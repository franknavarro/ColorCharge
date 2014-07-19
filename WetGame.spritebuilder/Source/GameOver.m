//
//  GameOver.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Gameplay.h" //imported to access the score

@implementation GameOver {
    
    CCLabelTTF *_finalScoreLabel;
    
}

-(void) onEnter {
    
    [super onEnter];
    
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
