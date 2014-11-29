//
//  ComposeContentViewController.h
//  app
//
//  Created by Henry Savit on 10/18/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTextView.h"

@interface ComposeContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet HSTextView *textArea;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) NSNumber *senderCellNumber;

@end
