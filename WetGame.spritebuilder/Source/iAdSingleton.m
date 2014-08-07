//
//  iAdSingleton.m
//  Color Charge
//
//  Created by Frank Navarro-Velasco on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "iAdSingleton.h"


@implementation iAdSingleton

//make a static variable of the Ad Banner to make it smoother
static iAdSingleton *sharediAd;

static bool isBannerSupposedToBeOnScreen;

//syntesize the adBanner and Scene to make sure it initializes
@synthesize adBanner;

+(iAdSingleton *) sharedInstanceOfiAd {

    //if sharediAd is nil then initialize it
    if(!sharediAd)
        sharediAd = [[self alloc] init];
    
    //retun the static instance of the shared iAd
    return sharediAd;
}

- (void) addBannerToScreen {
    
    //add the banner as a subview of the scene
    [[[CCDirector sharedDirector] view] addSubview:self.adBanner];
    //Add the ad view to the very front
    [[[CCDirector sharedDirector] view] bringSubviewToFront:self.adBanner];
    
    //since the addBannerToScreen was called the banner therefore is supposed to be on the screen
    isBannerSupposedToBeOnScreen = YES;
    
    
    [self layoutAnimated:YES];

    
}

- (void) removeBannerFromScreen {
    
    //make it so we tell the game that our ad banner needs to be off the screen
    isBannerSupposedToBeOnScreen = NO;
    
    //animate the layout so it now knows that the banner is supposed to be off the screen
    [self layoutAnimated:YES];
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //In iOS 6.0 add banner is initialized in a new effecient way so inititialize it here
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            self.adBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        }
        else {
            self.adBanner = [[ADBannerView alloc] init];
        }
        
        //Set which size ads can play in this ad banner
        self.adBanner.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        //Set the size of the banner itself
        self.adBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        //Set the view to be transparent background so we can still interact with the game
        [self.adBanner setBackgroundColor:[UIColor clearColor]];
        //Set so we can access the methods called for opening and closing ads here
        self.adBanner.delegate = self;
        //make so the banner can be on the screen when it is first initialized
        isBannerSupposedToBeOnScreen = YES;
        
    }
    
    return self;
}


- (void) layoutAnimated:(BOOL)animated {
    
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGSize contentFrame = [[CCDirector sharedDirector] viewSize];
    
    if (contentFrame.width < contentFrame.height) {
        self.adBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    }
    else {
        self.adBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    //Get the frame for the banner
    CGRect bannerFrame = self.adBanner.frame;
    if (self.adBanner.bannerLoaded && isBannerSupposedToBeOnScreen) {
        bannerFrame.origin.y = 0;
    } else {
        bannerFrame.origin.y -= bannerFrame.size.height;
    }
    
    [UIView animateWithDuration: animated ? 0.25 : 0.0 animations:^{
        
        self.adBanner.frame = bannerFrame;
        
    }];
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutAnimated:YES];
}


@end
