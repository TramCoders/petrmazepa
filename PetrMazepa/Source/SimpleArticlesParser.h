//
//  SimpleArticlesParser.h
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/26/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleArticlesParser : NSObject

- (NSArray *)parse:(NSData *)html;

@end
