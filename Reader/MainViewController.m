//
//  MainViewController.m
//  Events
//
//  Created by Brian Huynh
//  Copyright (c) 2014 Brian Huynh. All rights reserved.

#import "MainViewController.h"
#import "WebViewController.h"
#import <MessageUI/MessageUI.h>
#import "GoogleMapsViewController.h"


@interface MainViewController ()

@end

@implementation NSString (mycategory)

- (NSString *)stringByStrippingHTML 
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s; 
}

@end

@implementation MainViewController
@synthesize parseResults = _parseResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSUInteger) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Sets status bar to black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Initializing and inserting the logo into the header
    UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoBlue"]];
    self.navigationItem.titleView = logo;
     
    // Setting the color of the navigation bar
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Creates a button on the navigation bar that will direct users to the campus map
    UIBarButtonItem *campusMap = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(loadCampusMap)];
    // Setting the color of the button to dark blue
     campusMap.tintColor = [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
    // Place the bar button item on the right corner of the navigation bar
    self.navigationItem.rightBarButtonItem = campusMap;
    
    self.navigationController.navigationBar.tintColor =  [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName]];
    
    //Set table row height so it can fit title & 2 lines of summary
    self.tableView.rowHeight = 80;
    
    // Pull to refresh feature
    UIRefreshControl * refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [NSAttributedString alloc];
    // Once initiated, it calls a function to re-download the data
    [refresh addTarget:self action:@selector(reloadFeed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    // Just adding some style
    [refresh setTintColor: [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0]];
    
    // Some code to check if the device has access in an internet connection
    NSURL *scriptUrl = [NSURL URLWithString:@"http://apple.com"];
    
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    
    if (!data) {
        [self noInternet];
    }
    
    //Parse feed
    KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://25livepub.collegenet.com/calendars/csumb-master-calendar.rss" delegate:self];
    _parseResults = [parser posts];
   
    // [self numberOfEventsToday];
    
    /*
   
    // Ideas for the future
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionSheet)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.tableView addGestureRecognizer:doubleTap];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.1; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    */
    
    [self stripHTMLFromSummary];
    
}


- (void)stopRefresh {
    
    [self.refreshControl endRefreshing];
}

// User receives an alert if the device can not reach the intenret
- (void) noInternet {
    UIAlertView * internet = [[UIAlertView alloc] initWithTitle:@"" message:@"Internet Access Not Detected. Cannot retrieve Events." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [internet show];
}

// Double Tap to display new menu (Future)
/*
-(void)showActionSheet {
    
UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Menu:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Find Me", nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
*/

// If the user runs into issues with the app, the app will display the Mail compose window where
// the user could contact the developer and air any comments or concerns
-(void) emailButtonTouched {

MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
mail.mailComposeDelegate = self;
[mail setToRecipients:[NSArray arrayWithObject:@"brianh.idea@gmail.com"]];
[mail setSubject:@"Suggestions/Problems"];
[mail setMessageBody:@"" isHTML:NO];
[self presentViewController:mail animated:YES completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Message Sent!");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload
{
    [NSNotificationCenter defaultCenter];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)stripHTMLFromSummary {
    
    int i = 0;
   
    //cycles through each 'summary' element stripping HTML
    while (i < self.parseResults.count) {

       NSString * tempString = [[self.parseResults objectAtIndex:i] objectForKey:@"summary"];
        NSString *strippedString = [tempString stringByStrippingHTML];
        NSMutableDictionary *dict = [self.parseResults objectAtIndex:i];
        [dict setObject:strippedString forKey:@"summary"];
        [self.parseResults replaceObjectAtIndex:i withObject:dict];
        i++;
    }
    
}

- (void)reloadFeed {
    
        // Restarts the XML Parser
        KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://25livepub.collegenet.com/calendars/csumb-master-calendar.rss" delegate:self];
        _parseResults = [parser posts];
        [self stripHTMLFromSummary];
        [self.tableView reloadData];
        [self stopRefresh];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns the number of rows the table view needs to draw
    return self.parseResults.count;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // If the user selects the second button in the prompt, the mail compose window will appear
    if (buttonIndex == 1) {

        [self emailButtonTouched];
    }
    
}

// Future idea: Counts the number of events happening today and presents a local notification badge number
// to subtly allow the users to know the amount of events happening without having to open the app
-(NSInteger)numberOfEventsToday {
    
    NSInteger todaysEvent  = 0;
   
    for (NSUInteger i = 0; i < _parseResults.count; i++)
    {
        // Gets the posting date of the event
        NSString * eventDate = [[self.parseResults objectAtIndex:i]objectForKey:@"date"];
        eventDate = [eventDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        eventDate = [eventDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // Setting up date formatter
        NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
        [df setLocale:enUS];
        df.timeZone = [NSTimeZone systemTimeZone];
        
        
        NSDate *date = [df dateFromString:eventDate];
        
        NSDateComponents *event = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
        
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit fromDate:[NSDate date]];
        
        // Searches through the array and counts the number of events happening on the same day
        if([today day] == [event day] && [today month] == [event month] && [today year] == [event year] && [today era] == [event era])
        {
            todaysEvent++;
        }
        // If the event occurs on another day, it displays a badge number and exits the function
        else
        {
            UILocalNotification *local = [[UILocalNotification alloc]init];
            local.applicationIconBadgeNumber = todaysEvent;
            [[UIApplication sharedApplication]scheduleLocalNotification:local];
            return todaysEvent;
        }
    }
            return 0;
}

// Google Maps
-(void)loadCampusMap
{
    GoogleMapsViewController * map = [[GoogleMapsViewController alloc]init];
    [self.navigationController pushViewController:map animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //Check if cell is nil. If it is create a new instance of it
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.textColor =  [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
        // Inserting data and setting up the table view cell
        cell.textLabel.text = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.detailTextLabel.text = @"";
    
    // Checking the date of the event
    NSString *yourString = [NSString stringWithFormat:@"%@", [[self.parseResults objectAtIndex:indexPath.row]objectForKey:@"date"]];
    yourString = [yourString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    yourString = [yourString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
   
    [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    [df setLocale:enUS];
    df.timeZone = [NSTimeZone systemTimeZone];
    
    NSDate *date = [df dateFromString:yourString];

    NSDateComponents *event = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    // If the current time is 2 hours past the event time, the event is done
    // Displays 'Tonight' in lower part of the table view cell
    if([today day] == [event day] && [today month] == [event month] && [today year] == [event year] && [today era] == [event era] && [today hour] >= [event hour] + 2){
        
        cell.detailTextLabel.text = @"Done";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:5.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
    }
    
    // If the event time is past 5pm, then the event is considered 'Tonight'
    // Displays 'Tonight' in lower part of the table view cell
    else if([today day] == [event day] && [today month] == [event month] && [today year] == [event year] && [today era] == [event era] && [event hour] >= 17 ) {
        
        cell.detailTextLabel.text = @"Tonight!";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:5.0];
        //cell.detailTextLabel.font = [UIFont fontWithName:@"Chams-Bold" size:10];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor colorWithRed:212/255.0 green:175/255.0 blue:55/255.0 alpha:1.0];
    }
    // If the day of the event is happening on the current day,
    // it displays 'Today' in lower part of the table view cell
    else if([today day] == [event day] && [today month] == [event month] && [today year] == [event year] && [today era] == [event era]) {
        
        cell.detailTextLabel.text = @"Today!";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:5.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor colorWithRed:212/255.0 green:175/255.0 blue:55/255.0 alpha:1.0];
    }
     
    return cell;
    
}

#pragma mark - Table view delegate

// Once a row in a table view is selected push the title and link to the Web View
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *url = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"link"];
    NSString *title = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"title"];
    
        WebViewController *vc = [[WebViewController alloc] initWithURL:url title:title];
        [self.navigationController pushViewController:vc animated:YES];
    
}

// Idea: For RSS feeds that include images, this allows users to hold and view
// the article's image before the user commits to reading the article
/*
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];

  //  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Image View PoC from RSS
    
    
    NSString * imageUrl =  [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"image"];
    UIImageView *imageView = [[UIImageView alloc]init];
     imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
    
 //   UIImage * image = [[UIImage alloc] init];
    
 //    CGFloat width = image.size.width;
 //    CGFloat height = image.size.height;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Time"]];
    imageView.userInteractionEnabled = YES;
    imageView.tag = 1;
    
    
    
    if (width > height) {
        CGAffineTransform rotate = CGAffineTransformMakeRotation( 1.0 / 90.0 * 3.14 );
        [imageView setTransform:rotate];
    }
     
    
   UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
         NSLog(@"long press on table view at row %ld", (long)indexPath.row);
        
        [imageView setFrame:keyWindow.bounds];
        [keyWindow addSubview:imageView];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Done");
        //[imageView release];
        [[keyWindow viewWithTag:1] removeFromSuperview];
         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
}
*/

#pragma mark - KMXMLParser Delegate
// If the parser fails, a prompt is displaed allowing the user to take action
- (void)parserDidFailWithError:(NSError *)error {
    
         UIAlertView *noEvents = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events Found." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Contact", nil];
         [noEvents show];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)parserCompletedSuccessfully {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)parserDidBegin {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
