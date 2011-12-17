//
//  TFHppleXPathResult.m
//  Hpple
//
//  Created by Lysann Kessler on 12/17/11.
//
//  Copyright (c) 2011 Lysann Kessler. All rights reserved.
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
