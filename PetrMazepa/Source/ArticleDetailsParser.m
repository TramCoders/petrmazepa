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
    
    // html text
    TFHppleElement *htmlTextElement = [hpple searchWithXPathQuery:@"//div[@class='article-content']"].firstObject;
    NSString *htmlText = htmlTextElement.content;
    
    return [[ArticleDetails alloc] initWithId:@"123" title:@"123" author:@"123" thumbPath:@"" htmlText:htmlText date:[NSDate date]];
}

#pragma mark - Private

//- (ArticleDetails *)convertElement:(TFHppleElement *)element {
//    
//    
//}

@end
