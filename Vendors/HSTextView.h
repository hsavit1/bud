//
//  HSTextView.h
//  Turnup!
//
//  Created by Henry Savit on 10/11/14.
//  Copyright (c) 2014 Justin Canna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSTextView : UITextView

@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic, strong) UIColor* placeholderColor;

@end