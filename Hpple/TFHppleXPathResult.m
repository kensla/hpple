//
//  TFXPathResult.m
//  Hpple
//
//  Created by Lysann Kessler on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFHppleXPathResult.h"

@implementation TFHppleXPathResult

- initWithXPathObject: (xmlXPathObjectPtr) object {
  if (!(self = [super init])) {
    xmlXPathFreeObject(object);
    return nil;
  }
  
  xPathObject = object;
  
  return self;
}

- initWithXPathQuery: (NSString*) query inDocument: (xmlDocPtr) document {
  // create XPath context
  xmlXPathContextPtr context = xmlXPathNewContext(document);
  if (context == NULL) {
    NSLog(@"Unable to create XPath context");
    return nil;
  }
  
  // create XPath object
  xmlXPathObjectPtr object = xmlXPathEvalExpression(BAD_CAST [query cStringUsingEncoding:NSUTF8StringEncoding], context);
  if (object == NULL) {
    NSLog(@"Unable to evaluate XPath query");
    xmlXPathFreeContext(context);
    return nil;
  }
  
  self = [self initWithXPathObject:object];
  xmlXPathFreeContext(context);
  
  return self;
}

- (void) dealloc {
  if (xPathObject != NULL) xmlXPathFreeObject(xPathObject);
  
  [super dealloc];
}

#pragma mark -

- (NSArray*) array {
  NSUInteger count = self.count;
  NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:count];
  for (NSUInteger i = 0; i < count; i++) {
    [result addObject: [self unsafeObjectAtIndex: i]];
  }
  return [result autorelease];
}
- (NSArray*) results {
  return [self array];
}

- (NSUInteger) count {
  return xmlXPathNodeSetGetLength(xPathObject->nodesetval);
}
- (BOOL) isEmpty {
  return xmlXPathNodeSetIsEmpty(xPathObject->nodesetval);
}

- (TFHppleElement*) objectAtIndex: (NSUInteger) index {
  if (index >= self.count) return nil;
  return [self unsafeObjectAtIndex:index];
}
- (TFHppleElement*) unsafeObjectAtIndex: (NSUInteger) index {
  xmlNodePtr node = xmlXPathNodeSetItem(xPathObject->nodesetval, index);
  return [TFHppleElement hppleElementWithNode: node ofXPathResult: self];
}

- (TFHppleElement*) firstElement {
  if (self.isEmpty) return nil;
  else return [self unsafeObjectAtIndex:0];
}

@end
