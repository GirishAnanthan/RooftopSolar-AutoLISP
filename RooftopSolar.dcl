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
  label = "Solar PV Rooftop - Master Functions Control Center v2.5";
  initial_focus = "f_open_designer";
  
  : text {
    label = "Select any function below to execute in AutoCAD:";
    alignment = centered;
  }
  : spacer { height = 1; }

  : boxed_column {
    label = "1. Boundary, Complex Roof Division & Offsets";
    : row {
      : button {
        label = "1. Pick Roof Boundary/Roofs";
        key = "f_pick_bnd";
        width = 26;
      }
      : text {
        label = "Command: PVPICKBOUNDARY | Selects single or multiple closed roof outlines";
        width = 48;
      }
    }
    : row {
      : button {
        label = "2. Multi-Roof Manager";
        key = "f_multiroof";
        width = 26;
      }
      : text {
        label = "Command: PVMULTIROOF | Configure multi-building / multi-zone roof sets";
        width = 48;
      }
    }
    : row {
      : button {
        label = "3. Multi-Roof Inventory";
        key = "f_roof_list";
        width = 26;
      }
      : text {
        label = "Command: PVROOFLIST | Displays list of all roofs with area (m²) and handle";
        width = 48;
      }
    }
    : row {
      : button {
        label = "4. Select Active Roof";
        key = "f_select_roof";
        width = 26;
      }
      : text {
        label = "Command: PVSELECTROOF | Choose specific active roof or select ALL roofs";
        width = 48;
      }
    }
    : row {
      : button {
        label = "5. Roof Type & 3D Building";
        key = "f_roof_bldg_3d";
        width = 26;
      }
      : text {
        label = "Command: PVBLDG3D | Configure roof slope (1/2/4 dir) & create 3D building";
        width = 48;
      }
    }
    : row {
      : button {
        label = "2. Pick Obstacles & Arrays";
        key = "f_pick_obs";
        width = 26;
      }
      : text {
        label = "Command: PVPICKOBSTACLES | Unpacks arrays & generates solar shadows";
        width = 48;
      }
    }
    : row {
      : button {
        label = "3. Clear Obstacles / Shadows";
        key = "f_clr_obs";
        width = 26;
      }
      : text {
        label = "Command: PVCLEAROBSTACLES | Purges active obstacles & shadow envelopes";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Toggle Shadow Map (ON/OFF)";
        key = "f_toggle_shadow";
        width = 26;
      }
      : text {
        label = "Command: PVSHADOWTOGGLE | Toggles obstacle solar shadow maps ON / OFF";
        width = 48;
      }
    }
    : row {
      : button {
        label = "4. Hip / Valley Roof Split";
        key = "f_hip_split";
        width = 26;
      }
      : text {
        label = "Command: PVHIPSPLIT | Bisects hip/valley roof polygons into sub-polygons";
        width = 48;
      }
    }
    : row {
      : button {
        label = "5. Curved Dome / Barrel Split";
        key = "f_dome_split";
        width = 26;
      }
      : text {
        label = "Command: PVDOMESPLIT | Divides curved vault into slope facet strips";
        width = 48;
      }
    }
    : row {
      : button {
        label = "6. Convert to Single Pitch";
        key = "f_one_dome";
        width = 26;
      }
      : text {
        label = "Command: PVONEDOME | Merges faceted barrel roof segments into one plane";
        width = 48;
      }
    }
    : row {
      : button {
        label = "7. Label Roof ID Numbers";
        key = "f_roof_num";
        width = 26;
      }
      : text {
        label = "Command: PVROOFNUM | Adds RF-01, RF-02 identifiers to each roof boundary";
        width = 48;
      }
    }
    : row {
      : button {
        label = "8. Show / Hide Parapet Offsets";
        key = "f_show_offsets";
        width = 26;
      }
      : text {
        label = "Commands: PVSHOWALLOFFSET / PVHIDEALLOFFSET | Toggles safety offset guides";
        width = 48;
      }
    }
  }

  : boxed_column {
    label = "2. Equipment Data & File Parsers (.PAN / .OND)";
    : row {
      : button {
        label = "Load PV Module (.PAN)...";
        key = "f_load_pan";
        width = 26;
      }
      : text {
        label = "Command: PVLOADPAN | Browse & parse PVsyst .PAN module specifications";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Load Inverter (.OND)...";
        key = "f_load_ond";
        width = 26;
      }
      : text {
        label = "Command: PVLOADOND | Browse & parse PVsyst .OND string inverter data";
        width = 48;
      }
    }
    : row {
      : button {
        label = "PVCompLib Component Library";
        key = "f_complib";
        width = 26;
      }
      : text {
        label = "Command: PVCOMPLIB | View persistent modules & inverters library (PVCompLib.lsp)";
        width = 48;
      }
    }
  }

  : boxed_column {
    label = "3. Solar PV Layout Sizing & Generation";
    : row {
      : button {
        label = "Generate Array Layout";
        key = "f_gen_layout";
        width = 26;
      }
      : text {
        label = "Command: PVLAYOUT | Populate boundary or size to Target Capacity (kWp)";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Generate East-West Layout";
        key = "f_layout_ew";
        width = 26;
      }
      : text {
        label = "Command: PVLAYOUTEW | Dual-tilt A-frame / butterfly East-West layout";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Elevated Tilted Legs Setup";
        key = "f_elev_legs";
        width = 26;
      }
      : text {
        label = "Command: PVELEVCONFIG | Continuous canopy slope & vertical leg spacing";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Toggle East/West Visibility";
        key = "f_ew_vis";
        width = 26;
      }
      : text {
        label = "Command: PVEWVIS | Filter East or West subarrays independently";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Dimension Layout Plan";
        key = "f_dim_plan";
        width = 26;
      }
      : text {
        label = "Command: PVDIMPLAN | Adds automated pitch, setback & row spacing dimensions";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Pre-Flight Engineering Check";
        key = "f_validate";
        width = 26;
      }
      : text {
        label = "Command: PVVALIDATE | Audit boundary clearance, MPPT voltage & shading";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Clear Active Layout";
        key = "f_clr_layout";
        width = 26;
      }
      : text {
        label = "Command: PVCLEARLAYOUT | Clear all generated modules and array polyline";
        width = 48;
      }
    }
  }

  : boxed_column {
    label = "4. Maintenance Walkways & Fall Safety Systems";
    : row {
      : button {
        label = "Pick/Draw Walkway Path";
        key = "f_walkway";
        width = 26;
      }
      : text {
        label = "Command: PVWALKWAY | Define dedicated walkway corridors between tables";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Clear Walkway Corridors";
        key = "f_clr_walkway";
        width = 26;
      }
      : text {
        label = "Command: PVCLEARWALKWAY | Removes user walkway corridors and restores space";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Draw Fall Safety Lifeline";
        key = "f_fall_safety";
        width = 26;
      }
      : text {
        label = "Command: PVFALLSAFETY | End anchors, spring tensioners & 90 deg corner pulleys";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Draw Safety Handrails";
        key = "f_handrail";
        width = 26;
      }
      : text {
        label = "Command: PVHANDRAIL | Perimeter dual-rail guardrail with stanchions";
        width = 48;
      }
    }
  }

  : boxed_column {
    label = "5. DC Stringing, Inverters & Electrical Routing";
    : row {
      : button {
        label = "Auto Snake Stringing";
        key = "f_stringing";
        width = 26;
      }
      : text {
        label = "Command: PVSTRING | Boustrophedon snake stringing, color-coded circuits & tags";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Manual Click-to-Wire String";
        key = "f_string_manual";
        width = 26;
      }
      : text {
        label = "Command: PVSTRINGMANUAL | Interactively click modules in custom sequence";
        width = 48;
      }
    }
    : row {
      : button {
        label = "East-West Series Stringing";
        key = "f_string_ew";
        width = 26;
      }
      : text {
        label = "Command: PVSTRINGEW | Separate series strings for East & West to avoid mismatch";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Toggle Circuit Polarity (+/-)";
        key = "f_polarity";
        width = 26;
      }
      : text {
        label = "Command: PVPOLARITY | Invert start/end (+) and (-) DC string terminal poles";
        width = 48;
      }
    }
    : row {
      : button {
        label = "String Group Visualizer";
        key = "f_string_vis";
        width = 26;
      }
      : text {
        label = "Command: PVSTRINGVIS | Highlight modules by string group with convex hull tint";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Panel Index Numbering";
        key = "f_panel_num";
        width = 26;
      }
      : text {
        label = "Command: PVPANELNUM | Label modules: STR-01-01, STR-01-02...";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Inverter MPPT Matrix";
        key = "f_mppt_details";
        width = 26;
      }
      : text {
        label = "Command: PVMPPTDETAILS | Display MPPT tracker voltage & input allocation table";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Link String to Inverter/MPPT";
        key = "f_mppt_link";
        width = 26;
      }
      : text {
        label = "Command: PVMPPTLINK | Electrically connect string home run to inverter input";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Tracked DC Cable Routing";
        key = "f_dc_route_tracked";
        width = 26;
      }
      : text {
        label = "Command: PVDCROUTETRACKED | Draw DC runs snapped to tray/conduit routes";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Color DC Route by Polarity";
        key = "f_dc_route_color";
        width = 26;
      }
      : text {
        label = "Command: PVDCROUTECOLORPOLARITY | Dual Red (+) & Black (-) polarity conduits";
        width = 48;
      }
    }
    : row {
      : button {
        label = "DC/AC Cable Voltage Drop Sizing";
        key = "f_cable_calc";
        width = 26;
      }
      : text {
        label = "Command: PVCABLECALC | BS 7671 / IEC 60364-7-712 %Vdrop and mm2 sizing";
        width = 48;
      }
    }
    : row {
      : button {
        label = "AC Equipment Placement";
        key = "f_ac_equipment";
        width = 26;
      }
      : text {
        label = "Command: PVACEQUIPMENT | Insert ACDB, Main Switchboard & Transformer";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Insert DC Cable Schedule";
        key = "f_dc_schedule";
        width = 26;
      }
      : text {
        label = "Command: PVDCSCHEDULE | AutoCAD table with string tag, mm2, length & %Vdrop";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Place Inverter Plinth";
        key = "f_inverter";
        width = 26;
      }
      : text {
        label = "Command: PVINVERTER | Plinth pad, enclosure, DC/AC switches & ratings label";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Draw Cable Tray Corridor";
        key = "f_cable_tray";
        width = 26;
      }
      : text {
        label = "Command: PVCABLETRAY | Perforated GI tray, %Vdrop calculation & cable bill";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Clear DC Strings";
        key = "f_clr_strings";
        width = 26;
      }
      : text {
        label = "Command: PVCLEARSTRINGS | Purge active DC circuit polylines and markers";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Single Line Diagram (SLD)";
        key = "f_sld";
        width = 26;
      }
      : text {
        label = "Command: PVSLD | Publication-ready electrical SLD (IEC 62446-1 standard)";
        width = 48;
      }
    }
  }

  : boxed_column {
    label = "6. 3D Isometric Shading & PVsyst Export";
    : row {
      : button {
        label = "3D Isometric View";
        key = "f_3d_view";
        width = 26;
      }
      : text {
        label = "Command: PV3D | 3DFACE tilted tables, MMS legs, 3D obstacles & SW Iso view";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Prune Over-Shaded Modules";
        key = "f_prune_shaded";
        width = 26;
      }
      : text {
        label = "Command: PVPRUNESHADED | Highlight & auto-delete shaded modules to boost PR";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Export PVsyst 3D Array CSV";
        key = "f_export_pvsyst";
        width = 26;
      }
      : text {
        label = "Command: PVPVSYST | Direct 3D array coordinate CSV export for PVsyst 7/8";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Export Native PVsyst .PVC";
        key = "f_pvsyst_export";
        width = 26;
      }
      : text {
        label = "Command: PVPVSYSTEXPORT | Export native PVsyst 3D shading scene (.PVC)";
        width = 48;
      }
    }
  }

  : boxed_column {
    label = "7. AutoCAD Deliverables, Tables & Reports";
    : row {
      : button {
        label = "Insert 25-Yr Energy Table";
        key = "f_energy_table";
        width = 26;
      }
      : text {
        label = "Command: PVENERGYTABLE | AutoCAD native Monthly, Yearly & 25-Yr Table";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Insert Bill of Materials";
        key = "f_bom_table";
        width = 26;
      }
      : text {
        label = "Command: PVBOM | AutoCAD native Bill of Materials (BOM) Table";
        width = 48;
      }
    }
    : row {
      : button {
        label = "View Simulation Report";
        key = "f_sim_report";
        width = 26;
      }
      : text {
        label = "Command: PVSIMREPORT | Open comprehensive IEC 61724 report in Notepad";
        width = 48;
      }
    }
    : row {
      : button {
        label = "Export Project CSV Data";
        key = "f_export_csv";
        width = 26;
      }
      : text {
        label = "Command: PVEXPORTCSV | Export generation & degradation schedule to CSV";
        width = 48;
      }
    }
  }

  : boxed_row {
    label = "Full Configuration Suite";
    : button {
      label = "Open Multi-Tabbed Designer...";
      key = "f_open_designer";
      width = 26;
    }
    : text {
      label = "Command: SOLARTOOLS | Interactive 6-Tab Designer for complete configuration";
      width = 48;
    }
  }

  : spacer { height = 1; }

  : row {
    : spacer { width = 1; }
    : cancel_button {
      label = "Close";
      is_cancel = true;
      is_default = true;
      key = "cancel";
    }
  }
}

// ==========================================================================
// 2. TAB 1: SITE LOCATION & ROOFTOP STRUCTURE
// ==========================================================================
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
    label = "2. Maintenance Walkway Corridors & Grid Frequency";
    : row {
      : edit_box {
        label = "Walkway Corridor Width (m):";
        key = "walkway_width";
        edit_width = 7;
        value = "0.80";
      }
      : edit_box {
        label = "Horiz Freq (Module Rows):";
        key = "walkway_freq_row";
        edit_width = 5;
        value = "0";
      }
      : edit_box {
        label = "Vert Freq (Module Cols):";
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
    : text {
      label = "Note: Set frequency to '0' to disable periodic walkways, or specify e.g. every 2 rows / every 10 cols.";
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
    label = "2. Rooftop Safety Handrails & Guardrails (EN ISO 14122-3 & OSHA)";
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
    label = "3. Fall Safety Lifeline System (EN 795 & OSHA 1926)";
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
        width = 24;
      }
      : button {
        label = "Draw Cable Tray Path";
        key = "btn_cable_tray";
        width = 22;
      }
      : button {
        label = "Generate IEC SLD";
        key = "btn_sld";
        width = 20;
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
    label = "1. Financial ROI, Tariffs & Commercial Investment Metrics";
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
