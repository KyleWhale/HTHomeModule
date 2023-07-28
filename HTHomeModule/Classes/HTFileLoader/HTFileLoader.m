

#import "HTFileLoader.h"
#import "HTFileLoadOperation.h"
#import "HTFileLoadReceipt.h"

static NSString * STATIC_HTFileloadCacheFolderName = @"var_fileLoadCache";

static NSString * STATIC_cacheFolderPath;

NSString * lgjeropj_cacheFolder(void) {
    
    if (!STATIC_cacheFolderPath) {
        NSString *var_cacheString = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        STATIC_cacheFolderPath = [var_cacheString stringByAppendingPathComponent:STATIC_HTFileloadCacheFolderName];
        NSFileManager *var_manager = [NSFileManager defaultManager];
        NSError *error = nil;
        if(![var_manager createDirectoryAtPath:STATIC_cacheFolderPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", STATIC_cacheFolderPath);
            STATIC_cacheFolderPath = nil;
        }
    }
    return STATIC_cacheFolderPath;
}

static void var_clearCacheFolder(void) {
    STATIC_cacheFolderPath = nil;
}

static NSString * var_receiptsPath(void) {
    return [lgjeropj_cacheFolder() stringByAppendingPathComponent:AsciiString(@"receipts.data")];
}

@interface HTFileLoader() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic, nonnull) NSOperationQueue *fileloadQueue;
@property (weak, nonatomic, nullable) NSOperation *lastAddedOperation;
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, HTFileLoadOperation *> *URLOperations;
// This queue is used to serialize the handling of the network responses of all the fileload operation in a single queue
@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;
// The session in which data tasks will run
@property (strong, nonatomic) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *allFileloadReceipts;
@property (assign, nonatomic) UIBackgroundTaskIdentifier var_taskId;

@end

@implementation HTFileLoader

- (NSMutableDictionary *)allFileloadReceipts {
    
    if (_allFileloadReceipts == nil) {
        NSDictionary *receipts = [NSKeyedUnarchiver unarchiveObjectWithFile:var_receiptsPath()];
        _allFileloadReceipts = receipts != nil ? receipts.mutableCopy : [NSMutableDictionary dictionary];
    }
    return _allFileloadReceipts;
}

+ (nonnull instancetype) sharedFileloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (nonnull instancetype)init {
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration {
    if ((self = [super init])) {

        _fileloadQueue = [NSOperationQueue new];
        _fileloadQueue.maxConcurrentOperationCount = 3;
        _fileloadQueue.name = @"var_HTFileLoader";
        _URLOperations = [NSMutableDictionary new];
        _barrierQueue = dispatch_queue_create("var_BarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        sessionConfiguration.timeoutIntervalForRequest = 15.0;
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 10;
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

#pragma mark -  NSNotification
- (void)lgjeropj_applicationWillTerminate:(NSNotification *)sender
{
    [self lgjeropj_setAllStateToNone];
    [self lgjeropj_saveAllFileloadReceipts];
}

- (void)lgjeropj_applicationDidReceiveMemoryWarning:(NSNotification *)sender
{
    [self lgjeropj_saveAllFileloadReceipts];
}

- (void)lgjeropj_applicationWillResignActive:(NSNotification *)sender
{
    [self lgjeropj_saveAllFileloadReceipts];
    /// 捕获到失去激活状态后
    NSString *message1 = AsciiString(@"UIApplication");
    Class UIApplicationClass = NSClassFromString(message1);
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    if (hasApplication ) {
        @weakify(self);
        UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
        self.var_taskId = [app beginBackgroundTaskWithExpirationHandler:^{
            @strongify(self);
            if (self) {
                [self lgjeropj_setAllStateToNone];
                [self lgjeropj_saveAllFileloadReceipts];
                [app endBackgroundTask:self.var_taskId];
                self.var_taskId = UIBackgroundTaskInvalid;
            }
        }];
    }
}

- (void)lgjeropj_applicationDidBecomeActive:(NSNotification *)sender
{
    NSString *message1 = AsciiString(@"UIApplication");
    Class UIApplicationClass = NSClassFromString(message1);
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.var_taskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.var_taskId];
        self.var_taskId = UIBackgroundTaskInvalid;
    }
}

- (void)lgjeropj_setAllStateToNone {
    [self.allFileloadReceipts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[HTFileLoadReceipt class]]) {
            HTFileLoadReceipt *receipt = obj;
            if (receipt.state != ENUM_HTFileloadStateCompleted) {
                [receipt setState:ENUM_HTFileloadStateNone];
            }
        }
    }];
}

- (void)lgjeropj_saveAllFileloadReceipts
{
    [NSKeyedArchiver archiveRootObject:self.allFileloadReceipts toFile:var_receiptsPath()];
}

- (void)dealloc
{
    [self.session invalidateAndCancel];
    self.session = nil;
    [self.fileloadQueue cancelAllOperations];
}

- (nullable HTFileLoadReceipt *)ht_loadDataWithURL:(nullable NSURL *)url andCompleted:(nullable BLOCK_HTFileloaderCompletedBlock)completedBlock
{
    @weakify(self);
    HTFileLoadReceipt *receipt = [self ht_fileloadReceiptForURLString:url.absoluteString];
    if (receipt.state == ENUM_HTFileloadStateCompleted) {
        dispatch_main_async_safe(^{
            if (completedBlock) {
                completedBlock(receipt ,nil ,YES);
            }
            if (receipt.completedBlock) {
                receipt.completedBlock(receipt, nil, YES);
            }
        });
        return receipt;
    }
    
    return [self lgjeropj_addCompletionCallback:completedBlock forURL:url createback:^HTFileLoadOperation *{
        @strongify(self);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        HTFileLoadReceipt *receipt = [self ht_fileloadReceiptForURLString:url.absoluteString];
        if (receipt.totalBytesWritten > 0) {
            NSString *range = [NSString stringWithFormat:AsciiString(@"bytes=%zd-"), receipt.totalBytesWritten];
            [request setValue:range forHTTPHeaderField:AsciiString(@"Range")];
        }
        request.HTTPShouldUsePipelining = YES;
        HTFileLoadOperation *operation = [[HTFileLoadOperation alloc] initWithRequest:request inSession:self.session];
        [self.fileloadQueue addOperation:operation];
        return operation;
    }];
}

- (HTFileLoadReceipt *)ht_fileloadReceiptForURLString:(NSString *)string
{
    if (string == nil) {
        return nil;
    }
    if (self.allFileloadReceipts[string]) {
        return self.allFileloadReceipts[string];
    } else {
        HTFileLoadReceipt *receipt = [[HTFileLoadReceipt alloc] initWithString:string andCancelToken:nil andCompletedBlock:nil];
        self.allFileloadReceipts[string] = receipt;
        return receipt;
    }
    return nil;
}

- (nullable HTFileLoadReceipt *)lgjeropj_addCompletionCallback:(BLOCK_HTFileloaderCompletedBlock)completedBlock forURL:(nullable NSURL *)url createback:(HTFileLoadOperation *(^)(void))createback {
    // The URL will be used as the key to the callbacks dictionary so it cannot be nil. If it is nil immediately call the completed block with no image or data.
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, NO);
        }
        return nil;
    }
    
    __block HTFileLoadReceipt *var_token = nil;
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        HTFileLoadOperation *operation = self.URLOperations[url];
        if (!operation) {
            operation = createback();
            self.URLOperations[url] = operation;
            
            __weak HTFileLoadOperation *var_woperation = operation;
            operation.completionBlock = ^{
                HTFileLoadOperation *soperation = var_woperation;
                if (!soperation) return;
                if (self.URLOperations[url] == soperation) {
                    [self.URLOperations removeObjectForKey:url];
                };
            };
        }
        id var_Token1 = [operation lgjeropj_addHandlersCompleted:completedBlock];
        
        if (!self.allFileloadReceipts[url.absoluteString]) {
            var_token = [[HTFileLoadReceipt alloc] initWithString:url.absoluteString andCancelToken:var_Token1 andCompletedBlock:completedBlock];
            self.allFileloadReceipts[url.absoluteString] = var_token;
        }else {
            var_token = self.allFileloadReceipts[url.absoluteString];
            if (!var_token.completedBlock) {
                [var_token setCompletedBlock:completedBlock];
            }
            
            if (!var_token.cancelToken) {
                [var_token setCancelToken:var_Token1];
            }
        }

    });
    return var_token;
}

- (HTFileLoadOperation *)lgjeropj_operationWithTask:(NSURLSessionTask *)task
{
    HTFileLoadOperation *var_returnOperation = nil;
    for (HTFileLoadOperation *operation in self.fileloadQueue.operations) {
        if (operation.var_dataTask.taskIdentifier == task.taskIdentifier) {
            var_returnOperation = operation;
            break;
        }
    }
    return var_returnOperation;
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    // Identify the operation that runs this task and pass it the delegate method
    HTFileLoadOperation *dataOperation = [self lgjeropj_operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // Identify the operation that runs this task and pass it the delegate method
    HTFileLoadOperation *dataOperation = [self lgjeropj_operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    // Identify the operation that runs this task and pass it the delegate method
    HTFileLoadOperation *dataOperation = [self lgjeropj_operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // Identify the operation that runs this task and pass it the delegate method
    HTFileLoadOperation *dataOperation = [self lgjeropj_operationWithTask:task];
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}

@end
