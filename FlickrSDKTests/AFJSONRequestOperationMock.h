//
//  AFJSONRequestOperationMock.h
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/25/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "AFJSONRequestOperation.h"

typedef void (^successBlock)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
typedef void (^errorBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);


@interface AFJSONRequestOperationMock : AFJSONRequestOperation

@property (nonatomic, assign) successBlock success;
@property (nonatomic, assign) errorBlock error;

-(void)setNeedsSuccess;
-(void)setNeedsError;

@end
