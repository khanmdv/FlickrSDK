//
//  FlickrPhoto.m
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "FlickrPhoto.h"

NSString* const completeUrlStr = @"http://farm%@.staticflickr.com/%@/%@_%@.jpg";
NSString* const thumbnailUrl = @"http://farm%@.staticflickr.com/%@/%@_%@_t_d.jpg";

@implementation FlickrPhoto

-(id) initWithDictionary: (NSDictionary*) photoDict{
    if (self = [super init]){
        if (photoDict != nil){
            self.photoId = photoDict[@"id"];
            self.thumbnailUrl = [NSString stringWithFormat:thumbnailUrl, photoDict[@"farm"], photoDict[@"server"], self.photoId, photoDict[@"secret"]];
            self.completeUrl = [NSString stringWithFormat:completeUrlStr, photoDict[@"farm"], photoDict[@"server"], self.photoId, photoDict[@"secret"]];
        }
    }
    return self;
}

+(NSArray*) photosWithArray: (NSArray*) photos{
    NSMutableArray* array = [NSMutableArray array];
    if (photos != nil && photos.count > 0){
        for (NSDictionary* photoDict in photos){
            FlickrPhoto* photo = [[FlickrPhoto alloc] initWithDictionary:photoDict];
            [array addObject:photo];
        }
    }
    return array;
}

@end
