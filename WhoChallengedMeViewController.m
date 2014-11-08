//
//  WhoChallengedMeViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "WhoChallengedMeViewController.h"
#import "Challenge.h"
#import <Parse/Parse.h>
#import "Reachability.h"

@interface WhoChallengedMeViewController ()

@end

@implementation WhoChallengedMeViewController {
  NSMutableArray *_challengesToUser;
  PFUser *_currentUser;
  Reachability *networkReachability;
  NetworkStatus networkStatus;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _currentUser = [PFUser currentUser];
  networkReachability = [Reachability reachabilityForInternetConnection];
  [self initializeRefreshNotification];
  [self getChallengesFromBackend];
  self.title = @"Who Challenged Me?";

  //    _downSwipeRecognizer =
  //    [[UITapGestureRecognizer alloc] initWithTarget:self
  //    action:@selector(swipe:)];
  //    _downSwipeRecognizer.numberOfTapsRequired = 2;
  //    [[UISwipeGestureRecognizer alloc] initWithTarget:self
  //                                              action:@selector(swipe:)];
  //    _downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;

  //    [self.tableView addGestureRecognizer:_downSwipeRecognizer];
}

//- (IBAction)swipe:(UISwipeGestureRecognizer *)recognizer {
//
//  if (self.refreshControl) {
//    return;
//  }
//  [self initializeRefreshNotification];
//    [self.view removeGestureRecognizer:_downSwipeRecognizer];
//    _downSwipeRecognizer = nil;
//}
- (void)viewDidAppear:(BOOL)animated {
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)getChallengesFromBackend {
  if ([self checkInternetConnection]) {
    PFQuery *query = [Challenge query];
    [query whereKey:@"ownerId" equalTo:_currentUser.objectId];
    [query whereKeyExists:@"challengerName"];
    __weak id weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                              NSError *error) {
        if (!error) {
          _challengesToUser = [[NSMutableArray alloc] initWithArray:objects];
          [[weakSelf tableView] reloadData];
        }
        [self messageIfNoDataRetrieved];

        if (self.refreshControl) {
          [self setRefreshingMessage];
          [self.refreshControl endRefreshing];
        }
    }];
  }
}

- (BOOL)checkInternetConnection {
  networkStatus = [networkReachability currentReachabilityStatus];
  if (networkStatus == NotReachable) {
    [self showAlert:@"Data cannot be reached!"
         andMessage:@"Please, check your Internet connection!"];
    if (self.refreshControl) {
      [self setRefreshingMessage];
      [self.refreshControl endRefreshing];
    }
    NSLog(@"There IS NO internet connection");
    return NO;
  }

  return YES;
}

- (void)setRefreshingMessage {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM d, h:mm a"];
  NSString *title =
      [NSString stringWithFormat:@"Last update: %@",
                                 [formatter stringFromDate:[NSDate date]]];
  NSDictionary *attrsDictionary =
      [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                  forKey:NSForegroundColorAttributeName];
  NSAttributedString *attributedTitle =
      [[NSAttributedString alloc] initWithString:title
                                      attributes:attrsDictionary];
  self.refreshControl.attributedTitle = attributedTitle;
}

- (void)initializeRefreshNotification {
  if (!self.refreshControl) {
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];

    [refresh addTarget:self
                  action:@selector(getChallengesFromBackend)
        forControlEvents:UIControlEventValueChanged];
    refresh.backgroundColor = [UIColor purpleColor];
    refresh.tintColor = [UIColor whiteColor];
    self.refreshControl = refresh;
    [self setRefreshingMessage];
  }
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return _challengesToUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"cellForChallengesToUser";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }

  Challenge *chal = [_challengesToUser objectAtIndex:indexPath.row];
  UILabel *raceType = (UILabel *)[cell viewWithTag:1];
  UILabel *opponent = (UILabel *)[cell viewWithTag:2];
  UILabel *opponentEmail = (UILabel *)[cell viewWithTag:3];
  UILabel *car = (UILabel *)[cell viewWithTag:4];
  UILabel *raceLocation = (UILabel *)[cell viewWithTag:5];

  [raceType setText:chal.type];
  [opponent setText:chal.challengerName];
  [opponentEmail setText:chal.challengerEmail];
  [car setText:chal.challengerCar];
  [raceLocation setText:chal.location];

  return cell;
}

- (void)messageIfNoDataRetrieved {
  if (_challengesToUser) {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundView = nil;
  } else {
    UILabel *messageLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                 self.view.bounds.size.height)];

    messageLabel.text =
        @"No data is currently available.\n Please, pull down to refresh";
    messageLabel.textColor = [UIColor blackColor];
    //        messageLabel.backgroundColor = [UIColor colorWithRed:1.0
    //        green:0.6        blue:0.1 alpha:0.8];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [messageLabel sizeToFit];

    self.tableView.backgroundView = messageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)msg {
  [[[UIAlertView alloc] initWithTitle:title
                              message:msg
                             delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil] show];
}
@end
