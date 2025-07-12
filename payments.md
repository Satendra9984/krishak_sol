# Cart Payments: Checkout and Payment Feature Development

We are developing the checkout and payment features for our application. Users will have products in their cart and proceed to payment.

-----

## Core Requirements & Scope

1. **Guest Users:** We **do not** need to handle guest users. All users are authenticated.
2. **Payment Methods:** We support **two** payment methods:
      * **CASH**
      * **ONLINE**
3. **Payment Gateway:** We integrate with **one** payment gateway: **CASHFREE**.
4. **Currency:** We only support payments in **Indian Rupees (INR)**.
5. **Payment Statuses:** We manage **two** payment statuses:
      * **PENDING**
      * **COMPLETED**

-----

## Backend API Flow

The current backend API flow involves creating a payment and then handling the payment based on the selected method.

### 1\. Create Payment API

* **Endpoint:** `{{remote}}/payments`
* **Method:** `POST`
* **Request Body:**

    ```json
    {
        "amount": 100.00,
        "paymentMode": "ONLINE" // or "CASH"
    }
    ```

* **Response for ONLINE paymentMode:**

    ```json
    {
        "paymentId": 25,
        "cashfreeOrderResponse": {
            "order_id": "order_28742zjH3f5K2nym5Ol4oxiXMx8efhN",
            "order_expiry_time": "2025-08-10T18:06:05+05:30",
            "payment_session_id": "session_f5rAktmsfOxvrkUKqn4mCp7mbkmAUd-qt3qBCnlnD_PhtOeTlGw0qCokhcUupaBK876AuvTcSESla7FQrcLAK064RfgiN96aMzehWOaVrdSTJLwBUJFi9JiH"
        }
    }
    ```

* **Response for CASH paymentMode:**

    ```json
    {
        "paymentId": 26,
        "cashfreeOrderResponse": null
    }
    ```

  * **Note:** The `paymentId` received from this API call is crucial for subsequent operations.

### 2\. Post-Payment Actions (Frontend Logic)

#### A. For ONLINE Payments

* **Action:** After receiving the `cashfreeOrderResponse`, the **Cashfree Flutter SDK** must be initialized and used to open the payment screen.
* **Required Data for SDK:** The `order_id` and `payment_session_id` from the `cashfreeOrderResponse` are essential for the SDK.
* **Success Callback:** Upon successful completion of the online payment via the Cashfree SDK, a backend API needs to be called to update the payment status to **COMPLETED**.
  * **Dummy API (for now):** We need to call a simple, placeholder API for status update.
    * **Endpoint (example):** `{{remote}}/payments/{{paymentId}}/status/completed` (or similar, to be defined later by backend)
    * **Method:** `PUT` (or `POST`)
    * **Request Body (example, if any data is needed):** `{ "status": "COMPLETED" }`
    * **Note:** The `paymentId` from the initial "Create Payment" call should be used here.

#### B. For CASH Payments

* **UI Action:** A simple confirmation screen should be displayed to the user, prompting them to confirm the cash payment. This screen should include a "Confirm Payment" button.
* **Backend API Call on Confirmation:** When the user confirms the cash payment, the following backend API must be called to create the order:
  * **Endpoint:** `{{local}}/orders/`
  * **Method:** `POST`
  * **Request Body:**
        ```json
        {
            "items": [
                {
                    "productId": 1,
                    "quantity": 2
                }
            ],
            "paymentId": 1, // This should be the paymentId obtained from the initial /payments API call
            "agentId": 1    // This will be hardcoded for now, but will eventually come from a dropdown.
        }
        ```
  * **Note:** The `paymentId` from the initial `/payments` API call (when `paymentMode` was `CASH`) must be used in this request. The `agentId` will be static initially but is intended to be dynamic from a dropdown in a future iteration.

-----

## UI/UX Considerations (for LLM to consider when generating UI code)

* **Payment Method Selection:** A clear and intuitive way for users to select between "CASH" and "ONLINE" payment methods on the cart/checkout screen.
* **Loading States:** Appropriate loading indicators while API calls are in progress (e.g., creating payment, updating status).
* **Error Handling:** User-friendly error messages for failed API calls or payment issues.
* **Success/Failure Feedback:** Clear visual feedback to the user upon successful or failed payment/order creation.
* **Cash Payment Confirmation Screen:** A simple and clear screen for cash payment confirmation, perhaps summarizing the order and prompting for a final "Confirm Payment" action.

-----

Great, this additional information clarifies a lot and helps in tailoring the code generation to your specific architectural choices and future needs.

-----

## Enhanced Understanding for Code Generation

Here's a breakdown of how the new details influence the development approach:

### 1. Error Handling

* **Custom Failure Class:** We'll leverage your `Failure` abstract class. This means any backend API call (e.g., creating a payment, creating an order, updating payment status) that encounters an issue will return a subclass of `Failure`.
* **Layered Approach:** The code generated will incorporate `Either<Failure, T>` (from the `dartz` package, or a similar pattern if not explicitly using `dartz`) in the domain and data layers to explicitly handle success or failure scenarios, making it clean and extensible for future specific error codes.

### 2. "Dummy API" for Status Update

* **Clean Architecture Adherence:** This will be implemented with proper layering:
  * **Data Layer:** A remote data source method (e.g., `updatePaymentStatusRemote`) will simulate the API call (e.g., using `Future.delayed` to mimic network latency) and return `void` on success or a `Failure` on error.
  * **Repository Layer:** A method in the payment repository (e.g., `updatePaymentStatus`) will call the remote data source.
  * **Domain Layer:** A `UseCase` (e.g., `UpdatePaymentStatusUseCase`) will encapsulate this logic, making it easily callable from the presentation layer.
* **Future Robustness:** By structuring it this way, when the actual backend API is ready, only the implementation in the data layer needs to change; the rest of the application layers remain unaffected.

### 3. Agent Selection Dropdown

* **UI Influence:** The UI for the cart/checkout screen will include a **dropdown for agent selection**. Initially, this dropdown will have a hardcoded `agentId` value, but the structure will allow for easy integration of dynamic agent lists later. This implies that the selected `agentId` will be part of the state managed by the checkout screen.

### 4. Cart Data (`CartEntity`)

* **Data Source:** The `CartEntity` will be the primary source for retrieving `items` (productId, quantity) when making the `createOrder` API call. This confirms that we'll access existing cart data.

### 5. Navigation After Payment/Order

* **Success Flow:** Upon successful payment (either online or cash) and order creation, the user will be navigated to the **Orders screen**. This provides a clear path for the user after completing a transaction.

### 6. Handling Payment Outcomes (Success/Failure)

* **Expanded Scope:** We'll explicitly handle both **successful and failed payments** from the Cashfree SDK.
* **Status Updates:** Even in case of a failed online payment, a backend API call will be made to update the payment status (e.g., to `FAILED` or `CANCELLED`, although `PENDING` and `COMPLETED` are the only statuses defined, we'll anticipate a `FAILED` status or similar for online payments). This means the "dummy API" for status updates needs to accommodate different status values. The current scope only defines PENDING and COMPLETED, so for a failed online payment, we will still update the payment status, perhaps back to PENDING or a newly introduced 'FAILED' status. For now, we'll assume a `FAILED` status will be handled gracefully if introduced later, and focus on updating based on the SDK's outcome.

-----

This refined understanding will lead to a more robust, maintainable, and accurate code generation that aligns with your architectural principles and future development plans.
