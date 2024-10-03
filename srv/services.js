const { service } = require('@sap/cds');
const cds = require ('@sap/cds')

module.exports = cds.service.impl(function() {

  const { Orders, 'Orders.Items':OrderItems, SalesOrder } = this.entities;

  this.after('READ', Orders, async function(data) {

    const orders = Array.isArray(data) ? data : [data];
    let totalAmmount;
    let totalQty;

    for (let order of orders) {
      //Atualiza valor total da Ordem
      totalAmmount = 0;
      totalQty = 0;
      let Order_Items = await SELECT.from (OrderItems).where `up__ID=${order.ID}`;
      for (let i of Order_Items) {
        totalAmmount = totalAmmount + (i.quantity * i.price);
        totalQty = totalQty + i.quantity;
      }
      order.netAmmount = totalAmmount;
      order.qtyTotal = totalQty;

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

  // Handle GET call
  this.on('READ', SalesOrder, async function(req) {

    //Conecta SAP S/4
    const s4SORead = await cds.connect.to('API_SALES_ORDER_SRV');
    return s4SORead.run(req.query);
      
  })

  // Handle POST call
  this.on('Create_Order', async function(req) {

    console.log("Sync Order ID: " + req.params);
    //Conecta DB
    const orderDB = await cds.connect.to('OrderService');
    const s4Service = await cds.connect.to('API_SALES_ORDER_SRV');
    const s4e = s4Service.entities;

    //recupera ID da Ordem atraves do params
    const params = req.params;
    if(params != null){

      for (let i = 0; i < params.length; i++) {
        if (params[i].ID != null) {

          //busca dados da ordem
          let query = SELECT.from (Orders).where `ID=${params[i].ID}`;
          let order = await orderDB.run(query);

          //verifica se ordem esta aprovada
          if (order[0].status_code != 'A'){
            req.info(400, 'Order ID: ' + params[i].ID + ' Não permitido Sync de Ordem com status: ' + order[0].status_code + ' ' + order[0].status_txt);
            console.log("Sync Order ID: " + order);
            return req;
          }

          //Header Sales Order
          let:  SalesOrderType = "ZCUP",
                SalesOrganization = "C002",
                DistributionChannel = "01",
                PurchaseOrderByCustomer = order[0].OrderNo,
                SoldToParty = "1";

          //busca itens da ordem
          query = SELECT.from (OrderItems).where `up__ID=${params[i].ID}`;
          let ordItems = await orderDB.run (query);

          const to_Item = new Array();

          //Items Sales Order
          for (let i = 0; i < ordItems.length; i++) {
            to_Item.push({
              SalesOrderItem: String(i + 10),
              Material: ordItems[i].product_ID,
              RequestedQuantity: String(ordItems[i].quantity)
            });
          }

          //payload para debug
          const payload = {
            "SalesOrderType" : SalesOrderType,
            "SalesOrganization" : SalesOrganization,
            "DistributionChannel" : DistributionChannel,
            "PurchaseOrderByCustomer" : PurchaseOrderByCustomer,
            "SoldToParty" : SoldToParty,
            "to_Item" : to_Item 
          };

          console.log(JSON.stringify(payload));

          // Criar a Sales Order no S/4
          const salesOrder = await s4Service.run(
            INSERT({
                SalesOrderType,
                SalesOrganization,
                DistributionChannel,
                PurchaseOrderByCustomer,
                SoldToParty,
                to_Item,
            }).into(s4e.A_SalesOrder)
          );

          console.log(JSON.stringify(salesOrder));
          
          //atualiza dados na tabela de Ordens
          await UPDATE.entity(Orders, params[i].ID)
                      .set({status_code:'C', orderSAP: salesOrder.SalesOrder});
          
          req.info(400, 'Order ID: ' + params[i].ID + ' Sync com sucesso! Ordem SAP: ' + salesOrder.SalesOrder);

        }
      }
    }

    req.reply();
  })

})