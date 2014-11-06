//
//  MyChallengesTVC.m
//  RaceChallenge
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "MyChallengesTVC.h"
#import "CDChallenge.h"
#import "CoreDataDBHelper.h"

@interface MyChallengesTVC ()

@end

@implementation MyChallengesTVC {
  NSMutableArray *_myChallenges;
  CoreDataDBHelper *_cdHelper;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _cdHelper = [CoreDataDBHelper getInstance];
  [self getCdData];

  //    self.edgesForExtendedLayout = UIRectEdgeAll;
  //    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f,
  //    CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
  //    [self.tableView reloadData];
}

- (void)getCdData {
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"CDChallenge"];
  NSSortDescriptor *sort =
      [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObject:sort]];

  _myChallenges = [NSMutableArray
      arrayWithArray:[_cdHelper.context executeFetchRequest:request error:nil]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _myChallenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"listMyChallenges";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }

  CDChallenge *chal = [_myChallenges objectAtIndex:indexPath.row];
  UILabel *raceType = (UILabel *)[cell viewWithTag:1];
  UILabel *opponent = (UILabel *)[cell viewWithTag:2];
  UILabel *opponentEmail = (UILabel *)[cell viewWithTag:3];
  UILabel *car = (UILabel *)[cell viewWithTag:4];
  UILabel *raceLocation = (UILabel *)[cell viewWithTag:5];

  [raceType setText:chal.raceType];
  [opponent setText:chal.opponentName];
  [opponentEmail setText:chal.location];
  [car setText:chal.opponentCar];
  [raceLocation setText:chal.location];

  return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
