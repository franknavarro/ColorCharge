//
//  GameOver.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Gameplay.h" //imported to access the score
#import "NSUserDefaults+Encryption.h"
#import "MainScene.h"
#import <GameKit/GameKit.h>
#import "GameCenterFiles.h"
#import "SharedImage.h"

@implementation GameOver {
    
    CCLabelTTF *_finalScoreNumber;
    CCLabelTTF *_highScoreNumber;
    
    CCSprite *_scoreBox;
    CCSprite *_restartBackground;
    CCSprite *_menuBackground;
    CCSprite *_leaderBoardBackground;
    CCSprite *_shareBackground;
    
    //All the lines that shoot up in the end
    CCNodeColor *_finishLine1;
    CCNodeColor *_finishLine2;
    CCNodeColor *_finishLine3;
    CCNodeColor *_finishLine4;
    CCNodeColor *_finishLine5;
    NSMutableArray *_finishLines;
    
}

#pragma mark - In the begining...

-(void) didLoadFromCCB {
    
    //initialize the array of finish lines with the finish lines
    _finishLines = [NSMutableArray arrayWithObjects:_finishLine1, _finishLine2, _finishLine3, _finishLine4, _finishLine5,  nil];
    
    
}

-(void) onEnter {
    
    [super onEnter];

    //Get the encrypted high score
    NSNumber *getHighScore = [[NSUserDefaults standardUserDefaults] objectEncryptedForKey:@"HighScore"];
    
    //stores the integer for the highscore
    int highScore;
    
    //if the highscore is not nil
    if (getHighScore) {
        //store the current highscore in the local variable of highscore
        highScore = [getHighScore intValue];
    } else {
        //if it is nil set highscore to 0
        highScore = 0;
    }
    
    //if the current final score is greater than the current high score than display the final score in highscore instead and
    //save the highscore encrypted status
    if (self.finalScore > highScore) {
        //Encrypt the highscore in NSUserDefaults to save it
        [[NSUserDefaults standardUserDefaults] setObjectEncrypted:@(self.finalScore) forKey:@"HighScore"];
        //Display finalScore as highScore
        _highScoreNumber.string = [NSString stringWithFormat:@"%i", self.finalScore];
    } else {
        //Display current highScore
        _highScoreNumber.string = [NSString stringWithFormat:@"%i", highScore];
    }
    
    //Display the current final score
    _finalScoreNumber.string = [NSString stringWithFormat:@"%i", self.finalScore];
    

    
    //change the color to the line that you lost on
    [self changeColorForFinishLines: self.losingLine];
    [self runFinishLines];

    
    //reset the first line to not finished
    [Line resetFirstLineDone];
    
    //Report score to gamecenter
    if (self.finalScore > 0 && [GameCenterFiles isGameCenterAvailable]) {
    
        int64_t reportScoreOf = self.finalScore;
        
        [[GameCenterFiles getGameCenterManager] reportScore:reportScoreOf forLeaderboardID:@"1a"];
        
    }
    
    
//**********************************************************************************************************************************************
// Added for MGWU SDK
//
//**********************************************************************************************************************************************

    NSNumber *score =  [NSNumber numberWithInt:self.finalScore];
    NSNumber *losingLinesColor = [NSNumber numberWithInt:self.losingLine.linesColor];
    NSNumber *losingColorPressed = [NSNumber numberWithInt:self.colorPressed];
    NSDictionary *losingConditions = [[NSDictionary alloc] initWithObjectsAndKeys:score, @"score", losingLinesColor, @"losing_Lines_Color", losingColorPressed, @"color_User_Pressed", nil];
    
    [MGWU logEvent:@"Game_Over" withParams:losingConditions];
    
//**********************************************************************************************************************************************

    
}

#pragma mark - Asthetics for running GameOver

- (void) changeColorForFinishLines: (Line *) losingLine {
    
    for (CCNodeColor *currentFinishLine in _finishLines) {
        currentFinishLine.cascadeColorEnabled = YES;
        [Color changeObject:currentFinishLine withColor:losingLine.linesColor];
    }
    
    [Color changeObject:_scoreBox withOffSetColor:losingLine.linesColor];
    [Color changeObject:_restartBackground withOffSetColor:losingLine.linesColor];
    [Color changeObject:_menuBackground withOffSetColor:losingLine.linesColor];
    [Color changeObject:_leaderBoardBackground withOffSetColor:losingLine.linesColor];
    [Color changeObject:_shareBackground withOffSetColor:losingLine.linesColor];

    
}

- (void) runFinishLines {
    
    //Check to make sure there are still lines in the array to move
    if (_finishLines && _finishLines.count) {
        
        //Get a random number index of the array
        int indexCount = (int)[_finishLines count];
        int randomNumberForIndex;
        
        //If there is only 1 object then dont pick a random line but rather the first line in the array
        if (indexCount == 1) {
            randomNumberForIndex = 0;
        } else {
            //pick a random index value in the array
            randomNumberForIndex = arc4random() % indexCount;
        }
        
        //set the current moving line with the randomly picked line
        CCNode *currentFinishLine = [_finishLines objectAtIndex:randomNumberForIndex];
        
        //set up where the line moves to
        CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:1.f position:ccp(currentFinishLine.position.x, 1.0f)];
        //add an elastic effect to the move
        CCActionEase *moveToWithEase = [CCActionEaseIn actionWithAction:moveTo rate:10.f];

        //make the line move with that action
        [currentFinishLine runAction:moveToWithEase];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[OALSimpleAudio sharedInstance] playEffect:@"whoosh.wav"];
            
        });
        
        //remove the line from the array so that we know which lines are left to move
        [_finishLines removeObject:currentFinishLine];
        
        //re run this to move another line
        [self unschedule:@selector(runFinishLines)];
        [self scheduleOnce:@selector(runFinishLines) delay:0.1f];
    }
    
    else {
        //if there are no more lines in the array then just stop this method
        [self unschedule:@selector(runFinishLines)];
    }
    
}

#pragma mark - Buttons

- (void) restart {
    
    //Play a random marimba sound
    [Color playSound];
    
    //Save the Gameplay scene
    CCScene *newScene = [CCBReader loadAsScene:@"Gameplay"];
    //Set up the transition
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //Begin the tranistion made to go to Gameplay
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
    
    [MGWU logEvent:@"Restart_Pressed" withParams:nil];
    
}

- (void) backToMenu {
    
    //Play a random marimba sound
    [Color playSound];
    
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.f];
    [[CCDirector sharedDirector] presentScene:mainMenu withTransition:transition];
    
    [MGWU logEvent:@"Menu_Pressed" withParams:nil];

    
}

- (void) showLeaderboard {
    
    //Play a random marimba sound
    [Color playSound];
    
    [MGWU logEvent:@"Restart_Pressed" withParams:nil];
    
    [self showLeaderboard:@"1a"];
    
}

- (void) showLeaderboard: (NSString*) leaderboardID
{
    //Load in the view controller for the game center leaderboard
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    
    //Check to make sure gameCenterController exists
    if (gameCenterController != nil)
    {
        //Set all the values for the Leaderboard
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeWeek;
        gameCenterController.leaderboardCategory = leaderboardID;
        
        //Present the gameCenter Leaderboard
        [[CCDirector sharedDirector] presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    //Get rid of the gameCenter screne
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) shareButton {
    
    //Play a random marimba sound
    [Color playSound];
    
    //Create the image that we want to share
    SharedImage *shareThisImage = (SharedImage *) [CCBReader load:@"SharedImage"];
    //set up the image to show your score and the color lost on
    [shareThisImage setUpImageWithColor:self.losingLine.linesColor andScore:self.finalScore];
    
    //add the child to the self all the way in the back behind everything
    //  this is because when we render this node as a texture to make it an image it needs a parents timeline
    //  to follow so this gives it the timeline of this class for funsies
    //  p.s. this is super hacky
    [self addChild:shareThisImage z:-1];
    CCNode *node = [shareThisImage.children objectAtIndex:0];
    
    
    //Text for the post to say
    NSString *text = [NSString stringWithFormat:@"I just scored %i in Color Charge!", self.finalScore];
    //Save the image of the share image we are going to send
    UIImage *image = [GameOver screenshotWithStartNode:node];
    
    //Insert these when I find out how to screen shot and when I know what the app store url is
    //    NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
    
    //create the activity view controller to hold the text image and url we defined above
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, image] //, url]
     applicationActivities:nil];
    
    //Exlude all this stuff from sharing
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];

    //present the view controller
    [[CCDirector sharedDirector] presentViewController:controller animated:YES completion:nil];
    
  
    
}

+(UIImage *) screenshotWithStartNode: (CCNode *) startNode {
    
    //I have no clue what this does but it works
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
//    CGSize winSize = [[CCDirector sharedDirector] viewSize];
//    
//    //Start making a new texture with the size of the node we are making an image of
//    CCRenderTexture *rtx =
//    [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
    
    
    
    CCRenderTexture *rtx =
    [CCRenderTexture renderTextureWithWidth:startNode.contentSize.width height:startNode.contentSize.height];
    
    
    [rtx begin];    //Begin making the texture
    [startNode visit];  //have the node we want to make an image of start drawing on the texture
    [rtx end];  //Stop making the texture
    
    //make the texture an image and return it
    return [rtx getUIImage];
    
}

@end
