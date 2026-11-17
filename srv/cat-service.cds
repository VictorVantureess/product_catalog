using { com.logali as db } from '../db/schema';

service CatalogService {
    entity Products as projection on db.Products;
    entity Categories as projection on db.Categories;
    // Añade el resto de entidades que necesites exponer en tu servicio Fiori
}
