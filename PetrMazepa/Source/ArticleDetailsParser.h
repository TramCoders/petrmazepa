//
//  ArticleDetailsParser.h
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/4/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArticleDetails;

@interface ArticleDetailsParser : NSObject

- (ArticleDetails *)parse:(NSData *)html;

@end
