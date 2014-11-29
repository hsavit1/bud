//
//  ProfileDetailTVC.m
//  app
//
//  Created by Henry Savit on 10/16/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "ProfileDetailTVC.h"
#import "GMCPagingScrollView.h"
#import "ChoosePersonViewController.h"
#import "MainInfoCell.h"
#import "TextDescriptionCell.h"
#import "ASFSharedViewTransition.h"
#import "EditProfileDetailViewController.h"
#import "MDCSwipeToChooseViewOptions.h"
#import "UIView+MDCBorderedLabel.h"
#import "UIColor+MDCRGB8Bit.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

static CGFloat const MDCSwipeToChooseViewHorizontalPadding = 10.f + 15;
static CGFloat const MDCSwipeToChooseViewTopPadding = 20.f + 50;
static CGFloat const MDCSwipeToChooseViewLabelWidth = 95.f;

@interface ProfileDetailTVC ()<GMCPagingScrollViewDataSource,GMCPagingScrollViewDelegate, ASFSharedViewTransitionDataSource>{
    NSMutableArray *profilePics;
}

@property (nonatomic, strong) GMCPagingScrollView *pagingScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numMutualFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalBioLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteStrains;
@property (weak, nonatomic) IBOutlet UILabel *toolsIUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *moviesLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *booksLabel;

@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;


@end

@implementation ProfileDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/;
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:btn];
    
    float width = self.view.bounds.size.width;
    self.headerView.frame = CGRectMake(0, 0, width, width);
    CGRect backgroundRect = CGRectMake(0, 0, width, width);
    self.pagingScrollView = [[GMCPagingScrollView alloc] initWithFrame:backgroundRect];
    self.pagingScrollView.dataSource = self;
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.infiniteScroll = YES;
    self.pagingScrollView.interpageSpacing = 0;
    [self.pagingScrollView registerClass:[UIView class] forReuseIdentifier:@"blah"];
    [self.pagingScrollView reloadData];
    self.pagingScrollView.userInteractionEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGSize navBarSize = self.navigationController.navigationBar.bounds.size;
    CGPoint origin = CGPointMake( navBarSize.width/2, navBarSize.height/2 );
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(origin.x, origin.y,
                                                                       0, 0)];//    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(5, 10, 100, 20)];
    self.pageControl.numberOfPages = 6;
    [self.pageControl setCurrentPage:0];
    self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1] /*#16a085*/;
    [self.navigationController.navigationBar addSubview:self.pageControl];
    self.pageControl.alpha = 1;
    
    [self.tableView addSubview:self.pagingScrollView];
    
    profilePics = [[NSMutableArray alloc]init];
    for (int i = 0; i < 6; i++) {
        NSString *save = [@"image" stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
        if(self.user[save]){
            PFFile *file = self.user[save];
            [profilePics addObject:file];
        }
    }
    
    if([self.navigationController.viewControllers[0] class] == [self class]){
        UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
        self.navigationItem.rightBarButtonItem = edit;
        self.user = [PFUser currentUser];
    }
    else{
        UIImage * imageNormal = [UIImage imageNamed:@"noSmoking"];
        UIImage * imageNormal2 = [UIImage imageNamed:@"yesSmoking"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(menuButtonPressed2:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, imageNormal.size.width , imageNormal.size.height );
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setBackgroundImage:imageNormal2 forState:UIControlStateNormal];
        button2.frame = CGRectMake(65.0, 65, imageNormal2.size.width , imageNormal2.size.height );
        UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem * barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [self.navigationItem setRightBarButtonItems:@[barButtonItem2, barButtonItem]];

        _likeColor = [UIColor colorWith8BitRed:29.f green:245.f blue:106.f alpha:1.f];
        _nopeColor = [UIColor colorWith8BitRed:247.f green:91.f blue:37.f alpha:1.f];
        _likedRotationAngle = -10.f;
        _nopeRotationAngle = 10.f;
        [self constructLikedView];
        [self constructNopeImageView];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageControl.alpha = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.pageControl.alpha = 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (NSUInteger)numberOfPagesInPagingScrollView:(GMCPagingScrollView *)pagingScrollView {
    return profilePics.count;
}

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index {
    PFImageView *page = [pagingScrollView dequeueReusablePageWithIdentifier:@"blah"];
    float width = self.view.bounds.size.width;
    CGRect backgroundRect = CGRectMake(0, 0, width, width);

    for(int i = 0; i < profilePics.count; i++){
        if(i == index){
            PFImageView *backgroundImageView = [[PFImageView alloc] initWithFrame:backgroundRect];
            backgroundImageView.file = profilePics[i];
            [backgroundImageView loadInBackground];
            page = backgroundImageView;
            [self.pageControl setCurrentPage:i];
        }
    }
    
    return page;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            
            self.firstNameLabel.text = self.user[@"username"];
            self.distanceLabel.text = @"20 miles";
            self.numMutualFriendsLabel.text = @"50";
            self.lastActiveLabel.text = @"30 minutes ago";
            
            return 70;
            break;
        }
        case 1:{
            self.personalBioLabel.textAlignment = NSTextAlignmentLeft;
            self.personalBioLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.personalBioLabel.text = self.user[@"bioDescription"];
            if (IS_IPHONE_5) {
                [self.personalBioLabel setPreferredMaxLayoutWidth:248];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(248, 10000)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                            attributes:@{NSFontAttributeName:
                                                                                             self.personalBioLabel.font}
                                                                               context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            else if (IS_IPHONE_6){
                [self.personalBioLabel setPreferredMaxLayoutWidth:248 + 55];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(248 + 45, 10000)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                            attributes:@{NSFontAttributeName:
                                                                                             self.personalBioLabel.font}
                                                                               context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.personalBioLabel setPreferredMaxLayoutWidth:248 + 95];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(248 + 94, 10000)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                            attributes:@{NSFontAttributeName:
                                                                                             self.personalBioLabel.font}
                                                                               context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
        }
        case 2:{
            NSString *string = self.user[@"favoriteProducts"];

            return 60;
        }
            break;
        case 3:{
            NSString *string = self.user[@"favoriteTools"];

            return 60;
            
        }
        case 4:{
            NSString *string = self.user[@"education"];
            self.educationLabel.text = string;
            if (IS_IPHONE_5) {
                [self.educationLabel setPreferredMaxLayoutWidth:248];
                CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(248, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.educationLabel.font}
                                                                             context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            else if (IS_IPHONE_6){
                [self.educationLabel setPreferredMaxLayoutWidth:248 + 55];
                CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(248 + 45, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.educationLabel.font}
                                                                             context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.educationLabel setPreferredMaxLayoutWidth:248 + 95];
                CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(248 + 94, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.educationLabel.font}
                                                                                context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            return 60;
        }
        case 5:{
            NSString *string = self.user[@"location"];
            self.userLocationLabel.text = string;
            if (IS_IPHONE_5) {
                [self.userLocationLabel setPreferredMaxLayoutWidth:248];
                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(248, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.userLocationLabel.font}
                                                                                context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            else if (IS_IPHONE_6){
                [self.userLocationLabel setPreferredMaxLayoutWidth:248 + 55];
                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(248 + 45, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.userLocationLabel.font}
                                                                                context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.userLocationLabel setPreferredMaxLayoutWidth:248 + 95];
                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(248 + 94, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.userLocationLabel.font}
                                                                                context:nil].size;
                return MAX(60, expectedSize.height + 10);
                
            }
            return 60;
        }
            

            
        default:
            break;
    }
    return 30;
}

- (void)constructLikedView {
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding ,
                              MDCSwipeToChooseViewTopPadding ,
                              CGRectGetMidX(self.headerView.bounds),
                              MDCSwipeToChooseViewLabelWidth);
    self.likedView = [[UIView alloc] initWithFrame:frame];
    
    //should really randomize this text
    NSArray *yesSayingsArray = [[NSArray alloc]initWithObjects:@"DANK", @"DOPE", @"FEELN' IT", @"YES", @"MHMMM", @"HMU", @"I WOULD", nil];
    [self.likedView constructBorderedLabelWithText:yesSayingsArray[(arc4random() % [yesSayingsArray count])]//self.options.nopeText
                                             color:self.likeColor
                                             angle:self.likedRotationAngle];
    self.likedView.alpha = 0.f;
    [self.pagingScrollView addSubview:self.likedView];
}

- (void)constructNopeImageView {
    CGFloat width = CGRectGetMidX(self.headerView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(self.headerView.bounds) - width - MDCSwipeToChooseViewHorizontalPadding;
    self.nopeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, MDCSwipeToChooseViewTopPadding, width, MDCSwipeToChooseViewLabelWidth)];
    
    NSArray *noSayingsArray = [[NSArray alloc]initWithObjects:@"DRY", @"CHILL", @"WEAK", @"PEACE", @"NAH", @"NOPE", @"NO WAY", @"BYE", nil];
    [self.nopeView constructBorderedLabelWithText:noSayingsArray[(arc4random() % [noSayingsArray count])] //"self.options.likedText
                                            color:self.nopeColor
                                            angle:self.nopeRotationAngle];
    self.nopeView.alpha = 0.f;
    [self.pagingScrollView addSubview:self.nopeView];
}

//if like
-(void)menuButtonPressed:(id)sender{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.likedView.alpha = 1.f;
                     } completion:^(BOOL animated){
                         [self.navigationController popViewControllerAnimated:YES];
                         [((ChoosePersonViewController*)self.navigationController.viewControllers[0]) likeFrontCardView];
                     }];
    
}

//if dislike
-(void)menuButtonPressed2:(id)sender{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.nopeView.alpha = 1.f;
                     } completion:^(BOOL animated){
                         [self.navigationController popViewControllerAnimated:YES];
                         [((ChoosePersonViewController*)self.navigationController.viewControllers[0]) nopeFrontCardView];
                     }];
}

//if edit
-(void)editButtonPressed:(id)sender{
    UIStoryboard *edit = [UIStoryboard storyboardWithName:@"ProfileDetail" bundle:nil];
    EditProfileDetailViewController *e = [edit instantiateViewControllerWithIdentifier:@"e"];
    [self.navigationController pushViewController:e animated:YES];
}

//if back
-(void)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)sharedView
{
    return self.pagingScrollView;
}

@end
