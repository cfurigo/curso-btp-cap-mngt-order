const cds = require ('@sap/cds')
class OrdersService extends cds.ApplicationService {

  /** registra fase + evento que irão executar a lógica de negocio */
  init(){
    const { 'Orders':Orders , 'Orders.Items':OrderItems } = this.entities

    this.after('READ', Orders, async function(data) {

      const orders = Array.isArray(data) ? data : [data];
      let totalAmmount;
      let totalQty;
      let lastunit;

      for (let order of orders) {
        //Atualiza valor total da Ordem
        totalAmmount = 0;
        totalQty = 0;
        let Order_Items = await SELECT.from (OrderItems).where `up__ID=${order.ID}`;
        for (let i of Order_Items) {
          totalAmmount = totalAmmount + (i.quantity * i.price);
          totalQty = totalQty + i.quantity;
          lastunit = i.unit_code;
        }
        order.netAmmount = totalAmmount;
        order.qtyTotal = totalQty;
        order.unit = lastunit;

        // atualiza criticidade
        switch (order.status_code) {
          case 'N': //Novo
              order.criticality = 1;
              order.status_txt = 'New';
              break;
          case 'A': //Aprovado
              order.criticality = 2;
              order.status_txt = 'Approved';
              break;
          case 'C': //Concluido
              order.criticality = 3;
              order.status_txt = 'Closed';
              break;
          default:
              break;
        }

        console.log(order);
      }

    })

    this.before ('UPDATE', 'Orders', async function(req) {
      const { ID, Items } = req.data
      if (Items) for (let { product_ID, quantity } of Items) {
        const { quantity:before } = await cds.tx(req).run (
          SELECT.one.from (OrderItems, oi => oi.quantity) .where ({up__ID:ID, product_ID})
        )
        //if (quantity != before) await this.orderChanged (product_ID, quantity-before)
      }
    })

    this.before ('DELETE', 'Orders', async function(req) {
      const { ID } = req.data
      const Items = await cds.tx(req).run (
        SELECT.from (OrderItems, oi => { oi.product_ID, oi.quantity }) .where ({up__ID:ID})
      )
      //if (Items) await Promise.all (Items.map(it => this.orderChanged (it.product_ID, -it.quantity)))
    })

    return super.init()
  }

}
module.exports = OrdersService