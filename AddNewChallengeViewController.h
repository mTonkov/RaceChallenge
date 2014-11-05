//
//  AddNewChallengeViewController.h
//  RaceChallenge
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewChallengeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *carInput;
@property (weak, nonatomic) IBOutlet UIPickerView *raceTypePicker;
@property (weak, nonatomic) IBOutlet UIButton *addChallengeBtn;

@end
