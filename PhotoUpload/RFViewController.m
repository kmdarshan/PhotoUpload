//
//  RFViewController.m
//  PhotoUpload
//
//  Created by Darshan Katrumane on 6/18/13.
//  Copyright (c) 2013 Darshan Katrumane. All rights reserved.
//

#import "RFViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <QuartzCore/QuartzCore.h>

@interface RFViewController ()

@end

@implementation RFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, 320, 680)];
    [self.view setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:204.0/255.0 blue:219.0/255.0 alpha:1.0]];
    [self uploadPhotoToServer:@""];
}

-(void) uploadPhotoToServer:(NSString*) path {
    
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://172.22.4.203:8888"]];
    NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/videograms/upload.php" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                      {
                                        UIImage *image = [UIImage imageNamed:@"upload.png"];
                                        NSData *photoData = UIImageJPEGRepresentation(image, 1.0);
                                        [formData appendPartWithFileData:photoData name:@"image" fileName:path mimeType:@"image/jpeg"];
                                      }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success");
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@ %@ ",  operation.responseString, error);
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
