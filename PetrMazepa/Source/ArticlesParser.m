//
//  ArticlesParser.m
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/26/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

#import "ArticlesParser.h"
#import "PetrMazepa-Swift.h"
#import "TFHpple.h"

@implementation ArticlesParser

- (NSArray *)parse:(NSData *)html {
    
    if (!html) {
        return @[];
    }
    
    TFHpple *hpple = [[TFHpple alloc] initWithData:html isXML:NO];
    NSArray *elements = [hpple searchWithXPathQuery:@"//div[@class='row articles']/div"];
    NSMutableArray *articles = [NSMutableArray new];
    
    for (TFHppleElement *element in elements) {
        
        Article *article = [self convertElement:element];
        
        if (article) {
            [articles addObject:article];
        }
    }
    
    return articles;
}

#pragma mark - Private

- (Article *)convertElement:(TFHppleElement *)element {
    
    // identifier
    TFHppleElement *aElement = [element searchWithXPathQuery:@"//a"].firstObject;
    NSString *href = aElement.attributes[@"href"];
    NSString *identifier = [self identifierFromHref:href];
    
    // title
    TFHppleElement *imgElement = [element firstChildWithTagName:@"img"];
    NSString *title = imgElement.attributes[@"title"];
    
    // thumb
    NSString *thumbPath = imgElement.attributes[@"data-original"];
    
    return [[Article alloc] initWithId:identifier title:title thumbPath:thumbPath];
}

- (NSString *)identifierFromHref:(NSString *)href {
    
    if (href.length == 0) {
        return nil;
    }
    
    NSString *temp = [href substringFromIndex:1];
    NSArray *components = [temp componentsSeparatedByString:@"."];
    
    if (components.count != 2) {
        return nil;
    }
    
    return components[0];
}

@end
