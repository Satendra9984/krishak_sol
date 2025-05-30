# 📄 Bhoomi Shakti Application

**Submitted by:** Omnistacks Technologies  
**Prepared for:** Mr. Srinivasa V. Reddy  
**Date:** 22-05-2025

---

## 🔍 Project Overview

**Bhoomi Shakti** is an agriculture-focused digital solution designed to empower farmers with actionable soil insights and streamline agri-service delivery workflows through a seamless and accessible mobile-first approach.

The application consists of three integrated modules — **Farmer**, **Agent**, and **Admin** — focusing on soil testing, crop advisory, product ordering, and stakeholder management.

> Our goal is to digitize the farm-to-lab-to-market process while offering intuitive user experience and real-time insights to boost productivity and sustainability for Indian farmers.

---

## 🧩 Module Breakdown

### 📱 1. Farmer Module (Flutter App)

Farmers can:

- Register/login via mobile OTP (JWT-based authentication)
- Request a soil test by sharing farm details
- View all their soil reports and detailed crop advisory
- Access personalized recommendations:
  - Recommended crops
  - Fertilizers, pesticides, and seeds
  - Soil preparation steps
  - Services offered (can be ordered)
- Browse products and services
- Place orders and make payments (UPI / Netbanking / Cards)

---

### 👨‍🌾 2. Agent Module (Flutter App – Role-based Access)

Agents will:

- Login via mobile OTP (JWT-based)
- Visit farms and perform soil testing
- Enter soil data parameters directly in the app:
  - `phLevel`, `electricalConductivity`, `organicCarbon`, `nitrogen`, `phosphorus`,  
    `potassium`, `sulphur`, `zinc`, `boron`, `iron`, `manganese`, `copper`,  
    `temperature`, `humidity`, `windSpeed`, `precipitation`
- Generate crop advisory using our expert-curated agronomy dataset
- Manage:
  - Orders
  - Product inventory (Add/Edit/Delete)
  - Earnings and payment status
  - Assigned soil tests and their completion status

---

### 🖥️ 3. Admin Module (React Dashboard)

Admins (email + password authentication) can:

- Manage all users: Farmers, Agents
- Manage the Agronomy Table for crop advisory generation
- Add/Edit/Delete:
  - Products
  - Crops
  - Services
- Monitor and manage:
  - All soil tests
  - Orders
  - Payments (for agents and service providers)
  - Reports across the system

---

## 🧪 Soil Test Inputs

Agents will input the following scientific values:

```java
private Float phLevel;
private Float electricalConductivity;
private Float organicCarbon;
private Float nitrogen;
private Float phosphorus;
private Float potassium;
private Float sulphur;
private Float zinc;
private Float boron;
private Float iron;
private Float manganese;
private Float copper;
private Float temperature;
private Float humidity;
private Float windSpeed;
private Float precipitation;




Final Advice
Start with SWE-1-lite for most of your Flutter work—it’s unlimited and tuned for real-world software engineering.

Switch to SWE-1 for more complex or multi-step tasks while it remains free.

Use Gemini 2.5 Pro or Claude 3.7 Sonnet for the toughest coding challenges, especially if you have credits to spare.

This approach balances performance, access, and cost for Flutter development on Windsurf as a free user.