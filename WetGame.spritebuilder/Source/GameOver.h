//
//  GameOver.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Line.h"
#import "Color.h"

@interface GameOver : CCNode

@property (nonatomic, assign) int finalScore;
@property (nonatomic, strong) Line *loosingLine;
@property (nonatomic, assign) ActiveColor colorPressed;

@end
