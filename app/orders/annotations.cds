using OrderService as service from '../../srv/services';
using from '@sap/cds/common';
using from '../../db/schemas';


annotate service.Orders with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : OrderNo,
                Label : '{i18n>OrderNumber}',
            },
            {
                $Type : 'UI.DataField',
                Value : buyer,
            },
            {
                $Type : 'UI.DataField',
                Value : netAmmount,
                Label : '{i18n>Total}',
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Currency}',
                Value : currency_code,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Status}',
                Value : status_code,
                Criticality : criticality,
                CriticalityRepresentation : #WithIcon,
            },
            {
                $Type : 'UI.DataField',
                Value : qtyTotal,
                Label : '{i18n>TotalQuantity}',
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Orders Items',
            ID : 'OrdersItems',
            Target : 'Items/@UI.LineItem#OrdersItems',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : OrderNo,
            Label : '{i18n>OrderNumber}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : buyer,
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : netAmmount,
            Label : '{i18n>Total}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Currency}',
            Value : currency_code,
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : status_code,
            Label : '{i18n>Status}',
            Criticality : criticality,
            CriticalityRepresentation : #WithIcon,
            ![@UI.Importance] : #High,
        },
    ],
    UI.SelectionFields : [
        buyer,
        OrderNo,
    ],
    UI.DataPoint #netAmmount : {
        Value : netAmmount,
        Visualization : #Rating,
        TargetValue : 5,
        ![@Common.QuickInfo] : status.name,
    },
    UI.FieldGroup #Items : {
        $Type : 'UI.FieldGroupType',
        Data : [
        ],
    },
    UI.DataPoint #progress : {
        $Type : 'UI.DataPointType',
        Value : criticality,
        Title : '{i18n>Status}',
        TargetValue : 3,
        Visualization : #Progress,
        Description : '{i18n>Phase}',
        ![@Common.QuickInfo] : status.name,
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'criticality',
            Target : '@UI.DataPoint#progress',
        },
    ],
    UI.DataPoint #rating : {
        $Type : 'UI.DataPointType',
        Value : netAmmount,
        Title : 'netAmmount',
        TargetValue : 5,
        Visualization : #Rating,
    },
);

annotate service.Orders with {
    status @(
        Common.Text : {
            $value : status_txt,
            ![@UI.TextArrangement] : #TextLast
        },
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Status',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : status_code,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'Status',
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.Orders with {
    buyer @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Orders',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : buyer,
                    ValueListProperty : 'buyer',
                },
            ],
            Label : 'Buyer',
        },
        Common.ValueListWithFixedValues : true,
        Common.FieldControl : #Mandatory,
)};

annotate service.Orders with {
    OrderNo @(Common.FieldControl : #Mandatory,
)};

annotate service.Orders with {
    netAmmount @(
        Common.FieldControl : #ReadOnly,
    )
};

annotate service.Orders with {
    currency @Common.Text : {
        $value : currency.name,
        ![@UI.TextArrangement] : #TextFirst
    }
};

annotate service.Orders.Items with @(
    UI.LineItem #OrdersItems : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : '{i18n>Id}',
        },
        {
            $Type : 'UI.DataField',
            Value : product_ID,
            Label : '{i18n>Product}',
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : title,
            Label : '{i18n>Title}',
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Label : '{i18n>Quantity}',
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : unit_code,
            Label : '{i18n>Unit}',
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : price,
            Label : '{i18n>Price}',
            ![@UI.Importance] : #High,
        },
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Detail',
            ID : 'ItemDetail',
            Target : '@UI.FieldGroup#ItemDetail',
        },
    ],
    UI.Identification : [
        
    ],
    UI.FieldGroup #ItemDetail : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : up_.Items.product_ID,
                Label : '{i18n>Product}',
            },
            {
                $Type : 'UI.DataField',
                Value : up_.Items.title,
                Label : '{i18n>Title}',
            },
            {
                $Type : 'UI.DataField',
                Value : up_.Items.quantity,
                Label : '{i18n>Quantity}',
            },
            {
                $Type : 'UI.DataField',
                Value : up_.Items.unit_code,
                Label : '{i18n>Unit}',
            },
            {
                $Type : 'UI.DataField',
                Value : up_.Items.price,
                Label : '{i18n>Price}',
            },
        ],
    },
    UI.DataPoint #rating : {
        $Type : 'UI.DataPointType',
        Value : quantity,
        Title : '{i18n>RatingBasedOnQuantity}',
        TargetValue : 5,
        Visualization : #Rating,
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'quantity',
            Target : '@UI.DataPoint#rating',
        },
    ],
);

annotate service.Orders.Items with {
    ID @Common.FieldControl : #ReadOnly
};

annotate service.Orders.Items with {
    product @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Products',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : product_ID,
                    ValueListProperty : 'product_ID',
                },
            ],
            Label : 'Products',
        },
        Common.ValueListWithFixedValues : false
)};

annotate service.Products with {
    ID @Common.Text : {
        $value : title,
        ![@UI.TextArrangement] : #TextLast,
    }
};

annotate service.Status with {
    code @Common.Text : {
        $value : descr,
        ![@UI.TextArrangement] : #TextLast,
    }
};

annotate service.Products with {
    product_ID @Common.Text : {
        $value : title,
        ![@UI.TextArrangement] : #TextLast,
    }
};

annotate service.Orders.Items with {
    title @Common.FieldControl : #ReadOnly
};

annotate service.Orders.Items with {
    price @Common.FieldControl : #ReadOnly
};

annotate service.Orders.Items with {
    unit @Common.ValueListWithFixedValues : true
};

annotate service.Mensure with {
    code @Common.Text : descr
};

annotate service.Orders with {
    qtyTotal @(
        Common.FieldControl : #ReadOnly,
        )
};

