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

static CGFloat cellSpacing = 10;

static NSURL* url;
static int refreshInterval = 5; // in seconds

@implementation MasterViewController
{
    __weak IBOutlet UIActivityIndicatorView* loadingIndicator;
    __weak IBOutlet UITableView* tableView;
    
    __weak AppDelegate* appDelegate;
    
    NSTimer* refreshTimer;
    
    ServerCommunication* serverCommunication;
    
    NSMutableArray* notes;
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

- (void) awakeFromNib
{
    [super awakeFromNib];
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
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self insetOnTopAndBottom:tableView];
    });
}

- (void) startRefreshTimer
{
    if (!refreshTimer)
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                        target:self
                                                      selector:@selector(fetchNotes)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void) stopRefreshTimer
{
    [refreshTimer invalidate];
    refreshTimer = nil;
}

- (CGFloat) tableView: (UITableView*) tableView heightForHeaderInSection: (NSInteger) section
{
    return cellSpacing;
}

- (CGFloat) tableView: (UITableView*) tableView heightForFooterInSection: (NSInteger) section
{
    if (section == notes.count - 1)
        return cellSpacing;
    
    return 0;
}

- (UIView*) tableView: (UITableView*) tableView viewForHeaderInSection: (NSInteger) section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (UIView*) tableView: (UITableView*) tableView viewForFooterInSection: (NSInteger) section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (void) communicationFailed: (NSError*) error
                     message: (NSString*) errorMessage
{
    [loadingIndicator stopAnimating];
    
    [self showError:errorMessage];
}

- (void) fetchNotes
{
    if (!serverCommunication)
        serverCommunication = [[ServerCommunication alloc] initWithSessionSource:appDelegate url:url delegate:self];
    
    [serverCommunication communicate];
}

- (void) serverResponds: (NSDictionary*) data
{
    notes = [NSMutableArray new];
    
    for (NSDictionary* noteData in data)
    {
        Note* note = [[Note alloc] initWithJSON:noteData];
        [notes addObject:note];
    }
    
    [notes sortUsingComparator:^NSComparisonResult(Note* first, Note* second)
    {
        return [first.id compare:second.id];
    }];

    [tableView reloadData];
    
    //if current view = detail view
    //    refresh note text
    
    // if first time
    tableView.hidden = NO;
    [loadingIndicator stopAnimating];
}

- (void) showError: (NSString*) message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:message delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Error. Dismiss", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/

#pragma mark - Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return notes.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void) prepareForSegue: (UIStoryboardSegue*) segue
                  sender: (id) sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        Note* note = notes[indexPath.section];
        
        DetailViewController* detail = [segue destinationViewController];
        detail.note = note;
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:nil
                                                                      action:nil];
        
        [self.navigationItem setBackBarButtonItem:backButton];
    }
}

@end
