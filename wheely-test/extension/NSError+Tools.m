//
//  NSError+Tools.m
//  Sociopathy
//
//  Created by Admin on 04.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "NSError+Tools.h"

@implementation NSError (Tools)
+ (NSError*) error: (NSString*) text
              code: (int) code
            domain: (NSString*) domain
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:text forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:domain code:code userInfo:details];
}

+ (NSError*) error: (NSString*) text
              code: (int) code
{
    return [NSError error:text code:code domain:@"world"];
}
@end
