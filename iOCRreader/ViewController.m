//
//  ViewController.m
//  iOCRreader
//
//  Created by Rajesh on 6/18/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "ViewController.h"
#import "Connection.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadData
{
    [Connection uploadFileWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"png"]] block:^(FileUpload *objFileUpload) {
        if (objFileUpload.strError.length)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:objFileUpload.strError preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (objFileUpload.bStatus)
        {
            NSLog(@"%@",objFileUpload);
            [Connection recognizeDataWithFileId:objFileUpload.strFileId pages:objFileUpload.strPages language:@"eng" rotationAngle:@"0" block:^(Result *objResult) {
                if (objResult.strError.length)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:objFileUpload.strError preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else if (objResult.bStatus)
                {
                    NSLog(@"%@",objResult);
                }
            }];
        }
    }];
}

@end
