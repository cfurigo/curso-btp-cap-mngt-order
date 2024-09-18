sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'orders/test/integration/FirstJourney',
		'orders/test/integration/pages/OrdersList',
		'orders/test/integration/pages/OrdersObjectPage',
		'orders/test/integration/pages/Orders_ItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, OrdersList, OrdersObjectPage, Orders_ItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('orders') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheOrdersList: OrdersList,
					onTheOrdersObjectPage: OrdersObjectPage,
					onTheOrders_ItemsObjectPage: Orders_ItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);