//
//  AFJSONRequestOperationMock.m
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/25/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "AFJSONRequestOperationMock.h"

@interface AFJSONRequestOperationMock ()

@property (nonatomic, assign) BOOL needsSuccess;
@property (nonatomic, assign) BOOL needsError;

@end

@implementation AFJSONRequestOperationMock

-(void)setNeedsSuccess{
    self.needsSuccess = YES;
}

-(void)setNeedsError{
    self.needsError = YES;
}

- (void)start {
    if (self.needsSuccess){
        NSDictionary* JSON = @{ @"query" : @{ @"results" : @{ @"photo": @[@{
            @"farm": @"4",
            @"id": @"10442613173",
            @"isfamily": @"0",
            @"isfriend": @"0",
            @"ispublic": @"1",
            @"owner": @"74089637@N00",
            @"secret": @"1234362642",
            @"server": @"3762",
            @"title": @"hungary - budapest"
        }, @{
            @"farm": @"8",
            @"id": @"10439344594",
            @"isfamily": @"0",
            @"isfriend": @"0",
            @"ispublic": @"1",
            @"owner": @"27217152@N05",
            @"secret": @"fa5490b313",
            @"server": @"7381",
            @"title": @"Balder Footbridge (2)"
            } ], }, }, };
            
            self.success(nil, nil, JSON);
    }else{
        NSError* error;
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Something Bad Happened." forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"ErrorDomain" code:400 userInfo:errorDetail];
        self.error(nil, nil, error, nil);
    }
}

@end
