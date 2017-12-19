//
//  UITextPlaceholder.h
//  UIPlaceholder
//
//  Created by Basiliusic on 13/11/2017.
//  Copyright © 2017 FunWayInteractiveHQ. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, UIPLaceholderState) {
    UIPlaceholderStateOutside = 0,
    UIPlaceholderStateInside
};

IB_DESIGNABLE

@interface UITextPlaceholder : UILabel

@property (nonatomic, assign) IBInspectable BOOL animationDisabled;
// Animation duration (0.1 by default, if 0.0 or smaller is used default duration)
@property (nonatomic, assign) IBInspectable CGFloat animationDuration;
// State flag
@property (nonatomic, assign) UIPLaceholderState state;

-(void) moveIn;
-(void) moveOut;

-(void) moveInAnimated: (BOOL) animated;
-(void) moveOutAnimated: (BOOL) animated;
@end
