//
//  FlickrSDKTests.m
//  FlickrSDKTests
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlickrAPITest.h"
#import "FlickrAPI.h"
#import "FlickrFetchRequestDelegate.h"

@interface FlickrSDKTests : XCTestCase<FlickrFetchRequestDelegate>

@property (nonatomic, assign) BOOL succes;
@property (nonatomic, assign) BOOL failure;

@end

@implementation FlickrSDKTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.succes = self.failure = NO;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNoRequestType
{
    [FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] init];
    NSError* err;
    [api startFetching:&err];
    XCTAssertTrue(err.code == 100, @"Request Type not defined");
}

- (void)testNoAPIKeySet
{
    //[FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    NSError* err;
    [api startFetching:&err];
    XCTAssertTrue(err.code == 101, @"API Key not defined");
}

- (void)testNoDelegateSet
{
    [FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    NSError* err;
    [api startFetching:&err];
    XCTAssertTrue(api.delegate == nil, @"Delegate is not set");
}

- (void)testSuccessBlock
{
    self.succes = self.failure = NO;
    [FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    [(FlickrAPITest*)api setShowSuccess:YES];
    NSError* err;
    api.delegate = self;
    [api startFetching:&err];
    XCTAssertTrue(self.succes, @"Delegate is not set");
}

- (void)testFailureBlock
{
    self.succes = self.failure = NO;
    [FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    [(FlickrAPITest*)api setShowError:YES];
    NSError* err;
    [api startFetching:&err];
    XCTAssertTrue(self.failure, @"Delegate is not set");
}

-(void)didFinishFetchingPhotos: (NSArray*) photos forPage :(PageIndex) pageIndex{
    self.succes = YES;
}

-(void)didFinishWithError : (NSError*) error forPage: (PageIndex) pageIndex{
    self.failure = YES;
}

@end
