//
//  FirstTimeViewController2.h
//  Turnup!
//
//  Created by Henry Savit on 8/31/14.
//  Copyright (c) 2014 Sacha Demos and Henry Savit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTutorial : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) UIPageControl *pageControl2;

@end
