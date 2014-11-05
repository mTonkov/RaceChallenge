//
//  AddNewChallengeViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "AddNewChallengeViewController.h"

#import "Challenge.h"
#import <Parse/Parse.h>

@interface AddNewChallengeViewController ()

@end

@implementation AddNewChallengeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.carInput.layer.borderColor = [[UIColor blackColor] CGColor];
  self.carInput.layer.cornerRadius = 10;
  self.carInput.layer.borderWidth = 1.0;

  self.addChallengeBtn.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
