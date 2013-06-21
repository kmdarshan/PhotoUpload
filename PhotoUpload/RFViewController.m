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
    
    blockview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 10)];
    [self.view addSubview:blockview];
    [blockview setBackgroundColor:[UIColor lightGrayColor]];
    [[blockview layer] setBorderColor:[UIColor blackColor].CGColor];
    [[blockview layer] setCornerRadius:5.0f];
    [[blockview layer] setBorderWidth:1.0f];
    [blockview setCenter:self.view.center];
    
    progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 9)];
    [[progressBar layer] setCornerRadius:5.0f];
    [progressBar setBackgroundColor:[UIColor whiteColor]];
    [blockview addSubview:progressBar];
    
}

-(void) uploadPhotoToServer:(NSString*) path {
    
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.kmdarshan.com"]];
    NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/videograms/upload.php" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                      {
                                        UIImage *image = [UIImage imageNamed:path];
                                        NSData *photoData = UIImageJPEGRepresentation(image, 1.0);
                                        [formData appendPartWithFileData:photoData name:@"file" fileName:path mimeType:@"image/jpeg"];
                                      }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {

        NSDecimalNumber *hundredNumber = [[NSDecimalNumber alloc] initWithInt:100];
        NSDecimalNumber *dnumber = [[NSDecimalNumber alloc] initWithUnsignedLong:totalBytesExpectedToWrite];
        NSDecimalNumber *vnumber = [[NSDecimalNumber alloc] initWithUnsignedLong:totalBytesWritten];
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           decimalNumberHandlerWithRoundingMode:NSRoundUp
                                           scale:0
                                           raiseOnExactness:NO
                                           raiseOnOverflow:NO
                                           raiseOnUnderflow:NO
                                           raiseOnDivideByZero:YES];
        NSDecimalNumber *finalnumber = [[vnumber decimalNumberByDividingBy:dnumber] decimalNumberByMultiplyingBy:hundredNumber withBehavior:roundUp];
        [UIView animateWithDuration:1.0f animations:^{
            int percentProgressBar = blockview.frame.size.width * [finalnumber intValue] / 100;
            [progressBar setFrame:CGRectMake(0, 0, percentProgressBar, progressBar.frame.size.height)];
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
