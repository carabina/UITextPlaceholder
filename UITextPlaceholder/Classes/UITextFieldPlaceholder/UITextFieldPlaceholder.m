//
//  UITextFieldPlaceholder.m
//  UIPlaceholder
//
//  Created by Basiliusic on 13/11/2017.
//  Copyright © 2017 FunWayInteractiveHQ. All rights reserved.
//

#import "UITextFieldPlaceholder.h"

@import CoreText;

static void *SetTextFieldTextContext = &SetTextFieldTextContext;

@interface UITextFieldPlaceholder()
@property (nonatomic, weak) id<UITextFieldDelegate> textFieldInitialDelegate;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) BOOL addedObservers;
@end

@implementation UITextFieldPlaceholder
#pragma mark - Initialization
-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if(self) {
        
    }
    
    return self;
}

-(void) setColor:(UIColor *)color {
    _color = color;
    if(self.state == UIPlaceholderStateInside) {
        [self updateTextFieldPlaceholderTextTo: self.text];
    } else {
        self.textColor = color;
    }
}

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if(self) {
        
    }
    
    return self;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark - Observers
-(void) willMoveToWindow:(UIWindow *)newWindow {
    if(!newWindow) {
        [self removeObjservers];
    }
}

-(void) addObservers {
    if(!self.addedObservers) {
        [self addObserver: self forKeyPath: @"textField.text" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context: SetTextFieldTextContext];
        self.addedObservers = YES;
    }
}

-(void) removeObjservers {
    if(self.addedObservers) {
        [self removeObserver: self forKeyPath: @"textField.text" context: SetTextFieldTextContext];
        self.addedObservers = NO;
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(context == SetTextFieldTextContext) {
        NSString *newString = change[NSKeyValueChangeNewKey];
        if(newString.length > 0) {
            [self moveOut];
        } else {
            [self moveIn];
        }
    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}

#pragma mark - Getters and setters
-(void) setTextField:(UITextField *)textField {
    self.textFieldInitialDelegate = textField.delegate;
    _textField = textField;
    _textField.delegate = self;
    
    self.color = self.textColor;
    
    self.backgroundColor = UIColor.clearColor;
    
    // update state
    self.state = _textField.text.length > 0 ? UIPlaceholderStateOutside : UIPlaceholderStateInside;
    
    // update color
    self.color = self.useTextFieldPlaceholderColor ? [UIColor colorWithRed: 0.78 green: 0.78 blue: 0.804 alpha: 1] : self.textColor;
    if(self.state == UIPlaceholderStateInside) {
        self.textColor = UIColor.clearColor;
    }
    
    // update text
    [self updateTextFieldPlaceholderTextTo: self.text];
    
    [self removeObjservers];
    [self addObservers];
}

#pragma mark - Update textfield placeholder text
-(void) updateTextFieldPlaceholderTextTo: (NSString *) text {
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: text attributes: @{NSForegroundColorAttributeName : self.color}];
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textFieldShouldBeginEditing:)]) {
        return [self.textFieldInitialDelegate textFieldShouldBeginEditing: textField];
    }
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textFieldDidBeginEditing:)]) {
        [self.textFieldInitialDelegate textFieldDidBeginEditing: textField];
    }
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textFieldShouldEndEditing:)]) {
        return [self.textFieldInitialDelegate textFieldShouldEndEditing: textField];
    }
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textFieldDidEndEditing:reason:)]) {
        [self.textFieldInitialDelegate textFieldDidEndEditing: textField reason: reason];
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textFieldDidEndEditing:)]) {
        [self.textFieldInitialDelegate textFieldDidEndEditing: textField];
    }
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL returnValue = YES;
    
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textField:shouldChangeCharactersInRange:replacementString:)]){
        returnValue = [self.textFieldInitialDelegate textField: textField shouldChangeCharactersInRange: range replacementString: string];
    }
    
    if(returnValue) {
        NSString *replacementString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        if(replacementString.length > 0) {
            [self moveOut];
        } else {
            [self moveIn];
        }
    }
    
    return returnValue;
}

-(BOOL) textFieldShouldClear:(UITextField *)textField {
    BOOL returnValue = YES;
    
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textFieldShouldClear:)]) {
        returnValue = [self.textFieldInitialDelegate textFieldShouldClear: textField];
    }
    
    if(returnValue) {
        [self updateTextFieldPlaceholderTextTo: @""];
        [self moveIn];
    }
    
    return NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if([self.textFieldInitialDelegate respondsToSelector: @selector(textFieldShouldReturn:)]) {
        [self.textFieldInitialDelegate textFieldShouldReturn: textField];
    }
    return YES;
}

#pragma mark - Move placeholder
-(void) moveInAnimated:(BOOL)animated {
    if(self.state == UIPlaceholderStateOutside) {
        self.state = UIPlaceholderStateInside;
        if(animated) {
            [self startMoveInAnimation];
        }
    }
}

-(void) moveOutAnimated:(BOOL)animated {
    if(self.state == UIPlaceholderStateInside) {
        self.textColor = self.color;
        self.state = UIPlaceholderStateOutside;
        if(animated) {
            [self startMoveOutAnimation];
        }
    }
}

#pragma mark - Animation
-(void) startMoveOutAnimation {
    CGPoint labelPosition = self.center;
    
    CGSize textFieldplaceholderTextSize = [self.textField.placeholder sizeWithAttributes: @{NSFontAttributeName : self.textField.font}];
    CGSize placeholderTextSize = [self.text sizeWithAttributes: @{NSFontAttributeName : self.font}];
    CGRect textFieldPlaceholderRect = [self.textField placeholderRectForBounds: self.textField.frame];
    
    CGPoint textFieldPlaceHolderPosition = CGPointMake(textFieldplaceholderTextSize.width / 2 + textFieldPlaceholderRect.origin.x, textFieldPlaceholderRect.origin.y);
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath: @"position"];
    position.fromValue = [NSValue valueWithCGPoint: CGPointMake(textFieldPlaceHolderPosition.x, self.textField.center.y)];
    position.toValue = [NSValue valueWithCGPoint: CGPointMake(labelPosition.x, labelPosition.y)];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    CGFloat scaleFactor = textFieldplaceholderTextSize.width / placeholderTextSize.width;
    scale.fromValue = @(scaleFactor);
    scale.toValue = @(1.0);
    
    CAAnimationGroup *animationPositionGroup = [CAAnimationGroup animation];
    animationPositionGroup.animations = @[position, scale];
    animationPositionGroup.duration = self.animationDuration;
    animationPositionGroup.speed = 1.0;
    
    // Start animation
    [self.layer addAnimation: animationPositionGroup forKey: @"enableAnimation"];
}

-(void) startMoveInAnimation {
    CGPoint labelPosition = self.center;
    
    CGSize textFieldplaceholderTextSize = [self.textField.placeholder sizeWithAttributes: @{NSFontAttributeName : self.textField.font}];
    CGSize placeholderTextSize = [self.text sizeWithAttributes: @{NSFontAttributeName : self.font}];
    CGRect textFieldPlaceholderRect = [self.textField placeholderRectForBounds: self.textField.frame];
    
    CGPoint textFieldPlaceHolderPosition = CGPointMake(textFieldplaceholderTextSize.width / 2 + textFieldPlaceholderRect.origin.x, textFieldPlaceholderRect.origin.y);
    
    self.textField.placeholder = @"";
    
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath: @"position"];
    position.fromValue = [NSValue valueWithCGPoint: CGPointMake(labelPosition.x, labelPosition.y)];
    position.toValue = [NSValue valueWithCGPoint: CGPointMake(textFieldPlaceHolderPosition.x, self.textField.center.y)];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    CGFloat scaleFactor = textFieldplaceholderTextSize.width / placeholderTextSize.width;
    scale.fromValue = @(1.0);
    scale.toValue = @(scaleFactor);
    
    CAAnimationGroup *animationPositionGroup = [CAAnimationGroup animation];
    animationPositionGroup.animations = @[position, scale];
    animationPositionGroup.duration = self.animationDuration;
    animationPositionGroup.speed = 1.0;
    animationPositionGroup.removedOnCompletion = NO;
    animationPositionGroup.fillMode = kCAFillModeForwards;
    [animationPositionGroup setValue: @"moveInAnimation" forKey: @"animationID"];
    animationPositionGroup.delegate = self;
    
    // Start animation
    [self.layer addAnimation: animationPositionGroup forKey: @"moveInAnimation"];
}

#pragma mark - CABasicAnimationDelegate
-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey: @"animationID"] isEqualToString: @"moveInAnimation"]) {
        self.textColor = UIColor.clearColor;
        [self updateTextFieldPlaceholderTextTo: self.text];
        [self.layer removeAnimationForKey: @"moveInAnimation"];
    }
}

@end
