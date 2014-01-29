//
//  MasterViewController.m
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Note.h"
#import "NoteCell.h"
#import "UIViewController+TopBarAndBottomBarSpacing.h"
#import "AppDelegate.h"
#import "NSArray+Extensions.h"

static const CGFloat cellSpacing = 10;

static NSURL* url;
static const int refreshInterval = 3; // in seconds

@implementation MasterViewController
{
    __weak IBOutlet UIActivityIndicatorView* loadingIndicator;
    __weak IBOutlet UITableView* tableView;
    
    __weak AppDelegate* appDelegate;
    
    NSTimer* refreshTimer;
    
    ServerCommunication* serverCommunication;
    
    NSMutableArray* notes;
    
    __weak DetailViewController* detailViewController;
}

+ (void) initialize
{
    url = [NSURL URLWithString:@"http://crazy-dev.wheely.com/"];
}

- (id) initWithCoder: (NSCoder*) decoder
{
    if (self = [super initWithCoder:decoder])
    {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        appDelegate.masterViewController = self;
    }
    return self;
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchNotes)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // a fix for the 'Cell animation stop fraction must be greater than start fraction' crash
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, cellSpacing)];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        // fix table view insets for iOS 7
        [self insetOnTopAndBottom:tableView];
        
        [self centerLoadingIndicatorVertically];
    });
}

- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval) duration
{
    [self centerLoadingIndicatorVertically];
}

// take the insets into account when centering vertically on iOS 7
- (void) centerLoadingIndicatorVertically
{
    for (NSLayoutConstraint* constraint in self.view.constraints)
    {
        if (constraint.secondItem == loadingIndicator)
        {
            if (constraint.secondAttribute == NSLayoutAttributeCenterY)
            {
                CGFloat insets = self.topLayoutGuide.length + self.bottomLayoutGuide.length;
                constraint.constant = -(int) (insets / 2);
                
                [self.view setNeedsUpdateConstraints];
                [self.view layoutSubviews];
                
                break;
            }
        }
    }
}

- (void) startRefreshTimer
{
    if (!refreshTimer)
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                        target:self
                                                      selector:@selector(refreshTimerFired)
                                                      userInfo:nil
                                                       repeats:NO];
}

- (void) stopRefreshTimer
{
    if (!refreshTimer)
        return;
    
    [refreshTimer invalidate];
    refreshTimer = nil;
}

- (void) refreshTimerFired
{
    refreshTimer = nil;
    [self fetchNotes];
}

- (void) fetchNotes
{
    if (!serverCommunication)
        serverCommunication = [[ServerCommunication alloc] initWithSessionSource:appDelegate url:url delegate:self];
    
    [serverCommunication communicate];
}

- (void) communicationFailed: (NSError*) error
                     message: (NSString*) errorMessage
{
    [loadingIndicator stopAnimating];
    
    [self showError:errorMessage];
    
    [self startRefreshTimer];
}

- (void) serverResponds: (NSDictionary*) data
{
    NSMutableArray* newNotes = [NSMutableArray new];
    
    for (NSDictionary* noteData in data)
    {
        Note* note = [[Note alloc] initWithJSON:noteData];
        
        // for testing
        //note.text = [note.text stringByAppendingString:[[NSDate new] description]];
        
        [newNotes addObject:note];
    }
    
    [self sortNotes:newNotes];
    
    // if first time
    if (notes.count == 0)
    {
        notes = newNotes;
        [self refreshTable];
        
        tableView.hidden = NO;
        [loadingIndicator stopAnimating];
    }
    else
    {
        [self applyChanges:newNotes];
    }
    
    [self updateDetail];
    
    [self startRefreshTimer];
}

- (void) applyChanges: (NSArray*) newNotes
{
    NSMutableArray* previousNotes = notes;
    
    NSSet* previousNotesSet = [NSSet setWithArray:previousNotes];
    NSSet* newNotesSet = [NSSet setWithArray:newNotes];
    
    NSMutableSet* addedNotesSet = [NSMutableSet setWithArray:newNotes];
    [addedNotesSet minusSet:previousNotesSet];
    NSArray* addedNotes = [addedNotesSet allObjects];
    
    NSMutableSet* removedNotesSet = [NSMutableSet setWithArray:previousNotes];
    [removedNotesSet minusSet:newNotesSet];
    NSArray* removedNotes = [removedNotesSet allObjects];
    
    NSMutableSet* retainedNotesSet = [NSMutableSet setWithArray:previousNotes];
    [retainedNotesSet intersectSet:newNotesSet];
    NSArray* retainedNotes = [retainedNotesSet allObjects];
    
    // sorting added notes is needed to prevent 'index beyond bounds' exception
    addedNotes = [self sortNotes:addedNotes];
    //removedNotes = [self sortNotes:removedNotes];
    //retainedNotes = [self sortNotes:retainedNotes];
    
    /*
    NSMutableArray* removedNotes = [previousNotes mutableCopy];
    NSMutableArray* addedNotes = [newNotes mutableCopy];
    
    NSMutableArray* retainedNotes = [NSMutableArray new];

    for (Note* note in previousNotes)
    {
        if ([newNotes containsObject:note])
        {
            [addedNotes removeObject:note];
            [removedNotes removeObject:note];
            
            [retainedNotes addObject:note];
        }
    }
    */
    
    NSLog(@"previous notes %@", previousNotes);
    NSLog(@"new notes %@", newNotes);
    
    // remove absent notes
    for (Note* note in removedNotes)
    {
        int index = [previousNotes indexOfObject:note];
        
        // fix the 'request for rect of header in invalid section (-1)' bug
        // (bug report # 15824130)
        [tableView beginUpdates];
        
        NSLog(@"remove note at %d", index);
        
        [previousNotes removeObjectAtIndex:index];
        
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView endUpdates];
    }
    
    // prevent the "attempt to delete and reload the same index path" exception
    
    [tableView beginUpdates];
    
    // insert new notes
    for (Note* note in addedNotes)
    {
        int index = [newNotes indexOfObject:note];
        
        NSLog(@"insert note at %d", index);
        
        [previousNotes insertObject:note atIndex:index];
        
        [tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    // prevent 'attempt to delete section X, but there are only Y sections before the update'
    [tableView endUpdates];
    
    [tableView beginUpdates];
    
    // update retained notes if their text changed
    for (Note* oldNote in retainedNotes)
    {
        int index = [newNotes indexOfObject:oldNote];
        
        Note* newNote = newNotes[index];
        
        if ([newNote.text isEqualToString:oldNote.text])
            continue;
        
        NSLog(@"reload note at %d", index);
        
        previousNotes[index] = newNote;
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    NSLog(@"finished updates with %@", notes);
    
    [tableView endUpdates];
}

- (NSMutableArray*) sortNotes: (NSArray*) notes
{
    NSMutableArray* mutableNotes;
    
    if ([notes isKindOfClass:NSMutableArray.class])
        mutableNotes = (NSMutableArray*) notes;
    else
        mutableNotes = [notes mutableCopy];
    
    [mutableNotes sortUsingComparator:^NSComparisonResult(Note* first, Note* second)
    {
        return [first.id compare:second.id];
    }];
    
    return mutableNotes;
}

- (void) updateDetail
{
    if (!detailViewController)
        return;

    NSUInteger index = [notes indexOfObject:detailViewController.note];
    
    if (index != NSNotFound)
    {
        [detailViewController updateNote:notes[index]];
    }
    else
    {
        // let it stay shown
    }
}

- (void) showError: (NSString*) message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:message delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Error. Dismiss", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Table View

- (void) refreshTable
{
    [tableView reloadData];
}

- (CGFloat) tableView: (UITableView*) tableView heightForHeaderInSection: (NSInteger) section
{
    return cellSpacing;
}

/*
 // Crash: 'Cell animation stop fraction must be greater than start fraction'
 - (CGFloat) tableView: (UITableView*) tableView heightForFooterInSection: (NSInteger) section
 {
 if (section == notes.count - 1)
 return cellSpacing;
 
 return 0;
 }
 */

- (UIView*) tableView: (UITableView*) tableView viewForHeaderInSection: (NSInteger) section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView*) tableView
{
    return notes.count;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection: (NSInteger) section
{
    return 1;
}

- (CGFloat) tableView: (UITableView*) tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    static NoteCell* sizingCell;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        sizingCell = (NoteCell*)[tableView dequeueReusableCellWithIdentifier:@"NoteCell"];
    });
    
    [sizingCell note:notes[indexPath.section]];
    
    // force layout
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    // get the fitting size
    CGSize fittingSize = [sizingCell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    //NSLog( @"fittingSize: %@", NSStringFromCGSize(fittingSize));
    
    return fittingSize.height;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];

    Note* note = notes[indexPath.section];
    
    [cell note:note];
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void) prepareForSegue: (UIStoryboardSegue*) segue
                  sender: (id) sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        Note* note = notes[indexPath.section];
        
        detailViewController = [segue destinationViewController];
        detailViewController.note = note;
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:nil
                                                                      action:nil];
        
        [self.navigationItem setBackBarButtonItem:backButton];
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
