//
//  FTMediaRSSParser.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 11/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTMediaRSSParser.h"


#define kFTMediaRSSParserDebug                                  NO
#define kFTMediaRSSParserDebugFull                              if (kFTMediaRSSParserDebug)


@interface FTMediaRSSParser ()

@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSXMLParser *parser;

@property (nonatomic, readonly) FTMediaRSSParserFeedInfo *info;
@property (nonatomic, readonly) NSMutableArray *items;
@property (nonatomic, readonly) FTMediaRSSParserFeedItem *currentItem;
@property (nonatomic, readonly) FTMediaRSSParserFeedItemCredit *currentCredit;
@property (nonatomic, readonly) NSMutableArray *currentThumbnails;
@property (nonatomic, readonly) NSString *currentElementName;

@property (nonatomic, readonly) FTMediaRSSParserCompletionBlock completionBlock;

@property (nonatomic, readonly) NSDate *debugTimeStart;


@end


@implementation FTMediaRSSParser


#pragma mark Initialization

+ (FTMediaRSSParser *)instance {
    return [[FTMediaRSSParser alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _info = [[FTMediaRSSParserFeedInfo alloc] init];
        _items = [NSMutableArray array];
    }
    return self;
}

#pragma mark Settings

- (void)parse:(id)parseObject withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock {
    _debugTimeStart = [NSDate date];
    _completionBlock = completionBlock;
    
    if ([parseObject isKindOfClass:[NSXMLParser class]]) {
        _parser = parseObject;
    }
    else {
        _data = parseObject;
        _parser = [[NSXMLParser alloc] initWithData:_data];
    }
    
    [_parser setDelegate:self];
    [_parser parse];
}

#pragma mark Parsing

+ (void)parse:(NSXMLParser *)parse withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock {
    FTMediaRSSParser *p = [self instance];
    [p parse:parse withCompletionHandler:completionBlock];
}

+ (void)parseData:(NSData *)data withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock {
    FTMediaRSSParser *p = [self instance];
    [p parse:data withCompletionHandler:completionBlock];
}

+ (void)parseString:(NSString *)xmlString withCompletionHandler:(FTMediaRSSParserCompletionBlock)completionBlock {
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    [self parseData:data withCompletionHandler:completionBlock];
}

#pragma mark Parser delegate methods

- (void)checkForCategory {
    if (!_currentItem.category) {
        [_currentItem setCategory:[[FTMediaRSSParserFeedCategory alloc] init]];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    kFTMediaRSSParserDebugFull NSLog(@"Start elements: %@ with attributes: %@", elementName, attributeDict);
    _currentElementName = elementName;
    if ([elementName isEqualToString:@"item"]) {
        _currentItem = [[FTMediaRSSParserFeedItem alloc] init];
        _currentCredit = [[FTMediaRSSParserFeedItemCredit alloc] init];
        _currentThumbnails = [NSMutableArray array];
    }
    if (!_currentItem) {
        
    }
    else {
        if ([_currentElementName isEqualToString:@"media:credit"]) {
            [_currentCredit setRole:[attributeDict objectForKey:@"role"]];
            [_currentCredit setScheme:[attributeDict objectForKey:@"scheme"]];
        }
        else if ([_currentElementName isEqualToString:@"media:category"]) {
            [self checkForCategory];
            [_currentItem.category setLabel:[attributeDict objectForKey:@"label"]];
        }
        else if ([_currentElementName isEqualToString:@"media:copyright"]) {
            [_currentItem setCopyrightUrlString:[attributeDict objectForKey:@"url"]];
        }
        else if ([_currentElementName isEqualToString:@"media:thumbnail"]) {
            FTMediaRSSParserFeedItemThumbnail *t = [[FTMediaRSSParserFeedItemThumbnail alloc] init];
            CGFloat w = [[attributeDict objectForKey:@"width"] floatValue];
            CGFloat h = [[attributeDict objectForKey:@"height"] floatValue];
            [t setSize:CGSizeMake(w, h)];
            [t setUrlString:[attributeDict objectForKey:@"url"]];
            [_currentThumbnails addObject:t];
        }
        else if ([_currentElementName isEqualToString:@"media:content"]) {
            _currentItem.content = [[FTMediaRSSParserFeedItemContent alloc] init];
            CGFloat w = [[attributeDict objectForKey:@"width"] floatValue];
            CGFloat h = [[attributeDict objectForKey:@"height"] floatValue];
            [_currentItem.content setSize:CGSizeMake(w, h)];
            [_currentItem.content setUrlString:[attributeDict objectForKey:@"url"]];
            if ([[attributeDict objectForKey:@"medium"] isEqualToString:@"image"]) {
                [_currentItem.content setMedium:FTMediaRSSParserFeedItemContentMediumImage];
            }
            else {
                [_currentItem.content setMedium:FTMediaRSSParserFeedItemContentMediumUnknown];
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    kFTMediaRSSParserDebugFull NSLog(@"Finished elements: %@\n\n\n\n\n\n", elementName);
    _currentElementName = nil;
    if ([elementName isEqualToString:@"item"]) {
        [_currentItem setCredit:_currentCredit];
        [_currentItem setThumbnails:_currentThumbnails];
        [_items addObject:_currentItem];
    }
    else if ([elementName isEqualToString:@"channel"]) {
        NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:_debugTimeStart];
        NSLog(@"Parsing time: %f", t);
#warning Finish parsing benchmarking
        if (_completionBlock) {
            _completionBlock(_info, _items, nil);
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!_currentElementName) return;
    kFTMediaRSSParserDebugFull NSLog(@"Characters found: '%@'", string);
    if (!_currentItem) {
        if ([_currentElementName isEqualToString:@"title"]) {
            [_info setTitle:string];
        }
        else if ([_currentElementName isEqualToString:@"description"]) {
            [_info setDescription:string];
        }
        else if ([_currentElementName isEqualToString:@"language"]) {
            [_info setLanguage:string];
        }
        else if ([_currentElementName isEqualToString:@"copyright"]) {
            [_info setCopyright:string];
        }
        else if ([_currentElementName isEqualToString:@"pubDate"]) {
            [_info setPublishedString:string];
            // TODO: Finish date conversion
            [_info setPublished:nil];
        }
        else if ([_currentElementName isEqualToString:@"generator"]) {
            [_info setGenerator:string];
        }
        else if ([_currentElementName isEqualToString:@"docs"]) {
            [_info setDocs:string];
        }
        else if ([_currentElementName isEqualToString:@"atom:icon"]) {
            [_info setAtomIcon:string];
        }
    }
    else {
        if ([_currentElementName isEqualToString:@"title"]) {
            [_currentItem setTitle:string];
        }
        else if ([_currentElementName isEqualToString:@"link"]) {
            [_currentItem setUrlString:string];
        }
        else if ([_currentElementName isEqualToString:@"media:category"]) {
            [self checkForCategory];
            [_currentItem.category setPath:string];
        }
        else if ([_currentElementName isEqualToString:@"pubDate"]) {
            [_currentItem setPublishedString:string];
            // TODO: Finish date conversion
            [_currentItem setPublished:nil];
        }
        else if ([_currentElementName isEqualToString:@"media:rating"]) {
            [_currentItem setRating:([string isEqualToString:@"adult"] ? FTMediaRSSParserFeedItemDARatingAdult : FTMediaRSSParserFeedItemDARatingNoAdult)];
        }
        else if ([_currentElementName isEqualToString:@"media:credit"]) {
            if (([string rangeOfString:@"http:\\"].location == NSNotFound) && ([string rangeOfString:@"https:\\"].location == NSNotFound)) {
                [_currentCredit setName:string];
            }
            else {
                [_currentCredit setUrlString:string];
            }
        }
        else if ([_currentElementName isEqualToString:@"media:copyright"]) {
            [_currentItem setCopyright:string];
        }
        else if ([_currentElementName isEqualToString:@"media:description"]) {
            [_currentItem setDescriptionText:string];
        }
        else if ([_currentElementName isEqualToString:@"description"]) {
            [_currentItem setDescriptionFull:string];
        }
    }
}


@end