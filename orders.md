# Key Questions

## Order Types
Are there different types of orders (e.g., product orders, service bookings)?
Should we support order statuses like "pending", "shipped", "delivered", "cancelled"?

## Order Details
What information should be displayed in the order list item?
What details should be shown on the order detail page?
Api: `{{remote}}/orders/`

response:
```json
[
    {
        "orderId": 1,
        "totalAmount": 449,
        "paymentStatus": "INITIATED",
        "orderStatus": "SHIPPED",
        "userId": 1,
        "userName": "Anik Ghosh",
        "userMobileNumber": "1111111111",
        "agentId": 3,
        "agentName": "Bhuban Ruidas",
        "agentMobileNumber": "1231231234",
        "items": [
            {
                "orderItemId": 1,
                "quantity": 5,
                "product": {
                    "productId": 1,
                    "name": "Fresh Wheat Seeds",
                    "price": 10,
                    "stock": 1000,
                    "description": "Fresh Wheat seeds for high growth and production",
                    "manufacturer": null,
                    "imageUrl": "7de03bbe-7e00-404a-b486-97ddfb56c5b8.png",
                    "category": {
                        "categoryId": 1,
                        "name": "Seeds",
                        "description": ""
                    }
                }
            },
            {
                "orderItemId": 2,
                "quantity": 1,
                "product": {
                    "productId": 2,
                    "name": "NPK Fertilizer 00:00:50",
                    "price": 399,
                    "stock": 16,
                    "description": "This is a NPK Fertilizer",
                    "manufacturer": null,
                    "imageUrl": "6178314a-9f25-4c8c-8b58-60b81dd041c6.jpeg",
                    "category": {
                        "categoryId": 2,
                        "name": "Fertilizer",
                        "description": ""
                    }
                }
            }
        ]
    },
    {
        "orderId": 2,
        "totalAmount": 449,
        "paymentStatus": "INITIATED",
        "orderStatus": "SHIPPED",
        "userId": 1,
        "userName": "Anik Ghosh",
        "userMobileNumber": "1111111111",
        "agentId": 3,
        "agentName": "Bhuban Ruidas",
        "agentMobileNumber": "1231231234",
        "items": [
            {
                "orderItemId": 3,
                "quantity": 5,
                "product": {
                    "productId": 1,
                    "name": "Fresh Wheat Seeds",
                    "price": 10,
                    "stock": 1000,
                    "description": "Fresh Wheat seeds for high growth and production",
                    "manufacturer": null,
                    "imageUrl": "7de03bbe-7e00-404a-b486-97ddfb56c5b8.png",
                    "category": {
                        "categoryId": 1,
                        "name": "Seeds",
                        "description": ""
                    }
                }
            },
            {
                "orderItemId": 4,
                "quantity": 1,
                "product": {
                    "productId": 2,
                    "name": "NPK Fertilizer 00:00:50",
                    "price": 399,
                    "stock": 16,
                    "description": "This is a NPK Fertilizer",
                    "manufacturer": null,
                    "imageUrl": "6178314a-9f25-4c8c-8b58-60b81dd041c6.jpeg",
                    "category": {
                        "categoryId": 2,
                        "name": "Fertilizer",
                        "description": ""
                    }
                }
            }
        ]
    },
]

```

## Pagination
Will the orders list support pagination?
Pagination is not supported yet.
Should we implement pull-to-refresh and infinite scroll?
Yes please.

## Order Tracking
What tracking information should be shown (e.g., status timeline, delivery updates)?
You can choose based on the existing json response I provided or can add some static for now.
Will there be real-time updates for order status changes?
No real time updates.

## User Actions
What actions can users perform on orders (cancel, reorder, track, contact support)?
You can choose based on the existing json response I provided or can add some static for now.
Should users be able to rate/review delivered orders?
No rating/review feature.

## Filtering/Sorting
Should users be able to filter orders by status, date range, etc.?
Yes.
What sorting options should be available (newest first, price, etc.)?
You can leave it for now.


## Offline Support
Should the app cache orders for offline viewing?
No not right now.
Should we implement optimistic updates for order actions?
No not right now.

## Error Handling
How should we handle API errors or network issues?
Yes, we had to handle API errors or network issues.
We also have app_exceptions.dart and app_failures.dart in lib/app/core/error to handle erros gracefully in app.
Should we implement retry mechanisms?
Yes, we had to implement retry mechanisms.

## Authentication
Should orders be tied to the logged-in user?
Yes, we had to handle logged-in user. Have user authentication already implemented and can be accessed through currentUserProvider.
We have custom token based authentication system which is handled through api_client and dio-interceptors in app/core/network where tokens are injected in requests and refreshed automatically.

Do we need to handle guest orders?
No, we don't need to handle guest orders.

## UI/UX
Should we follow any specific design system or existing patterns from other parts of the app?
Yes, we had to follow existing patterns from other parts of the app.
Right now we are following Clean Architecture designs
We have products, cart features already implemented.


Are there any specific animations or transitions you'd like for the order flow?
No, we don't need any specific animations or transitions.

## Special Note
Currently I want to access the orders from profile section. So you have to make a profile page also.
A userProfileProvider is also provided for loggedin user details.
Profile will be a page under ui/main_scaffold.dart as a bottomnavbar page.
