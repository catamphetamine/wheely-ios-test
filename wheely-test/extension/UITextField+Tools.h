//
//  UITextField+EditableTextFocus.h
//  Sociopathy
//
//  Created by Admin on 01.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Tools)
- (void) hideInputOnFocusLoss: (UITouch*) touch;
- (void) padding: (int) padding;
- (void) setPlaceholderColor: (UIColor*) color;
@end
