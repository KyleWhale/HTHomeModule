

#import "HTFileLoadReceipt.h"
#import <CommonCrypto/CommonDigest.h>

extern NSString * lgjeropj_cacheFolder(void);

static unsigned long long filePath(NSString *path) {
    
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *var_fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && var_fileDict) {
            fileSize = [var_fileDict fileSize];
        }
    }
    return fileSize;
}

@interface HTFileLoadReceipt()

@end

@implementation HTFileLoadReceipt

- (NSString *)lgjeropj_getMD5String:(NSString *)str
{
    if (str == nil) return nil;
    
    const char *cstring = str.UTF8String;
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), bytes);
    
    NSMutableString *var_str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [var_str appendFormat:@"%02x", bytes[i]];
    }
    return var_str;
}

- (NSString *)filePath
{
    NSString *path = [lgjeropj_cacheFolder() stringByAppendingPathComponent:self.var_fileName];
    if (![path isEqualToString:_filePath] ) {
        if (_filePath && ![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            NSString *dir = [_filePath stringByDeletingLastPathComponent];
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _filePath = path;
    }
    
    return _filePath;
}

- (NSString *)var_fileName
{
    if (_var_fileName == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _var_fileName = [NSString stringWithFormat:@"%@.%@", [self lgjeropj_getMD5String:self.url], pathExtension];
        } else {
            _var_fileName = [self lgjeropj_getMD5String:self.url];
        }
    }
    return _var_fileName;
}

- (NSProgress *)progress
{
    if (_progress == nil) {
        _progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    }
    @try {
        _progress.totalUnitCount = self.totalBytesExpectedToWrite;
        _progress.completedUnitCount = self.totalBytesWritten;
    } @catch (NSException *exception) {
        
    }
    return _progress;
}

- (long long)totalBytesWritten
{
    return filePath(self.filePath);
}


- (instancetype)initWithURL:(NSString *)url
{
    if (self = [self init]) {
        self.url = url;
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:NSStringFromSelector(@selector(url))];
    [aCoder encodeObject:self.filePath forKey:NSStringFromSelector(@selector(filePath))];
    [aCoder encodeObject:@(self.state) forKey:NSStringFromSelector(@selector(state))];
    [aCoder encodeObject:self.var_fileName forKey:NSStringFromSelector(@selector(var_fileName))];
    [aCoder encodeObject:@(self.totalBytesWritten) forKey:NSStringFromSelector(@selector(totalBytesWritten))];
    [aCoder encodeObject:@(self.totalBytesExpectedToWrite) forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(url))];
        self.filePath = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filePath))];
        self.state = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(state))] unsignedIntegerValue];
        self.var_fileName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(var_fileName))];
        self.totalBytesWritten = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesWritten))] unsignedIntegerValue];
        self.totalBytesExpectedToWrite = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))] unsignedIntegerValue];
        
    }
    return self;
}


- (nonnull instancetype)initWithString:(nonnull NSString *)string andCancelToken:(nullable id)var_token andCompletedBlock:(nullable BLOCK_HTFileloaderCompletedBlock)completedblock {
    
    if (self = [self init]) {
        
        self.url = string;
        self.totalBytesExpectedToWrite = 0;
        self.cancelToken = var_token;
        self.completedBlock = completedblock;
    }
    return self;
}

@end
