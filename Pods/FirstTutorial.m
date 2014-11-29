//
//  FirstTutorial.m
//  app
//
//  Created by Henry Savit on 10/31/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "FirstTutorial.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "WelcomeView.h"
#import "NavigationController.h"

@interface FirstTutorial (){
    //NSArray *pages;
}

@property (retain, nonatomic) NSArray *pages;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) UIPageControl *pageControlr;
@end

@implementation FirstTutorial

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view.
    
    // instantiate the view controlles from the storyboard
    UIViewController *page1 = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"page1"];
    
    UIViewController *page2 = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"page2"];
    
    UIViewController *page3 = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"page3"];
    
    UIViewController *page4 = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"page4"];
    
    NavigationController *page5 = [[NavigationController alloc] initWithRootViewController:[[WelcomeView alloc] init]];
    
    // load the view controllers in our pages array
    self.pages = [[NSArray alloc] initWithObjects:page1, page2, page3, page4, page5, nil];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageController setDelegate:self];
    [self.pageController setDataSource:self];
    
    [[self.pageController view] setFrame:[[self view] bounds]];
    NSArray *viewControllers = [NSArray arrayWithObject:[self.pages objectAtIndex:0]];
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.view sendSubviewToBack:[self.pageController view]];
    
    self.pageControlr = [[UIPageControl alloc] init];
    self.pageControlr.tintColor = [UIColor blueColor];
    self.pageControlr.backgroundColor = [UIColor clearColor];
    self.pageControlr.frame = CGRectMake(self.view.frame.size.width/2 - 50,7,103,100);
    self.pageControlr.numberOfPages = 2;
    self.pageControlr.currentPage = 0;
    self.pageControlr.numberOfPages = 5;
    [self.view addSubview:self.pageControlr];
    [self.view addSubview:self.pageControl];
    [self.pageControlr addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];    // get the index of the current view controller on display
    [self.pageControlr setCurrentPage:self.pageControlr.currentPage+1];                   // move the pageControl indicator to the next page
                                                                                          // [self.pageControl2 setCurrentPage:self.pageControl2.currentPage+1];                   // move the pageControl indicator to the next page
    
    // check if we are at the end and decide if we need to present the next viewcontroller
    if ( currentIndex < [self.pages count]-1) {
        return [self.pages objectAtIndex:currentIndex+1];                   // return the next view controller
    } else {
        return nil;                                                         // do nothing
    }
}


- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];    // get the index of the current view controller on display
    [self.pageControlr setCurrentPage:self.pageControlr.currentPage-1];                   // move the pageControl indicator to the next page
                                                                                          // [self.pageControl2 setCurrentPage:self.pageControl2.currentPage-1];                   // move the pageControl indicator to the next page
    
    // check if we are at the beginning and decide if we need to present the previous viewcontroller
    if ( currentIndex > 0) {
        return [self.pages objectAtIndex:currentIndex-1];                   // return the previous viewcontroller
    } else {
        return nil;                                                         // do nothing
    }
}

- (void)changePage:(id)sender {
    
    UIViewController *visibleViewController = self.pageController.viewControllers[0];
    NSUInteger currentIndex = [self.pages indexOfObject:visibleViewController];
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self.pages objectAtIndex:self.pageControlr.currentPage]];
    
    if (self.pageControlr.currentPage > currentIndex) {
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
    }

}

@end
