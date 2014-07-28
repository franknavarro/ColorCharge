//
//  Line.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCNodeColor.h"
#import "Color.h"

@interface Line : CCNodeColor

//To tell other classes what this lines current color is
@property (nonatomic, assign) ActiveColor linesColor;
//To know if this line has the same color as the line before it
@property (assign) BOOL sameColorAsBefore;
//To know if this lines score has already been counted
@property (assign) BOOL scoreCounted;

//Used for testing time
@property (assign) BOOL passedMidBox;

@property (nonatomic, strong) CCNodeColor *frontOfLine;

//Used to set the color of the line to a random color
- (void) setRandomColor: (GameDifficulty) currentGameDifficulty;

+ (void) resetFirstLineDone;
+ (BOOL) isFirstLineDone;

@end
