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
    CCLabelTTF *_messageLabel;
    
}

-(void) didLoadFromCCB {
    
    int finalScore = [Gameplay getScore];
    
    _finalScoreLabel.string = [NSString stringWithFormat:@"%i", finalScore];
    
    if (finalScore <= 7) {
        _messageLabel.string = [NSString stringWithFormat:@"Try Harder\nNext Time"];
    } else if (finalScore <= 20) {
        _messageLabel.string = [NSString stringWithFormat:@"Not Bad, But\nYou Can Do Better"];
    } else if (finalScore <= 50) {
         _messageLabel.string = [NSString stringWithFormat:@"Wow, Good Job!"];
    } else if (finalScore <= 100) {
        _messageLabel.string = [NSString stringWithFormat:@"Your score is unreal!"];
    } else {
        _messageLabel.string = [NSString stringWithFormat:@"You're cheating aren't\nyou?"];
    }
    
    
    
}

- (void) restart {
    
    //Save the Gameplay scene
    CCScene *newScene = [CCBReader loadAsScene:@"Gameplay"];
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
    
}

@end
