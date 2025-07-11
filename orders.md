# Key Questions

## Order Types
Are there different types of orders (e.g., product orders, service bookings)?
Should we support order statuses like "pending", "shipped", "delivered", "cancelled"?

## Order Details
What information should be displayed in the order list item?
What details should be shown on the order detail page?

## Pagination
Will the orders list support pagination?
Should we implement pull-to-refresh and infinite scroll?

## Order Tracking
What tracking information should be shown (e.g., status timeline, delivery updates)?
Will there be real-time updates for order status changes?

## User Actions
What actions can users perform on orders (cancel, reorder, track, contact support)?
Should users be able to rate/review delivered orders?

## Filtering/Sorting
Should users be able to filter orders by status, date range, etc.?
What sorting options should be available (newest first, price, etc.)?

## Offline Support
Should the app cache orders for offline viewing?
Should we implement optimistic updates for order actions?

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