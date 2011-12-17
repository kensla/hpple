//
//  TFXPathResult.h
//  Hpple
//
//  Created by Lysann Kessler on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libxml/xpath.h>

#import "TFHppleElement.h"

@class TFHppleElement;

@interface TFHppleXPathResult : NSObject {
@private
  xmlXPathObjectPtr xPathObject;
}

- initWithXPathObject: (xmlXPathObjectPtr) object;
- initWithXPathQuery: (NSString*) query inDocument: (xmlDocPtr) document;

- (NSArray*) array;
- (NSArray*) results;
- (NSUInteger) count;
- (BOOL) isEmpty;

- (TFHppleElement*) objectAtIndex: (NSUInteger) index;
- (TFHppleElement*) unsafeObjectAtIndex: (NSUInteger) index;
- (TFHppleElement*) firstElement;

@end
