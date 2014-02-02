//
//  DynamicRowHeightTableViewController.m
//  Sociopathy
//
//  Created by Admin on 13.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "DynamicRowHeightTableViewController.h"
#import "DynamicRowHeightTableViewCell.h"

@interface DynamicRowHeightTableViewController ()

@end

@implementation DynamicRowHeightTableViewController
{
    NSMutableDictionary* rowHeightCache;
    
    UITableViewCell<DynamicRowHeightTableViewCell>* sizingCell;
    dispatch_once_t onceToken;
}

- (id) initWithCoder: (NSCoder*) decoder
{
    if (self = [super initWithCoder:decoder])
    {
        rowHeightCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) adjustSizingCellWidthToTableWidth
{
    sizingCell.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0);
}

- (CGFloat) tableView: (UITableView*) tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    dispatch_once(&onceToken, ^
    {
        sizingCell = (UITableViewCell<DynamicRowHeightTableViewCell>*)[self.tableView dequeueReusableCellWithIdentifier:[self cellId]];
        
        [self adjustSizingCellWidthToTableWidth];
    });
    
    id dataSetItem = [self data][indexPath.section];
    id id = [self idForDataSetItem:dataSetItem];
    
    if (rowHeightCache[id] == nil)
    {
        [sizingCell data:dataSetItem];
        
        // force layout
        [sizingCell setNeedsLayout];
        [sizingCell layoutIfNeeded];
        
        CGSize fittingSize = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //NSLog(@"fitting size: %@", NSStringFromCGSize(fittingSize));
        
        rowHeightCache[id] = @(fittingSize.height);
    }
    
    return [rowHeightCache[id] floatValue];
}

- (UITableView*) tableView
{
    return [self valueForKey:@"tableView"];
}

- (NSString*) cellId
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ method in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSArray*) data
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ method in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id) idForDataSetItem: (id) dataSetItem
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ method in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void) purgeCachedRowHeightFor: (id) dataSetItem
{
    [rowHeightCache removeObjectForKey:[self idForDataSetItem:dataSetItem]];
}

- (void) purgeCache
{
    [rowHeightCache removeAllObjects];
}

- (void) recalculateTableViewRowHeights
{
    [rowHeightCache removeAllObjects];
    
    [self adjustSizingCellWidthToTableWidth];
    
    // force table view row height refresh
    [self.tableView reloadData];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self recalculateTableViewRowHeights];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self purgeCache];
}

@end
