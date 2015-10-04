//
//  ArticleDetailsParser.m
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/4/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

#import "ArticleDetailsParser.h"
#import "PetrMazepa-Swift.h"
#import "TFHpple.h"

@implementation ArticleDetailsParser

- (ArticleDetails *)parse:(NSData *)html {

    if (!html) {
        return nil;
    }
    
    TFHpple *hpple = [[TFHpple alloc] initWithData:html isXML:NO];
    return [self convertElement:hpple];
}

#pragma mark - Private

- (ArticleDetails *)convertElement:(TFHpple *)hpple {
    
    // html text
    TFHppleElement *htmlTextElement = [hpple searchWithXPathQuery:@"//div[@class='article-content']"].firstObject;
    NSString *htmlText = htmlTextElement.content;
    
    // date string
    TFHppleElement *dateElement = [hpple searchWithXPathQuery:@"//p[@class='article-metadata']"].firstObject;
    NSString *dateString = dateElement.content;
    
    // title
    TFHppleElement *titleElement = [hpple searchWithXPathQuery:@"//meta[@class='og:title']"].firstObject;
    NSString *title = titleElement.attributes[@"content"];
    
    return [[ArticleDetails alloc] initWithId:@"" title:title author:@"" thumbPath:@"" htmlText:htmlText dateString:dateString];
}

@end
