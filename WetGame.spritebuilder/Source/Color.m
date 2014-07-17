//
//  ActiveColor.m
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Color.h"

@implementation Color

+ (void) changeObject: (id) objectToChange withColor: (ActiveColor) newColor {

    //Change the color of the box
    switch (newColor) {
        case ActiveColorRed:
            [objectToChange setColor:[CCColor colorWithRed:1.f green:0.f blue:0.f]];
            break;
            
        case ActiveColorBlue:
            [objectToChange setColor:[CCColor colorWithRed:0.f green:0.f blue:1.f]];
            break;
            
        case ActiveColorYellow:
            [objectToChange setColor:[CCColor colorWithRed:1.f green:1.f blue:0.f]];
            break;
            
        case ActiveColorGreen:
            [objectToChange setColor:[CCColor colorWithRed:0.f green:1.f blue:0.f]];
            break;
            
        case ActiveColorPurple:
            [objectToChange setColor:[CCColor colorWithRed:0.4f green:0.17f blue:0.56f]];
            break;
            
        case ActiveColorOrange:
            [objectToChange setColor:[CCColor colorWithRed:1.f green:0.58f blue:0.11f]];
            break;
            
        case ActiveColorNone:
            [objectToChange setColor:[CCColor colorWithRed:1.f green:1.f blue:1.f]];
            break;
    }
}


@end
