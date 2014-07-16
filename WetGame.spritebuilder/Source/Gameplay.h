//
//  Gameplay.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef NS_ENUM(NSInteger, GameDifficulty) {
    GameEasy,
    GameMedium,
    GameHard,
    GameExpert,
    GameIntense,
    GameHowAreYouStillPlaying
};

@interface Gameplay : CCNode

+(GameDifficulty) getGameDifficulty;
+(int) getScore;

@end
