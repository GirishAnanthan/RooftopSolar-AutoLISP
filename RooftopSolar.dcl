// ==========================================================================
// RooftopSolar.dcl - Dialog Control Language interface for AutoCAD
// Solar PV Plant Layout Generation for Rooftop Solar Projects
// Contains:
//   1. solar_pv_control_center  : Master Functions Hub for Calling All Commands
//   2. Multi-Tabbed SolarTools Suite:
//      - tab_site_roof         : Tab 1 - Site Location & Rooftop Structure
//      - tab_equipment         : Tab 2 - PV Module & Inverter Equipment (.PAN / .OND)
//      - tab_array_layout      : Tab 3 - Array Layout & Obstacle Shading
//      - tab_walkway_safety    : Tab 4 - Maintenance Walkways & Safety Systems
//      - tab_electrical_3d     : Tab 5 - Electrical System, SLD & 3D
//      - tab_reports_finance   : Tab 6 - Financial ROI, BOM & Deliverables
//   3. rooftop_solar_dialog     : Comprehensive Configuration & Execution Dialog (All-In-One Fallback)
// ==========================================================================

dcl_settings : default_dcl_settings { audit_level = 0; }

// ==========================================================================
// 1. MASTER FUNCTIONS CONTROL CENTER (All Functions in One Dialog)
// ==========================================================================
solar_pv_control_center : dialog {
  label = "Solar PV Rooftop - Master Functions Control Center (India EPC Edition) v3.0";
  initial_focus = "f_open_designer";
  width = 96;

  : text {
    label = "SOLAR PV ROOFTOP DESIGNER - MASTER CONTROL CENTER & DISPATCHER";
    alignment = centered;
  }
  : text {
    label = "Indian Standards Edition (CEA Regulations 2023 | IS 3043 Earthing | IS 875 Wind | CEIG SLD)";
    alignment = centered;
  }
  : spacer { height = 1; }
  : boxed_column {
    label = "1. Boundary, Roof Management & Parapet Offsets";
    : row {
      : button { key = "f_pick_bnd"; label = "Pick Roof Boundary / Roofs"; width = 26; }
      : text { label = "PVBOUNDARY Boundary | Selects single or multiple closed roof outlines"; width = 56; }
    }
    : row {
      : button { key = "f_pick_obs"; label = "Pick Obstacles & Arrays"; width = 26; }
      : text { label = "PVBOUNDARY Obstacles | Unpacks arrays & generates solar shadows"; width = 56; }
    }
    : row {
      : button { key = "f_multiroof"; label = "Multi-Roof Manager"; width = 26; }
      : text { label = "PVROOF Multi | Configure multi-building / multi-zone roof sets"; width = 56; }
    }
    : row {
      : button { key = "f_roof_list"; label = "Multi-Roof Inventory"; width = 26; }
      : text { label = "PVROOF List | Displays all roofs with area (m2) and handle"; width = 56; }
    }
    : row {
      : button { key = "f_select_roof"; label = "Select Active Roof"; width = 26; }
      : text { label = "PVROOF Select | Choose specific active roof or select ALL roofs"; width = 56; }
    }
    : row {
      : button { key = "f_roof_num"; label = "Label Roof ID Numbers"; width = 26; }
      : text { label = "PVROOF Number | Adds RF-01, RF-02 identifiers to each roof boundary"; width = 56; }
    }
    : row {
      : button { key = "f_show_offsets"; label = "Draw Parapet Offsets"; width = 26; }
      : text { label = "PVPARAPET Draw | Draw parapet wall safety setback offset guides"; width = 56; }
    }
    : row {
      : button { key = "f_show_hide_offset"; label = "Show / Hide Parapet Offsets"; width = 26; }
      : text { label = "PVPARAPET Show/Hide | Toggle visibility of parapet offset guides"; width = 56; }
    }
    : row {
      : button { key = "f_hip_split"; label = "Hip / Valley Roof Split"; width = 26; }
      : text { label = "PVROOFSPLIT Hip | Bisects hip/valley roof polygons into sub-polygons"; width = 56; }
    }
    : row {
      : button { key = "f_dome_split"; label = "Curved Dome / Barrel Split"; width = 26; }
      : text { label = "PVROOFSPLIT Dome | Divides curved vault into slope facet strips"; width = 56; }
    }
    : row {
      : button { key = "f_one_dome"; label = "Convert to Single Pitch"; width = 26; }
      : text { label = "PVROOFSPLIT OneDome | Converts selected roof plane into uniform single pitch"; width = 56; }
    }
  }
  : boxed_column {
    label = "2. 3D Building & Solar Shadow Analysis";
    : row {
      : button { key = "f_roof_bldg_3d"; label = "Roof Type & 3D Building"; width = 26; }
      : text { label = "PV3D Build | Configure roof slope (1/2/4 dir) & create 3D building"; width = 56; }
    }
    : row {
      : button { key = "f_3d_view"; label = "3D Isometric View"; width = 26; }
      : text { label = "PV3D View | 3DFACE tilted tables, MMS legs, 3D obstacles & SW Iso view"; width = 56; }
    }
    : row {
      : button { key = "f_prune_shaded"; label = "Prune Over-Shaded Modules"; width = 26; }
      : text { label = "PVSHADOW Prune | Highlight & auto-delete shaded modules to boost PR"; width = 56; }
    }
    : row {
      : button { key = "f_toggle_shadow"; label = "Toggle Shadow Map (ON/OFF)"; width = 26; }
      : text { label = "PVSHADOW Toggle | Toggles obstacle solar shadow maps ON / OFF"; width = 56; }
    }
  }
  : boxed_column {
    label = "3. Equipment Data & File Parsers (.PAN / .OND)";
    : row {
      : button { key = "f_load_pan"; label = "Load PV Module (.PAN)..."; width = 26; }
      : text { label = "PVLOAD Pan | Browse & parse PVsyst .PAN module specifications"; width = 56; }
    }
    : row {
      : button { key = "f_load_ond"; label = "Load Inverter (.OND)..."; width = 26; }
      : text { label = "PVLOAD Ond | Browse & parse PVsyst .OND string inverter data"; width = 56; }
    }
    : row {
      : button { key = "f_complib"; label = "PVCompLib Component Library"; width = 26; }
      : text { label = "PVLOAD Library | View persistent modules (ALMM/DCR) & inverters"; width = 56; }
    }
  }
  : boxed_column {
    label = "4. Solar PV Layout Sizing & Generation";
    : row {
      : button { key = "f_gen_layout"; label = "Generate Array Layout"; width = 26; }
      : text { label = "PVLAYOUTGEN Auto | Populate boundary or size to Target Capacity (kWp)"; width = 56; }
    }
    : row {
      : button { key = "f_layout_ew"; label = "Generate East-West Layout"; width = 26; }
      : text { label = "PVLAYOUTGEN EW | Dual-tilt A-frame / butterfly East-West layout"; width = 56; }
    }
    : row {
      : button { key = "f_elev_legs"; label = "Elevated Tilted Legs Setup"; width = 26; }
      : text { label = "PVELEV Config | Continuous canopy slope & vertical leg spacing"; width = 56; }
    }
    : row {
      : button { key = "f_elev_toggle"; label = "Toggle Elevated / Standard MMS"; width = 26; }
      : text { label = "PVELEV Toggle | Switch mounting between Elevated Legs and Standard MMS"; width = 56; }
    }
    : row {
      : button { key = "f_ew_vis"; label = "Toggle East/West Visibility"; width = 26; }
      : text { label = "PVMPPT EW | Filter East or West subarrays independently"; width = 56; }
    }
    : row {
      : button { key = "f_dim_plan"; label = "Dimension Layout Plan"; width = 26; }
      : text { label = "PVREPORT Dim | Automated pitch, setback & row spacing dimensions"; width = 56; }
    }
    : row {
      : button { key = "f_validate"; label = "Pre-Flight Engineering Check"; width = 26; }
      : text { label = "PVREPORT Validate | Audit Sanctioned Load, MPPT voltage & IS 3043 earthing"; width = 56; }
    }
  }
  : boxed_column {
    label = "5. Maintenance Walkways & Fall Safety Systems";
    : row {
      : button { key = "f_walkway"; label = "Pick / Draw Walkway Path"; width = 26; }
      : text { label = "PVWALKWAY Draw | Define dedicated walkway corridors between tables"; width = 56; }
    }
    : row {
      : button { key = "f_walkway_auto"; label = "Toggle Auto Walkway"; width = 26; }
      : text { label = "PVWALKWAY Auto | Enable / disable automatic walkway generation"; width = 56; }
    }
    : row {
      : button { key = "f_fall_safety"; label = "Draw Fall Safety Lifeline"; width = 26; }
      : text { label = "PVSAFETY FallSafety | End anchors, spring tensioners & 90 deg corner pulleys"; width = 56; }
    }
    : row {
      : button { key = "f_handrail"; label = "Draw Safety Handrails"; width = 26; }
      : text { label = "PVSAFETY Handrail | Perimeter dual-rail guardrail with stanchions (NBC 2016)"; width = 56; }
    }
  }
  : boxed_column {
    label = "6. DC Stringing, Inverters & Electrical BOS (IS / CEA)";
    : row {
      : button { key = "f_stringing"; label = "Auto Snake Stringing"; width = 26; }
      : text { label = "PVSTRING Auto | Boustrophedon snake stringing, color-coded circuits & tags"; width = 56; }
    }
    : row {
      : button { key = "f_string_manual"; label = "Manual Click-to-Wire String"; width = 26; }
      : text { label = "PVSTRING Manual | Interactively click modules in custom sequence"; width = 56; }
    }
    : row {
      : button { key = "f_string_ew"; label = "East-West Series Stringing"; width = 26; }
      : text { label = "PVSTRING EW | Separate series strings for East & West subarrays"; width = 56; }
    }
    : row {
      : button { key = "f_polarity"; label = "Toggle Circuit Polarity (+/-)"; width = 26; }
      : text { label = "PVSTRING Polarity | Invert (+) and (-) DC string terminal poles"; width = 56; }
    }
    : row {
      : button { key = "f_string_vis"; label = "String Group Visualizer"; width = 26; }
      : text { label = "PVSTRING Vis | Highlight modules by string group with convex hull tint"; width = 56; }
    }
    : row {
      : button { key = "f_panel_num"; label = "Panel Index Numbering"; width = 26; }
      : text { label = "PVSTRING panelNum | Label modules: STR-01-01, STR-01-02..."; width = 56; }
    }
    : row {
      : button { key = "f_mppt_details"; label = "Inverter MPPT Matrix"; width = 26; }
      : text { label = "PVMPPT Details | MPPT tracker voltage & input allocation table"; width = 56; }
    }
    : row {
      : button { key = "f_mppt_link"; label = "Link String to Inverter/MPPT"; width = 26; }
      : text { label = "PVMPPT Link | Electrically connect string home run to inverter input"; width = 56; }
    }
    : row {
      : button { key = "f_inverter"; label = "Place Inverter Plinth"; width = 26; }
      : text { label = "PVINVERTER Place | Plinth pad, enclosure, DC/AC switches & ratings label"; width = 56; }
    }
    : row {
      : button { key = "f_ajb"; label = "Place Array Junction Box (AJB)"; width = 26; }
      : text { label = "PVAJB | Insert IP65 AJB/DCDB with 1000V DC fuses & Type-II SPD"; width = 56; }
    }
    : row {
      : button { key = "f_ac_equipment"; label = "Place ACDB & DISCOM Switch"; width = 26; }
      : text { label = "PVACDB | ACDB (4P MCCB, SPD) & Lockable DISCOM GOS Isolator"; width = 56; }
    }
    : row {
      : button { key = "f_earthing"; label = "IS 3043 Chemical Earthing"; width = 26; }
      : text { label = "PVEARTHING | Place AC, DC, LA earth pits (3m sep) & 25x3mm strip"; width = 56; }
    }
    : row {
      : button { key = "f_lightning"; label = "IS/IEC 62305 Lightning Arrester"; width = 26; }
      : text { label = "PVLIGHTNING | ESE / Franklin mast & rolling sphere protection cone"; width = 56; }
    }
    : row {
      : button { key = "f_cable_tray"; label = "Draw Cable Tray Corridor"; width = 26; }
      : text { label = "PVCABLE Tray | Perforated HDG tray with cover, %Vdrop calculation"; width = 56; }
    }
    : row {
      : button { key = "f_dc_route_tracked"; label = "Tracked DC Cable Routing"; width = 26; }
      : text { label = "PVCABLE Route | Draw DC runs snapped to tray/conduit routes"; width = 56; }
    }
    : row {
      : button { key = "f_dc_route_color"; label = "Color DC Route by Polarity"; width = 26; }
      : text { label = "PVCABLE Color | Dual Red (+) & Black (-) polarity conduit coloring"; width = 56; }
    }
    : row {
      : button { key = "f_cable_calc"; label = "DC/AC Cable Voltage Drop"; width = 26; }
      : text { label = "PVCABLE Calc | IS 17293 DC & IS 7098 AC Armored %Vdrop and mm2 sizing"; width = 56; }
    }
    : row {
      : button { key = "f_dc_schedule"; label = "Insert DC Cable Schedule"; width = 26; }
      : text { label = "PVEXPORT CSV | AutoCAD table: string tag, mm2, length & %Vdrop"; width = 56; }
    }
  }
  : boxed_column {
    label = "7. Single Line Diagram, Reports & Exports";
    : row {
      : button { key = "f_sld"; label = "CEIG Single Line Diagram (SLD)"; width = 26; }
      : text { label = "PVREPORT SLD | CEIG & DISCOM SLD with Dual Meters, GOS & IS 3043 Earthing"; width = 56; }
    }
    : row {
      : button { key = "f_energy_table"; label = "Insert 25-Yr Energy Table"; width = 26; }
      : text { label = "PVREPORT Energy | AutoCAD native Monthly, Yearly & 25-Yr Energy Table"; width = 56; }
    }
    : row {
      : button { key = "f_bom_table"; label = "Insert Bill of Materials (BOM)"; width = 26; }
      : text { label = "PVREPORT BOM | Indian Market BOQ (ALMM, Earth Pits, LA, ACDB/DCDB, HDG)"; width = 56; }
    }
    : row {
      : button { key = "f_sim_report"; label = "View Simulation Report"; width = 26; }
      : text { label = "PVREPORT Energy | Open comprehensive IEC 61724 report in Notepad"; width = 56; }
    }
    : row {
      : button { key = "f_export_pvsyst"; label = "Export PVsyst 3D Array CSV"; width = 26; }
      : text { label = "PVEXPORT PVsyst | 3D array coordinate CSV export for PVsyst 7/8"; width = 56; }
    }
    : row {
      : button { key = "f_pvsyst_export"; label = "Export Native PVsyst .PVC"; width = 26; }
      : text { label = "PVEXPORT PVsyst | Export native PVsyst 3D shading scene (.PVC)"; width = 56; }
    }
    : row {
      : button { key = "f_export_csv"; label = "Export Project CSV Data"; width = 26; }
      : text { label = "PVEXPORT CSV | Export generation & degradation schedule to CSV"; width = 56; }
    }
  }
  : boxed_column {
    label = "8. Clear / Reset Drawing Elements (Unified Master Reset)";
    : row {
      : button { key = "f_clr_all"; label = "Clear Everything"; width = 26; }
      : text { label = "PVCLEAR All | Clear layout, strings, walkways, handrails, cable tray, 3D, obstacles"; width = 56; }
    }
    : row {
      : button { key = "f_clr_layout"; label = "Clear Active Layout"; width = 26; }
      : text { label = "PVCLEAR Layout | Clear all generated modules and array polyline"; width = 56; }
    }
    : row {
      : button { key = "f_clr_strings"; label = "Clear DC Strings"; width = 26; }
      : text { label = "PVCLEAR Strings | Purge active DC circuit polylines and markers"; width = 56; }
    }
    : row {
      : button { key = "f_clr_walkway"; label = "Clear Walkway Corridors"; width = 26; }
      : text { label = "PVCLEAR Walkway | Removes user walkway corridors and restores space"; width = 56; }
    }
    : row {
      : button { key = "f_clr_handrail"; label = "Clear Handrails"; width = 26; }
      : text { label = "PVCLEAR Handrail | Remove all handrail entities from drawing"; width = 56; }
    }
    : row {
      : button { key = "f_clr_cabletray"; label = "Clear Cable Tray"; width = 26; }
      : text { label = "PVCLEAR CableTray | Remove all cable tray entities from drawing"; width = 56; }
    }
    : row {
      : button { key = "f_clr_earthing"; label = "Clear Earthing & Lightning"; width = 26; }
      : text { label = "PVEARTHING Clear | Remove all earth pits, strips & lightning mast"; width = 56; }
    }
    : row {
      : button { key = "f_clr_3d"; label = "Clear 3D Visualization"; width = 26; }
      : text { label = "PVCLEAR 3d | Remove 3D module faces, MMS legs & ISO view entities"; width = 56; }
    }
    : row {
      : button { key = "f_clr_bldg"; label = "Clear 3D Building"; width = 26; }
      : text { label = "PVCLEAR Building | Remove 3D building walls, roof faces & parapet"; width = 56; }
    }
    : row {
      : button { key = "f_clr_obs"; label = "Clear Obstacles / Shadows"; width = 26; }
      : text { label = "PVCLEAR Obstacles | Purges active obstacles & shadow envelopes"; width = 56; }
    }
  }
  : spacer { height = 1; }
  : boxed_row {
    label = "Full Configuration Suite";
    : button {
      key = "f_open_designer";
      label = "Open Multi-Tabbed Designer...";
      width = 28;
      is_default = true;
    }
    : text {
      label = "Command: PVSOLAR | Interactive 6-Tab Designer for complete configuration";
      width = 54;
    }
  }

  : spacer { height = 1; }
  : row {
    : spacer { width = 1; }
    : cancel_button {
      key = "cancel";
      label = "Close";
      is_cancel = true;
    }
  }
}
tab_site_roof : dialog {
  label = "Solar PV Plant Layout Generator - Tab 1: Site Location & Rooftop Structure";
  initial_focus = "proj_name";

  : row {
    alignment = centered;
    : button { key = "tab_btn_1"; label = "[ 1. Site & Roof ]"; width = 17; is_enabled = false; }
    : button { key = "tab_btn_2"; label = "  2. Equipment  "; width = 15; }
    : button { key = "tab_btn_3"; label = "  3. Array Layout  "; width = 17; }
    : button { key = "tab_btn_4"; label = " 4. Walkway & Safety "; width = 19; }
    : button { key = "tab_btn_5"; label = "  5. Electrical & 3D  "; width = 19; }
    : button { key = "tab_btn_6"; label = "  6. Financial & BOM  "; width = 19; }
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Site Location, Solar Resource & Weather Source";
    : row {
      : edit_box {
        label = "Site / Project Name:";
        key = "proj_name";
        edit_width = 24;
        value = "Solar Rooftop Project";
      }
      : popup_list {
        label = "Weather Data Source:";
        key = "weather_source";
        edit_width = 22;
      }
    }
    : row {
      : edit_box {
        label = "Latitude (deg N/S):";
        key = "lat_val";
        edit_width = 9;
        value = "13.0827";
      }
      : edit_box {
        label = "Longitude (deg E/W):";
        key = "lon_val";
        edit_width = 9;
        value = "80.2707";
      }
      : edit_box {
        label = "Tilt Angle (deg):";
        key = "tilt_angle";
        edit_width = 7;
        value = "15.0";
      }
      : edit_box {
        label = "Azimuth (180=S):";
        key = "azimuth_angle";
        edit_width = 7;
        value = "180.0";
      }
    }
  }

  : boxed_column {
    label = "2. Rooftop Structure & Sizing Capacity Mode";
    : row {
      : popup_list {
        label = "Roof Structure:";
        key = "roof_type";
        edit_width = 22;
      }
      : popup_list {
        label = "Mounting Option:";
        key = "mount_option";
        edit_width = 22;
      }
    }
    : row {
      : popup_list {
        label = "Layout Sizing Mode:";
        key = "layout_mode";
        edit_width = 24;
      }
      : edit_box {
        label = "Target Capacity (kWp):";
        key = "target_kw";
        edit_width = 8;
        value = "50.0";
      }
      : edit_box {
        label = "Boundary Setback (m):";
        key = "roof_setback";
        edit_width = 6;
        value = "0.50";
      }
    }
    : row {
      : edit_box {
        label = "Roof Slope (deg):";
        key = "roof_slope";
        edit_width = 8;
        value = "0.0";
      }
      : edit_box {
        label = "Module Clearance (m):";
        key = "mod_clearance";
        edit_width = 8;
        value = "0.50";
      }
      : edit_box {
        label = "Base System PR (%):";
        key = "pr_val";
        edit_width = 6;
        value = "78.0";
      }
    }
    : row {
      : edit_box {
        label = "Building Height (m):";
        key = "bldg_height";
        edit_width = 8;
        value = "6.00";
      }
      : edit_box {
        label = "Parapet Wall Height (m):";
        key = "parapet_height";
        edit_width = 8;
        value = "1.00";
      }
      : edit_box {
        label = "Parapet Wall Thickness (m):";
        key = "parapet_thick";
        edit_width = 6;
        value = "0.23";
      }
    }
    : spacer { height = 1; }
        : spacer { height = 1; }
    : boxed_column {
      label = "3. Indian Regulatory, DISCOM & Structural Parameters";
      : row {
        : edit_box {
          label = "Sanctioned Load (kW):";
          key = "sanctioned_load_kw";
          edit_width = 8;
          value = "25.0";
        }
        : edit_box {
          label = "Contract Demand (kVA):";
          key = "contract_demand_kva";
          edit_width = 8;
          value = "28.0";
        }
        : popup_list {
          label = "Grid Supply Voltage:";
          key = "grid_voltage_opt";
          edit_width = 20;
        }
      }
      : row {
        : popup_list {
          label = "Wind Zone (IS 875 Pt 3):";
          key = "wind_zone_opt";
          edit_width = 22;
        }
        : edit_box {
          label = "Peak Summer Amb (°C):";
          key = "ambient_temp_max";
          edit_width = 6;
          value = "45.0";
        }
        : edit_box {
          label = "Winter Min Amb (°C):";
          key = "temp_min_c";
          edit_width = 6;
          value = "8.0";
        }
      }
    }

    : boxed_column {
      label = "Elevated Tilted Legs & Continuous Canopy Setup (Flat RCC)";
      : row {
        : popup_list {
          label = "Leg Spacing Rule:";
          key = "elev_leg_mode";
          edit_width = 24;
        }
        : popup_list {
          label = "Continuous Slope Plane:";
          key = "elev_tilt_dir";
          edit_width = 24;
        }
      }
      : row {
        : edit_box {
          label = "Intermediate Legs Count:";
          key = "elev_leg_count";
          edit_width = 6;
          value = "2";
        }
        : edit_box {
          label = "Spacing in Metres (m):";
          key = "elev_leg_dist";
          edit_width = 6;
          value = "3.00";
        }
        : edit_box {
          label = "Spacing in Modules:";
          key = "elev_leg_mods";
          edit_width = 6;
          value = "2";
        }
        : edit_box {
          label = "Lowest Leg Clearance (m):";
          key = "elev_min_clear";
          edit_width = 6;
          value = "2.00";
        }
      }
    }
  }

  : spacer { height = 1; }
  : row {
    : spacer { width = 1; }
    : button {
      key = "btn_next_tab";
      label = "Next: PV Modules & Inverters (Tab 2) >>";
      width = 42;
    }
  }

  : spacer { height = 1; }
  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure parameters and select boundary/obstacles.";
      width = 54;
    }
    : spacer { width = 1; }
    : ok_button {
      label = "Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 3. TAB 2: PV MODULE & INVERTER EQUIPMENT (.PAN / .OND)
// ==========================================================================
tab_equipment : dialog {
  label = "Solar PV Plant Layout Generator - Tab 2: PV Module & Inverter Equipment (.PAN / .OND)";
  initial_focus = "mod_select";

  : row {
    alignment = centered;
    : button { key = "tab_btn_1"; label = "  1. Site & Roof  "; width = 17; }
    : button { key = "tab_btn_2"; label = "[ 2. Equipment ]"; width = 15; is_enabled = false; }
    : button { key = "tab_btn_3"; label = "  3. Array Layout  "; width = 17; }
    : button { key = "tab_btn_4"; label = " 4. Walkway & Safety "; width = 19; }
    : button { key = "tab_btn_5"; label = "  5. Electrical & 3D  "; width = 19; }
    : button { key = "tab_btn_6"; label = "  6. Financial & BOM  "; width = 19; }
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Solar PV Module Selection & PAN File Library";
    : row {
      : popup_list {
        label = "Select PV Module:";
        key = "mod_select";
        edit_width = 34;
      }
      : button {
        label = "Browse PAN File...";
        key = "btn_load_pan";
        width = 18;
      }
    }
    : row {
      : edit_box {
        label = "Power Rating (Wp):";
        key = "mod_watt";
        edit_width = 8;
        value = "550.0";
      }
      : edit_box {
        label = "Length (m):";
        key = "mod_len";
        edit_width = 8;
        value = "2.278";
      }
      : edit_box {
        label = "Width (m):";
        key = "mod_wid";
        edit_width = 8;
        value = "1.134";
      }
    }
    : row {
      : text {
        key = "txt_pan_specs";
        label = "Vmp: 41.95V | Imp: 13.12A | Voc: 49.80V | muPmp: -0.30%/degC | Eff: 21.3%";
        width = 68;
      }
    }
  }

  : boxed_column {
    label = "2. Grid-Tied String Inverter Selection & OND File Library";
    : row {
      : popup_list {
        label = "Select String Inverter:";
        key = "inv_select";
        edit_width = 34;
      }
      : button {
        label = "Browse OND File...";
        key = "btn_load_ond";
        width = 18;
      }
    }
    : row {
      : text {
        key = "txt_inv_info";
        label = "Inverter: Sungrow SG50CX (50 kW AC | 5 MPPTs | Max 1000V DC)";
        width = 68;
      }
    }
    : row {
      : text {
        key = "txt_inv_specs";
        label = "MPPT: 200-960V | Inputs: 10 (2/MPPT) | ImaxDC: 100A | Euro Eff: 98.5%";
        width = 68;
      }
    }
  }

  : spacer { height = 1; }
  : row {
    : button {
      key = "btn_prev_tab";
      label = "<< Back: Site & Roof (Tab 1)";
      width = 30;
    }
    : spacer { width = 1; }
    : button {
      key = "btn_next_tab";
      label = "Next: Array Layout & Obstacles (Tab 3) >>";
      width = 42;
    }
  }

  : spacer { height = 1; }
  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure parameters and select boundary/obstacles.";
      width = 54;
    }
    : spacer { width = 1; }
    : ok_button {
      label = "Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 4. TAB 3: ARRAY LAYOUT & OBSTACLE SHADING
// ==========================================================================
tab_array_layout : dialog {
  label = "Solar PV Plant Layout Generator - Tab 3: Array Layout & Obstacle Shading";
  initial_focus = "mod_orient";

  : row {
    alignment = centered;
    : button { key = "tab_btn_1"; label = "  1. Site & Roof  "; width = 17; }
    : button { key = "tab_btn_2"; label = "  2. Equipment  "; width = 15; }
    : button { key = "tab_btn_3"; label = "[ 3. Array Layout ]"; width = 17; is_enabled = false; }
    : button { key = "tab_btn_4"; label = " 4. Walkway & Safety "; width = 19; }
    : button { key = "tab_btn_5"; label = "  5. Electrical & 3D  "; width = 19; }
    : button { key = "tab_btn_6"; label = "  6. Financial & BOM  "; width = 19; }
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Array Geometry & Table Configuration";
    : row {
      : popup_list {
        label = "Orientation:";
        key = "mod_orient";
        edit_width = 14;
      }
      : edit_box {
        label = "Modules per Table (Cols x Rows):";
        key = "table_cols";
        edit_width = 5;
        value = "10";
      }
      : text { label = "x"; }
      : edit_box {
        key = "table_rows";
        edit_width = 5;
        value = "1";
      }
      : edit_box {
        label = "Table Pitch (m):";
        key = "row_pitch";
        edit_width = 7;
        value = "2.80";
      }
      : button {
        label = "Auto Pitch";
        key = "btn_auto_pitch";
        width = 10;
      }
    }
    : row {
      : edit_box {
        label = "Module Col Spacing (m):";
        key = "col_spacing";
        edit_width = 6;
        value = "0.03";
      }
      : edit_box {
        label = "Module Row Spacing (m):";
        key = "row_spacing";
        edit_width = 6;
        value = "0.03";
      }
      : edit_box {
        label = "Obstacle Height (m):";
        key = "obs_default_ht";
        edit_width = 6;
        value = "1.50";
      }
      : toggle {
        label = "Shadows ON/OFF";
        key = "chk_draw_shadow";
        value = "1";
      }
      : button {
        label = "Toggle Shadow Map (ON/OFF)";
        key = "btn_toggle_shadow";
        width = 24;
      }
    }
  }

  : boxed_column {
    label = "2. Maintenance Walkway Corridors & Safety Reference";
    : text {
      label = "Maintenance Walkways, Guardrails & Lifelines are configured under Tab 4 (Walkway & Safety).";
    }
    : text {
      label = "Note: In India (IS 875 / CEIG), minimum 0.8m - 1.0m walkways are recommended for cleaning access.";
    }
  }

  : boxed_row {
    label = "3. AutoCAD Interactive Layout Execution Steps";
    : button {
      label = "1. Pick Boundary";
      key = "btn_pick_boundary";
      width = 15;
    }
    : button {
      label = "2. Pick Obstacles";
      key = "btn_pick_obstacles";
      width = 15;
    }
    : button {
      label = "Clear Obs";
      key = "btn_clear_obstacles";
      width = 10;
    }
    : button {
      label = "3. Generate Layout";
      key = "btn_generate_layout";
      width = 17;
    }
    : button {
      label = "Clear Layout";
      key = "btn_clear_layout";
      width = 12;
    }
  }

  : spacer { height = 1; }
  : row {
    : button {
      key = "btn_prev_tab";
      label = "<< Back: Equipment (Tab 2)";
      width = 30;
    }
    : spacer { width = 1; }
    : button {
      key = "btn_next_tab";
      label = "Next: Walkways & Safety (Tab 4) >>";
      width = 38;
    }
  }

  : spacer { height = 1; }
  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure parameters and select boundary/obstacles.";
      width = 54;
    }
    : spacer { width = 1; }
    : ok_button {
      label = "Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 5. TAB 4: MAINTENANCE WALKWAYS & FALL SAFETY SYSTEMS
// ==========================================================================
tab_walkway_safety : dialog {
  label = "Solar PV Plant Layout Generator - Tab 4: Maintenance Walkways & Fall Safety Systems";
  initial_focus = "walkway_width";

  : row {
    alignment = centered;
    : button { key = "tab_btn_1"; label = "  1. Site & Roof  "; width = 17; }
    : button { key = "tab_btn_2"; label = "  2. Equipment  "; width = 15; }
    : button { key = "tab_btn_3"; label = "  3. Array Layout  "; width = 17; }
    : button { key = "tab_btn_4"; label = "[ 4. Walkway & Safety ]"; width = 19; is_enabled = false; }
    : button { key = "tab_btn_5"; label = "  5. Electrical & 3D  "; width = 19; }
    : button { key = "tab_btn_6"; label = "  6. Financial & BOM  "; width = 19; }
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Rooftop Maintenance Walkway Corridors & Grid Frequency";
    : row {
      : edit_box {
        label = "Walkway Corridor Width (m):";
        key = "walkway_width";
        edit_width = 8;
        value = "0.80";
      }
      : button {
        label = "Pick / Draw Walkway Path...";
        key = "btn_draw_walkway";
        width = 26;
      }
      : button {
        label = "Clear Walkways";
        key = "btn_clear_walkway";
        width = 16;
      }
    }
    : row {
      : edit_box {
        label = "Horiz Freq (Every N Module Rows):";
        key = "walkway_freq_row";
        edit_width = 6;
        value = "0";
      }
      : edit_box {
        label = "Vert Freq (Every N Module Cols):";
        key = "walkway_freq_col";
        edit_width = 6;
        value = "0";
      }
      : toggle {
        label = "Draw Walkways (Yes/No)";
        key = "chk_draw_auto_walkway";
        value = "1";
      }
    }
    : row {
      : text {
        key = "txt_walkway_status";
        label = "Walkway Status: No path defined yet. Click 'Pick/Draw Walkway Path'.";
        width = 68;
      }
    }
  }

  : boxed_column {
    label = "2. Rooftop Safety Handrails & Guardrails (NBC 2016 & CEA Safety Regulations)";
    : row {
      : edit_box {
        label = "Handrail Height (m):";
        key = "txt_handrail_ht";
        edit_width = 8;
      }
      : popup_list {
        label = "Horizontal Rails:";
        key = "pop_handrail_num_rails";
        width = 24;
      }
    }
    : row {
      : popup_list {
        label = "Vertical Post Shape:";
        key = "pop_handrail_post_shape";
        width = 22;
      }
      : popup_list {
        label = "Hand Rail Shape:";
        key = "pop_handrail_rail_shape";
        width = 22;
      }
    }
    : row {
      : edit_box {
        label = "Post Spacing (m):";
        key = "txt_handrail_spacing";
        edit_width = 8;
      }
      : toggle {
        label = "Include 150mm Kickplate (Toeboard)";
        key = "chk_handrail_toeboard";
      }
    }
    : row {
      : toggle {
        label = "Consider Handrail as Obstacle (Generate 9am-3pm Shadow Map on PV_SHADOW)";
        key = "chk_handrail_shadow";
      }
    }
    : row {
      : button {
        label = "Draw 3D Safety Handrails";
        key = "btn_draw_handrail";
        width = 30;
      }
      : button {
        label = "Clear Handrails";
        key = "btn_clear_handrail";
        width = 20;
      }
    }
  }

  : boxed_column {
    label = "3. Fall Safety Lifeline System (NBC 2016 / IS Standards)";
    : row {
      : button {
        label = "Draw Fall Safety Lifeline (Wire Rope)";
        key = "btn_draw_fall_safety";
        width = 34;
      }
      : text {
        label = "Spring tensioners, 90 deg corner pulleys & SS wire rope atop roof";
        width = 38;
      }
    }
  }

  : spacer { height = 1; }
  : row {
    : button {
      key = "btn_prev_tab";
      label = "<< Back: Array Layout (Tab 3)";
      width = 30;
    }
    : spacer { width = 1; }
    : button {
      key = "btn_next_tab";
      label = "Next: Electrical & 3D (Tab 5) >>";
      width = 36;
    }
  }

  : spacer { height = 1; }
  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure parameters and select boundary/obstacles.";
      width = 54;
    }
    : spacer { width = 1; }
    : ok_button {
      label = "Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 6. TAB 5: ELECTRICAL SYSTEM, SLD & 3D 
// ==========================================================================
tab_electrical_3d : dialog {
  label = "Solar PV Plant Layout Generator - Tab 5: Electrical System, SLD & 3D";
  initial_focus = "string_size";

  : row {
    alignment = centered;
    : button { key = "tab_btn_1"; label = "  1. Site & Roof  "; width = 17; }
    : button { key = "tab_btn_2"; label = "  2. Equipment  "; width = 15; }
    : button { key = "tab_btn_3"; label = "  3. Array Layout  "; width = 17; }
    : button { key = "tab_btn_4"; label = " 4. Walkway & Safety "; width = 19; }
    : button { key = "tab_btn_5"; label = "[ 5. Electrical & 3D ]"; width = 19; is_enabled = false; }
    : button { key = "tab_btn_6"; label = "  6. Financial & BOM  "; width = 19; }
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Automated DC Stringing Engine";
    : row {
      : edit_box {
        label = "Modules per String:";
        key = "string_size";
        edit_width = 6;
        value = "20";
      }
      : button {
        label = "Run DC Stringing (Snake)";
        key = "btn_stringing";
        width = 24;
      }
      : button {
        label = "Clear Strings";
        key = "btn_clear_strings";
        width = 16;
      }
    }
    : text {
      label = "Color-coded circuits, [+] / [-] terminal markers & circuit tags";
    }
  }

  : boxed_column {
    label = "2. Inverter Station, Cable Tray Corridor & Single Line Diagram (SLD)";
    : row {
      : button {
        label = "Place Inverter Plinth";
        key = "btn_place_inverter";
        width = 22;
      }
      : button {
        label = "Place AJB / DCDB";
        key = "btn_place_ajb";
        width = 20;
      }
      : button {
        label = "Place ACDB & GOS Switch";
        key = "btn_place_acdb";
        width = 24;
      }
    }
    : row {
      : button {
        label = "Draw Cable Tray Path";
        key = "btn_cable_tray";
        width = 22;
      }
      : button {
        label = "IS 3043 Chemical Earthing";
        key = "btn_earthing";
        width = 22;
      }
      : button {
        label = "IS/IEC 62305 Lightning Protection";
        key = "btn_lightning";
        width = 26;
      }
    }
    : row {
      : button {
        label = "Generate CEIG-Compliant SLD";
        key = "btn_sld";
        width = 30;
      }
    }
  }

  : boxed_column {
    label = "3. 3D Isometric View, Shadow Pruning & PVsyst Export";
    : row {
      : button {
        label = "3D Isometric View";
        key = "btn_3d_view";
        width = 22;
      }
      : button {
        label = "Prune Over-Shaded Modules";
        key = "btn_prune_shaded";
        width = 26;
      }
      : button {
        label = "Export PVsyst 3D CSV";
        key = "btn_export_pvsyst";
        width = 20;
      }
    }
  }

  : spacer { height = 1; }
  : row {
    : button {
      key = "btn_prev_tab";
      label = "<< Back: Walkway & Safety (Tab 4)";
      width = 34;
    }
    : spacer { width = 1; }
    : button {
      key = "btn_next_tab";
      label = "Next: Financial & Reports (Tab 6) >>";
      width = 36;
    }
  }

  : spacer { height = 1; }
  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure parameters and select boundary/obstacles.";
      width = 54;
    }
    : spacer { width = 1; }
    : ok_button {
      label = "Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 7. TAB 6: FINANCIAL ROI, BOM & DELIVERABLES
// ==========================================================================
tab_reports_finance : dialog {
  label = "Solar PV Plant Layout Generator - Tab 6: Financial ROI, BOM & Deliverables";
  initial_focus = "grid_tariff";

  : row {
    alignment = centered;
    : button { key = "tab_btn_1"; label = "  1. Site & Roof  "; width = 17; }
    : button { key = "tab_btn_2"; label = "  2. Equipment  "; width = 15; }
    : button { key = "tab_btn_3"; label = "  3. Array Layout  "; width = 17; }
    : button { key = "tab_btn_4"; label = " 4. Walkway & Safety "; width = 19; }
    : button { key = "tab_btn_5"; label = "  5. Electrical & 3D  "; width = 19; }
    : button { key = "tab_btn_6"; label = "[ 6. Financial & BOM ]"; width = 19; is_enabled = false; }
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Financial ROI, Tariffs & Commercial Investment Metrics (India Subsidy / Tax)";
    : row {
      : popup_list {
        label = "Project Currency:";
        key = "currency_select";
        edit_width = 24;
      }
      : edit_box {
        label = "Grid Electricity Tariff (/kWh):";
        key = "grid_tariff";
        edit_width = 8;
        value = "7.50";
      }
      : edit_box {
        label = "Turnkey EPC Cost (/Wp):";
        key = "epc_cost_watt";
        edit_width = 8;
        value = "42.00";
      }
    }
    : row {
      : edit_box {
        label = "PM Surya Ghar Subsidy (Rs):";
        key = "subsidy_rs";
        edit_width = 10;
        value = "78000.0";
      }
      : toggle {
        label = "40% Accelerated Depreciation (C&I)";
        key = "chk_commercial_ad";
        value = "0";
      }
      : edit_box {
        label = "Blended GST Rate (%):";
        key = "gst_rate";
        edit_width = 6;
        value = "13.8";
      }
    }
    : row {
      : text {
        key = "txt_financial_summary";
        label = "Est. CapEx: Rs. 2,100,000 | Simple Payback: 3.8 Yrs | 25-Yr Savings: Rs. 9,450,000 | LCOE: Rs. 2.45/kWh";
        width = 74;
      }
    }
  }

  : boxed_column {
    label = "2. AutoCAD Native Tables, Reports & Simulation Schedules";
    : row {
      : button {
        label = "Insert 25-Yr Energy Table";
        key = "btn_gen_energy_table";
        width = 24;
      }
      : button {
        label = "Insert Bill of Materials (BOM)";
        key = "btn_gen_bom";
        width = 24;
      }
      : button {
        label = "Simulation Report";
        key = "btn_gen_energy";
        width = 18;
      }
    }
    : row {
      : button {
        label = "Export Project CSV Data";
        key = "btn_export_csv";
        width = 24;
      }
      : text {
        label = "Command: PVEXPORTCSV | Export generation & degradation schedule to CSV";
        width = 46;
      }
    }
  }

  : spacer { height = 1; }
  : row {
    : button {
      key = "btn_prev_tab";
      label = "<< Back: Electrical & 3D (Tab 5)";
      width = 34;
    }
    : spacer { width = 1; }
  }

  : spacer { height = 1; }
  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure parameters and select boundary/obstacles.";
      width = 54;
    }
    : spacer { width = 1; }
    : ok_button {
      label = "Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 8. FULL DESIGNER CONFIGURATION DIALOG (All-In-One Fallback)
// ==========================================================================
rooftop_solar_dialog : dialog {
  label = "Solar PV Plant Layout Generator - Rooftop Projects v2.5";
  initial_focus = "proj_name";
  
  : boxed_column {
    label = "1. Site Location, Solar Resource & Weather Source";
    : row {
      : edit_box {
        label = "Site / Project Name:";
        key = "proj_name";
        edit_width = 24;
        value = "Solar Rooftop Project";
      }
      : popup_list {
        label = "Weather Data Source:";
        key = "weather_source";
        edit_width = 22;
      }
    }
    : row {
      : edit_box {
        label = "Latitude (deg N/S):";
        key = "lat_val";
        edit_width = 9;
        value = "13.0827";
      }
      : edit_box {
        label = "Longitude (deg E/W):";
        key = "lon_val";
        edit_width = 9;
        value = "80.2707";
      }
      : edit_box {
        label = "Tilt Angle (deg):";
        key = "tilt_angle";
        edit_width = 7;
        value = "15.0";
      }
      : edit_box {
        label = "Azimuth (180=S):";
        key = "azimuth_angle";
        edit_width = 7;
        value = "180.0";
      }
    }
  }

  : boxed_column {
    label = "2. Rooftop Structure & Sizing Capacity Mode";
    : row {
      : popup_list {
        label = "Roof Structure:";
        key = "roof_type";
        edit_width = 22;
      }
      : popup_list {
        label = "Mounting Option:";
        key = "mount_option";
        edit_width = 22;
      }
    }
    : row {
      : popup_list {
        label = "Layout Sizing Mode:";
        key = "layout_mode";
        edit_width = 24;
      }
      : edit_box {
        label = "Target Capacity (kWp):";
        key = "target_kw";
        edit_width = 8;
        value = "50.0";
      }
      : edit_box {
        label = "Boundary Setback (m):";
        key = "roof_setback";
        edit_width = 6;
        value = "0.50";
      }
    }
    : row {
      : edit_box {
        label = "Roof Slope (deg):";
        key = "roof_slope";
        edit_width = 8;
        value = "0.0";
      }
      : edit_box {
        label = "Module Clearance (m):";
        key = "mod_clearance";
        edit_width = 8;
        value = "0.50";
      }
      : edit_box {
        label = "Base System PR (%):";
        key = "pr_val";
        edit_width = 6;
        value = "78.0";
      }
    }
    : row {
      : edit_box {
        label = "Building Height (m):";
        key = "bldg_height";
        edit_width = 8;
        value = "6.00";
      }
      : edit_box {
        label = "Parapet Wall Height (m):";
        key = "parapet_height";
        edit_width = 8;
        value = "1.00";
      }
      : edit_box {
        label = "Parapet Wall Thickness (m):";
        key = "parapet_thick";
        edit_width = 6;
        value = "0.23";
      }
    }
    : spacer { height = 1; }
    : boxed_column {
      label = "Indian Regulatory, DISCOM & Structural Parameters";
      : row {
        : edit_box {
          label = "Sanctioned Load (kW):";
          key = "sanctioned_load_kw";
          edit_width = 8;
          value = "25.0";
        }
        : edit_box {
          label = "Contract Demand (kVA):";
          key = "contract_demand_kva";
          edit_width = 8;
          value = "28.0";
        }
        : popup_list {
          label = "Grid Supply Voltage:";
          key = "grid_voltage_opt";
          edit_width = 20;
        }
      }
      : row {
        : popup_list {
          label = "Wind Zone (IS 875 Pt 3):";
          key = "wind_zone_opt";
          edit_width = 22;
        }
        : edit_box {
          label = "Peak Summer Amb (°C):";
          key = "ambient_temp_max";
          edit_width = 6;
          value = "45.0";
        }
        : edit_box {
          label = "Winter Min Amb (°C):";
          key = "temp_min_c";
          edit_width = 6;
          value = "8.0";
        }
      }
    }
    : spacer { height = 1; }
    : boxed_column {
      label = "Elevated Tilted Legs & Continuous Canopy Setup (Flat RCC)";
      : row {
        : popup_list {
          label = "Leg Spacing Rule:";
          key = "elev_leg_mode";
          edit_width = 24;
        }
        : popup_list {
          label = "Continuous Slope Plane:";
          key = "elev_tilt_dir";
          edit_width = 24;
        }
      }
      : row {
        : edit_box {
          label = "Intermediate Legs Count:";
          key = "elev_leg_count";
          edit_width = 6;
          value = "2";
        }
        : edit_box {
          label = "Spacing in Metres (m):";
          key = "elev_leg_dist";
          edit_width = 6;
          value = "3.00";
        }
        : edit_box {
          label = "Spacing in Modules:";
          key = "elev_leg_mods";
          edit_width = 6;
          value = "2";
        }
        : edit_box {
          label = "Lowest Leg Clearance (m):";
          key = "elev_min_clear";
          edit_width = 6;
          value = "2.00";
        }
      }
    }
  }

  : boxed_column {
    label = "3. Solar PV Module Selection & PAN File Library";
    : row {
      : popup_list {
        label = "Select PV Module:";
        key = "mod_select";
        edit_width = 34;
      }
      : button {
        label = "Add PAN File...";
        key = "btn_load_pan";
        width = 16;
      }
    }
    : row {
      : edit_box {
        label = "Power Rating (Wp):";
        key = "mod_watt";
        edit_width = 8;
        value = "550.0";
      }
      : edit_box {
        label = "Length (m):";
        key = "mod_len";
        edit_width = 8;
        value = "2.278";
      }
      : edit_box {
        label = "Width (m):";
        key = "mod_wid";
        edit_width = 8;
        value = "1.134";
      }
    }
    : row {
      : text {
        key = "txt_pan_specs";
        label = "Vmp: 41.95V | Imp: 13.12A | Voc: 49.80V | muPmp: -0.30%/degC | Eff: 21.3%";
        width = 68;
      }
    }
  }

  : boxed_column {
    label = "4. Grid-Tied String Inverter Selection & OND File Library";
    : row {
      : popup_list {
        label = "Select String Inverter:";
        key = "inv_select";
        edit_width = 34;
      }
      : button {
        label = "Add OND File...";
        key = "btn_load_ond";
        width = 16;
      }
    }
    : row {
      : text {
        key = "txt_inv_info";
        label = "Inverter: Sungrow SG50CX (50 kW AC | 5 MPPTs | Max 1000V DC)";
        width = 68;
      }
    }
    : row {
      : text {
        key = "txt_inv_specs";
        label = "MPPT: 200-960V | Inputs: 10 (2/MPPT) | ImaxDC: 100A | Euro Eff: 98.5%";
        width = 68;
      }
    }
  }

  : boxed_column {
    label = "5. Array Geometry & Table Configuration";
    : row {
      : popup_list {
        label = "Orientation:";
        key = "mod_orient";
        edit_width = 14;
      }
      : edit_box {
        label = "Modules per Table (Cols x Rows):";
        key = "table_cols";
        edit_width = 5;
        value = "10";
      }
      : text { label = "x"; }
      : edit_box {
        key = "table_rows";
        edit_width = 5;
        value = "1";
      }
      : edit_box {
        label = "Table Pitch (m):";
        key = "row_pitch";
        edit_width = 7;
        value = "2.80";
      }
      : button {
        label = "Auto Pitch";
        key = "btn_auto_pitch";
        width = 10;
      }
    }
    : row {
      : edit_box {
        label = "Module Col Spacing (m):";
        key = "col_spacing";
        edit_width = 6;
        value = "0.03";
      }
      : edit_box {
        label = "Module Row Spacing (m):";
        key = "row_spacing";
        edit_width = 6;
        value = "0.03";
      }
      : edit_box {
        label = "Obstacle Height (m):";
        key = "obs_default_ht";
        edit_width = 6;
        value = "1.50";
      }
      : toggle {
        label = "Shadows ON/OFF";
        key = "chk_draw_shadow";
        value = "1";
      }
      : button {
        label = "Toggle Shadow Map (ON/OFF)";
        key = "btn_toggle_shadow";
        width = 24;
      }
    }
  }

  : boxed_column {
    label = "6. Maintenance Walkways & Safety Systems";
    : row {
      : edit_box {
        label = "Walkway Corridor Width (m):";
        key = "walkway_width";
        edit_width = 8;
        value = "0.80";
      }
      : edit_box {
        label = "Horiz Freq (Rows):";
        key = "walkway_freq_row";
        edit_width = 5;
        value = "0";
      }
      : edit_box {
        label = "Vert Freq (Cols):";
        key = "walkway_freq_col";
        edit_width = 5;
        value = "0";
      }
      : toggle {
        label = "Draw Walkways (Yes/No)";
        key = "chk_draw_auto_walkway";
        value = "1";
      }
    }
    : row {
      : button {
        label = "Pick / Draw Walkway Path...";
        key = "btn_draw_walkway";
        width = 24;
      }
      : button {
        label = "Clear Walkways";
        key = "btn_clear_walkway";
        width = 16;
      }
    }
    : row {
      : text {
        key = "txt_walkway_status";
        label = "Walkway Status: No path defined yet. Click 'Pick/Draw Walkway Path'.";
        width = 68;
      }
    }
    : row {
      : button {
        label = "Draw Fall Safety Line";
        key = "btn_draw_fall_safety";
        width = 24;
      }
      : button {
        label = "Draw Safety Handrails";
        key = "btn_draw_handrail";
        width = 24;
      }
    }
  }

  : boxed_column {
    label = "7. Electrical System, 3D Modeling & Financial Parameters";
    : row {
      : edit_box {
        label = "Modules per String:";
        key = "string_size";
        edit_width = 6;
        value = "20";
      }
      : popup_list {
        label = "Currency:";
        key = "currency_select";
        edit_width = 20;
      }
      : edit_box {
        label = "Grid Tariff (/kWh):";
        key = "grid_tariff";
        edit_width = 7;
        value = "7.50";
      }
      : edit_box {
        label = "EPC Cost (/Wp):";
        key = "epc_cost_watt";
        edit_width = 7;
        value = "42.00";
      }
    }
    : row {
      : button {
        label = "Run DC Stringing";
        key = "btn_stringing";
        width = 16;
      }
      : button {
        label = "Clear Strings";
        key = "btn_clear_strings";
        width = 13;
      }
      : button {
        label = "Place Inverter";
        key = "btn_place_inverter";
        width = 14;
      }
      : button {
        label = "Draw Cable Tray";
        key = "btn_cable_tray";
        width = 15;
      }
      : button {
        label = "Generate SLD";
        key = "btn_sld";
        width = 14;
      }
    }
    : row {
      : button {
        label = "3D Isometric View";
        key = "btn_3d_view";
        width = 18;
      }
      : button {
        label = "Prune Over-Shaded Modules";
        key = "btn_prune_shaded";
        width = 24;
      }
      : button {
        label = "Export PVsyst 3D CSV";
        key = "btn_export_pvsyst";
        width = 20;
      }
    }
  }

  : boxed_row {
    label = "Interactive CAD Selection & Execution Steps";
    : button {
      label = "1. Pick Boundary";
      key = "btn_pick_boundary";
      width = 15;
    }
    : button {
      label = "2. Pick Obstacles";
      key = "btn_pick_obstacles";
      width = 15;
    }
    : button {
      label = "Clear Obs";
      key = "btn_clear_obstacles";
      width = 10;
    }
    : button {
      label = "3. Generate Layout";
      key = "btn_generate_layout";
      width = 17;
    }
    : button {
      label = "Clear Layout";
      key = "btn_clear_layout";
      width = 12;
    }
  }

  : boxed_row {
    label = "Reports & Deliverables";
    : button {
      label = "Draw BOM Table";
      key = "btn_gen_bom";
      width = 16;
    }
    : button {
      label = "Draw Energy Table";
      key = "btn_gen_energy_table";
      width = 18;
    }
    : button {
      label = "Simulation Report";
      key = "btn_gen_energy";
      width = 16;
    }
    : button {
      label = "Export CSV";
      key = "btn_export_csv";
      width = 12;
    }
  }

  : spacer { height = 1; }

  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure parameters and select boundary/obstacles.";
      width = 54;
    }
    : spacer { width = 1; }
    : ok_button {
      label = "Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 8. ELEVATED TILTED LEGS & CONTINUOUS CANOPY DIALOG
// ==========================================================================
elev_legs_dialog : dialog {
  label = "Elevated Tilted Legs & Continuous Solar Canopy Setup";
  initial_focus = "elev_leg_mode";

  : text {
    label = "Flat RCC Rooftop - Elevated Tilted Structure & Vertical Legs Configuration";
    alignment = centered;
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Continuous Incident Solar Plane (North to South / East to West)";
    : text {
      label = "Note: Continuous incident plane maintains identical tilt angle across all rows with zero inter-row shading.";
    }
    : row {
      : popup_list {
        label = "Continuous Slope Plane:";
        key = "elev_tilt_dir";
        edit_width = 26;
      }
      : edit_box {
        label = "Canopy Tilt Angle (deg):";
        key = "tilt_angle";
        edit_width = 8;
        value = "15.0";
      }
      : edit_box {
        label = "Lowest Leg Clearance (m):";
        key = "elev_min_clear";
        edit_width = 8;
        value = "2.00";
      }
    }
  }

  : boxed_column {
    label = "2. Row Vertical Legs Placement & Intermediate Spacing Rules";
    : text {
      label = "Rule: Vertical legs begin with outer edge of first panel and end with outer edge of last panel in each row.";
    }
    : row {
      : popup_list {
        label = "Intermediate Leg Spacing Rule:";
        key = "elev_leg_mode";
        edit_width = 30;
      }
    }
    : row {
      : edit_box {
        label = "Intermediate Legs Count (between first & last):";
        key = "elev_leg_count";
        edit_width = 6;
        value = "2";
      }
      : edit_box {
        label = "Spacing in Metres (m):";
        key = "elev_leg_dist";
        edit_width = 6;
        value = "3.00";
      }
      : edit_box {
        label = "Spacing in Modules (panels):";
        key = "elev_leg_mods";
        edit_width = 6;
        value = "2";
      }
    }
  }

  : spacer { height = 1; }
  : row {
    : text {
      key = "status_bar";
      label = "Ready. Configure elevated legs and click Apply & Generate.";
      width = 44;
    }
    : spacer { width = 1; }
    : button {
      key = "btn_apply_gen";
      label = "Apply & Generate Layout";
      width = 24;
    }
    : ok_button {
      label = "Save & Close";
      is_default = true;
      key = "accept";
    }
    : cancel_button {
      label = "Cancel";
      is_cancel = true;
      key = "cancel";
    }
  }
}
