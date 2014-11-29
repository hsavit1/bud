//
//  UIDevice+JSQMessages.h
//  app
//
//  Created by Henry Savit on 10/25/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (JSQMessages)

/**
 *  @return Whether or not the current device is running a version of iOS before 8.0.
 */
+ (BOOL)jsq_isCurrentDeviceBeforeiOS8;

@end