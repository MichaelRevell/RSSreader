//
//  NewFeedViewController.m
//  RSSreader
//
//  Created by Michael Revell on 10/3/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "NewFeedViewController.h"

@implementation NewFeedViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.textField.text = self.str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Use Feed" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    self.navigationItem.leftBarButtonItem = newButton;
    
}

- (void)buttonClicked:(UIBarButtonItem *)barButton {
    self.str = self.textField.text;
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

@end
