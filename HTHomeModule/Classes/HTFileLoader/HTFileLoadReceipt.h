
#import <Foundation/Foundation.h>

@class HTFileLoadReceipt;

typedef void(^BLOCK_HTFileloaderCompletedBlock)(HTFileLoadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished);

@interface HTFileLoadReceipt : NSObject

@property (nonatomic, assign) ENUM_HTFileloadState state;

@property (nonatomic, copy, nonnull) NSString *url;

@property (nonatomic, copy, nonnull) NSString *filePath;

@property (nonatomic, copy, nullable) NSString *var_fileName;

@property (assign, nonatomic) long long totalBytesWritten;
@property (assign, nonatomic) long long totalBytesExpectedToWrite;

@property (nonatomic, strong, nullable) NSProgress *progress;

@property (nonatomic, strong, nullable) NSError *error;

@property (nonatomic,copy, nullable) BLOCK_HTFileloaderCompletedBlock completedBlock;

#pragma mark - Private Methods
- (nonnull instancetype)initWithString:(nonnull NSString *)string andCancelToken:(nullable id)var_token andCompletedBlock:(nullable BLOCK_HTFileloaderCompletedBlock)completedblock;

@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, strong, nullable) id cancelToken;

@end
