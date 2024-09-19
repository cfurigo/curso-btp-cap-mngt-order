
namespace mngt.orders;

using { Currency, User, managed, cuid, sap.common.CodeList } from '@sap/cds/common';

entity Orders : cuid, managed {
  OrderNo  : String(22) @title:'Order Number'; //> chave de leitura
  Items    : Composition of many {
    key ID    : UUID;
    product   : Association to Products;
    quantity  : Integer;
    title  : String; //> sera populado pelo product.title
    price     : Double; //> campo calculado
  };
  buyer    : User;
  currency : Currency;
  status   : Association to Status default 'N';
  status_txt : String;
  criticality : Integer;
  netAmmount: Double; 
}

/** entidade de produtos não será persistida */
entity Products @(cds.persistence.skip:'always') {
  key ID : String;
  quantity: Decimal(13,2);
  product_ID: String;
  title: String;
  price: Double;  
  unitMensure: Association to Mensure;
}

entity Status : CodeList {
  key code: String enum {
      new = 'N';
      approved = 'A'; 
      closed = 'C'; 
  };
}

entity Mensure : CodeList {
  key code: String enum {
      kilo = 'KG';
      unit = 'UN'; 
  };
}