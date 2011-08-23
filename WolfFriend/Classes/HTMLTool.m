//
//  HTMLTool.m
//  WolfFriend
//
//  Created by Jiang Chuncheng on 8/21/11.
//  Copyright 2011 SenseForce. All rights reserved.
//

#import "HTMLTool.h"
#import "ItemObject.h"

@implementation HTMLTool

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}



+ (NSInteger)parseSectionPageCountFromHTML:(NSString *)aHtml {
    NSInteger result = 0;
    NSScanner *aScanner;
    NSString *resultText = @"";
    aScanner = [NSScanner scannerWithString:aHtml];
    NSString *beginString = @"<strong>1</strong>&nbsp; <a href=\"index_";
    [aScanner scanUpToString:beginString intoString:NULL]; //你要找的起始字串
    [aScanner scanUpToString:@".html" intoString:&resultText]; //你要找的束结字串，中间的文字会放到text中
    if ([resultText length] > 0) {
        result = [[resultText substringFromIndex:[beginString length]] intValue] + 1;
    }
//    NSString *beginString = @"<a href=\"index_";
//    NSString *valueString = @"";
//    [aScanner scanUpToString:beginString intoString:NULL]; //你要找的起始字串
//    [aScanner scanUpToString:@"</a>" intoString:&resultText]; //你要找的束结字串，中间的文字会放到text中
//    if ([resultText length] > 0) {
//        valueString = [resultText substringFromIndex:[beginString length]];
//        if ([valueString length] <= 0) {
//            result = 1;
//        }
//        else {
//            if ([valueString intValue] == 0) {  //判断逻辑有误
//                beginString = resultText;
//                [aScanner scanUpToString:beginString intoString:NULL];
//                [aScanner scanUpToString:@".html" intoString:&resultText];
//                NSString *resultText2 = @"";
//                [aScanner scanUpToString:beginString intoString:NULL];
//                [aScanner scanUpToString:@"</a>" intoString:&resultText2];
//                result = [[resultText substringFromIndex:[beginString length]] intValue] + [[resultText2 substringFromIndex:[resultText2 length]-1] intValue];
//            }
//            else {
//                result = [valueString intValue] + 1;
//            }
//        }
//    }
    return result;
}

+ (NSMutableArray *)parseItemsArrayCountFromHTML:(NSString *)aHtml {
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    NSString *resourceString = aHtml;
    while (true) {
        NSScanner *aScanner;
        NSString *resultText = @"";
        aScanner = [NSScanner scannerWithString:resourceString];
        NSString *beginString = @"<img src=\"/templets/default/neisan.gif\"> <a href=\"";
        [aScanner scanUpToString:beginString intoString:NULL]; //你要找的起始字串
        [aScanner scanUpToString:@"</a>" intoString:&resultText]; //你要找的束结字串，中间的文字会放到text中
        if ([resultText length] > 0) {
            resultText = [resultText substringFromIndex:[beginString length]];
            NSArray *resultArray = [resultText componentsSeparatedByString:@"\" target=\"_blank\">"];
            if ([resultArray count] >= 2) {
                ItemObject *anItem = [[ItemObject alloc] init];
                anItem.url = [@"http://www.34eee.com" stringByAppendingString:[resultArray objectAtIndex:0]];
                anItem.title = [[resultArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                [itemsArray addObject:anItem];
            }
            
            resourceString = [[resourceString componentsSeparatedByString:resultText] objectAtIndex:1];
        }
        else {
            break;
        }
    }
        
    return  itemsArray;
}

+ (NSString *)parseImageBodyFromHtml:(NSString *)aHtml {
    NSScanner *aScanner;
    NSString *resultText = @"";
    aScanner = [NSScanner scannerWithString:aHtml];
    [aScanner scanUpToString:@"<td id=" intoString:NULL]; //你要找的起始字串
    [aScanner scanUpToString:@"</td>" intoString:&resultText]; //你要找的束结字串，中间的文字会放到text中
    if ([resultText length] <= 0) {
        aScanner = [NSScanner scannerWithString:aHtml];
        [aScanner scanUpToString:@"<div id=\"MyContent\">" intoString:NULL];
        [aScanner scanUpToString:@"</div>" intoString:&resultText];
    }
    resultText = [[@"<html xml:lang=\"zh-CN\" lang=\"zh-CN\" xmlns=\"http://www.w3.org/1999/xhtml\"><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><title>WolfFriend</title></head><body>"
                   stringByAppendingString:resultText] stringByAppendingString:@"</body></html>"];
    return resultText;
}

+ (NSString *)parseNovelBodyFromHtml:(NSString *)aHtml {
    NSScanner *aScanner;
    NSString *resultText = @"";
    aScanner = [NSScanner scannerWithString:aHtml];
    [aScanner scanUpToString:@"<div id=\"MyContent\">" intoString:NULL];
    [aScanner scanUpToString:@"</div>" intoString:&resultText];
    if ([resultText length] <= 0) {
        aScanner = [NSScanner scannerWithString:aHtml];
        [aScanner scanUpToString:@"<td id=" intoString:NULL];
        [aScanner scanUpToString:@"</td>" intoString:&resultText];
    }
    resultText = [[@"<html xml:lang=\"zh-CN\" lang=\"zh-CN\" xmlns=\"http://www.w3.org/1999/xhtml\"><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><title>WolfFriend</title></head><body>"
                   stringByAppendingString:resultText] stringByAppendingString:@"</body></html>"];
    return resultText;
}

@end
