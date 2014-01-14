//
//  UIButton+Animator.m
//  Sociopathy
//
//  Created by Admin on 05.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "UIButton+Animator.h"
#import "UIView+Animator.h"

@implementation UIButton (Animator)

- (void) fadeIn: (float) duration
     completion: (void (^)(void)) completion
{
    self.userInteractionEnabled = YES;
    [super fadeIn:duration completion:completion];
}

- (void) fadeOut: (float) duration
      completion: (void (^)(void)) completion
{
    self.userInteractionEnabled = NO;
    [super fadeOut:duration completion:completion];
}
@end
