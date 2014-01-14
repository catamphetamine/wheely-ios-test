//
//  UIVIew+Animator.m
//  Sociopathy
//
//  Created by Admin on 05.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "UIView+Animator.h"

@implementation UIView (Animator)

- (void) fadeIn: (float) duration
{
    [self fadeIn:duration completion:nil];
}

- (void) fadeIn: (float) duration
     completion: (void (^)(void)) completion
{
    //NSLog(@"fade in %@. completion = %@", self, completion);
    
    if (self.alpha == 1.0)
        return;
    
    [self.layer removeAllAnimations];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:duration
                     animations:^{ self.alpha = 1.0; }
                     completion:^(BOOL finished)
    {
        if (!finished)
            return;
        
        //NSLog(@"faded in %@. completion = %@", self, completion);
        
        if (completion)
            completion();
    }];
}

- (void) fadeOut: (float) duration
{
    [self fadeOut:duration completion:nil];
}

- (void) fadeOut: (float) duration
      completion: (void (^)(void)) completion
{
    //NSLog(@"fade out %@. completion = %@", self, completion);
    
    if (self.alpha == 0.0)
        return;
    
    [self.layer removeAllAnimations];
    
    [UIView animateWithDuration:duration
                     animations:^{ self.alpha = 0; }
                     completion:^(BOOL finished)
    {
        if (!finished)
            return;
         
        self.hidden = YES;
        
        //NSLog(@"faded out %@. completion = %@", self, completion);
        
        if (completion)
            completion();
    }];
}

- (BOOL) isVisible
{
    if (self.hidden)
        return NO;
    
    return self.alpha > 0;
}
@end
