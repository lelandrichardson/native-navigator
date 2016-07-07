//
// Created by Leland Richardson on 6/19/16.
// Copyright (c) 2016 Facebook. All rights reserved.
//

#import "EXNativeViewController.h"
#import "RNNCoordinator.h"


@implementation EXNativeViewController {

}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];

  UILabel *label = [[UILabel alloc] init];
  [label setText:@"I am Native"];
  label.frame = CGRectMake(0, 150, 320, 80);
  [self.view addSubview:label];

  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:@"Push ScreenOne" forState:UIControlStateNormal];
  button.frame = CGRectMake(0, 230, 320, 800);
  [button addTarget:self action:@selector(pushScreenTwo) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];

  UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button2 setTitle:@"Push ScreenTwo" forState:UIControlStateNormal];
  button2.frame = CGRectMake(0, 310, 320, 80);
  [button2 addTarget:self action:@selector(pushScreenOne) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button2];
}

- (void)pushScreenOne {
  RNNViewController *rnvc = [[RNNCoordinator sharedInstance] newViewController:@"ScreenOne" withProps:nil];
  [self.navigationController pushViewController:rnvc animated:YES];
}

- (void)pushScreenTwo {
  RNNViewController *rnvc = [[RNNCoordinator sharedInstance] newViewController:@"ScreenTwo" withProps:nil];
  [self.navigationController pushViewController:rnvc animated:YES];
}

@end

