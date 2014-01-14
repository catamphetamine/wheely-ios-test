//
//  NSDictionary+HttpTools.m
//  Sociopathy
//
//  Created by Admin on 04.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "NSDictionary+HttpTools.h"

@implementation NSDictionary (HttpTools)
- (NSString*) httpParameters
{
    NSMutableString* parameters = [NSMutableString new];
    
    for (NSString* key in self)
    {
        id value = [self objectForKey:key];
        
        if ([parameters length] > 0)
        {
            [parameters appendString:@"&"];
        }
        
        [parameters appendString:[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [parameters appendString:@"="];
        [parameters appendString:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [parameters copy];
}

- (NSData*) postParameters
{
    return [[self httpParameters] dataUsingEncoding:NSUTF8StringEncoding];
}
@end
