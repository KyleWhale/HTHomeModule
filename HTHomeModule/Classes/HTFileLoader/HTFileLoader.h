//
//  HTFileLoader.h
//  
//
//  Created by M.C on 17/4/6. (QQ:714080794 Gmail:chaoma0609@gmail.com)
//  Copyright © 2017年 qikeyun. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
#import <Foundation/Foundation.h>
#import "HTFileLoadReceipt.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Use dispatch_main_async_safe instead of dispatch_async(dispatch_get_main_queue(), block)
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif



FOUNDATION_EXPORT NSString * lgjeropj_cacheFolder(void);


@interface HTFileLoader : NSObject

+ (nonnull instancetype)sharedFileloader;
 
- (nullable HTFileLoadReceipt *)ht_loadDataWithURL:(nullable NSURL *)url andCompleted:(nullable BLOCK_HTFileloaderCompletedBlock)completedBlock;

- (nullable HTFileLoadReceipt *)ht_fileloadReceiptForURLString:(nullable NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
