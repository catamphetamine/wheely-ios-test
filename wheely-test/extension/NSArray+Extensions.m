//
//  NSArray+Extensions.m
//  wheely-test
//
//  Created by Admin on 15.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (NSArray*) mapObjectsUsingBlock: (id (^)(id obj, NSUInteger idx)) block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        [result addObject:block(obj, idx)];
    }];
    
    return result;
}

@end
