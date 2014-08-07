//
//  iAdSingleton.h
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface iAdSingleton : NSObject <ADBannerViewDelegate>

@property (nonatomic, strong) ADBannerView *adBanner;

+(iAdSingleton *) sharedInstanceOfiAd;
- (void) addBannerToScreen;
- (void) removeBannerFromScreen;


@end
