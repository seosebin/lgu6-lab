products = [
    {
        "category": "Electronics",
        "items": [
            {"name": "Laptop", "price": 1200, "stock": 5},
            {"name": "Smartphone", "price": 800, "stock": 10}
        ]
    },
    {
        "category": "Home Appliances",
        "items": [
            {"name": "Vacuum Cleaner", "price": 150, "stock": 7},
            {"name": "Air Conditioner", "price": 500, "stock": 3}
        ]
    }
]

# 결과 형태 
# result = {
#     "Laptop": {"price": 1200, "stock": 5},
#     "Smartphone": {"price": 800, "stock": 10},
#     "Vacuum Cleaner": {"price": 150, "stock": 7},
#     "Air Conditioner": {"price": 500, "stock": 3}
# }


def convert_data(products):
    result = {}
    for category in products:
        for item in category['items']:
            # item: {"name": "Laptop", "price": 1200, "stock": 5}
            
            name = item.pop('name')
            # del item['name']
            
            result[ name ] = item
            
    #         result[ item['name'] ] = {
    #             'price':item['price'],
    #             'stock':item['stock'],
    #         }
    return result


items = convert_data(products)
# print(items)

import json
print( json.dumps(items, indent=2) )