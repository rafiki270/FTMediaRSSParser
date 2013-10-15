//
//  FTMediaRSSParser.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 11/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FTMediaRSSParserFeedInfo;


typedef void (^FTMediaRSSParserCompletionBlock)(FTMediaRSSParserFeedInfo *info, NSArray *items, NSError *error);


@interface FTMediaRSSParser : NSObject

+ (void)parse:(NSString *)xmlString withCompletion:(id)completionBlock;


@end


@interface FTMediaRSSParserFeedInfo : NSObject

@end
