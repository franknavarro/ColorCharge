//
//  OptionsMenu.m
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "OptionsMenu.h"
#import "Color.h"

@implementation OptionsMenu {
    
    CCButton *_soundsButton;
    
}

- (void) didLoadFromCCB {
    
    NSNumber *soundsOff = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundsOff"];
    
    //If soundsOff is YES then leave the selected state for soundsOFF to YES
    if ([soundsOff boolValue]) {
        _soundsButton.selected = YES;
    }
    
}

- (void) back {
    
    //Play a random marimba sound
    [Color playSound];
    
    CCScene *newScene = [CCBReader loadAsScene:@"MainScene"];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene];
    
}

- (void) tutorial {
    
    //Play a random marimba sound
    [Color playSound];
    
    CCScene *newScene = [CCBReader loadAsScene:@"GameplayTutorial"];
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
    
}

- (void) sounds {
    
    //Play a random marimba sound
    [Color playSound];
    
    //Read in the default on whether the sound is on or off
    NSNumber *soundsOff = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundsOff"];
    
    //Make is sound off the oposite of the bool storded in soundsOff
    //  because we are changing its value when we press this button
    BOOL isSoundOff = ![soundsOff boolValue];
    
    //Turn muted wo whatever our new state for isSoundOff
    [[OALSimpleAudio sharedInstance] setMuted:isSoundOff];
    //Save whether the sound is on or off
    [[NSUserDefaults standardUserDefaults] setObject:@(isSoundOff) forKey:@"SoundsOff"];
}

@end
