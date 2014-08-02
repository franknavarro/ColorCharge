//
//  SharedImage.m
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SharedImage.h"


@implementation SharedImage {
    
    CCNodeColor *_mainColor;
    CCNodeColor *_shaderColor;
    
    CCLabelTTF *_score;
    
}

- (void) setUpImageWithColor: (ActiveColor) newColor andScore: (int) score{
    
    [Color changeObject:_mainColor withColor:newColor];
    [Color changeObject:_shaderColor withOffSetColor:newColor];
    _score.string = [NSString stringWithFormat:@"%i", score];
    
}

@end
