using { mngt.orders as ord } from '../db/schemas';
using { API_SALES_ORDER_SRV as external } from './external/API_SALES_ORDER_SRV';

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
    @readonly
    entity SalesOrder as projection on external.A_SalesOrder;
    @open
    type object {};
    @Common.IsActionCritical
    action Create_Order(Order : object) returns object;
}
annotate OrderService.Orders with @odata.draft.enabled;
annotate OrderService.Orders with @odata.draft.bypass;