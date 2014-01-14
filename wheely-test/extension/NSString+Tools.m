//
//  NSString+Tools.m
//  Sociopathy
//
//  Created by Admin on 04.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
- (NSString*) trim
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:whitespace];
}
@end
