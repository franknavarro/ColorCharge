/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import <GameKit/GameKit.h>
#import "GameCenterFiles.h"


@implementation AppController

- (BOOL) application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //check first to make sure the current iOS supports GameCenter
    if ([GameCenterFiles isGameCenterAvailable]) {
        //get the manager and authenticate the player
        [[GameCenterFiles getGameCenterManager] authenticateLocalPlayer];
    }
    
    [[OALSimpleAudio sharedInstance] preloadEffect:@"whoosh.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaCLow.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaELow.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaGLow.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaC.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaE.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaG.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"MarimbaCHigh.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"YouSuck.mp3"];

    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    //Check if sounds are off when we run the app
    NSNumber *soundsOff = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundsOff"];
    
    //If we have never initialized this object then initialize it
    if (soundsOff == nil) {
        //Set SoundsOff to start off with NO because we want the game to start off with sounds
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"SoundsOff"];
        soundsOff = @(NO);
    }
    
    //Set muted to whatever sounds off is
    //  If sounds off is NO then muted is NO
    [[OALSimpleAudio sharedInstance] setMuted:[soundsOff boolValue]];
    
    //the silent switch always has priorety to the game sounds
    [[OALSimpleAudio sharedInstance] setHonorSilentSwitch:YES];

    
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
//**********************************************************************************************************************************************
// Added for MGWU SDK
//
//**********************************************************************************************************************************************
    
    [MGWU loadMGWU:@"JesusSaves7GodIsGood7"];
    [MGWU preFacebook]; //Temporarily disables Facebook until you integrate it later
    
    //Reminder to play
    [MGWU setReminderMessage:@"Your device must be feeling a little blue. Play Color Charge to make it feel colorful again!"];

//**********************************************************************************************************************************************

    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [super applicationWillResignActive:application];
    
    CCLOG(@"App will resign Active");
    if (!self.gameplayScene.paused) {
        [self.gameplayScene pause];
    }
    
    //Stop the animation because the game crashes if we dont do this for gamecenter and share :P
    [[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationDidBecomeActive:(UIApplication *)application {
    
    [super applicationDidBecomeActive:application];
    
    //Resume the options stopped when we entered the background
    [[CCDirector sharedDirector] startAnimation];
    
}

- (CCScene*) startScene {
    return [CCBReader loadAsScene:@"MainScene"];
}


//**********************************************************************************************************************************************
// Added for MGWU SDK
//
//**********************************************************************************************************************************************


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)tokenId {
    [MGWU registerForPush:tokenId];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [MGWU gotPush:userInfo];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    [MGWU failedPush:error];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [MGWU gotLocalPush:notification];
}

//**********************************************************************************************************************************************


@end
