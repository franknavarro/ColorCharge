//
//  HitBox.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HitBox.h"
#import "Color.h"

@implementation HitBox {
    
    CCSprite *_boxColor;
    
}

- (void) updateWhiteBoxAtEnd {
    
    //call the color change method in order to change to color of the box
    [Color changeObject:_boxColor withOffSetColor:ActiveColorGrey];
    
}

- (void) updateBoxColor: (ActiveColor) newColor {
    
    //call the color change method in order to change to color of the box
    [Color changeObject:_boxColor withColor:newColor];
    
    //set the boxes current color to the newly assinged color
    self.currentBoxColor = newColor;
    
}

@end
