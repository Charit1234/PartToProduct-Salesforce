# Salesforce Assignment - Part to Product Synchronization

## Overview
This project synchronizes custom **Part (SQX_Part__c)** records with standard **Product2** records in Salesforce.

- Runs daily at **6 AM IST**
- Associates active parts with products
- Creates new products if not found
- Restricted to **System Administrators** or users with **CQ Product Admin** permission set

---

## Components
### Objects
- **SQX_Part__c (Custom Object)**
  - Name (Part Name)
  - Part Number (Unique, Text 255)
  - Active (Checkbox)
  - Product (Lookup → Product2)

### Apex Classes
- `PartToProductService.cls` → Core logic
- `PartToProductBatch.cls` → Batch job
- `PartToProductScheduler.cls` → Daily scheduler
- `PartToProductBatchTest.cls` → Unit tests (>90% coverage)

### Permission Set
- `CQ_Product_Admin` → Grants Apex class access

---

## Deployment
1. Deploy to an org:
   ```bash
   sfdx force:auth:web:login -a AssignmentOrg

2. Deploy the source code:
   ```bash
   sfdx force:source:deploy -p force-app

3. Assing the permission set:
   ```bash
   sfdx force:user:permset:assign -n CQ_Product_Admin -u AssignmentOrg

4. Run unit tests:
   ```bash
   sfdx force:apex:test:run --classnames PartToProductBatchTest --resultformat human --codecoverage --synchronous -u AssignmentOrg

5. Schedule the daily job:
   ```bash
   System.schedule('PartToProduct Daily Job', '0 0 6 * * ?', new PartToProductScheduler());

