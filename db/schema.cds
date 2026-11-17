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

//namespace com.logali;

// 1. Asociaciones no administradas en Products
// 1. Asociaciones no administradas en Products
extend entity Products with {
  supplier_ID      : UUID;
  unitOfMeasure_ID : String;
  dimensionUnit_ID : String;

  ToSupplier       : association to Suppliers on ToSupplier.ID = supplier_ID;
  ToUnitOfMeasure  : association to UnitOfMeasures on ToUnitOfMeasure.ID = unitOfMeasure_ID;
  ToDimesionUnit   : association to DimensionUnits on ToDimesionUnit.ID = dimensionUnit_ID;
};

// 2. Modificación de ProductReview con ID tipo UUID y asociación administrada
/*
entity ProductReview {
  key ID      : UUID;
  Rating      : Integer;
  Comment     : String;
  Product     : Association to Products;
}
*/

// Asociaciones administradas en las entidades correspondientes
extend entity Products with {
  Supplier    : Association to Suppliers;
  Category    : Association to Categories;
  Currency    : Association to Currencies;
  DimensionUnit : Association to DimensionUnits;
  UnitOfMeasure : Association to UnitOfMeasures;
}

extend entity SalesData with {
  Product     : Association to Products;
  Currency    : Association to Currencies;
  DeliveryMonth : Association to Months;
}

// 3. Asociaciones de uno a muchos (reversas)
extend entity Products {
  SalesData   : association to many SalesData on SalesData.Product = $self;
}

extend entity ProductReview {
  // Ya vinculada mediante su asociación a Product
}

extend entity Suppliers {
  Product     : association to many Products on Product.Supplier = $self;
}

// 4. Entidades Course, Student y StudentCourse (Muchos a Muchos)
entity Course {
  key ID      : UUID;
  Title       : String;
  Students    : Association to many StudentCourse on Students.Course = $self;
}

entity Student {
  key ID      : UUID;
  Name        : String;
  Courses     : Association to many StudentCourse on Courses.Student = $self;
}

entity StudentCourse {
  key ID      : UUID;
  Student     : Association to Student;
  Course      : Association to Course;
}

// 5. Composiciones (Orders y OrderItems)
entity Orders {
  key ID      : UUID;
  OrderNo     : String;
  Items       : Composition of many OrderItems on Items.Order = $self;
}

entity OrderItems {
  key ID      : UUID;
  Order       : Association to Orders;
  Product     : Association to Products;
  Quantity    : Integer;
}