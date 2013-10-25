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
    [api fetchPhotosWithSuccess:^(PageIndex pageIndex, NSArray *photos) {
        XCTAssertTrue(NO, @"Request Type is defined");
    } failure:^(PageIndex pageIndex, NSError *error) {
        XCTAssertTrue(YES, @"Request Type is not defined");
    }];
}

- (void)testNoAPIKeySet
{
    //[FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    [api fetchPhotosWithSuccess:^(PageIndex pageIndex, NSArray *photos) {
        XCTAssertTrue(NO, @"API Key is defined");
    } failure:^(PageIndex pageIndex, NSError *error) {
        XCTAssertTrue(YES, @"API Key not defined");
    }];
}

- (void)testDelegateSet
{
    [FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    api.delegate = self;
    [(FlickrAPITest*)api setShowSuccess:YES];
    [api fetchPhotosWithSuccess:^(PageIndex pageIndex, NSArray *photos) {
        XCTAssertTrue(pageIndex.pageNumber == 5, @"Delegate is set");
    } failure:^(PageIndex pageIndex, NSError *error) {
        ;
    }];
    
}

- (void)testSuccessBlock
{
    self.succes = self.failure = NO;
    [FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    [(FlickrAPITest*)api setShowSuccess:YES];
    [api fetchPhotosWithSuccess:^(PageIndex pageIndex, NSArray *photos) {
        XCTAssertTrue(photos.count == 2, @"Success was called");
    } failure:^(PageIndex pageIndex, NSError *error) {
        XCTAssertTrue(NO, @"Success was not called");;
    }];
}

- (void)testFailureBlock
{
    self.succes = self.failure = NO;
    [FlickrAPITest registerAPIKey:@"Somekey"];
    FlickrAPI* api = [[FlickrAPITest alloc] initWithRequestType:FlickrRequestTypeInteresting];
    [(FlickrAPITest*)api setShowError:YES];
    [api fetchPhotosWithSuccess:^(PageIndex pageIndex, NSArray *photos) {
        XCTAssertTrue(YES, @"Failure was not called");
    } failure:^(PageIndex pageIndex, NSError *error) {
        XCTAssertTrue(error != nil, @"Failure was called");;
    }];
}

-(NSUInteger) pageNumberForFetchRequest{
    return 5;
}

@end
