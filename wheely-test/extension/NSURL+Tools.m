//
//  NSURL+Tools.m
//  Sociopathy
//
//  Created by Admin on 07.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "NSURL+Tools.h"
#import "NSDictionary+HttpTools.h"

@implementation NSURL (Tools)
+ (NSURL*) URLWithString: (NSString*) url parameters: (NSDictionary*) parameters
{
    return [NSURL URLWithString:[[url stringByAppendingString:@"?"] stringByAppendingString:[parameters httpParameters]]];
}
@end
