//
//  FirstViewController.m
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "FirstViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FlickrAPI.h"
#import "FlickrPhoto.h"

@interface FirstViewController ()

@property( nonatomic, strong) NSArray* photos;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [FlickrAPI registerAPIKey:@"d5c7df3552b89d13fe311eb42715b510"];
    FlickrAPI* api = [[FlickrAPI alloc] initWithRequestType:FlickrRequestTypeInteresting andFetchLimit:10];
    api.delegate = self;
    
    NSError* error;
    [api startFetching:&error];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didFinishFetchingPhotos: (NSArray*) aPhotos forPage :(PageIndex) pageIndex{
    self.photos = aPhotos;
    [self.photoTable reloadData];
}

-(void)didFinishWithError : (NSError*) error forPage: (PageIndex) pageIndex{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    FlickrPhoto * photo = self.photos[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:photo.thumbnailUrl]];
    return cell;
}


@end
