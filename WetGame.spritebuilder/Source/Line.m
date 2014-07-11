//
//  Line.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Line.h"

static CCColor *previousColor;

@implementation Line {
    CCNodeColor *_color;
}

- (void) changeColor {
    
    int randomNumber = arc4random()%22;
    
    //Red Line
    if(randomNumber <= 2) {
        previousColor = [CCColor colorWithRed:1.f green:0.f blue:0.f];
        [_color setColor:previousColor];
    }
    
    //Blue Line
    else if(randomNumber <= 5) {
        previousColor = [CCColor colorWithRed:0.f green:0.f blue:1.f];
        [_color setColor:previousColor];
    }
    
    //Yellow Line
    else if (randomNumber <= 8) {
        previousColor = [CCColor colorWithRed:1.f green:1.f blue:0.f];
        [_color setColor:previousColor];
    }
    
    //Purple Line
    else if (randomNumber <= 10) {
        previousColor =[CCColor colorWithRed:0.4f green:0.17f blue:0.56f];
        [_color setColor:previousColor];
    }
    
    //Green Line
    else if (randomNumber <= 12) {
        previousColor = [CCColor colorWithRed:0.f green:1.f blue:0.f];
        [_color setColor:previousColor];
    }
    
    else if (randomNumber <= 14) {
        previousColor = [CCColor colorWithRed:1.f green:0.58f blue:0.11f];
        [_color setColor:previousColor];
    }
    
    //Black Line
    else if (randomNumber == 15) {
        previousColor = [CCColor colorWithRed:1.f green:1.f blue:1.f];
        [_color setColor:previousColor];
    }
    
    //Set the color to the previous color
    else {
        [_color setColor:previousColor];
    }
    
}

@end
