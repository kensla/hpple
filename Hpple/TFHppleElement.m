//
//  TFHppleElement.m
//  Hpple
//
//  Created by Geoffrey Grosenbach on 1/31/09.
//
//  Copyright (c) 2009 Topfunky Corporation, http://topfunky.com
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


#import "TFHppleElement.h"
#import "TFHppleElementAttribute.h"

@implementation TFHppleElement

- (void) dealloc
{
  [parentResult release];
  
  [super dealloc];
}

- (id) initWithNode:(xmlNodePtr)theNode {
  if (!(self = [super init]))
    return nil;
  
  node = theNode;
  parentNode = nil;
  parentResult = nil;
  
  return self;
}

- (id) initWithNode: (xmlNodePtr) theNode ofXPathResult: (TFXPathResult*) result {
  if (!(self = [self initWithNode:theNode]))
    return nil;
  parentResult = [result retain];
  return self;
}

- (id) initWithNode: (xmlNodePtr) theNode ofParentNode: (TFHppleElement*) parent {
  if (!(self = [self initWithNode:theNode]))
    return nil;
  parentNode = [parentNode retain];
  return self;
}

+ (TFHppleElement*) hppleElementWithNode: (xmlNodePtr) node ofXPathResult: (TFXPathResult*) result {
  return [[[self alloc] initWithNode: node ofXPathResult: result] autorelease];
}

+ (TFHppleElement*) hppleElementWithNode: (xmlNodePtr) node ofParentNode: (TFHppleElement*) parent {
  return [[[self alloc] initWithNode: node ofParentNode:parent] autorelease];
}

#pragma mark -

- (NSString *) content
{
  xmlChar* content = xmlNodeGetContent(node);
  NSString* result = [NSString stringWithCString: (char*) content encoding: NSUTF8StringEncoding];
  xmlFree(content); // TODO: is this ok? does NSString copy the data? maybe we should directly use node->content
  return result;
}

- (NSString *) tagName
{
  // TODO: is this ok? does NSString copy the data?
  return [NSString stringWithCString: (char*) node->name encoding: NSUTF8StringEncoding];
}

- (TFHppleElement*) parent {
  return parentNode;
}

- (NSDictionary *) attributes
{
  NSMutableDictionary * result = [NSMutableDictionary dictionary];
  for (TFHppleElementAttribute* attribute in self.allAttributes) {
    [result setValue:[attribute value] forKey:[attribute name]];
  }  
  return result;
}

- (NSArray*) allAttributes {
  NSMutableArray* result = [NSMutableArray array];
  xmlAttrPtr attribute = node->properties;
  while (attribute) {    
    [result addObject: [TFHppleElementAttribute hppleElementAttributeWithAttribute:attribute ofElement:self]];
    attribute = attribute->next;
  }
  return result;
}

- (NSUInteger) attributeCount {
  NSUInteger count = 0;
  xmlAttrPtr attribute = node->properties;
  while (attribute) {    
    count++;
    attribute = attribute->next;
  }
  return count;
}

- (NSString *) objectForKey:(NSString *) theKey
{
  xmlChar* value = xmlGetProp(node, BAD_CAST [theKey cStringUsingEncoding:NSUTF8StringEncoding]);
  if(value == NULL) return nil;
  NSString* str = [NSString stringWithCString: (char*) value encoding:NSUTF8StringEncoding];
  xmlFree(value); // TODO: is this ok? does NSString copy the data?
  return str;
}

- (NSArray *) children
{
  NSMutableArray *result = [NSMutableArray array];
  xmlNodePtr child = node->children;
  while (child) {    
    [result addObject: [TFHppleElement hppleElementWithNode:child ofParentNode: self]];
    child = child->next;
  }
  return result;
}

- (TFHppleElement *) firstChild
{
  xmlNodePtr child = node->children;
  if (child) {
    return [TFHppleElement hppleElementWithNode:child ofParentNode: self];
  } else {
    return nil;
  }
}

- (NSUInteger) childrenCount {
  NSUInteger count = 0;
  xmlNodePtr child = node->children;
  while (child) {    
    count++;
    child = child->next;
  }
  return count;
}

- (NSUInteger) count {
  return self.childrenCount;
}

#pragma  mark -

- (TFXPathResult *) searchWithXPathQuery:(NSString *)query {
  // create XPath context
  xmlXPathContextPtr context = xmlXPathNewContext(node->doc);
  if (context == NULL) {
    NSLog(@"Unable to create XPath context");
    return nil;
  }
  // set subnode as context
  context->node = node;
  
  // create XPath object
  xmlXPathObjectPtr object = xmlXPathEvalExpression(BAD_CAST [query cStringUsingEncoding:NSUTF8StringEncoding], context);
  if (object == NULL) {
    NSLog(@"Unable to evaluate XPath query");
    xmlXPathFreeContext(context);
    return nil;
  }
  
  TFXPathResult* result = [[[TFXPathResult alloc] initWithXPathObject:object] autorelease];
  xmlXPathFreeContext(context);
  
  return result;
}

- (TFHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS {
  return [[self searchWithXPathQuery:xPathOrCSS] firstElement];
}

@end
