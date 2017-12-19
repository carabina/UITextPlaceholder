//
//  UITextPlaceholder.m
//  UIPlaceholder
//
//  Created by Basiliusic on 13/11/2017.
//  Copyright © 2017 FunWayInteractiveHQ. All rights reserved.
//

#import "UITextPlaceholder.h"

@import Foundation;

@interface UITextPlaceholder()

@end

@implementation UITextPlaceholder
@synthesize animationDuration = _animationDuration;

#pragma mark - Getters and setters
-(CGFloat) animationDuration {
    if(_animationDuration <= 0 || _animationDuration > 1.0) {
        return 0.1;
    }
    return _animationDuration;
}

-(void) setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
}

-(void) moveIn{
    [self moveInAnimated: !self.animationDisabled];
}

-(void) moveOut {
    [self moveOutAnimated: !self.animationDisabled];
}
-(void) moveInAnimated: (BOOL) animated {
    @throw [NSException exceptionWithName: @"" reason: @"" userInfo: nil];
}

-(void) moveOutAnimated: (BOOL) animated {
    @throw [NSException exceptionWithName: @"" reason: @"" userInfo: nil];
}
@end
