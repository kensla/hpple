//
//  TFHppleElementAttribute.m
//  Hpple
//
//  Created by Lysann Kessler on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFHppleElementAttribute.h"

@implementation TFHppleElementAttribute

- (id) initWithAttribute: (xmlAttrPtr) attr ofElement: (TFHppleElement*) parent {
  if (!(self = [super init])) {
    return nil;
  }
  
  attribute = attr;
  parentElement = [parent retain];
  
  return self;
}

+ (TFHppleElementAttribute*) hppleElementAttributeWithAttribute: (xmlAttrPtr) attr ofElement: (TFHppleElement*) parent {
  return [[[self alloc] initWithAttribute:attr ofElement:parent] autorelease];
}

- (void) dealloc {
  [parentElement release];
  
  [super dealloc];
}

#pragma mark -

- (NSString*) name {
  // TODO: is this ok? does NSString copy the data?
  return [NSString stringWithCString:(char*)attribute->name encoding:NSUTF8StringEncoding];
}

- (NSString*) value {
  xmlChar* content = xmlNodeGetContent(attribute->children);
  NSString* result = [NSString stringWithCString: (char*) content encoding: NSUTF8StringEncoding];
  xmlFree(content); // is this ok? does NSString copy the data? maybe we should directly use attribute->children->content
  return result;
}

@end
