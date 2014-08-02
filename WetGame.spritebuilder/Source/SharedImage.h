//
//  SharedImage.h
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Color.h"

@interface SharedImage : CCNode

@property (nonatomic, strong) CCNode *shareThis;

- (void) setUpImageWithColor: (ActiveColor) newColor andScore: (int) score;

@end
