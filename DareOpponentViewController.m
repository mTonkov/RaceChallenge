//
//  ChallengeOpponentViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "DareOpponentViewController.h"

@interface DareOpponentViewController ()
@property(weak, nonatomic) IBOutlet UILabel *opponentName;
@property(weak, nonatomic) IBOutlet UILabel *opponentCar;
@property(weak, nonatomic) IBOutlet UILabel *raceLocation;
@property(weak, nonatomic) IBOutlet UILabel *raceType;
@property(weak, nonatomic) IBOutlet UILabel *opponentMail;
@property(weak, nonatomic) IBOutlet UITextField *currentUserCar;

@end

@implementation DareOpponentViewController{
    PFUser * currentUser;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.opponentName.text = self.selectedChallenge.ownerName;
  self.opponentCar.text = self.selectedChallenge.ownerCar;
  self.raceLocation.text = self.selectedChallenge.location;
  self.raceType.text = self.selectedChallenge.type;
  self.opponentMail.text = self.selectedChallenge.ownerEmail;
    
    currentUser = [PFUser currentUser];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)challengeOpponent:(id)sender {
    if (self.currentUserCar.text.length < 5) {
        [[[UIAlertView alloc] initWithTitle:@"Not enough data for car!"
                                   message:@"Please provide car data"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil, nil] show];
        return;
    }
    self.selectedChallenge.challengerName = currentUser.username;
    self.selectedChallenge.challengerEmail = currentUser.email;
    self.selectedChallenge.challengerCar = self.currentUserCar.text;
    
    [self.selectedChallenge saveInBackground];
    [self.retrievedChallenges removeObject:self.selectedChallenge];
    
//TODO add to CoreData
    [self animateButton:sender];
}

-(void) animateButton:(id) button{
    UIView *btn = button;
    [btn setFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame),
                             CGRectGetWidth(btn.frame),
                             CGRectGetHeight(btn.frame))];
    
    [UIView animateWithDuration:1
                          delay:0.2
                        options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         // set the new frame
                         [btn setFrame:CGRectMake(2*CGRectGetWidth(btn.frame), CGRectGetMinY(btn.frame),
                                                  CGRectGetWidth(btn.frame),
                                                  CGRectGetHeight(btn.frame))];
                     }
                     completion:^(BOOL finished) { NSLog(@"Button animated!"); }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
