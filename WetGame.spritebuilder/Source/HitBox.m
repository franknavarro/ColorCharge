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

- (void) updateBoxColor: (ActiveColor) newColor {
    
    //Change the color of the box
    switch (newColor) {
        case ActiveColorRed:
            [_boxColor setColor:[CCColor colorWithRed:1.f green:0.f blue:0.f]];
            break;
            
        case ActiveColorBlue:
            [_boxColor setColor:[CCColor colorWithRed:0.f green:0.f blue:1.f]];
            break;
            
        case ActiveColorYellow:
            [_boxColor setColor:[CCColor colorWithRed:1.f green:1.f blue:0.f]];
            break;
            
        case ActiveColorGreen:
            [_boxColor setColor:[CCColor colorWithRed:0.f green:1.f blue:0.f]];
            break;
            
        case ActiveColorPurple:
            [_boxColor setColor:[CCColor colorWithRed:0.4f green:0.17f blue:0.56f]];
            break;
            
        case ActiveColorOrange:
            [_boxColor setColor:[CCColor colorWithRed:1.f green:0.58f blue:0.11f]];
            break;
            
        case ActiveColorNone:
            [_boxColor setColor:[CCColor colorWithRed:1.f green:1.f blue:1.f]];
            break;
    }
    
    //set the boxes current color to the newly assinged color
    self.currentBoxColor = newColor;
    
}

@end
