# RooftopSolar Suite - User Manual & Engineering Guide
### Professional Rooftop Solar PV Design & Automation for AutoCAD
**Version 2.5 (PVDesigner 2027 Edition)**

---

## 📦 1. Distribution Package (Files to Share)

When sharing this AutoLISP application with colleagues, clients, or team members, **keep all files in the same folder**. The system automatically resolves relative paths, so users can extract it anywhere on their PC without modifying system paths.

### 🔴 Mandatory Files (Must Always Be Shared Together)
| Filename | Purpose |
|---|---|
| **`RooftopSolar.lsp`** | **The Main AutoLISP Engine**: Contains all drafting algorithms, layout engines, stringing logic, solar math, yield modeling, and command definitions. |
| **`RooftopSolar.dcl`** | **The Dialog Interface**: Defines all graphical user interfaces (Master Control Center, 6-tab SolarTools designer, and settings dialogs). |
| **`PVCompLib.lsp`** | **Persistent Component Library**: Contains saved solar PV modules and string inverters. All newly imported `.PAN` and `.OND` files are automatically saved here. |

> [!IMPORTANT]
> The three files above (`RooftopSolar.lsp`, `RooftopSolar.dcl`, and `PVCompLib.lsp`) must reside in the **same directory**. If separated, AutoCAD will not be able to load the dialog boxes or persistent component libraries.

### 🟢 Recommended Accompanying Files
| Filename | Purpose |
|---|---|
| **`USER_GUIDE.md`** | This user manual and command quick reference. |
| **`README.md`** | Technical architecture and layer definitions. |
| **`*.pan` files** | Sample PVsyst module files (e.g. `Jinko_TigerNeo_JKM550N_72HL4_V.pan`, `LONGi_LR5_72HBD_550M.pan`, `Trina_Vertex_DE19R_550W.pan`). |
| **`*.ond` files** | Sample PVsyst inverter files (e.g. `Sungrow_SG50CX.ond`, `Solis_S5_GC50K.ond`). |
| **`RooftopBoundary.dwg`**| Sample drawing with realistic flat RCC rooftop, obstacles, and skylights for practice. |

---

## 🚀 2. Installation & Quick Setup

### Method A: One-Time Loading
1. Open AutoCAD (2018 through 2027 compatible).
2. Type `APPLOAD` in the command bar and press `Enter`.
3. Browse to the folder where you saved the files, select **`RooftopSolar.lsp`**, and click **Load**.
4. The command window will confirm:
   ```text
   Solar PV Plant Layout Generator - Rooftop Projects Loaded!
   Type 'PVMENU' or 'PVDCL' to open the Master Functions Dialog.
   Type 'ROOFTOPSOLAR' or 'SOLARPV' for the Full Designer.
   ```

### Method B: Permanent Auto-Load (Recommended)
1. Type `APPLOAD` in AutoCAD.
2. In the bottom-right corner under **Startup Suite**, click the **Contents...** button (briefcase icon).
3. Click **Add...**, select `RooftopSolar.lsp`, and click **Open**.
4. Click **Close**. Now `RooftopSolar` will automatically load every time AutoCAD starts or opens any drawing.

### ⚠️ Drawing Units Requirement
- The suite is designed for **Metric units** where **1 Drawing Unit = 1 Meter**.
- Type `UNITS` in AutoCAD, ensure Insertion Scale is set to **Meters**, and Length Type is set to **Decimal**.

---

## 🧭 3. Launching the Software

The suite provides two main user interfaces depending on your workflow:

### 1. Master Functions Control Center (`PVMENU` or `PVDCL`)
A single, clean control panel listing all 56 engineering commands grouped into categories. Click any button to execute that specific action directly.

### 2. Multi-Tabbed Master Designer (`SOLARTOOLS` or `ROOFTOPSOLAR`)
A 6-tab wizard interface for step-by-step project design:
- **Tab 1: Site & Rooftop**: Latitude/Longitude, weather source, design tilt & azimuth, setback clearance, roof type.
- **Tab 2: Equipment**: Module & inverter selection, `.PAN` / `.OND` parser, live electrical parameters.
- **Tab 3: Array Layout**: Table configuration (cols × rows), winter-solstice pitch calculator, boundary selection, and layout generation.
- **Tab 4: Walkways & Safety**: Maintenance walkway corridors, EN 795 fall safety lifelines, perimeter handrails.
- **Tab 5: Electrical & 3D**: Snake DC stringing, inverter stations, cable tray routing, IEC 62446-1 SLD, 3D modeling, and shade pruning.
- **Tab 6: Financial ROI & BOM**: Tariff and EPC rates, 25-Year yield table, Bill of Materials (BOM), simulation report.

---

## 📖 4. Step-by-Step Engineering Workflow

### Step 1: Define Roof Boundaries & 3D Building Outlines (`PVPICKBOUNDARY` / `PVBLDG3D`)
1. Draw your building perimeter as a **closed polyline** (`PLINE`).
2. Run `PVPICKBOUNDARY`:
   - Click a single polyline, OR window-select multiple polylines.
   - For multi-building sites, run `PVMULTIROOF` to view and select active roofs (`PVSELECTROOF`).
   - Run `PVROOFNUM` to auto-stamp sequential identification badges (`RF-01`, `RF-02`...) and usable area ($m^2$) at the roof centroid.
3. **Interactive Rooftop Type & Building Height Modeler**:
   - The suite immediately prompts you for the **Rooftop Type**: `[Flat-RCC / Metal-Sheet]`.
   - **For Flat RCC**:
     - **Building Height ($m$)**: Elevation of the concrete roof slab above ground level ($Z = H_{\text{bldg}}$). This defines the structural base surface on which module mounting structures (MMS legs), maintenance walkways, safety lines, and equipment are placed.
     - **Parapet Wall Height ($m$)**: Vertical height of the perimeter parapet wall rising above the roof slab surface ($Z = H_{\text{bldg}}$ to $Z = H_{\text{bldg}} + H_{\text{parapet}}$).
     - **Parapet Wall Thickness ($m$)**: Structural thickness of the parapet wall. **This value is used directly as the offset distance from the boundary drawn inside the boundary** (layer `PV_PARAPET`). Run `PVOFFSET` or `PVSHOWALLOFFSET` / `PVHIDEALLOFFSET` to toggle this inner parapet offset boundary.
     - **3D Modeling & Solar Shading**: The suite models the parapet wall directly on the roof slab surface with outer vertical faces, inner vertical faces, and top coping caps on layer `PV_3D_PARAPET`. It is also automatically registered as an obstacle, generating winter solstice 9am–3pm dynamic solar shadow maps on `PV_SHADOW` that are excluded during array layout generation.
     - **Usable Roof Surface Boundary**: During layout generation (`PVLAYOUT`), the module placement engine enforces this inner boundary offset (parapet wall thickness + additional setback) to ensure all modules are placed cleanly on the usable roof slab without encroaching on the parapet wall.
   - **For Sloped Metal Sheet**:
     - Choose slope configuration: `[1 / 2 / 4 directions]`.
     - **1 Direction (Monoslope / Shed)**: Specify slope facing direction (`North`, `South`, `East`, `West`), then enter building height at the high end / centre (e.g. `8.0m`) and low end / eaves (e.g. `6.0m`).
     - **2 Directions (Dual-Pitch / Gable)**: Define slope facing direction (`North-South` or `East-West`), then enter building height at the centre / ridge (e.g. `8.0m`) and ends / eaves (e.g. `6.0m`).
     - **4 Directions (Hip Roof)**: Enter building height at the centre / apex and perimeter / eaves.
   - **Automatic 3D Building Outlines**: The suite computes the true mathematical roof slope in degrees and pitch %, and automatically creates 3D vertical wall outlines (`PV_3D_BUILDING`), 3D eaves and ridge lines (`PV_3D_ROOF_OUTLINE`), and 3D roof surfaces (`PV_3D_ROOF_FACE`). You can reconfigure or regenerate this at any time using `PVBLDG3D`.

### Step 2: Complex Roof Splitting (If Applicable)
- **Hip & Valley Roofs**: Run `PVHIPSPLIT` to divide faceted hip roofs into distinct planar faces.
- **Curved Barrel Vaults / Domes**: Run `PVDOMESPLIT` to discretize curved roofs into facet strips, or `PVONEDOME` to normalize slopes.

### Step 3: Pick Obstacles & Solar Shadows (`PVPICKOBSTACLES`)
1. Draw rooftop obstructions (HVAC units, skylights, water tanks, lift rooms) as closed polylines.
2. Run `PVPICKOBSTACLES` and select the polylines.
3. Enter obstacle height (e.g. `1.5` meters).
4. The suite automatically extrudes winter solstice solar shadow envelopes on layer `PV_SHADOW` based on your site latitude and design azimuth. Modules will automatically avoid shaded zones.
5. **Toggle Obstacle Shadow Maps ON / OFF**:
   - **Command Line**: Run `PVSHADOWTOGGLE` (or `PVTOGGLESHADOW` / `PVSHADOWMAP`) to instantly invert shadow map calculation and visibility. Use `PVSHADOWON` or `PVSHADOWOFF` for explicit states.
   - **Dialogs**: Use the **"Toggle Shadow Map (ON/OFF)"** button or **"Shadows ON/OFF"** checkbox in Tab 3 (`tab_array_layout`), the Master Control Center (`solar_pv_control_center`), or the Full Designer dialog.
   - When toggled **OFF**, layer `PV_SHADOW` is frozen, shadow envelopes are hidden, and modules will ignore shadow exclusion during layout generation.
   - When toggled **ON**, layer `PV_SHADOW` is thawed/displayed, shadow envelopes are dynamically verified, and modules will strictly avoid shaded zones.

### Step 4: Equipment Selection & PVCompLib (`PVCOMPLIB`)
1. Run `PVLOADPAN` to browse and import any PVsyst `.PAN` file.
   - All electrical ratings ($V_{mp}, I_{mp}, V_{oc}, I_{sc}$, temperature coefficients, bifaciality, dimensions) are parsed.
   - The module is **automatically saved to `PVCompLib.lsp`** for all future projects.
2. Run `PVLOADOND` to import any PVsyst `.OND` string inverter file.
   - MPPT tracking windows, maximum DC input current, and Euro efficiencies are parsed and saved to `PVCompLib.lsp`.
3. Type `PVCOMPLIB` to view, manage, or reload the persistent equipment database.

### Step 5: Generate Solar PV Layout (`PVLAYOUT` / `PVLAYOUTEW`)
1. Choose layout mode in Tab 1:
   - **Max Capacity**: Fills the entire boundary with optimal table spacing.
   - **Target Capacity**: Stops placing modules once your target kWp (e.g. `50.0 kWp`) is reached.
2. **Sloped Metal Rooftop Zone Splitting & 3D Rooftop Placement**:
   - For **2-Side Sloped Metal Roofs (Dual-Pitch / Gable)**:
     - The layout engine automatically calculates the ridge line ($Y_c$ for North-South, $X_c$ for East-West) and isolates each roof face.
     - You are prompted to choose which slope to populate:
       `Select Slope(s) to populate [Both-Slopes / South-Slope-Only / North-Slope-Only] <Both-Slopes>:` (or West/East).
     - Central ridge setbacks (e.g. $0.30\text{m}$) and perimeter eaves setbacks ($0.50\text{m}$) are strictly maintained to prevent modules from straddling the ridge cap.
   - **True 3D Rooftop Elevation**:
     - All modules are placed directly at their **actual rooftop elevation ($Z_{\text{roof}}$)** atop the sloped roof plane (at $6.0\text{m} \dots 8.0\text{m}$ rather than at $Z=0$ on the floor).
     - Modules are constructed as closed 3D Polylines on `PV_MODULES` and rendered as solid 3DFACE solar panels on `PV_3D_MODULES`.
     - For Flat RCC roofs with MMS structures, front and rear legs connect the module support frame down to the roof slab.
3. For East-West A-Frame configurations, run `PVLAYOUTEW` to generate dual-tilt East (90°) and West (270°) subarrays elevated directly atop the rooftop surface.

### Step 5B: Elevated Tilted Legs & Continuous Solar Canopy Setup (Flat RCC Rooftop)
When **Elevated Tilted Legs** is selected for Flat RCC Rooftops, the array is constructed as a **continuous elevated canopy superstructure**:
1. **Continuous Incident Solar Plane**:
   - The tilt angle $\theta$ is continuously maintained across the entire rooftop from the first row on the North side to the South side (or East to West).
   - All modules across all rows share the **identical 3D mathematical incident plane**:
     $$Z_{\text{plane}}(x, y) = Z_{\text{roof}} + H_{\text{clear}} + (y - Y_{\text{south}}) \cdot \tan(\theta)$$
   - This eliminates sawtooth height resets between rows, ensuring **zero inter-row shading** and maximum solar irradiance capture.
2. **Row Vertical Legs Placement Rules**:
   - **First Vertical Leg**: Begins precisely at the outer edge of the first panel in each row ($X = X_{\text{start}}$, both front and rear).
   - **Last Vertical Leg**: Ends precisely at the outer edge of the last panel in each row ($X = X_{\text{end}}$, both front and rear).
   - **Intermediate Vertical Legs**: The user can configure intermediate leg positions using any of 3 rules:
     - **By Count**: User specifies exact number of intermediate vertical legs between first and last leg (e.g. 2 legs divides row into 3 bays).
     - **By Distance in Metres**: User defines spacing in metres (e.g. $3.00\text{m}$ max span between columns).
     - **By Number of Modules**: User defines leg spacing in module counts (e.g. vertical leg placed at joint every 2 modules).
3. **Structural CAD Elements Generated**:
   - **3D Vertical Columns**: Drawn on `PV_3D_STRUCTURE` (Color 8) connecting concrete roof slab ($Z_{\text{roof}}$) up to the elevated plane ($Z_{\text{plane}}$).
   - **Column Footings / Base Plates**: Drawn directly on the active terrace slab surface at $Z = Z_{\text{roof}}$ as $0.20\text{m} \times 0.20\text{m}$ 3D polyline markings (`PV_STRUCTURE`, Color 4 Cyan) and solid mounting plates (`PV_3D_STRUCTURE`).
   - **Transverse Rafter Beams**: Sloped structural rafters along the tilt angle connecting front and rear leg tops.
   - **Longitudinal Purlins**: Continuous rails running along front and rear row edges.
4. **Dedicated Configuration Commands**:
   - Run `PVELEVCONFIG` (or `PVELEVATED` / `PVLEGS`) to open the Elevated Tilted Legs setup dialog.
   - Run `PVELEVTOGGLE` to quickly toggle between standard MMS and Elevated Tilted Canopy mode.

### Step 6: Walkways & Safety Systems (Elevated onto Rooftop Surface)
- **Corridor Walkways**:
  - Run `PVWALKWAY` to draw maintenance walkway paths (e.g. $0.80\text{m}$ width) on `PV_WALKWAY`.
  - Walkways are automatically elevated onto the active rooftop surface at $Z_{\text{roof}} + 0.02\text{m}$ as 3D anti-skid FRP grating corridor polylines (`PV_3D_WALKWAY`).
- **Fall Safety Lifelines**:
  - Run `PVFALLSAFETY` to draw EN 795 / OSHA compliant wire-rope lifelines with spring tensioners and corner anchors on `PV_FALL_SAFETY`.
  - Standoff posts and SS wire ropes are anchored at rooftop surface elevation ($Z_{\text{roof}} + 0.15\text{m}$) on `PV_3D_SAFETY`.
- **3D Perimeter Safety Handrails & Guardrails**:
  - Run `PVHANDRAIL` to place OSHA & EN ISO 14122-3 compliant safety guardrails along roof edges or walkway perimeters.
  - **User-Definable Specifications** (Configurable in Tab 4 or via interactive command prompt):
    - **Handrail Height**: Default $1.10\text{m}$ (1100mm standard), user-definable.
    - **Number of Horizontal Lines**: Choose between `2 Rails` (Top + Mid), `3 Rails` (Top + 2 Mid), or `4 Rails` (Top + 3 Mid).
    - **Vertical Post Shape**: Select `Round Pipe` (50mm diameter cylindrical column with top cap) or `Square Pipe` (50x50mm box section column).
    - **Hand Rail Shape**: Select `Round Pipe` (40mm diameter pipe tube) or `Square Pipe` (40x40mm box section tube).
    - **Post Spacing**: Default $1.50\text{m}$ spacing between vertical stanchions.
    - **Kickplate / Toeboard**: Optional solid $150\text{mm}$ toeboard sitting directly at the base between posts.
    - **Surface Elevation ($Z_{\text{roof}}$)**: Baseplate flanges ($140\text{mm} \times 140\text{mm}$) anchor directly onto the roof surface, with stanchions and rails following the pitch of the roof.
    - Rendered in 3D on `PV_3D_HANDRAIL` (Color 40) and schematic plan on `PV_HANDRAIL`.
  - Run `PVCLEARHANDRAIL` to clear all placed handrails from the project.


### Step 7: Automated DC Stringing (`PVSTRING` / `PVSTRINGMANUAL` / `PVSTRINGEW`)
1. Run `PVSTRING`:
   - Enter modules per string (e.g. `20`).
   - The boustrophedon snake algorithm groups modules row-by-row to minimize DC loop area.
   - Polylines are drawn on `PV_STRINGS` in rotating vivid colors.
   - Circuit terminal poles are stamped: `[+]` Red Circle and `[-]` Blue Circle.
   - String circuit labels are created on `PV_STRING_TAGS` (e.g. `STR-01 (20M | 11.0 kWp | 828V)`).
2. For custom or irregular layouts, run `PVSTRINGMANUAL` to click modules in sequence.
3. For East-West layouts, run `PVSTRINGEW` to guarantee that East and West modules are kept in strictly isolated series strings.
4. Run `PVPOLARITY` on any string to invert start/end `[+]` and `[-]` poles to optimize home-run cable lengths.
5. Run `PVPANELNUM` to serialize individual panels (`STR-01-01`, `STR-01-02`...).

### Step 8: Inverter Plinth & Cable Tray Corridor
1. Run `PVINVERTER` to click an installation point. Draws a concrete foundation plinth pad, inverter enclosure, DC disconnect switch, AC isolator, and ratings plate on `PV_INVERTER`.
2. Run `PVMPPTDETAILS` to inspect inverter MPPT voltage windows and string capacity limits.
3. Run `PVMPPTLINK` to click a string terminal pole and route an electrical tie line to an inverter MPPT channel.
4. Run `PVCABLETRAY` to route a perforated GI cable tray corridor with automatic cross-rungs.
5. Run `PVDCROUTETRACKED` to route home-run cables along the tray corridor.
6. Run `PVCABLECALC` to size DC/AC conductor cross-sections ($4, 6, 10\text{ mm}^2$) and verify voltage drop ($\%V_{\text{drop}} < 1.5\%$).

### Step 9: 3D Visualization & Shade Pruning
1. Run `PV3D`:
   - Automatically builds 3D Building exterior walls and sloped roof surfaces at center ridge height ($H_{\text{ridge}}$) and eaves height ($H_{\text{eaves}}$).
   - Positions all PV modules directly atop the rooftop surface plane ($Z_{\text{roof}}$) with true tilt and racking clearance on `PV_3D_MODULES`.
   - Extrudes obstacles into 3D solid bounding boxes sitting on the rooftop surface on `PV_3D_OBSTACLES`.
   - Projects winter solstice dynamic shadow envelopes onto the rooftop plane at $Z_{\text{roof}} + 0.01\text{m}$ on `PV_SHADOW`.
   - Generates complete 3D Safety Handrails with 3D stanchion posts (Round/Square pipe), continuous multi-level rails, baseplates, and kickplates on `PV_3D_HANDRAIL`.
   - Renders 3D Fall Safety wire rope lifelines with $150\text{mm}$ standoff posts anchored to the rooftop on `PV_3D_SAFETY`.
   - Elevates maintenance walkway corridors on `PV_3D_WALKWAY`.
   - Automatically switches the viewport to South-West Isometric with Conceptual Shading and Zoom Extents.
2. Run `PVPRUNESHADED`:
   - Audits all placed modules against winter solstice shadow profiles.
   - Flags shaded modules in bright red and prompts you to delete them to safeguard array Performance Ratio (PR).
3. Run `PVCLEAR3D` to remove all 3D entities and return to clean 2D plan view.

### Step 10: Deliverables & Export
- **Single Line Diagram (SLD)**: Run `PVSLD` to generate a publication-ready IEC 62446-1 schematic diagram.
- **25-Year Energy Table**: Run `PVENERGYTABLE` to insert an AutoCAD native yield generation table.
- **Bill of Materials (BOM)**: Run `PVDRAWBOM` to generate a quantified hardware procurement table.
- **DC Cable Schedule**: Run `PVDCSCHEDULE` to create a cable schedule documenting string IDs, cable runs, and $\%V_{\text{drop}}$.
- **Simulation Report**: Run `PVSIMREPORT` to view a comprehensive technical and financial audit in Notepad.
- **PVsyst 3D Scene Export**: Run `PVPVSYSTEXPORT` to generate a native `.PVC` / `.CSV` scene file for direct import into PVsyst 7/8.
- **Pre-Flight Validation**: Run `PVVALIDATE` for a final design audit before releasing drawings for construction.

---

## ⚡ 5. Master Command Cheatsheet

| Command | Alias | Category | Description |
|---|---|---|---|
| `PVMENU` | `PVDCL`, `PVCOMMANDS` | Navigation | Master Functions Control Center dialog |
| `SOLARTOOLS` | `ROOFTOPSOLAR`, `SOLARPV` | Navigation | Full 6-Tab Designer Wizard |
| `PVPICKBOUNDARY` | — | Layout | Select single or multiple closed roof boundaries |
| `PVMULTIROOF` | `PVROOFS` | Layout | Multi-roof manager for multi-building projects |
| `PVROOFLIST` | — | Layout | Displays roof inventory with handles and areas ($m^2$) |
| `PVSELECTROOF` | — | Layout | Set active target roof or select all roofs |
| `PVROOFNUM` | — | Layout | Stamp roof identifiers (`RF-01`) and area badges |
| `PVBLDG3D` | `PVBUILDING3D` | 3D Building | Interactive roof slope (1/2/4 dir) & 3D building outlines modeler |
| `PVHIPSPLIT` | — | 3D Roof | Split hip and valley roofs along ridge lines |
| `PVDOMESPLIT` | — | 3D Roof | Discretize curved barrel roofs into flat facets |
| `PVONEDOME` | — | 3D Roof | Normalize curved roof facets into single plane |
| `PVPICKOBSTACLES`| `PVOBSTACLES` | Obstacles | Select obstacles and generate winter shadow envelopes |
| `PVCLEAROBSTACLES`| — | Obstacles | Clear active obstacles and shadow envelopes |
| `PVCOMPLIB` | `PVLIBRARY` | Equipment | Open Persistent Component Library manager |
| `PVLOADPAN` | `PVPAN` | Equipment | Import PV module `.PAN` file (auto-saved to library) |
| `PVLOADOND` | `PVOND` | Equipment | Import string inverter `.OND` file (auto-saved to library)|
| `PVLAYOUT` | — | Layout | Populate modules inside boundary (Max Fill or Target kWp)|
| `PVLAYOUTEW` | — | Layout | Populate dual-tilt East-West (A-frame) arrays |
| `PVELEVCONFIG` | `PVELEVATED`, `PVLEGS` | Structure | Configure Elevated Tilted Legs & continuous canopy slope |
| `PVELEVTOGGLE` | — | Structure | Toggle between standard MMS and Elevated Canopy mode |
| `PVEWVIS` | — | Layout | Toggle visibility of East vs West subarrays |
| `PVCLEARLAYOUT` | — | Layout | Delete placed PV modules and structure tables |
| `PVWALKWAY` | `PVWALKWAYPATH` | Walkways | Draw maintenance walkway corridor (e.g. 0.80m) |
| `PVCLEARWALKWAY`| — | Walkways | Clear defined walkway corridors |
| `PVFALLSAFETY` | `PVSAFETYLINE` | Safety | Draw EN 795 wire rope lifeline with spring tensioners |
| `PVHANDRAIL` | — | Safety | Draw 3D safety handrails (Round/Square pipe, 2-4 rails, kickplate) |
| `PVCLEARHANDRAIL`| `PVCLEARHANDRAILS` | Safety | Clear all placed 3D safety handrails |
| `PVSTRING` | `PVSTRINGING` | Electrical | Automatic snake DC stringing with terminal markers |
| `PVSTRINGMANUAL`| — | Electrical | Manual click-to-wire custom string routing |
| `PVSTRINGEW` | — | Electrical | Series-isolated stringing for East-West layouts |
| `PVPOLARITY` | — | Electrical | Invert `[+]` and `[-]` string terminal poles |
| `PVSTRINGVIS` | — | Electrical | Colored convex-hull string cluster visualizer |
| `PVPANELNUM` | — | Electrical | Number modules sequentially (`STR-01-01`...) |
| `PVCLEARSTRINGS`| — | Electrical | Remove all string polylines and circuit tags |
| `PVINVERTER` | `PVPLACEINVERTER` | Electrical | Place inverter plinth, enclosure, disconnects & tag |
| `PVMPPTDETAILS` | — | Electrical | View inverter MPPT voltage windows & capacity limits |
| `PVMPPTLINK` | — | Electrical | Connect string terminal to inverter MPPT input |
| `PVCABLETRAY` | `PVDRAWCABLETRAY` | Electrical | Route perforated GI cable tray with rungs |
| `PVDCROUTETRACKED`| — | Electrical | Route DC home-run cable snapped along tray corridor |
| `PVDCROUTECOLORPOLARITY`| — | Electrical | Distinguish positive Red (+) and negative Black (-) runs |
| `PVCABLECALC` | — | Electrical | DC/AC cable sizing and $\%V_{\text{drop}}$ calculator |
| `PVACEQUIPMENT` | — | Electrical | Place ACDB, Main Switchboard & Transformer symbols |
| `PVSLD` | `PVDRAWSLD` | Electrical | Auto-generate publication-ready IEC 62446-1 SLD |
| `PV3D` | `PV3DVIEW` | 3D / Shading | Generate 3D tilted tables, MMS legs & SW Iso view |
| `PVPRUNESHADED` | `PVCHECKSHADING` | 3D / Shading | Highlight & auto-delete over-shaded modules |
| `PVCLEAR3D` | — | 3D / Shading | Clear 3D models and return to 2D plan view |
| `PVENERGYTABLE` | — | Deliverables | Insert AutoCAD native 25-Year Yield Table |
| `PVDRAWBOM` | `PVBOM` | Deliverables | Insert AutoCAD native Bill of Materials Table |
| `PVDCSCHEDULE` | — | Deliverables | Insert AutoCAD native DC Cable Schedule Table |
| `PVSIMREPORT` | `PVREPORT` | Deliverables | Open comprehensive IEC 61724 simulation report |
| `PVEXPORTCSV` | — | Deliverables | Export monthly and 25-year energy schedules to CSV |
| `PVPVSYSTEXPORT`| `PVPVSYST` | Export | Export native PVsyst 7/8 3D scene (`.PVC` / `.CSV`) |
| `PVVALIDATE` | — | QA / Audit | Comprehensive pre-flight engineering validation |
| `PVDIMPLAN` | — | Drafting | Auto-dimension pitch, row gaps, setbacks and spacing |

---

## 🛠️ 6. Troubleshooting & Frequently Asked Questions (FAQ)

### Q1: "Dialog Error: Could not find RooftopSolar.dcl"
- **Cause**: The `.dcl` file is missing or in a different folder.
- **Solution**: Ensure `RooftopSolar.dcl` is in the **exact same folder** as `RooftopSolar.lsp`. Alternatively, add that folder to AutoCAD's **Support File Search Path** (`OPTIONS` > `Files` tab > `Support File Search Path` > `Add...` > `Browse...`).

### Q2: "My imported PAN and OND files didn't save when I restarted AutoCAD."
- **Cause**: Windows permission restriction preventing write access to the folder.
- **Solution**: Avoid keeping the files inside `C:\Program Files\` where Windows restricts write permissions. Keep them in an accessible directory (such as `D:\SolarProjects\LISP\` or `C:\Users\<Name>\Documents\AutoCAD\LISP\`) so `PVCompLib.lsp` can update cleanly.

### Q3: "Modules are placed outside my roof or at unexpected angles."
- **Cause**: Boundary is not a closed 2D polyline or drawing units are in millimeters.
- **Solution**: 
  1. Verify the roof outline is a **Closed Polyline** (in Properties palette, `Closed = Yes`).
  2. Verify drawing units with `UNITS`. Ensure units are set to **Meters** (e.g., a $30\text{m} \times 20\text{m}$ roof should measure 30 units by 20 units, not 30,000 by 20,000).

### Q4: "How do I share the tool with a client or team member?"
- Simply select the folder containing:
  1. `RooftopSolar.lsp`
  2. `RooftopSolar.dcl`
  3. `PVCompLib.lsp`
  4. (Optional) Sample `.PAN` and `.OND` files
- Zip the folder and send it. The recipient only needs to extract the zip and run `APPLOAD` on `RooftopSolar.lsp`.

---
*Developed with PVDesigner 2027 Engineering Suite.*
