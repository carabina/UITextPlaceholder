//
//  UITextViewPlaceholder.h
//  UIPlaceholder
//
//  Created by Basiliusic on 21/11/2017.
//  Copyright © 2017 FunWayInteractiveHQ. All rights reserved.
//

#import "UITextPlaceholder.h"

@protocol UITextViewPlaceholderDelegate;

@interface UITextViewPlaceholder : UITextPlaceholder <UITextViewDelegate, CAAnimationDelegate>
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, weak) IBOutlet id<UITextViewPlaceholderDelegate> delegate;
@end

@protocol UITextViewPlaceholderDelegate <NSObject>
@optional
-(CGPoint) textViewPlaceholder: (UITextViewPlaceholder *) textViewPlaceholder centerInWithPlaceholderSize: (CGSize) placeholderSize;
@end
