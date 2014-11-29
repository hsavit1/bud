//
//  EditProfileTableViewController.m
//  app
//
//  Created by Henry Savit on 10/16/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "ProfileDetailTableViewController.h"
#import "MDCParallaxView.h"
#import "GMCPagingScrollView.h"
#import "PWParallaxScrollView.h"
#import "ChoosePersonViewController.h"

@interface ProfileDetailTableViewController ()  <UIScrollViewDelegate, GMCPagingScrollViewDataSource, GMCPagingScrollViewDelegate >

@property (nonatomic, strong) GMCPagingScrollView *pagingScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) MDCParallaxView *parallaxView;

@end

@implementation ProfileDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect backgroundRect = CGRectMake(0, 0, 320, 320);
    CGRect backgroundRect2 = CGRectMake(0, 64, 320, 320);

    if([self.navigationController.viewControllers[0] class] == [ChoosePersonViewController class])
        self.pagingScrollView = [[GMCPagingScrollView alloc] initWithFrame:backgroundRect2];
    else
        self.pagingScrollView = [[GMCPagingScrollView alloc] initWithFrame:backgroundRect];
    
    self.pagingScrollView.dataSource = self;
    self.pagingScrollView.infiniteScroll = YES;
    self.pagingScrollView.interpageSpacing = 0;
    [self.pagingScrollView registerClass:[UIView class] forReuseIdentifier:@"blah"];
    [self.pagingScrollView reloadData];
    self.pagingScrollView.userInteractionEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110, 20, 100, 20)];
    self.pageControl.numberOfPages = 5;
    [self.pageControl setCurrentPage:0];
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//    [self.view addSubview:self.pagingScrollView];
    
    CGRect textRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400.0f);
    UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
    textView.text = NSLocalizedString(@"Permission is hereby granted, free of charge, to any "
                                      @"person obtaining a copy of this software and associated "
                                      @"documentation files (the \"Software\"), to deal in the "
                                      @"Software without restriction, including without limitation "
                                      @"the rights to use, copy, modify, merge, publish, "
                                      @"distribute, sublicense, and/or sell copies of the "
                                      @"Software, and to permit persons to whom the Software is "
                                      @"furnished to do so, subject to the following "
                                      @"conditions...\"", nil);
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.textColor = [UIColor darkTextColor];
    textView.scrollsToTop = NO;
    textView.editable = NO;
    
    
    //foreground view can be anything you want it to be!!
    self.parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:self.pagingScrollView foregroundView:textView];
    if([self.navigationController.viewControllers[0] class] == [ChoosePersonViewController class]){
        self.parallaxView.frame = CGRectMake(0, 64, 320, 568);
        //self.parallaxView.scrollView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);
    }
    else
        self.parallaxView.frame = self.view.frame;

    //self.parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.parallaxView.backgroundHeight = 270;
    self.parallaxView.scrollView.scrollsToTop = YES;
    self.parallaxView.backgroundInteractionEnabled = YES;
    self.parallaxView.scrollViewDelegate = self;
    [self.view addSubview:self.parallaxView];
    //[self.navigationController.navigationItem.titleView addSubview:self.pageControl];
    [self.view addSubview:self.pageControl];

}


#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}


#pragma mark - Internal Methods

- (void)handleTap:(UIGestureRecognizer *)gesture {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

#pragma mark - GMCPagingScrollViewDataSource

- (NSUInteger)numberOfPagesInPagingScrollView:(GMCPagingScrollView *)pagingScrollView {
    return 4;//self.imageFiles;
}

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index {
    UIImageView *page = [pagingScrollView dequeueReusablePageWithIdentifier:@"blah"];
    
    switch (index) {
        case 0:{
            //all it's doing is putting something in the background
            UIImage *backgroundImage = [UIImage imageNamed:@"finn"];
            CGRect backgroundRect = CGRectMake(0, 0, 320, 320);
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
            backgroundImageView.image = backgroundImage;
            page = backgroundImageView;
//            page = self.galleryImages2[0];
//            [self.pageControl setCurrentPage:0];
            break;
        }
        case 1:{
            //all it's doing is putting something in the background
            UIImage *backgroundImage = [UIImage imageNamed:@"jake"];
            CGRect backgroundRect = CGRectMake(0, 0, 320, 320);
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
            backgroundImageView.image = backgroundImage;
            page = backgroundImageView;
            //            page = self.galleryImages2[0];
            //            [self.pageControl setCurrentPage:0];
            break;
        }
        case 2:{
            //all it's doing is putting something in the background
            UIImage *backgroundImage = [UIImage imageNamed:@"fiona"];
            CGRect backgroundRect = CGRectMake(0, 0, 320, 320);
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
            backgroundImageView.image = backgroundImage;
            page = backgroundImageView;
            //            page = self.galleryImages2[0];
            //            [self.pageControl setCurrentPage:0];
            break;
        }
        case 3:{
            //all it's doing is putting something in the background
            UIImage *backgroundImage = [UIImage imageNamed:@"prince"];
            CGRect backgroundRect = CGRectMake(0, 0, 320, 320);
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
            backgroundImageView.image = backgroundImage;
            page = backgroundImageView;
            //            page = self.galleryImages2[0];
            //            [self.pageControl setCurrentPage:0];
            break;
        }
    }
    
    return page;
}

-(void)pagingScrollView:(GMCPagingScrollView *)pagingScrollView didEndDisplayingPage:(UIView *)page atIndex:(NSUInteger)index{
    [self.pageControl setCurrentPage:index];

}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    
//    CGFloat scrollViewOffset = aScrollView.contentOffset.y;
//    
//    if(scrollViewOffset < 0.0f) {
//        // postition top
//        //CGRect backgroundRect = CGRectMake(0, 0, 320, 270);
//        CGRect imageViewRect = ((UIView*)[self pagingScrollView:self.pagingScrollView pageForIndex:0]).frame;
//        imageViewRect.origin.y = scrollViewOffset;
//        imageViewRect.origin.x = scrollViewOffset;
//        
//        CGFloat newBackdropHeight = 320 - MAX(scrollViewOffset,-100.0);
//        //CGFloat newBackdropWidth = self.pagingScrollView.frame.size.width - MAX(scrollViewOffset,-100.0);
//        //CGFloat newBackdropWidth2 = self.pagingScrollView.frame.size.width - MAX(scrollViewOffset,-100.0);
//        CGFloat newBackdropWidth = 320 - MAX(scrollViewOffset,-100.0);
//
//        imageViewRect.size.height = newBackdropHeight;
//        imageViewRect.size.width = newBackdropWidth;
//  
//        self.pagingScrollView.frame = imageViewRect;
//        //need to figure out how to adjust the width!!!
//        
////        [self pagingScrollView:self.pagingScrollView pageForIndex:0].frame = imageViewRect;
//    }
}
@end
