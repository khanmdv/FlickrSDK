//
//  FlickrAPITest.m
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/25/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "FlickrAPITest.h"
#import <AFNetworking.h>
#import "AFJSONRequestOperationMock.h"

@implementation FlickrAPITest

-(AFJSONRequestOperation*) buildAFJSONRequestOperationWithRequest : (NSURLRequest *)urlRequest
                                                           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure{
    
    AFJSONRequestOperationMock* jsonOperation = [[AFJSONRequestOperationMock alloc] init];
    jsonOperation.success = success;
    jsonOperation.error = failure;
    
    if(self.showSuccess){
        [jsonOperation setNeedsSuccess];
    }else{
        [jsonOperation setNeedsError];
    }
    
    return jsonOperation;
}

@end
