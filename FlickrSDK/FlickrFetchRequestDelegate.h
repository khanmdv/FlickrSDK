//
//  FlickrFetchRequestDelegate.h
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _PageIndex{
    int pageNumber;
    int count;
} PageIndex;

@protocol FlickrFetchRequestDelegate <NSObject>

-(NSUInteger) pageNumberForFetchRequest;

@end
