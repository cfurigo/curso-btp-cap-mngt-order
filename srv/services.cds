using { mngt.orders as ord } from '../db/schemas';

@path: 'service/order'
service OrderService {

    entity Orders @(restrict : [
              {
                  grant : [ 'READ' ],
                  to : [ 'Viewer', 'Manager' ]
              },
              {
                  grant : [ 'CREATE', 'UPDATE', 'DELETE' ],
                  to : [ 'Manager' ]
              }
          ]) as projection on ord.Orders;
}
annotate OrderService with @odata.draft.enabled;
annotate OrderService with @odata.draft.bypass;