//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void) didLoadFromCCB {
    
//    [[OALSimpleAudio sharedInstance] preloadBg:@"GameSong.m4a"];
//    [[OALSimpleAudio sharedInstance] preloadEffect:@"1Snare.m4a"];
//    [[OALSimpleAudio sharedInstance] preloadEffect:@"2Kick.m4a"];
//    [[OALSimpleAudio sharedInstance] preloadEffect:@"3HiHat.m4a"];
    
    
    self.userInteractionEnabled = YES;
    
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
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

@end
