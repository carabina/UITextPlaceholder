//
//  UITextFieldPlaceholder.h
//  UIPlaceholder
//
//  Created by Basiliusic on 13/11/2017.
//  Copyright © 2017 FunWayInteractiveHQ. All rights reserved.
//

#import "UITextPlaceholder.h"

@interface UITextFieldPlaceholder : UITextPlaceholder <UITextFieldDelegate, CAAnimationDelegate>
@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, assign) IBInspectable BOOL useTextFieldPlaceholderColor;

@property (nonatomic, strong) UIColor *color;
@end
