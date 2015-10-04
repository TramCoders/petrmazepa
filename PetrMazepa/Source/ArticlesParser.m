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
    NSArray *elements = [hpple searchWithXPathQuery:@"//div[@class='cell']/*"];
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
    
    TFHppleElement *articleContainer = [element firstChildWithClassName:@"article-container"];
    
    if (!articleContainer) {
        return nil;
    }
    
    // identifier
    NSString *href = articleContainer.attributes[@"href"];
    NSString *identifier = [self identifierFromHref:href];
    
    if (!identifier) {
        return nil;
    }
    
    // title
    TFHppleElement *articleTile = [articleContainer firstChildWithClassName:@"article-tile"];
    
    if (!articleTile) {
        return nil;
    }
    
    TFHppleElement *articleTitle = [articleTile firstChildWithClassName:@"article-title"];
    
    if (!articleTitle) {
        return nil;
    }
    
    NSString *title = articleTitle.content;
    
    // author
    TFHppleElement *articleAuthor = [articleTile firstChildWithClassName:@"article-author"];
    
    if (!articleAuthor) {
        return nil;
    }
    
    NSString *author = articleAuthor.content;
    
    // image
    TFHppleElement *articleImage = [articleContainer firstChildWithClassName:@"article-image"];
    
    if (!articleImage) {
        return nil;
    }
    
    NSString *imagePath = articleImage.attributes[@"src"];
    
    // result
    return [[Article alloc] initWithId:identifier title:title author:author thumbPath:imagePath];
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
