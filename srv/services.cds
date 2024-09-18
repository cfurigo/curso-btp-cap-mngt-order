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
    entity Orders as projection on ord.Orders;
}
annotate OrderService with @odata.draft.enabled;
annotate OrderService with @odata.draft.bypass;