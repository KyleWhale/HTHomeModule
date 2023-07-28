

#import <Foundation/Foundation.h>
#import "HTFileLoader.h"

@interface HTFileLoadOperation : NSOperation <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic, nullable) NSURLRequest *var_request;

@property (strong, nonatomic, nullable) NSURLSessionTask *var_dataTask;

@property (strong, nonatomic, nullable) NSURLResponse *response;

- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request inSession:(nullable NSURLSession *)session NS_DESIGNATED_INITIALIZER;

- (nullable id)lgjeropj_addHandlersCompleted:(nullable BLOCK_HTFileloaderCompletedBlock)completedBlock;

@end
