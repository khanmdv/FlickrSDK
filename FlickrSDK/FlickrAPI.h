//
//  FlickrAPI.h
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrFetchRequestDelegate.h"

// Constants
#define MAX_FETCH_LIMIT     1000
#define DEFAULT_FETCH_LIMIT 10

// ENUM for the type of request
typedef enum _FlickrRequestType{
    FlickrRequestTypeInteresting = 1,
    FlickrRequestTypeRecent = 2
} FlickrRequestType;


@interface FlickrAPI : NSObject


// Constructors
// init with type
-(id) initWithRequestType : (FlickrRequestType) aRequestType;
-(id) initWithRequestType : (FlickrRequestType) aRequestType andFetchLimit: (NSUInteger)aFetchLimit;

// Properties

// Get/Set the fetch limit. i.e number of photos in a single batch.
// Restricted to 1000 photos
// Default is 10
@property (nonatomic, assign) NSUInteger fetchLimit;

// Read only fetch typ
@property (nonatomic, assign, readonly) FlickrRequestType requestType;

// Delegate to send the data back to the controller
@property (nonatomic, weak) id<FlickrFetchRequestDelegate> delegate;

// Class methods

// The API key required to fetch the photos
+(void) registerAPIKey:(NSString*)apikey;

// public API methods

// Start the fetch request
-(void) startFetching : (NSError**)error;

@end
