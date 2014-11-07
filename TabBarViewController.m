//
//  TabBarViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController {
    int _controllerIndex ;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _controllerIndex = 0;
  UISwipeGestureRecognizer *rightSwipeRecognizer =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(swipe:)];

  UISwipeGestureRecognizer *leftSwipeRecognizer =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(swipe:)];
  leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

  [self.view addGestureRecognizer:rightSwipeRecognizer];
  [self.view addGestureRecognizer:leftSwipeRecognizer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)recognizer {
  NSString *message;
    
  switch (recognizer.direction) {
  case UISwipeGestureRecognizerDirectionRight:
    message = @"Swiped right";
          _controllerIndex--;
    break;
  case UISwipeGestureRecognizerDirectionLeft:
    message = @"Swiped left";
          _controllerIndex++;
    break;
  default:
    message = @"Not swiped";
    break;
  }
//  NSLog(@"%@", message);
//NSLog(@"%d", _controllerIndex);
    
//    NSLog(@"%ld", self.viewControllers.count);
    if (_controllerIndex >= (int)self.viewControllers.count) {
        _controllerIndex = (int)self.viewControllers.count-1;
    }else if (_controllerIndex<0){
        _controllerIndex = 0;
    }
    
//    NSLog(@"%d", _controllerIndex);
    if (_controllerIndex!=self.selectedIndex) {
       
    UIView * fromView = self.selectedViewController.view;
    UIView * toView = [[self.viewControllers objectAtIndex:_controllerIndex] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(_controllerIndex > self.selectedIndex ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft)
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.selectedIndex = _controllerIndex;
                        }
                    }];
    }
}

@end
