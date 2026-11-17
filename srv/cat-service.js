import cds from '@sap/cds';

export default cds.service.impl(async function () {
    const { Products } = this.entities;

    this.before(['CREATE', 'UPDATE'], Products, (req) => {
        if (req.data.price !== undefined && req.data.price <= 0) {
            req.error(400, 'El precio del producto debe ser mayor que cero.');
        }
    });

    this.after('READ', Products, (each) => {
        if (each.stock > 40) {
            each.title += ' (¡Oferta 10% DTO!)';
        }
    });
});