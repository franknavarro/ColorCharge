//
//  Gameplay_Gameplay_Protected.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Playbar.h"
#import "Line.h"
#import "HitBox.h"

@interface Gameplay ()

@property (nonatomic, strong) PlayBar *playBarLeft;
@property (nonatomic, strong) PlayBar *playBarRight;

//used to keep track of the current color being pressed
@property (nonatomic, assign) ActiveColor currentColorBeingPressed;

//Used for target area of hitting colors
@property (nonatomic, strong) HitBox *hitBox;

//keeps track of all the lines running through the screen
@property (nonatomic, strong) NSMutableArray *lines; 

//shows the current score on the screen
@property (nonatomic, strong) CCLabelTTF *scoreLabel;

@property (nonatomic, strong) CCScene *pauseMenu;

//How much we count down from on countdowns
@property (nonatomic, assign) int countDownNumber;

//pause button to add or remove from scene
@property (nonatomic, strong) CCButton *pauseButton;

@property (nonatomic, assign) int score;
@property (nonatomic, assign) GameDifficulty currentGameDifficulty;

- (void) resume;
- (void) countDown;
- (void) spawnNewLine;
- (void) keepSpawningNewLine;
- (void) removeSceneBeforeCountDownStarts;

@end
