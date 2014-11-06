//
//  ViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/2/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "ListAllChallengesViewController.h"
#import "Challenge.h"
#import <Parse/Parse.h>
#import "DareOpponentViewController.h"

@interface ListAllChallengesViewController ()

@end

@implementation ListAllChallengesViewController {
  NSMutableArray *availableChallenges;
  PFUser *currentUser;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  currentUser = [PFUser currentUser];

  [self getChallengesFromBackend];
//  [[self tableView] reloadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getChallengesFromBackend)
                  forControlEvents:UIControlEventValueChanged];
    
  self.title = @"All Challenges";
}

-(void)viewWillAppear:(BOOL)animated{
    
      [[self tableView] reloadData];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)getChallengesFromBackend {
  PFQuery *query = [Challenge query];
  [query whereKey:@"ownerId" notEqualTo:currentUser.objectId];
  [query whereKeyDoesNotExist:@"challengerName"];

  __weak id weakSelf = self;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

      if (!error) {
        availableChallenges = [[NSMutableArray alloc] initWithArray:objects];
        [[weakSelf tableView] reloadData];
      }
      
      if (self.refreshControl) {
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"MMM d, h:mm a"];
          NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
          NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                      forKey:NSForegroundColorAttributeName];
          NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
          self.refreshControl.attributedTitle = attributedTitle;
          [self.refreshControl endRefreshing];
      }
  }];
}

- (NSInteger)tableView:(UITableView *)tableView    numberOfRowsInSection:(NSInteger)section {
  return availableChallenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"cellForAllChallenges";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }

  Challenge *chal = [availableChallenges objectAtIndex:indexPath.row];
//  cell.textLabel.text = chal.ownerName;
    UILabel *raceType = (UILabel *)[cell viewWithTag:1];
    [raceType setText:[NSString stringWithFormat:@"%@ Race", [chal.type capitalizedString]]];
    UILabel *raceAuthor = (UILabel *)[cell viewWithTag:2];
    [raceAuthor setText:chal.ownerName];
    UILabel *raceLocation = (UILabel *)[cell viewWithTag:3];
    [raceLocation setText:chal.location];

  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  if ([segue.identifier isEqualToString:@"dareOpponentSegue"]) {
    DareOpponentViewController *destination = [segue destinationViewController];
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];

    [destination setSelectedChallenge:[availableChallenges objectAtIndex:ip.row]];
      [destination setRetrievedChallenges:availableChallenges];
  }
}


#pragma mark Customizing table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (availableChallenges) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available.\n Please, pull down to refresh or check your Internet connection.";
        messageLabel.textColor = [UIColor blackColor];
//        messageLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.1 alpha:0.8];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 1;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

@end



