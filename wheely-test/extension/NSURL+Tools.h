//
//  NSURL+Tools.h
//  Sociopathy
//
//  Created by Admin on 07.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Tools)
+ (NSURL*) URLWithString: (NSString*) url parameters: (NSDictionary*) parameters;
@end
