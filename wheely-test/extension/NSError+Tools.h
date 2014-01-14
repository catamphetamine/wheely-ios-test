//
//  NSError+Tools.h
//  Sociopathy
//
//  Created by Admin on 04.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Tools)
+ (NSError*) error: (NSString*) text
              code: (int) code
            domain: (NSString*) domain;
+ (NSError*) error: (NSString*) text
              code: (int) code;
@end
