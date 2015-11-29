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
    TFHppleElement *htmlTextElement = [hpple searchWithXPathQuery:@"//div[@class='mainContent']"].firstObject;
    NSString *htmlText = htmlTextElement.raw;
    NSString *fixedHtmlText = [self htmlTextWithFixedYoutubeWidth:htmlText];
    
    return [[ArticleDetails alloc] initWithHtmlText:fixedHtmlText];
}

- (NSString *)htmlTextWithFixedYoutubeWidth:(NSString *)htmlText {
    return [htmlText stringByReplacingOccurrencesOfString:@"width=\"788\"" withString:@"width=\"100%%\""];
}

@end
