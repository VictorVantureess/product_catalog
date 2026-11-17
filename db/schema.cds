namespace com.logali;

type Name : String(50);

type Address {
  Street     : String;
  City       : String;
  State      : String(2);
  PostalCode : String(5);
  Country    : String(3);
}

type EmailsAddresses_01 {
  kind  : String;
  email : String;
}

type EmailsAddresses_02 {
  kind  : String;
  email : String;
}

type Emails {
  email_01 : EmailsAddresses_01;
  email_02 : many EmailsAddresses_02;
  email_03 : many {
    kind  : String;
    email : String;
  };
}

type Gender : String enum {
  male;
  female;
}

entity Products {
  key ID                : UUID;
  Name                  : Name not null; 
  Description           : String;
  ImageUrl              : String;
  ReleaseDate           : DateTime default $now;
  DiscontinuedDate      : DateTime;
  Price                 : Decimal(16,2);
  Height                : Products:Price; 
  Width                 : Decimal(16,2);
  Depth                 : Decimal(16,2);
  Quantity              : Decimal(16,2);
}

entity Suppliers {
  key ID      : UUID;
  Name        : Products:Name;
  address     : Address; 
  Email       : String;
  Phone       : String;
  Fax         : String;
}

entity Categories {
  key ID   : String(1);
  Name     : String;
}

entity StockAvailability {
  key ID      : Integer;
  Description : String;
}

entity Currencies {
  key ID      : String(3);
  Description : String;
}

entity UnitOfMeasures {
  key ID      : String(2);
  Description : String;
}

entity DimensionUnits {
  key ID      : String(2);
  Description : String;
}

entity Months {
  key ID             : String(2);
  Description        : String;
  ShortDescription   : String(3);
}

entity ProductReview {
  key Name  : String;
  Rating    : Integer;
  Comment   : String;
}

entity SalesData {
  key ID        : UUID;
  DeliveryDate  : DateTime;
  Revenue       : Decimal(16,2);
}

entity Order {
  clientGender : Gender;
  status       : Integer enum {
    submitted = 1;
    fulfiller = 2;
    shipped   = 3;
    cancel    = -1;
  };
  Priority     : String enum {
    high;
    medium;
    low;
  };
}

entity Car {
  key ID         : UUID;
  name           : String;
  virtual discount_1 : Decimal;
  virtual discount_2 : Decimal;
}

// --- 1. Selecciones (select) sobre Products ---
entity SelProducts as select from Products;

entity SelProducts1 as select * from Products;

entity SelProducts2 as select from Products {
  Name,
  Price,
  Quantity
};

entity SelProducts3 as select from Products 
  left join ProductReview on Products.Name = ProductReview.Name 
{
  sum(Products.Price) as TotalPrice,
  ProductReview.Rating,
  Products.Name
} 
group by ProductReview.Rating, Products.Name
order by ProductReview.Rating desc;


// --- 2. Proyecciones (projection on) sobre Products ---
entity ProjProducts as projection on Products;

entity ProjProducts2 as projection on Products;

entity ProjProducts3 as projection on Products {
  ReleaseDate,
  Name
};


// --- 3. Entidades con parámetros (Comentadas por limitación de SQLite local) ---
/*
entity ParamProducts as select from Products {
  Name,
  Price,
  Quantity
} where Name = :pName;

entity ProjParamProducts as projection on Products parameters pName : String;
*/


// --- 4. Extensión de la entidad Products ---
extend entity Products with {
  PriceCondition     : String(2);
  PriceDetermination : String(3);
};