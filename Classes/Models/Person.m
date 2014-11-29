//
// Person.m
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

#import "Person.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation Person

#pragma mark - Object Lifecycle

//- (instancetype)initWithName:(NSString *)name
//                    objectId:(NSString *)objid
//                       image:(UIImage *)image
//                         age:(NSUInteger)age
//       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
//     numberOfSharedInterests:(NSUInteger)numberOfSharedInterests //do i want to keep this?
//              numberOfPhotos:(NSUInteger)numberOfPhotos { //definitely cant keep this!
//    self = [super init];
//    if (self) {
//        _name = name;
//        _objectId = objid;
//        _image = image;
//        _age = age;
//        _numberOfSharedFriends = numberOfSharedFriends;
//        _numberOfSharedInterests = numberOfSharedInterests;
//        _numberOfPhotos = numberOfPhotos;
//    }
//    return self;
//}


- (instancetype)initWithName:(NSString *)name
                    objectId:(NSString *)objid
                       image:(PFFile *)image
                         age:(NSUInteger)age
       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
              strainOfChoice:(NSUInteger)strainOfChoice{
    self = [super init];
    if (self) {
        _name = name;
        _objectId = objid;
        _image = image;
        _age = age;
        _numberOfSharedFriends = numberOfSharedFriends;
        _strainOfChoice = strainOfChoice;
    }
    return self;
}


-(instancetype)initFromPFObject:(PFObject *)obj {
    self = [super init];
    if (self) {
        
        _name = obj[@"fullname"];
        _objectId = obj.objectId;
        _image = obj[@"picture"];
        _age =  (NSUInteger) obj[@"age"];
        _numberOfSharedFriends = (NSUInteger) obj[@"shared"];
        _strainOfChoice = (NSUInteger) obj[@"strain"];
    }
    return self;
}

////A list of Facebook friends that the session user and the request user have in common.
////https://developers.facebook.com/docs/graph-api/reference/v2.2/user.context/mutual_friends
//-(int)numberOfSharedFriends{
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"context.fields(mutual_friends)", @"fields",
//                            nil
//                            ];
//    __block int num;
//    /* make the API call */
//    [FBRequestConnection startWithGraphPath:@"/{user-id}"
//                                 parameters:params
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              /* handle the result */
//                              num = (int)result;
//                          }];
//    return num;
//}


@end
