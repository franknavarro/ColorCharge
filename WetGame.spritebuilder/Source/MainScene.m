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

@implementation MainScene {
    
    CCButton *_soundsButton;
    CCButton *_optionsButton;
    CCButton *_backButton;
    
    ADBannerView *_bannerView;
    
}

#pragma mark - iAd implementation

- (instancetype)init
{
    self = [super init];
    if (self) {        
        
        //In iOS 6.0 add banner is initialized in a new effecient way so inititialize it here
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        }
        else {
            _bannerView = [[ADBannerView alloc] init];
        }
        
        //Set which size ads can play in this ad banner
        _bannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        //Set the size of the banner itself
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        //add the banner as a subview of the scene
        [[[CCDirector sharedDirector] view] addSubview:_bannerView];
        //Set the view to be transparent background so we can still interact with the game
        [_bannerView setBackgroundColor:[UIColor clearColor]];
        [[[CCDirector sharedDirector] view] addSubview:_bannerView];
        //Set so we can access the methods called for opening and closing ads here
        _bannerView.delegate = self;
        
    }
    
    //Add the ad view to the very front
    [[[CCDirector sharedDirector] view] bringSubviewToFront:_bannerView];
    
    [self layoutAnimated:YES];
    return self;
}

- (void) layoutAnimated:(BOOL)animated {
    
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGSize contentFrame = [[CCDirector sharedDirector] viewSize];
    
    if (contentFrame.width < contentFrame.height) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    }
    else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    //Get the frame for the banner
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        bannerFrame.origin.y = 0;
    } else {
        bannerFrame.origin.y -= bannerFrame.size.height;
    }
    
    [UIView animateWithDuration: animated ? 0.25 : 0.0 animations:^{
        
        _bannerView.frame = bannerFrame;
        
    }];
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutAnimated:YES];
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
