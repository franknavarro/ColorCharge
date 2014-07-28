//
//  ActiveColor.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(int, ActiveColor) {
    
    ActiveColorNone,
    ActiveColorBlue,
    ActiveColorRed,
    ActiveColorYellow,
    ActiveColorGreen,
    ActiveColorPurple,
    ActiveColorOrange,
    ActiveColorGrey
    
};

@interface Color : NSObject

+ (void) changeObject: (id) objectToChange withColor: (ActiveColor) newColor;
+ (void) changeObject: (id) objectToChange withOffSetColor: (ActiveColor) newColor;

@end
