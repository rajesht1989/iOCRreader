//
//  Connection.h
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCRreader : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithError:(NSError *)error;
@property (nonatomic,strong)NSString *strError;

@end

@interface FileUpload : OCRreader
@property (nonatomic,strong)NSString *strFileId;
@property (nonatomic,strong)NSString *strPages;
@property (nonatomic,assign)BOOL bStatus;
@end

@interface Result : OCRreader
@property (nonatomic,assign)BOOL bStatus;
@property (nonatomic,strong)NSString *strText;
@end

typedef void (^completionFileUpload)(FileUpload *objFileUpload);
typedef void (^completionResult)(Result *objResult);

@interface Connection : NSObject

+ (void)uploadFileWithData:(NSData *)data block:(completionFileUpload)completion;
+ (void)recognizeDataWithFileId:(NSString *)strFileId pages:(NSString *)strPages language:(NSString *)strLanguage rotationAngle:(NSString *)strAngle block:(completionResult)completion;

@end


