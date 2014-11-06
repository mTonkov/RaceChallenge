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
@property(weak, nonatomic) IBOutlet UIButton *challengeBtn;

@end

@implementation DareOpponentViewController {
  PFUser *currentUser;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.opponentName.text = self.selectedChallenge.ownerName;
  self.opponentCar.text = self.selectedChallenge.ownerCar;
  self.raceLocation.text = self.selectedChallenge.location;
  self.raceType.text = self.selectedChallenge.type;
  self.opponentMail.text = self.selectedChallenge.ownerEmail;
  self.challengeBtn.layer.cornerRadius = 10;
  currentUser = [PFUser currentUser];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];}

- (IBAction)challengeOpponent:(id)sender {
  if (self.currentUserCar.text.length < 5) {
    [self showAlert:@"Not enough data for car!"
         andMessage:@"Please provide car data"];

    return;
  }
  self.selectedChallenge.challengerName = currentUser.username;
  self.selectedChallenge.challengerEmail = currentUser.email;
  self.selectedChallenge.challengerCar = self.currentUserCar.text;

  [self.selectedChallenge saveInBackground];
  [self.retrievedChallenges removeObject:self.selectedChallenge];

  // TODO add to CoreData

  [self showAlert:@"New challenge!"
       andMessage:[NSString stringWithFormat:@"You just challenged %@",
                                             self.selectedChallenge.ownerName]];
  [self animateButton:sender];
}

- (void)animateButton:(id)button {
  UIView *btn = button;
  [btn setFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame),
                           CGRectGetWidth(btn.frame),
                           CGRectGetHeight(btn.frame))];

  [UIView animateWithDuration:1
      delay:0.2
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
          // set the new frame
          [btn setFrame:CGRectMake(2 * CGRectGetWidth(btn.frame),
                                   CGRectGetMinY(btn.frame),
                                   CGRectGetWidth(btn.frame),
                                   CGRectGetHeight(btn.frame))];
      }
      completion:^(BOOL finished) { NSLog(@"Button animated!"); }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)msg {
  [[[UIAlertView alloc] initWithTitle:title
                              message:msg
                             delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil] show];
}

@end
