//
//  UITextViewPlaceholder.m
//  UIPlaceholder
//
//  Created by Basiliusic on 21/11/2017.
//  Copyright © 2017 FunWayInteractiveHQ. All rights reserved.
//

#import "UITextViewPlaceholder.h"

static CGFloat const placeholderWidthOffset = 0.0;

@interface UITextViewPlaceholder()
@property (nonatomic, weak) id<UITextViewDelegate> textViewInitialDelegate;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, strong) UIFont *originalFont;

@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, assign, readonly) CGPoint positionIn;
@property (nonatomic, assign, readonly) CGPoint positionOut;
@end

@implementation UITextViewPlaceholder
#pragma mark - Initialization
-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if(self) {
        
    }
    
    return self;
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

#pragma mark - Getters and setters
-(void) setTextView:(UITextView *)textView {
    _textView = textView;
    self.textViewInitialDelegate = textView.delegate;
    _textView.delegate = self;
    
    // update state
    self.state = self.textView.text.length > 0 ? UIPlaceholderStateOutside : UIPlaceholderStateInside;
    
    // save original position
    self.originalCenter = self.center;
    
    // save original font
    self.originalFont = self.font;
    
    // update position
    if(self.state == UIPlaceholderStateInside) {
        self.center = self.positionIn;
    }
    
}

#pragma mark - Placeholder size
-(CGSize) sizeWithFont: (UIFont *) font {
    return [self.text sizeWithAttributes: @{NSFontAttributeName : font}];
}

-(CGSize) size {
    return [self sizeWithFont: self.font];
}

#pragma mark - UITextViewDelegate
-(BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textViewShouldBeginEditing:)]) {
        return [self.textViewInitialDelegate textViewShouldBeginEditing: textView];
    }
    
    return YES;
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textViewShouldEndEditing:)]) {
        return [self.textViewInitialDelegate textViewShouldEndEditing: textView];
    }
    
    return YES;
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textViewDidBeginEditing:)]) {
        [self.textViewInitialDelegate textViewDidBeginEditing: textView];
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textViewDidEndEditing:)]) {
        [self.textViewInitialDelegate textViewDidEndEditing: textView];
    }
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL returnValue = YES;
    
    if([self.textViewInitialDelegate respondsToSelector: @selector(textView:shouldChangeTextInRange:replacementText:)]) {
        returnValue = [self.textViewInitialDelegate textView: textView shouldChangeTextInRange: range replacementText: text];
    }
    
    // change placeholder position
    if(returnValue) {
        NSString *replacementString = [textView.text stringByReplacingCharactersInRange: range withString: text];
        if(replacementString.length > 0) {
            [self moveOut];
        } else {
            [self moveIn];
        }
    }
    
    return returnValue;
}

-(void) textViewDidChange:(UITextView *)textView {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textViewDidChange:)]) {
        [self.textViewInitialDelegate textViewDidChange: textView];
    }
}

-(void) textViewDidChangeSelection:(UITextView *)textView {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textViewDidChangeSelection:)]) {
        [self.textViewInitialDelegate textViewDidChangeSelection: textView];
    }
}

-(BOOL) textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
        return [self.textViewInitialDelegate textView: textView shouldInteractWithURL: URL inRange: characterRange interaction: interaction];
    }
    
    return YES;
}

-(BOOL) textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if([self.textViewInitialDelegate respondsToSelector: @selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
        return [self.textViewInitialDelegate textView: textView shouldInteractWithTextAttachment: textAttachment inRange: characterRange interaction: interaction];
    }
    
    return YES;
}

#pragma mark - Position
-(CGPoint) positionIn {
    CGPoint positionIn = CGPointZero;
    
    CGFloat textTopEdgeInset = self.textView.textContainerInset.top;
    
    switch (self.textView.textAlignment) {
        case NSTextAlignmentNatural:
        case NSTextAlignmentJustified:
        case NSTextAlignmentLeft: {
            positionIn = CGPointMake(self.textView.frame.origin.x + self.textView.textContainerInset.left + placeholderWidthOffset + [self sizeWithFont: self.textView.font].width / 2, self.textView.frame.origin.y + textTopEdgeInset + self.size.height / 2);
            break;
        }
        case NSTextAlignmentRight: {
            positionIn = CGPointMake(self.textView.frame.origin.x + self.textView.frame.size.width - self.textView.textContainerInset.right - placeholderWidthOffset - [self sizeWithFont: self.textView.font].width / 2, self.textView.frame.origin.y + textTopEdgeInset + self.size.height / 2);
            break;
        }
        case NSTextAlignmentCenter: {
            positionIn = CGPointMake(self.textView.frame.origin.x + self.textView.frame.size.width / 2, self.textView.frame.origin.y + textTopEdgeInset + self.size.height / 2);
            break;
        }
    }
    
    if([self.delegate respondsToSelector: @selector(textViewPlaceholder:centerInWithPlaceholderSize:)]) {
        positionIn = [self.delegate textViewPlaceholder: self centerInWithPlaceholderSize: self.size];
    }
    
    return positionIn;
}

-(CGPoint) positionOut {
    return self.originalCenter;
}

#pragma mark - Move placeholder
-(void) moveIn {
    if(self.state == UIPlaceholderStateOutside) {
        
        // update original position
        self.originalCenter = self.center;
        
        //change state
        self.state = UIPlaceholderStateInside;
        
        // change font
        self.font = self.textView.font;
        
        // change position
        self.center = self.positionIn;
        
        if(!self.animationDisabled) {
            //[self startMoveInAnimationToPosition: self.positionIn];
        }
    }
}

-(void) moveOut {
    if(self.state == UIPlaceholderStateInside) {
        
        // change state
        self.state = UIPlaceholderStateOutside;
        
        // change font
        self.font = self.originalFont;
        
        // change position
        self.center = self.positionOut;

        
        if(!self.animationDisabled) {
            //[self startMoveOutAnimationToPosition: self.positionOut];
        }
    }
}

#pragma mark - Animation
-(void) startMoveOutAnimationToPosition: (CGPoint) toPosition {
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath: @"position"];
    position.fromValue = [NSValue valueWithCGPoint: self.center];
    position.toValue = [NSValue valueWithCGPoint: toPosition];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    CGFloat scaleFactor = [self sizeWithFont: self.originalFont].width / self.size.width;
    scale.fromValue = @(1.0);
    scale.toValue = @(scaleFactor);
    
    CAAnimationGroup *animationPositionGroup = [CAAnimationGroup animation];
    animationPositionGroup.animations = @[position, scale];
    animationPositionGroup.duration = 2.0; //self.animationDuration;
    animationPositionGroup.speed = 1.0;
    animationPositionGroup.removedOnCompletion = NO;
    animationPositionGroup.fillMode = kCAFillModeForwards;
    [animationPositionGroup setValue: @"moveOutAnimation" forKey: @"animationID"];
    animationPositionGroup.delegate = self;
    
    // Start animation
    [self.layer addAnimation: animationPositionGroup forKey: @"moveInAnimation"];
}

-(void) startMoveInAnimationToPosition: (CGPoint) toPosition {
    CABasicAnimation *position = [CABasicAnimation animationWithKeyPath: @"position"];
    position.fromValue = [NSValue valueWithCGPoint: self.center];
    position.toValue = [NSValue valueWithCGPoint: toPosition];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    CGFloat scaleFactor = [self sizeWithFont: self.textView.font].width / self.size.width;
    scale.fromValue = @(1.0);
    scale.toValue = @(scaleFactor);
    
    CAAnimationGroup *animationPositionGroup = [CAAnimationGroup animation];
    animationPositionGroup.animations = @[position, scale];
    animationPositionGroup.duration = 2.0; //self.animationDuration;
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
        //change state
        self.state = UIPlaceholderStateInside;
        
        // change font
        self.font = self.textView.font;
        
        // change position
        self.center = self.positionIn;
        
        [self.layer removeAnimationForKey: @"moveInAnimation"];
    } else if([[anim valueForKey: @"animationID"] isEqualToString: @"moveOutAnimation"]) {
        // change state
        self.state = UIPlaceholderStateOutside;
        
        // change font
        self.font = self.originalFont;
        
        // change position
        self.center = self.positionOut;
        
        [self.layer removeAnimationForKey: @"moveOutAnimation"];
    }
}

@end
