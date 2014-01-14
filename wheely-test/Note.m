//
//  Note.m
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "Note.h"

@implementation Note

- (id) initWithJSON: (NSDictionary*) data
{
    if (self = [super init])
    {
        self.id = data[@"id"];
        self.title = data[@"title"];
        self.text = data[@"text"];
    }
    return self;
}

@end
