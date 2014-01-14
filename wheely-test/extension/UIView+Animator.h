//
//  UIView+Animator.h
//  Sociopathy
//
//  Created by Admin on 05.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//



@interface UIView (Animator)
- (void) fadeIn: (float) duration;
- (void) fadeIn: (float) duration
     completion: (void (^)(void)) completion;
- (void) fadeOut: (float) duration;
- (void) fadeOut: (float) duration
      completion: (void (^)(void)) completion;
- (BOOL) isVisible;
@end
