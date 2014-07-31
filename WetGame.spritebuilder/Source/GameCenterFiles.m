//
//  GameCenterFiles.m
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameCenterFiles.h"
#import <GameKit/GameKit.h>

static GameCenterFiles *gameCenterManager = nil;

@implementation GameCenterFiles

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            // Player was successfully authenticated.
            // Perform additional tasks for the authenticated player.
            CCLOG(@"Game Center is working!");
        }
        else {
            
            CCLOG(@"Game Center is NOT working!");
            
        }
    }];
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category
{
    
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        // Do something interesting here.
    }];
    
}

//Check the system version of the device to make sure that GameCenter is supported
+(BOOL) isGameCenterAvailable {
    
    // check for presence/existance of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	//check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

+ (GameCenterFiles *) getGameCenterManager {
    
    //Check to see is gameCenterManager is nil
    if (gameCenterManager == nil) {
        
        //If it is than allocate and initialize it
        gameCenterManager = [[GameCenterFiles alloc] init];
        
    }
    
    //return the gameCenterManager
    return gameCenterManager;
}

@end
