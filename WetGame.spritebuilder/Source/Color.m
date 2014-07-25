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
            [objectToChange setColor:[Color defaultRed]];
            break;
            
        case ActiveColorBlue:
            [objectToChange setColor:[Color defaultBlue]];
            break;
            
        case ActiveColorYellow:
            [objectToChange setColor:[Color defaultYellow]];
            break;
            
        case ActiveColorGreen:
            [objectToChange setColor:[Color defaultGreen]];
            break;
            
        case ActiveColorPurple:
            [objectToChange setColor:[Color defaultPurple]];
            break;
            
        case ActiveColorOrange:
            [objectToChange setColor:[Color defaultOrange]];
            break;
            
        case ActiveColorGrey:
            [objectToChange setColor:[Color defaultGrey]];
            break;
            
        case ActiveColorNone:
            [objectToChange setColor:[Color defaultWhite]];
            break;
            
            
    }
}

+ (void) changeObject: (id) objectToChange withOffSetColor: (ActiveColor) newColor {
    
    //Change the color of the box
    switch (newColor) {
        case ActiveColorRed:
            [objectToChange setColor:[Color offSetRed]];
            break;
            
        case ActiveColorBlue:
            [objectToChange setColor:[Color offSetBlue]];
            break;
            
        case ActiveColorYellow:
            [objectToChange setColor:[Color offSetYellow]];
            break;
            
        case ActiveColorGreen:
            [objectToChange setColor:[Color offSetGreen]];
            break;
            
        case ActiveColorPurple:
            [objectToChange setColor:[Color offSetPurple]];
            break;
            
        case ActiveColorOrange:
            [objectToChange setColor:[Color offSetOrange]];
            break;
            
        case ActiveColorGrey:
            [objectToChange setColor:[Color offSetGrey]];
            break;
            
        case ActiveColorNone:
            [objectToChange setColor:[Color offSetWhite]];
            break;
            
            
    }
}


#pragma mark - Defualt Colors

+ (CCColor *) defaultRed {
    
    return [CCColor colorWithRed:(235.f/255.f) green:(45.f/255.f) blue:(24.f/255.f)];
    
}

+ (CCColor *) defaultBlue {
    
    return [CCColor colorWithRed:(0.f/255.f) green:(120.f/255.f) blue:(255.f/255.f)];
    
}

+ (CCColor *) defaultYellow {
    
    return [CCColor colorWithRed:(245.f/255.f) green:(241.f/255.f) blue:(54.f/255.f)];
    
}

+(CCColor *) defaultGreen {
    
    return [CCColor colorWithRed:(40.f/255.f) green:(200.f/255.f) blue:(92.f/255.f)];
}

+ (CCColor *) defaultPurple {
    
    return [CCColor colorWithRed:(171.f/255.f) green:(0.f/255.f) blue:(253.f/255.f)];
    
}

+ (CCColor *) defaultOrange {
    
    return [CCColor colorWithRed:(255.f/255.f) green:(163.f/255.f) blue:(54.f/255.f)];
    
}

+ (CCColor *) defaultWhite {
    
    return [CCColor colorWithRed:1.f green:1.f blue:1.f];
    
}

+ (CCColor *) defaultGrey {
    
    return [CCColor colorWithRed:(230.f/255.f) green:(230.f/255.f) blue:(230.f/255.f)];
    
}

#pragma mark - Off Set Colors

+ (CCColor *) offSetRed {
    
    return [CCColor colorWithRed:(255.f/255.f) green:(231.f/255.f) blue:(255.f/255.f)];
}

+ (CCColor *) offSetBlue {
    
    return [CCColor colorWithRed:(231.f/255.f) green:(255.f/255.f) blue:(255.f/255.f)];
}

+ (CCColor *) offSetYellow {
    
    return [CCColor colorWithRed:(255.f/255.f) green:(255.f/255.f) blue:(167.f/255.f)];
}

+ (CCColor *) offSetGreen {
    
    return [CCColor colorWithRed:(223.f/255.f) green:(255.f/255.f) blue:(166.f/255.f)];
}

+ (CCColor *) offSetPurple {
    
    return [CCColor colorWithRed:(231.f/255.f) green:(227.f/255.f) blue:(255.f/255.f)];
}


+ (CCColor *) offSetOrange {
    
    return [CCColor colorWithRed:(255.f/255.f) green:(217.f/255.f) blue:(176.f/255.f)];
}

+ (CCColor *) offSetWhite {
    
    return [CCColor colorWithRed:(230.f/255.f) green:(230.f/255.f) blue:(230.f/255.f)];
}

+ (CCColor *) offSetGrey {
    
    return [CCColor colorWithRed:(102.f/255.f) green:(102.f/255.f) blue:(102.f/255.f)];
    
}

@end
