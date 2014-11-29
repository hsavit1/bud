//
//  ProfileDetailTVC.h
//  app
//
//  Created by Henry Savit on 10/16/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileDetailTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) PFUser *user;

/*!
 * The "liked" view, which fades in when the like button is pressed
 */
@property (nonatomic, strong) UIView *likedView;

/*!
 * The "nope" view, which fades in when the nope button is pressed
 */
@property (nonatomic, strong) UIView *nopeView;

@property (nonatomic, strong) UIColor *likeColor;
@property (nonatomic, strong) UIColor *nopeColor;
@property (nonatomic, assign) CGFloat nopeRotationAngle;
@property (nonatomic, assign) CGFloat likedRotationAngle;


@end
