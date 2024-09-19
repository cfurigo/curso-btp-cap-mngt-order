using { mngt.orders as ord } from '../db/schemas';

@path: 'service/order'
service OrderService {
    @(restrict : [
        {
            grant : [ 'WRITE' ],
            to : [ 'Manager' ]
        },
        {
            grant : [ 'READ' ],
            to : [ 'Viewer', 'Manager' ]
        }
    ])
    entity Orders as projection on ord.Orders order by OrderNo asc;
    @readonly
    entity Products as projection on ord.Products;
}
annotate OrderService.Orders with @odata.draft.enabled;
annotate OrderService.Orders with @odata.draft.bypass;