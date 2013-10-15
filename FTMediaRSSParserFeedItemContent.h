//
//  FTMediaRSSParserFeedItemContent.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, FTMediaRSSParserFeedItemContentMedium) {
    FTMediaRSSParserFeedItemContentMediumUnknown,
    FTMediaRSSParserFeedItemContentMediumImage,
    FTMediaRSSParserFeedItemContentMediumText
};


@interface FTMediaRSSParserFeedItemContent : NSObject

@property (nonatomic) CGSize size;
@property (nonatomic) FTMediaRSSParserFeedItemContentMedium medium;
@property (nonatomic, copy) NSString *urlString;


@end
