//
//  GameCenterFiles.m
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameCenterFiles.h"
#import <GameKit/GameKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion

static GameCenterFiles *gameCenterManager = nil;
static NSMutableDictionary *achievementsDictionary;
BOOL isGameCenterActive;

@implementation GameCenterFiles

#pragma mark - Starting Game Center

- (void) authenticateLocalPlayer
{
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (localPlayer.isAuthenticated)
            {
                // Player was successfully authenticated.
                // Perform additional tasks for the authenticated player.
                CCLOG(@"Game Center is working!");
                //If GameCenter is activated then load in the achievements
                [self loadAchievements];
                isGameCenterActive = YES;
            }
            else {
                CCLOG(@"Game Center is NOT working!");
                isGameCenterActive = NO;
            }
        }];
    }
    else {
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil)
            {
                //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
                isGameCenterActive =YES;
            }
            else if (localPlayer.isAuthenticated)
            {
                //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
            }
            else
            {
                isGameCenterActive = NO;
            }
        };

    }
}

//Check the system version of the device to make sure that GameCenter is supported
+(BOOL) isGameCenterAvailable {
    
    // check for presence/existance of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	//check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL isVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && isVersionSupported);
}

#pragma mark - Leaderboards

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category {
    
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        // Do something interesting here.
    }];
    
}

#pragma mark - Achievements

- (void) loadAchievements {
    
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        //if check if we have an error
        if (error != nil) {
            // Handle the error.
        }
        //if we dont have an error loading the achievements then create the achievements
        else {
            //initialize the dictionary object
            achievementsDictionary = [[NSMutableDictionary alloc] init];
            
            //go through and put in all the achievements we have
            for (GKAchievement* achievement in achievements)
                [achievementsDictionary setObject: achievement forKey: achievement.identifier];
        }
        
        if (achievements != nil)
        {
            // Process the array of achievements.
        }
        
    }];


}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent {
    
    //Get the achievement with the specified identifier
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    //Check to make sure the achievement is not nil
    if (achievement)
    {
        //Check if the achievement has already been completed or if the percent complete is already greater than
        //  the amount we are giving it when make the achievement nil so we dont submit it again
        if (achievement.percentComplete >= 100 || achievement.percentComplete >= percent) {
            achievement = nil;
        }
        
        //Check if the achievement is nil and if not report the score
        if (achievement) {
            //update the achievement percentage
            achievement.percentComplete = percent;
            achievement.showsCompletionBanner = YES;
            //Report the achievement
            [achievement reportAchievementWithCompletionHandler:^(NSError *error)
             {
                 //check if there is an error
                 if (error != nil)
                 {
                     //Log the error
                     NSLog(@"Error in reporting achievements: %@", error);
                 }
             }];
        }
    }
}

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier {
    
    //get the achievement located in the dictionary of achievements we created
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    //make sure the achievement is empty and if it is create an new instance of it
    if (achievement == nil)
    {
        //initialize the achievement
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        //store it within our dictionary
        [achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    
    //return the achievement we created if needed or the achievement that existed in the
    //  dictionary
    return achievement;
}


#pragma mark - Instance of class

+ (GameCenterFiles *) getGameCenterManager {
    
    //Check to see is gameCenterManager is nil
    if (gameCenterManager == nil) {
        
        //If it is than allocate and initialize it
        gameCenterManager = [[GameCenterFiles alloc] init];
        
    }
    
    //return the gameCenterManager
    return gameCenterManager;
}

+ (NSMutableDictionary *) sharedAchievements {
    
    //return the achievements
    return achievementsDictionary;

}

+ (BOOL) isGameCenterActivated {
    
    //return the bool that tells uswether gamecenter was activated
    return isGameCenterActive;
    
}

@end
