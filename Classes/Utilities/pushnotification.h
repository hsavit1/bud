//
//  pushnotification.h
//  app
//
//  Created by Henry Savit on 10/25/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <Parse/Parse.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
void		ParsePushUserAssign		(void);
void		ParsePushUserResign		(void);

//-------------------------------------------------------------------------------------------------------------------------------------------------
void		SendPushNotification	(NSString *roomId, NSString *text);