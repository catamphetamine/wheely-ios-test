//
//  UITextField+EditableTextFocus.m
//  Sociopathy
//
//  Created by Admin on 01.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "UITextField+Tools.h"

#import <QuartzCore/QuartzCore.h>

@implementation UITextField (EditableTextFocus)
- (void) hideInputOnFocusLoss: (UITouch*) touch
{
    if ([self isFirstResponder] && [touch view] != self)
    {
        [self resignFirstResponder];
    }
}

- (void) padding: (int) padding
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, 20)];
    
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    //self.rightView = paddingView;
    //self.rightViewMode = UITextFieldViewModeAlways;
}

- (void) setPlaceholderColor: (UIColor*) color
{
    if ([self.attributedPlaceholder length])
    {
        // Extract attributes
        NSDictionary* attributes = (NSMutableDictionary*) [(NSAttributedString*) self.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
        
        NSMutableDictionary* newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        
        [newAttributes setObject:color forKey:NSForegroundColorAttributeName];
        
        // Set new text with extracted attributes
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.attributedPlaceholder string] attributes:newAttributes];
        
    }
}
@end
