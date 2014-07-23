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
            [objectToChange setColor:[CCColor colorWithRed:(235.f/255.f) green:(45.f/255.f) blue:(24.f/255.f)]];
            break;
            
        case ActiveColorBlue:
            [objectToChange setColor:[CCColor colorWithRed:(0.f/255.f) green:(120.f/255.f) blue:(255.f/255.f)]];
            break;
            
        case ActiveColorYellow:
            [objectToChange setColor:[CCColor colorWithRed:(245.f/255.f) green:(241.f/255.f) blue:(54.f/255.f)]];
            break;
            
        case ActiveColorGreen:
            [objectToChange setColor:[CCColor colorWithRed:(40.f/255.f) green:(200.f/255.f) blue:(92.f/255.f)]];
            break;
            
        case ActiveColorPurple:
            [objectToChange setColor:[CCColor colorWithRed:(171.f/255.f) green:(0.f/255.f) blue:(253.f/255.f)]];
            break;
            
        case ActiveColorOrange:
            [objectToChange setColor:[CCColor colorWithRed:(255.f/255.f) green:(163.f/255.f) blue:(54.f/255.f)]];
            break;
            
        case ActiveColorNone:
            [objectToChange setColor:[CCColor colorWithRed:1.f green:1.f blue:1.f]];
            break;
    }
}


@end
