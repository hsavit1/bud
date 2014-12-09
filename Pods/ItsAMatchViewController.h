//
//  ItsAMatchViewController.h
//  app
//
//  Created by Henry Savit on 10/28/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ItsAMatchViewController : UIViewController

@property (nonatomic, weak) PFFile *personImageFile;
@property (nonatomic, weak) NSString *name;

@property (weak, nonatomic) IBOutlet PFImageView *likedPersonImage;
@property (weak, nonatomic) IBOutlet PFImageView *myImage;
@end
