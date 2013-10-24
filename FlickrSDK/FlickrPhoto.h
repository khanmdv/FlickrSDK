//
//  FlickrPhoto.h
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FlickrPhoto : NSObject

@property (nonatomic, strong) NSString* photoId;
@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* completeUrl;

-(id) initWithDictionary: (NSDictionary*) photoDict;
+(NSArray*) photosWithArray: (NSArray*) photos;

@end
