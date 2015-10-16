//
//  FTMediaRSSParserFeedInfo.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTMediaRSSParserFeedInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *copyright;
@property (nonatomic, copy) NSString *publishedString;
@property (nonatomic, copy) NSDate *published;
@property (nonatomic, copy) NSString *generator;
@property (nonatomic, copy) NSString *docs;
@property (nonatomic, copy) NSString *atomIcon;
@property (nonatomic, copy) NSString *atomLink;

@property (nonatomic) NSTimeInterval parsingTime;


@end
