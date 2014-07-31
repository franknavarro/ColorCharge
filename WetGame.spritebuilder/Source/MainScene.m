//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

GameCenterFiles *gameCenterManger;

@implementation MainScene

- (void) didLoadFromCCB {
    
    //check first to make sure the current iOS supports GameCenter
    if ([GameCenterFiles isGameCenterAvailable]) {
        
        //get the manager and authenticate the player
        [[GameCenterFiles getGameCenterManager] authenticateLocalPlayer];
    }
    
}

- (void) onEnter {
    
    [super onEnter];
    
    [[OALSimpleAudio sharedInstance] preloadEffect:@"whoosh.wav"];
    //[[OALSimpleAudio sharedInstance] preloadBg:@"ProjectGame1.mp3"];
    
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
    
    
    
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
}

- (void) tutorial {
    
    CCScene *newScene = [CCBReader loadAsScene:@"GameplayTutorial"];
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
    
}

@end
