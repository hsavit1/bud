//
// ChoosePersonViewController.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ChoosePersonViewController.h"
#import "Person.h"
#import "MDCSwipeToChoose.h"
#import "ProfileDetailTVC.h"
#import "ASFSharedViewTransition.h"
#import "ProgressHUD.h"
#import "RTSpinKitView.h"
#import "ItsAMatchViewController.h"

#import "utilities.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = -10;

@interface ChoosePersonViewController ()<UIGestureRecognizerDelegate, ASFSharedViewTransitionDataSource>
@property (nonatomic, strong) NSMutableArray *people;
@end

@implementation ChoosePersonViewController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PFUser currentUser] == nil) LoginUser(self);
}



#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _people = [[NSMutableArray alloc] init];
        [self addMorePeople:5];
        
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"LoveBuds";
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"SnellRoundhand-Black" size:40], //HoeflerText-BlackItalic
      NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.898 blue:0.8 alpha:1];
    [self.view addSubview:self.frontCardView];
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    pgr.delegate = self;
    [self.frontCardView addGestureRecognizer:pgr];
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    [self constructNopeButton];
    [self constructLikedButton];
    [self constructInfoButton];
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    
        MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
        options.delegate = self;
        options.threshold = 100.f;
        options.onPan = ^(MDCPanState *state){
    
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y + (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
        NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
        };
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPerson.name);
    } else {
        NSLog(@"You liked %@.", self.currentPerson.name);
    }
    
    [PFCloud callFunctionInBackground:@"match"
                      withParameters:@{
                                       @"touser" : self.currentPerson.objectId == nil ? @"":self.currentPerson.objectId,
                                       @"match" : @(direction == MDCSwipeDirectionRight)
                                       }
                                block: ^(id obj, NSError* err){
                                    //swiped.
                                    
                                    //if swipes match, call match screen
                                    if(![obj isKindOfClass:[NSNull class]]){
                                        UIStoryboard *matchSB = [UIStoryboard storyboardWithName:@"MatchView" bundle:nil];
                                        ItsAMatchViewController *matchView = [matchSB instantiateViewControllerWithIdentifier:@"mv"];
                                        [self presentViewController:matchView animated:YES completion:nil];
                                    }
                                    //if no match, do nothing
                                    
                                }];
    self.frontCardView = self.backCardView;
    [self reloadCards];
    
}

-(void)reloadCards{
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    pgr.delegate = self;
    [self.frontCardView addGestureRecognizer:pgr];
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

//really could use a better way of making this
- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.person;
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {

    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 100.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    if ([self.people count] != 0) {
        ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame person:self.people[0] options:options];
        [self.people removeObjectAtIndex:0];
        return personView;
    }
    else{
        Person *load = [[Person alloc] initWithName:@"Loading...    "
                                           objectId:nil
                                              image:nil
                                                age:nil
                              numberOfSharedFriends:nil
                                     strainOfChoice:nil];
        
        ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                        person:load
                                                                       options:options];
        
        self.spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleFadingCircle];
        self.spinner.frame = CGRectMake(frame.size.width/2 - 50, frame.size.height/2 - 80, 100, 100);
        self.spinner.color = [UIColor colorWithRed:0.0 green:1 blue:0.24 alpha:1.0];
        self.spinner.hidesWhenStopped = YES;
        [personView addSubview:self.spinner];
        self.spinner.spinnerSize = 100.0;
        [self.spinner sizeToFit];
        self.stonersLoadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.spinner.frame.origin.x - 30, self.spinner.frame.origin.y + 110, 180, 60)];
        self.stonersLoadingLabel.text = @"Loading Potheads";
        self.stonersLoadingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        self.stonersLoadingLabel.numberOfLines = 0;
        [self.stonersLoadingLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.stonersLoadingLabel.textAlignment = NSTextAlignmentCenter;
        [personView addSubview:self.stonersLoadingLabel];
        
        
        [self addMorePeople:5];
        
        //set up an NSTIMER
        
        return personView;
    }
}

-(void)addMorePeople:(int)num{
    
    self.stonersLoadingLabel.hidden = YES;
    self.spinner.stopped = YES;
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
    
    [PFCloud callFunctionInBackground: @"getPeople"
                       withParameters: @{@"number" : @(num)}
                                block:^(NSArray* objs, NSError *error) {
                                    if(!error){
                                        for (PFObject *obj in objs) {
                                            [_people addObject:[[Person alloc] initFromPFObject:obj]];
                                        }
   
                                        
                                        [self reloadCards];
                                    
   
                                    }
                                }];
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 10.f;
    CGFloat topPadding = 70.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    CGFloat horizontalPadding = 20.f;

    return CGRectMake(frontFrame.origin.x + 10,
                      frontFrame.origin.y + 20.f,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),//CGRectGetWidth(frontFrame) - 20,
                      CGRectGetHeight(frontFrame));
}





//////////////////////////Construction bottom buttons///////////////////////////////////////////////////////////////////////////



// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"noSmoking_large"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding - 30,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding - 15,
                              image.size.width,
                              image.size.height);
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor redColor]];
    [button.layer setShadowOffset:CGSizeMake(0, 0)];
    [button.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [button.layer setShadowRadius:2.0];
    [button.layer setShadowOpacity:0.6];
    [button addTarget:self action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "info" button.
- (void)constructInfoButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"info"];
    button.frame = CGRectMake(self.view.bounds.size.width/2 - 20,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding - 2,
                              40,
                              40);
    //    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1] /*#3498db*/];//[UIColor yellowColor]];
    [button.layer setShadowOffset:CGSizeMake(0, 0)];
    [button.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [button.layer setShadowRadius:1.0];
    [button.layer setShadowOpacity:0.6];
    [button addTarget:self action:@selector(pushProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)pushProfile{
    UIStoryboard *psb = [UIStoryboard storyboardWithName:@"ProfileDetail" bundle:nil];
    ProfileDetailTVC *e = [psb instantiateViewControllerWithIdentifier:@"p"];//    [self presentViewController:profile animated:YES completion:nil];
    e.edgesForExtendedLayout = UIRectEdgeNone;
    [e.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController pushViewController:e animated:YES];
    
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"yesSmoking_large"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding + 30,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding - 15,
                              image.size.width,
                              image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    //[button setImage:image forState:UIControlStateNormal];
    //[button setTintColor:[UIColor greenColor]];
    
    [button.layer setShadowOffset:CGSizeMake(0, 0)];
    [button.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [button.layer setShadowRadius:2.0];
    [button.layer setShadowOpacity:0.6];
    [button addTarget:self action:@selector(likeFrontCardView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    [self pushProfile];
}

- (UIView *)sharedView
{
    return self.frontCardView.imageView;
}

@end
