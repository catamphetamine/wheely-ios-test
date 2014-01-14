//
//  CALayer+WheelyTestStyle.m
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "UIView+SectionStyle.h"

@implementation UIView (SectionStyle)

- (void) stylize
{
    [self.layer setCornerRadius:6];
    [self.layer setBorderColor:[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1].CGColor];
    [self.layer setBorderWidth:1];
    [self setClipsToBounds:YES];
}

@end
