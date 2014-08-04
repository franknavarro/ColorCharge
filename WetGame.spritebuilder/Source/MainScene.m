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

@implementation MainScene

- (void) didLoadFromCCB {
    
    [[OALSimpleAudio sharedInstance] preloadEffect:@"whoosh.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaCLow.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaELow.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaGLow.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaC.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaE.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaG.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaCHigh.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"YouSuck.mp3"];

}

-(void) startPlay {
    
    NSNumber *tutorialHasRan = [[NSUserDefaults standardUserDefaults] objectForKey:@"TutroialHasRan"];
    CCScene *newScene;
    
    if (tutorialHasRan && [tutorialHasRan boolValue]) {
        newScene = [CCBReader loadAsScene:@"Gameplay"];
    }
    else {
        //Save the Gameplay scene
        newScene = [CCBReader loadAsScene:@"GameplayTutorial"];
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
    
    //Play a random marimba sound
    [Color playSound];
    
    CCScene *newScene = [CCBReader loadAsScene:@"OptionsMenu"];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene];
    
}

@end
