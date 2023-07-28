

#import "HTFileLoadOperation.h"


NS_ASSUME_NONNULL_BEGIN

static NSString * STATIC_kCompletedCallbackKey = @"var_completed";

typedef NSMutableDictionary<NSString *, id> var_HTCallbacksDictionary;

@interface HTFileLoadOperation ()

@property (strong, nonatomic, nonnull) NSMutableArray<var_HTCallbacksDictionary *> *callbackBlocks;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

// This is weak because it is injected by whoever manages this session. If this gets nil-ed out, we won't be able to run
// the task associated with this operation
@property (weak, nonatomic, nullable) NSURLSession *var_unownedSession;
// This is set if we're using not using an injected NSURLSession. We're responsible of invalidating this one
@property (strong, nonatomic, nullable) NSURLSession *var_ownedSession;

@property (strong, nonatomic, nullable) dispatch_queue_t var_barrierQueue;

@property (assign, nonatomic) UIBackgroundTaskIdentifier var_taskId;

@property (assign, nonatomic) long long totalBytesWritten;
@property (assign, nonatomic) long long totalBytesExpectedToWrite;

@property (strong, nonatomic) HTFileLoadReceipt *var_receipt;
@end

@implementation HTFileLoadOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (HTFileLoadReceipt *)var_receipt {
    
    if (_var_receipt == nil) {
        _var_receipt = [[HTFileLoader sharedFileloader] ht_fileloadReceiptForURLString:self.var_request.URL.absoluteString];
    }
    return _var_receipt;
}

- (nonnull instancetype)init
{
    return [self initWithRequest:nil inSession:nil];
}

- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request inSession:(nullable NSURLSession *)session
{
    if ((self = [super init])) {
        self.var_request = [request copy];
        _callbackBlocks = [NSMutableArray new];
        _executing = NO;
        _finished = NO;
        self.var_unownedSession = session;
        self.var_barrierQueue = dispatch_queue_create("var_HTFileLoaderOperationBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        
        [self.var_receipt setState:ENUM_HTFileloadStateWillResume];
    }
    return self;
}

- (nullable id)lgjeropj_addHandlersCompleted:(nullable BLOCK_HTFileloaderCompletedBlock)completedBlock
{
    var_HTCallbacksDictionary *callbacks = [NSMutableDictionary new];
    if (completedBlock) callbacks[STATIC_kCompletedCallbackKey] = [completedBlock copy];
    dispatch_barrier_async(self.var_barrierQueue, ^{
        [self.callbackBlocks addObject:callbacks];
    });
    return callbacks;
}

- (nullable NSArray<id> *)lgjeropj_callbacksForKey:(NSString *)key
{
    __block NSMutableArray<id> *callbacks = nil;
    dispatch_sync(self.var_barrierQueue, ^{
        callbacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
        [callbacks removeObjectIdenticalTo:[NSNull null]];
    });
    return [callbacks copy];
}

- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self lgjeropj_reset];
            return;
        }
        @weakify(self);
        self.var_taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            @strongify(self);
            if (self) {
                [self cancel];
                [[UIApplication sharedApplication] endBackgroundTask:self.var_taskId];
                self.var_taskId = UIBackgroundTaskInvalid;
            }
        }];
        
        NSURLSession *session = self.var_unownedSession;
        if (!self.var_unownedSession) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 15;
            self.var_ownedSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            session = self.var_ownedSession;
        }
        self.var_dataTask = [session dataTaskWithRequest:self.var_request];
        self.executing = YES;
    }
    
    [self.var_dataTask resume];
    
    if (self.var_dataTask) {
        [self.var_receipt setState:ENUM_HTFileloadStateFileloading];
    } else {
        NSString *message = AsciiString(@"Connection can't be initialized");
        [self lgjeropj_callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : message}]];
    }
    
    if (self.var_taskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.var_taskId];
        self.var_taskId = UIBackgroundTaskInvalid;
    }
}

- (void)cancel {
    @synchronized (self) {
        [self lgjeropj_cancelInternal];
    }
}

- (void)lgjeropj_cancelInternal {
    if (self.isFinished) return;
    [super cancel];
    
    if (self.var_dataTask) {
        [self.var_dataTask cancel];
        [self.var_receipt setState:ENUM_HTFileloadStateNone];
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    [self lgjeropj_reset];
}

- (void)lgjeropj_done {
    self.finished = YES;
    self.executing = NO;
    [self lgjeropj_reset];
}

- (void)lgjeropj_reset {
    dispatch_barrier_async(self.var_barrierQueue, ^{
        [self.callbackBlocks removeAllObjects];
    });
    self.var_dataTask = nil;
    if (self.var_ownedSession) {
        [self.var_ownedSession invalidateAndCancel];
        self.var_ownedSession = nil;
    }
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:AsciiString(@"isFinished")];
    _finished = finished;
    [self didChangeValueForKey:AsciiString(@"isFinished")];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:AsciiString(@"isExecuting")];
    _executing = executing;
    [self didChangeValueForKey:AsciiString(@"isExecuting")];
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode < 400 && ((NSHTTPURLResponse *)response).statusCode != 304)) {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        HTFileLoadReceipt *receipt = [[HTFileLoader sharedFileloader] ht_fileloadReceiptForURLString:self.var_request.URL.absoluteString];
        [receipt setTotalBytesExpectedToWrite:expected + receipt.totalBytesWritten];
        receipt.date = [NSDate date];
        self.response = response;
    } else if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode == 416)) {
        [self lgjeropj_callCompletionBlocksWithFileURL:[NSURL fileURLWithPath:self.var_receipt.filePath] data:[NSData dataWithContentsOfFile:self.var_receipt.filePath] error:nil finished:YES];
        [self lgjeropj_done];
    } else {
        NSUInteger code = ((NSHTTPURLResponse *)response).statusCode;
        if (code == 304) {
            [self lgjeropj_cancelInternal];
        } else {
            [self.var_dataTask cancel];
            [self.var_receipt setState:ENUM_HTFileloadStateNone];
        }
        [self lgjeropj_callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:((NSHTTPURLResponse *)response).statusCode userInfo:nil]];
        [self.var_receipt setState:ENUM_HTFileloadStateNone];
        [self lgjeropj_done];
    }
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
  
    __block NSError *error = nil;
    HTFileLoadReceipt *receipt = [[HTFileLoader  sharedFileloader] ht_fileloadReceiptForURLString:self.var_request.URL.absoluteString];
    NSDate *currentDate = [NSDate date];
    if ([currentDate timeIntervalSinceDate:receipt.date] >= 1) {
        receipt.date = currentDate;
    }
    NSInputStream *inputStream =  [[NSInputStream alloc] initWithData:data];
    NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:[NSURL fileURLWithPath:receipt.filePath] append:YES];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    while ([inputStream hasBytesAvailable] && [outputStream hasSpaceAvailable])
    {
        uint8_t buffer[1024];
        NSInteger bytesRead = [inputStream read:buffer maxLength:1024];
        if (inputStream.streamError || bytesRead < 0) {
            error = inputStream.streamError;
            break;
        }
        NSInteger bytesWritten = [outputStream write:buffer maxLength:(NSUInteger)bytesRead];
        if (outputStream.streamError || bytesWritten < 0) {
            error = outputStream.streamError;
            break;
        }
        if (bytesRead == 0 && bytesWritten == 0) {
            break;
        }
    }
    [outputStream close];
    [inputStream close];
    receipt.progress.totalUnitCount = receipt.totalBytesExpectedToWrite;
    receipt.progress.completedUnitCount = receipt.totalBytesWritten;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    NSCachedURLResponse *cachedResponse = proposedResponse;
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    @synchronized(self) {
        self.var_dataTask = nil;
    }
    if (error) {
        [self lgjeropj_callCompletionBlocksWithError:error];
    } else {
        HTFileLoadReceipt *receipt = self.var_receipt;
        [receipt setState:ENUM_HTFileloadStateCompleted];
        if ([self lgjeropj_callbacksForKey:STATIC_kCompletedCallbackKey].count > 0) {
            
            [self lgjeropj_callCompletionBlocksWithFileURL:[NSURL fileURLWithPath:receipt.filePath] data:[NSData dataWithContentsOfFile:receipt.filePath] error:nil finished:YES];

        }
        dispatch_main_async_safe(^{
            if (self.var_receipt.completedBlock) {
                self.var_receipt.completedBlock(receipt, nil, YES);
            }
        });
    }
    [self lgjeropj_done];
}

- (void)lgjeropj_callCompletionBlocksWithError:(nullable NSError *)error
{
    [self lgjeropj_callCompletionBlocksWithFileURL:nil data:nil error:error finished:YES];
}

- (void)lgjeropj_callCompletionBlocksWithFileURL:(nullable NSURL *)fileURL data:(nullable NSData *)data error:(nullable NSError *)error finished:(BOOL)finished {
    
    if (error) {
        [self.var_receipt setState:ENUM_HTFileloadStateFailed];
    } else {
        [self.var_receipt setState:ENUM_HTFileloadStateCompleted];
    }
    NSArray *var_completionBlocks = [self lgjeropj_callbacksForKey:STATIC_kCompletedCallbackKey];
    dispatch_main_async_safe(^{
        for (BLOCK_HTFileloaderCompletedBlock completedBlock in var_completionBlocks) {
            completedBlock(self.var_receipt, error, finished);
        }
        if (self.var_receipt.completedBlock) {
            self.var_receipt.completedBlock(self.var_receipt, error, YES);
        }
    });
}

- (NSString*)lgjeropj_formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

@end


NS_ASSUME_NONNULL_END
