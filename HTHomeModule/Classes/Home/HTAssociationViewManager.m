//
//  HTAssociationViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTAssociationViewManager.h"

@implementation HTAssociationViewManager

+ (UILabel *)lgjeropj_searchLabel
{
    return [HTKitCreate ht_labelWithText:AsciiString(@"Search") andFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)] andTextColor:[UIColor colorWithHexString:@"#29D3EA"] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UITableView *)lgjeropj_tableView:(id)target {
    
    UITableView *view = [HTKitCreate ht_tableViewWithDelegate:target style:UITableViewStylePlain];
    view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    view.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    view.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    view.rowHeight = 45;
    [view registerClass:[HTSearchAssociationCell class] forCellReuseIdentifier:NSStringFromClass([HTSearchAssociationCell class])];
    return view;
}

+ (void)lgjeropj_getAssociationWordsWithRequest:(NSString *)keyword completion:(BLOCK_dataBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *tmpStr = AsciiString(@"https://suggestqueries.google.com/complete/search?client=youtube&q=");
        NSString *URLString = [NSString stringWithFormat:@"%@%@",tmpStr,keyword];
        URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:URLString];
        NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
        NSString *useragentStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_userAgent"];
        [urlrequest setValue:useragentStr forHTTPHeaderField:@"User-Agent"];
        urlrequest.HTTPMethod = @"GET";
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlrequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (result) {
                    NSString *ghlleeStr = AsciiString(@"(");
                    NSRange range = [result rangeOfString:ghlleeStr];
                    NSMutableArray *array = [NSMutableArray array];
                    if (range.location != NSNotFound && result.length > range.location + 2) {
                        NSString *tmpStr = [result substringWithRange:NSMakeRange(range.location +1, result.length -range.location -2)];
                        if (tmpStr.length > 0) {
                            NSData *jsonData = [tmpStr dataUsingEncoding:NSUTF8StringEncoding];
                            NSError *error;
                            NSArray *jsonArr = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                            if(!error) {
                                if (jsonArr.count > 2) {
                                    NSArray *wordsArr = [jsonArr objectAtIndex:1];
                                    for (NSArray *tmp in wordsArr) {
                                        NSString *wordStr = tmp.firstObject;
                                        [array addObject:wordStr];
                                    }
                                    if (completion) {
                                        completion(array);
                                    }
                                }
                            }
                        }
                    }
                }

            }
        }];
        [dataTask resume];
    });
}

@end
