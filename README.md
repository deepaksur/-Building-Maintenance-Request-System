# 🏗️ Building Maintenance Request System
### SAP ABAP Cloud — RAP Unmanaged Implementation

<p align="center">
  <img src="https://img.shields.io/badge/SAP-ABAP%20Cloud-0070F2?style=for-the-badge&logo=sap&logoColor=white"/>
  <img src="https://img.shields.io/badge/RAP-Unmanaged-FF6B35?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/OData-V4-1D9E75?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Fiori-Elements-0070F2?style=for-the-badge&logo=sap&logoColor=white"/>
  <img src="https://img.shields.io/badge/Draft--Enabled-534AB7?style=for-the-badge"/>
</p>

---

## 📋 Project Overview

A fully functional **Building Maintenance Request System** built on the **SAP RESTful Application Programming (RAP) model** using the **Unmanaged implementation** approach. In an unmanaged app, all transactional logic — create, update, delete, and database save — is written manually in ABAP classes, giving complete control over how data is persisted.

> **Analogy:** Think of it like driving a manual transmission car instead of an automatic. You have full control over every gear shift (save operation), but you do the work yourself.

---

## 👨‍💻 Project Details

| Field | Value |
|---|---|
| **Student Name** | DEEPAK S |
| **Register Number** | 22IT018 |
| **Project Mentor** | Ajayan C |
| **Technology** | SAP ABAP Cloud — Eclipse ADT |
| **RAP Type** | Unmanaged |
| **OData Version** | OData V4 – UI |
| **UI Framework** | SAP Fiori Elements (List Report + Object Page) |
| **Draft Handling** | Enabled (manual draft tables) |
| **Package** | `ZMK_RAP_BMRS` |

---

## 🗂️ File Structure & Naming Convention

> All objects follow the pattern: `ZBMR_*_22IT018` (max 15 characters)

```
ZMK_RAP_BMRS/
│
├── 📦 Database Tables
│   ├── ZBMR_HDR_22IT018          ← Maintenance Request Header
│   └── ZBMR_ITM_22IT018          ← Maintenance Request Items
│
├── 📦 Draft Tables (auto-generated via Quick Fix)
│   ├── ZBMR_D_HDR_22IT018        ← Draft buffer — header
│   └── ZBMR_D_ITM_22IT018        ← Draft buffer — items
│
├── 📦 Interface Views (CDS)
│   ├── ZBMR_I_HDR_22IT018        ← Root interface view
│   └── ZBMR_I_ITM_22IT018        ← Child interface view
│
├── 📦 Consumption Views (Projection)
│   ├── ZBMR_C_HDR_22IT018        ← Header consumption view
│   └── ZBMR_C_ITM_22IT018        ← Item consumption view
│
├── 📦 Metadata Extensions (UI Labels)
│   ├── ZBMR_C_HDR_22IT018        ← UI facets & column positions (header)
│   └── ZBMR_C_ITM_22IT018        ← UI facets & column positions (items)
│
├── 📦 Behavior Definitions
│   ├── ZBMR_I_HDR_22IT018        ← BDEF — Unmanaged (root + item)
│   └── ZBMR_C_HDR_22IT018        ← BDEF — Projection
│
├── 📦 Implementation Classes
│   ├── ZCL_BMR_UTIL_22IT018      ← Singleton buffer utility class
│   ├── ZBP_BMR_HDR_22IT018       ← Header CRUD handler (create/update/delete/read)
│   ├── ZBP_BMR_ITM_22IT018       ← Item CRUD handler (update/delete/read)
│   └── ZBP_BMR_I_22IT018         ← Saver class (flushes buffer → DB)
│
└── 📦 Service Layer
    ├── ZBMR_SRV_22IT018          ← Service definition
    └── ZBMR_BIND_22IT018         ← Service binding (OData V4 – UI)
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Fiori Elements UI                     │
│              (List Report + Object Page)                 │
└────────────────────────┬────────────────────────────────┘
                         │ OData V4
┌────────────────────────▼────────────────────────────────┐
│           Service Binding  ZBMR_BIND_22IT018             │
│           Service Definition  ZBMR_SRV_22IT018           │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│         Consumption Views  (Projection Layer)            │
│   ZBMR_C_HDR_22IT018  ←→  ZBMR_C_ITM_22IT018           │
│         + Metadata Extensions (UI annotations)           │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│           Interface Views  (CDS Data Model)              │
│   ZBMR_I_HDR_22IT018  ──composition──  ZBMR_I_ITM_22IT018│
└──────────┬──────────────────────────────────────────────┘
           │                    │
┌──────────▼──────────┐  ┌─────▼──────────────────────────┐
│ ZBMR_HDR_22IT018    │  │ ZBMR_ITM_22IT018               │
│ (DB Header Table)   │  │ (DB Item Table)                 │
└─────────────────────┘  └────────────────────────────────┘
           │
┌──────────▼──────────────────────────────────────────────┐
│          Behavior Definition  (Unmanaged)                │
│  ┌─────────────────────────────────────────────────┐    │
│  │  ZCL_BMR_UTIL_22IT018  — Transactional Buffer   │    │
│  │  ZBP_BMR_HDR_22IT018   — Header Handler         │    │
│  │  ZBP_BMR_ITM_22IT018   — Item Handler           │    │
│  │  ZBP_BMR_I_22IT018     — Saver (SAVE METHOD)    │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 Data Model

### Header Table — `ZBMR_HDR_22IT018`

| Field | Type | Description |
|---|---|---|
| `REQUESTNO` *(key)* | `ZBMR_REQNO` (CHAR 10) | Maintenance request number |
| `REQUESTTYPE` | CHAR(10) | Type of maintenance (Electrical, Plumbing…) |
| `PRIORITY` | CHAR(10) | Priority level (High / Medium / Low) |
| `LOCATION` | CHAR(40) | Full location description |
| `BUILDING` | CHAR(20) | Building identifier |
| `FLOOR` | CHAR(10) | Floor number |
| `ROOM` | CHAR(10) | Room number |
| `DESCRIPTION` | CHAR(100) | Problem description |
| `STATUS` | CHAR(10) | Request status (Open / In Progress / Closed) |
| `REQUESTEDBY` | CHAR(20) | Requester ID |
| `ESTIMATEDCOST` | CURR(13,2) | Estimated repair cost |
| `CURRENCY` | CUKY | Currency code |
| Admin fields | — | Created by/at, last changed by/at |

### Item Table — `ZBMR_ITM_22IT018`

| Field | Type | Description |
|---|---|---|
| `REQUESTNO` *(key, FK)* | `ZBMR_REQNO` | Foreign key → header |
| `ITEMNUMBER` *(key)* | INT2 | Line item number |
| `WORKTYPE` | CHAR(20) | Type of work (Rewiring, Painting…) |
| `WORKERASSIGNED` | CHAR(30) | Assigned technician |
| `SPAREPARTNO` | CHAR(20) | Spare part number |
| `SPAREDESCRIPTION` | CHAR(60) | Spare part description |
| `QUANTITY` | QUAN(13,3) | Quantity required |
| `UOM` | UNIT(3) | Unit of measure |
| `ITEMCOST` | CURR(13,2) | Item cost |
| `CURRENCY` | CUKY | Currency code |
| Admin fields | — | Created by/at, last changed by/at |

---

## ⚙️ Implementation Logic

This is an **unmanaged** RAP app — every operation is coded manually:

### Transactional Flow

```
User action (Create / Update / Delete)
        │
        ▼
Handler class (ZBP_BMR_HDR/ITM_22IT018)
  — validates input
  — checks for duplicates via SELECT
  — stores data in singleton buffer (ZCL_BMR_UTIL_22IT018)
        │
        ▼  (on Save / Activate)
Saver class (ZBP_BMR_I_22IT018)
  — reads from buffer
  — MODIFY / DELETE on actual DB tables
  — clears the buffer (cleanup)
```

### Key Classes

#### `ZCL_BMR_UTIL_22IT018` — Buffer Utility (Singleton)
- Acts as an in-memory transactional buffer between the modify phase and the save phase
- Stores pending header and item data, deletion flags, and deletion lists
- `get_instance()` returns the single shared instance across all handler calls in one LUW

#### `ZBP_BMR_HDR_22IT018` — Header Handler
- `CREATE` — checks for duplicate request number, writes to buffer
- `UPDATE` — checks record exists, writes to buffer
- `DELETE` — marks header (and cascaded items) for deletion
- `READ` — reads directly from `ZBMR_HDR_22IT018`
- `CBA_MAINTITEM` — creates child item records (Create-by-Association)
- `RBA_MAINTITEM` — reads associated items (Read-by-Association)

#### `ZBP_BMR_ITM_22IT018` — Item Handler
- `UPDATE` — validates item exists, buffers the update
- `DELETE` — flags individual item for deletion

#### `ZBP_BMR_I_22IT018` — Saver Class
- `SAVE` — flushes all buffered changes to the database (`MODIFY`, `DELETE`)
- `CLEANUP` — calls `cleanup_buffer()` to reset the singleton state

---

## 🚀 Setup & Installation

### Prerequisites

- Eclipse ADT connected to SAP BTP ABAP Environment or S/4HANA Cloud (release ≥ 2022)
- Package `ZMK_RAP_BMRS` created
- Domain and Data Element `ZBMR_REQNO` (CHAR 10) created and activated

### Step-by-step Build Order

> ⚠️ **Follow this order strictly** — objects depend on each other

```
1. Create domain ZBMR_REQNO  (SE11 or ADT)
2. Create ZBMR_HDR_22IT018   (DB table)
3. Create ZBMR_ITM_22IT018   (DB table)
4. Create ZBMR_I_HDR_22IT018 (interface view — DO NOT activate yet)
5. Create ZBMR_I_ITM_22IT018 (interface view)
   → Activate BOTH together (Ctrl+Shift+F3)
6. Create ZBMR_C_HDR_22IT018 (consumption view — DO NOT activate yet)
7. Create ZBMR_C_ITM_22IT018 (consumption view)
   → Activate BOTH together (Ctrl+Shift+F3)
8. Create metadata extensions for ZBMR_C_HDR_22IT018 and ZBMR_C_ITM_22IT018
9. Create ZCL_BMR_UTIL_22IT018  (utility class) — activate
10. Create ZBMR_I_HDR_22IT018 behavior definition (unmanaged)
    → Double-click draft table names → Quick Fix → create & activate draft tables
    → Activate BDEF
11. Use Quick Fix to create class stubs:
    ZBP_BMR_HDR_22IT018, ZBP_BMR_ITM_22IT018, ZBP_BMR_I_22IT018
12. Paste implementation code into each class's Local Types tab → activate
13. Create projection BDEF on ZBMR_C_HDR_22IT018 → activate
14. Create service definition ZBMR_SRV_22IT018 → activate
15. Create service binding ZBMR_BIND_22IT018 (OData V4 – UI) → Publish
16. Click Preview on ZBMR_C_HDR_22IT018 in the service binding
```

---

## 🎬 Demo Screenshots

### Demo 1 — Create a new maintenance request
Enter the request number (e.g. `REQ-001`) in the New Object dialog and click Continue.

### Demo 2 — Fill request details
Fill in Request Type, Priority, Building, Floor, Room, Description, Status, Estimated Cost and Currency. Click Save.

### Demo 3 — Add a maintenance item
Navigate to the Item Details tab → Click Create → Enter Item Number (e.g. `10`) → Continue.

### Demo 4 — Fill item details
Enter Work Type, Worker Assigned, Spare Part No, Quantity, UOM, and Item Cost → Click Apply.

### Demo 5 — Activate (persist from draft to DB)
Click the **Activate** action button to flush the draft record into the permanent database tables.

---

## 🧪 Test the Application

1. Open the Service Binding `ZBMR_BIND_22IT018` in Eclipse ADT
2. Select entity `ZBMR_C_HDR_22IT018` in the Entity Set list
3. Click **Preview** — a browser tab opens with the Fiori Elements list report
4. Click **Go** to fetch existing records
5. Use **Create**, **Edit**, **Delete** buttons to exercise all CRUD operations
6. Verify data is saved in `ZBMR_HDR_22IT018` and `ZBMR_ITM_22IT018` via SE16N or the ADT table browser

---

## 🛠️ Troubleshooting

| Symptom | Fix |
|---|---|
| Red underline on draft table name in BDEF | Double-click the name → Ctrl+1 → Create database table |
| Circular dependency activation error | Select both interface views → Ctrl+Shift+F3 to activate together |
| Class not found after BDEF creation | Use Quick Fix (Ctrl+1) on each red class name to generate stubs |
| Data not saved after clicking Save | Check the Saver class SAVE method — ensure the utility buffer class is the correct singleton |
| Preview button greyed out | Service binding must show **Published** status — click Publish explicitly |
| Draft not activating | Ensure projection BDEF has `use draft;` and exposes all draft actions |
| Foreign key error on item table | Verify domain `ZBMR_REQNO` is active before creating the tables |

---

## 📌 Key Concepts Demonstrated

- ✅ **RAP Unmanaged** — full manual CRUD logic in ABAP classes
- ✅ **CDS Root + Child composition** with foreign key association
- ✅ **Draft-enabled** transactional application (Edit → Activate → Discard flow)
- ✅ **Singleton buffer pattern** — decouples modify phase from save phase
- ✅ **Behavior Definition** with lock master, authorization, etag, and field control
- ✅ **Projection layer** with redirected associations
- ✅ **Metadata extensions** for Fiori list report columns, facets, and selection fields
- ✅ **OData V4 service** published via Service Binding
- ✅ **Fiori Elements preview** — List Report + Object Page with inline item table

---

## 📚 References

- [SAP RAP Documentation](https://help.sap.com/docs/abap-cloud/abap-rap/restful-abap-programming-model)
- [SAP ABAP CDS Reference](https://help.sap.com/docs/ABAP_PLATFORM/f2e545608079437ab165c105649b89db/4ed1f2e06e391014adc9fffe4e204223.html)
- [Fiori Elements Feature Showcase](https://help.sap.com/docs/SAP_FIORI_tools)

---

## 📄 License

This project is for educational purposes as part of the SAP ABAP Cloud curriculum.

---

<p align="center">
  Made with SAP ABAP Cloud &nbsp;|&nbsp; Register No: 22IT018 &nbsp;|&nbsp; Mentor: Ajayan C
</p>
