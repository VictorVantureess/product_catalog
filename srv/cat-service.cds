using { com.logali as db } from '../db/schema';

service CatalogService {
    entity Products1 as projection on db.Products;
    entity Categories1 as projection on db.Categories;
    // Añade el resto de entidades que necesites exponer en tu servicio Fiori
// Exposición de entidades de materials
@cds.redirection.target: true
  entity Products as projection on materials.Products;
  entity Categories         as projection on materials.Categories;
  entity StockAvailability  as projection on materials.StockAvailability;
  entity Currencies         as projection on materials.Currencies;
  entity UnitOfMeasures     as projection on materials.UnitOfMeasures;
  entity DimensionUnits     as projection on materials.DimensionUnits;
  entity ProductReview      as projection on materials.ProductReview;
  entity SelProducts        as projection on materials.SelProducts;
  entity ProjProducts       as projection on materials.ProjProducts;
  entity ProjProducts2      as projection on materials.ProjProducts2;
  entity ProjProducts3      as projection on materials.ProjProducts3;

  // Exposición de entidades de sales
  entity Orders             as projection on sales.Orders;
  entity OrderItems         as projection on sales.OrderItems;
  entity Suppliers          as projection on sales.Suppliers;
  entity Months             as projection on sales.Months;
  entity SelProducts1       as projection on sales.SelProducts1;
  entity SelProducts2       as projection on sales.SelProducts2;
  entity SelProducts3       as projection on sales.SelProducts3;
  entity SalesData          as projection on sales.SalesData;

  // Exposición de entidades de training
  entity Course             as projection on training.Course;
  entity Student            as projection on training.Student;
  entity StudentCourse      as projection on training.StudentCourse;
}
using { com.logali.materials, com.logali.sales } from '../db/schema';
using { com.training } from '../db/training';

