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
        self.id = @([data[@"id"] integerValue]);
        self.title = data[@"title"];
        self.text = data[@"text"];
    }
    return self;
}

- (BOOL) isEqual: (id) object
{
    if (![object isKindOfClass:Note.class])
        return false;
    
    Note* note = (Note*) object;
    
    return [self.id isEqualToNumber:note.id];
}

- (NSUInteger) hash
{
    return [self.id intValue];
}

- (NSString*) description
{
    return [[[self.id stringValue] stringByAppendingString:@". "] stringByAppendingString:self.title];
}

@end
