//
//  UIDevice+JSQMessages.m
//  app
//
//  Created by Henry Savit on 10/25/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIDevice+JSQMessages.h"

@implementation UIDevice (JSQMessages)

+ (BOOL)jsq_isCurrentDeviceBeforeiOS8
{
    // iOS < 8.0
    return [[UIDevice currentDevice].systemVersion compare:@"8.0.0" options:NSNumericSearch] == NSOrderedAscending;
}

@end