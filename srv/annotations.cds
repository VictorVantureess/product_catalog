using CatalogService as service from './cat-service';

annotate service.Products with @(
    UI.HeaderInfo : {
        TypeName       : 'Producto',
        TypeNamePlural : 'Productos',
        Title          : { Value : title },
        Description    : { Value : description }
    },
    UI.SelectionFields : [
        title,
        price
    ],
    UI.LineItem : [
        { Value : title,       Label : 'Nombre del Producto' },
        { Value : description, Label : 'Descripción' },
        { Value : stock,       Label : 'Stock Disponible' },
        { Value : price,       Label : 'Precio (€)' }
    ],
    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'GeneralInfoFacet',
            Label  : 'Información General',
            Target : '@UI.FieldGroup#GeneralInfo'
        }
    ],
    UI.FieldGroup #GeneralInfo : {
        Data : [
            { Value : title,       Label : 'Título' },
            { Value : description, Label : 'Descripción' },
            { Value : stock,       Label : 'Stock' },
            { Value : price,       Label : 'Precio (€)' }
        ]
    }
);