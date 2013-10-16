//
//  FTMediaRSSParser.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 11/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTMediaRSSParserFeedItem.h"
#import "FTMediaRSSParserFeedInfo.h"


typedef void (^FTMediaRSSParserCompletionBlock)(FTMediaRSSParserFeedInfo *info, NSArray *items, NSError *error);


@interface FTMediaRSSParser : NSObject <NSXMLParserDelegate>

+ (void)parse:(NSXMLParser *)parse withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock;
+ (void)parseData:(NSData *)data withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock;
+ (void)parseString:(NSString *)xmlString withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock;


@end

