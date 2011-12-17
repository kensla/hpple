//
//  TFHpple.m
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

#import "TFHpple.h"
#import "XPathQuery.h"

@implementation TFHpple

- (xmlXPathContextPtr) getOrCreateXPathContext {
  if (xpathContext == NULL) {
    xpathContext = xmlXPathNewContext(xmlDocument);
  }
  return xpathContext;
}

@synthesize data, isXML;

- (void) dealloc
{
  if (xpathContext != NULL) xmlXPathFreeContext(xpathContext);
  xmlFreeDoc(xmlDocument);
  [data release];
  
  [super dealloc];
}

- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML
{
  if (!(self = [super init])) {
    return nil;
  }

  [theData retain];
  data = theData;
  isXML = isDataXML;
  
  if (isDataXML) {
    xmlDocument = xmlReadMemory([theData bytes], (int)[theData length], "", NULL, XML_PARSE_RECOVER);
  } else {
    xmlDocument = htmlReadMemory([theData bytes], (int)[theData length], "", NULL, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);
  }
  
  if (xmlDocument == NULL) {
    NSLog(@"Cannot parse document");
    [self dealloc];
    return nil;
  }
  
  xpathContext = NULL;

  return self;
}

- (id) initWithXMLData:(NSData *)theData
{
  return [self initWithData:theData isXML:YES];
}

- (id) initWithHTMLData:(NSData *)theData
{
  return [self initWithData:theData isXML:NO];
}

+ (TFHpple *) hppleWithData:(NSData *)theData isXML:(BOOL)isDataXML {
  return [[[[self class] alloc] initWithData:theData isXML:isDataXML] autorelease];
}

+ (TFHpple *) hppleWithHTMLData:(NSData *)theData {
  return [[self class] hppleWithData:theData isXML:NO];
}

+ (TFHpple *) hppleWithXMLData:(NSData *)theData {
  return [[self class] hppleWithData:theData isXML:YES];
}

#pragma mark -

// Returns all elements at xPath.
- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS
{
  xmlXPathContextPtr context = [self getOrCreateXPathContext];
  if (context == NULL) {
    NSLog(@"Unable to create XPath context");
    return nil;
  }
  
  NSArray * detailNodes = nil;
  if (isXML) {
    detailNodes = PerformXMLXPathQuery(data, xPathOrCSS);
  } else {
    detailNodes = PerformHTMLXPathQuery(data, xPathOrCSS);
  }

  NSMutableArray * hppleElements = [NSMutableArray array];
  for (id node in detailNodes) {
    [hppleElements addObject:[TFHppleElement hppleElementWithNode:node]];
  }
  return hppleElements;
}

// Returns first element at xPath
- (TFHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS
{
  NSArray * elements = [self searchWithXPathQuery:xPathOrCSS];
  if ([elements count] >= 1) {
    return [elements objectAtIndex:0];
  }

  return nil;
}

@end
