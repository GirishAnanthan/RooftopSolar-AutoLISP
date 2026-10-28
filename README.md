# Rooftop Solar PV Plant Layout Generator for AutoCAD (AutoLISP + DCL)
### Professional PVcase & ARKA 360 Grade Automation for Commercial Rooftop Solar PV Projects

A state-of-the-art AutoCAD automation suite designed for Solar PV design engineers, EPC contractors, and rooftop solar consultants. Modeled after industry benchmarks **PVcase (Roof Mount)** and **ARKA 360 / The Solar Labs**, this suite integrates 2D/3D solar layout generation, DC electrical stringing, inverter station placement, cable tray routing with voltage drop calculation, electrical Single Line Diagram (SLD) schematic generation, dynamic obstacle shadow pruning, financial ROI/payback analysis, and PVsyst 3D coordinate export.

---

## 🌟 Comprehensive Features (PVcase & ARKA 360 Upgrades)

### 1. Automated DC Stringing Engine & Color-Coded Circuits (PVcase Style)
- **Commands**: `PVSTRING`, `PVSTRINGING`, `PVCLEARSTRINGS`
- **Snake Topology (Boustrophedon)**: Modules on layer `PV_MODULES` are clustered into rows and sorted in an alternating West-to-East and East-to-West snake pattern to minimize DC cable loop area and reduce induced surge voltages.
- **Configurable String Size**: Groups modules into strings matching inverter MPPT specifications (e.g. 18 to 24 modules per string, default 20 modules).
- **Color-Coded Polylines**: Routes continuous string polylines on layer `PV_STRINGS` (Lineweight 0.35 mm) using cycling vivid colors (Red, Cyan, Yellow, Green, Magenta, Orange, Blue, Violet).
- **Terminal Markers & Circuit Tags**:
  - `[+]` Red circle & plus symbol at String Positive terminal (Module 1).
  - `[-]` Blue circle & minus symbol at String Negative terminal (Module N).
  - Stamped string annotation on layer `PV_STRING_TAGS`: e.g. `STR-01 (20M | 11.0 kWp | 828V)`.

### 2. Inverter Station Placement & Cable Tray Routing (PVcase Style)
- **Commands**: `PVINVERTER`, `PVPLACEINVERTER`, `PVCABLETRAY`, `PVCLEARCABLETRAY`
- **Inverter Station Placement**:
  - Interactive placement on rooftop. Draws concrete foundation plinth pad ($1.6\text{m} \times 1.2\text{m}$), inverter enclosure with heat-sink cooling fins, DC disconnect switch, AC isolator box, and multi-line engineering ratings tag on layer `PV_INVERTER`.
- **Perforated GI Cable Tray Corridor**:
  - Configurable tray width (default $0.30\text{m}$).
  - User picks points to route the cable tray corridor from the PV array towards the Inverter Station.
  - Automatically draws parallel rails and ladder cross rungs spaced every $0.30\text{m}$ on layer `PV_CABLE_TRAY`.
  - **Engineering Cable Estimation & %Vdrop**: Calculates total tray length, total DC $1\text{C} \times 4/6\text{ mm}^2$ homerun solar cable length, and computes DC % Voltage Drop ($\%V_{\text{drop}}$). Automatically flags compliance ($< 1.5\%$ as per IEC 60364-7-712).

### 3. Electrical Single Line Diagram (SLD) Schematic Auto-Generator (ARKA 360 Style)
- **Commands**: `PVSLD`, `PVDRAWSLD`
- Generates a publication-ready, fully annotated Single Line Diagram on layer `PV_SLD` compliant with **IEC 62446-1** and **IEC 60364-7-712**:
  - **DC Field**: PV array string symbols with $V_{oc}$, $V_{mp}$, 15A 1000V DC gPV fuses, Class II DC Surge Protection Devices (SPD) with earth ground, and 2-pole DC isolator rotary switches.
  - **Inverter Station**: Multi-MPPT DC-DC boost stage, PWM IGBT DC-AC inverter bridge, microprocessor controller, IP65 enclosure, and dedicated low-resistance earth pit ($< 2\ \Omega$).
  - **AC Distribution**: 4-Pole AC MCCB breaker, Class II AC SPD (40kA), 3-phase bi-directional Net Energy Import/Export Meter, LT busbar (415V, 50Hz), and utility grid connection.
  - **Engineering Cable Schedule & Legend**: Complete conductor cross-sections, tray types, grounding standards, and design notes.

### 4. 3D Isometric Visualization & Over-Shaded Module Pruner (PVcase & ARKA 360)
- **Commands**: `PV3D`, `PV3DVIEW`, `PVCLEAR3D`, `PVPRUNESHADED`, `PVCHECKSHADING`
- **3D Modeling & Visualization**:
  - Converts placed 2D modules into tilted `3DFACE` planes at project tilt angle $\beta$ and azimuth on layer `PV_3D_MODULES`.
  - Generates 3D Module Mounting Structure (MMS) vertical support legs and purlins connecting modules to the roof on layer `PV_3D_STRUCTURE`.
  - Extrudes obstacles into 3D solid blocks up to their defined elevation heights on layer `PV_3D_OBSTACLES`.
  - Automatically switches viewport to South-West Isometric (`_SWISO`) with Conceptual Shading (`VSCURRENT _C`).
- **Over-Shaded Module Pruning**:
  - Scans all placed modules against winter solstice obstacle shadow envelopes.
  - Highlights over-shaded modules in high-contrast Red, calculates exact shading percentage and PR loss.
  - Prompts user to prune (auto-delete) shaded modules, instantly updating active module count, system capacity (kWp), and protecting array Performance Ratio from hot-spot degradation.

### 5. Financial ROI Engine & PVsyst 3D Scene Export (ARKA 360 Style)
- **Commands**: `PVPVSYST`, `PVEXPORTPVSYST`
- **Financial ROI & Payback**:
  - **Multi-Currency Engine**: Dropdown selection in Tab 6 for major world currencies: **INR (Rs.)**, **USD ($)**, **EUR (EUR)**, **GBP (GBP)**, **AED (AED)**, **SAR (SAR)**, **AUD (A$)**, **CAD (C$)**, **JPY (JPY)**, **SGD (S$)**, and **ZAR (R)**. Selecting a currency automatically suggests realistic local market defaults for grid electricity tariff (e.g. `INR 7.50 / kWh` vs `USD 0.10 / kWh`) and turnkey EPC cost (e.g. `INR 42.00 / Wp` vs `USD 0.85 / Wp`).
  - Computes Total CapEx, Year 1 Electricity Bill Savings, Simple Payback Period (Years), 25-Year Cumulative Net Savings, Levelized Cost of Electricity (LCOE), and Return on Investment (ROI %).
  - Seamlessly embedded into the simulation report (`PVSIMREPORT`), energy table (`PVENERGYTABLE`), and live status banners.
- **PVsyst 3D Scene Coordinate Export**:
  - Exports a PVsyst-compatible 3D array layout CSV (`PVsyst_3D_Layout.csv`) with `Table_ID, X_Center, Y_Center, Z_Base, Width, Length, Tilt, Azimuth, Modules_Count, String_ID` for direct import into PVsyst 7/8 near-shading 3D scene.

### 6. Maintenance Walkways & Safety Systems
- **Commands**: `PVWALKWAY`, `PVCLEARWALKWAY`, `PVFALLSAFETY`, `PVHANDRAIL`
- **Configurable Walkway Frequency (Rows & Columns)**: Define horizontal walkway frequency (every $N$ module rows) and vertical walkway frequency (every $M$ module columns) directly in Tab 3 and Tab 4. Auto-draws amber corridor paths on layer `PV_WALKWAY`.
- **Custom Walkway Corridors**: Configurable corridor width (default $0.80\text{m}$) with interactive path routing. Modules automatically avoid defined walkway paths.
- **Safety Lines as Obstacles**: All safety lines (Fall Safety wire rope lifelines on `PV_FALL_SAFETY` and dual-rail guardrails on `PV_HANDRAIL`) drawn within the roof boundary are automatically detected as physical exclusion obstacles with safety buffers—modules are never placed over safety lines.
- **Fall Safety Lifelines (EN 795 / OSHA 1926)**: End anchor plates with spring-loaded wire tensioners, 90° corner turn deflection pulleys, and intermediate rope guides.
- **Perimeter Handrails**: Dual-rail perimeter guardrails with top rail ($1100\text{mm}$), mid rail ($550\text{mm}$), and stanchion post flange bases.

### 7. Core Rooftop Sizing, PAN/OND Parsers & Persistent PVCompLib
- **RCC Flat Roof & Metal Sheet Roof** (Flush mount & Elevated tilt legs).
- **PAN File & OND File Parsers**: Full electrical parameters for modules and inverters.
- **Persistent Component Library (`PVCompLib.lsp`)**:
  - Automatically created and saved in the **same folder from which the LISP file is loaded**.
  - Any time a new `.PAN` module or `.OND` inverter is loaded/parsed, it is automatically appended and permanently saved into `PVCompLib.lsp`.
  - When starting any new project or opening a new drawing, `PVCompLib.lsp` is auto-loaded immediately, ensuring all your custom equipment is always available in the dropdowns without needing to browse files again!
  - Command: `PVCOMPLIB` (Manage, List, Reload, or Open the persistent library).
- **Sizing Modes**: Fill Polyline Boundary (Max Capacity) vs. Target Plant DC Capacity (kWp).
### 8. Multi-Tabbed SolarTools DCL Interface (Organized Segments)
- **Command**: `SOLARTOOLS` (Aliases: `ROOFTOPSOLAR`, `SOLARPV`, `SOLARLAYOUT`)
- **6 Dedicated Tab Segments**:
  1. **Tab 1: Site & Rooftop**: Project name, weather source, lat/lon coordinates, design tilt & azimuth, roof structure, mounting option, sizing mode (Max fill vs. Target kWp), setback, roof slope, module clearance, and base PR %.
  2. **Tab 2: Equipment (.PAN / .OND)**: Solar PV module selection with PAN parser, live electrical specs (Vmp, Imp, Voc, muPmp, efficiency), string inverter selection with OND parser, and operating parameters (MPPT count, voltage windows, Euro efficiency).
  3. **Tab 3: Array Layout & Obstacles**: Table arrangement (Cols x Rows), winter-solstice auto-pitch calculator, inter-module column and row gaps, obstacle height, winter-solstice shadow envelopes (North-facing for India / Northern Hemisphere), maintenance walkway frequencies (horizontal row and vertical column frequency), and full CAD layout execution steps (Pick Boundary, Pick Obstacles, Clear Obstacles, Generate Layout, Clear Layout).
  4. **Tab 4: Walkways & Safety Systems**: Maintenance walkway corridor width and interactive routing, EN 795 fall safety lifeline with spring tensioners, and perimeter dual-rail guardrails.
  5. **Tab 5: Electrical & 3D (PVcase & ARKA 360)**: DC stringing engine with modules per string, inverter station plinth placement, perforated GI cable tray routing with %Vdrop calculation, IEC 62446-1 Single Line Diagram (SLD), 3D isometric tilted tables & MMS support legs, obstacle shadow audit & module pruning, and PVsyst 3D scene CSV export.
  6. **Tab 6: Financial ROI & BOM**: Grid electricity tariffs, turnkey EPC cost per watt, live CapEx/Payback/25-Yr savings/LCOE display, AutoCAD native 25-Yr Energy Table, Bill of Materials (BOM), IEC 61724 simulation report, and CSV data export.
- **Navigation**: Instant top tab bar switcher, sequential `<< Back` and `Next >>` wizard navigation, and persistent state across all tabs and AutoCAD pick prompts.

---

### 9. PVDesigner 2027 Advanced Engineering Suite
- **Complex Roof Modeling**:
  - `PVHIPSPLIT`: Bisects hip and valley roofs along ridgelines into distinct planar faces.
  - `PVDOMESPLIT` & `PVONEDOME`: Discretizes curved cylindrical barrel vaults into facet strips or merges faceted segments into a single coordinate plane.
  - `PVROOFNUM`: Stamps `[RF-01]`, `[RF-02]` boundary identifiers with calculated net usable roof area.
  - `PVSHOWALLOFFSET` & `PVHIDEALLOFFSET`: Toggles visual boundary parapet setback offset guides.
- **East-West Dual-Tilt System**:
  - `PVLAYOUTEW`: Places high-density dual-tilt (A-frame / butterfly) arrays facing East (90°) and West (270°).
  - `PVSTRINGEW`: Series strings East-facing modules (`PV_MODULES_EAST`) and West-facing modules (`PV_MODULES_WEST`) in completely isolated series circuits, preventing hazardous cross-orientation current mismatch.
  - `PVEWVIS`: Interactive visibility toggle to isolate East or West subarrays in complex multi-megawatt designs.
- **Enhanced DC Stringing & Electrical Engine**:
  - `PVSTRINGMANUAL`: Interactive click-to-wire manual stringing for irregularly shaped arrays or custom conduit layouts.
  - `PVPOLARITY`: Reverses circuit polarity on any selected string, inverting the `[+]` and `[-]` terminal poles to optimize homeruns.
  - `PVSTRINGVIS`: Convex-hull string cluster visualizer providing immediate colored boundary groupings for quality assurance.
  - `PVPANELNUM`: Automatic module-level serialization: `STR-01-01`, `STR-01-02` ... `STR-01-20`.
  - `PVMPPTDETAILS`: Displays the inverter MPPT tracking matrix, minimum/maximum voltage windows, and input allocations.
  - `PVMPPTLINK`: Interactively selects a string homerun pole and routes an electrical tie line directly to the designated inverter MPPT input.
- **Cable Calculations & AC Balance of System**:
  - `PVDCROUTETRACKED`: Routes home-run DC cables snapped to designated tray corridors with automatic length accumulation.
  - `PVDCROUTECOLORPOLARITY`: Distinguishes positive Red (+) and negative Black (-) DC conduits with polarity separation.
  - `PVCABLECALC`: BS 7671 / IEC 60364-7-712 cable cross-section ($4\text{ mm}^2, 6\text{ mm}^2, 10\text{ mm}^2$) and percentage voltage drop ($\%V_{\text{drop}}$) sizing calculator.
  - `PVACEQUIPMENT`: Places AC Distribution Boards (ACDB), Main Switchboards (MSB), and step-up transformers with ratings annotations.
  - `PVDCSCHEDULE`: Generates an AutoCAD native DC cable schedule table documenting string IDs, module counts, cable types, cross-sectional areas, lengths, and verified voltage drops.
- **Native PVsyst 3D Scene (.PVC) & Pre-Flight Validation**:
  - `PVPVSYSTEXPORT`: Direct export of the entire rooftop array into native PVsyst 7/8 `.PVC` 3D scene file format.
  - `PVVALIDATE`: Comprehensive pre-flight engineering audit verifying module-boundary clearances, MPPT string voltage compliance, and shading risks before construction sign-off.
  - `PVDIMPLAN`: Automated dimensioning of inter-row pitch, boundary setbacks, and walkway corridors.

---

## 🚀 Quick Command Reference

| Command | Alias | Module / Category | Description |
|---|---|---|---|
| `PVMENU` | `PVDCL`, `PVCOMMANDS`, `PVHUB` | Master Hub | **Master Functions Control Center** dialog to trigger all actions |
| `SOLARTOOLS` | `ROOFTOPSOLAR`, `SOLARPV`, `SOLARLAYOUT` | Full Suite | **Multi-Tabbed Master Designer Dialog** (6 dedicated tabs) |
| `PVSTRING` | `PVSTRINGING` | Electrical (PVcase) | **Automated DC Stringing**: Snake wiring, color circuits, [+] / [-] tags |
| `PVSTRINGMANUAL`| — | Electrical (PVDesigner) | **Manual Stringing**: Interactively click modules in custom sequence |
| `PVSTRINGEW` | — | Electrical (PVDesigner) | **East-West Stringing**: Independent series circuits for East & West arrays |
| `PVPOLARITY` | — | Electrical (PVDesigner) | Toggles start/end `[+]` and `[-]` polarity poles for selected string |
| `PVSTRINGVIS` | — | Electrical (PVDesigner) | Visualizes string clusters with colored grouping envelopes |
| `PVPANELNUM` | — | Electrical (PVDesigner) | Sequential panel numbering: `STR-01-01`, `STR-01-02` ... |
| `PVCLEARSTRINGS`| `PVCLEARSTRING` | Electrical (PVcase) | Clears all string polylines and circuit tags |
| `PVMPPTDETAILS` | — | Electrical (PVDesigner) | Inverter MPPT tracker voltage & input allocation matrix |
| `PVMPPTLINK` | — | Electrical (PVDesigner) | Connects string home run to designated inverter MPPT input |
| `PVDCROUTETRACKED`| — | Electrical (PVDesigner) | Routes DC homerun snapped along cable tray corridor |
| `PVDCROUTECOLORPOLARITY`| — | Electrical (PVDesigner) | Dual Red (+) & Black (-) polarity conduits |
| `PVCABLECALC` | — | Calculations (BS 7671) | DC/AC conductor cross-section ($mm^2$) & $\%V_{drop}$ calculator |
| `PVDCSCHEDULE` | — | Deliverables | AutoCAD native DC Cable Schedule Table |
| `PVACEQUIPMENT` | — | Balance of System | Inserts ACDB, Main Switchboard & Transformer equipment |
| `PVLAYOUT` | — | Layout Setup | Populates solar PV modules inside boundary (Max Fill or Target kWp) |
| `PVLAYOUTEW` | — | Layout (PVDesigner) | Generates dual-tilt East-West (A-frame / butterfly) layout |
| `PVEWVIS` | — | Layout (PVDesigner) | Toggles East vs West subarray visibility |
| `PVMULTIROOF` | `PVROOFS` | Roof Management | **Multi-Roof Manager**: Manage multi-building and multi-zone roof sets |
| `PVROOFLIST` | — | Roof Management | **Multi-Roof Inventory**: Displays list of all roofs with area (m²) and handles |
| `PVSELECTROOF`| — | Roof Management | Set active roof target or toggle to ALL roofs |
| `PVHIPSPLIT` | — | Roof Modeling | Divides hip & valley roof polylines along ridgelines |
| `PVDOMESPLIT` | — | Roof Modeling | Discretizes curved dome / barrel roof into flat facets |
| `PVONEDOME` | — | Roof Modeling | Converts multi-facet barrel roof into single coordinate pitch |
| `PVROOFNUM` | — | Roof Modeling | Labels roof boundaries with sequential IDs (`RF-01`, `RF-02`) |
| `PVBLDG3D` | `PVBUILDING3D` | 3D Building | **3D Building Outlines**: Interactive roof slope (1/2/4 dir) & 3D building modeler |
| `PVSHOWALLOFFSET`| `PVHIDEALLOFFSET` | Roof Modeling | Toggles parapet setback offset visual guides |
| `PVDIMPLAN` | — | Drafting | Automated dimensioning of row pitch, setbacks & spacing |
| `PVVALIDATE` | — | Engineering Audit | Automated pre-flight check of boundaries, MPPT voltage & shading |
| `PVPVSYSTEXPORT`| — | Export (PVsyst) | Exports native PVsyst 3D scene (`.PVC`) file |
| `PVINVERTER` | `PVPLACEINVERTER` | Electrical (PVcase) | Places Inverter Station pad, enclosure, DC/AC switches & ratings |
| `PVCABLETRAY` | `PVDRAWCABLETRAY` | Electrical (PVcase) | Routes GI perforated cable tray corridor with %Vdrop calculation |
| `PVCLEARCABLETRAY`| — | Electrical (PVcase) | Clears cable tray corridor entities |
| `PVSLD` | `PVDRAWSLD` | Electrical (ARKA 360) | **Single Line Diagram**: Generates complete IEC 62446-1 SLD schematic |
| `PV3D` | `PV3DVIEW` | 3D & Shading | Generates 3D tilted tables, MMS legs, 3D obstacles & SW Iso view |
| `PVCLEAR3D` | — | 3D & Shading | Clears all 3D module, structure, and obstacle entities |
| `PVPRUNESHADED` | `PVCHECKSHADING` | 3D & Shading | Highlights & auto-deletes over-shaded modules to maximize PR |
| `PVPVSYST` | `PVEXPORTPVSYST` | Export (ARKA 360) | Exports 3D array coordinate CSV for direct import into PVsyst 7/8 |
| `PVWALKWAY` | `PVWALKWAYPATH` | Layout & Safety | Draws maintenance walkway corridor with custom width (e.g. 0.80m) |
| `PVCLEARWALKWAY`| `PVCLEARWALKWAYS` | Layout & Safety | Clears defined walkway corridors |
| `PVFALLSAFETY` | `PVSAFETYLINE` | Safety Systems | Draws fall safety lifeline with spring tensioners & 90° turn points |
| `PVHANDRAIL` | — | Safety Systems | Draws perimeter safety handrails with stanchion posts |
| `PVENERGYTABLE` | — | Deliverables | Inserts AutoCAD native 25-Year Energy Generation Table |
| `PVDRAWBOM` | `PVBOM` | Deliverables | Inserts AutoCAD native Bill of Materials (BOM) Table |
| `PVSIMREPORT` | `PVREPORT` | Deliverables | Opens comprehensive IEC 61724 simulation report in Notepad |
| `PVEXPORTCSV` | — | Deliverables | Exports monthly and 25-year degradation schedule to CSV |
| `PVPICKBOUNDARY` | — | Layout Setup | Selects closed boundary polyline for rooftop outline |
| `PVCOMPLIB` | `PVLIBRARY` | Equipment Library | **Persistent Component Library**: View/manage saved PAN & OND models |
| `PVLOADPAN` | `PVPAN` | Equipment Library | Import PV module `.PAN` file (auto-saves into `PVCompLib.lsp`) |
| `PVLOADOND` | `PVOND` | Equipment Library | Import string inverter `.OND` file (auto-saves into `PVCompLib.lsp`) |
| `PVPICKOBSTACLES`| `PVOBSTACLES` | Layout Setup | Selects obstacles & arrays, casting winter solstice solar shadows |
| `PVCLEAROBSTACLES`| — | Layout Setup | Clears active obstacles and shadow envelopes |
| `PVCLEARLAYOUT` | — | Layout Setup | Deletes placed PV modules and tables |

---

## 📐 AutoCAD Layers Created

| Layer Name | Color | Lineweight | Description |
|---|---|---|---|
| `PV_BOUNDARY` | Cyan (4) | 0.30 mm | Rooftop perimeter boundary polyline |
| `PV_SETBACK` | Gray (8) | 0.15 mm | Parapet and boundary safety clearance setback |
| `PV_OBSTACLE` | Red (1) | 0.25 mm | Obstacle boundary outlines |
| `PV_SHADOW` | Light Gray (9) | 0.15 mm | Winter solstice dynamic shadow envelopes |
| `PV_MODULES` | Blue (5) | 0.25 mm | Solar PV module 2D polylines (South / standard) |
| `PV_MODULES_EAST`| Orange (30) | 0.25 mm | East-facing solar PV modules in East-West layouts |
| `PV_MODULES_WEST`| Green (3) | 0.25 mm | West-facing solar PV modules in East-West layouts |
| `PV_PANEL_NUMS` | Yellow (2) | 0.15 mm | Module sequence index tags (`STR-01-01`...) |
| `PV_STRUCTURE` | Green (3) | 0.20 mm | Mounting structure table frames |
| `PV_WALKWAY` | Amber (30) | 0.20 mm | Maintenance walkway corridors |
| `PV_STRINGS` | Red (1) | 0.35 mm | Color-coded DC string circuit polylines |
| `PV_STRING_TAGS`| Yellow (2) | 0.20 mm | String circuit identification labels & [+] / [-] terminals |
| `PV_DC_CABLE` | Red (1) | 0.35 mm | Tracked DC homerun cable lines |
| `PV_DC_ROUTE_GUIDE`| Magenta (6)| 0.20 mm | DC cable route corridor guidelines |
| `PV_AC_CABLE` | Cyan (4) | 0.50 mm | AC distribution feeders (Inverter -> ACDB -> MSB) |
| `PV_INVERTER` | Cyan (4) | 0.50 mm | Inverter foundation plinth, enclosure, DC/AC switches & ratings |
| `PV_CABLE_TRAY` | Orange (30) | 0.35 mm | Perforated GI cable tray corridor rails and rungs |
| `PV_SLD` | White (7) | Continuous | Single Line Diagram (SLD) electrical schematic |
| `PV_3D_MODULES` | Slate Blue (140) | 0.20 mm | 3D tilted module planes (`3DFACE`) |
| `PV_3D_STRUCTURE`| Dark Gray (8) | 0.18 mm | 3D MMS support legs and purlins |
| `PV_3D_OBSTACLES`| Red (1) | 0.20 mm | 3D extruded obstacle solid boxes |
| `PV_FALL_SAFETY` | Magenta (6) | 0.35 mm | Fall safety wire rope, spring tensioners & turn anchors |
| `PV_HANDRAIL` | Orange (40) | 0.30 mm | Dual-rail safety handrails & stanchion posts |
| `PV_ANNOTATION` | White (7) | 0.18 mm | Dimensions, hardware labels and notes |
| `PV_BOM` | Yellow (2) | — | AutoCAD native Bill of Materials (BOM) Table |
| `PV_ENERGY_TABLE`| White (7) | — | AutoCAD native Monthly, Yearly & 25-Yr Yield Table |
| `PV_REPORT` | White (7) | — | Simulation summary text report |

---

## 🛠️ Complete Engineering Workflow

1. **Load Application**:
   - In AutoCAD, type `APPLOAD` and load `RooftopSolar.lsp`.
2. **Open Master Functions or Designer UI**:
   - Type `PVMENU` to open the Master Functions Hub, or `ROOFTOPSOLAR` for the full designer.
3. **Pick Boundary & Obstacles**:
   - Pick the outer closed rooftop polyline (`PVPICKBOUNDARY`).
   - If designing on hip roofs or curved barrel roofs, run `PVHIPSPLIT` or `PVDOMESPLIT`.
   - Pick obstacles (`PVPICKOBSTACLES`). Winter solstice shadow envelopes are automatically cast.
4. **Define Walkway Corridors & Safety**:
   - Type `PVWALKWAY` to specify walkway corridor width (e.g. $0.80\text{m}$) and route walkway corridors.
   - Run `PVFALLSAFETY` or `PVHANDRAIL` for perimeter safety compliance.
5. **Generate Layout**:
   - Type `PVLAYOUT` for standard South-facing arrays or `PVLAYOUTEW` for East-West dual-tilt arrays.
   - Dimension the layout plan with `PVDIMPLAN`.
6. **DC Stringing & Inverter Configuration**:
   - Type `PVSTRING` for automated snake stringing (or `PVSTRINGEW` for East-West, `PVSTRINGMANUAL` for click-to-wire).
   - Use `PVPOLARITY` to flip string terminals if necessary.
   - Check string grouping with `PVSTRINGVIS` and serialize modules with `PVPANELNUM`.
   - Review Inverter MPPT windows with `PVMPPTDETAILS` and link homeruns with `PVMPPTLINK`.
7. **DC Cable Routing & Calculations**:
   - Type `PVINVERTER` to place the inverter foundation plinth.
   - Route cable tray corridors with `PVCABLETRAY`.
   - Run `PVDCROUTETRACKED` to route home runs snapped along trays, and `PVDCROUTECOLORPOLARITY` for +/- conduits.
   - Run `PVCABLECALC` to size cables under IEC 60364-7-712 / BS 7671 and check voltage drop ($< 1.5\%$).
   - Insert `PVDCSCHEDULE` for the DC cable bill of quantities.
8. **Single Line Diagram & 3D Audit**:
   - Type `PVSLD` to generate the complete electrical Single Line Diagram.
   - Type `PV3D` to visualize tilted modules, MMS legs, and 3D obstacles in SW Isometric view.
   - Type `PVPRUNESHADED` to identify and prune over-shaded modules.
9. **Pre-Flight Validation & Export**:
   - Run `PVVALIDATE` to ensure zero clearances violations, correct MPPT voltage limits, and low shading losses.
   - Type `PVPVSYSTEXPORT` to generate a native `.PVC` 3D scene file for PVsyst 7/8.
   - Type `PVENERGYTABLE` and `PVBOM` to insert generation and bill-of-materials tables directly into the drawing.
