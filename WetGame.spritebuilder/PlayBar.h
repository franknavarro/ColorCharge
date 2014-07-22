//
//  PlayBar.h
//  WetGame
//
//  Created by Frank Navarro-Velasco on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Color.h"
#import "ColorSelectionDelegate.h"

@interface PlayBar : CCNode

@property (nonatomic, assign) ActiveColor currentColorPressed;

//used to call updatePressedColor in Gameplay
@property (nonatomic, weak) NSObject <ColorSelectionDelegate> *colorSelectionDelegate;

@end
