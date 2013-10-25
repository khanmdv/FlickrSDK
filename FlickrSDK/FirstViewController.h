//
//  FirstViewController.h
//  FlickrSDK
//
//  Created by Mohtashim Khan on 10/24/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetchRequestDelegate.h"

@interface FirstViewController : UIViewController <FlickrFetchRequestDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *photoTable;

@end
