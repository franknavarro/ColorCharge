//
//  GameCenterFiles.h
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCenterFiles : NSObject

- (void) authenticateLocalPlayer;

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category;

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;

+ (BOOL) isGameCenterAvailable;
+ (BOOL) isGameCenterActivated;
+ (GameCenterFiles *) getGameCenterManager;
+ (NSMutableDictionary *) sharedAchievements;

@end
