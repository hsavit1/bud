//
//  AddItemViewController.m
//  app
//
//  Created by Henry Savit on 10/28/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popViewControllerAnimated:)];
    self.navigationController.navigationItem.leftBarButtonItem = add;
}


@end
