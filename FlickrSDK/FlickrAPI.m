//
//  FlickrAPI.m
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "FlickrAPI.h"
#import <AFNetworking.h>
#import "FlickrPhoto.h"

// Constants
NSString *const FlickrAPINoRequestTypeErrorDomain = @"FlickrAPINoRequestTypeErrorDomain";
NSUInteger const FlickrAPINoRequestTypeErrorCode = 100;

NSString *const FlickrAPIKEYNotSetDomain = @"FlickrAPIKEYNotSetDomain";
NSUInteger const FlickrAPIKEYNotSetErrorCode = 101;

NSString* const MostInterestingYQL = @"http://query.yahooapis.com/v1/public/yql?q=select * from flickr.photos.interestingness(%i,%i) where api_key='%@'&diagnostics=true&format=json";

NSString* const MostRecentYQL = @"http://query.yahooapis.com/v1/public/yql?q=select * from flickr.photos.recent(%i,%i) where api_key='%@'&diagnostics=true&format=json";


// Flickr API
@interface FlickrAPI ()

@property (nonatomic, assign) NSUInteger offset;

-(NSString*) buildURL;
-(NSURLRequest*) buildRequestWithURL : (NSString*) urlStr;
-(AFJSONRequestOperation*) buildAFJSONRequestOperationWithRequest : (NSURLRequest *)urlRequest
                                                           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end

@implementation FlickrAPI

static NSString* APIKEY;

@synthesize requestType=_requestType;

// Private Methods
-(NSString*) buildURL{
    NSString* yqlFormat = nil;
    
    switch(_requestType){
        case FlickrRequestTypeInteresting:
            yqlFormat = [NSString stringWithFormat:MostInterestingYQL, self.offset, self.fetchLimit, APIKEY];
            break;
        case FlickrRequestTypeRecent:
            yqlFormat = [NSString stringWithFormat:MostRecentYQL, self.offset, self.fetchLimit, APIKEY];
            break;
    }
    
    return [yqlFormat stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

-(NSURLRequest*) buildRequestWithURL : (NSString*) urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

-(AFJSONRequestOperation*) buildAFJSONRequestOperationWithRequest : (NSURLRequest *)urlRequest
                                                           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure{
    return [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:success failure:failure];
}

-(BOOL) requestTypeAvailable :(NSError**) error{
    if (_requestType == 0){
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Request Type is not set." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:FlickrAPINoRequestTypeErrorDomain code:FlickrAPINoRequestTypeErrorCode userInfo:errorDetail];
        return NO;
    }
    return YES;
}

-(BOOL) isAPIKeySet :(NSError**) error{
    if (APIKEY == nil){
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"API Key is not set." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:FlickrAPIKEYNotSetDomain code:FlickrAPIKEYNotSetErrorCode userInfo:errorDetail];
        return NO;
    }
    return YES;
}


// Constructors
// init with type
-(id) initWithRequestType : (FlickrRequestType) aRequestType{
    if (self = [super init]){
        _requestType = aRequestType;
        
        // Set the default fetch limit if not specified
        self.fetchLimit = DEFAULT_FETCH_LIMIT;
        self.offset = 0;
    }
    return self;
}

-(id) initWithRequestType : (FlickrRequestType) aRequestType andFetchLimit: (NSUInteger)aFetchLimit{
    if (self = [super init]){
        _requestType = aRequestType;
        
        if (aFetchLimit > MAX_FETCH_LIMIT){
            self.fetchLimit = DEFAULT_FETCH_LIMIT;
        }else{
            self.fetchLimit = aFetchLimit;
        }
        self.offset = 0;
    }
    return self;
}

// Class methods

// The API key required to fetch the photos
+(void) registerAPIKey:(NSString*)apikey{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        APIKEY = [apikey copy];
    });
}

// public API methods

// Start the fetch request
-(void) fetchPhotosWithSuccess : (SuccessBlock)success failure : (FailureBlock) failure{
    NSError* error;
    
    if ( ![self requestTypeAvailable:&error] || ![self isAPIKeySet:&error]){
        PageIndex pi = { self.offset, 0 };
        failure(pi, error);
        return;
    }
    
    // Check the page number the user wants to fetch
    if (self.delegate){
        self.offset = [self.delegate pageNumberForFetchRequest];
    }else{
        self.offset = 0;
    }
    
    NSString* urlStr = [self buildURL];
    NSURLRequest* request = [self buildRequestWithURL:urlStr];
    
    // The Success Handler
    void (^successBlock)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* query = (NSDictionary*) JSON[@"query"];
        NSDictionary* results = query[@"results"];
        NSArray* photos = results[@"photo"];
        
        NSArray* photosResult = [FlickrPhoto photosWithArray:photos];
        
        PageIndex pi;
        pi.pageNumber = self.offset;
        pi.count = [query[@"count"] integerValue];
        
        // Call the success block
        success(pi, photosResult);
    };
    
    // The Failure handler
    void (^failureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        PageIndex pi;
        pi.pageNumber = self.offset;
        pi.count = 0;
        failure(pi, error);
    };
    
    // Get the JSON operation request object
    AFJSONRequestOperation* jsonOperation = [self buildAFJSONRequestOperationWithRequest:request
                                                                                 success:successBlock
                                                                                 failure:failureBlock];
    // Send the JSON request
    [jsonOperation start];
}

@end
