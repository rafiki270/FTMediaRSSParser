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

typedef NS_ENUM(NSInteger, FTMediaRSSParserFeedItemMediaType) {
    FTMediaRSSParserFeedItemMediaTypeThumbnail,
    FTMediaRSSParserFeedItemMediaTypeContent,
    FTMediaRSSParserFeedItemMediaTypeDescription,
    FTMediaRSSParserFeedItemMediaTypeCategory,
    FTMediaRSSParserFeedItemMediaTypeCredit,
    FTMediaRSSParserFeedItemMediaTypeRating,
    FTMediaRSSParserFeedItemMediaTypeCopyright
};

typedef NS_ENUM(NSInteger, FTMediaRSSParserMedium) {
    FTMediaRSSParserMediumImage,
    FTMediaRSSParserMediumHtml
};


@interface FTMediaRSSParser : NSObject <NSXMLParserDelegate>

+ (void)parseData:(NSData *)data withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock;
+ (void)parseString:(NSString *)xmlString withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock;


@end

