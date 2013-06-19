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

@interface RFViewController (){
    UIView *blockview, *progressBar;
}
@end

@implementation RFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, 320, 680)];
    [self.view setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:204.0/255.0 blue:219.0/255.0 alpha:1.0]];
    [self uploadPhotoToServer:@"upload.png"];
    
    [self setupProgressbar];
}

-(void) setupProgressbar {
    
    blockview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 10, 20)];
    [self.view addSubview:blockview];
    [blockview setBackgroundColor:[UIColor clearColor]];
    [[blockview layer] setBorderColor:[UIColor blackColor].CGColor];
    [[blockview layer] setBorderWidth:3.0f];
    [blockview setCenter:self.view.center];
    
    progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 18)];
    [progressBar setBackgroundColor:[UIColor redColor]];
    [blockview addSubview:progressBar];
    
}

-(void) uploadPhotoToServer:(NSString*) path {
    
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://172.22.4.203:8888"]];
    NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/videograms/upload.php" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                      {
                                        UIImage *image = [UIImage imageNamed:path];
                                        NSData *photoData = UIImageJPEGRepresentation(image, 1.0);
                                        [formData appendPartWithFileData:photoData name:@"file" fileName:path mimeType:@"image/jpeg"];
                                      }];
    
    __block int countr = 10;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        double val = (totalBytesWritten / totalBytesExpectedToWrite) * 100;
        NSLog(@"Sent %lld of %lld bytes percent %lld", totalBytesWritten, totalBytesExpectedToWrite, (totalBytesWritten / totalBytesExpectedToWrite) * 100);
        [UIView animateWithDuration:0.15f animations:^{
            
            [progressBar setFrame:CGRectMake(0, 0, countr, 18)];
            
        }];
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
