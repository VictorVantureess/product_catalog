using { my.products as my } from '../db/schema';

service CatalogService {
    entity Products as projection on my.Products;
    entity Categories as projection on my.Categories;
}