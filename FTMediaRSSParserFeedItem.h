//
//  FTMediaRSSParserFeedItem.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTMediaRSSParserFeedCategory.h"
#import "FTMediaRSSParserFeedItemThumbnail.h"
#import "FTMediaRSSParserFeedItemContent.h"
#import "FTMediaRSSParserFeedItemCredit.h"


typedef NS_ENUM(NSInteger, FTMediaRSSParserFeedItemRating) {
    FTMediaRSSParserFeedItemDARatingNoAdult,
    FTMediaRSSParserFeedItemDARatingAdult
};


@interface FTMediaRSSParserFeedItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *publishedString;
@property (nonatomic, copy) NSDate *published;
@property (nonatomic, copy) NSArray *thumbnails; // Array of FTMediaRSSParserFeedItemThumbnail objects
@property (nonatomic, strong) FTMediaRSSParserFeedItemContent *content;
@property (nonatomic, copy) NSArray *keywords; // Array of NSString objects
@property (nonatomic) FTMediaRSSParserFeedItemRating rating;
@property (nonatomic, strong) FTMediaRSSParserFeedCategory *category;
@property (nonatomic, strong) FTMediaRSSParserFeedItemCredit *credit;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *descriptionFull;
@property (nonatomic, copy) NSString *copyright;
@property (nonatomic, copy) NSString *copyrightUrlString;


@end
