//
//  NoteCell.m
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "NoteCell.h"

static CGFloat sideMargin = 10;

@implementation NoteCell
{
    __weak IBOutlet UILabel* title;
    __weak IBOutlet UILabel* noteText;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (void) setFrame: (CGRect) frame
{
    frame.origin.x += sideMargin;
    frame.size.width -= 2 * sideMargin;
    [super setFrame:frame];
}

- (void) data: (id) data
{
    return [self note: (Note*) data];
}

- (void) note: (Note*) note
{
    title.text = note.title;
    noteText.text = note.text;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
@end
