//
//  Connection.m
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "Connection.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>

NSString * const apiKey = @"6e633cbc39635be277ccee2f76333d32";

@implementation Connection

+ (void)uploadFileWithData:(NSData *)data block:(completionFileUpload)completion;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.newocr.com/v1/upload?key=%@",apiKey]]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------41184676334";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"filename.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    [request setValue:@"29278" forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (connectionError)
            {
                completion([[FileUpload alloc] initWithError:connectionError]);
            }
            else
            {
                id objReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                completion([[FileUpload alloc] initWithDictionary:objReturn]);
            }
        });
    }];
}

+ (void)recognizeDataWithFileId:(NSString *)strFileId pages:(NSString *)strPages language:(NSString *)strLanguage rotationAngle:(NSString *)strAngle block:(completionResult)completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.newocr.com/v1/ocr?key=%@&file_id=%@&page=%@&lang=%@&psm=3&rotate=%@",apiKey,strFileId,strPages,strLanguage,strAngle]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (connectionError)
            {
                completion([[Result alloc] initWithError:connectionError]);
            }
            else
            {
                id objReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                completion([[Result alloc] initWithDictionary:objReturn]);
            }
        });
    }];
}

@end


@implementation OCRreader

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error
{
    if (self = [super init])
    {
        _strError = [error localizedDescription];
    }
    return self;
}

- (NSString *)description
{
    unsigned int varCount;
    NSMutableString *descriptionString = [[NSMutableString alloc]init];
    
    
    objc_property_t *vars = class_copyPropertyList(object_getClass(self), &varCount);
    
    for (int i = 0; i < varCount; i++)
    {
        objc_property_t var = vars[i];
        
        const char* name = property_getName (var);
        
        NSString *keyValueString = [NSString stringWithFormat:@"\n%@ = %@",[NSString stringWithUTF8String:name],[self valueForKey:[NSString stringWithUTF8String:name]]];
        [descriptionString appendString:keyValueString];
    }
    
    free(vars);
    return descriptionString;
}

@end

@implementation FileUpload

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        _bStatus = [[[dict objectForKey:@"status"] lowercaseString] isEqualToString:@"success"];
        if (_bStatus)
        {
            _strFileId = [dict valueForKeyPath:@"data.file_id"];
            _strPages = [dict valueForKeyPath:@"data.pages"];
        }
    }
    return self;
}

@end

@implementation Result

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        _bStatus = [[[dict objectForKey:@"status"] lowercaseString] isEqualToString:@"success"];
        if (_bStatus)
        {
            _strText = [dict valueForKeyPath:@"data.text"];
        }
        else
        {
            self.strError = [dict objectForKey:@"message"];
        }
    }
    return self;
}

@end
