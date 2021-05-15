# Organization Setup

The first knowledge area of the Salesforce Certified Administrator exam guide is about the Organization Setup.

It includes setting up Company Information, such as:

- Fiscal Year Settings
- Business Hours
- Currency Management
- Default Settings
- etc.

It also deals with various UI features that an Administrator controls, for instance:

- UI Settings
- Search Settings
- List Views
- Home Page Layouts

<br>

## Company Settings

<br>

### Company Information

<br>

Developer edition has more limits.

<br>

#### Currency Settings

- Edit company information
- Turn on multiple currencies: permanent change
  - Exchange rate
  - Base currency should be set

<br>

#### Currency Setup

After enabling **Multiple Currency**, the Company Information will have a button called **Currency Setup**.

This is not visible before.

We can specify the new currency we want to support and conversion rate.

To manage exchange rates, we should enable **Advanced Currency Management**.

By enabling that feature we can specify exchange rates for specific Dates (and after).

*Parenthetical Currency Conversion:*
If user currency is different from currency of the record, the converted amount will be displayed in parentheses.

<br>

#### Locale Settings

Default language

The user record has to change in order to see the effect.<br>
Setup -> Users -> User -> Language

<br>

### Fiscal Year

Irreversible.

<br>

### Business Hours

- Hours that support team is available.
- Part of Service Cloud.

<br>

### Holidays

- Create holiday details


<br>

## User Interface

Setup -> User Interface -> User Interface

<br>

### User Management

Setup -> Users -> User Management Settings

Affects user interface - not mush a user setup.

- Enable
  - ENhance Profile List Views
  - Enhance Profile User Interface

GDPR settings:

- Enable
  - User Self Deactivate
  - Scramble Specific Users' Data


<br>

### Search Settings

Can only be done in Cliassic
Setup -> Search Settings

You can click on Help on top corner of page to see docs

Number of search results per object.

<br>

### List Views - Create and Filter

- Object Tab
- Clone List View
- Create Chart

<br>

### Kanban List Views

We can view records in different stages - when we group by an item.

<br>

### Home page layout

It's the view user can see in Home tab.

Differs significantly between Classic and Lightning.

- Classic: Setup -> Build -> Customize -> Home -> **Home Page Layouts**
- Lightning: Home Tab -> Gear Icon -> Edit Page

<br>

### Themes and Branding

Only available in Lightning experience.

- Setup -> User Interface -> **Themes and Branding**

We can create custom theme. Up to 300 different themes.