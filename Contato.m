//
//  Contato.m
//  ContatosIP67
//
//  Created by ios6998 on 10/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

#import "Contato.h"

@implementation Contato

-(id)initWithNome:(NSString *)nome_
{
    self = [super init];
    if (self) {
        self.nome = nome_;
    }
    return self;
}

-(NSString *) description{
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@, Endereço: %@, Site: %@", self.nome, self.telefone, self.endereco, self.site];
}

-(CLLocationCoordinate2D) coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

-(NSString *) title {
    return self.title;
}

-(NSString *) subtitle {
    return self.subtitle;
}

@end
