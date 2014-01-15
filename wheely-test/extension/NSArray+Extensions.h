//
//  NSArray+Extensions.h
//  wheely-test
//
//  Created by Admin on 15.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extensions)

- (NSArray*) mapObjectsUsingBlock: (id (^)(id obj, NSUInteger idx)) block;

@end
