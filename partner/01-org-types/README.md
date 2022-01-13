# Org Types

## Customer
- Sandboxes - staging and testing
- Production

## ISV Business
- PBO
- LMO
- Environment Hub
- Partner Community

## Development and Testing
- Dev Hub
- DX Scratch Orgs
- Dev Orgs
- Packaging Orgs
- Trailforce


<br>

---
## Run your business

### PBO (Partner Business Org)
- PBO allows you to run your business.
- Inside PBO you will find:
  - LMA (License Management App)
    - Manage leads and licenses for the AppExchange offering
  - COA (Channel Order App)
    - Create, submit and track orders with Salesforce
  - CMA
  - Environment Hub
    - Spin-up product-ready orgs to test the app in varying Salesforce editions
  - Developer Hub
    - Create and manage Salesforce DX scratch orgs for development


#### LMA: a PBO App
- Manage Licenses
- Leads and Listings
- Licenses for installs
- Support COnsole
- Linked with MFA (Feature Management App)

#### COA: a PBO App
- Submit Orders
- Contract Terms
- Revenue Sharing
- Product Catalogue

* Note: not all partners use COA

<br>

---
### Develop and Test
Environment Hub and Developer Hub allow you to:
- Plan
- Code
- Build
- Test
- Release

They also allow:
- CLI for integration with 3rd party editors
- IDEs, Text Editors, Language Services
- Scratch orgs for dev, built off of source
- Continues integration with test automation
- Packaging to streamline delivery to prod
- Sandboxes for performance testing, UAT, Staging
- Continues delivery/ Build automation

#### Developer Hub
Spin up Scratch Orgs

- Included with PBO
- Authorize SFDX Scratch Org
- Source-Driven Development
- CLI Automation
- Develop and Test with CI/CD
- Org Shaping Configuration

#### Environment Hub: a PBO App
Spin up actual orgs that are related to Salesforce production orgs
- Create Test/Demo orgs
- Packaging Orgs
- Connect Orgs
- Login and SSO

![Create Org](./img/create-org.png)

<br>

---
### Package and List
Packaging Org (Golden Package Org) created by Environment Hub.

Packaging org allows to:
- Register package namespace
- Install new package version
- Linked to AppExchange

<br>

---
### Security Review
You need to spin up a Partner Edition Org from Environment Hub.

Partner Edition Org will be an exact copy of Golden Package Org.

<br>

---
### Deliver Trials
Trial allows customers to test drive application before buying them.

#### TSO - Trial Source Orgs
- Generated from EnvHub/TMO (Trial Manage Org)
- Create templates preconfigured with sample data
- Curated for specific customers

---

### References
- [Salesforce Developers - EnvHub, DevHub, Trials, Oh My! ! Org Best Practices for ISVs](https://www.youtube.com/watch?v=PsjfNAfbSbc)
