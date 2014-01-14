//
//  NSDictionary+HttpTools.h
//  Sociopathy
//
//  Created by Admin on 04.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HttpTools)
- (NSString*) httpParameters;
- (NSData*) postParameters;
@end
