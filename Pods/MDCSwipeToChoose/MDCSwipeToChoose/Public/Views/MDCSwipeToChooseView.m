//
// MDCSwipeToChooseView.m
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

#import "MDCSwipeToChooseView.h"
#import "MDCSwipeToChoose.h"
#import "MDCGeometry.h"
#import "UIView+MDCBorderedLabel.h"
#import "UIColor+MDCRGB8Bit.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const MDCSwipeToChooseViewHorizontalPadding = 10.f + 15;
static CGFloat const MDCSwipeToChooseViewTopPadding = 20.f + 50;
static CGFloat const MDCSwipeToChooseViewLabelWidth = 95.f;

@interface MDCSwipeToChooseView ()
@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;
@end

@implementation MDCSwipeToChooseView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _options = options ? options : [MDCSwipeToChooseViewOptions new];
        [self setupView];
        [self constructImageView];
        [self constructLikedView];
        [self constructNopeImageView];
        [self setupSwipeToChoose];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 0.f;
    self.layer.borderWidth = 3.f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowRadius:5.0];
    [self.layer setShadowOpacity:0.6];
}

- (void)constructImageView {
    _imageView = [[PFImageView alloc] initWithFrame:self.bounds];
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 2;
    [self addSubview:_imageView];
}


///////////////////////////////// CONSTRUCT LIKE AND NOPE OVERLAYS //////////////////////////////////////////////////////////////////


- (void)constructLikedView {
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding ,
                              MDCSwipeToChooseViewTopPadding ,
                              CGRectGetMidX(_imageView.bounds),
                              MDCSwipeToChooseViewLabelWidth);
    self.likedView = [[UIView alloc] initWithFrame:frame];
    
    //should really randomize this text
    NSArray *yesSayingsArray = [[NSArray alloc]initWithObjects:@"DANK", @"DOPE", @"FEELN' IT", @"YES", @"MHMMM", @"HMU", @"I WOULD", nil];
    [self.likedView constructBorderedLabelWithText:yesSayingsArray[(arc4random() % [yesSayingsArray count])]//self.options.nopeText
                                            color:self.options.likedColor
                                            angle:self.options.likedRotationAngle];
    self.likedView.alpha = 0.f;
    [self.imageView addSubview:self.likedView];
}

- (void)constructNopeImageView {
    CGFloat width = CGRectGetMidX(self.imageView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(_imageView.bounds) - width - MDCSwipeToChooseViewHorizontalPadding;
    self.nopeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, MDCSwipeToChooseViewTopPadding, width, MDCSwipeToChooseViewLabelWidth)];
    
    NSArray *noSayingsArray = [[NSArray alloc]initWithObjects:@"DRY", @"CHILL", @"WEAK", @"PEACE", @"NAH", @"NOPE", @"NO WAY", @"BYE", nil];
    [self.nopeView constructBorderedLabelWithText:noSayingsArray[(arc4random() % [noSayingsArray count])] //"self.options.likedText
                                             color:self.options.nopeColor
                                             angle:self.options.nopeRotationAngle];
    self.nopeView.alpha = 0.f;
    [self.imageView addSubview:self.nopeView];
}

- (void)setupSwipeToChoose {
    
    //the swipe options are the options that happen when the swipe is made
    
    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self.options.delegate;
    options.threshold = self.options.threshold;

    __block UIView *likedImageView = self.likedView;
    __block UIView *nopeImageView = self.nopeView;
    options.onPan = ^(MDCPanState *state) {
        if (state.direction == MDCSwipeDirectionNone) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = 0.f;
        }
        else if (state.direction == MDCSwipeDirectionLeft) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = state.thresholdRatio * 1.3;
        }
        else if (state.direction == MDCSwipeDirectionRight) {
            likedImageView.alpha = state.thresholdRatio * 1.3;
            nopeImageView.alpha = 0.f;
        }

        if (self.options.onPan) {
            self.options.onPan(state);
        }
    };

    [self mdc_swipeToChooseSetup:options];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
