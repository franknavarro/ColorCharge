//
//  Gameplay_Gameplay_Protected.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Playbar.h"

@interface Gameplay ()

@property (nonatomic, strong) PlayBar *playBarLeft;
@property (nonatomic, strong) PlayBar *playBarRight;

@property (nonatomic, assign) int score;
@property (nonatomic, assign) GameDifficulty currentGameDifficulty;

@end
