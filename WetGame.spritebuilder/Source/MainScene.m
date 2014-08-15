//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import <GameKit/GameKit.h>
#import "GameCenterFiles.h"
#import "Color.h"
#import "iAdSingleton.h"

@implementation MainScene {
    
    CCButton *_soundsButton;
    CCButton *_optionsButton;
    CCButton *_backButton;
    
}

#pragma mark - iAd implementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //add the banner to the screen
        //[[iAdSingleton sharedInstanceOfiAd] addBannerToScreen];
        
    }
    return self;
}

- (void) onExit {

    [super onExit];
    
    //remove the banner from the screen
    //[[iAdSingleton sharedInstanceOfiAd] removeBannerFromScreen];

}

#pragma mark - Set Up
- (void) didLoadFromCCB {
    
    NSNumber *soundsOff = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundsOff"];
    
    //If soundsOff is YES then leave the selected state for soundsOFF to YES
    if ([soundsOff boolValue]) {
        _soundsButton.selected = YES;
    }

    
}

-(void) onEnter {
    
    [super onEnter];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"whoosh.wav"];
    
    
}

#pragma mark - Main Menu buttons

-(void) startPlay {
    
    CCAnimationManager *animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"StartPlay"];
    
    NSNumber *tutorialHasRan = [[NSUserDefaults standardUserDefaults] objectForKey:@"TutroialHasRan"];
    CCScene *newScene;
    
    if (tutorialHasRan && [tutorialHasRan boolValue]) {
        newScene = [CCBReader loadAsScene:@"Gameplay"];
    }
    else {
        //Save the Gameplay scene
        newScene = [CCBReader loadAsScene:@"GameplayTutorial"];
        [MGWU logEvent:@"First_Time_Tutorial" withParams:nil];
    }
    
    //Play a random marimba sound
    [Color playSound];
    
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
}

- (void) showAchievements
{
    
    [MGWU logEvent:@"Checked_Achievements" withParams:nil];
    
    //Play a random marimba sound
    [Color playSound];
    
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
        [[CCDirector sharedDirector] presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}

- (void) options {
    
    _optionsButton.userInteractionEnabled = NO;
    _backButton.userInteractionEnabled = YES;

//    //Play a random marimba sound
//    [Color playSound];

    [[OALSimpleAudio sharedInstance] playEffect:@"whoosh.wav"];
    
//    CCScene *newScene = [CCBReader loadAsScene:@"OptionsMenu"];
//    //Begin the tranistion made to go to Gameplay
//    [[CCDirector sharedDirector] presentScene:newScene];
    
    CCAnimationManager *animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"OpenOptions"];
    
}


#pragma mark - Options Menu

- (void) back {
    
    _optionsButton.userInteractionEnabled = YES;
    _backButton.userInteractionEnabled = NO;

    
//    //Play a random marimba sound
//    [Color playSound];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"whoosh.wav"];

    
//    CCScene *newScene = [CCBReader loadAsScene:@"MainScene"];
//    //Begin the tranistion made to go to Gameplay
//    [[CCDirector sharedDirector] presentScene:newScene];

    CCAnimationManager *animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"BackToMain"];

}

- (void) tutorial {
    
    //Play a random marimba sound
    [Color playSound];
    
    CCAnimationManager *animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"StartTutorial"];

    
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
