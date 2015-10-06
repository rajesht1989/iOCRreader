//
//  ViewController.m
//  iOCRreader
//
//  Created by Rajesh on 6/18/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "ViewController.h"
#import "Connection.h"
#import "SendingIndicatorView.h"
#import "OCRdisplayViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIImageView *imageView;
    SendingIndicatorView *sendingIndicator;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    sendingIndicator = [[SendingIndicatorView alloc] initWithFrame:self.view.bounds andIndicationColor:[UIColor greenColor]];
    [sendingIndicator setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:sendingIndicator];
//    [self loadData];
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
- (IBAction)btnCameraTapped:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (IBAction)btnPhotoTapped:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [sendingIndicator startAnimating];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [Connection uploadFileWithData:UIImageJPEGRepresentation(image, 0.5f) block:^(FileUpload *objFileUpload) {
        if (objFileUpload.strError.length)
        {
            [sendingIndicator stopAnimating];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:objFileUpload.strError preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (objFileUpload.bStatus)
        {
            [Connection recognizeDataWithFileId:objFileUpload.strFileId pages:objFileUpload.strPages language:@"eng" rotationAngle:@"0" block:^(Result *objResult) {
                if (objResult.strError.length)
                {
                    [sendingIndicator stopAnimating];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:objFileUpload.strError preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else if (objResult.bStatus) 
                {
                    [sendingIndicator stopAnimating];
                    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"OCRdisplayNavigationController"];
                    OCRdisplayViewController *displayViewController = navigationController.viewControllers[0];
                    [(UITextView *)[displayViewController view] setText:objResult.strText];
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
            }];
        }
    }];
}

@end
