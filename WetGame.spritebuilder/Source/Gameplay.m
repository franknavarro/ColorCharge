//
//  Gameplay.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Line.h"
#import "Playbar.h"

static const int kFallVelocity = -300;
static const double kSpawnSpeed = .5f;

@implementation Gameplay {
    
    NSMutableArray *_lines; //keeps track of all the lines running through the screen
    CCNode *_background; //used to add the line directly to the background so that the box is behind the
                         //    line
    PlayBar *_playBarLeft;
    PlayBar  *_playBarRight;
    
}

//When the Gameplay is initialized initialize the _lines array
- (id)init
{
    //Conventional crap
    self = [super init];
    if (self) {
        //Initialize the _lines array
        //NOTE TO SELF: [NSMutableArray array] is the same as [[alloc]init] for an array
        _lines = [NSMutableArray array];
        
    }
    return self;
}

//As soon as the file is loaded
-(void) didLoadFromCCB {
    
    //Start by spawning a line so that we don't have to wait for the interval that comes next
    [self spawnNewLine];
    //Slpawn anew line every 1 and a half frames/seconds
    [self schedule: @selector(spawnNewLine) interval:kSpawnSpeed];
    
    
}

- (void) onEnter {
    
    [super onEnter];
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
}

//This method puts in a new line at the top of the screen to be scrolled down
- (void) spawnNewLine {
    
    //initialize a new line
    Line *newLine = (Line*)[CCBReader load:@"Line"];
    
    //Randomly changes the color of the line
    [newLine changeColor];
    
    //add the new line to the array of lines to be scrolled through
    [_lines addObject:newLine];
    //add the line to the sceen
    [_background addChild:newLine];
    //get the size of the current screen
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    //poistion the new line at half of the screen width at the very top of the screen
    newLine.position = ccp(screenSize.width/2, screenSize.height);

}

//calls every frame
- (void) update:(CCTime)delta {
    
    //Goes through every line in the array of lines to scroll them down the screen
    for (Line *line in _lines) {
        //update the lines position to keep the same x axis position and scroll down the screen
        line.position = ccp(line.position.x, line.position.y + kFallVelocity * delta);
    }
    
    //An array to keep track of which lines we now have to remove from the game
    NSMutableArray *removeFromLines = [NSMutableArray array];
    
    //Goes through the lines in the array and adds them to another array to be deleted
    for (Line *line in _lines) {
        //If the line is completely outside the screen add it to the array of lines to be taken out
        if (line.position.y < -(line.boundingBox.size.height)) {
            [removeFromLines addObject:line];
        }
    }
    
    //delete the line from _lines array by going through the array of lines we want to get rid of
    for (Line *removeLine in removeFromLines) {
        //Remove the line
        [_lines removeObject:removeLine];
        //Delete it from the scene
        [removeLine removeFromParent];
    }

    //Keep track of how many exisiting lines there are
    //CCLOG(@"%d", _lines.count);
    
    
    
}

@end
