namespace my.products;

entity Products {
  key ID          : UUID;
      title       : String;
      description : String;
      stock       : Integer;
      price       : Decimal(9,2);
      category    : Association to Categories;
}

entity Categories {
  key ID       : UUID;
      name     : String;
      products : Association to many Products on products.category = $self;
}