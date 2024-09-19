
namespace mngt.orders;

using { Currency, User, managed, cuid, sap.common.CodeList } from '@sap/cds/common';

entity Orders : cuid, managed {
  //key ID   : UUID;
  OrderNo  : String(22) @title:'Order Number'; //> chave de leitura
  Items    : Composition of many {
    key ID    : UUID;
    product   : Association to Products;
    quantity  : Integer;
    unit: Association to Mensure;
    title  : String; //> sera populado pelo product.title
    price     : Double; //> campo calculado
  };
  buyer    : User;
  currency : Currency;
  status   : Association to Status default 'N';
  status_txt : String;
  criticality : Integer;
  netAmmount: Double; 
  qtyTotal: Integer;
  unit: Association to Mensure;
}

/** entidade de produtos não será persistida */
//@(cds.persistence.skip:'always')
entity Products {
  key ID : String;
  quantity: Integer;
  unitMensure: Association to Mensure;
  product_ID: String;
  title: String;
  price: Double;  
}

entity Status : CodeList {
  key code: String enum {
      new = 'N';
      approved = 'A'; 
      closed = 'C'; 
  };
}

entity Mensure : CodeList {
  key code: String(2) enum {
      kilo = 'KG';
      unit = 'UN'; 
  };
}