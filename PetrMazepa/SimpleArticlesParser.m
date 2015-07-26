//
//  SimpleArticlesParser.m
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/26/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

#import "SimpleArticlesParser.h"
#import "PetrMazepa-Swift.h"
#import "TFHpple.h"

@implementation SimpleArticlesParser

- (NSArray *)parse:(NSData *)html {
    
    if (!html) {
        return @[];
    }
    
    TFHpple *hpple = [[TFHpple alloc] initWithData:html isXML:NO];
    NSArray *elements = [hpple searchWithXPathQuery:@"//div[@id='content']/*"];
    NSMutableArray *articles = [NSMutableArray new];
    
    for (TFHppleElement *element in elements) {
        
        SimpleArticle *article = [self convertElement:element];
        
        if (article) {
            [articles addObject:article];
        }
    }
    
    return articles;
}

#pragma mark - Private

- (SimpleArticle *)convertElement:(TFHppleElement *)element {
    
    // Identifier
    NSString *identifier = element.attributes[@"id"];
    
    //
    TFHppleElement *itemInner = [element firstChildWithClassName:@"item-inner"];
    
    if (!itemInner) {
        return nil;
    }
    
    // Image
    TFHppleElement *itemThumbnail = [itemInner firstChildWithClassName:@"item-thumbnail"];
    
    if (!itemThumbnail) {
        return nil;
    }
    
    TFHppleElement *img = [itemThumbnail firstChildWithTagName:@"img"];
    
    if (!img) {
        return nil;
    }
    
    // - width
    NSObject *widthObject = img.attributes[@"width"];
    
    if (!widthObject) {
        return nil;
    }
    
    NSString *widthString = [NSString stringWithFormat:@"%@", widthObject];
    CGFloat width = widthString.floatValue;
    
    // - height
    NSObject *heightObject = img.attributes[@"height"];
    
    if (!heightObject) {
        return nil;
    }
    
    NSString *heightString = [NSString stringWithFormat:@"%@", heightObject];
    CGFloat height = heightString.floatValue;
    
    // - url
    NSString *src = img.attributes[@"src"];
    
    if (!src) {
        return nil;
    }
    
    NSURL *imageUrl = [NSURL URLWithString:src];
    
    MetaImage *image = [[MetaImage alloc] initWithSize:CGSizeMake(width, height) url:imageUrl];
    
    //
    TFHppleElement *itemMain = [itemInner firstChildWithClassName:@"item-main"];
    
    if (!itemMain) {
        return nil;
    }
    
    TFHppleElement *itemHeader = [itemMain firstChildWithClassName:@"item-header"];
    
    if (!itemHeader) {
        return nil;
    }
    
    // Title
    TFHppleElement *itemTitle = [itemHeader firstChildWithClassName:@"item-title"];
    
    if (!itemTitle) {
        return nil;
    }
    
    TFHppleElement *a = [itemTitle firstChildWithTagName:@"a"];
    
    if (!a) {
        return nil;
    }
   
    // Article URL
    NSString *href = a.attributes[@"href"];
    
    if (!href) {
        return nil;
    }
    
    NSURL *articleUrl = [NSURL URLWithString:href];
    
    // Title
    NSString *title = a.content;
    
    SimpleArticle *article = [[SimpleArticle alloc] initWithId:identifier
                                                         title:title
                                                    smallImage:image
                                                    articleUrl:articleUrl];
    
    return article;
}

@end
