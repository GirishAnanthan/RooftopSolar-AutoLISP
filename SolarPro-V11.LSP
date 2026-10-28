;;; -------------------------------------------------------------------------
;;; --- SOLARPRO - VERSION 11 (UPDATED FROM V10) ---
;;;
;;; A comprehensive AutoCAD LISP plugin for automated Solar PV plant design.
;;;
;;; KEY FEATURES:
;;; - Dynamic DCL Graphical User Interface Generation
;;; - Automated Table Placement (Fixed Tilt, Single Axis & Dual Axis Trackers)
;;; - Auto Pitch (GCR-based) and Manual Pitch Overrides
;;; - Piling Coordinate Extraction & Visualization
;;; - Obstruction Handling & Lightning Arrester (LA) Shadow Analysis
;;; - Automated Road Network Generation (Horizontal & Vertical)
;;; - Equipment Placement (Inverters, Transformers, Combiner Boxes)
;;; - Energy Estimation (Integrating NASA POWER & PVGIS APIs)
;;; - Detailed Layout & Energy Summary Reporting (BOM generation)
;;; - UPDATES: Fixed inverter grouping dialog path issue, fixed DC stringing clear function mismatch, added layer existence checks, fixed path handling
;;; -------------------------------------------------------------------------
(vl-load-com)

;; Define the DCL files path
(setq solarpro-dcl-path "D:/SolarPro AcadLISP/Under Development/SolarPro 10062026")

;;; --- DYNAMIC DCL GENERATION ---
;;; All DCL content is embedded in this LISP file. A temp .dcl file is
;;; generated at runtime in TEMPPREFIX, loaded, then cleaned up.
;;; NOTE: The FIXDCL command must be run once to add the roaming Support
;;;       directory to AutoCAD's search path (required for base.dcl).

(defun spd-get-dcl (dcl_name / tmp_dir tmp_path f)
  (setq tmp_dir (getvar "TEMPPREFIX"))
  (if (or (null tmp_dir) (= tmp_dir ""))
    (setq tmp_dir "C:\\Temp\\"))
  (if (/= (substr tmp_dir (strlen tmp_dir) 1) "\\")
    (setq tmp_dir (strcat tmp_dir "\\")))
  (setq tmp_path (strcat tmp_dir dcl_name))
  (if (findfile tmp_path) (vl-file-delete tmp_path))
  (setq f (open tmp_path "w"))
  (if f
    (progn
      (cond
        ((= dcl_name "SolarPro - LA Dialog - Shadow.dcl")
         (write-line "la_dialog_shadow : dialog {" f)
         (write-line "    label = \"SolarPro  LA Placement\";" f)
         (write-line "    : column {" f)
         (write-line "        : boxed_column {" f)
         (write-line "            label = \"LA Parameters\";" f)
         (write-line "            : edit_box {" f)
         (write-line "                label = \"Protection Radius (m)\";" f)
         (write-line "                key = \"la_rad\";" f)
         (write-line "                edit_width = 12;" f)
         (write-line "            }" f)
         (write-line "            : edit_box {" f)
         (write-line "                label = \"Pole Height (m)\";" f)
         (write-line "                key = \"la_height\";" f)
         (write-line "                edit_width = 12;" f)
         (write-line "            }" f)
         (write-line "            : edit_box {" f)
         (write-line "                label = \"Site Latitude (deg)\";" f)
         (write-line "                key = \"la_lat\";" f)
         (write-line "                edit_width = 12;" f)
         (write-line "            }" f)
         (write-line "        }" f)
         (write-line "        : spacer { height = 0.5; }" f)
         (write-line "        : boxed_column {" f)
         (write-line "            label = \"Placement Mode\";" f)
         (write-line "            : radio_column {" f)
         (write-line "                : radio_button { key = \"la_mode_manual\"; label = \"Manual (pick point)\"; }" f)
         (write-line "                : radio_button { key = \"la_mode_auto\"; label = \"Auto (select boundary)\"; }" f)
         (write-line "            }" f)
         (write-line "        }" f)
         (write-line "        : spacer { height = 0.5; }" f)
         (write-line "        : text {" f)
         (write-line "            label = \"Auto mode: places LA shadows in hexagonal grid covering boundary.\";" f)
         (write-line "            alignment = centered;" f)
         (write-line "        }" f)
         (write-line "        : spacer { height = 0.5; }" f)
         (write-line "        ok_cancel;" f)
         (write-line "    }" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - LA Dialog - Protection.dcl")
         (write-line "la_dialog_protection : dialog {" f)
         (write-line "    label = \"SolarPro  LA Protection\";" f)
         (write-line "    : column {" f)
         (write-line "        : boxed_column {" f)
         (write-line "            label = \"Protection Circle Radius\";" f)
         (write-line "            : edit_box {" f)
         (write-line "                label = \"Override Radius (m, 0=use XData)\";" f)
         (write-line "                key = \"la_override_rad\";" f)
         (write-line "                edit_width = 12;" f)
         (write-line "                value = \"0\";" f)
         (write-line "            }" f)
         (write-line "        }" f)
         (write-line "        : spacer { height = 0.5; }" f)
         (write-line "        : boxed_column {" f)
         (write-line "            label = \"Selection Mode\";" f)
         (write-line "            : radio_column {" f)
         (write-line "                : radio_button { key = \"la_sel_manual\"; label = \"Manual (pick objects)\"; }" f)
         (write-line "                : radio_button { key = \"la_sel_all\"; label = \"All LA in Drawing (from XData)\"; }" f)
         (write-line "            }" f)
         (write-line "        }" f)
         (write-line "        : spacer { height = 0.5; }" f)
         (write-line "        : text {" f)
         (write-line "            label = \"All LA mode reads base point & radius from XData on shadow polylines.\";" f)
         (write-line "            alignment = centered;" f)
         (write-line "        }" f)
         (write-line "        : spacer { height = 0.5; }" f)
         (write-line "        ok_cancel;" f)
         (write-line "    }" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - Earthing.dcl")
         (write-line "// SolarPro - Earthing Layout Dialog" f)
         (write-line "" f)
         (write-line "earthing_dialog : dialog {" f)
         (write-line "  label = \"SolarPro - Earthing Settings\";" f)
         (write-line "" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Earthing Strip Size\";" f)
         (write-line "    : edit_box {" f)
         (write-line "      key = \"dc_strip_size\";" f)
         (write-line "      label = \"DC Strip Size:\";" f)
         (write-line "      edit_width = 15;" f)
         (write-line "      value = \"25x3\";" f)
         (write-line "    }" f)
         (write-line "    : edit_box {" f)
         (write-line "      key = \"ac_strip_size\";" f)
         (write-line "      label = \"AC Strip Size:\";" f)
         (write-line "      edit_width = 15;" f)
         (write-line "      value = \"25x3\";" f)
         (write-line "    }" f)
         (write-line "  }" f)
         (write-line "" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Earth Pits Configuration\";" f)
         (write-line "    : edit_box {" f)
         (write-line "      key = \"num_dc_pits\";" f)
         (write-line "      label = \"DC Earth Pits (On Grid Perimeter):\";" f)
         (write-line "      edit_width = 10;" f)
         (write-line "      value = \"4\";" f)
         (write-line "    }" f)
         (write-line "    : edit_box {" f)
         (write-line "      key = \"num_ac_pits\";" f)
         (write-line "      label = \"AC Earth Pits (Per Inverter):\";" f)
         (write-line "      edit_width = 10;" f)
         (write-line "      value = \"3\";" f)
         (write-line "    }" f)
         (write-line "  }" f)
         (write-line "" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Layout Geometry\";" f)
         (write-line "    : radio_row {" f)
         (write-line "      label = \"Module Earth Spacing:\";" f)
         (write-line "      key = \"module_earth_spacing\";" f)
         (write-line "      : radio_button {" f)
         (write-line "        key = \"space_200\";" f)
         (write-line "        label = \"200mm\";" f)
         (write-line "        value = \"1\";" f)
         (write-line "      }" f)
         (write-line "      : radio_button {" f)
         (write-line "        key = \"space_300\";" f)
         (write-line "        label = \"300mm\";" f)
         (write-line "      }" f)
         (write-line "    }" f)
         (write-line "    : edit_box {" f)
         (write-line "      key = \"grid_offset\";" f)
         (write-line "      label = \"Grid Offset (m):\";" f)
         (write-line "      edit_width = 10;" f)
         (write-line "      value = \"1.5\";" f)
         (write-line "    }" f)
         (write-line "  }" f)
         (write-line "" f)
         (write-line "  ok_cancel;" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - LA Dialog.dcl")
          (write-line "la_dialog : dialog {" f)
          (write-line "    label = \"SolarPro  LA Protection Zone\";" f)
          (write-line "    : column {" f)
          (write-line "        : boxed_column {" f)
          (write-line "            label = \"LA Parameters\";" f)
          (write-line "            : edit_box {" f)
          (write-line "                label = \"ESE Protection Radius (m)\";" f)
          (write-line "                key = \"la_rad\";" f)
          (write-line "                edit_width = 12;" f)
          (write-line "            }" f)
          (write-line "            : edit_box {" f)
          (write-line "                label = \"LA Pole Height (m)\";" f)
          (write-line "                key = \"la_height\";" f)
          (write-line "                edit_width = 12;" f)
          (write-line "            }" f)
          (write-line "            : edit_box {" f)
          (write-line "                label = \"Site Latitude (deg)\";" f)
          (write-line "                key = \"la_lat\";" f)
          (write-line "                edit_width = 12;" f)
          (write-line "            }" f)
          (write-line "        }" f)
          (write-line "        : spacer { height = 0.5; }" f)
          (write-line "        : boxed_column {" f)
          (write-line "            label = \"Selection Mode\";" f)
          (write-line "            : radio_column {" f)
          (write-line "                : radio_button { key = \"la_sel_manual\"; label = \"Manual (pick objects)\"; }" f)
          (write-line "                : radio_button { key = \"la_sel_all\"; label = \"All LA in Drawing\"; }" f)
          (write-line "            }" f)
          (write-line "        }" f)
          (write-line "        : spacer { height = 0.5; }" f)
          (write-line "        : boxed_column {" f)
          (write-line "            label = \"Radius Override (for All LA mode)\";" f)
          (write-line "            : edit_box {" f)
          (write-line "                label = \"Override Radius (m, 0=use XData)\";" f)
          (write-line "                key = \"la_override_rad\";" f)
          (write-line "                edit_width = 12;" f)
          (write-line "                value = \"0\";" f)
          (write-line "            }" f)
          (write-line "        }" f)
          (write-line "        : spacer { height = 0.5; }" f)
          (write-line "        : boxed_column {" f)
          (write-line "            label = \"Placement Mode (for SHADOW cmd)\";" f)
          (write-line "            : radio_column {" f)
          (write-line "                : radio_button { key = \"la_mode_manual\"; label = \"Manual (pick point)\"; }" f)
          (write-line "                : radio_button { key = \"la_mode_auto\"; label = \"Auto (select boundary)\"; }" f)
          (write-line "            }" f)
          (write-line "        }" f)
          (write-line "        : spacer { height = 0.5; }" f)
          (write-line "        : text {" f)
          (write-line "            label = \"Note: Gray line hatch (ANSI31) will be applied.\";" f)
          (write-line "            alignment = centered;" f)
          (write-line "        }" f)
          (write-line "        : spacer { height = 0.5; }" f)
          (write-line "        ok_cancel;" f)
          (write-line "    }" f)
          (write-line "}" f)
         )
        ((= dcl_name "SolarPro - Layout Input Dialog.dcl")
         (write-line "solarpro_pg_general : dialog {" f)
         (write-line "  label = \"SolarPro Layout Generator - General\";" f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Navigation\";" f)
         (write-line "    : button { key = \"tab_general\"; label = \"General\"; width = 12; }" f)
         (write-line "    : button { key = \"tab_module\"; label = \"Module & Pitch\"; width = 14; }" f)
         (write-line "    : button { key = \"tab_roads\"; label = \"Roads\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_piling\"; label = \"Piling\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_energy\"; label = \"Energy\"; width = 10; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Capacity\";" f)
         (write-line "    : popup_list { key = \"capacity_mode\"; label = \"Capacity Mode\"; width = 20; }" f)
         (write-line "    : edit_box { key = \"target_mw\"; label = \"Target MWp\"; edit_width = 15; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Location & Boundary\";" f)
         (write-line "    : popup_list { key = \"mount_type\"; label = \"Mounting Structure\"; width = 20; }" f)
         (write-line "    : edit_box { key = \"lat\"; label = \"Latitude\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"lon\"; label = \"Longitude\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"az\"; label = \"Azimuth (0=S)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"set_off\"; label = \"Boundary Set-off (m)\"; edit_width = 15; }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : text { key = \"status\"; value = \"General inputs\"; width = 24; }" f)
         (write-line "    : button { key = \"prev\"; label = \"< Prev\"; width = 10; }" f)
         (write-line "    : button { key = \"next\"; label = \"Next >\"; width = 10; }" f)
         (write-line "    : button { key = \"accept\"; label = \"OK\"; is_default = true; width = 10; }" f)
         (write-line "    : button { key = \"cancel\"; label = \"Cancel\"; is_cancel = true; width = 10; }" f)
         (write-line "  }" f)
         (write-line "}" f)
         (write-line "solarpro_pg_module : dialog {" f)
         (write-line "  label = \"SolarPro Layout Generator - Module & Pitch\";" f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Navigation\";" f)
         (write-line "    : button { key = \"tab_general\"; label = \"General\"; width = 12; }" f)
         (write-line "    : button { key = \"tab_module\"; label = \"Module & Pitch\"; width = 14; }" f)
         (write-line "    : button { key = \"tab_roads\"; label = \"Roads\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_piling\"; label = \"Piling\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_energy\"; label = \"Energy\"; width = 10; }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Module Data\";" f)
         (write-line "      : popup_list { key = \"db_spd_mod_mfr\"; label = \"DB Make\"; width = 28; }" f)
         (write-line "      : popup_list { key = \"db_spd_mod_model\"; label = \"DB Model\"; width = 28; }" f)
         (write-line "      : row {" f)
         (write-line "        : button { key = \"db_spd_use_module\"; label = \"Use Data from PAN File\"; width = 14; }" f)
         (write-line "        : button { key = \"db_spd_new_module\"; label = \"Create New\"; width = 12; }" f)
         (write-line "      }" f)
         (write-line "      : edit_box { key = \"p_w\"; label = \"Width (m)\"; edit_width = 15; }" f)
         (write-line "      : edit_box { key = \"p_h\"; label = \"Height (m)\"; edit_width = 15; }" f)
         (write-line "      : edit_box { key = \"p_watt\"; label = \"Wattage (Wp)\"; edit_width = 15; }" f)
         (write-line "      : popup_list { key = \"p_ori\"; label = \"Orientation\"; width = 20; }" f)
         (write-line "    }" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Pitch & Layout\";" f)
         (write-line "      : edit_box { key = \"mod_in_row\"; label = \"Modules per Row\"; edit_width = 15; }" f)
         (write-line "      : edit_box { key = \"gcr\"; label = \"Ground Coverage Ratio (%)\"; edit_width = 15; }" f)
         (write-line "      : edit_box { key = \"tracker_len\"; label = \"Tracker Max Length (m)\"; edit_width = 15; }" f)
          (write-line "      : edit_box { key = \"motor_gap\"; label = \"Motor Gap Width (m)\"; edit_width = 15; }" f)
          (write-line "      : edit_box { key = \"tracker_gap\"; label = \"Tracker Table Gap (m)\"; edit_width = 15; }" f)
          (write-line "      : edit_box { key = \"mod_in_stack\"; label = \"Modules per Stack\"; edit_width = 15; }" f)
         (write-line "      : edit_box { key = \"tilt\"; label = \"Tilt Angle\"; edit_width = 15; }" f)
         (write-line "      : popup_list { key = \"layout_mode\"; label = \"Layout Mode\"; width = 20; }" f)
         (write-line "      : popup_list { key = \"pitch_mode\"; label = \"Row Pitch Mode\"; width = 20; }" f)
         (write-line "      : edit_box { key = \"manual_pitch\"; label = \"Manual Pitch (m)\"; edit_width = 15; }" f)
         (write-line "    }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Gaps & Secondary\";" f)
         (write-line "    : edit_box { key = \"m_gap_v\"; label = \"Rows Gap (m)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"m_gap_h\"; label = \"Cols Gap (m)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"t_gap_h\"; label = \"Table Gap (m)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"mod_in_row_2\"; label = \"Sec. Mod/Row (0=off)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"mod_in_stack_2\"; label = \"Sec. Mod/Stack (0=off)\"; edit_width = 15; }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : text { key = \"status\"; value = \"Module and pitch inputs\"; width = 24; }" f)
         (write-line "    : button { key = \"prev\"; label = \"< Prev\"; width = 10; }" f)
         (write-line "    : button { key = \"next\"; label = \"Next >\"; width = 10; }" f)
         (write-line "    : button { key = \"accept\"; label = \"OK\"; is_default = true; width = 10; }" f)
         (write-line "    : button { key = \"cancel\"; label = \"Cancel\"; is_cancel = true; width = 10; }" f)
         (write-line "  }" f)
         (write-line "}" f)
         (write-line "solarpro_pg_roads : dialog {" f)
         (write-line "  label = \"SolarPro Layout Generator - Roads\";" f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Navigation\";" f)
         (write-line "    : button { key = \"tab_general\"; label = \"General\"; width = 12; }" f)
         (write-line "    : button { key = \"tab_module\"; label = \"Module & Pitch\"; width = 14; }" f)
         (write-line "    : button { key = \"tab_roads\"; label = \"Roads\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_piling\"; label = \"Piling\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_energy\"; label = \"Energy\"; width = 10; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Road Options\";" f)
         (write-line "    : edit_box { key = \"h_road_w\"; label = \"H. Road Width (m)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"h_road_f\"; label = \"H. Road Freq (rows)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"v_road_w\"; label = \"V. Road Width (m)\"; edit_width = 15; }" f)
         (write-line "    : edit_box { key = \"v_road_f\"; label = \"V. Road Freq (cols)\"; edit_width = 15; }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : text { key = \"status\"; value = \"Road corridor inputs\"; width = 24; }" f)
         (write-line "    : button { key = \"prev\"; label = \"< Prev\"; width = 10; }" f)
         (write-line "    : button { key = \"next\"; label = \"Next >\"; width = 10; }" f)
         (write-line "    : button { key = \"accept\"; label = \"OK\"; is_default = true; width = 10; }" f)
         (write-line "    : button { key = \"cancel\"; label = \"Cancel\"; is_cancel = true; width = 10; }" f)
         (write-line "  }" f)
         (write-line "}" f)
         (write-line "solarpro_pg_piling : dialog {" f)
         (write-line "  label = \"SolarPro Layout Generator - Piling\";" f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Navigation\";" f)
         (write-line "    : button { key = \"tab_general\"; label = \"General\"; width = 12; }" f)
         (write-line "    : button { key = \"tab_module\"; label = \"Module & Pitch\"; width = 14; }" f)
         (write-line "    : button { key = \"tab_roads\"; label = \"Roads\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_piling\"; label = \"Piling\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_energy\"; label = \"Energy\"; width = 10; }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Piling (Primary)\";" f)
         (write-line "      : edit_box { key = \"pile_dist_first\"; label = \"Edge to 1st (mm)\"; edit_width = 10; }" f)
         (write-line "      : edit_box { key = \"pile_dist_btw\"; label = \"Spacing (mm)\"; edit_width = 10; }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"pile_num\"; label = \"No. of Piles\"; edit_width = 6; }" f)
         (write-line "        : button { key = \"btn_calc_pile\"; label = \"Calculate\"; width = 12; }" f)
         (write-line "      }" f)
         (write-line "      : text { key = \"pile_status\"; value = \"\"; alignment = centered; }" f)
         (write-line "      : edit_box { key = \"pile_radius\"; label = \"Radius (mm)\"; edit_width = 10; }" f)
         (write-line "    }" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Piling (Secondary)\";" f)
         (write-line "      : edit_box { key = \"pile_dist_first_2\"; label = \"Edge to 1st (mm)\"; edit_width = 10; }" f)
         (write-line "      : edit_box { key = \"pile_dist_btw_2\"; label = \"Spacing (mm)\"; edit_width = 10; }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"pile_num_2\"; label = \"No. of Piles\"; edit_width = 6; }" f)
         (write-line "        : button { key = \"btn_calc_pile_2\"; label = \"Calculate\"; width = 12; }" f)
         (write-line "      }" f)
         (write-line "    }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Piling Parameter Reference Diagram\";" f)
         (write-line "    : image {" f)
         (write-line "      key = \"piling_img\";" f)
         (write-line "      width = 58;" f)
         (write-line "      height = 6;" f)
         (write-line "      color = 7;" f)
         (write-line "    }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : text { key = \"status\"; value = \"Piling inputs\"; width = 24; }" f)
         (write-line "    : button { key = \"prev\"; label = \"< Prev\"; width = 10; }" f)
         (write-line "    : button { key = \"next\"; label = \"Next >\"; width = 10; }" f)
         (write-line "    : button { key = \"accept\"; label = \"OK\"; is_default = true; width = 10; }" f)
         (write-line "    : button { key = \"cancel\"; label = \"Cancel\"; is_cancel = true; width = 10; }" f)
         (write-line "  }" f)
         (write-line "}" f)
         (write-line "solarpro_pg_energy : dialog {" f)
         (write-line "  label = \"SolarPro Layout Generator - Energy\";" f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Navigation\";" f)
         (write-line "    : button { key = \"tab_general\"; label = \"General\"; width = 12; }" f)
         (write-line "    : button { key = \"tab_module\"; label = \"Module & Pitch\"; width = 14; }" f)
         (write-line "    : button { key = \"tab_roads\"; label = \"Roads\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_piling\"; label = \"Piling\"; width = 10; }" f)
         (write-line "    : button { key = \"tab_energy\"; label = \"Energy\"; width = 10; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Energy Data\";" f)
         (write-line "    : popup_list { key = \"energy_source\"; label = \"Energy Source\"; width = 20; }" f)
         (write-line "    : edit_box { key = \"manual_ghi\"; label = \"Manual GHI\"; edit_width = 15; }" f)
         (write-line "    : text { key = \"energy_hint\"; value = \"Manual GHI is also used for API fallback.\"; }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : text { key = \"status\"; value = \"Energy inputs\"; width = 24; }" f)
         (write-line "    : button { key = \"prev\"; label = \"< Prev\"; width = 10; }" f)
         (write-line "    : button { key = \"next\"; label = \"Next >\"; width = 10; }" f)
         (write-line "    : button { key = \"accept\"; label = \"OK\"; is_default = true; width = 10; }" f)
         (write-line "    : button { key = \"cancel\"; label = \"Cancel\"; is_cancel = true; width = 10; }" f)
         (write-line "  }" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - SLD.dcl")
         (write-line "createsld : dialog {" f)
         (write-line "    label = \"SolarPro - Single Line Diagram Setup\";" f)
         (write-line "    width = 92;" f)
         (write-line "    : column {" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"Array and String Data\";" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Module Watt (Wp)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_mod_watt\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Total Modules\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_total_mod\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"DC Capacity (kWp)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_dc_kwp\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Modules per String\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_mps\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Strings per Inverter\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_spi\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Number of Inverters\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_num_inv\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "      }" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"Inverter Data\";" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Inverter Make\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_inv_make\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Inverter Model\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_inv_model\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Inverter Rating (kW)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_inv_kw\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Inverter AC Voltage (kV)\"; width = 28; }" f)
         (write-line "          : popup_list { key = \"sld_inv_ac_kv\"; width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"MPPT Count\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_mppt\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "      }" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"ACDB Data\";" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"ACDB Incoming\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_acdb_in\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"ACDB Outgoing\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_acdb_out\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"ACDB Rating (A)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_acdb_rating\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "      }" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"Transformer\";" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"Transformer Rating (kVA)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_tf_rating\"; edit_width = 28; }" f)
          (write-line "        }" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"LV Voltage (kV)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_tf_lv\"; edit_width = 28; }" f)
          (write-line "        }" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"HV Voltage (kV)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_tf_hv\"; edit_width = 28; }" f)
          (write-line "        }" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"Impedance (%)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_tf_imp\"; edit_width = 28; }" f)
          (write-line "        }" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"Vector Group\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_tf_vector\"; edit_width = 28; }" f)
          (write-line "        }" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"Winding Type\"; width = 28; }" f)
         (write-line "          : popup_list { key = \"sld_tf_winding\"; width = 28; }" f)
          (write-line "        }" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"Cooling Type\"; width = 28; }" f)
         (write-line "          : popup_list { key = \"sld_tf_cooling\"; width = 28; }" f)
          (write-line "        }" f)
          (write-line "        : row {" f)
         (write-line "          : text { label = \"OLTC\"; width = 28; }" f)
         (write-line "          : popup_list { key = \"sld_tf_oltc\"; width = 28; }" f)
          (write-line "        }" f)
         (write-line "      }" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"HT Panel\";" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"HT Panel Voltage (kV)\"; width = 28; }" f)
         (write-line "          : popup_list { key = \"sld_ht_kv\"; width = 28; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"HT Panel Rating (A)\"; width = 28; }" f)
         (write-line "          : edit_box { key = \"sld_ht_rating\"; edit_width = 28; }" f)
         (write-line "        }" f)
         (write-line "      }" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"Sheet\";" f)
         (write-line "        : row {" f)
         (write-line "          : text { label = \"Sheet Size\"; width = 28; }" f)
         (write-line "          : popup_list { key = \"sld_sheet\"; width = 28; }" f)
         (write-line "        }" f)
         (write-line "      }" f)
         (write-line "      : text { key = \"status\"; value = \"Basic SLD setup. More fields can be added later.\"; width = 72; }" f)
         (write-line "      ok_cancel;" f)
         (write-line "    }" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - Streetlight.dcl")
         (write-line "// SolarPro - Streetlight.dcl" f)
         (write-line "streetlight_dialog : dialog {" f)
         (write-line "    label = \"Street Lighting configuration\";" f)
         (write-line "    : column {" f)
         (write-line "        : boxed_radio_column {" f)
         (write-line "            label = \"Placement Mode\";" f)
         (write-line "            key = \"sl_mode\";" f)
         (write-line "            : radio_button { label = \"Single streetlight\"; key = \"single\"; value = \"1\"; }" f)
         (write-line "            : radio_button { label = \"Multiple streetlights\"; key = \"multiple\"; }" f)
         (write-line "        }" f)
         (write-line "        : row {" f)
         (write-line "            : edit_box {" f)
         (write-line "                label = \"Streetlight Height (m):\";" f)
         (write-line "                key = \"sl_height\";" f)
         (write-line "                edit_width = 10;" f)
         (write-line "            }" f)
         (write-line "            : popup_list {" f)
         (write-line "                label = \"Distance (meters):\";" f)
         (write-line "                key = \"sl_dist\";" f)
         (write-line "                list = \"20\\n30\\n40\\n50\\n60\";" f)
         (write-line "                width = 15;" f)
         (write-line "            }" f)
         (write-line "        }" f)
         (write-line "        : boxed_radio_row {" f)
         (write-line "            label = \"Arm Side\";" f)
         (write-line "            key = \"sl_side\";" f)
         (write-line "            : radio_button { label = \"Left\"; key = \"left\"; value = \"1\"; }" f)
         (write-line "            : radio_button { label = \"Right\"; key = \"right\"; }" f)
         (write-line "        }" f)
         (write-line "    }" f)
         (write-line "    : row {" f)
         (write-line "        : spacer { width = 10; }" f)
         (write-line "        : button { label = \"OK\"; key = \"accept\"; is_default = true; width = 12; }" f)
         (write-line "        : button { label = \"Cancel\"; key = \"cancel\"; is_cancel = true; width = 12; }" f)
         (write-line "    }" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - Equipment Database Dialogs.dcl")
         (write-line "solarpro_new_module_dialog : dialog {" f)
         (write-line "  label = \"SolarPro - New Module Database Entry\";" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Module Details\";" f)
         (write-line "    : edit_box { key = \"nm_manufacturer\"; label = \"Manufacturer\"; edit_width = 28; }" f)
         (write-line "    : edit_box { key = \"nm_model\"; label = \"Model\"; edit_width = 28; }" f)
         (write-line "    : edit_box { key = \"nm_width\"; label = \"Width (m)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_height\"; label = \"Height (m)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_watt\"; label = \"Wattage (Wp)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_voc\"; label = \"Voc (V)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_vmp\"; label = \"Vmp (V)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_isc\"; label = \"Isc (A)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_imp\"; label = \"Imp (A)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_tc_voc\"; label = \"Temp Coeff Voc (%/C)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"nm_tc_vmp\"; label = \"Temp Coeff Vmp (%/C)\"; edit_width = 12; }" f)
         (write-line "  }" f)
         (write-line "  ok_cancel;" f)
         (write-line "}" f)
         (write-line "solarpro_new_inverter_dialog : dialog {" f)
         (write-line "  label = \"SolarPro - New Inverter Database Entry\";" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Inverter Details\";" f)
         (write-line "    : edit_box { key = \"ni_manufacturer\"; label = \"Manufacturer\"; edit_width = 28; }" f)
         (write-line "    : edit_box { key = \"ni_model\"; label = \"Model\"; edit_width = 28; }" f)
         (write-line "    : edit_box { key = \"ni_inv_kw\"; label = \"Capacity (kW)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"ni_vdc_max\"; label = \"Max Voltage (V)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"ni_mppt_count\"; label = \"MPPT Count\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"ni_mppt_vmin\"; label = \"MPPT Vmin (V)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"ni_mppt_vmax\"; label = \"MPPT Vmax (V)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"ni_mppt_imax\"; label = \"Max Current / MPPT (A)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"ni_mppt_inputs\"; label = \"Inputs / MPPT\"; edit_width = 12; }" f)
         (write-line "  }" f)
         (write-line "  ok_cancel;" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - Stringing Dialog.dcl")
         (write-line "// SolarPro  Inverter Grouping Dialog" f)
         (write-line "// 3-condition voltage check matching SLD tool (Cond A / B / C with temp correction)" f)
         (write-line "" f)
         (write-line "autostring_dialog : dialog {" f)
         (write-line "  label = \"SolarPro  Inverter Grouping Setup\";" f)
         (write-line "" f)
         (write-line "  //  Site Overview (Fixed Data) " f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Site Overview (Auto-Detected from Boundary)\";" f)
         (write-line "    : text { key = \"s_total_mods\"; label = \"Total Modules: ---\"; width = 30; }" f)
         (write-line "    : text { key = \"s_site_kw\";    label = \"Total DC Capacity: --- kWp\"; width = 35; }" f)
         (write-line "  }" f)
         (write-line "" f)
         (write-line "  //  Row 1: Module data + Inverter specs " f)
         (write-line "  : row {" f)
         (write-line "" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Module Electrical Data\";" f)
         (write-line "      : popup_list { key = \"db_mod_mfr\"; label = \"DB Make\"; width = 28; }" f)
         (write-line "      : popup_list { key = \"db_mod_model\"; label = \"DB Model\"; width = 28; }" f)
         (write-line "      : row {" f)
         (write-line "        : button { key = \"db_use_module\"; label = \"Use Module DB\"; width = 14; }" f)
         (write-line "        : button { key = \"db_new_module\"; label = \"Create New\"; width = 12; }" f)
         (write-line "      }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"s_voc\";  label = \"Voc  (V)\";    edit_width = 7; }" f)
         (write-line "        : edit_box { key = \"s_vmp\";  label = \"Vmp  (V)\";    edit_width = 7; }" f)
         (write-line "      }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"s_isc\";  label = \"Isc  (A)\";    edit_width = 7; }" f)
         (write-line "        : edit_box { key = \"s_imp\";  label = \"Imp  (A)\";    edit_width = 7; }" f)
         (write-line "      }" f)
         (write-line "      : edit_box { key = \"s_watt\";   label = \"Wattage (Wp)\"; edit_width = 7; }" f)
         (write-line "    }" f)
         (write-line "" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Inverter Specifications\";" f)
         (write-line "      : popup_list { key = \"db_inv_mfr\"; label = \"DB Make\"; width = 28; }" f)
         (write-line "      : popup_list { key = \"db_inv_model\"; label = \"DB Model\"; width = 28; }" f)
         (write-line "      : row {" f)
         (write-line "        : button { key = \"db_use_inverter\"; label = \"Use Inverter DB\"; width = 14; }" f)
         (write-line "        : button { key = \"db_new_inverter\"; label = \"Create New\"; width = 12; }" f)
         (write-line "      }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"s_inv_kw\";    label = \"Capacity (kW)   \";  edit_width = 6; }" f)
         (write-line "        : edit_box { key = \"s_dcac_ratio\"; label = \"DC/AC Ratio     \";  edit_width = 6; }" f)
         (write-line "      }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"s_num_inv\";   label = \"No. Inverters   \";  edit_width = 6; }" f)
         (write-line "        : button { key = \"inv_recommend\"; label = \"Recommend\"; width = 12; }" f)
         (write-line "      }" f)
         (write-line "      : popup_list { key = \"s_inv_place\"; label = \"Inverter Placement\"; width = 28; }" f)
         (write-line "      : popup_list { key = \"s_group_mode\"; label = \"Grouping Mode\"; width = 28; }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"s_vdc_max\";   label = \"Max Voltage (V) \";  edit_width = 6; }" f)
         (write-line "        : edit_box { key = \"s_num_mppt\";  label = \"MPPTs/Inverter  \";  edit_width = 6; }" f)
         (write-line "      }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"s_mppt_vmin\"; label = \"MPPT Vmin (V)   \";  edit_width = 6; }" f)
         (write-line "        : edit_box { key = \"s_mppt_vmax\"; label = \"MPPT Vmax (V)   \";  edit_width = 6; }" f)
         (write-line "      }" f)
         (write-line "      : row {" f)
         (write-line "        : edit_box { key = \"s_mppt_imax\";   label = \"Max Current / MPPT (A) \"; edit_width = 6; }" f)
         (write-line "        : edit_box { key = \"s_mppt_inputs\"; label = \"Inputs / MPPT   \"; edit_width = 6; }" f)
         (write-line "      }" f)
         (write-line "    }" f)
         (write-line "" f)
         (write-line "  } // end row 1" f)
         (write-line "" f)
         (write-line "  //  Row 2: Temperature conditions " f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Temperature Conditions (Site Ambient Range)\";" f)
         (write-line "    : row {" f)
         (write-line "      : edit_box { key = \"s_tc_voc\";    label = \"Temp Coeff Voc (%/C)\"; edit_width = 7; }" f)
         (write-line "      : edit_box { key = \"s_tc_vmp\";    label = \"Temp Coeff Vmp (%/C)\"; edit_width = 7; }" f)
         (write-line "    }" f)
         (write-line "    : row {" f)
         (write-line "      : edit_box { key = \"s_t_min\";     label = \"T_min (Coldest) (C) \"; edit_width = 7; }" f)
         (write-line "      : edit_box { key = \"s_t_max\";     label = \"T_max (Hottest) (C) \"; edit_width = 7; }" f)
         (write-line "    }" f)
         (write-line "    : text { label = \"T_max used for Vmp cell temp calc (T = T_max - STC)\"; }" f)
         (write-line "  }" f)
         (write-line "" f)
         (write-line "  //  Results panel " f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Calculated Results (Click Calculate)\";" f)
         (write-line "" f)
         (write-line "    : row {" f)
         (write-line "      : text { key = \"r_cond_a\"; label = \"Cond A (Voc safety)   : ---\"; width = 42; }" f)
         (write-line "      : text { key = \"r_cond_b\"; label = \"Cond B (MPPT upper)   : ---\"; width = 42; }" f)
         (write-line "    }" f)
         (write-line "    : row {" f)
         (write-line "      : text { key = \"r_cond_c\"; label = \"Cond C (MPPT lower)   : ---\"; width = 42; }" f)
         (write-line "      : text { key = \"r_mps\";    label = \"Modules per String    : ---\"; width = 42; }" f)
         (write-line "    }" f)
         (write-line "" f)
         (write-line "    : row {" f)
         (write-line "      : text { key = \"r_spm\";   label = \"Strings per MPPT     : ---\"; width = 42; }" f)
         (write-line "      : text { key = \"r_spi\";   label = \"Strings per Inverter : ---\"; width = 42; }" f)
         (write-line "    }" f)
         (write-line "    : row {" f)
         (write-line "      : text { key = \"r_tpi\";   label = \"Tables per Inverter  : ---\"; width = 42; }" f)
         (write-line "      : text { key = \"r_ratio\"; label = \"DC / AC Ratio        : ---\"; width = 42; }" f)
         (write-line "    }" f)
         (write-line "    : row {" f)
         (write-line "      : text { key = \"r_total\"; label = \"Total Tables Needed  : ---\"; width = 42; }" f)
         (write-line "      : spacer { width = 1; }" f)
         (write-line "    }" f)
         (write-line "" f)
         (write-line "    : button {" f)
         (write-line "      key = \"calc_btn\"; label = \"Calculate Results\";" f)
         (write-line "      is_default = false; fixed_width = true; width = 20;" f)
         (write-line "      alignment = centered;" f)
         (write-line "    }" f)
         (write-line "  }" f)
         (write-line "" f)
         (write-line "  : text { key = \"status\"; label = \"Fill in values, click Calculate, then OK to start stringing.\"; }" f)
         (write-line "" f)
         (write-line "  ok_cancel;" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - Stringing Method Dialog.dcl")
         (write-line "autostring_method_dialog : dialog {" f)
          (write-line "  label = \"SolarPro - Stringing Method\";" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Stringing Setup\";" f)
         (write-line "    : popup_list { key = \"string_method\"; label = \"Method\"; width = 24; }" f)
         (write-line "    : popup_list { key = \"string_direction\"; label = \"Direction\"; width = 24; }" f)
         (write-line "    : text { key = \"method_hint\"; label = \"Choose the routing style for DC stringing.\"; width = 48; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Preview\";" f)
         (write-line "    : image { key = \"string_method_img\"; width = 74; height = 18; color = 0; }" f)
         (write-line "  }" f)
         (write-line "  : row {" f)
         (write-line "    : text { key = \"status\"; value = \"Set method and direction, then click OK.\"; width = 34; }" f)
         (write-line "    : button { key = \"back\"; label = \"< Back\"; width = 10; }" f)
         (write-line "    : button { key = \"accept\"; label = \"OK\"; is_default = true; width = 10; }" f)
         (write-line "    : button { key = \"cancel\"; label = \"Cancel\"; is_cancel = true; width = 10; }" f)
          (write-line "  }" f)
          (write-line "}" f)
         )
        ((= dcl_name "SolarPro - DC Stringing Dialog.dcl")
         (write-line "dcstringing_dialog : dialog {" f)
         (write-line "  label = \"SolarPro - DC Stringing Setup\";" f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Stringing Inputs\";" f)
         (write-line "    : edit_box { key = \"dc_mps\"; label = \"Modules per String\"; edit_width = 10; }" f)
         (write-line "    : edit_box { key = \"dc_num_inv\"; label = \"No. of Inverters\"; edit_width = 10; }" f)
         (write-line "    : edit_box { key = \"dc_spi\"; label = \"Strings / Inverter\"; edit_width = 10; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_row {" f)
         (write-line "    label = \"Stringing Method\";" f)
         (write-line "    : popup_list { key = \"string_method\"; label = \"Method\"; width = 24; }" f)
         (write-line "    : popup_list { key = \"string_direction\"; label = \"Direction\"; width = 24; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Preview\";" f)
         (write-line "    : image { key = \"string_method_img\"; width = 74; height = 18; color = 0; }" f)
         (write-line "  }" f)
         (write-line "  : text { key = \"status\"; value = \"Enter DC stringing inputs and choose the routing method.\"; width = 60; }" f)
         (write-line "  ok_cancel;" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - DC Cabling All Dialog.dcl")
         (write-line "dccablingall_dialog : dialog {" f)
         (write-line "  label = \"SolarPro - Batch DC Cabling Setup\";" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Cable Parameters (Applied to All Inverters)\";" f)
         (write-line "    : popup_list { key = \"cab_csize\"; label = \"Cable Size (Sq.mm)\"; width = 18; }" f)
         (write-line "    : edit_box { key = \"cab_neg_o\"; label = \"-VE Extra Length Offset (m)\"; edit_width = 12; }" f)
         (write-line "    : edit_box { key = \"cab_updown\"; label = \"Up & Down per Leg (m)\"; edit_width = 12; }" f)
         (write-line "    : popup_list { key = \"cab_trunk_mode\"; label = \"Trunk Position\"; width = 18; }" f)
         (write-line "    : edit_box { key = \"cab_trunk_offset\"; label = \"Trunk Offset Magnitude (m)\"; edit_width = 12; }" f)
         (write-line "  }" f)
         (write-line "  : boxed_column {" f)
         (write-line "    label = \"Notes\";" f)
         (write-line "    : text { key = \"cab_mps_info\"; label = \"Modules/String: auto\"; width = 42; }" f)
         (write-line "    : text { key = \"status\"; label = \"Set values once, then DC cabling will run for all inverters.\"; width = 60; }" f)
         (write-line "  }" f)
         (write-line "  ok_cancel;" f)
         (write-line "}" f)
        )

        ((= dcl_name "SolarPro - PVsyst Export.dcl")
         (write-line "spvc_export_dialog : dialog {" f)
         (write-line "  label = \"SolarPro - PVsyst .pvc Export\";" f)
         (write-line "  : column {" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Terrain Surface\";" f)
         (write-line "      : edit_box { key = \"spvc_surface\"; label = \"Civil 3D Surface Name\"; edit_width = 20; value = \"EG\"; }" f)
         (write-line "    }" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Table Detection\";" f)
         (write-line "      : edit_box { key = \"spvc_layer\"; label = \"Layer Filter (wildcard)\"; edit_width = 20; value = \"*\"; }" f)
         (write-line "    }" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Grid Sampling (optional)\";" f)
         (write-line "      : toggle { key = \"spvc_grid_en\"; label = \"Enable grid sampling\"; }" f)
         (write-line "      : edit_box { key = \"spvc_grid_sp\"; label = \"Grid Spacing (m)\"; edit_width = 10; value = \"5.0\"; }" f)
         (write-line "    }" f)
         (write-line "    : boxed_column {" f)
         (write-line "      label = \"Output\";" f)
         (write-line "      : text { key = \"spvc_out\"; label = \"\"; width = 60; }" f)
         (write-line "    }" f)
         (write-line "    : spacer { height = 0.5; }" f)
         (write-line "    : text { key = \"spvc_status\"; label = \"Ready.\"; width = 60; }" f)
         (write-line "    : spacer { height = 0.5; }" f)
         (write-line "    ok_cancel;" f)
         (write-line "  }" f)
         (write-line "}" f)
        )
        ((= dcl_name "SolarPro - Launcher.dcl")
         (write-line "solarpro_launcher : dialog {" f)
         (write-line "  label = \"SolarPro Command Launcher\";" f)
         (write-line "  : column {" f)
         (write-line "    : text { label = \"Click a tool to run it. The launcher reopens after the command finishes.\"; width = 72; }" f)
         (write-line "    : row {" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"Layout & Core\";" f)
         (write-line "        : button { key = \"cmd_solarpro\"; label = \"SolarPro Layout Dialog\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_generate\"; label = \"Generate Layout (Manual)\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_refresh\"; label = \"Refresh Layout\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_obstruction\"; label = \"Set Obstruction Height\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_yldcompare\"; label = \"Yield/Compare Layout\"; width = 28; }" f)
         (write-line "      }" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"Piling & Shadows\";" f)
         (write-line "        : button { key = \"cmd_piling\"; label = \"Pile Labels\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_clearpiling\"; label = \"Clear Pile Labels\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_shadow\"; label = \"Pole / LA Shadow\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_bshadow\"; label = \"Building Shadow\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_shadowcoords\"; label = \"Shadow Coordinates\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_clearshadowcoords\"; label = \"Clear Shadow Coords\"; width = 28; }" f)
         (write-line "      }" f)
         (write-line "    }" f)
         (write-line "    : row {" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"Stringing & DC\";" f)
         (write-line "        : button { key = \"cmd_invgroup\"; label = \"Inverter Grouping Dialog\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_autostring\"; label = \"Auto Stringing\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_clearstring\"; label = \"Clear Stringing\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_dcstring\"; label = \"DC Stringing\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_cleardcstring\"; label = \"Clear DC Stringing\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_dccabling\"; label = \"DC Cabling\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_dccablingall\"; label = \"DC Cabling All\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_cleardccabling\"; label = \"Clear DC Cabling\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_dccableexport\"; label = \"DC Cable Export\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_debugstrings\"; label = \"Debug Strings\"; width = 28; }" f)
         (write-line "      }" f)
         (write-line "      : boxed_column {" f)
         (write-line "        label = \"AC, Earthing & Trench\";" f)
         (write-line "        : button { key = \"cmd_sld\"; label = \"Create SLD\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_laprotection\"; label = \"LA Protection\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_setacdb\"; label = \"Set ACDB\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_accabling\"; label = \"AC Cabling\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_autoearthing\"; label = \"Auto Earthing\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_clearearthing\"; label = \"Clear Earthing\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_trench\"; label = \"Trench Layout\"; width = 28; }" f)
         (write-line "        : button { key = \"cmd_trenchexport\"; label = \"Trench Export\"; width = 28; }" f)
         (write-line "      }" f)
          (write-line "    }" f)
          (write-line "    : row {" f)
          (write-line "      : boxed_column {" f)
          (write-line "        label = \"3D View\";" f)
          (write-line "        : button { key = \"cmd_view3d\"; label = \"3D Isometric View\"; width = 28; }" f)
          (write-line "        : button { key = \"cmd_view2d\"; label = \"2D Plan View\"; width = 28; }" f)
           (write-line "      }" f)
           (write-line "    }" f)
           (write-line "    : row {" f)
           (write-line "      : boxed_column {" f)
           (write-line "        label = \"Export\";" f)
           (write-line "        : button { key = \"cmd_pvcexport\"; label = \"PVsyst .pvc Export\"; width = 28; }" f)
           (write-line "      }" f)
           (write-line "    }" f)
           (write-line "    : row {" f)
           (write-line "      : spacer { width = 1; }" f)
           (write-line "      : button { key = \"close\"; label = \"Close\"; is_cancel = true; width = 14; }" f)
          (write-line "    }" f)
          (write-line "  }" f)
          (write-line "}" f)
         )
        )
           (close f)
      tmp_path)
    nil))
;;; ------------------------------



(defun c:GenerateLayout (/ *error* old_osmode old_cmdecho p_w p_h p_watt lat lon az set_off 
                           mod_in_row mod_in_stack m_gap_v m_gap_h t_gap_h table_w table_h 
                           table_h_proj table_rise row_gap row_pitch ent bmin bmax min_pt max_pt
                           cur_x cur_y panel_count tilt d2r solar_alt_design results xdata_list
                           table_count report_str poly_area p_ori actual_w actual_h target_mw
                           target_mods modules_per_table layout_mode row_start capacity_mode
                           summary_rows energy_rows table_block_name boundary_handle
                           obstruction_zones obstruction_clearance placement_type unit_w unit_gap total_tables_label
                           mod_in_row_2 mod_in_stack_2 table_w_2 table_h_2 table_h_proj_2
                           modules_per_table_2 table_block_name_2 table_count_2 unit_w_2 step_w
                           placed_row_ys elec_xd_gl ac_kw_gl h_road_width h_road_freq v_road_width v_road_freq energy_source_req energy_profile energy_source_label manual_ghi ghi_used structural_rows extra_vals road_zones row_candidates)
  (vl-load-com)
  (setq old_osmode (getvar "OSMODE")
        old_cmdecho (getvar "CMDECHO"))
  (defun *error* (msg)
    (if (numberp old_osmode) (setvar "OSMODE" old_osmode))
    (if (numberp old_cmdecho) (setvar "CMDECHO" old_cmdecho))
    (if (and msg (/= msg "Function cancelled"))
      (progn
        (princ (strcat "\nError in c:GenerateLayout: " msg))
        (alert (strcat "Error in GenerateLayout:\n" msg))))
    (princ))

  ;; 1. Capacity Input
  (if (and (boundp '*spd-run*) *spd-run*)
      (progn
        (setq capacity_mode *spd-capacity_mode*)
        (setq target_mw (if (equal capacity_mode "Maximum") nil *spd-target_mw*)))
      (progn
        (initget "TargetMWp Maximum")
        (setq capacity_mode (getkword "\nCapacity Mode [TargetMWp/Maximum] <TargetMWp>: "))
        (if (null capacity_mode) (setq capacity_mode "TargetMWp"))
        (if (= capacity_mode "Maximum")
            (setq target_mw nil)
            (progn
              (setq target_mw (getreal "\nEnter Target Capacity in MWp (e.g., 1.5): "))
              (if (or (null target_mw) (<= target_mw 0)) (setq target_mw 1.0))))))
  ;; 2. Module & Site Inputs
  (if (and (boundp '*spd-run*) *spd-run*)
      (setq p_w *spd-p_w*  p_h *spd-p_h*  p_watt *spd-p_watt*
            lat *spd-lat*   lon *spd-lon*   az *spd-az*   set_off *spd-set_off*)
      (setq p_w (getdist "\nModule WIDTH (m) [Short Side]: ")
            p_h (getdist "\nModule HEIGHT (m) [Long Side]: ")
            p_watt (getreal "\nModule Wattage (Wp): ")
            lat (getreal "\nLatitude: ")
            lon (getreal "\nLongitude: ")
            az (getreal "\nAzimuth (0=South): ")
            set_off (getdist "\nBoundary Set-off (m): ")))

  ;; 2B. Roads & Energy Defaults
  (if (and (boundp '*spd-run*) *spd-run*)
      (setq h_road_width (if (boundp '*spd-h_road_width*) *spd-h_road_width* 0.0)
            h_road_freq  (if (boundp '*spd-h_road_freq*)  *spd-h_road_freq*  0)
            v_road_width (if (boundp '*spd-v_road_width*) *spd-v_road_width* 0.0)
            v_road_freq  (if (boundp '*spd-v_road_freq*)  *spd-v_road_freq*  0)
            energy_source_req (if (boundp '*spd-energy_source*) *spd-energy_source* "Latitude Default")
            manual_ghi (if (boundp '*spd-manual_ghi*) *spd-manual_ghi* 0.0))
      (progn
        (setq h_road_width (getdist "\nHorizontal Road Width (m) <0>: "))
        (if (or (null h_road_width) (< h_road_width 0.0)) (setq h_road_width 0.0))
        (setq h_road_freq (getint "\nHorizontal Road Frequency in Rows <0>: "))
        (if (or (null h_road_freq) (< h_road_freq 0)) (setq h_road_freq 0))
        (setq v_road_width (getdist "\nVertical Road Width (m) <0>: "))
        (if (or (null v_road_width) (< v_road_width 0.0)) (setq v_road_width 0.0))
        (setq v_road_freq (getint "\nVertical Road Frequency in Columns <0>: "))
        (if (or (null v_road_freq) (< v_road_freq 0)) (setq v_road_freq 0))
        (initget "LatitudeDefault ManualGHI PVGIS NASA")
        (setq energy_source_req (getkword "\nEnergy Source [LatitudeDefault/ManualGHI/PVGIS/NASA] <LatitudeDefault>: "))
        (setq energy_source_req
              (cond
                ((or (null energy_source_req) (= energy_source_req "LatitudeDefault")) "Latitude Default")
                ((= energy_source_req "ManualGHI") "Manual GHI")
                ((= energy_source_req "PVGIS") "PVGIS API")
                ((= energy_source_req "NASA") "NASA POWER API")
                (T "Latitude Default")))
        (if (/= energy_source_req "Latitude Default")
          (progn
            (setq manual_ghi (getreal "\nManual GHI for direct use / API fallback <0>: "))
            (if (or (null manual_ghi) (<= manual_ghi 0.0)) (setq manual_ghi 0.0)))
          (setq manual_ghi 0.0))))
  (setq energy_profile (ResolveEnergyProfile energy_source_req lat lon manual_ghi nil)
        energy_source_label (car energy_profile)
        ghi_used (cadr energy_profile))

  ;; Defensive cleanup for dialog-fed values. Some DCL paths can leave a tile
  ;; variable as T instead of a numeric value; convert those back to numbers
  ;; before any geometry math starts.
  (setq p_w           (sp-safe-real p_w 1.13)
        p_h           (sp-safe-real p_h 2.25)
        p_watt        (sp-safe-real p_watt 610.0)
        lat           (sp-safe-real lat 23.53)
        lon           (sp-safe-real lon 77.63)
        az            (sp-safe-real az 0.0)
        set_off       (sp-safe-real set_off 1.0)
        h_road_width  (sp-safe-real h_road_width 0.0)
        h_road_freq   (sp-safe-int  h_road_freq 0)
        v_road_width  (sp-safe-real v_road_width 0.0)
        v_road_freq   (sp-safe-int  v_road_freq 0)
        manual_ghi    (sp-safe-real manual_ghi 0.0))

  ;; Calculate target module count
  (if (= capacity_mode "Maximum")
      (setq target_mods 2147483647)
      (setq target_mods (fix (/ (* target_mw 1000000.0) p_watt))))

  ;; 3. Orientation Choice
  (if (and (boundp '*spd-run*) *spd-run*)
      (setq p_ori *spd-p_ori*)
      (progn
        (initget "Portrait Landscape")
        (setq p_ori (getkword "\nOrientation [Portrait/Landscape] <Portrait>: "))
        (if (null p_ori) (setq p_ori "Portrait"))))
  (if (= p_ori "Portrait")
      (setq actual_w p_w actual_h p_h)
      (setq actual_w p_h actual_h p_w))

  ;; 4. Table Configuration
  (if (and (boundp '*spd-run*) *spd-run*)
      (setq mod_in_row *spd-mod_in_row*  mod_in_stack *spd-mod_in_stack*
            m_gap_v *spd-m_gap_v*  m_gap_h *spd-m_gap_h*)
      (setq mod_in_row (getint "\nModules per ROW in Table [0=Continuous]: ")
            mod_in_stack (getint "\nModules per STACK in Table: ")
            m_gap_v (getdist "\nGap between stacked module rows (m): ")
            m_gap_h (getdist "\nGap between stacked module columns (m): ")))
  (if (or (null mod_in_row) (< mod_in_row 0)) (setq mod_in_row 0))
  (if (or (null mod_in_stack) (< mod_in_stack 1)) (setq mod_in_stack 1))
  (if (or (null m_gap_v) (< m_gap_v 0.0)) (setq m_gap_v 0.0))
  (if (or (null m_gap_h) (< m_gap_h 0.0)) (setq m_gap_h 0.0))
  (setq mod_in_row   (sp-safe-int mod_in_row 0)
        mod_in_stack (max 1 (sp-safe-int mod_in_stack 1))
        m_gap_v      (sp-safe-real m_gap_v 0.0)
        m_gap_h      (sp-safe-real m_gap_h 0.0))
  (if (> mod_in_row 0)
      (progn
        (setq t_gap_h (if (and (boundp '*spd-run*) *spd-run*)
                          *spd-t_gap_h*
                          (getdist "\nGap between adjacent TABLES in same row (m): ")))
        (if (or (null t_gap_h) (< t_gap_h 0.0)) (setq t_gap_h 0.0))
        (setq t_gap_h (sp-safe-real t_gap_h 0.0))
        (setq placement_type "Table"
              modules_per_table (* mod_in_row mod_in_stack)
              table_w (+ (* actual_w mod_in_row) (* m_gap_h (- mod_in_row 1)))))
      (setq t_gap_h 0.0
            placement_type "Continuous"
            modules_per_table mod_in_stack
            table_w actual_w))

  ;; 5. Tilt & Pitch Calculations
  (if (and (boundp '*spd-run*) *spd-run*)
      (setq tilt *spd-tilt*)
      (progn
        (setq tilt (getreal (strcat "\nTilt Angle <" (rtos (abs lat) 2 1) ">: ")))
        (if (null tilt) (setq tilt (abs lat)))))
  (setq tilt (sp-safe-real tilt (abs lat)))
  
  (setq is_tracker (if (and (boundp '*spd-s-mount-type*) (or (= *spd-s-mount-type* "1") (= *spd-s-mount-type* "2"))) T nil))
  (setq is_dat (if (and (boundp '*spd-s-mount-type*) (= *spd-s-mount-type* "2")) T nil))
  (if is_tracker
      (progn
        (setq tilt 0.0)
        (setq block_az 0.0)              ; 0 = South in user convention = N-S tracker axis
        (setq *spd-motor-gap-active* (if (boundp '*spd-motor_gap*) *spd-motor_gap* 0.0))
      )
      (progn
        (setq block_az az)
        (setq *spd-motor-gap-active* 0.0)
      )
  )

  (setq d2r (/ pi 180.0))
  (setq block_az_rad (* block_az d2r))
  
  ;; Tracker geometry swap: for trackers, mod_in_row = N-S (along axis), mod_in_stack = E-W
  (if is_tracker
    (progn
      (setq table_h (+ (* actual_h mod_in_row) (* m_gap_v (- mod_in_row 1))))  ; N-S = mod_in_row
      (setq table_w (+ (* actual_w mod_in_stack) (* m_gap_h (- mod_in_stack 1)))) ; E-W = mod_in_stack
    )
    (progn
      (setq table_h (+ (* actual_h mod_in_stack) (* m_gap_v (- mod_in_stack 1))))
      (setq table_w (+ (* actual_w mod_in_row) (* m_gap_h (- mod_in_row 1))))
    )
  )

  ;; Motor gap along tracker axis (N-S) at midway of rows
  (if is_tracker
      (setq table_h (+ table_h *spd-motor-gap-active*))
  )
  
  ;; Use winter-solstice 9:30 AM solar altitude as the design condition for no inter-row shading.
  (setq solar_alt_design (SolarAltitudeAtTime lat -23.45 9.5))
  (setq table_rise (* table_h (sin (* tilt d2r))))
  (setq table_h_proj (* table_h (cos (* tilt d2r))))
  
  (if is_tracker
      (progn
        (setq gcr_ratio (if (and (boundp '*spd-gcr*) (> *spd-gcr* 0.0)) (/ *spd-gcr* 100.0) 0.40))
        ;; For trackers, Pitch can be Auto (GCR) or Manual
        (if (and (boundp '*spd-run*) *spd-run* (boundp '*spd-pitch_mode*) (= *spd-pitch_mode* "Manual") (boundp '*spd-manual_pitch*) (> *spd-manual_pitch* 0.0))
            (setq t_gap_h (- *spd-manual_pitch* table_w))
            (setq t_gap_h (- (/ table_w gcr_ratio) table_w)))
        
        (if is_dat
            ;; Dual Axis Tracker
            (if (and (boundp '*spd-run*) *spd-run* (boundp '*spd-pitch_mode*) (= *spd-pitch_mode* "Manual") (boundp '*spd-manual_pitch*) (> *spd-manual_pitch* 0.0))
                (setq row_pitch *spd-manual_pitch*)
                (setq row_pitch (/ table_h_proj gcr_ratio)))
            ;; Single Axis Tracker (N-S axis)
            (setq row_pitch (+ table_h_proj (if (and (boundp '*spd-tracker_gap*) (>= *spd-tracker_gap* 0.0)) *spd-tracker_gap* 0.5)))
        )
      )
      (progn
        ;; Fixed Tilt
        (if (and (boundp '*spd-run*) *spd-run* (boundp '*spd-pitch_mode*) (= *spd-pitch_mode* "Manual") (boundp '*spd-manual_pitch*) (> *spd-manual_pitch* 0.0))
            (setq row_pitch *spd-manual_pitch*)
            (progn
              (setq row_gap (/ table_rise (tan_lsp (* solar_alt_design d2r))))
              (setq row_pitch (+ table_h_proj row_gap))
            )
        )
      )
  )

  ;; 6. Selection & Area
  (setq ent nil)
  (while (null ent)
    (setq ent (car (entsel "\nSelect Boundary Polyline: ")))
    (if (and ent (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE"))
      (setq ent nil)))
  
  (if ent
    (progn
      (EnsureObstructionLayer)
      (setq poly_area (/ (vla-get-area (vlax-ename->vla-object ent)) 4046.86))
      (setq boundary_handle (cdr (assoc 5 (entget ent))))
      
      ;; Delete existing report entities for this boundary
      (DeleteReportEntities boundary_handle)
      (DeleteReportEntities (strcat boundary_handle "_REFRESH"))
      (DeleteReportEntities (strcat boundary_handle "_RECALCULATE"))
      (DeleteReportEntities (strcat boundary_handle "_YLDCOMPARE"))
      
      ;; Clear existing TABLE_* blocks inside this boundary
      (setq *sp-outer-verts* (DiscretizePolyline ent))
      (if (setq ss (ssget "_X" '((0 . "INSERT"))))
          (progn
            (setq idx 0)
            (while (< idx (sslength ss))
              (setq ename (ssname ss idx)
                    blk_name (cdr (assoc 2 (entget ename))))
              (if (and blk_name (wcmatch (strcase blk_name) "TABLE_*"))
                  (progn
                    (setq ins_pt_blk (cdr (assoc 10 (entget ename))))
                    (if (InsidePoly ins_pt_blk *sp-outer-verts*)
                        (entdel ename))))
              (setq idx (1+ idx)))))
              
      (setq obstruction_clearance 1.0)
      (setq obstruction_zones (CollectObstructionZones ent lat obstruction_clearance))
      ;; Add shadow polygons (SHADOW-POLE / SHADOW-BLDG / SHADOW-SMALL) as extra exclusion zones
      (setq obstruction_zones (append obstruction_zones (CollectShadowExclusionZones)))
      
      (if (not (tblsearch "APPID" "FS_SOLAR_DATA")) (regapp "FS_SOLAR_DATA"))
      (setq xdata_list
            (list -3
                  (list "FS_SOLAR_DATA"
                        (cons 1040 p_w)
                        (cons 1040 p_h)
                        (cons 1040 p_watt)
                        (cons 1040 tilt)
                        (cons 1040 lat)
                        (cons 1040 lon)
                        (cons 1040 az)
                        (cons 1040 (float mod_in_row))
                        (cons 1040 (float mod_in_stack))
                        (cons 1040 (if (= p_ori "Portrait") 1.0 2.0))
                        (cons 1040 m_gap_h)
                        (cons 1040 m_gap_v)
                        (cons 1000 placement_type)
                        (cons 1000 boundary_handle))))
      (entmod (append (entget ent) (list xdata_list)))
      (SaveSolarExtraValues ent h_road_width h_road_freq v_road_width v_road_freq energy_source_req manual_ghi (if ghi_used ghi_used 0.0))
      (EnsureModuleLayer)
      (DefineModuleBlock actual_w actual_h tilt)
      (if (= placement_type "Table")
          (progn
            ;; Initialize pile globals from dialog BEFORE naming/defining blocks
            (setq *spd-pile-np*-m  (if (and (boundp '*spd-s-pile-np*)  *spd-s-pile-np*)  (atoi *spd-s-pile-np*)  0)
                  *spd-pile-df*-m  (if (and (boundp '*spd-s-pile-df*)  *spd-s-pile-df*)  (/ (atof *spd-s-pile-df*)  1000.0) 0.5)
                  *spd-pile-db*-m  (if (and (boundp '*spd-s-pile-db*)  *spd-s-pile-db*)  (/ (atof *spd-s-pile-db*)  1000.0) 2.0)
                  *spd-pile-rad*-m (if (and (boundp '*spd-s-pile-rad*) *spd-s-pile-rad*) (/ (atof *spd-s-pile-rad*) 1000.0) 0.15))
            (setq table_block_name
                  (if is_tracker
                    (BuildTableBlockName mod_in_stack mod_in_row p_ori actual_w actual_h m_gap_h m_gap_v tilt
                                         *spd-pile-np*-m (fix (+ 0.5 (* 1000.0 *spd-pile-db*-m))) *spd-pile-df*-m)
                    (BuildTableBlockName mod_in_row mod_in_stack p_ori actual_w actual_h m_gap_h m_gap_v tilt
                                         *spd-pile-np*-m (fix (+ 0.5 (* 1000.0 *spd-pile-db*-m))) *spd-pile-df*-m)))
            (if is_tracker
              (DefineTableBlock table_block_name mod_in_stack mod_in_row actual_w actual_h m_gap_h m_gap_v tilt T)
              (DefineTableBlock table_block_name mod_in_row mod_in_stack actual_w actual_h m_gap_h m_gap_v tilt nil)))
          (setq table_block_name nil))

       ;; Secondary table setup
       (setq mod_in_row_2   (if (and (boundp '*spd-run*) *spd-run*) *spd-mod_in_row_2*   0)
             mod_in_stack_2 (if (and (boundp '*spd-run*) *spd-run*) *spd-mod_in_stack_2* 0))
       (setq unit_w_2 nil  table_h_proj_2 nil  table_block_name_2 nil
             modules_per_table_2 0  table_count_2 0)
       (if (and (= placement_type "Table") (> mod_in_row_2 0) (> mod_in_stack_2 0))
         (progn
        (if is_tracker
            (progn
              (setq table_w_2      (+ (* actual_w mod_in_stack_2) (* m_gap_h (- mod_in_stack_2 1)))
                    table_h_2      (+ (* actual_h mod_in_row_2) (* m_gap_v (- mod_in_row_2 1)))
                    table_h_proj_2 (* table_h_2 (cos (* tilt d2r)))
                    unit_w_2       table_w_2
                    modules_per_table_2 (* mod_in_row_2 mod_in_stack_2))
            )
            (progn
              (setq table_w_2      (+ (* actual_w mod_in_row_2) (* m_gap_h (- mod_in_row_2 1)))
                    table_h_2      (+ (* actual_h mod_in_stack_2) (* m_gap_v (- mod_in_stack_2 1)))
                    table_h_proj_2 (* table_h_2 (cos (* tilt d2r)))
                    unit_w_2       table_w_2
                    modules_per_table_2 (* mod_in_row_2 mod_in_stack_2))
            )
        )
        (setq unit_w_2 table_w_2)
          ;; If secondary table is taller, recalculate row pitch using taller table
          (if (> table_h_2 table_h)
            (setq row_pitch (+ table_h_proj_2
                               (/ (* table_h_2 (sin (* tilt d2r)))
                                  (tan_lsp (* solar_alt_design d2r))))))
          ;; Recalculate secondary pile settings before naming/defining
          (setq *spd-pile-np*-m  (if (and (boundp '*spd-s-pile-np2*)  *spd-s-pile-np2*)  (atoi *spd-s-pile-np2*)  0)
                *spd-pile-df*-m  (if (and (boundp '*spd-s-pile-df2*)  *spd-s-pile-df2*)  (/ (atof *spd-s-pile-df2*)  1000.0) 0.5)
                *spd-pile-db*-m  (if (and (boundp '*spd-s-pile-db2*)  *spd-s-pile-db2*)  (/ (atof *spd-s-pile-db2*)  1000.0) 2.0))
          (setq table_block_name_2
                (if is_tracker
                  (BuildTableBlockName mod_in_stack_2 mod_in_row_2 p_ori actual_w actual_h m_gap_h m_gap_v tilt
                                       *spd-pile-np*-m (fix (+ 0.5 (* 1000.0 *spd-pile-db*-m))) *spd-pile-df*-m)
                  (BuildTableBlockName mod_in_row_2 mod_in_stack_2 p_ori actual_w actual_h m_gap_h m_gap_v tilt
                                       *spd-pile-np*-m (fix (+ 0.5 (* 1000.0 *spd-pile-db*-m))) *spd-pile-df*-m)))
          (if is_tracker
            (DefineTableBlock table_block_name_2 mod_in_stack_2 mod_in_row_2 actual_w actual_h m_gap_h m_gap_v tilt T)
            (DefineTableBlock table_block_name_2 mod_in_row_2 mod_in_stack_2 actual_w actual_h m_gap_h m_gap_v tilt nil))))

      (setq old_osmode (getvar "OSMODE") old_cmdecho (getvar "CMDECHO"))
      (setvar "OSMODE" 0) (setvar "CMDECHO" 1)
      (setvar "PDMODE" 35) (setvar "PDSIZE" 0.25)
      (vla-getboundingbox (vlax-ename->vla-object ent) 'min_pt 'max_pt)
      (setq bmin (vlax-safearray->list (if (= (type min_pt) 'VARIANT) (vlax-variant-value min_pt) min_pt))
            bmax (vlax-safearray->list (if (= (type max_pt) 'VARIANT) (vlax-variant-value max_pt) max_pt))
            panel_count 0 table_count 0)

      ;; 7. Layout Mode Choice [AT THE END]
      (setq *spd-last-table-w* table_w)
      (prompt "\nFINAL STEP: Choose layout mode.")
      (if (and (boundp '*spd-run*) *spd-run*)
          (setq layout_mode *spd-layout_mode*)
          (progn
            (initget "Aligned Unaligned")
            (setq layout_mode (getkword "\nLayout Mode [Aligned/Unaligned] <Aligned>: "))
            (if (null layout_mode) (setq layout_mode "Aligned"))))

      ;; 8. Capacity-Limited Placement Logic
      (setq *spro-set-off* set_off)   ; expose for TableFitsPoly distance check
      ;; DEBUG: Dump values to find the T
      (princ (strcat "\n[DBG] table_w=" (vl-princ-to-string table_w)
                     " actual_w=" (vl-princ-to-string actual_w)
                     " t_gap_h=" (vl-princ-to-string t_gap_h)
                     " m_gap_h=" (vl-princ-to-string m_gap_h)
                     " unit_w_2=" (vl-princ-to-string unit_w_2)
                     " set_off=" (vl-princ-to-string set_off)
                     " row_pitch=" (vl-princ-to-string row_pitch)
                     " table_h_proj=" (vl-princ-to-string table_h_proj)
                     " placement=" (vl-princ-to-string placement_type)
                     " bmin=" (vl-princ-to-string bmin)))
      (princ (strcat "\n[DBG2] bmax=" (vl-princ-to-string bmax)
                     " h_road_w=" (vl-princ-to-string h_road_width)
                     " h_road_f=" (vl-princ-to-string h_road_freq)
                     " v_road_w=" (vl-princ-to-string v_road_width)
                     " v_road_f=" (vl-princ-to-string v_road_freq)
                     " mod_in_row=" (vl-princ-to-string mod_in_row)
                     " mod_in_stack=" (vl-princ-to-string mod_in_stack)
                     " tilt=" (vl-princ-to-string tilt)
                     " target_mods=" (vl-princ-to-string target_mods)))
      (setq unit_w   (if (= placement_type "Table")
                           (if is_tracker table_w table_w)
                           actual_w)
            unit_gap (if (= placement_type "Table") t_gap_h m_gap_h)
            step_w   (if unit_w_2
                          (min (+ unit_w unit_gap) (+ unit_w_2 unit_gap))
                          (+ unit_w unit_gap))
            placed_row_ys nil)

      ;; PRE-PASS: Find actual_min_x for dynamic vertical roads
      (setq actual_min_x nil
            cur_y (+ (cadr bmin) set_off)
            top_y (- (cadr bmax) set_off))
      (while (<= (+ cur_y table_h_proj) top_y)
        (setq rstart (if (= layout_mode "Unaligned")
                         (FindBestRowStart cur_y (car bmin) (car bmax) set_off unit_w unit_gap table_h_proj ent obstruction_zones)
                         (+ (car bmin) set_off)))
        (if (and rstart (> (CountTablesInRow rstart cur_y (car bmax) set_off unit_w unit_gap table_h_proj ent obstruction_zones is_tracker) 0))
            (if (null actual_min_x)
                (setq actual_min_x rstart)
                (setq actual_min_x (min actual_min_x rstart))))
        (setq cur_y (+ cur_y row_pitch)))
      (setq usable_x (if actual_min_x actual_min_x (+ (car bmin) set_off)))

      ;; Build Vertical Road Zones (horizontal roads removed from CollectRoadZones)
      (setq road_zones (CollectRoadZones bmin bmax set_off row_pitch table_h_proj step_w unit_gap h_road_width h_road_freq v_road_width v_road_freq usable_x))
      (setq obstruction_zones (append obstruction_zones road_zones))

      ;; ------------------------------------------------------------------
      ;; Helper: attempt to place a row of tables at a given cur_y.
      ;; Updates panel_count, table_count, table_count_2, placed_row_ys.
      ;; Returns T if at least one table was placed.
      ;; ------------------------------------------------------------------
      (defun PlaceRowAtY (row_y / rstart rx row_hit rze)
        (setq row_hit nil
              rstart (if (= layout_mode "Unaligned")
                         (FindBestRowStart row_y (car bmin) (car bmax) set_off unit_w unit_gap table_h_proj ent obstruction_zones)
                         (+ (car bmin) set_off))
              rx rstart)
        (while (and (< panel_count target_mods)
                    (<= (+ rx step_w) (- (car bmax) set_off)))
          (cond
            ;; Primary table
             ((and (<= (+ rx unit_w) (- (car bmax) set_off))
                   (if (= placement_type "Table")
                        (TablePlacementOk rx row_y unit_w table_h_proj ent obstruction_zones is_tracker)
                       T))
              (if (= placement_type "Table")
                (progn (InsertTableBlock table_block_name (list rx row_y 0.0) *sp-primary-table-color* block_az_rad)
                       (setq panel_count (+ panel_count modules_per_table) table_count (1+ table_count)))
                (progn (DrawStackColumn3D rx row_y actual_w actual_h mod_in_stack m_gap_v tilt block_az_rad)
                       (setq panel_count (+ panel_count mod_in_stack))))
             (setq row_hit T)
             (setq rx (+ rx unit_w unit_gap)))
            ;; Secondary table  ONLY when primary genuinely can't fit widthwise
            ;; (right-edge constraint or obstruction gap narrower than primary).
            ;; Do NOT use secondary when primary fails a diagonal-boundary polygon
            ;; check in the middle of a clean row  that position should be skipped.
            ((and unit_w_2
                  (> (+ rx unit_w) (- (car bmax) set_off))   ; primary is too wide to fit
                  (<= (+ rx unit_w_2) (- (car bmax) set_off))
                   (TablePlacementOk rx row_y unit_w_2 table_h_proj_2 ent obstruction_zones is_tracker))
             (InsertTableBlock table_block_name_2 (list rx row_y 0.0) *sp-secondary-table-color* block_az_rad)
             (setq panel_count (+ panel_count modules_per_table_2) table_count_2 (1+ table_count_2))
             (setq row_hit T)
             (setq rx (+ rx unit_w_2 unit_gap)))
            ;; Neither fits: if this X falls inside a road corridor, jump to the
            ;; corridor end; otherwise step by the smallest width so we do not
            ;; skip over valid positions near obstructions/diagonal edges.
             (T
              (setq rze (sp-road-zone-end-x rx step_w row_y (if (= placement_type "Table") table_h_proj actual_h) road_zones))
              (if rze
                  (setq rx rze)
                  (setq rx (+ rx step_w))))))
        row_hit)

      ;; ------------------------------------------------------------------
      ;; Helper: try to place cur_y only if it is >= 0.99*row_pitch away
      ;; from every already-placed row.  If a table is drawn the row_y is
      ;; recorded in placed_row_ys so later passes respect it.
      ;; ------------------------------------------------------------------
      (defun TryPlaceRow (row_y / min_d placed)
        (setq min_d (if placed_row_ys
                      (apply 'min (mapcar (function (lambda (py) (abs (- row_y py)))) placed_row_ys))
                      row_pitch))
        (if (>= min_d (* row_pitch 0.99))
          (progn
            (setq placed (PlaceRowAtY row_y))
            (if placed (setq placed_row_ys (cons row_y placed_row_ys)))
            placed)
          nil))

      ;; === PASS 1  BOTTOM-UP (dynamic road-aware) ===
      (setq cur_y (+ (cadr bmin) set_off)
            placed_row_count 0
            extra_gap_y (if (and (numberp h_road_width) (> h_road_width 0.0)) h_road_width 0.0))
      (while (and (< panel_count target_mods) (<= (+ cur_y table_h_proj) top_y))
        (if (TryPlaceRow cur_y)
          (progn
            (setq placed_row_count (1+ placed_row_count))
            (setq cur_y (+ cur_y row_pitch))
            (if (and (> h_road_freq 0) (= (rem placed_row_count h_road_freq) 0))
                (setq cur_y (+ cur_y extra_gap_y))))
          (setq cur_y (+ cur_y row_pitch))))

      ;; === PASS 2  TOP-DOWN (dynamic road-aware fill) ===
      (setq cur_y (- top_y table_h_proj)
            placed_row_count 0)
      (while (and (< panel_count target_mods) (>= cur_y (+ (cadr bmin) set_off)))
        (if (TryPlaceRow cur_y)
          (progn
            (setq placed_row_count (1+ placed_row_count))
            (setq cur_y (- cur_y row_pitch))
            (if (and (> h_road_freq 0) (= (rem placed_row_count h_road_freq) 0))
                (setq cur_y (- cur_y extra_gap_y))))
          (setq cur_y (- cur_y row_pitch))))
      (setq total_tables_label
            (if (= placement_type "Table")
              (if (> table_count_2 0)
                (strcat (itoa table_count) " primary + " (itoa table_count_2) " secondary")
                (itoa table_count))
              "N/A (Continuous)"))
      (setq results (CalculateSolarData panel_count p_watt lat tilt ghi_used))
      (setq elec_xd_gl (cdr (assoc -3 (entget ent '("FS_SOLAR_ELEC")))))
      (setq ac_kw_gl   (if (and elec_xd_gl (= (caar elec_xd_gl) "FS_SOLAR_ELEC"))
                         (cdr (car (cdar elec_xd_gl))) 0.0))
      (setq end_clamps (+ (* table_count mod_in_stack 4) (* table_count_2 mod_in_stack_2 4)))
      (setq mid_clamps (+ (* table_count mod_in_stack (* (- mod_in_row 1) 2)) (* table_count_2 mod_in_stack_2 (* (- mod_in_row_2 1) 2))))
      
      (setq summary_rows
            (list
              (list "Boundary Area"          (strcat (rtos poly_area 2 3) " Acres"))
              (list "Total Modules"          (itoa panel_count))
              (list "Module Wattage"         (strcat (rtos p_watt 2 0) " Wp"))
              (list "System Capacity (DC)"   (strcat (rtos (nth 0 results) 2 3) " MWp"))
              (list "System Capacity (AC)"   (if (> ac_kw_gl 0.0)
                                               (strcat (rtos (/ ac_kw_gl 1000.0) 2 3) " MWac")
                                               "-"))
              (list "Total Tables"           total_tables_label)
              (list "Primary Tables"         (strcat (itoa table_count) " (" (itoa mod_in_row) "x" (itoa mod_in_stack) ")"))
              (list "Secondary Tables"       (if (> table_count_2 0) (strcat (itoa table_count_2) " (" (itoa mod_in_row_2) "x" (itoa mod_in_stack_2) ")") "0"))
              (list "End Clamps"             (itoa end_clamps))
              (list "Mid Clamps"             (itoa mid_clamps))
              (list "Orientation"            p_ori)
              (list "Tilt Angle"             (strcat (rtos tilt 2 1) " deg"))
              (list "Azimuth"                (FormatAzimuthLabel az))
              (list "Row Pitch"              (strcat (rtos row_pitch 2 3) " m"))
              (list "Location"              (strcat (rtos lat 2 3) ", " (rtos lon 2 3)))))
      
      ;; Separate structural data
      (setq structural_rows (append
                              (spd-piling-summary)
                              (spd-road-summary h_road_width h_road_freq v_road_width v_road_freq)
                            ))
      
      (setq energy_rows
            (list
              (list "Energy Source" (if energy_source_label energy_source_label "Latitude Default"))
              (list "GHI Used" (if ghi_used (strcat (rtos ghi_used 2 3) " kWh/m2/day") "Latitude Default"))
              (list "Annual Energy" (strcat (rtos (nth 1 results) 2 0) " kWh"))
              (list "Monthly Energy" (strcat (rtos (/ (nth 1 results) 12.0) 2 0) " kWh"))
              (list "Daily Generation" (strcat (rtos (nth 2 results) 2 2) " kWh"))
              (list "Specific Yield" (strcat (rtos (nth 3 results) 2 3) " kWh/kWp/day"))
              (list "Design Solar Altitude" (strcat (rtos solar_alt_design 2 2) " deg"))))

      (DeleteReportEntities boundary_handle)
      (DrawReportTables ent summary_rows energy_rows structural_rows boundary_handle)
      (princ (strcat "\nLayout Complete. " (itoa panel_count) " modules placed in " (itoa table_count) " tables."))
      
      ;; Automatic Piling Extraction was disabled as requested.
      ;; You can still run it manually using the PILING command.
      
  (command "._REGEN")
  (setvar "OSMODE" old_osmode) (setvar "CMDECHO" old_cmdecho)
  )
  (princ "\nNo area selected."))
  ;; Clear dialog globals after run
  (setq *spd-run* nil)
  (princ)
)

(defun c:Refresh (/ ent bmin min_pt max_pt bmax poly_area data_vals p_w p_h p_watt tilt lat lon az
                    mod_in_row mod_in_stack p_ori m_gap_h m_gap_v table_h table_h_proj table_rise
                    solar_alt_design row_gap row_pitch panel_count table_count results summary_rows
                    energy_rows boundary_handle placement_type total_tables_label ghi_used_saved
                    elec_xd_rf ac_kw_rf extra_vals h_road_width h_road_freq v_road_width v_road_freq energy_source_req energy_profile energy_source_label manual_ghi ghi_used structural_rows)
  (vl-load-com)
  (setq ent (car (entsel "\nSelect Boundary Polyline to refresh report: ")))
  (if (and ent (= (cdr (assoc 0 (entget ent))) "LWPOLYLINE"))
      (progn
        (setq boundary_handle (cdr (assoc 5 (entget ent))))
        (setq data_vals (GetSolarDataValues ent))
        (if (>= (length data_vals) 12)
            (progn
              (setq p_w (nth 0 data_vals)
                    p_h (nth 1 data_vals)
                    p_watt (nth 2 data_vals)
                    tilt (nth 3 data_vals)
                    lat (nth 4 data_vals)
                    lon (nth 5 data_vals)
                    az (nth 6 data_vals)
                    mod_in_row (fix (nth 7 data_vals))
                    mod_in_stack (fix (nth 8 data_vals))
                    p_ori (if (= (fix (nth 9 data_vals)) 1) "Portrait" "Landscape")
                    m_gap_h (nth 10 data_vals)
                    m_gap_v (nth 11 data_vals)
                    placement_type (if (>= (length data_vals) 13) (nth 12 data_vals) (if (> mod_in_row 0) "Table" "Continuous")))
              (setq extra_vals (GetSolarExtraValues ent)
                    h_road_width (if (and extra_vals (nth 0 extra_vals)) (nth 0 extra_vals) 0.0)
                    h_road_freq  (if (and extra_vals (nth 1 extra_vals)) (fix (nth 1 extra_vals)) 0)
                    v_road_width (if (and extra_vals (nth 2 extra_vals)) (nth 2 extra_vals) 0.0)
                    v_road_freq  (if (and extra_vals (nth 3 extra_vals)) (fix (nth 3 extra_vals)) 0)
                    energy_source_req (if (and extra_vals (nth 4 extra_vals)) (nth 4 extra_vals) "Latitude Default")
                    manual_ghi (if (and extra_vals (nth 5 extra_vals)) (nth 5 extra_vals) 0.0)
                    ghi_used_saved (if (and extra_vals (nth 6 extra_vals)) (nth 6 extra_vals) nil)
                    *spd-mount_type* (if (and extra_vals (> (length extra_vals) 7)) (nth 7 extra_vals) "Fixed Tilt")
                    *spd-gcr* (if (and extra_vals (> (length extra_vals) 8)) (nth 8 extra_vals) 40.0)
                    *spd-tracker_len* (if (and extra_vals (> (length extra_vals) 9)) (nth 9 extra_vals) 90.0)
                    *spd-motor_gap* (if (and extra_vals (> (length extra_vals) 10)) (nth 10 extra_vals) 1.5))
              (setq energy_profile (ResolveEnergyProfile energy_source_req lat lon manual_ghi ghi_used_saved)
                    energy_source_label (car energy_profile)
                    ghi_used (cadr energy_profile))
              
              (setq is_tracker (if (or (= *spd-s-mount-type* "1") (= *spd-s-mount-type* "2")) T nil))
              (setq is_dat (if (= *spd-s-mount-type* "2") T nil))
              
              ;; Restore string index for PVGIS API
              (setq *spd-s-mount-type* 
                (cond 
                  ((= *spd-mount_type* "Single Axis Tracker") "1")
                  ((= *spd-mount_type* "Dual Axis Tracker") "2")
                  (T "0")))
                  
               (if is_tracker
                   (progn
                     (setq tilt 0.0)
                     (setq table_h (+ (* actual_h mod_in_row) (* m_gap_v (- mod_in_row 1))))
                     (setq table_w (+ (* actual_w mod_in_stack) (* m_gap_h (- mod_in_stack 1))))
                     (setq table_h (+ table_h *spd-motor_gap*))
                   )
                  (progn
                    (setq table_h (+ (* (if (= p_ori "Portrait") p_h p_w) mod_in_stack)
                                     (* m_gap_v (- mod_in_stack 1))))
                    (setq table_w (+ (* (if (= p_ori "Portrait") p_w p_h) mod_in_row)
                                     (* m_gap_h (- mod_in_row 1))))
                  )
              )
                               
              (setq table_rise (* table_h (sin (* tilt (/ pi 180.0)))))
              (setq table_h_proj (* table_h (cos (* tilt (/ pi 180.0)))))
              (setq solar_alt_design (SolarAltitudeAtTime lat -23.45 9.5))
              
              (if is_tracker
                  (progn
                    (setq tilt 0.0)
                    ;; Trackers axis N-S: azimuth 0 = South in user convention = N-S tracker axis
                    (setq az 0.0)
                    (setq table_h_proj (* table_h (cos (* tilt (/ pi 180.0)))))
                    ;; GCR applies to Y-axis (which is now E-W)
                    (setq gcr_ratio (if (and (boundp '*spd-gcr*) (> *spd-gcr* 0.0)) (/ *spd-gcr* 100.0) 0.40))
                    (setq row_pitch (/ table_h_proj gcr_ratio))
                    ;; Re-calculate azimuth radians for the rest of the generation script
                    (setq az_rad (* az (/ pi 180.0)))
                  )
                  (progn
                    (setq row_gap (/ table_rise (tan_lsp (* solar_alt_design (/ pi 180.0)))))
                    (setq row_pitch (+ table_h_proj row_gap))
                  ))
              (setq poly_area (/ (vla-get-area (vlax-ename->vla-object ent)) 4046.86))
              (if (= placement_type "Continuous")
                  (progn
                    (setq panel_count (CountModuleBlocksInBoundary ent)
                          table_count 0 table_count_2 0
                          total_tables_label "N/A (Continuous)"))
                  (progn
                    (setq actual_panel_count 0 actual_table_count 0 table_count_2 0)
                    (setq mod_in_row_2 (max 1 (/ mod_in_row 2)) mod_in_stack_2 mod_in_stack)
                    (setq *sp-outer-verts* (DiscretizePolyline ent))
                    (setq pri_pattern (strcat "TABLE_V5_" (itoa mod_in_row) "X" (itoa mod_in_stack) "_*"))
                    (setq sec_pattern (strcat "TABLE_V5_" (itoa mod_in_row_2) "X" (itoa mod_in_stack_2) "_*"))
                    (if (setq ss (ssget "_X" '((0 . "INSERT"))))
                        (progn
                          (setq idx 0)
                          (while (< idx (sslength ss))
                            (setq ename (ssname ss idx)
                                  blk_name (strcase (cdr (assoc 2 (entget ename))))
                                  ins_pt_blk (cdr (assoc 10 (entget ename))))
                            (if (InsidePoly ins_pt_blk *sp-outer-verts*)
                                (cond
                                  ((wcmatch blk_name pri_pattern)
                                   (setq actual_table_count (1+ actual_table_count) actual_panel_count (+ actual_panel_count (* mod_in_row mod_in_stack))))
                                  ((wcmatch blk_name sec_pattern)
                                   (setq table_count_2 (1+ table_count_2) actual_panel_count (+ actual_panel_count (* mod_in_row_2 mod_in_stack_2))))
                                  ((wcmatch blk_name "TABLE_*")
                                   (setq actual_table_count (1+ actual_table_count) actual_panel_count (+ actual_panel_count (* mod_in_row mod_in_stack))))
                                ))
                            (setq idx (1+ idx)))))
                    (setq table_count actual_table_count panel_count actual_panel_count)
                    (if (> table_count_2 0)
                      (setq total_tables_label (strcat (itoa table_count) " primary + " (itoa table_count_2) " secondary"))
                      (setq total_tables_label (itoa table_count)))))
              (setq results (CalculateSolarData panel_count p_watt lat tilt ghi_used))
              (setq elec_xd_rf (cdr (assoc -3 (entget ent '("FS_SOLAR_ELEC")))))
              (setq ac_kw_rf   (if (and elec_xd_rf (= (caar elec_xd_rf) "FS_SOLAR_ELEC"))
                                 (cdr (car (cdar elec_xd_rf))) 0.0))
              ;; Calculate clamps for Refresh
              (setq end_clamps (+ (* table_count mod_in_stack 4) (* table_count_2 mod_in_stack_2 4)))
              (setq mid_clamps (+ (* table_count mod_in_stack (* (- mod_in_row 1) 2)) (* table_count_2 mod_in_stack_2 (* (- mod_in_row_2 1) 2))))
              
              (setq summary_rows
                    (list
                      (list "Boundary Area"         (strcat (rtos poly_area 2 3) " Acres"))
                      (list "Total Modules"         (itoa panel_count))
                      (list "Module Wattage"        (strcat (rtos p_watt 2 0) " Wp"))
                      (list "System Capacity (DC)"  (strcat (rtos (nth 0 results) 2 3) " MWp"))
                      (list "System Capacity (AC)"  (if (> ac_kw_rf 0.0)
                                                      (strcat (rtos (/ ac_kw_rf 1000.0) 2 3) " MWac")
                                                      "-"))
                      (list "Total Tables"          total_tables_label)
                      (list "Primary Tables"        (strcat (itoa table_count) " (" (itoa mod_in_row) "x" (itoa mod_in_stack) ")"))
                      (list "Secondary Tables"      (if (> table_count_2 0) (strcat (itoa table_count_2) " (" (itoa mod_in_row_2) "x" (itoa mod_in_stack_2) ")") "0"))
                      (list "End Clamps"            (itoa end_clamps))
                      (list "Mid Clamps"            (itoa mid_clamps))
                      (list "Orientation"           p_ori)
                      (list "Tilt Angle"            (strcat (rtos tilt 2 1) " deg"))
                      (list "Azimuth"               (FormatAzimuthLabel az))
                      (list "Row Pitch"             (strcat (rtos row_pitch 2 3) " m"))
                      (list "Location"             (strcat (rtos lat 2 3) ", " (rtos lon 2 3)))))
              
              ;; Separate structural data for Refresh
              (setq structural_rows (append
                                      (spd-piling-summary)
                                      (spd-road-summary h_road_width h_road_freq v_road_width v_road_freq)
                                    ))
              
              (setq energy_rows
                    (list
                      (list "Energy Source" (if energy_source_label energy_source_label "Latitude Default"))
                      (list "GHI Used" (if ghi_used (strcat (rtos ghi_used 2 3) " kWh/m2/day") "Latitude Default"))
                      (list "Annual Energy" (strcat (rtos (nth 1 results) 2 0) " kWh"))
                      (list "Monthly Energy" (strcat (rtos (/ (nth 1 results) 12.0) 2 0) " kWh"))
                      (list "Daily Generation" (strcat (rtos (nth 2 results) 2 2) " kWh"))
                      (list "Specific Yield" (strcat (rtos (nth 3 results) 2 3) " kWh/kWp/day"))
                      (list "Design Solar Altitude" (strcat (rtos solar_alt_design 2 2) " deg"))))
              (vla-getboundingbox (vlax-ename->vla-object ent) 'min_pt 'max_pt)
              (setq bmin (vlax-safearray->list min_pt) bmax (vlax-safearray->list max_pt))
              (DeleteReportEntities boundary_handle)
              (DrawReportTables ent summary_rows energy_rows structural_rows boundary_handle)
              (princ "\nReport refreshed from current drawing blocks."))
            (princ "\nNo stored solar data found on selected boundary."))))
  (princ))

;; --- 3D TABLE DRAWING SUBROUTINE ---
(defun DrawTable3D (base_x base_y table_block_name)
  (InsertTableBlock table_block_name (list base_x base_y 0.0) *sp-primary-table-color*))

(defun DrawStackColumn3D (base_x base_y mod_w mod_h stack_count gap_v tilt rot_ang / r d2r_val m_top m_base z_top z_base)
  (setq d2r_val (/ pi 180.0)
        r 0)
  (while (< r stack_count)
    (setq m_top  (- (* stack_count mod_h (cos (* tilt d2r_val)))
                    (* r (+ mod_h gap_v) (cos (* tilt d2r_val))))
          m_base (- m_top (* mod_h (cos (* tilt d2r_val))))
          z_top  (* (- stack_count r) mod_h (sin (* tilt d2r_val)))
          z_base (- z_top (* mod_h (sin (* tilt d2r_val))))
    )
    (InsertModuleBlock (list base_x (+ base_y m_base) z_base) *sp-primary-table-color* rot_ang)
    (setq r (1+ r))))

(defun sp-rgb-int (r g b)
  (+ (* 65536 r) (* 256 g) b))

(setq *sp-primary-table-color*   (sp-rgb-int 39 188 187))
(setq *sp-secondary-table-color* (sp-rgb-int 237 31 36))

(defun EnsureModuleLayer (/ layer_def layer_ent flags col new_flags new_col)
  (if (tblsearch "LAYER" "module")
      (progn
        (setq layer_ent (tblobjname "LAYER" "module"))
        (if layer_ent
            (progn
              (setq layer_def (entget layer_ent)
                    flags (cdr (assoc 70 layer_def))
                    col (cdr (assoc 62 layer_def))
                    new_flags (logand flags (~ 1)) ; Clear freeze bit
                    new_col 255) ; Force color to 255 (which is also positive -> ON)
              (setq layer_def (subst (cons 70 new_flags) (assoc 70 layer_def) layer_def))
              (setq layer_def (subst (cons 62 new_col) (assoc 62 layer_def) layer_def))
              (entmod layer_def))))
      (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord")
                     '(2 . "module") '(70 . 0) '(62 . 255) '(6 . "Continuous")))))

(defun EnsureObstructionLayer (/ layer_def layer_ent)
  (if (tblsearch "LAYER" "obstruction")
      (progn
        (setq layer_ent (tblobjname "LAYER" "obstruction"))
        (if layer_ent
            (progn
              (setq layer_def (entget layer_ent))
              (if (assoc 420 layer_def)
                  (setq layer_def (subst (cons 420 16753920) (assoc 420 layer_def) layer_def))
                  (setq layer_def (append layer_def (list (cons 420 16753920)))))
              (if (assoc 62 layer_def)
                  (setq layer_def (subst (cons 62 30) (assoc 62 layer_def) layer_def))
                  (setq layer_def (append layer_def (list (cons 62 30)))))
              (entmod layer_def))))
      (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord")
                     '(2 . "obstruction") '(70 . 0) '(62 . 30) '(420 . 16753920) '(6 . "Continuous")))))

(defun EnsureObstructionApp ()
  (if (not (tblsearch "APPID" "FS_OBSTRUCTION_DATA"))
      (regapp "FS_OBSTRUCTION_DATA")))

(defun c:ObstructionHeight (/ ss idx ename height edata xdata)
  (vl-load-com)
  (EnsureObstructionLayer)
  (EnsureObstructionApp)
  (princ "\nSelect obstruction objects to assign shadow height: ")
  (setq ss (ssget '((8 . "obstruction"))))
  (if ss
      (progn
        (setq height (getreal "\nEnter obstruction height in meters: "))
        (if (and height (> height 0.0))
            (progn
              (setq idx 0)
              (while (< idx (sslength ss))
                (setq ename (ssname ss idx)
                      edata (entget ename '("FS_OBSTRUCTION_DATA"))
                      xdata (cdr (assoc -3 edata)))
                (if (and xdata (= (car xdata) "FS_OBSTRUCTION_DATA"))
                    (setq edata (vl-remove (assoc -3 edata) edata)))
                (entmod (append edata (list (list -3 (list "FS_OBSTRUCTION_DATA" (cons 1040 height))))))
                (setq idx (1+ idx)))
              (princ (strcat "\nAssigned obstruction height: " (rtos height 2 2) " m.")))
            (princ "\nNo valid height entered.")))
      (princ "\nNo obstruction objects selected."))
  (princ))

(defun DefineModuleBlock (w h tilt / d2r h_proj h_rise)
  (setq d2r (/ pi 180.0))
  (setq h_proj (* h (cos (* tilt d2r))))
  (setq h_rise (* h (sin (* tilt d2r))))
  (entmake (list '(0 . "BLOCK") '(100 . "AcDbEntity") '(8 . "0")
                 '(100 . "AcDbBlockBegin") '(2 . "module") '(70 . 0)
                 (cons 10 (list 0.0 0.0 0.0)) '(3 . "module") '(1 . "")))
  (entmake (list '(0 . "POLYLINE") '(8 . "0") '(62 . 0) '(66 . 1) '(70 . 9)))
  (entmake (list '(0 . "VERTEX") '(8 . "0") '(62 . 0) '(70 . 32) (cons 10 (list 0.0 0.0 0.0))))
  (entmake (list '(0 . "VERTEX") '(8 . "0") '(62 . 0) '(70 . 32) (cons 10 (list w 0.0 0.0))))
  (entmake (list '(0 . "VERTEX") '(8 . "0") '(62 . 0) '(70 . 32) (cons 10 (list w h_proj h_rise))))
  (entmake (list '(0 . "VERTEX") '(8 . "0") '(62 . 0) '(70 . 32) (cons 10 (list 0.0 h_proj h_rise))))
  (entmake (list '(0 . "SEQEND") '(8 . "0") '(62 . 0)))
  (entmake (list '(0 . "ENDBLK") '(100 . "AcDbEntity") '(8 . "0") '(100 . "AcDbBlockEnd"))))

(defun InsertModuleBlock (ins_pt true_color rot_ang / r)
  (setq r (if rot_ang rot_ang 0.0))
  (entmake (append (list '(0 . "INSERT") '(100 . "AcDbEntity") '(8 . "module")
                  '(100 . "AcDbBlockReference") '(2 . "module")
                  (cons 10 ins_pt) '(41 . 1.0) '(42 . 1.0) '(43 . 1.0)
                  (cons 50 (sp-safe-real r 0.0)))
                  (if true_color (list (cons 420 true_color)) nil))))

(defun BuildTableBlockName (cols rows ori w h gap_h gap_v tilt p_num p_db p_df)
  (strcat "table_v5_" (itoa cols) "x" (itoa rows)
          "_" (if (= ori "Portrait") "P" "L")
          "_w" (itoa (fix (+ 0.5 (* w 1000.0))))
          "_h" (itoa (fix (+ 0.5 (* h 1000.0))))
          "_gh" (itoa (fix (+ 0.5 (* gap_h 1000.0))))
          "_gv" (itoa (fix (+ 0.5 (* gap_v 1000.0))))
          "_t" (itoa (fix (+ 0.5 (* tilt 10.0))))
          "_pn" (itoa p_num)
          "_ps" (itoa p_db)
          "_pf" (itoa (fix (+ 0.5 (* p_df 1000.0))))))

(defun DefineTableBlock (block_name cols rows w h gap_h gap_v tilt is_tracker / r c m_x m_top m_base d2r_val z_top z_base pl_rad pl_ext_h pl_ext_v pl_k pl_x pl_c_tilt pl_highest pl_lowest pl_y table_w_local pl_total_span pl_start_x pl_start_y pl_y_curr pl_x_curr pl_z)
  (if (not (tblsearch "BLOCK" block_name))
      (progn
        (setq d2r_val (/ pi 180.0))
        (entmake (list '(0 . "BLOCK") '(100 . "AcDbEntity") '(8 . "0")
                       '(100 . "AcDbBlockBegin") (cons 2 block_name) '(70 . 0)
                       (cons 10 (list 0.0 0.0 0.0)) (cons 3 block_name) '(1 . "")))
        (setq r 0)
        (while (< r rows)
          (setq c 0)
          (while (< c cols)
            (setq m_x (* c (+ w gap_h)))
            (setq m_top (- (* rows h (cos (* tilt d2r_val))) (* r (+ h gap_v) (cos (* tilt d2r_val)))))
            (setq m_base (- m_top (* h (cos (* tilt d2r_val)))))
            (if (and (boundp '*spd-motor-gap-active*) (> *spd-motor-gap-active* 0.0) (>= r (/ rows 2.0)))
                (progn
                  (setq m_top (- m_top *spd-motor-gap-active*))
                  (setq m_base (- m_base *spd-motor-gap-active*))))
            (setq z_top (* (- rows r) h (sin (* tilt d2r_val))))
            (setq z_base (- z_top (* h (sin (* tilt d2r_val)))))
            (entmake (list '(0 . "INSERT") '(100 . "AcDbEntity") '(8 . "0") '(62 . 0)
                           '(100 . "AcDbBlockReference") '(2 . "module")
                            (cons 10 (list m_x m_base z_base))
                            '(41 . 1.0) '(42 . 1.0) '(43 . 1.0) '(50 . 0.0)))
            (setq c (1+ c)))
          (setq r (1+ r)))
        ;; Pile markers  drawn inside block so they move with every table
        (if (and (boundp '*spd-pile-np*-m) (> *spd-pile-np*-m 0))
          (progn
            (setq pl_rad   *spd-pile-rad*-m
                  pl_c_tilt (cos (* tilt d2r_val))
                  pl_s_tilt (sin (* tilt d2r_val))
                  pl_highest (* rows h pl_c_tilt)
                  pl_lowest  (* -1.0 (if (> rows 1) (- rows 1) 0) gap_v pl_c_tilt)
                  pl_y     (/ (+ pl_highest pl_lowest) 2.0)
                  ;; Draw piles slightly above the highest point of the tilted table to ensure visibility
                  pl_z     (+ (* rows h pl_s_tilt) 1.0)
                  ;; Calculate Centering Offset
                  table_w_local (+ (* w cols) (* gap_h (- cols 1)))
                  pl_total_span (* (1- *spd-pile-np*-m) *spd-pile-db*-m)
                  pl_k     0)
            (if (not (tblsearch "LAYER" "PILING"))
              (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord")
                             '(100 . "AcDbLayerTableRecord")
                             '(2 . "PILING") '(70 . 0) '(62 . 1) '(6 . "Continuous"))))
            (command "._LAYER" "_Thaw" "PILING" "_On" "PILING" "_Set" "0" "")
            
            (if is_tracker
              (progn
                (setq table_h_local (- pl_highest pl_lowest))
                (if (> pl_total_span table_h_local)
                    (setq *spd-pile-np*-m (max 2 (1+ (fix (/ table_h_local *spd-pile-db*-m))))
                          pl_total_span (* (1- *spd-pile-np*-m) *spd-pile-db*-m)))
                ;; For trackers, piles are distributed along the Y-axis (torque tube)
                (setq pl_start_y (- pl_y (/ pl_total_span 2.0))
                      pl_x       (/ table_w_local 2.0))
                (repeat *spd-pile-np*-m
                  (setq pl_y_curr (+ pl_start_y (* pl_k *spd-pile-db*-m)))
                  (entmake (list '(0 . "POINT") '(100 . "AcDbEntity")
                                 '(8 . "PILING") '(62 . 1)
                                 '(100 . "AcDbPoint")
                                 (cons 10 (list pl_x pl_y_curr pl_z))))
                  (setq pl_k (1+ pl_k))
                )
              )
              (progn
                ;; For fixed tilt, piles are distributed along the X-axis
                (if (> pl_total_span table_w_local)
                    (setq *spd-pile-np*-m (max 2 (1+ (fix (/ table_w_local *spd-pile-db*-m))))
                          pl_total_span (* (1- *spd-pile-np*-m) *spd-pile-db*-m)))
                (setq pl_start_x (/ (- table_w_local pl_total_span) 2.0))
                (repeat *spd-pile-np*-m
                  (setq pl_x_curr (+ pl_start_x (* pl_k *spd-pile-db*-m)))
                  (entmake (list '(0 . "POINT") '(100 . "AcDbEntity")
                                 '(8 . "PILING") '(62 . 1)
                                 '(100 . "AcDbPoint")
                                 (cons 10 (list pl_x_curr pl_y pl_z))))
                  (setq pl_k (1+ pl_k))
                )
              )
            )))
        (entmake (list '(0 . "ENDBLK") '(100 . "AcDbEntity") '(8 . "0") '(100 . "AcDbBlockEnd"))))))

(defun InsertTableBlock (block_name ins_pt true_color rot_ang / r)
  (setq r (if rot_ang rot_ang 0.0))
  (entmake (append (list '(0 . "INSERT") '(100 . "AcDbEntity") '(8 . "0")
                  '(100 . "AcDbBlockReference") (cons 2 block_name)
                  (cons 10 ins_pt) '(41 . 1.0) '(42 . 1.0) '(43 . 1.0)
                  (cons 50 (sp-safe-real r 0.0)))
                  (if true_color (list (cons 420 true_color)) nil))))

(defun DefineStreetlightBlock (pole_h lat / block_name noon-res noon-alt noon-az noon-calc noon-tip noon-len tips pt-list)
  ;; Block name includes height suffix for uniqueness
  (setq block_name (strcat "solarpro_sl_" (rtos pole_h 2 0) "m"))
  
  (if (not (tblsearch "BLOCK" block_name))
    (progn
      (setq noon-res (solar-position lat 12.0 -23.45)
            noon-alt (car noon-res)
            noon-az (cdr noon-res)
            noon-calc (calc-shadow-tip (list 0 0 0) pole_h noon-alt noon-az)
            noon-tip (car noon-calc))
            
      ;; Full fan tips: Winter Solstice (-23.45 dec), 9AM (9.0) to 3:30PM (15.5)
      (setq tips (collect-tips (list 0 0 0) pole_h lat -23.45 9.0 15.5 0.25)) ;; 15-min intervals

      ;; Block Header
      (entmake (list '(0 . "BLOCK") (cons 2 block_name) '(70 . 0) (cons 10 (list 0.0 0.0 0.0))))
                     
      ;; Pole (Center Circle)
      (entmake (list '(0 . "CIRCLE") (cons 8 "0") (cons 62 3) (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.15)))
      
      ;; Light Arm (Standard 1.5m)
      (entmake (list '(0 . "LINE") (cons 8 "0") (cons 62 3) (cons 10 (list 0.0 0.0 0.0)) (cons 11 (list 1.5 0.0 0.0))))

      ;; Shadow Fan (Radial Lines to tips)
      (foreach tip-pr tips
        (entmake (list '(0 . "LINE") (cons 8 "0") (cons 62 3) (cons 10 (list 0.0 0.0 0.0)) (cons 11 (car tip-pr))))
      )
      
      ;; Shadow Boundary (Fan Edge)
      (if (> (length tips) 1)
        (progn
          (setq pt-list (mapcar 'car tips))
          (setq i 0)
          (while (< i (1- (length pt-list)))
            (entmake (list '(0 . "LINE") (cons 8 "0") (cons 62 3) (cons 10 (nth i pt-list)) (cons 11 (nth (1+ i) pt-list))))
            (setq i (1+ i))
          )
        )
      )

      ;; Noon Shadow Line (Dashed)
      (entmake (list '(0 . "LINE") (cons 8 "0") (cons 62 3) (cons 6 "Dashed") (cons 10 (list 0.0 0.0 0.0)) (cons 11 noon-tip)))
      
      ;; Label "Pole X.Xm"
      (entmake (list '(0 . "TEXT") (cons 8 "0") (cons 62 3) (cons 10 (list 0.2 -0.5 0)) (cons 40 0.25) (cons 1 (strcat "Pole " (rtos pole_h 2 1) "m"))))
                     
      (entmake (list '(0 . "ENDBLK"))))
  )
  block_name)

(defun sp-dtr (a) (* pi (/ a 180.0)))
(defun sp-rtd (a) (/ (* a 180.0) pi))
(defun sp-asin (x)
  (if (>= (abs x) 1.0)
      (if (> x 0.0) (/ pi 2.0) (/ pi -2.0))
      (atan x (sqrt (- 1.0 (* x x))))))
(defun sp-acos (x)
  (if (>= x 1.0) 0.0
      (if (<= x -1.0) pi
          (atan (sqrt (- 1.0 (* x x))) x))))
(defun SolarPosition (lat hour dec / lat-r dec-r ha-r alt-r az-num az-den az-r az-d)
  (setq lat-r (sp-dtr lat)
        dec-r (sp-dtr dec)
        ha-r  (sp-dtr (* (- hour 12.0) 15.0)))
  (setq alt-r (sp-asin (+ (* (sin lat-r) (sin dec-r))
                          (* (cos lat-r) (cos dec-r) (cos ha-r)))))
  (setq az-num (- (sin dec-r) (* (sin alt-r) (sin lat-r)))
        az-den (* (cos alt-r) (cos lat-r)))
  (if (> (abs az-den) 1e-10)
      (progn
        (setq az-r (sp-acos (/ az-num az-den))
              az-d (sp-rtd az-r))
        (if (> hour 12.0) (setq az-d (- 360.0 az-d))))
      (setq az-d 180.0))
  (list (sp-rtd alt-r) az-d))
(defun SolarAltitudeAtTime (lat dec hour / sunpos)
  (setq sunpos (SolarPosition lat hour dec))
  (max 0.5 (car sunpos)))
(defun ShadowVector (height alt-d az-d / shadow-len shad-az)
  (setq shadow-len (/ height (tan_lsp (sp-dtr alt-d)))
        shad-az    (sp-dtr (+ (- 90.0 az-d) 180.0)))
  (list (* shadow-len (cos shad-az))
        (* shadow-len (sin shad-az))
        shadow-len))
(defun GetObstructionHeight (ename / xdata appdata)
  (setq xdata (cdr (assoc -3 (entget ename '("FS_OBSTRUCTION_DATA")))))
  (if (and xdata (= (caar xdata) "FS_OBSTRUCTION_DATA"))
      (progn
        (setq appdata (cdar xdata))
        (cdr (assoc 1040 appdata)))
      0.0))
(defun GetPolygonBBox (pts / xs ys)
  (setq xs (mapcar 'car pts)
        ys (mapcar 'cadr pts))
  (list (apply 'min xs) (apply 'min ys) (apply 'max xs) (apply 'max ys)))
(defun ExpandBBox (box clearance)
  (list (- (nth 0 box) clearance)
        (- (nth 1 box) clearance)
        (+ (nth 2 box) clearance)
        (+ (nth 3 box) clearance)))
(defun ShiftPointXY (pt dx dy)
  (list (+ (car pt) dx) (+ (cadr pt) dy) 0.0))
(defun EntityBBoxPolygon (ename / min_pt max_pt bmin bmax)
  (vla-getboundingbox (vlax-ename->vla-object ename) 'min_pt 'max_pt)
  (setq bmin (vlax-safearray->list (if (= (type min_pt) 'VARIANT) (vlax-variant-value min_pt) min_pt))
        bmax (vlax-safearray->list (if (= (type max_pt) 'VARIANT) (vlax-variant-value max_pt) max_pt)))
  (list (list (car bmin) (cadr bmin) 0.0)
        (list (car bmax) (cadr bmin) 0.0)
        (list (car bmax) (cadr bmax) 0.0)
        (list (car bmin) (cadr bmax) 0.0)))
(defun GetEntityFootprintPoints (ename / pts)
  (setq pts (get-poly-approx-vertices ename))
  (if (and pts (> (length pts) 2))
      pts
      (EntityBBoxPolygon ename)))
(defun BuildShadowZonePolygon (foot_pts dx dy)
  (convex-hull (append foot_pts (mapcar '(lambda (p) (ShiftPointXY p dx dy)) foot_pts))))
(defun CollectSeasonShadowZones (foot_pts lat height clearance dec start_hr end_hr step_hr / zones hour sun-pos alt-d az-d shv zone box)
  (setq zones nil
        hour start_hr)
  (while (<= hour end_hr)
    (setq sun-pos (SolarPosition lat hour dec)
          alt-d (car sun-pos)
          az-d  (cadr sun-pos))
    (if (> alt-d 0.5)
        (progn
          (setq shv (ShadowVector height alt-d az-d)
                zone (BuildShadowZonePolygon foot_pts (car shv) (cadr shv))
                box  (ExpandBBox (GetPolygonBBox zone) clearance))
          (setq zones (cons (list box zone clearance) zones))))
    (setq hour (+ hour step_hr)))
  zones)
(defun CollectObstructionZonesByLayer (boundary_ent lat clearance / ss idx ename foot_pts zones base_box height)
  (setq zones nil)
  (if (setq ss (ssget "_X" '((8 . "obstruction"))))
      (progn
        (setq idx 0)
        (while (< idx (sslength ss))
          (setq ename (ssname ss idx))
          (if (/= ename boundary_ent)
              (progn
                (setq foot_pts (GetEntityFootprintPoints ename))
                (if (and foot_pts (> (length foot_pts) 2))
                    (progn
                      (setq base_box (ExpandBBox (GetPolygonBBox foot_pts) clearance))
                      (setq zones (cons (list base_box foot_pts clearance) zones))
                      (setq height (GetObstructionHeight ename))
                      (if (> height 0.0)
                          (setq zones
                                (append
                                  (CollectSeasonShadowZones foot_pts lat height clearance -23.45 9.0 15.5 0.5)
                                  (CollectSeasonShadowZones foot_pts lat height clearance 23.45 8.5 17.5 0.5)
                                  zones)))))))
          (setq idx (1+ idx)))))
  zones)

(defun CollectInnerPolylinesAsObstructions (boundary_ent clearance / ss idx ename foot_pts zones base_box all_inside pt boundary_verts bnd_box lay)
  (setq zones nil)
  (setq boundary_verts (DiscretizePolyline boundary_ent))
  (setq bnd_box (GetPolygonBBox boundary_verts))
  (if (setq ss (ssget "_X" '((0 . "LWPOLYLINE"))))
      (progn
        (setq idx 0)
        (while (< idx (sslength ss))
          (setq ename (ssname ss idx))
          (setq lay (strcase (cdr (assoc 8 (entget ename)))))
          (if (and (/= ename boundary_ent) 
                   ;; closed polyline check: group code 70 bit 1 is closed
                   (= (logand (cdr (assoc 70 (entget ename))) 1) 1)
                   ;; ignore internal generated layers
                   (not (or (wcmatch lay "SHADOW*")
                            (wcmatch lay "OBSTRUCTION")
                            (wcmatch lay "MODULE*")
                            (wcmatch lay "STRINGING")
                            (wcmatch lay "ACDB")
                            (wcmatch lay "PILING")
                            (wcmatch lay "TRENCH*")
                            (wcmatch lay "REPORT*")
                            (wcmatch lay "LA_PROTECTION")
                            (wcmatch lay "STREET_LIGHTING"))))
              (progn
                (setq foot_pts (GetEntityFootprintPoints ename))
                (if (and foot_pts (> (length foot_pts) 2))
                    (progn
                      ;; Fast bbox check first: if polyline is not within boundary bbox, skip
                      (setq base_box (GetPolygonBBox foot_pts))
                      (if (not (or (< (nth 2 base_box) (nth 0 bnd_box))
                                   (> (nth 0 base_box) (nth 2 bnd_box))
                                   (< (nth 3 base_box) (nth 1 bnd_box))
                                   (> (nth 1 base_box) (nth 3 bnd_box))))
                          (progn
                            ;; Check if ALL vertices are inside the boundary
                            (setq all_inside T)
                            (foreach pt foot_pts
                              (if (not (InsidePoly pt boundary_verts))
                                  (setq all_inside nil)))
                            (if all_inside
                                (progn
                                  (setq base_box (ExpandBBox base_box clearance))
                                  (setq zones (cons (list base_box foot_pts clearance) zones))))))))))
          (setq idx (1+ idx)))))
  zones)

(defun CollectObstructionZones (boundary_ent lat clearance / zones)
  (setq zones (CollectObstructionZonesByLayer boundary_ent lat clearance))
  (setq zones (append zones (CollectInnerPolylinesAsObstructions boundary_ent clearance)))
  zones)

;; Collect shadow polygons drawn by SHADOW / BSHADOW as module exclusion zones.
;; Checks layers: SHADOW-POLE, SHADOW-BLDG, SHADOW-SMALL
(defun CollectShadowExclusionZones (/ layers layer ss idx ename foot_pts zones box)
  (setq zones nil
        layers (list "SHADOW-POLE" "SHADOW-BLDG" "SHADOW-SMALL" "SHADOW-LA" "LA_PROTECTION" "STREET_LIGHTING"))
  (foreach layer layers
    (if (setq ss (ssget "_X" (list (cons 8 layer) '(0 . "LWPOLYLINE"))))
        (progn
          (setq idx 0)
          (while (< idx (sslength ss))
            (setq ename (ssname ss idx))
            (setq foot_pts (get-poly-approx-vertices ename))
            (if (and foot_pts (> (length foot_pts) 2))
                (progn
                  (setq box (GetPolygonBBox foot_pts))
                  (setq zones (cons (list box foot_pts) zones))))
            (setq idx (1+ idx))))))
  zones)
 
;;;============================================================
;;; Drafting Utility Helpers
;;;============================================================

(defun setup-layer (name color / )
  (setvar "CMDECHO" 0)
  (if (not (tblsearch "LAYER" name))
    (command "_.-LAYER" "_Make" name "_Color" color "" "")
    (command "_.-LAYER" "_Thaw" name "_On" name "_Unlock" name "_Set" name ""))
  (setvar "CLAYER" name))

(defun spd-draw-text (pt txt h rot lay clr)
  (entmake (list '(0 . "TEXT")
                 '(100 . "AcDbEntity") (cons 8 lay) (cons 62 clr)
                 '(100 . "AcDbText")
                 (cons 10 pt) (cons 40 h) (cons 1 txt) (cons 50 rot)
                 '(72 . 1) (cons 11 pt) '(73 . 2))))


;; Shortest distance from point (px,py) to line segment (p1x,p1y)-(p2x,p2y)
(defun PointToSegmentDist (px py p1x p1y p2x p2y / dx dy len2 tv cx cy)
  (setq dx (- p2x p1x) dy (- p2y p1y) len2 (+ (* dx dx) (* dy dy)))
  (if (< len2 1e-12)
    (sqrt (+ (* (- px p1x) (- px p1x)) (* (- py p1y) (- py p1y))))
    (progn
      (setq tv (max 0.0 (min 1.0 (/ (+ (* (- px p1x) dx) (* (- py p1y) dy)) len2))))
      (setq cx (+ p1x (* tv dx)) cy (+ p1y (* tv dy)))
      (sqrt (+ (* (- px cx) (- px cx)) (* (- py cy) (- py cy)))))))

;; Minimum distance from point pt=(x y) to any edge of closed polygon bverts
(defun MinDistToBoundary (pt bverts / work p1 p2 best d)
  (setq work (append bverts (list (car bverts))) best 1e308)
  (repeat (1- (length work))
    (setq p1 (car work) p2 (cadr work) work (cdr work))
    (setq d (PointToSegmentDist (car pt) (cadr pt)
                                (car p1) (cadr p1) (car p2) (cadr p2)))
    (if (< d best) (setq best d)))
  best)

(defun RectanglesOverlap (min_x min_y max_x max_y box)
  (not (or (<= max_x (nth 0 box))
           (>= min_x (nth 2 box))
           (<= max_y (nth 1 box))
           (>= min_y (nth 3 box)))))

(defun PointInPolygonList (pt vertices / x y count p1 p2 work)
  (if (and vertices (> (length vertices) 2))
      (progn
        (setq x (car pt)
              y (cadr pt)
              count 0
              work (append vertices (list (car vertices))))
        (repeat (1- (length work))
          (setq p1 (car work) p2 (cadr work) work (cdr work))
          (if (and (or (and (<= (cadr p1) y) (< y (cadr p2)))
                       (and (<= (cadr p2) y) (< y (cadr p1))))
                   (< x (+ (car p1)
                           (/ (* (- y (cadr p1)) (- (car p2) (car p1)))
                              (- (cadr p2) (cadr p1))))))
              (setq count (1+ count))))
        (= (rem count 2) 1))
      nil))

(defun SegmentsIntersect (a b c d / den ua ub)
  (setq den (- (* (- (car d) (car c)) (- (cadr b) (cadr a)))
               (* (- (cadr d) (cadr c)) (- (car b) (car a)))))
  (if (equal den 0.0 1e-12)
      nil
      (progn
        (setq ua (/ (- (* (- (cadr d) (cadr c)) (- (car a) (car c)))
                       (* (- (car d) (car c)) (- (cadr a) (cadr c))))
                    den))
        (setq ub (/ (- (* (- (cadr b) (cadr a)) (- (car a) (car c)))
                       (* (- (car b) (car a)) (- (cadr a) (cadr c))))
                    den))
        (and (>= ua 0.0) (<= ua 1.0) (>= ub 0.0) (<= ub 1.0)))))

(defun PolygonEdgesIntersect (poly1 poly2 / w1 w2 a b c d hit)
  (setq hit nil
        w1 (append poly1 (list (car poly1)))
        w2 (append poly2 (list (car poly2))))
  (repeat (1- (length w1))
    (setq a (car w1) b (cadr w1) w1 (cdr w1) w2 (append poly2 (list (car poly2))))
    (repeat (1- (length w2))
      (setq c (car w2) d (cadr w2) w2 (cdr w2))
      (if (SegmentsIntersect a b c d)
          (setq hit T))))
  hit)

(defun RectanglePolygon (x y w h)
  (list (list x y 0.0)
        (list (+ x w) y 0.0)
        (list (+ x w) (+ y h) 0.0)
        (list x (+ y h) 0.0)))

(defun PolygonsOverlap (poly1 poly2)
  (or (PointInPolygonList (car poly1) poly2)
      (PointInPolygonList (car poly2) poly1)
      (PolygonEdgesIntersect poly1 poly2)))

(defun TableClearOfObstructions (x y w h_proj obstruction_zones / max_x max_y rect_poly clear_ok)
  (setq max_x (+ x w)
        max_y (+ y h_proj)
        rect_poly (RectanglePolygon x y w h_proj)
        clear_ok T)
  (foreach zone obstruction_zones
    (if (and (RectanglesOverlap x y max_x max_y (car zone))
             (PolygonsOverlap rect_poly (cadr zone)))
        (setq clear_ok nil)))
  clear_ok)

(defun TablePlacementOk (x y w h_proj ent obstruction_zones is_tracker)
  (and (TableFitsPoly x y w h_proj ent)
       (TableClearOfObstructions x y w h_proj obstruction_zones)))

(defun FindBestRowStart (row_y min_x max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones / base_x max_start pitch candidates candidate test_start best_start best_count test_count)
  (setq base_x (+ min_x set_off))
  (setq max_start (- (- max_x set_off) table_w))
  (setq best_start base_x)
  (setq best_count (CountTablesInRow base_x row_y max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones is_tracker))
  ;; Keep NonAligned fast by testing only a few practical stagger positions
  ;; instead of sweeping many offsets across every row.
  (setq pitch (+ table_w t_gap_h))
  (setq candidates (list 0.25 0.5 0.75))
  (foreach candidate candidates
    (setq test_start (+ base_x (* pitch candidate)))
    (if (<= test_start max_start)
        (progn
          (setq test_count (CountTablesInRow test_start row_y max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones is_tracker))
          (if (> test_count best_count)
              (setq best_count test_count
                    best_start test_start)))))
  best_start)

(defun CountTablesInRow (start_x row_y max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones is_tracker / cur_x count eff_w)
  (setq eff_w table_w)
  (setq cur_x start_x
        count 0)
  (while (<= (+ cur_x eff_w) (- max_x set_off))
    (if (TablePlacementOk cur_x row_y eff_w table_h_proj ent obstruction_zones is_tracker)
        (setq count (1+ count)))
    (setq cur_x (+ cur_x eff_w t_gap_h)))
  count)

(defun EnsureReportTextStyle (/ style_ent style_def)
  (if (tblsearch "STYLE" "REPORT_STD")
      (progn
        (setq style_ent (tblobjname "STYLE" "REPORT_STD"))
        (if style_ent
            (progn
              (setq style_def (entget style_ent))
              (if (assoc 50 style_def)
                  (setq style_def (subst (cons 50 0.0) (assoc 50 style_def) style_def))
                  (setq style_def (append style_def (list (cons 50 0.0)))))
              (if (assoc 3 style_def)
                  (setq style_def (subst (cons 3 "calibril.ttf") (assoc 3 style_def) style_def))
                  (setq style_def (append style_def (list (cons 3 "calibril.ttf")))))
              (entmod style_def))))
      (entmake (list '(0 . "STYLE") '(100 . "AcDbSymbolTableRecord")
                     '(100 . "AcDbTextStyleTableRecord") '(2 . "REPORT_STD")
                     '(70 . 0) '(40 . 0.0) '(41 . 1.0) '(50 . 0.0)
                     '(71 . 0) '(42 . 2.5) '(3 . "calibril.ttf") '(4 . "")))))


(defun ClampValue (val min_val max_val)
  (max min_val (min max_val val)))

(defun GetReportMetrics (ent / min_pt max_pt bmin bmax bw bh ref_dim scale row_h text_h sno_w details_w data_w title_h title_gap table_gap report_offset x y)
  (vla-getboundingbox (vlax-ename->vla-object ent) 'min_pt 'max_pt)
  (setq bmin (vlax-safearray->list min_pt)
        bmax (vlax-safearray->list max_pt)
        bw   (max 1.0 (- (car bmax) (car bmin)))
        bh   (max 1.0 (- (cadr bmax) (cadr bmin)))
        ref_dim (min bw bh)
        scale (ClampValue (/ ref_dim 120.0) 0.35 2.0)
        row_h (* 10.0 scale)
        text_h (* 4.0 scale)
        sno_w (* 16.0 scale)
        details_w (* 72.0 scale)
        data_w (* 92.0 scale)
        title_h (* 5.0 scale)
        title_gap (* 0.8 row_h)
        table_gap (* 1.6 row_h)
        report_offset (max (* 1.25 row_h) (* ref_dim 0.04))
        x (car bmin)
        y (- (cadr bmin) report_offset))
  (list (list x y 0.0) row_h text_h sno_w details_w data_w title_h title_gap table_gap))

(defun DrawReportTables (ent summary_rows energy_rows structural_rows boundary_handle
                         / metrics base_pt table_gap x y total_w next_y1 next_y2
                           before_ent e entity_list grp_name doc groups grp)
  (EnsureReportTextStyle)
  (setq metrics   (GetReportMetrics ent)
        base_pt   (nth 0 metrics)
        table_gap (nth 8 metrics)
        total_w   (+ (nth 3 metrics) (nth 4 metrics) (nth 5 metrics))
        x         (car base_pt)
        y         (cadr base_pt))
  
  ;; Record last entity before drawing
  (setq before_ent (entlast))
  
  ;; 1. Layout Summary (Forest Green)
  (setq next_y1 (DrawReportTable x y "LAYOUT SUMMARY" summary_rows boundary_handle metrics 1284936))
  
  ;; 2. Energy Summary (Solar Amber - Side-by-Side)
  (setq next_y2 (DrawReportTable (+ x total_w (* 2.0 table_gap)) y "ENERGY SUMMARY" energy_rows boundary_handle metrics 15247360))
  
  ;; 3. Structural Summary (Structural Blue - Below)
  (DrawReportTable x (- (min next_y1 next_y2) table_gap) "STRUCTURAL SUMMARY" structural_rows boundary_handle metrics 41704)

  ;; Collect all entity names created since before_ent
  (setq entity_list nil
        e (if before_ent (entnext before_ent) (entnext)))
  (while e
    (setq entity_list (cons e entity_list))
    (setq e (entnext e)))
  ;; Create a VLA named GROUP so the entire report selects as one click
  (if entity_list
    (progn
      (vl-load-com)
      (setq grp_name (strcat "SRPT_" boundary_handle)
            doc      (vla-get-activedocument (vlax-get-acad-object))
            groups   (vla-get-groups doc))
      ;; Remove old group with the same name if it exists (from a Refresh)
      (vl-catch-all-apply
        (function (lambda () (vla-delete (vla-item groups grp_name)))))
      ;; Create fresh group and populate it
      (setq grp (vla-add groups grp_name))
      (foreach e entity_list
        (if (and e (entget e))
          (vl-catch-all-apply
            (function (lambda ()
              (vla-appenditem grp (vlax-ename->vla-object e))))))))))

(defun DrawReportTable (x y title rows boundary_handle metrics true_color / row_h text_h sno_w details_w data_w title_h title_gap total_w total_h y_bottom cur_y idx row pad_x pad_y)
  (setq row_h     (nth 1 metrics)
        text_h    (nth 2 metrics)
        sno_w     (nth 3 metrics)
        details_w (nth 4 metrics)
        data_w    (nth 5 metrics)
        title_h   (nth 6 metrics)
        title_gap (nth 7 metrics)
        pad_x     (max 1.0 (* text_h 0.5))
        pad_y     (max 0.8 (* text_h 0.5))
        total_w   (+ sno_w details_w data_w)
        total_h   (* row_h (+ 1 (length rows)))
        y_bottom  (- y total_h))
  (DrawReportMText (list x (+ y title_gap) 0.0) total_w title title_h true_color boundary_handle)
  (DrawReportLine (list x y 0.0) (list (+ x total_w) y 0.0) true_color boundary_handle)
  (DrawReportLine (list x y_bottom 0.0) (list (+ x total_w) y_bottom 0.0) true_color boundary_handle)
  (DrawReportLine (list x y 0.0) (list x y_bottom 0.0) true_color boundary_handle)
  (DrawReportLine (list (+ x sno_w) y 0.0) (list (+ x sno_w) y_bottom 0.0) true_color boundary_handle)
  (DrawReportLine (list (+ x sno_w details_w) y 0.0) (list (+ x sno_w details_w) y_bottom 0.0) true_color boundary_handle)
  (DrawReportLine (list (+ x total_w) y 0.0) (list (+ x total_w) y_bottom 0.0) true_color boundary_handle)
  (setq cur_y (- y row_h))
  (while (>= cur_y y_bottom)
    (DrawReportLine (list x cur_y 0.0) (list (+ x total_w) cur_y 0.0) true_color boundary_handle)
    (setq cur_y (- cur_y row_h)))
  (DrawReportMText (list (+ x pad_x) (- y pad_y) 0.0) (- sno_w (* 2.0 pad_x)) "S.No" text_h true_color boundary_handle)
  (DrawReportMText (list (+ x sno_w pad_x) (- y pad_y) 0.0) (- details_w (* 2.0 pad_x)) "Details" text_h true_color boundary_handle)
  (DrawReportMText (list (+ x sno_w details_w pad_x) (- y pad_y) 0.0) (- data_w (* 2.0 pad_x)) "Data" text_h true_color boundary_handle)
  (setq idx 1
        cur_y (- y row_h))
  (foreach row rows
    (DrawReportMText (list (+ x pad_x) (- cur_y pad_y) 0.0) (- sno_w (* 2.0 pad_x)) (itoa idx) text_h true_color boundary_handle)
    (DrawReportMText (list (+ x sno_w pad_x) (- cur_y pad_y) 0.0) (- details_w (* 2.0 pad_x)) (car row) text_h true_color boundary_handle)
    (setq cell_color (if (and (= (car row) "Piling Status") (= (cadr row) "OK")) 1284936 true_color))
    (DrawReportMText (list (+ x sno_w details_w pad_x) (- cur_y pad_y) 0.0) (- data_w (* 2.0 pad_x)) (cadr row) text_h cell_color boundary_handle)
    (setq idx (1+ idx)
          cur_y (- cur_y row_h)))
  y_bottom)

(defun DrawReportLine (p1 p2 true_color boundary_handle / ename)
  (setq ename (entmakex (list '(0 . "LINE") '(8 . "0") (cons 420 true_color) (cons 10 p1) (cons 11 p2))))
  (TagReportEntity ename boundary_handle))

(defun DrawReportMText (pt width txt h true_color boundary_handle / ename)
  (setq ename
        (entmakex (list '(0 . "MTEXT") '(100 . "AcDbEntity") '(8 . "0") (cons 420 true_color)
                        '(100 . "AcDbMText") (cons 10 pt) (cons 40 h)
                        (cons 41 width) '(71 . 1) '(72 . 1)
                        '(7 . "REPORT_STD") (cons 1 txt))))
  (TagReportEntity ename boundary_handle))

(defun TagReportEntity (ename boundary_handle / data)
  (if ename
      (progn
        (if (not (tblsearch "APPID" "FS_SOLAR_REPORT")) (regapp "FS_SOLAR_REPORT"))
        (setq data (entget ename))
        (entmod (append data (list (list -3 (list "FS_SOLAR_REPORT" (cons 1000 boundary_handle)))))))))

(defun DeleteReportEntities (boundary_handle / grp_name doc groups grp entity_list vobj ss idx ename xdata)
  (vl-load-com)
  (setq grp_name (strcat "SRPT_" boundary_handle)
        doc      (vla-get-activedocument (vlax-get-acad-object))
        groups   (vla-get-groups doc))
  ;; 1. Primary: find group, collect member enames, delete group, delete entities
  (vl-catch-all-apply
    (function (lambda ()
      (setq grp (vla-item groups grp_name)
            entity_list nil)
      ;; Collect all member enames before touching anything
      (vlax-for obj grp
        (vl-catch-all-apply
          (function (lambda ()
            (setq entity_list (cons (vlax-vla-object->ename obj) entity_list))))))
      ;; Delete the group object itself (removes grouping, not entities)
      (vla-delete grp)
      ;; Now delete every member entity
      (foreach e entity_list
        (if (and e (entget e)) (entdel e))))))
  ;; 2. Fallback: catch any stray tagged LINE/MTEXT from old-format reports
  (if (setq ss (ssget "_X" '((0 . "LINE,MTEXT"))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ename (ssname ss idx)
              xdata (cdr (assoc -3 (entget ename '("FS_SOLAR_REPORT")))))
        (if (and xdata
                 (= (caar xdata) "FS_SOLAR_REPORT")
                 (= (cdr (assoc 1000 (cdar xdata))) boundary_handle))
          (entdel ename))
        (setq idx (1+ idx))))))

(defun GetSolarDataValues (ent / xdata appdata)
  (setq xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (and xdata (= (caar xdata) "FS_SOLAR_DATA"))
      (progn
        (setq appdata (cdar xdata))
        (mapcar 'cdr (vl-remove-if-not '(lambda (itm) (member (car itm) '(1040 1000))) appdata)))
      nil))

(defun EnsureSolarExtrasApp ()
  (if (not (tblsearch "APPID" "FS_SOLAR_EXTRAS"))
    (regapp "FS_SOLAR_EXTRAS")))

(defun GetSolarExtraValues (ent / xdata appdata)
  (setq xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_EXTRAS")))))
  (if (and xdata (= (caar xdata) "FS_SOLAR_EXTRAS"))
      (progn
        (setq appdata (cdar xdata))
        (mapcar 'cdr (vl-remove-if-not '(lambda (itm) (member (car itm) '(1040 1000))) appdata)))
      nil))

(defun SaveSolarExtraValues (ent h_road_w h_road_f v_road_w v_road_f energy_src manual_ghi ghi_used / ed)
  (EnsureSolarExtrasApp)
  (setq ed (entget ent))
  (setq ed (vl-remove-if
             '(lambda (itm)
                (and (= (car itm) -3)
                     (= (car (cadr itm)) "FS_SOLAR_EXTRAS")))
             ed))
  (entmod
    (append ed
      (list
        (list -3
          (list "FS_SOLAR_EXTRAS"
                (cons 1040 h_road_w)
                (cons 1040 (float h_road_f))
                (cons 1040 v_road_w)
                (cons 1040 (float v_road_f))
                (cons 1000 energy_src)
                (cons 1040 manual_ghi)
                (cons 1040 ghi_used)
                (cons 1000 (if (boundp '*spd-mount_type*) *spd-mount_type* "Fixed Tilt"))
                (cons 1040 (if (boundp '*spd-gcr*) *spd-gcr* 40.0))
                (cons 1040 (if (boundp '*spd-tracker_len*) *spd-tracker_len* 90.0))
                (cons 1040 (if (boundp '*spd-motor_gap*) *spd-motor_gap* 1.5))))))))

(defun MakeZoneFromRect (x y w h / poly)
  (setq poly (RectanglePolygon x y w h))
  (list (GetPolygonBBox poly) poly))

(defun sp-safe-real (val def /)
  (cond
    ((numberp val) val)
    ((and (= (type val) 'STR) (/= val "")) (atof val))
    (T def)))

(defun sp-safe-int (val def /)
  (fix (sp-safe-real val def)))

(defun sp-road-extra-gap (base_gap road_w)
  (max 0.0 (- road_w base_gap)))

(defun sp-road-gap-width (base_gap road_w)
  (max base_gap road_w))

(defun sp-build-row-candidates-bottom (bmin bmax set_off row_pitch table_h_proj h_road_w h_road_f / rows usable_y top_y row_gap extra_gap idx y done)
  (setq rows nil
        usable_y (+ (cadr bmin) set_off)
        top_y (- (cadr bmax) set_off)
        row_gap (max 0.0 (- row_pitch table_h_proj))
        extra_gap (if (and (> h_road_w 0.0) (> h_road_f 0))
                    (sp-road-extra-gap row_gap h_road_w)
                    0.0)
        idx 0
        done nil)
  (while (not done)
    (setq y (+ usable_y
               (* idx row_pitch)
               (* (if (and (> h_road_f 0) (> extra_gap 0.0))
                      (fix (/ idx h_road_f))
                      0)
                  extra_gap)))
    (if (> (+ y table_h_proj) top_y)
      (setq done T)
      (progn
        (setq rows (append rows (list y)))
        (setq idx (1+ idx)))))
  rows)

(defun sp-build-row-candidates-top (bmin bmax set_off row_pitch table_h_proj h_road_w h_road_f / rows usable_y top_y row_gap extra_gap idx y done)
  (setq rows nil
        usable_y (+ (cadr bmin) set_off)
        top_y (- (cadr bmax) set_off)
        row_gap (max 0.0 (- row_pitch table_h_proj))
        extra_gap (if (and (> h_road_w 0.0) (> h_road_f 0))
                    (sp-road-extra-gap row_gap h_road_w)
                    0.0)
        idx 0
        done nil)
  (while (not done)
    (setq y (- top_y
               table_h_proj
               (* idx row_pitch)
               (* (if (and (> h_road_f 0) (> extra_gap 0.0))
                      (fix (/ idx h_road_f))
                      0)
                  extra_gap)))
    (if (< y usable_y)
      (setq done T)
      (progn
        (setq rows (append rows (list y)))
        (setq idx (1+ idx)))))
  rows)

(defun sp-road-zone-end-x (x table_w row_y row_h road_zones / hit bbox rmin rmax)
  (setq hit nil)
  (foreach z road_zones
    (setq bbox (car z)
          rmin (list (nth 0 bbox) (nth 1 bbox))
          rmax (list (nth 2 bbox) (nth 3 bbox)))
    ;; Check proper 1D overlap on both X and Y axis to accurately detect road collisions
    (if (and (< x (car rmax)) (> (+ x table_w) (car rmin))
             (< row_y (cadr rmax)) (> (+ row_y row_h) (cadr rmin)))
      (if (null hit)
          (setq hit (car rmax))
          (setq hit (max hit (car rmax))))))
  hit)

(defun CollectRoadZones (bmin bmax set_off row_pitch table_h_proj unit_w unit_gap h_road_w h_road_f v_road_w v_road_f dyn_usable_x / zones usable_y usable_w usable_h road_x col_pitch idx col_gap col_w extra_x road_no done)
  (setq zones nil
        usable_y (+ (cadr bmin) set_off)
        usable_w (max 0.0 (- (- (car bmax) set_off) dyn_usable_x))
        usable_h (max 0.0 (- (- (cadr bmax) set_off) usable_y))
        col_gap (max 0.0 unit_gap))
  (if (and (numberp v_road_w) (numberp v_road_f) (numberp unit_w) (numberp unit_gap) (> v_road_w 0.0) (> v_road_f 0) (> (+ unit_w unit_gap) 0.0))
    (progn
      (setq col_pitch (+ unit_w unit_gap)
            col_w (sp-road-gap-width col_gap v_road_w)
            extra_x (sp-road-extra-gap col_gap v_road_w)
            idx v_road_f
            done nil)
      (while (not done)
        (setq road_no (fix (/ idx v_road_f))
              road_x (+ dyn_usable_x
                        (* idx col_pitch)
                        (* (max 0 (1- road_no)) extra_x)
                        (- col_gap)))
        (if (> (+ road_x col_w) (+ dyn_usable_x usable_w))
          (setq done T)
          (progn
            (setq zones (cons (MakeZoneFromRect road_x usable_y col_w usable_h) zones))
            (setq idx (+ idx v_road_f)))))))
  zones)

(defun spd-road-summary (h_road_w h_road_f v_road_w v_road_f / rows)
  (setq rows nil)
  (if (> h_road_w 0.0)
    (setq rows (append rows (list (list "Horiz. Road Width" (strcat (rtos h_road_w 2 2) " m (Freq: " (itoa h_road_f) ")"))))))
  (if (> v_road_w 0.0)
    (setq rows (append rows (list (list "Vert. Road Width" (strcat (rtos v_road_w 2 2) " m (Freq: " (itoa v_road_f) ")"))))))
  rows)

(defun get-pvgis-ghi-lisp (latitude longitude / http url response_text send_result regex matches match match_str colon_pos ghi_value track_type)
  (setq http (vlax-create-object "MSXML2.ServerXMLHTTP"))
  (setq track_type (if (and (boundp '*spd-s-mount-type*) (member *spd-s-mount-type* '("0" "1" "2"))) *spd-s-mount-type* "0"))
  (setq url (strcat "https://re.jrc.ec.europa.eu/api/v5_3/PVcalc?lat="
                    (vl-string-translate "," "." (rtos latitude 2 6)) "&lon="
                    (vl-string-translate "," "." (rtos longitude 2 6))
                    "&peakpower=1&loss=0&mountingplace=free"
                    (cond ((= track_type "1") "&inclined_axis=1")
                          ((= track_type "2") "&twoaxis=1")
                          (t "&angle=0&aspect=0"))
                    "&outputformat=json"))
  (vlax-invoke-method http 'Open "GET" url :vlax-false)
  (setq send_result (vl-catch-all-apply 'vlax-invoke-method (list http 'Send)))
  (if (vl-catch-all-error-p send_result)
      nil
      (if (= (vlax-get-property http 'Status) 200)
          (progn
            (setq response_text (vlax-get-property http 'ResponseText)
                  ghi_value nil)
            (setq regex (vlax-create-object "VBScript.RegExp"))
            (vlax-put-property regex 'Global :vlax-true)
            (vlax-put-property regex 'IgnoreCase :vlax-true)
            (vlax-put-property regex 'Pattern "\"H\\(i\\)_d\"\\s*:\\s*([0-9.]+)")
            (setq matches (vl-catch-all-apply 'vlax-invoke-method (list regex 'Execute response_text)))
            (if (not (vl-catch-all-error-p matches))
              (vlax-for match matches
                (setq match_str (vlax-get-property match 'Value)
                      colon_pos (vl-string-search ":" match_str))
                (if colon_pos
                  (setq ghi_value (atof (substr match_str (+ colon_pos 2)))))))
            (vlax-release-object regex)
            ghi_value)
          nil)))

(defun get-nasa-power-ghi-lisp (latitude longitude / http url response_text param_pos ann_pos ghi_value comma_pos brace_pos end_pos send_result)
  (setq http (vlax-create-object "MSXML2.ServerXMLHTTP"))
  (setq url (strcat "https://power.larc.nasa.gov/api/temporal/climatology/point?parameters=ALLSKY_SFC_SW_DWN&community=RE&longitude="
                    (vl-string-translate "," "." (rtos longitude 2 6))
                    "&latitude="
                    (vl-string-translate "," "." (rtos latitude 2 6))
                    "&format=JSON"))
  (vlax-invoke-method http 'Open "GET" url :vlax-false)
  (setq send_result (vl-catch-all-apply 'vlax-invoke-method (list http 'Send)))
  (if (vl-catch-all-error-p send_result)
      nil
      (if (= (vlax-get-property http 'Status) 200)
          (progn
            (setq response_text (vlax-get-property http 'ResponseText)
                  param_pos (vl-string-search "\"ALLSKY_SFC_SW_DWN\":" response_text))
            (if param_pos
              (progn
                (setq response_text (substr response_text (+ param_pos 1 (strlen "\"ALLSKY_SFC_SW_DWN\":")))
                      ann_pos (vl-string-search "\"ANN\":" response_text))
                (if ann_pos
                  (progn
                    (setq response_text (substr response_text (+ ann_pos 1 (strlen "\"ANN\":")))
                          comma_pos (vl-string-search "," response_text)
                          brace_pos (vl-string-search "}" response_text))
                    (if (and comma_pos brace_pos)
                      (setq end_pos (min comma_pos brace_pos))
                      (setq end_pos (if comma_pos comma_pos brace_pos)))
                    (if end_pos (setq ghi_value (atof (substr response_text 1 end_pos))) (setq ghi_value nil))
                    (if (and ghi_value (> ghi_value 0.0)) ghi_value nil))
                  nil))
              nil))
          nil)))

(defun ResolveEnergyProfile (source lat lon manual_ghi saved_ghi / src fetched)
  (setq src (cond
              ((or (null source) (= source "")) "Latitude Default")
              ((= source "Manual GHI") "Manual GHI")
              ((= source "PVGIS API") "PVGIS API")
              ((= source "NASA POWER API") "NASA POWER API")
              (T "Latitude Default")))  (cond
    ((= src "Manual GHI")
      (if (> manual_ghi 0.0)
        (list "Manual GHI" manual_ghi)
        (list "Latitude Default" nil)))
    ((= src "PVGIS API")
      (setq fetched (get-pvgis-ghi-lisp lat lon))
      (cond
        ((and fetched (> fetched 0.0)) (list "PVGIS API" fetched))
        ((> manual_ghi 0.0) (list "PVGIS API (Manual Fallback)" manual_ghi))
        ((and saved_ghi (> saved_ghi 0.0)) (list "PVGIS API (Saved Fallback)" saved_ghi))
        (T (list "PVGIS API (Default Fallback)" nil))))
    ((= src "NASA POWER API")
      (setq fetched (get-nasa-power-ghi-lisp lat lon))
      (cond
        ((and fetched (> fetched 0.0)) (list "NASA POWER API" fetched))
        ((> manual_ghi 0.0) (list "NASA POWER API (Manual Fallback)" manual_ghi))
        ((and saved_ghi (> saved_ghi 0.0)) (list "NASA POWER API (Saved Fallback)" saved_ghi))
        (T (list "NASA POWER API (Default Fallback)" nil))))
    (T (list "Latitude Default" nil))))

(defun CountTableBlocksInBoundary (ent / ss idx ename ins_pt blk_name count)
  (setq count 0)
  (if (setq ss (ssget "_X" '((0 . "INSERT"))))
      (progn
        (setq idx 0)
        (while (< idx (sslength ss))
          (setq ename (ssname ss idx)
                blk_name (cdr (assoc 2 (entget ename))))
          (if (and blk_name (= (substr (strcase blk_name) 1 6) "TABLE_"))
              (progn
                (setq ins_pt (cdr (assoc 10 (entget ename))))
                (if (InsidePoly ins_pt ent) (setq count (1+ count)))))
          (setq idx (1+ idx)))))
  count)

(defun CountModuleBlocksInBoundary (ent / ss idx ename ins_pt blk_name count)
  (setq count 0)
  (if (setq ss (ssget "_X" '((0 . "INSERT"))))
      (progn
        (setq idx 0)
        (while (< idx (sslength ss))
          (setq ename (ssname ss idx)
                blk_name (cdr (assoc 2 (entget ename))))
          (if (and blk_name (= (strcase blk_name) "MODULE"))
              (progn
                (setq ins_pt (cdr (assoc 10 (entget ename))))
                (if (InsidePoly ins_pt ent) (setq count (1+ count)))))
          (setq idx (1+ idx)))))
  count)

(defun FormatAzimuthLabel (az)
  (strcat (rtos az 2 1) " deg"
          (cond
            ((equal az 0.0 1e-6) " (South)")
            ((equal az 90.0 1e-6) " (West)")
            ((equal az -90.0 1e-6) " (East)")
            ((or (equal az 180.0 1e-6) (equal az -180.0 1e-6)) " (North)")
            (T ""))))

;; --- RECALCULATE, AUTOSTRING, AND UTILITIES (REMAIN UNCHANGED FROM VER-4.1) ---
;; [Keep all utility functions like TableFitsPoly, sort-modules-snake, InsidePoly, GenerateReportString, etc. from Ver 4.1]

(defun TableFitsPoly (x y w h_proj ent / rect_poly bverts soff corners ok)
  ;; 1. All 4 corners must be inside the boundary polygon.
  ;; 2. No table edge may cross a boundary edge (catches diagonal boundaries).
  ;; 3. Every corner must be >= set_off metres from any boundary edge
  ;;    (enforces the true clearance regardless of boundary shape).
  (setq rect_poly (list (list x       y           0.0)
                        (list (+ x w) y           0.0)
                        (list (+ x w) (+ y h_proj) 0.0)
                        (list x       (+ y h_proj) 0.0))
        bverts (get-poly-approx-vertices ent)
        soff   (if (and (boundp '*spro-set-off*) (numberp *spro-set-off*) (> *spro-set-off* 0.0))
                   *spro-set-off* 0.0))
  (and (InsidePoly (list x y 0) ent)
       (InsidePoly (list (+ x w) y 0) ent)
       (InsidePoly (list (+ x w) (+ y h_proj) 0) ent)
       (InsidePoly (list x (+ y h_proj) 0) ent)
       (not (PolygonEdgesIntersect rect_poly bverts))
       ;; Setback distance check  every corner >= soff from boundary edge
       (or (<= soff 0.0)
           (and (>= (MinDistToBoundary (list x y)             bverts) soff)
                (>= (MinDistToBoundary (list (+ x w) y)       bverts) soff)
                (>= (MinDistToBoundary (list (+ x w) (+ y h_proj)) bverts) soff)
                (>= (MinDistToBoundary (list x (+ y h_proj))  bverts) soff)))))
(defun sort-by-y (a b) (< (cadr (get-center a)) (cadr (get-center b))))
(defun sort-by-x (a b) (< (car (get-center a)) (car (get-center b))))
(defun sort-modules-snake (lst / rows sorted final_list current_row last_y p reverse_flag)
  (setq sorted (vl-sort lst 'sort-by-y))
  (setq rows nil current_row nil last_y nil)
  (foreach ent sorted
    (setq p (get-center ent))
    (if (or (null last_y) (> (abs (- (cadr p) last_y)) 0.15))
        (progn (if current_row (setq rows (cons (vl-sort current_row 'sort-by-x) rows))) (setq current_row (list ent) last_y (cadr p)))
        (setq current_row (cons ent current_row))))
  (if current_row (setq rows (cons (vl-sort current_row 'sort-by-x) rows)))
  (setq rows (reverse rows) final_list nil reverse_flag nil)
  (foreach r rows (if reverse_flag (setq r (reverse r))) (setq final_list (append final_list r)) (setq reverse_flag (not reverse_flag)))
  final_list)
(defun midpoint2d (p1 p2)
  (list (/ (+ (car p1) (car p2)) 2.0)
        (/ (+ (cadr p1) (cadr p2)) 2.0)
        0.0))
(defun arc-segment-points (p1 p2 bulge / delta chord mid dist alpha center radius steps idx pts arc-raw)
  (if (equal bulge 0.0 1e-12)
      (list p1)
      (progn
        (setq delta (* 4.0 (atan bulge)))
        (setq chord (distance p1 p2))
        (setq mid (midpoint2d p1 p2))
        (setq dist (/ (* chord (- 1.0 (* bulge bulge))) (* 4.0 bulge)))
        (setq alpha (angle p1 p2))
        (setq arc-raw (polar mid (+ alpha (if (> bulge 0.0) (/ pi 2.0) (- (/ pi 2.0)))) dist)
              center  (list (car arc-raw)
                            (if (numberp (cdr arc-raw)) (cdr arc-raw) (cadr arc-raw))
                            0.0))
        (setq radius (distance center p1))
        (setq steps (max 4 (fix (+ 1 (/ (abs delta) (/ pi 18.0))))))
        (setq idx 0 pts nil)
        (while (< idx steps)
          ;; polar may return dotted pair (x . y) - normalise to (x y 0.0)
          (setq arc-raw (polar center (+ (angle center p1) (* delta (/ idx (float steps)))) radius)
                pts (cons (list (car arc-raw)
                                (if (numberp (cdr arc-raw)) (cdr arc-raw) (cadr arc-raw))
                                0.0)
                          pts))
          (setq idx (1+ idx)))
        (reverse pts))))
(defun get-poly-approx-vertices (ent / data pts bulges closed pairs vertices idx curr next pending-x raw-val)
  ;; AutoCAD entget for LWPOLYLINE may return group-10 as a combined 2D point (x . y)
  ;; OR as a plain x-number with a separate group-20 y-number.
  ;; We detect which format and normalise to (x y 0.0) in both cases.
  (setq data (entget ent) pts nil bulges nil pending-x nil)
  (foreach item data
    (cond
      ((= (car item) 10)
       (setq raw-val (cdr item))
       (if (numberp raw-val)
         ;; Separate format: group-10 = x only; wait for group-20 for y
         (setq pending-x raw-val)
         ;; Combined format: group-10 = full 2D point (dotted pair or list)
         (progn
           (setq pts (append pts (list (list (car raw-val)
                                             (if (listp (cdr raw-val)) (cadr raw-val) (cdr raw-val))
                                             0.0))))
           (setq pending-x nil))))
      ((= (car item) 20)
       (if pending-x
         (progn (setq pts (append pts (list (list pending-x (cdr item) 0.0))))
                (setq pending-x nil))))
      ((= (car item) 42) (setq bulges (append bulges (list (cdr item)))))))
  (setq closed (= 1 (logand 1 (cdr (assoc 70 data)))))
  (while (< (length bulges) (length pts)) (setq bulges (append bulges (list 0.0))))
  (setq pairs nil idx 0)
  (while (< idx (length pts))
    (setq pairs (append pairs (list (list (nth idx pts) (nth idx bulges)))))
    (setq idx (1+ idx)))
  (setq vertices nil idx 0)
  (while (< idx (if closed (length pairs) (1- (length pairs))))
    (setq curr (nth idx pairs))
    (setq next (nth (rem (1+ idx) (length pairs)) pairs))
    (setq vertices (append vertices (arc-segment-points (car curr) (car next) (cadr curr))))
    (setq idx (1+ idx)))
  ;; Close polygon: for closed flag use first pt; for open use last pt (NOT car of last pt)
  ;; (car (last pts)) would return just the x-number - use (last pts) for the full point
  (if pts
      (append vertices (list (if closed (car pts) (last pts))))
      nil))
(defun DiscretizePolyline (poly_ent / vla_obj end_param param pts pt)
  (setq vla_obj (vlax-ename->vla-object poly_ent))
  (setq end_param (vlax-curve-getEndParam vla_obj))
  (setq param 0.0 pts nil)
  (while (< param end_param)
    (setq pt (vlax-curve-getPointAtParam vla_obj param))
    (setq pts (cons (list (car pt) (cadr pt) 0.0) pts))
    (setq param (+ param 0.5)))
  (setq pt (vlax-curve-getPointAtParam vla_obj end_param))
  (setq pts (cons (list (car pt) (cadr pt) 0.0) pts))
  (reverse pts)
)

(defun InsidePoly (pt poly_data / vertices x y count p1 p2)
  (if (= (type poly_data) 'ENAME)
      (setq vertices (DiscretizePolyline poly_data))
      (setq vertices poly_data))
  (if (and vertices (> (length vertices) 2))
      (progn
        (setq x (car pt) y (cadr pt) count 0 vertices (append vertices (list (car vertices))))
        (repeat (1- (length vertices))
          (setq p1 (car vertices) p2 (cadr vertices) vertices (cdr vertices))
          (if (and (or (and (<= (cadr p1) y) (< y (cadr p2))) (and (<= (cadr p2) y) (< y (cadr p1)))) (< x (+ (car p1) (/ (* (- y (cadr p1)) (- (car p2) (car p1))) (- (cadr p2) (cadr p1)))))) (setq count (1+ count))))
        (= (rem count 2) 1))
      nil))
(defun GenerateReportString (header count watt res lat lon tilt az gap pitch design_alt ori stack tables mod_row area)
  (strcat "--- " header " ---\n"
          "Boundary Area: " (rtos area 2 3) " Acres\n"
          "Orientation: " ori " | Stack: " (itoa stack) "-High\n"
          "Total Modules: " (itoa count) " nos (" (rtos watt 2 0) " Wp)\n"
          "System Capacity: " (rtos (nth 0 res) 2 3) " MWp\n"
          "Total Full Tables: " (itoa tables) " nos\n"
          "Table Details: " (itoa mod_row) " Wide x " (itoa stack) " High\n"
          "----------------------------------\n"
          "Annual Energy: " (rtos (nth 1 res) 2 0) " kWh\n"
          "Monthly Energy: " (rtos (/ (nth 1 res) 12.0) 2 0) " kWh\n"
          "Daily Gen: " (rtos (nth 2 res) 2 2) " kWh\n"
          "Row Spacing (clear): " (rtos gap 2 3) " m\n"
          "Row Pitch (c/c): " (rtos pitch 2 3) " m\n"
          "Design Solar Altitude: " (rtos design_alt 2 2) " deg\n"
          "Angle / Azimuth: " (rtos tilt 2 1) " / " (rtos az 2 1) "\n"
          "Location: " (rtos lat 2 3) ", " (rtos lon 2 3)))
(defun CalculateSolarData (count watt lat tilt ghi / cap_kw cap_mw daily_gen annual_gen spec_yield base_irradiance)
  (setq cap_kw (/ (* count watt) 1000.0)
        cap_mw (/ cap_kw 1000.0)
        base_irradiance (if (and ghi (> ghi 0.0)) ghi (if (< (abs lat) 23.5) 5.5 4.8))
        daily_gen (* cap_kw
                      base_irradiance
                      (/ (sin (* (+ (- 90 (abs lat)) tilt) (/ pi 180.0)))
                         (sin (* (- 90 (abs lat)) (/ pi 180.0))))
                      0.78)
        annual_gen (* daily_gen 365.0)
        spec_yield (if (> cap_kw 0.0) (/ daily_gen cap_kw) 0.0))
  (list cap_mw annual_gen daily_gen spec_yield))
(defun tan_lsp (ang) (/ (sin ang) (cos ang)))
(defun get-center (ent / min_pt max_pt bmin bmax)
  (vla-getboundingbox (vlax-ename->vla-object ent) 'min_pt 'max_pt)
  (setq bmin (vlax-safearray->list min_pt)
        bmax (vlax-safearray->list max_pt))
  (list (/ (+ (car bmin) (car bmax)) 2.0)
        (/ (+ (cadr bmin) (cadr bmax)) 2.0)
        0))

(EnsureObstructionLayer)
(princ)

;;;============================================================
;;; SHADOW & BSHADOW - Shadow Analysis (merged from SunShadow.lsp)
;;;============================================================

(defun ss-dtr (a) (* pi (/ a 180.0)))
(defun ss-rtd (a) (/ (* a 180.0) pi))
(defun ss-tan (a) (/ (sin a) (cos a)))

(defun ss-asin (x)
  (if (>= (abs x) 1.0)
    (if (> x 0) (/ pi 2.0) (/ pi -2.0))
    (atan x (sqrt (- 1.0 (* x x))))))

(defun ss-acos (x)
  (if (>= x 1.0) 0.0
    (if (<= x -1.0) pi
      (atan (sqrt (- 1.0 (* x x))) x))))

(defun ss-solar-pos (lat hour dec / lat-r dec-r ha-r alt-r az-num az-den az-r alt-d az-d)
  (setq lat-r (ss-dtr lat)
        dec-r (ss-dtr dec)
        ha-r  (ss-dtr (* (- hour 12.0) 15.0)))
  (setq alt-r (ss-asin (+ (* (sin lat-r) (sin dec-r))
                           (* (cos lat-r) (cos dec-r) (cos ha-r)))))
  (setq alt-d (ss-rtd alt-r))
  (setq az-num (- (sin dec-r) (* (sin alt-r) (sin lat-r)))
        az-den (* (cos alt-r) (cos lat-r)))
  (if (> (abs az-den) 1e-10)
    (progn
      (setq az-r (ss-acos (/ az-num az-den))
            az-d (ss-rtd az-r))
      (if (> hour 12.0) (setq az-d (- 360.0 az-d))))
    (setq az-d 180.0))
  (cons alt-d az-d))

(defun ss-collect-tips (base pole-h lat dec time-start time-end time-step
                        / tips t-now sun-pos alt-d az-d shad-len shad-az dx dy tip)
  (setq tips '() t-now time-start)
  (while (<= t-now time-end)
    (setq sun-pos (ss-solar-pos lat t-now dec)
          alt-d   (car sun-pos)
          az-d    (cdr sun-pos))
    (if (> alt-d 0.5)
      (progn
        (setq shad-len (/ pole-h (ss-tan (ss-dtr alt-d)))
              shad-az  (ss-dtr (+ (- 90.0 az-d) 180.0))
              dx       (* shad-len (cos shad-az))
              dy       (* shad-len (sin shad-az))
              tip      (list (+ (car base) dx) (+ (cadr base) dy)))
        (setq tips (append tips (list (cons tip shad-len))))))
    (setq t-now (+ t-now time-step)))
  tips)

(defun ss-setup-layer (lname lcolor-aci)
  (if (not (tblsearch "LAYER" lname))
    (command "_.LAYER" "_Make" lname "_Color" lcolor-aci lname "")
    (command "_.LAYER" "_Thaw" lname "_On" lname "_Unlock" lname "_Set" lname ""))
  (setvar "CLAYER" lname))

(defun ss-setup-layer-rgb (lname rgb-str)
  (if (not (tblsearch "LAYER" lname))
    (command "_.LAYER" "_Make" lname "_Color" "T" rgb-str lname "")
    (command "_.LAYER" "_Thaw" lname "_On" lname "_Unlock" lname "_Set" lname ""))
  (setvar "CLAYER" lname))

(defun ss-set-transparency (ent pct / old_cmdecho)
  (if (and ent pct)
    (progn
      (setq old_cmdecho (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.CHPROP" ent "" "_Transparency" (itoa pct) "")
      (setvar "CMDECHO" old_cmdecho)
      (entupd ent))))

(defun ss-hatch-boundary (boundary-ent pattern scale / doc space hatch arr vobj)
  (vl-load-com)
  (setq doc   (vla-get-activedocument (vlax-get-acad-object))
        space (vla-get-modelspace doc)
        hatch (vla-addHatch space acHatchPatternTypePreDefined pattern :vlax-true))
  (setq vobj (vlax-ename->vla-object boundary-ent))
  (setq arr  (vlax-make-safearray vlax-vbObject '(0 . 0)))
  (vlax-safearray-put-element arr 0 vobj)
  (vla-appendOuterLoop hatch (vlax-make-variant arr))
  (vla-put-PatternScale hatch scale)
  (vla-evaluate hatch)
  (vlax-vla-object->ename hatch))

(defun ss-put-prop (ent code value / edata)
  (setq edata (entget ent))
  (if (assoc code edata)
    (setq edata (subst (cons code value) (assoc code edata) edata))
    (setq edata (append edata (list (cons code value)))))
  (entmod edata)
  (entupd ent))

(defun ss-cross (o a b)
  (- (* (- (car a) (car o)) (- (cadr b) (cadr o)))
     (* (- (cadr a) (cadr o)) (- (car b) (car o)))))

(defun ss-sort-pts (pts)
  (vl-sort pts (function (lambda (a b)
    (if (= (car a) (car b)) (< (cadr a) (cadr b)) (< (car a) (car b)))))))

(defun ss-remove-dups (pts / result p found)
  (setq result '())
  (foreach p pts
    (setq found nil)
    (foreach r result
      (if (and (< (abs (- (car p) (car r))) 0.001)
               (< (abs (- (cadr p) (cadr r))) 0.001))
        (setq found T)))
    (if (not found) (setq result (append result (list p)))))
  result)

(defun ss-convex-hull (pts / sorted n lower upper i p)
  (setq pts (ss-remove-dups pts))
  (if (<= (length pts) 2) pts
    (progn
      (setq sorted (ss-sort-pts pts) n (length sorted) lower '() i 0)
      (while (< i n)
        (setq p (nth i sorted))
        (while (and (>= (length lower) 2)
                    (<= (ss-cross (nth (- (length lower) 2) lower)
                                  (nth (- (length lower) 1) lower) p) 0))
          (setq lower (reverse (cdr (reverse lower)))))
        (setq lower (append lower (list p)) i (1+ i)))
      (setq upper '() i (1- n))
      (while (>= i 0)
        (setq p (nth i sorted))
        (while (and (>= (length upper) 2)
                    (<= (ss-cross (nth (- (length upper) 2) upper)
                                  (nth (- (length upper) 1) upper) p) 0))
          (setq upper (reverse (cdr (reverse upper)))))
        (setq upper (append upper (list p)) i (1- i)))
      (setq lower (reverse (cdr (reverse lower)))
            upper (reverse (cdr (reverse upper))))
      (append lower upper))))

;;;------------------------------------------------------------
;;; AUTOSTRING  Automatic inverter color-coding of table blocks
;;; Commands: AUTOSTRING     (auto-group tables by inverter and color)
;;;           CLEARSTRINGING (remove all inverter hatches and labels)
;;;
;;; Coloring method: solid semi-transparent HATCH per table, sent to the
;;; back of draw order so module lines (white) remain visible on top.
;;;------------------------------------------------------------

;; Draw per-stack-row hatches so only the actual module area is colored,
;; leaving the inter-row gap (m_gap_v) dark.
;; Uses module geometry globals set by AUTOSTRINGDIALOG from XDATA.
;; Draw one hatch per individual module cell  colors only the module rectangles,
;; leaving all gaps (inter-module and inter-stack) as empty dark space.
(defun StrHatchModuleRows (tbl_ename color_aci /
                            ins_pt ix iy
                            p_w p_h tilt tilt_rad actual_w actual_h mh_proj
                            mod_row mod_stk m_gap_h m_gap_v gap_v_proj y_start
                            j k mx1 my1 mx2 my2)
  (setq p_w     (if (and (boundp '*asd-xd-pw*)   (> *asd-xd-pw*   0.0)) *asd-xd-pw*   1.13)
        p_h     (if (and (boundp '*asd-xd-ph*)   (> *asd-xd-ph*   0.0)) *asd-xd-ph*   2.25)
        tilt    (if (boundp '*asd-xd-tilt*) *asd-xd-tilt* 23.5)
        mod_row (if (and (boundp '*asd-mod-row*) (> *asd-mod-row* 0)) *asd-mod-row* 1)
        mod_stk (if (and (boundp '*asd-mod-stk*) (> *asd-mod-stk* 0)) *asd-mod-stk* 1)
        m_gap_h (if (boundp '*asd-xd-mgh*) *asd-xd-mgh* 0.03)
        m_gap_v (if (boundp '*asd-xd-mgv*) *asd-xd-mgv* 0.02))
  ;; Actual module dimensions by orientation
  (if (and (boundp '*asd-xd-ori*) (= *asd-xd-ori* 2.0))
    (setq actual_w p_h  actual_h p_w)
    (setq actual_w p_w  actual_h p_h))
  ;; Projected dimensions  match DefineTableBlock geometry exactly:
  ;; y-step = (h + gap_v) * cos(tilt), bottom row origin = iy - (stacks-1)*gap_v*cos(tilt)
  (setq tilt_rad   (* tilt (/ pi 180.0))
        mh_proj    (* actual_h (cos tilt_rad))
        gap_v_proj (* m_gap_v  (cos tilt_rad)))
  ;; Insertion point of the table INSERT
  (setq ins_pt (cdr (assoc 10 (entget tbl_ename)))
        ix     (car  ins_pt)
        iy     (cadr ins_pt))
  ;; Bottom-row y-origin (matches block m_base for r = mod_stk-1)
  (setq y_start (- iy (* (1- mod_stk) gap_v_proj)))
  ;; Draw one outline rectangle per module cell (row j from bottom, column k from left)
  (setq j 0)
  (repeat mod_stk
    (setq k 0)
    (repeat mod_row
      (setq mx1 (+ ix (* k (+ actual_w m_gap_h)))
            my1 (+ y_start (* j (+ mh_proj gap_v_proj)))
            mx2 (+ mx1 actual_w)
            my2 (+ my1 mh_proj))
      (StrHatchTable mx1 my1 mx2 my2 color_aci)
      (setq k (1+ k)))
    (setq j (1+ j))))

;; Draw one light transparent solid hatch over a table bounding box,
;; then keep the colored outline on top so the grouping stays readable.
(defun StrHatchTable (x1 y1 x2 y2 color_aci / poly_ent hatch_ent old_cmdecho)
  (setq old_cmdecho (getvar "CMDECHO"))
  ;; Draw a colored outline rectangle.
  (setq poly_ent
    (entmakex
      (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
            '(8 . "STRINGING") (cons 62 color_aci)
            '(100 . "AcDbPolyline") '(90 . 4) '(70 . 1)
            (cons 10 (list x1 y1)) (cons 10 (list x2 y1))
            (cons 10 (list x2 y2)) (cons 10 (list x1 y2)))))
  (if poly_ent
    (progn
      ;; Light same-color hatch behind the outline.
      (setq hatch_ent (ss-hatch-boundary poly_ent "SOLID" 1.0))
      (if hatch_ent
        (progn
          (ss-put-prop hatch_ent 8 "STRINGING")
          (ss-put-prop hatch_ent 62 color_aci)
          (ss-set-transparency hatch_ent 75)
          (setvar "CMDECHO" 0)
          (command "_.DRAWORDER" (ssadd hatch_ent) "" "_Back")))
      (setvar "CMDECHO" 0)
      (command "_.DRAWORDER" (ssadd poly_ent) "" "_Front")
      (setvar "CMDECHO" old_cmdecho)
      poly_ent)))

(defun sp-sort-tables-top-left (tables /)
  (if tables
    (vl-sort tables
      (function (lambda (a b / pa pb)
        (setq pa (cdr (assoc 10 (entget a)))
              pb (cdr (assoc 10 (entget b))))
        (if (> (abs (- (cadr pa) (cadr pb))) 0.5)
          (> (cadr pa) (cadr pb))
          (< (car pa) (car pb))))))
    nil))

(defun sp-table-record (ename / bmin bmax)
  (vla-getboundingbox (vlax-ename->vla-object ename) 'bmin 'bmax)
  (setq bmin (vlax-safearray->list bmin)
        bmax (vlax-safearray->list bmax))
  (list
    (cons 'ename ename)
    (cons 'minx (car bmin))
    (cons 'miny (cadr bmin))
    (cons 'maxx (car bmax))
    (cons 'maxy (cadr bmax))
    (cons 'cx (/ (+ (car bmin) (car bmax)) 2.0))
    (cons 'cy (/ (+ (cadr bmin) (cadr bmax)) 2.0))))

(defun sp-rec-get (rec key)
  (cdr (assoc key rec)))

(defun sp-rec-put (rec key val)
  (cons (cons key val)
        (vl-remove-if
          (function (lambda (x) (= (car x) key)))
          rec)))

(defun sp-build-group-counts (total num_inv / base rem i counts)
  (setq base (fix (/ total num_inv))
        rem  (- total (* base num_inv))
        i    1
        counts nil)
  (repeat num_inv
    (setq counts (append counts (list (if (<= i rem) (1+ base) base))))
    (setq i (1+ i)))
  counts)

(defun sp-rec-top-left-less (ra rb)
  (if (> (abs (- (sp-rec-get ra 'cy) (sp-rec-get rb 'cy))) 0.5)
    (> (sp-rec-get ra 'cy) (sp-rec-get rb 'cy))
    (< (sp-rec-get ra 'cx) (sp-rec-get rb 'cx))))

(defun sp-pick-top-left-rec (recs / best)
  (setq best (car recs))
  (foreach r (cdr recs)
    (if (sp-rec-top-left-less r best)
      (setq best r)))
  best)

(defun sp-rec-distance (ra rb / dx dy)
  (setq dx (- (sp-rec-get ra 'cx) (sp-rec-get rb 'cx))
        dy (- (sp-rec-get ra 'cy) (sp-rec-get rb 'cy)))
  (sqrt (+ (* dx dx) (* dy dy))))

(defun sp-group-centroid (group / sx sy n)
  (setq sx 0.0 sy 0.0 n 0)
  (foreach r group
    (setq sx (+ sx (sp-rec-get r 'cx))
          sy (+ sy (sp-rec-get r 'cy))
          n  (1+ n)))
  (if (> n 0)
    (list (/ sx n) (/ sy n))
    '(0.0 0.0)))

(defun sp-assign-grid-indices (recs / sorted rows cur_row cur_y tol row_idx out col_idx row_list r)
  (setq sorted (vl-sort recs 'sp-rec-top-left-less)
        rows   nil
        cur_row nil
        cur_y  nil
        tol    0.5)
  (foreach r sorted
    (if (or (null cur_y) (> (abs (- (sp-rec-get r 'cy) cur_y)) tol))
      (progn
        (if cur_row
          (setq rows (append rows (list (vl-sort cur_row 'sp-rec-top-left-less)))))
        (setq cur_row (list r)
              cur_y   (sp-rec-get r 'cy)))
      (setq cur_row (append cur_row (list r)))))
  (if cur_row
    (setq rows (append rows (list (vl-sort cur_row 'sp-rec-top-left-less)))))
  (setq row_idx 0
        out     nil)
  (foreach row_list rows
    (setq col_idx 0)
    (foreach r row_list
      (setq out
            (append out
                    (list
                      (sp-rec-put
                        (sp-rec-put r 'row row_idx)
                        'col col_idx))))
      (setq col_idx (1+ col_idx)))
    (setq row_idx (1+ row_idx)))
  out)

(defun sp-grid-bounds (group / minr maxr minc maxc)
  (if group
    (progn
      (setq minr (sp-rec-get (car group) 'row)
            maxr minr
            minc (sp-rec-get (car group) 'col)
            maxc minc)
      (foreach r (cdr group)
        (if (< (sp-rec-get r 'row) minr) (setq minr (sp-rec-get r 'row)))
        (if (> (sp-rec-get r 'row) maxr) (setq maxr (sp-rec-get r 'row)))
        (if (< (sp-rec-get r 'col) minc) (setq minc (sp-rec-get r 'col)))
        (if (> (sp-rec-get r 'col) maxc) (setq maxc (sp-rec-get r 'col))))
      (list minr maxr minc maxc))
    '(0 0 0 0)))

(defun sp-grid-area (bounds)
  (* (1+ (- (nth 1 bounds) (nth 0 bounds)))
     (1+ (- (nth 3 bounds) (nth 2 bounds)))))

(defun sp-grid-adj-distance (cand group / best dist)
  (setq best nil)
  (foreach r group
    (setq dist (+ (abs (- (sp-rec-get cand 'row) (sp-rec-get r 'row)))
                  (abs (- (sp-rec-get cand 'col) (sp-rec-get r 'col)))))
    (if (or (null best) (< dist best))
      (setq best dist)))
  (if best best 9999))

(defun sp-grid-bbox-score (cand group / oldb newb olda newa minr maxr minc maxc)
  (setq oldb (sp-grid-bounds group)
        olda (sp-grid-area oldb)
        minr (min (nth 0 oldb) (sp-rec-get cand 'row))
        maxr (max (nth 1 oldb) (sp-rec-get cand 'row))
        minc (min (nth 2 oldb) (sp-rec-get cand 'col))
        maxc (max (nth 3 oldb) (sp-rec-get cand 'col))
        newb (list minr maxr minc maxc)
        newa (sp-grid-area newb))
  (- newa olda))

(defun sp-pick-compact-next-grid (group recs / ctr best best_score cand adj bbox dx dy score)
  (setq ctr (sp-group-centroid group)
        best nil
        best_score nil)
  (foreach cand recs
    (setq adj  (sp-grid-adj-distance cand group)
          bbox (sp-grid-bbox-score cand group)
          dx   (- (sp-rec-get cand 'cx) (car ctr))
          dy   (- (sp-rec-get cand 'cy) (cadr ctr))
          score (+ (* 10000 adj)
                   (* 100 bbox)
                   (sqrt (+ (* dx dx) (* dy dy)))))
    (if (or (null best_score)
            (< score best_score)
            (and (= score best_score) (sp-rec-top-left-less cand best)))
      (setq best cand
            best_score score)))
  best)

(defun sp-pick-compact-next (group recs / ctr best best_score score nearest dx dy cand)
  (setq ctr (sp-group-centroid group)
        best nil
        best_score nil)
  (foreach cand recs
    (setq nearest nil)
    (foreach r group
      (setq score (sp-rec-distance cand r))
      (if (or (null nearest) (< score nearest))
        (setq nearest score)))
    (setq dx (- (sp-rec-get cand 'cx) (car ctr))
          dy (- (sp-rec-get cand 'cy) (cadr ctr))
          score (+ (* 0.60 nearest) (* 0.40 (sqrt (+ (* dx dx) (* dy dy))))))
    (if (or (null best_score)
            (< score best_score)
            (and (= score best_score) (sp-rec-top-left-less cand best)))
      (setq best cand
            best_score score)))
  best)

(defun sp-remove-rec (target recs)
  (vl-remove-if
    (function (lambda (r) (= (sp-rec-get r 'ename) (sp-rec-get target 'ename))))
    recs))

(defun sp-build-linear-groups (tables counts / groups start take)
  (setq groups nil
        start  0)
  (foreach take counts
    (setq groups
          (append groups
                  (list
                    (if (> take 0)
                      (progn
                        (setq sp-sub nil
                              sp-k   0)
                        (repeat take
                          (setq sp-sub (append sp-sub (list (nth (+ start sp-k) tables))))
                          (setq sp-k (1+ sp-k)))
                        (vl-remove nil sp-sub))
                      nil))))
    (setq start (+ start take)))
  groups)

(defun sp-build-compact-groups (tables counts / recs groups take seed group next)
  (setq recs   (sp-assign-grid-indices (mapcar 'sp-table-record tables))
        groups nil)
  (foreach take counts
    (if (and recs (> take 0))
      (progn
        (setq seed  (sp-pick-top-left-rec recs)
              group (list seed)
              recs  (sp-remove-rec seed recs))
        (while (and (< (length group) take) recs)
          (setq next  (sp-pick-compact-next-grid group recs)
                group (append group (list next))
                recs  (sp-remove-rec next recs)))
        (setq groups
              (append groups
                      (list
                        (mapcar '(lambda (r) (sp-rec-get r 'ename))
                                (vl-sort group 'sp-rec-top-left-less))))))
      (setq groups (append groups (list nil)))))
  groups)

(defun sp-put-inverter-group-xdata (ename inv_idx inv_name / ed)
  (if (not (tblsearch "APPID" "FS_INV_GROUP")) (regapp "FS_INV_GROUP"))
  (setq ed (entget ename '("FS_INV_GROUP")))
  (if (assoc -3 ed)
    (setq ed (vl-remove (assoc -3 ed) ed)))
  (entmod
    (append ed
            (list
              (list -3
                    (list "FS_INV_GROUP"
                          (cons 1070 inv_idx)
                          (cons 1000 inv_name)))))))

(defun sp-get-inverter-group-index (ename / xdata app vals hit)
  (setq xdata (cdr (assoc -3 (entget ename '("FS_INV_GROUP")))))
  (if (and xdata (= (caar xdata) "FS_INV_GROUP"))
    (progn
      (setq vals (cdar xdata)
            hit  (assoc 1070 vals))
      (if hit (cdr hit) nil))
    nil))

(defun sp-alist-push (key val alist / hit)
  (setq hit (assoc key alist))
  (if hit
    (subst (cons key (cons val (cdr hit))) hit alist)
    (cons (cons key (list val)) alist)))

(defun sp-build-groups-from-xdata (tables num_inv / alist idx ok i out)
  (setq alist nil
        ok    T)
  (foreach en tables
    (setq idx (sp-get-inverter-group-index en))
    (if (and idx (>= idx 1) (<= idx num_inv))
      (setq alist (sp-alist-push idx en alist))
      (setq ok nil)))
  (if ok
    (progn
      (setq i 1 out nil)
      (repeat num_inv
        (setq out (append out (list (sp-sort-tables-top-left (reverse (cdr (assoc i alist)))))))
        (setq i (1+ i)))
      out)
    nil))

(defun c:AUTOSTRING (/ ent xdata xd p_watt mod_in_row mod_in_stack
                       modules_per_table mods_per_string strings_per_inv
                       tables_per_string tables_per_inv num_inv
                       ss idx ename edata blk_name ins_pt bmin_e bmax_e
                       all_tables total_tables sorted_tables group_counts grouped_tables
                       grouping_mode this_group this_inv_tables
                       i j color inv_list
                       total_x total_y cnt lbl_x lbl_y text_h
                       inv_colors color_names old_cmdecho inv_place
                       total_ac_kw elec_edata
                       inv_box_w inv_box_h inv_txt_h)
  (vl-load-com)
  (setq old_cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)

  ;; Ensure STRINGING layer
  (if (not (tblsearch "LAYER" "STRINGING"))
    (command "_.LAYER" "_New" "STRINGING" "_Color" "7" "STRINGING" ""))

  ;; Read module data  from dialog globals if available, else auto-detect boundary
  (if (and (boundp '*asd-run*) *asd-run*
           (boundp '*asd-bnd-ent*) *asd-bnd-ent*)
    (setq ent *asd-bnd-ent*)
    (progn
      ;; Auto-detect: if exactly one SolarPro boundary exists, use it silently
      (setq as-bnds (asd-find-boundaries))
      (cond
        ((= (length as-bnds) 1)
         (setq ent (car as-bnds))
         (princ "\nBoundary detected automatically."))
        ((> (length as-bnds) 1)
         (princ (strcat "\n" (itoa (length as-bnds)) " boundaries found. Select one: "))
         (setq ent (car (entsel)))
         (if (null ent) (progn (setvar "CMDECHO" old_cmdecho) (exit))))
        (T
         (princ "\nSelect boundary polyline: ")
         (setq ent (car (entsel)))
         (if (null ent) (progn (setvar "CMDECHO" old_cmdecho) (exit)))))))
  (setq xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (and xdata (= (caar xdata) "FS_SOLAR_DATA"))
    (progn
      (setq xd             (cdar xdata)
            p_watt         (cdr (nth 2 xd))
            mod_in_row     (fix (cdr (nth 7 xd)))
            mod_in_stack   (fix (cdr (nth 8 xd)))
            placement_type (if (and (nth 12 xd) (= (type (cdr (nth 12 xd))) 'STR))
                             (cdr (nth 12 xd))
                             "Table"))
      (if (or (= placement_type "Continuous") (<= mod_in_row 0))
        (progn
          (princ "\nAUTOSTRING currently supports table-based layouts only.")
          (princ "\nThis boundary was generated in Continuous mode, so no TABLE_* blocks exist to string.")
          (setvar "CMDECHO" old_cmdecho)
          (exit)))
      ;; Also load geometry globals so per-module coloring works
      (setq *asd-mod-row*  mod_in_row
            *asd-mod-stk*  mod_in_stack
            *asd-xd-pw*    (cdr (nth 0  xd))
            *asd-xd-ph*    (cdr (nth 1  xd))
            *asd-xd-tilt*  (cdr (nth 3  xd))
            *asd-xd-ori*   (cdr (nth 9  xd))
            *asd-xd-mgh*   (cdr (nth 10 xd))
            *asd-xd-mgv*   (cdr (nth 11 xd))))
    (progn
      ;; No XDATA  cannot proceed without module data
      (princ "\nERROR: No SolarPro layout data on this boundary.")
      (princ "\nRun SolarProDialog first to generate the layout.")
      (setvar "CMDECHO" old_cmdecho)
      (exit)))
  (setq modules_per_table (* mod_in_row mod_in_stack))
  (princ (strcat "\nTable size: " (itoa mod_in_row) "x" (itoa mod_in_stack)
                 " = " (itoa modules_per_table) " modules/table"))

  ;; String parameters  from dialog globals if available, else ask manually
  (if (and (boundp '*asd-run*) *asd-run*)
    (setq mods_per_string *asd-mps*
          strings_per_inv *asd-spi*
          num_inv         *asd-num-inv*)
    (progn
      (initget 6)
      (setq mods_per_string (getint "\nModules per string (series): "))
      (if (null mods_per_string) (progn (setvar "CMDECHO" old_cmdecho) (exit)))
      (initget 6)
      (setq strings_per_inv (getint "\nStrings per inverter: "))
      (if (null strings_per_inv) (progn (setvar "CMDECHO" old_cmdecho) (exit)))
      (initget 6)
      (setq num_inv (getint "\nNumber of inverters: "))
      (if (null num_inv) (progn (setvar "CMDECHO" old_cmdecho) (exit)))))

  ;; Calculate tables per inverter  handles all three cases:
  ;;   Case A (mps >= mpt): string spans tables   tpi = spi * ceil(mps/mpt)
  ;;   Case B (mps <  mpt, mpt%mps=0): multiple strings/table  tpi = ceil(spi*mps/mpt)
  ;;   (Case C is blocked by dialog before reaching here)
  (setq tables_per_string
        (if (>= mods_per_string modules_per_table)
          (max 1 (fix (+ 0.9999 (/ (float mods_per_string) modules_per_table))))
          1))   ; Case B: colour whole tables, 1 table per colour block
  (setq tables_per_inv
        (if (>= mods_per_string modules_per_table)
          (* strings_per_inv tables_per_string)
          ;; Case B: ceil(spi * mps / mpt)
          (max 1 (fix (+ 0.9999 (/ (* (float strings_per_inv) mods_per_string)
                                    modules_per_table))))))
  (princ (strcat "\nModules/string: " (itoa mods_per_string)
                 "  Table size: " (itoa modules_per_table)
                 "  Tables/inverter: " (itoa tables_per_inv)))

  ;; Collect TABLE_* blocks inside the boundary
  (setq all_tables (GetTablesInBoundary ent))
  (setq total_tables (length all_tables))
  (if (= total_tables 0)
    (progn (princ "\nNo table blocks found.") (setvar "CMDECHO" old_cmdecho) (exit)))
  (princ (strcat "\nTotal tables found: " (itoa total_tables)))

  ;; Sort tables: top row first (Y descending), left to right (X ascending)
  (setq sorted_tables
    (vl-sort all_tables
      (function (lambda (a b)
        (setq ay (cadr (cdr (assoc 10 (entget a))))
              by (cadr (cdr (assoc 10 (entget b)))))
        (if (> (abs (- ay by)) 0.5)
          (> ay by)
          (< (car (cdr (assoc 10 (entget a))))
             (car (cdr (assoc 10 (entget b))))))))))

  ;; ACI colors for inverters
  (setq inv_colors
    '(  1   ; INV-01  Red
        2   ; INV-02  Yellow
        3   ; INV-03  Green
        4   ; INV-04  Cyan
        5   ; INV-05  Blue
        6   ; INV-06  Magenta
       10   ; INV-07  Red-Orange bright
       20   ; INV-08  Orange bright
       30   ; INV-09  Yellow-Orange bright
       40   ; INV-10  Yellow-Green bright
       50   ; INV-11  Lime bright
       60   ; INV-12  Green bright
       70   ; INV-13  Teal bright
       80   ; INV-14  Teal-Cyan bright
       90   ; INV-15  Cyan bright
      100   ; INV-16  Sky-Blue bright
      110   ; INV-17  Blue-Violet bright
      120   ; INV-18  Violet bright
      130   ; INV-19  Purple-Pink bright
      140   ; INV-20  Pink bright
      150   ; INV-21  Rose bright
      160   ; INV-22  Salmon bright
      170   ; INV-23  Peach bright
      180   ; INV-24  Gold bright
      190   ; INV-25  Yellow-Gray bright
      200   ; INV-26  Slate bright
      210   ; INV-27  Lavender bright
      220   ; INV-28  Mauve bright
      230   ; INV-29  Taupe bright
      240   ; INV-30  Cool-Gray bright
       15   ; INV-31  Red-Orange light
       25   ; INV-32  Orange light
       35   ; INV-33  Yellow-Orange light
       45   ; INV-34  Yellow-Green light
       55   ; INV-35  Lime light
       65   ; INV-36  Green light
       75   ; INV-37  Teal light
       85   ; INV-38  Teal-Cyan light
       95   ; INV-39  Cyan light
      105   ; INV-40  Sky-Blue light
      115   ; INV-41  Blue-Violet light
      125   ; INV-42  Violet light
      135   ; INV-43  Purple-Pink light
      145   ; INV-44  Pink light
      155   ; INV-45  Rose light
      165   ; INV-46  Salmon light
      175   ; INV-47  Peach light
      185   ; INV-48  Gold light
      195   ; INV-49  Yellow-Gray light
      205)) ; INV-50  Slate light
  (setq color_names
    '("Red" "Yellow" "Green" "Cyan" "Blue" "Magenta"
      "Red-Orange" "Orange" "Yel-Orange" "Yel-Green"
      "Lime" "Green-B" "Teal" "Teal-Cyan" "Cyan-B"
      "Sky-Blue" "Blu-Violet" "Violet" "Purple-Pink" "Pink"
      "Rose" "Salmon" "Peach" "Gold" "Yel-Gray"
      "Slate" "Lavender" "Mauve" "Taupe" "Cool-Gray"
      "RedOrng-L" "Orange-L" "YelOrng-L" "YelGrn-L" "Lime-L"
      "Green-L" "Teal-L" "TealCyn-L" "Cyan-L" "SkyBlu-L"
      "BluViol-L" "Violet-L" "PurPnk-L" "Pink-L" "Rose-L"
      "Salmon-L" "Peach-L" "Gold-L" "YelGry-L" "Slate-L"))

  ;; Ensure Calibri text style exists for inverter block labels
  (if (not (tblsearch "STYLE" "Calibri"))
    (entmake (list '(0 . "STYLE") '(100 . "AcDbSymbolTableRecord")
                   '(100 . "AcDbTextStyleTableRecord")
                   '(2 . "Calibri") '(70 . 0) '(40 . 0.0) '(41 . 1.0)
                   '(50 . 0.0) '(71 . 0) '(3 . "calibri.ttf") '(4 . ""))))
  ;; Inverter block  fixed dimensions 2.5 wide x 1.6 tall, text height 0.5
  (setq inv_box_w 2.5
        inv_box_h 1.6
        inv_txt_h 0.5
        inv_place (asd-current-inv-placement)
        grouping_mode (if (and (boundp '*asd-s-group-mode*) *asd-s-group-mode*)
                        (asd-current-grouping-mode)
                        "Linear Strip"))

  ;; Build inverter groups.
  (setq group_counts (sp-build-group-counts total_tables num_inv)
        grouped_tables
          (if (= grouping_mode "Compact Block")
            (sp-build-compact-groups sorted_tables group_counts)
            (sp-build-linear-groups sorted_tables group_counts)))
  (setq base_tpi  (fix (/ total_tables num_inv))
        remainder (- total_tables (* base_tpi num_inv)))
  (princ (strcat "\nGrouping mode: " grouping_mode))
  (princ (strcat "\nEqual distribution target: each inverter ~"
                 (itoa base_tpi) "-" (itoa (1+ base_tpi)) " tables"))

  ;; Assign tables to inverters, draw hatches, collect summary data
  (setq i 1  inv_summary nil
        inv_kw_rating (if (and (boundp '*asd-s-inv_kw*) *asd-s-inv_kw*)
                        (atof *asd-s-inv_kw*) 0.0))
  (repeat num_inv
    (setq color           (nth (1- i) inv_colors)
          this_group      (nth (1- i) grouped_tables)
          this_inv_tables (length this_group))
    (if (null color) (setq color 7))
    (if (> this_inv_tables 0)
      (progn
        ;; strings-per-table for label numbering
        (setq spt_local (if (>= mods_per_string modules_per_table) 1
                            (fix (/ modules_per_table mods_per_string))))
        (setq grp_min_x 1e10  grp_max_x -1e10
              grp_min_y 1e10  grp_max_y -1e10
              cnt 0  text_h 2.5
              j   0)
        (foreach ename this_group
          (setq edata (entget ename))
          (vla-getboundingbox (vlax-ename->vla-object ename) 'bmin_e 'bmax_e)
          (setq bmin_e (vlax-safearray->list bmin_e)
                bmax_e (vlax-safearray->list bmax_e))
          ;; Track bounding rectangle of entire inverter group
          (if (< (car  bmin_e) grp_min_x) (setq grp_min_x (car  bmin_e)))
          (if (> (car  bmax_e) grp_max_x) (setq grp_max_x (car  bmax_e)))
          (if (< (cadr bmin_e) grp_min_y) (setq grp_min_y (cadr bmin_e)))
          (if (> (cadr bmax_e) grp_max_y) (setq grp_max_y (cadr bmax_e)))
          (if (= cnt 0)
            (setq text_h (max 1.0 (* (- (cadr bmax_e) (cadr bmin_e)) 0.5))))
          ;; Outline whole table as a block (no individual module cells)
          (StrHatchTable (car bmin_e) (cadr bmin_e)
                         (car bmax_e) (cadr bmax_e) color)
          ;; Per-table string labels  centered inside the table boundary, white
          (setq str_start (1+ (* cnt spt_local))
                lbl_h_s   0.65
                lbl_cx    (/ (+ (car bmin_e) (car bmax_e)) 2.0)
                table_h   (- (cadr bmax_e) (cadr bmin_e))
                table_cy  (/ (+ (cadr bmin_e) (cadr bmax_e)) 2.0)
                lbl_above (+ (cadr bmin_e) (* 0.75 table_h))
                lbl_below (if (> spt_local 1) (+ (cadr bmin_e) (* 0.25 table_h)) table_cy))
          ;; 2 strings: first label in top half, second label in bottom half
          ;; 1 string:  label exactly in center of table
          (if (> spt_local 1)
            ;; Case B  top half label
            (entmake
              (list '(0 . "MTEXT") '(100 . "AcDbEntity")
                    '(8 . "STRINGING") '(62 . 7)
                    '(100 . "AcDbMText")
                    (cons 10 (list lbl_cx lbl_above 0.0))
                    (cons 40 lbl_h_s)
                    (cons 41 (* lbl_h_s 18.0))
                    '(71 . 5)   ; middle-center
                    (cons 1 (strcat "INV-" (itoa i) "-STR-" (itoa str_start)))))
            ;; Case A  single string label in center
            (entmake
              (list '(0 . "MTEXT") '(100 . "AcDbEntity")
                    '(8 . "STRINGING") '(62 . 7)
                    '(100 . "AcDbMText")
                    (cons 10 (list lbl_cx lbl_below 0.0))
                    (cons 40 lbl_h_s)
                    (cons 41 (* lbl_h_s 18.0))
                    '(71 . 5)   ; middle-center
                    (cons 1 (strcat "INV-" (itoa i) "-STR-" (itoa str_start))))))
          ;; Case B second string label  BELOW table
          (if (> spt_local 1)
            (entmake
              (list '(0 . "MTEXT") '(100 . "AcDbEntity")
                    '(8 . "STRINGING") '(62 . 7)
                    '(100 . "AcDbMText")
                    (cons 10 (list lbl_cx lbl_below 0.0))
                    (cons 40 lbl_h_s)
                    (cons 41 (* lbl_h_s 18.0))
                    '(71 . 5)   ; middle-center
                    (cons 1 (strcat "INV-" (itoa i) "-STR-" (itoa (1+ str_start)))))))
          (sp-put-inverter-group-xdata ename i (strcat "INV-" (itoa i)))
          (setq cnt (1+ cnt)
                j   (1+ j)))
        ;; Inverter Block: colored rectangle (1.8 x 1.0 scaled) centred at table-group centroid
        ;; Contains "INV-X" white text. Brackets and string count removed.
        (if (> cnt 0)
          (progn
            (setq lbl_x (cond
                          ((= inv_place "Left")  (+ grp_min_x (/ inv_box_w 2.0)))
                          ((= inv_place "Right") (- grp_max_x (/ inv_box_w 2.0)))
                          (T (/ (+ grp_min_x grp_max_x) 2.0)))
                  raw_lbl_y (/ (+ grp_min_y grp_max_y) 2.0)
                  best_dist 1e10
                  lbl_y raw_lbl_y)
            ;; Snap Inverter label Y to the nearest table row to avoid floating in empty aisles
            (foreach tbl this_group
              (vla-getboundingbox (vlax-ename->vla-object tbl) 'bmin_t 'bmax_t)
              (setq t_cy (/ (+ (cadr (vlax-safearray->list bmin_t))
                               (cadr (vlax-safearray->list bmax_t))) 2.0)
                    dist (abs (- t_cy raw_lbl_y)))
              (if (< dist best_dist)
                (setq best_dist dist
                      lbl_y t_cy)))
            ;; Colored border rectangle
            (entmakex
              (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                    '(8 . "STRINGING") (cons 62 color)
                    '(100 . "AcDbPolyline") '(90 . 4) '(70 . 1)
                    (cons 10 (list (- lbl_x (/ inv_box_w 2.0))
                                   (- lbl_y (/ inv_box_h 2.0))))
                    (cons 10 (list (+ lbl_x (/ inv_box_w 2.0))
                                   (- lbl_y (/ inv_box_h 2.0))))
                    (cons 10 (list (+ lbl_x (/ inv_box_w 2.0))
                                   (+ lbl_y (/ inv_box_h 2.0))))
                    (cons 10 (list (- lbl_x (/ inv_box_w 2.0))
                                   (+ lbl_y (/ inv_box_h 2.0))))))
            ;; "INV-X" white text  Calibri 0.5, middle-centre inside box
            (entmake
              (list '(0 . "MTEXT") '(100 . "AcDbEntity")
                    '(8 . "STRINGING") '(62 . 7)
                    '(100 . "AcDbMText")
                    (cons 10 (list lbl_x lbl_y 0.0))
                    (cons 40 inv_txt_h)
                    (cons 41 (* inv_box_w 0.9))
                    '(7 . "Calibri")   ; Calibri text style
                    '(71 . 5)
                    (cons 1 (strcat "INV-" (itoa i)))))))
        ;; Collect summary row  string count works for both Case A and Case B
        (setq this_modules  (* this_inv_tables modules_per_table)
              this_strings  (fix (/ this_modules mods_per_string))
              this_dc_kwp   (/ (* this_modules p_watt) 1000.0)
              this_loading  (if (> inv_kw_rating 0.0)
                              (* 100.0 (/ this_dc_kwp inv_kw_rating)) 0.0))
        (setq inv_summary
              (append inv_summary
                (list (list (strcat "INV-" (itoa i))  ; 0 inverter name
                            (itoa mods_per_string)     ; 1 string size
                            (itoa this_strings)        ; 2 no of strings
                            (itoa this_modules)        ; 3 modules/inverter
                            (itoa (fix p_watt))        ; 4 module wattage Wp
                            (rtos this_dc_kwp 2 1)     ; 5 DC kWp
                            (rtos inv_kw_rating 2 1)   ; 6 inverter rated kW
                            this_loading))))))
    (setq i (1+ i)))

  ;; Draw the inverter summary table next to the report tables
  (if (and ent inv_summary)
    (DrawInverterSummaryTable ent inv_summary))

  ;; Store total AC capacity in boundary XDATA so REFRESH can display it
  (if (and ent (> inv_kw_rating 0.0))
    (progn
      (setq total_ac_kw (* num_inv inv_kw_rating))
      (if (not (tblsearch "APPID" "FS_SOLAR_ELEC")) (regapp "FS_SOLAR_ELEC"))
      (setq elec_edata (entget ent '("FS_SOLAR_ELEC")))
      (if (assoc -3 elec_edata)
        (setq elec_edata (vl-remove (assoc -3 elec_edata) elec_edata)))
      (entmod (append elec_edata
                      (list (list -3 (list "FS_SOLAR_ELEC"
                                          (cons 1040 total_ac_kw))))))))

  (setvar "CMDECHO" old_cmdecho)
  (princ (strcat "\nAuto stringing complete  "
                 (itoa num_inv) " inverters, ~"
                 (itoa base_tpi) "-" (itoa (1+ base_tpi)) " tables each."))
  (princ (strcat "\nUse CLEARSTRINGING to remove."))
  (princ))

;;;------------------------------------------------------------
;;; Inverter Summary Table
;;; Columns: INV NO | STR SIZE | STRINGS | MOD/INV | MOD Wp |
;;;          DC kWp | INV kW | LOADING% | No.INV
;;; - Header row is 2 height with 2-line MTEXT headers (\P separator)
;;; - Loading color-coded: green 110%, orange 111-130%, red >130%
;;; - All entities on STRINGING layer  deleted by CLEARSTRINGING
;;;------------------------------------------------------------
(defun DrawInverterSummaryTable (bnd_ent rows /
        metrics scale row_h hdr_h text_h sno_w title_h title_gap table_gap base_pt
        cw1 cw2 cw3 cw4 cw5 cw6 cw7 cw8 cw9 total_w
        x y pad_x pad_y y_bottom cur_y idx row
        c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 gold
        tot_mod tot_dc tot_ac tot_inv loading_pct loading_str
        tot_loading_pct tot_loading_str)
  (EnsureReportTextStyle)
  (setq metrics   (GetReportMetrics bnd_ent)
        base_pt   (nth 0 metrics)
        row_h     (nth 1 metrics)
        text_h    (nth 2 metrics)
        sno_w     (nth 3 metrics)
        title_h   (nth 6 metrics)
        title_gap (nth 7 metrics)
        table_gap (nth 8 metrics)
        scale     (/ row_h 10.0)
        hdr_h     (* row_h 2.0))   ; header row is 2 tall for 2-line text
  ;; Column widths  wide enough so header text fits without overflow
  (setq cw1 (* 30.0 scale)   ; INVERTER NO
        cw2 (* 28.0 scale)   ; STRING SIZE
        cw3 (* 28.0 scale)   ; NO OF STRING
        cw4 (* 30.0 scale)   ; MOD/INVERTER
        cw5 (* 28.0 scale)   ; MOD WATTAGE
        cw6 (* 30.0 scale)   ; INV POWER kWp
        cw7 (* 30.0 scale)   ; INV OUTPUT kW
        cw8 (* 28.0 scale)   ; INV LOADING
        cw9 (* 24.0 scale)   ; NO OF INV
        total_w (+ cw1 cw2 cw3 cw4 cw5 cw6 cw7 cw8 cw9))
  ;; Position: Below the existing report tables to avoid overlap
  (setq x       (car base_pt)
        y       (- (cadr base_pt) (* 21.0 row_h))
        pad_x   (max 1.0 (* text_h 0.4))
        pad_y   (max 0.8 (* text_h 0.4))
        ;; hdr_h + (data rows + total row)  row_h
        y_bottom (- y hdr_h (* row_h (1+ (length rows))))
        gold    13158701)
  ;; Column x-offsets
  (setq c1  x
        c2  (+ c1 cw1)  c3  (+ c2 cw2)  c4  (+ c3 cw3)
        c5  (+ c4 cw4)  c6  (+ c5 cw5)  c7  (+ c6 cw6)
        c8  (+ c7 cw7)  c9  (+ c8 cw8)  c10 (+ c9 cw9))
  ;; Title above table
  (StrDrawMText (list x (+ y title_gap) 0.0) total_w "INVERTER SCHEDULE" title_h gold)
  ;; Outer border
  (StrDrawLine (list x y 0.0)        (list c10 y 0.0))
  (StrDrawLine (list x y_bottom 0.0) (list c10 y_bottom 0.0))
  (StrDrawLine (list x y 0.0)        (list x y_bottom 0.0))
  (StrDrawLine (list c10 y 0.0)      (list c10 y_bottom 0.0))
  ;; Internal vertical dividers (full height)
  (foreach cx (list c2 c3 c4 c5 c6 c7 c8 c9)
    (StrDrawLine (list cx y 0.0) (list cx y_bottom 0.0)))
  ;; Horizontal line below header (taller header row)
  (StrDrawLine (list x (- y hdr_h) 0.0) (list c10 (- y hdr_h) 0.0))
  ;; Horizontal lines for data rows
  (setq cur_y (- y hdr_h row_h))
  (while (> cur_y y_bottom)
    (StrDrawLine (list x cur_y 0.0) (list c10 cur_y 0.0))
    (setq cur_y (- cur_y row_h)))
  ;; 2-line header text (\\P = MTEXT paragraph break)
  (setq cur_y (- y pad_y))
  (StrDrawMText (list (+ c1 pad_x) cur_y 0.0) (- cw1 (* 2 pad_x)) "INVERTER\\PNO"      text_h gold)
  (StrDrawMText (list (+ c2 pad_x) cur_y 0.0) (- cw2 (* 2 pad_x)) "STRING\\PSIZE"      text_h gold)
  (StrDrawMText (list (+ c3 pad_x) cur_y 0.0) (- cw3 (* 2 pad_x)) "NO OF\\PSTRING"     text_h gold)
  (StrDrawMText (list (+ c4 pad_x) cur_y 0.0) (- cw4 (* 2 pad_x)) "MOD /\\PINVERTER"   text_h gold)
  (StrDrawMText (list (+ c5 pad_x) cur_y 0.0) (- cw5 (* 2 pad_x)) "MODULE\\PWATTAGE"   text_h gold)
  (StrDrawMText (list (+ c6 pad_x) cur_y 0.0) (- cw6 (* 2 pad_x)) "INVERTER\\PPOWER kWp" text_h gold)
  (StrDrawMText (list (+ c7 pad_x) cur_y 0.0) (- cw7 (* 2 pad_x)) "INV OUTPUT\\P(kW)"  text_h gold)
  (StrDrawMText (list (+ c8 pad_x) cur_y 0.0) (- cw8 (* 2 pad_x)) "INV\\PLOADING"      text_h gold)
  (StrDrawMText (list (+ c9 pad_x) cur_y 0.0) (- cw9 (* 2 pad_x)) "No. of\\PINV"       text_h gold)
  ;; Data rows + accumulate totals
  (setq idx 1  cur_y (- y hdr_h pad_y)
        tot_mod 0  tot_dc 0.0  tot_ac 0.0  tot_inv 0)
  (foreach row rows
    (setq loading_pct (nth 7 row)
          loading_str (strcat (itoa (fix (+ 0.5 loading_pct))) "%"))
    ;; Color code the loading using MTEXT inline color: green/orange/red
    (setq loading_str
      (cond ((> loading_pct 140.0) (strcat "{\\C1;" loading_str "}"))   ; red
            ((> loading_pct 120.0) (strcat "{\\C30;" loading_str "}"))  ; orange
            (T                     (strcat "{\\C3;" loading_str "}"))))  ; green
    (StrDrawMText (list (+ c1 pad_x) cur_y 0.0) (- cw1 (* 2 pad_x)) (nth 0 row)   text_h gold)
    (StrDrawMText (list (+ c2 pad_x) cur_y 0.0) (- cw2 (* 2 pad_x)) (nth 1 row)   text_h gold)
    (StrDrawMText (list (+ c3 pad_x) cur_y 0.0) (- cw3 (* 2 pad_x)) (nth 2 row)   text_h gold)
    (StrDrawMText (list (+ c4 pad_x) cur_y 0.0) (- cw4 (* 2 pad_x)) (nth 3 row)   text_h gold)
    (StrDrawMText (list (+ c5 pad_x) cur_y 0.0) (- cw5 (* 2 pad_x)) (nth 4 row)   text_h gold)
    (StrDrawMText (list (+ c6 pad_x) cur_y 0.0) (- cw6 (* 2 pad_x)) (nth 5 row)   text_h gold)
    (StrDrawMText (list (+ c7 pad_x) cur_y 0.0) (- cw7 (* 2 pad_x)) (nth 6 row)   text_h gold)
    (StrDrawMText (list (+ c8 pad_x) cur_y 0.0) (- cw8 (* 2 pad_x)) loading_str   text_h gold)
    (StrDrawMText (list (+ c9 pad_x) cur_y 0.0) (- cw9 (* 2 pad_x)) "1"           text_h gold)
    ;; Accumulate totals
    (setq tot_mod (+ tot_mod (atoi (nth 3 row)))
          tot_dc  (+ tot_dc  (atof (nth 5 row)))
          tot_ac  (+ tot_ac  (atof (nth 6 row)))
          tot_inv (1+ tot_inv)
          idx     (1+ idx)
          cur_y   (- cur_y row_h)))
  ;; Total row
  (setq tot_loading_pct (if (> tot_ac 0.0) (* 100.0 (/ tot_dc tot_ac)) 0.0)
        tot_loading_str (strcat (itoa (fix (+ 0.5 tot_loading_pct))) "%")
        tot_loading_str
          (cond ((> tot_loading_pct 140.0) (strcat "{\\C1;" tot_loading_str "}"))
                ((> tot_loading_pct 120.0) (strcat "{\\C30;" tot_loading_str "}"))
                (T                         (strcat "{\\C3;" tot_loading_str "}"))))
  (StrDrawMText (list (+ c1 pad_x) cur_y 0.0) (- cw1 (* 2 pad_x)) "TOTAL"                  text_h gold)
  (StrDrawMText (list (+ c2 pad_x) cur_y 0.0) (- cw2 (* 2 pad_x)) "-"                       text_h gold)
  (StrDrawMText (list (+ c3 pad_x) cur_y 0.0) (- cw3 (* 2 pad_x)) "-"                       text_h gold)
  (StrDrawMText (list (+ c4 pad_x) cur_y 0.0) (- cw4 (* 2 pad_x)) (itoa tot_mod)            text_h gold)
  (StrDrawMText (list (+ c5 pad_x) cur_y 0.0) (- cw5 (* 2 pad_x)) "-"                       text_h gold)
  (StrDrawMText (list (+ c6 pad_x) cur_y 0.0) (- cw6 (* 2 pad_x)) (rtos tot_dc 2 1)         text_h gold)
  (StrDrawMText (list (+ c7 pad_x) cur_y 0.0) (- cw7 (* 2 pad_x)) (rtos tot_ac 2 1)         text_h gold)
  (StrDrawMText (list (+ c8 pad_x) cur_y 0.0) (- cw8 (* 2 pad_x)) tot_loading_str           text_h gold)
  (StrDrawMText (list (+ c9 pad_x) cur_y 0.0) (- cw9 (* 2 pad_x)) (itoa tot_inv)            text_h gold))

(defun StrDrawLine (p1 p2)
  (entmakex (list '(0 . "LINE") '(8 . "STRINGING")
                  (cons 420 13158701) (cons 10 p1) (cons 11 p2))))

(defun StrDrawMText (pt width txt h true_color)
  (entmakex (list '(0 . "MTEXT") '(100 . "AcDbEntity") '(8 . "STRINGING")
                  (cons 420 true_color) '(100 . "AcDbMText")
                  (cons 10 pt) (cons 40 h) (cons 41 width)
                  '(71 . 1) '(72 . 1) '(7 . "REPORT_STD") (cons 1 txt))))

(defun c:CLEARSTRINGING (/ ss idx ename removed)
  (setq ss (ssget "_X" '((8 . "STRINGING")))
        removed 0)
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ename (ssname ss idx))
        ;; Skip the boundary polyline  it carries FS_SOLAR_DATA XDATA
        (if (null (cdr (assoc -3 (entget ename '("FS_SOLAR_DATA")))))
          (progn (entdel ename) (setq removed (1+ removed))))
        (setq idx (1+ idx)))
      (princ (strcat "\nRemoved " (itoa removed) " stringing entities.")))
    (princ "\nNo stringing entities found."))
  (princ))

;;;------------------------------------------------------------
;;; DC STRINGING SYSTEM
;;; Command: DCSTRINGING   draw U-shape series wiring on all tables
;;; Command: CLEARDCSTRINGING  remove all DC stringing entities
;;; Layer: DC_STRINGING (separate from STRINGING)
;;;------------------------------------------------------------

;;; --- Helper: draw a thick LWPOLYLINE on DC_STRINGING layer (width 0.07) ---
(defun DrawDCLine (p1 p2 aci_color)
  (entmakex (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                  '(8 . "DC_STRINGING") (cons 62 aci_color)
                  '(100 . "AcDbPolyline") '(90 . 2) '(70 . 0)
                  '(43 . 0.07)   ; global width
                  (cons 10 (list (car p1) (cadr p1)))
                  (cons 10 (list (car p2) (cadr p2))))))

;;; --- Helper: draw a circle on DC_STRINGING layer ---
(defun DrawDCCircle (cx cy r aci_color)
  (entmakex (list '(0 . "CIRCLE") '(8 . "DC_STRINGING")
                  (cons 62 aci_color)
                  (cons 10 (list cx cy 0.0))
                  (cons 40 r))))

;;; --- Helper: circle + symbol text (+ or -) terminal marker ---
(defun DrawDCTerminal (cx cy r symbol aci_color)
  (DrawDCCircle cx cy r aci_color)
  (entmake (list '(0 . "MTEXT") '(100 . "AcDbEntity")
                 '(8 . "DC_STRINGING") (cons 62 aci_color)
                 '(100 . "AcDbMText")
                 (cons 10 (list cx cy 0.0))
                 (cons 40 (* r 1.4))
                 (cons 41 (* r 3.0))
                 '(71 . 5)
                 (cons 1 symbol))))

;;; --- DrawUShape ---
;;; Draws series U-shape wiring for one string (row band r_bot..r_top).
;;; inv_x = X on inverter side (terminal side)
;;; far_x = X on far side (U-turn side)
;;; Returns (list plus_pt minus_pt) as ((x y) (x y))
(defun DrawUShape (ix iy r_top r_bot mh_proj gap_v_proj inv_x far_x line_color /
                   k offset y_r y_next last_off y_top_row y_bot_row)
  (setq k r_top)
  (while (>= k r_bot)
    (setq y_r    (+ iy (* k (+ mh_proj gap_v_proj)) (/ mh_proj 2.0))
          offset (- r_top k))
    ;; Horizontal row line: even offset  invfar, odd  farinv
    (if (= (rem offset 2) 0)
      (DrawDCLine (list inv_x y_r 0.0) (list far_x y_r 0.0) line_color)
      (DrawDCLine (list far_x y_r 0.0) (list inv_x y_r 0.0) line_color))
    ;; Vertical jumper to next row down
    (if (> k r_bot)
      (progn
        (setq y_next (+ iy (* (1- k) (+ mh_proj gap_v_proj)) (/ mh_proj 2.0)))
        (if (= (rem offset 2) 0)
          (DrawDCLine (list far_x y_r 0.0) (list far_x y_next 0.0) line_color)
          (DrawDCLine (list inv_x y_r 0.0) (list inv_x y_next 0.0) line_color))))
    (setq k (1- k)))
  ;; Terminal positions
  (setq y_top_row (+ iy (* r_top (+ mh_proj gap_v_proj)) (/ mh_proj 2.0))
        y_bot_row (+ iy (* r_bot (+ mh_proj gap_v_proj)) (/ mh_proj 2.0))
        last_off  (- r_top r_bot))
  ;; Even rows_per_string (last_off odd)   both terminals on inv side
  ;; Odd  rows_per_string (last_off even)  minus terminal on far side
  (list (list inv_x y_top_row)
        (if (= (rem last_off 2) 1)
          (list inv_x y_bot_row)
          (list far_x y_bot_row))))

(defun sp-string-row-center-y (iy row_idx mh_proj gap_v_proj)
  (+ iy (* row_idx (+ mh_proj gap_v_proj)) (/ mh_proj 2.0)))

(defun sp-string-col-center-x (ix col_idx actual_w m_gap_h)
  (+ ix (* col_idx (+ actual_w m_gap_h)) (/ actual_w 2.0)))

(defun sp-build-seq-single-row (mod_in_row direction / seq c)
  (setq seq nil)
  (if (= direction "Right to Left")
    (progn
      (setq c mod_in_row)
      (while (> c 0)
        (setq seq (append seq (list c)))
        (setq c (1- c))))
    (progn
      (setq c 1)
      (while (<= c mod_in_row)
        (setq seq (append seq (list c)))
        (setq c (1+ c)))))
  seq)

(defun sp-build-seq-leapfrog (mod_in_row direction / seq c)
  (setq seq nil)
  (if (= direction "Right to Left")
    (progn
      (setq c mod_in_row)
      (while (> c 0)
        (setq seq (append seq (list c)))
        (setq c (- c 2)))
      (setq c (if (= (rem mod_in_row 2) 0) 1 2))
      (while (<= c mod_in_row)
        (setq seq (append seq (list c)))
        (setq c (+ c 2))))
    (progn
      (setq c 1)
      (while (<= c mod_in_row)
        (setq seq (append seq (list c)))
        (setq c (+ c 2)))
      (setq c (if (= (rem mod_in_row 2) 0) mod_in_row (1- mod_in_row)))
      (while (> c 0)
        (setq seq (append seq (list c)))
        (setq c (- c 2)))))
  seq)

(defun sp-draw-row-string-path (ix iy row_idx seq actual_w m_gap_h mh_proj gap_v_proj color / pts first_pt last_pt col cx cy)
  (setq pts nil
        first_pt nil
        last_pt nil)
  (foreach col seq
    (setq cx (sp-string-col-center-x ix (1- col) actual_w m_gap_h)
          cy (sp-string-row-center-y iy row_idx mh_proj gap_v_proj))
    (if (null first_pt)
      (setq first_pt (list cx cy 0.0)))
    (setq last_pt (list cx cy 0.0))
    (setq pts (append pts (list (list cx cy 0.0)))))
  (if (> (length pts) 1)
    (entmakex
      (append
        (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
              '(8 . "DC_STRINGING") (cons 62 color)
              '(100 . "AcDbPolyline")
              (cons 90 (length pts))
              '(70 . 0)
              '(43 . 0.05))
        (mapcar '(lambda (p) (cons 10 p)) pts))))
  (if (and first_pt last_pt)
    (list first_pt last_pt)
    nil))

(defun sp-xd-item-val (item)
  (cond
    ((null item) nil)
    ((listp item) (cdr item))
    (T item)))

(defun sp-find-inverter-label-point (inv_name / ss idx en ed etype txt ins found)
  (setq found nil
        ss    (ssget "X" '((8 . "STRINGING"))))
  (if ss
    (progn
      (setq idx 0)
      (while (and (< idx (sslength ss)) (null found))
        (setq en    (ssname ss idx)
              ed    (entget en)
              etype (cdr (assoc 0 ed))
              txt   (cdr (assoc 1 ed)))
        (if (and txt
                 (or (= etype "TEXT") (= etype "MTEXT"))
                 (= (strcase txt) (strcase inv_name)))
          (progn
            (setq ins (cdr (assoc 10 ed)))
            (if ins
              (setq found (list (car ins) (cadr ins) 0.0)))))
        (setq idx (1+ idx)))))
  found)

(defun sp-resolve-row-direction (table_cx inv_cx fallback_dir)
  (if (and inv_cx (numberp inv_cx))
    (if (> inv_cx table_cx)
      "Right to Left"
      "Left to Right")
    fallback_dir))

(defun sp-resolve-row-direction-by-edge (left_x right_x inv_cx fallback_dir / dleft dright)
  (if (and inv_cx (numberp inv_cx))
    (progn
      (setq dleft  (abs (- inv_cx left_x))
            dright (abs (- inv_cx right_x)))
      (if (< dright dleft)
        "Right to Left"
        "Left to Right"))
    fallback_dir))

(defun sp-get-effective-string-direction (manual_dir /)
  (cond
    ((or (null manual_dir) (= manual_dir "") (= manual_dir "Auto by Inverter"))
     "Auto by Inverter")
    ((= manual_dir "Right to Left") "Right to Left")
    (T "Left to Right")))

;;;------------------------------------------------------------
(defun c:DCSTRINGING (/ ent xdata xd p_w p_h tilt mod_in_row mod_in_stack
                          p_ori m_gap_h m_gap_v actual_w actual_h
                          tilt_rad mh_proj gap_v_proj modules_per_table
                          mods_per_string strings_per_inv num_inv tmp dflt
                          spt_local rows_per_string string_method string_direction use_row_methods row_seq row_idx
                          ss idx ename edata blk_name
                          all_tables total_tables sorted_tables grouped_tables this_group
                          base_tpi remainder cumulative_idx
                          i j s start_idx end_idx this_inv_tables cnt_inv
                          inv_cx ix iy table_w left_x right_x
                          inv_x far_x this_table_cx inv_name inv_label_pt row_direction
                          r_top r_bot terminals plus_pt minus_pt circ_r method_result dc_result
                          old_cmdecho)
  (vl-load-com)
  (setq old_cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)

  ;; Ensure DC_STRINGING layer is visible and active
  (ss-setup-layer "DC_STRINGING" "7")

  ;; 1. Select boundary
  (setvar "CMDECHO" 1)
  ;; Auto-detect: if exactly one SolarPro boundary exists, use it silently
  (setq as-bnds (asd-find-boundaries))
  (cond
    ((= (length as-bnds) 1)
     (setq ent (car as-bnds))
     (princ "\nOne SolarPro boundary detected automatically."))
    ((> (length as-bnds) 1)
     (princ (strcat "\n" (itoa (length as-bnds)) " boundaries found. Select the target area: "))
     (setq ent (car (entsel)))
     (if (null ent) (progn (setvar "CMDECHO" old_cmdecho) (exit))))
    (T
     (princ "\nSelect boundary polyline (must have SolarPro layout data): ")
     (setq ent (car (entsel)))
     (if (null ent) (progn (setvar "CMDECHO" old_cmdecho) (exit)))))

  (setvar "CMDECHO" 0)
  (if (null ent) (progn (setvar "CMDECHO" old_cmdecho) (exit)))

  ;; 2. Read XDATA
  (setq xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (not (and xdata (= (caar xdata) "FS_SOLAR_DATA")))
    (progn
      (princ "\nERROR: The selected object has no SolarPro data.")
      (princ "\nPlease run SolarProDialog first, then try DCSTRINGING again.")
      (setvar "CMDECHO" old_cmdecho)
      (exit)))
  (setq xd          (cdar xdata)
        p_w          (sp-xd-item-val (nth 0  xd))
        p_h          (sp-xd-item-val (nth 1  xd))
        tilt         (sp-xd-item-val (nth 3  xd))
        mod_in_row   (fix (sp-xd-item-val (nth 7  xd)))
        mod_in_stack (fix (sp-xd-item-val (nth 8  xd)))
        p_ori        (if (= (fix (sp-xd-item-val (nth 9 xd))) 1) "Portrait" "Landscape")
        m_gap_h      (sp-xd-item-val (nth 10 xd))
        m_gap_v      (sp-xd-item-val (nth 11 xd)))

  ;; 3. Geometry
  (setq actual_w   (if (= p_ori "Portrait") p_w p_h)
        actual_h   (if (= p_ori "Portrait") p_h p_w)
        tilt_rad   (* tilt (/ pi 180.0))
        mh_proj    (* actual_h (cos tilt_rad))
        gap_v_proj (* m_gap_v  (cos tilt_rad))
        modules_per_table (* mod_in_row mod_in_stack)
        circ_r     (* mh_proj 0.22))

  ;; 4. Combined DC stringing dialog
  (setq dc_result (dcstr-open-dialog))
  (if (null dc_result)
    (progn
      (princ "\nDC stringing cancelled.")
      (setvar "CMDECHO" old_cmdecho)
      (exit)))
  (setq mods_per_string (nth 1 dc_result)
        num_inv         (nth 2 dc_result)
        strings_per_inv (nth 3 dc_result)
        string_method   (nth 4 dc_result)
        string_direction (sp-get-effective-string-direction (nth 5 dc_result)))

  ;; 5. String/table relationships
  (setq spt_local
        (if (>= mods_per_string modules_per_table) 1
            (fix (/ modules_per_table mods_per_string))))
  (setq rows_per_string
        (max 1 (fix (/ mod_in_stack spt_local))))
  (setq use_row_methods
        (and (/= string_method "U-String")
             (= mods_per_string mod_in_row)
             (= spt_local mod_in_stack)))
  (if (and (/= string_method "U-String") (not use_row_methods))
    (princ "\nSelected method needs one full row per string inside a table. Falling back to U-String for this table/string combination."))

  ;; 6. Collect TABLE_* blocks inside the boundary
  (setq all_tables (GetTablesInBoundary ent))
  (setq total_tables (length all_tables))
  (if (= total_tables 0)
    (progn (princ "\nNo table blocks found.")
           (setvar "CMDECHO" old_cmdecho) (exit)))

  ;; 7. Sort: Y descending, X ascending
  (setq sorted_tables
    (vl-sort all_tables
      (function (lambda (a b / pa pb)
        (setq pa (cdr (assoc 10 (entget a)))
              pb (cdr (assoc 10 (entget b))))
        (if (> (abs (- (cadr pa) (cadr pb))) (* mh_proj 0.5))
          (> (cadr pa) (cadr pb))
          (< (car  pa) (car  pb)))))))

  ;; 8. Equal distribution
  (setq base_tpi  (fix (/ total_tables num_inv))
        remainder (- total_tables (* base_tpi num_inv)))
  (setq grouped_tables (sp-build-groups-from-xdata sorted_tables num_inv))
  (if grouped_tables
    (princ "\nDCSTRINGING using inverter groups saved by inverter grouping.")
    (princ "\nDCSTRINGING using fallback equal-distribution grouping."))

  ;; 9. Draw U-shapes
  (setq i 1  cumulative_idx 0)
  (repeat num_inv
    (if grouped_tables
      (setq this_group      (nth (1- i) grouped_tables)
            this_inv_tables (length this_group)
            start_idx       0
            end_idx         (1- this_inv_tables))
      (setq this_inv_tables (if (<= i remainder) (1+ base_tpi) base_tpi)
            start_idx       cumulative_idx
            end_idx         (1- (+ cumulative_idx this_inv_tables))
            cumulative_idx  (+ cumulative_idx this_inv_tables)
            this_group      nil))

    ;; Prefer the actual moved INV-* label position; fall back to group midpoint.
    (setq grp_min_bx 1e10  grp_max_bx -1e10  j start_idx)
    (while (and (<= j end_idx)
                (if grouped_tables
                  (< j this_inv_tables)
                  (< j total_tables)))
      (vla-getboundingbox
        (vlax-ename->vla-object
          (if grouped_tables (nth j this_group) (nth j sorted_tables)))
        'bmin_t 'bmax_t)
      (setq bmin_t (vlax-safearray->list bmin_t)
            bmax_t (vlax-safearray->list bmax_t))
      (if (< (car bmin_t) grp_min_bx) (setq grp_min_bx (car bmin_t)))
      (if (> (car bmax_t) grp_max_bx) (setq grp_max_bx (car bmax_t)))
      (setq j (1+ j)))
    (setq inv_name     (strcat "INV-" (itoa i))
          inv_label_pt (sp-find-inverter-label-point inv_name)
          inv_cx       (if inv_label_pt
                         (car inv_label_pt)
                         (/ (+ grp_min_bx grp_max_bx) 2.0)))

    ;; Process each table in this inverter
    (setq j start_idx)
    (while (and (<= j end_idx)
                (if grouped_tables
                  (< j this_inv_tables)
                  (< j total_tables)))
      (setq edata   (entget (if grouped_tables (nth j this_group) (nth j sorted_tables)))
            ix      (car  (cdr (assoc 10 edata)))
            iy      (cadr (cdr (assoc 10 edata)))
            table_w (+ (* actual_w mod_in_row) (* m_gap_h (1- mod_in_row)))
            left_x  ix
            right_x (+ ix table_w)
            this_table_cx (+ ix (/ table_w 2.0)))

      ;; Terminal side: offset inward by 1.5 circle radius so symbols/lines stay inside table
      (if (< this_table_cx inv_cx)
        (setq inv_x (- right_x (* circ_r 1.5))   ; inverter on right  pull left from right edge
              far_x (+ left_x  (* circ_r 1.5)))  ; U-turn side  pull right from left edge
        (setq inv_x (+ left_x  (* circ_r 1.5))   ; inverter on left  pull right from left edge
              far_x (- right_x (* circ_r 1.5)))) ; U-turn side  pull left from right edge

      ;; Draw per selected method
      (if use_row_methods
        (progn
          (princ (strcat "\nDrawing row-wise method on table " (itoa (1+ j)) " of "
                         (itoa (if grouped_tables this_inv_tables total_tables)) "."))
          (setq row_direction
                (if (= string_direction "Auto by Inverter")
                  (sp-resolve-row-direction-by-edge left_x right_x inv_cx "Left to Right")
                  string_direction))
          (princ (strcat "\n  " inv_name " table " (itoa (1+ j))
                         " using " row_direction
                         " (inv_x=" (rtos inv_cx 2 2) ")"))
          (setq row_idx 0)
          (repeat mod_in_stack
            (setq row_seq
                  (if (= string_method "Leapfrog")
                    (sp-build-seq-leapfrog mod_in_row row_direction)
                    (sp-build-seq-single-row mod_in_row row_direction)))
            (setq terminals
                  (sp-draw-row-string-path ix iy row_idx row_seq actual_w m_gap_h mh_proj gap_v_proj 7))
            (if terminals
              (progn
                (setq plus_pt  (car terminals)
                      minus_pt (cadr terminals))
                (DrawDCTerminal (car plus_pt)  (cadr plus_pt)  circ_r "+" 1)
                (DrawDCTerminal (car minus_pt) (cadr minus_pt) circ_r "-" 5)))
            (setq row_idx (1+ row_idx))))
        (progn
          ;; Draw U-shape per string band in this table
          (setq s 0)
          (repeat spt_local
            (setq r_top (1- (- mod_in_stack (* s rows_per_string)))
                  r_bot (-    mod_in_stack (* (1+ s) rows_per_string)))
            (setq terminals (DrawUShape ix iy r_top r_bot mh_proj gap_v_proj
                                        inv_x far_x 7))
            ;; + terminal  red circle
            (setq plus_pt  (car  terminals)
                  minus_pt (cadr terminals))
            (DrawDCTerminal (car plus_pt)  (cadr plus_pt)  circ_r "+" 1)
            ;; - terminal  blue circle
            (DrawDCTerminal (car minus_pt) (cadr minus_pt) circ_r "-" 5)
            (setq s (1+ s)))))
      (setq j (1+ j)))
    (setq i (1+ i)))

  (setvar "CMDECHO" old_cmdecho)
  (princ (strcat "\nDC stringing complete  " (itoa num_inv) " inverters. Method: " string_method ", Direction: " string_direction))
  (princ "\nUse CLEARDCSTRINGING to remove."))

(defun c:CLEARDCSTRINGING (/ ss idx ename removed)
  (setq ss      (ssget "_X" '((8 . "DC_STRINGING")))
        removed 0)
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ename (ssname ss idx))
        (entdel ename)
        (setq removed (1+ removed)  idx (1+ idx)))
      (princ (strcat "\nRemoved " (itoa removed) " DC stringing entities.")))
    (princ "\nNo DC stringing entities found."))
  (princ))

;;;------------------------------------------------------------

;;; Auto Stringing Dialog Handler
;;; Commands: AUTOSTRINGDIALOG / INVERTERGROUPINGDIALOG  (open dialog  configure inverter grouping)
;;;------------------------------------------------------------

;; Equipment database helpers
(defun spdb-db-path ()
  "d:\\SolarPro AcadLISP\\Sameer\\with PANFile\\solarpro_equipment_db.lsp")

(defun spdb-copy-record (rec)
  (if rec (read (vl-prin1-to-string rec)) nil))

(defun spdb-rec-get (rec key default / hit)
  (setq hit (assoc key rec))
  (if hit (cdr hit) default))

(defun spdb-rec-put (rec key val)
  (cons (cons key val) (vl-remove-if '(lambda (x) (= (car x) key)) rec)))

(defun spdb-ond-read-number (path key / fh line pos val)
  (setq val nil)
  (if (and path (findfile path))
    (progn
      (setq fh (open path "r"))
      (if fh
        (progn
          (while (and (null val) (setq line (read-line fh)))
            (setq pos (vl-string-search (strcat key "=") line))
            (if pos
              (setq val (atof (substr line (+ pos (strlen key) 2))))))
          (close fh)))))
  val)

(defun spdb-fix-inverter-rec (rec / src mppt_count total_inputs mppt_inputs idcmax imaxdc mppt_imax)
  (if (null rec)
    nil
    (progn
      (setq src          (spdb-rec-get rec 'source "")
            mppt_count   (spdb-rec-get rec 'mppt_count 0)
            total_inputs (spdb-rec-get rec 'total_inputs 0)
            mppt_inputs  (spdb-rec-get rec 'mppt_inputs 0)
            mppt_imax    (spdb-rec-get rec 'mppt_imax 0.0))
      (if (and (or (<= mppt_imax 0.0) (<= mppt_inputs 0))
               src
               (findfile src))
        (progn
          (setq idcmax (spdb-ond-read-number src "IDCMax")
                imaxdc (spdb-ond-read-number src "IMaxDC"))
          (if (<= mppt_count 0)
            (setq mppt_count (fix (spdb-ond-read-number src "NbMPPT"))))
          (if (<= total_inputs 0)
            (setq total_inputs (fix (spdb-ond-read-number src "NbInputs"))))
          (if (<= mppt_inputs 0)
            (progn
              (if (and (> total_inputs 0) (> mppt_count 0))
                (setq mppt_inputs (max 1 (fix (+ 0.9999 (/ total_inputs (float mppt_count)))))))
              (if (> mppt_inputs 0)
                (setq rec (spdb-rec-put rec 'mppt_inputs mppt_inputs)))))
          (if (<= mppt_imax 0.0)
            (progn
              (cond
                ((and idcmax (> idcmax 0.0))
                 (setq mppt_imax idcmax))
                ((and imaxdc (> imaxdc 0.0) (> mppt_count 0))
                 (setq mppt_imax (/ imaxdc mppt_count))))
              (if (> mppt_imax 0.0)
                (setq rec (spdb-rec-put rec 'mppt_imax mppt_imax)))))))
      rec)))

(defun spdb-remove-record (records manufacturer model / key)
  (setq key (strcat (strcase manufacturer) "|" (strcase model)))
  (vl-remove-if
    '(lambda (r)
       (= (strcat (strcase (cdr (assoc 'manufacturer r))) "|" (strcase (cdr (assoc 'model r)))) key))
    records))

(defun spdb-save-db (/ path fh)
  (setq path (spdb-db-path))
  (setq fh (open path "w"))
  (if fh
    (progn
      (write-line "(setq *spdb-module-db* '" fh)
      (prin1 *spdb-module-db* fh)
      (write-line ")" fh)
      (write-line "(setq *spdb-inverter-db* '" fh)
      (prin1 *spdb-inverter-db* fh)
      (write-line ")" fh)
      (close fh)
      T)
    nil))

(defun spdb-ensure-loaded (/ path res)
  (setq *spdb-module-db* nil
        *spdb-inverter-db* nil)
  (setq path (spdb-db-path))
  (if (findfile path)
    (progn
      (setq res (vl-catch-all-apply
                  '(lambda ()
                     (load path))))
      (if (vl-catch-all-error-p res)
        (setq *spdb-module-db* nil
              *spdb-inverter-db* nil))))
  (if (null *spdb-module-db*) (setq *spdb-module-db* nil))
  (if (null *spdb-inverter-db*) (setq *spdb-inverter-db* nil))
  (setq *spdb-loaded* T)
  T)

(defun spdb-sort-strings (lst)
  (if lst (acad_strlsort lst) nil))

(defun spdb-unique-strings (lst / out)
  (setq out nil)
  (foreach x lst
    (if (and x (/= x "") (not (member x out)))
      (setq out (cons x out))))
  (spdb-sort-strings out))

(defun spdb-popup-fill (key items idx)
  (start_list key)
  (if items
    (foreach it items (add_list it))
    (add_list "(none)"))
  (end_list)
  (if (null idx) (setq idx 0))
  (if (< idx 0) (setq idx 0))
  (if (and items (>= idx (length items))) (setq idx 0))
  (set_tile key (itoa idx)))

(defun spdb-module-manufacturers ()
  (spdb-ensure-loaded)
  (spdb-unique-strings (mapcar '(lambda (r) (cdr (assoc 'manufacturer r))) *spdb-module-db*)))

(defun spdb-inverter-manufacturers ()
  (spdb-ensure-loaded)
  (spdb-unique-strings (mapcar '(lambda (r) (cdr (assoc 'manufacturer r))) *spdb-inverter-db*)))

(defun spdb-module-models (manufacturer)
  (spdb-ensure-loaded)
  (spdb-unique-strings
    (mapcar '(lambda (r) (cdr (assoc 'model r)))
            (vl-remove-if-not
              '(lambda (r) (= (cdr (assoc 'manufacturer r)) manufacturer))
              *spdb-module-db*))))

(defun spdb-inverter-models (manufacturer)
  (spdb-ensure-loaded)
  (spdb-unique-strings
    (mapcar '(lambda (r) (cdr (assoc 'model r)))
            (vl-remove-if-not
              '(lambda (r) (= (cdr (assoc 'manufacturer r)) manufacturer))
              *spdb-inverter-db*))))

(defun spdb-find-module (manufacturer model / key)
  (setq key (strcat (strcase manufacturer) "|" (strcase model)))
  (car
    (vl-remove-if-not
      '(lambda (r)
         (= (strcat (strcase (cdr (assoc 'manufacturer r))) "|" (strcase (cdr (assoc 'model r)))) key))
      *spdb-module-db*)))

(defun spdb-string-index (value items / idx found)
  (setq idx 0
        found nil)
  (while (and items (< idx (length items)) (null found))
    (if (= (nth idx items) value)
      (setq found idx)
      (setq idx (1+ idx))))
  found)

(defun spdb-remember-selected-module (rec / manufacturer model)
  (if rec
    (progn
      (setq manufacturer (cdr (assoc 'manufacturer rec))
            model        (cdr (assoc 'model rec))
            *sp-selected-module-rec*   rec
            *sp-selected-module-mfr*   manufacturer
            *sp-selected-module-model* model)
      (if manufacturer (setq *spdb-last-module-manufacturer* manufacturer)))))

(defun spdb-sync-asd-module-selection-from-solarpro (/ manufacturer model mfrs models idx)
  (if (and (boundp '*sp-selected-module-mfr*)
           (boundp '*sp-selected-module-model*)
           *sp-selected-module-mfr*
           *sp-selected-module-model*)
    (progn
      (spdb-ensure-loaded)
      (setq manufacturer *sp-selected-module-mfr*
            model        *sp-selected-module-model*
            mfrs         (spdb-module-manufacturers)
            idx          (spdb-string-index manufacturer mfrs))
      (if idx
        (progn
          (setq *asd-db-mod-mfr-idx* idx
                models               (spdb-module-models manufacturer)
                idx                  (spdb-string-index model models))
          (if idx
            (setq *asd-db-mod-model-idx* idx)
            (setq *asd-db-mod-model-idx* 0)))))))

(defun spdb-find-inverter (manufacturer model / key)
  (setq key (strcat (strcase manufacturer) "|" (strcase model)))
  (spdb-fix-inverter-rec
    (car
      (vl-remove-if-not
        '(lambda (r)
           (= (strcat (strcase (cdr (assoc 'manufacturer r))) "|" (strcase (cdr (assoc 'model r)))) key))
        *spdb-inverter-db*))))

(defun spdb-numstr (val prec)
  (cond
    ((numberp val) (rtos val 2 prec))
    ((and val (= (type val) 'REAL)) (rtos val 2 prec))
    ((and val (= (type val) 'INT)) (itoa val))
    (T "")))

(defun spdb-apply-module-rec-to-asd (rec)
  (if rec
    (progn
      (spdb-remember-selected-module rec)
      (set_tile "s_watt" (spdb-numstr (cdr (assoc 'watt rec)) 0))
      (set_tile "s_voc" (spdb-numstr (cdr (assoc 'voc rec)) 2))
      (set_tile "s_vmp" (spdb-numstr (cdr (assoc 'vmp rec)) 2))
      (set_tile "s_isc" (spdb-numstr (cdr (assoc 'isc rec)) 2))
      (set_tile "s_imp" (spdb-numstr (cdr (assoc 'imp rec)) 2))
      (if (/= (spdb-numstr (cdr (assoc 'tc_voc rec)) 3) "")
        (set_tile "s_tc_voc" (spdb-numstr (cdr (assoc 'tc_voc rec)) 3)))
      (if (/= (spdb-numstr (cdr (assoc 'tc_vmp rec)) 3) "")
        (set_tile "s_tc_vmp" (spdb-numstr (cdr (assoc 'tc_vmp rec)) 3)))
      (setq *asd-s-watt*   (get_tile "s_watt")
            *asd-s-voc*    (get_tile "s_voc")
            *asd-s-vmp*    (get_tile "s_vmp")
            *asd-s-isc*    (get_tile "s_isc")
            *asd-s-imp*    (get_tile "s_imp")
            *asd-s-tc_voc* (get_tile "s_tc_voc")
            *asd-s-tc_vmp* (get_tile "s_tc_vmp"))
      (set_tile "status" "Module data filled from database."))))

(defun spdb-apply-inverter-rec-to-asd (rec)
  (if rec
    (progn
      (set_tile "s_inv_kw" (spdb-numstr (cdr (assoc 'inv_kw rec)) 0))
      (set_tile "s_vdc_max" (spdb-numstr (cdr (assoc 'vdc_max rec)) 0))
      (set_tile "s_num_mppt" (spdb-numstr (cdr (assoc 'mppt_count rec)) 0))
      (set_tile "s_mppt_vmin" (spdb-numstr (cdr (assoc 'mppt_vmin rec)) 0))
      (set_tile "s_mppt_vmax" (spdb-numstr (cdr (assoc 'mppt_vmax rec)) 0))
      (set_tile "s_mppt_imax" (if (> (cdr (assoc 'mppt_imax rec)) 0.0) (spdb-numstr (cdr (assoc 'mppt_imax rec)) 2) ""))
      (set_tile "s_mppt_inputs" (spdb-numstr (cdr (assoc 'mppt_inputs rec)) 0))
      (setq *asd-s-inv_kw*      (get_tile "s_inv_kw")
            *asd-s-vdc_max*     (get_tile "s_vdc_max")
            *asd-s-num_mppt*    (get_tile "s_num_mppt")
            *asd-s-mppt_vmin*   (get_tile "s_mppt_vmin")
            *asd-s-mppt_vmax*   (get_tile "s_mppt_vmax")
            *asd-s-mppt_imax*   (get_tile "s_mppt_imax")
            *asd-s-mppt_inputs* (get_tile "s_mppt_inputs"))
      (if (> (cdr (assoc 'mppt_imax rec)) 0.0)
        (set_tile "status" "Inverter data filled from database.")
        (set_tile "status" "Inverter data filled, but Max Current / MPPT is unavailable in source data. Verify from datasheet.")))))

(defun spdb-apply-module-rec-to-spd (rec)
  (if rec
    (progn
      (spdb-remember-selected-module rec)
      (set_tile "p_w" (spdb-numstr (cdr (assoc 'width rec)) 3))
      (set_tile "p_h" (spdb-numstr (cdr (assoc 'height rec)) 3))
      (set_tile "p_watt" (spdb-numstr (cdr (assoc 'watt rec)) 0))
      (setq *spd-s-pw*   (get_tile "p_w")
            *spd-s-ph*   (get_tile "p_h")
            *spd-s-watt* (get_tile "p_watt"))
      (set_tile "status" "Module dimensions filled from database."))))

(defun asd-cache-fields ()
  (setq *asd-s-voc*         (get_tile "s_voc")
        *asd-s-vmp*         (get_tile "s_vmp")
        *asd-s-isc*         (get_tile "s_isc")
        *asd-s-imp*         (get_tile "s_imp")
        *asd-s-watt*        (get_tile "s_watt")
        *asd-s-inv_kw*      (get_tile "s_inv_kw")
        *asd-s-dcac-ratio*  (get_tile "s_dcac_ratio")
        *asd-s-num_inv*     (get_tile "s_num_inv")
        *asd-s-inv-place*   (get_tile "s_inv_place")
        *asd-s-group-mode*  (get_tile "s_group_mode")
        *asd-s-vdc_max*     (get_tile "s_vdc_max")
        *asd-s-num_mppt*    (get_tile "s_num_mppt")
        *asd-s-mppt_vmin*   (get_tile "s_mppt_vmin")
        *asd-s-mppt_vmax*   (get_tile "s_mppt_vmax")
        *asd-s-mppt_imax*   (get_tile "s_mppt_imax")
        *asd-s-mppt_inputs* (get_tile "s_mppt_inputs")
        *asd-s-tc_voc*      (get_tile "s_tc_voc")
        *asd-s-tc_vmp*      (get_tile "s_tc_vmp")
        *asd-s-t_min*       (get_tile "s_t_min")
        *asd-s-t_max*       (get_tile "s_t_max")))

(defun asd-recommend-inverter-count (/ dc_kw inv_kw dcac_ratio rec_count)
  (setq dc_kw      (if (and (boundp '*asd-site-dc-kw*) *asd-site-dc-kw*) *asd-site-dc-kw* 0.0)
        inv_kw     (atof (get_tile "s_inv_kw"))
        dcac_ratio (atof (get_tile "s_dcac_ratio")))
  (cond
    ((<= dc_kw 0.0)
     (set_tile "status" "Cannot recommend inverter count: site DC capacity is not available."))
    ((<= inv_kw 0.0)
     (set_tile "status" "Enter inverter Capacity (kW) before recommending inverter count."))
    ((<= dcac_ratio 0.0)
     (set_tile "status" "Enter a valid DC/AC ratio, for example 1.20."))
    (T
     (setq rec_count (max 1 (fix (+ 0.9999 (/ dc_kw (* inv_kw dcac_ratio))))))
     (set_tile "s_num_inv" (itoa rec_count))
     (setq *asd-s-num_inv*    (get_tile "s_num_inv")
           *asd-s-dcac-ratio* (get_tile "s_dcac_ratio"))
     (set_tile "status"
               (strcat "Recommended inverter count = "
                       (itoa rec_count)
                       " for "
                       (rtos dc_kw 2 2)
                       " kWp at DC/AC ratio "
                       (rtos dcac_ratio 2 2)
                       ".")))))

(defun asd-init-db-controls ()
  (spdb-ensure-loaded)
  (spdb-sync-asd-module-selection-from-solarpro)
  (setq *asd-db-mod-mfrs* (spdb-module-manufacturers)
        *asd-db-inv-mfrs* (spdb-inverter-manufacturers))
  (if (null *asd-db-mod-mfr-idx*) (setq *asd-db-mod-mfr-idx* 0))
  (if (null *asd-db-inv-mfr-idx*) (setq *asd-db-inv-mfr-idx* 0))
  (spdb-popup-fill "db_mod_mfr" *asd-db-mod-mfrs* *asd-db-mod-mfr-idx*)
  (setq *asd-db-mod-models*
        (if *asd-db-mod-mfrs*
          (spdb-module-models (nth *asd-db-mod-mfr-idx* *asd-db-mod-mfrs*))
          nil))
  (if (null *asd-db-mod-model-idx*) (setq *asd-db-mod-model-idx* 0))
  (spdb-popup-fill "db_mod_model" *asd-db-mod-models* *asd-db-mod-model-idx*)
  (spdb-popup-fill "db_inv_mfr" *asd-db-inv-mfrs* *asd-db-inv-mfr-idx*)
  (setq *asd-db-inv-models*
        (if *asd-db-inv-mfrs*
          (spdb-inverter-models (nth *asd-db-inv-mfr-idx* *asd-db-inv-mfrs*))
          nil))
  (if (null *asd-db-inv-model-idx*) (setq *asd-db-inv-model-idx* 0))
  (spdb-popup-fill "db_inv_model" *asd-db-inv-models* *asd-db-inv-model-idx*))

(defun asd-module-mfr-changed (idx)
  (setq *asd-db-mod-mfr-idx* (atoi idx)
        *asd-db-mod-model-idx* 0
        *asd-db-mod-models*
        (if *asd-db-mod-mfrs*
          (spdb-module-models (nth *asd-db-mod-mfr-idx* *asd-db-mod-mfrs*))
          nil))
  (spdb-popup-fill "db_mod_model" *asd-db-mod-models* 0))

(defun asd-module-model-changed (idx)
  (setq *asd-db-mod-model-idx* (atoi idx)))

(defun asd-inverter-mfr-changed (idx)
  (setq *asd-db-inv-mfr-idx* (atoi idx)
        *asd-db-inv-model-idx* 0
        *asd-db-inv-models*
        (if *asd-db-inv-mfrs*
          (spdb-inverter-models (nth *asd-db-inv-mfr-idx* *asd-db-inv-mfrs*))
          nil))
  (spdb-popup-fill "db_inv_model" *asd-db-inv-models* 0))

(defun asd-inverter-model-changed (idx)
  (setq *asd-db-inv-model-idx* (atoi idx)))

(defun asd-apply-selected-module ()
  (if (and *asd-db-mod-mfrs* *asd-db-mod-models*)
    (spdb-apply-module-rec-to-asd
      (spdb-find-module
        (nth *asd-db-mod-mfr-idx* *asd-db-mod-mfrs*)
        (nth *asd-db-mod-model-idx* *asd-db-mod-models*)))))

(defun asd-apply-selected-inverter ()
  (if (and *asd-db-inv-mfrs* *asd-db-inv-models*)
    (spdb-apply-inverter-rec-to-asd
      (spdb-find-inverter
        (nth *asd-db-inv-mfr-idx* *asd-db-inv-mfrs*)
        (nth *asd-db-inv-model-idx* *asd-db-inv-models*)))))

(defun spd-init-module-db-controls ()
  (spdb-ensure-loaded)
  (setq *spd-db-mod-mfrs* (spdb-module-manufacturers))
  (if (null *spd-db-mod-mfr-idx*) (setq *spd-db-mod-mfr-idx* 0))
  (spdb-popup-fill "db_spd_mod_mfr" *spd-db-mod-mfrs* *spd-db-mod-mfr-idx*)
  (setq *spd-db-mod-models*
        (if *spd-db-mod-mfrs*
          (spdb-module-models (nth *spd-db-mod-mfr-idx* *spd-db-mod-mfrs*))
          nil))
  (if (null *spd-db-mod-model-idx*) (setq *spd-db-mod-model-idx* 0))
  (spdb-popup-fill "db_spd_mod_model" *spd-db-mod-models* *spd-db-mod-model-idx*))

(defun spd-module-mfr-changed (idx)
  (setq *spd-db-mod-mfr-idx* (atoi idx)
        *spd-db-mod-model-idx* 0
        *spd-db-mod-models*
        (if *spd-db-mod-mfrs*
          (spdb-module-models (nth *spd-db-mod-mfr-idx* *spd-db-mod-mfrs*))
          nil))
  (spdb-popup-fill "db_spd_mod_model" *spd-db-mod-models* 0))

(defun spd-module-model-changed (idx)
  (setq *spd-db-mod-model-idx* (atoi idx)))

(defun spd-apply-selected-module ()
  (if (and *spd-db-mod-mfrs* *spd-db-mod-models*)
    (spdb-apply-module-rec-to-spd
      (spdb-find-module
        (nth *spd-db-mod-mfr-idx* *spd-db-mod-mfrs*)
        (nth *spd-db-mod-model-idx* *spd-db-mod-models*)))))

(defun spdb-open-new-module-dialog (/ dcl-id result rec)
  (setq dcl-id (load_dialog (spd-get-dcl "SolarPro - Equipment Database Dialogs.dcl")))
  (if (and dcl-id (not (minusp dcl-id)) (new_dialog "solarpro_new_module_dialog" dcl-id))
    (progn
      (set_tile "nm_manufacturer" (if *spdb-last-module-manufacturer* *spdb-last-module-manufacturer* ""))
      (set_tile "nm_model" "")
      (set_tile "nm_width" (if *spd-s-pw* *spd-s-pw* ""))
      (set_tile "nm_height" (if *spd-s-ph* *spd-s-ph* ""))
      (set_tile "nm_watt" (if *asd-s-watt* *asd-s-watt* (if *spd-s-watt* *spd-s-watt* "")))
      (set_tile "nm_voc" (if *asd-s-voc* *asd-s-voc* ""))
      (set_tile "nm_vmp" (if *asd-s-vmp* *asd-s-vmp* ""))
      (set_tile "nm_isc" (if *asd-s-isc* *asd-s-isc* ""))
      (set_tile "nm_imp" (if *asd-s-imp* *asd-s-imp* ""))
      (set_tile "nm_tc_voc" (if *asd-s-tc_voc* *asd-s-tc_voc* ""))
      (set_tile "nm_tc_vmp" (if *asd-s-tc_vmp* *asd-s-tc_vmp* ""))
      (setq result (start_dialog))
      (if (= result 1)
        (progn
          (setq rec
                (list
                  (cons 'manufacturer (get_tile "nm_manufacturer"))
                  (cons 'model (get_tile "nm_model"))
                  (cons 'width (atof (get_tile "nm_width")))
                  (cons 'height (atof (get_tile "nm_height")))
                  (cons 'watt (atof (get_tile "nm_watt")))
                  (cons 'voc (atof (get_tile "nm_voc")))
                  (cons 'vmp (atof (get_tile "nm_vmp")))
                  (cons 'isc (atof (get_tile "nm_isc")))
                  (cons 'imp (atof (get_tile "nm_imp")))
                  (cons 'tc_voc (atof (get_tile "nm_tc_voc")))
                  (cons 'tc_vmp (atof (get_tile "nm_tc_vmp")))
                  (cons 'source "Manual Entry")))
          (setq *spdb-module-db*
                (cons rec
                      (spdb-remove-record *spdb-module-db*
                                          (cdr (assoc 'manufacturer rec))
                                          (cdr (assoc 'model rec)))))
          (spdb-save-db)
          (setq *spdb-loaded* nil)
          (spdb-ensure-loaded)
          (setq *spdb-last-module-manufacturer* (cdr (assoc 'manufacturer rec))
                *asd-s-watt*   (spdb-numstr (cdr (assoc 'watt rec)) 0)
                *asd-s-voc*    (spdb-numstr (cdr (assoc 'voc rec)) 2)
                *asd-s-vmp*    (spdb-numstr (cdr (assoc 'vmp rec)) 2)
                *asd-s-isc*    (spdb-numstr (cdr (assoc 'isc rec)) 2)
                *asd-s-imp*    (spdb-numstr (cdr (assoc 'imp rec)) 2)
                *asd-s-tc_voc* (spdb-numstr (cdr (assoc 'tc_voc rec)) 3)
                *asd-s-tc_vmp* (spdb-numstr (cdr (assoc 'tc_vmp rec)) 3)
                *spd-s-pw*     (spdb-numstr (cdr (assoc 'width rec)) 3)
                *spd-s-ph*     (spdb-numstr (cdr (assoc 'height rec)) 3)
                *spd-s-watt*   (spdb-numstr (cdr (assoc 'watt rec)) 0))))))
  (if dcl-id (unload_dialog dcl-id))
  result)

(defun spdb-open-new-inverter-dialog (/ dcl-id result rec)
  (setq dcl-id (load_dialog (spd-get-dcl "SolarPro - Equipment Database Dialogs.dcl")))
  (if (and dcl-id (not (minusp dcl-id)) (new_dialog "solarpro_new_inverter_dialog" dcl-id))
    (progn
      (set_tile "ni_manufacturer" (if *spdb-last-inverter-manufacturer* *spdb-last-inverter-manufacturer* ""))
      (set_tile "ni_model" "")
      (set_tile "ni_inv_kw" (if *asd-s-inv_kw* *asd-s-inv_kw* ""))
      (set_tile "ni_vdc_max" (if *asd-s-vdc_max* *asd-s-vdc_max* ""))
      (set_tile "ni_mppt_count" (if *asd-s-num_mppt* *asd-s-num_mppt* ""))
      (set_tile "ni_mppt_vmin" (if *asd-s-mppt_vmin* *asd-s-mppt_vmin* ""))
      (set_tile "ni_mppt_vmax" (if *asd-s-mppt_vmax* *asd-s-mppt_vmax* ""))
      (set_tile "ni_mppt_imax" (if *asd-s-mppt_imax* *asd-s-mppt_imax* ""))
      (set_tile "ni_mppt_inputs" (if *asd-s-mppt_inputs* *asd-s-mppt_inputs* ""))
      (setq result (start_dialog))
      (if (= result 1)
        (progn
          (setq rec
                (list
                  (cons 'manufacturer (get_tile "ni_manufacturer"))
                  (cons 'model (get_tile "ni_model"))
                  (cons 'inv_kw (atof (get_tile "ni_inv_kw")))
                  (cons 'vdc_max (atof (get_tile "ni_vdc_max")))
                  (cons 'mppt_count (atoi (get_tile "ni_mppt_count")))
                  (cons 'mppt_vmin (atof (get_tile "ni_mppt_vmin")))
                  (cons 'mppt_vmax (atof (get_tile "ni_mppt_vmax")))
                  (cons 'mppt_imax (atof (get_tile "ni_mppt_imax")))
                  (cons 'mppt_inputs (atoi (get_tile "ni_mppt_inputs")))
                  (cons 'total_inputs (* (atoi (get_tile "ni_mppt_count"))
                                         (atoi (get_tile "ni_mppt_inputs"))))
                  (cons 'source "Manual Entry")))
          (setq *spdb-inverter-db*
                (cons rec
                      (spdb-remove-record *spdb-inverter-db*
                                          (cdr (assoc 'manufacturer rec))
                                          (cdr (assoc 'model rec)))))
          (spdb-save-db)
          (setq *spdb-loaded* nil)
          (spdb-ensure-loaded)
          (setq *spdb-last-inverter-manufacturer* (cdr (assoc 'manufacturer rec))
                *asd-s-inv_kw*      (spdb-numstr (cdr (assoc 'inv_kw rec)) 0)
                *asd-s-vdc_max*     (spdb-numstr (cdr (assoc 'vdc_max rec)) 0)
                *asd-s-num_mppt*    (spdb-numstr (cdr (assoc 'mppt_count rec)) 0)
                *asd-s-mppt_vmin*   (spdb-numstr (cdr (assoc 'mppt_vmin rec)) 0)
                *asd-s-mppt_vmax*   (spdb-numstr (cdr (assoc 'mppt_vmax rec)) 0)
                *asd-s-mppt_imax*   (spdb-numstr (cdr (assoc 'mppt_imax rec)) 2)
                *asd-s-mppt_inputs* (spdb-numstr (cdr (assoc 'mppt_inputs rec)) 0))))))
  (if dcl-id (unload_dialog dcl-id))
  result)

(defun asd-find-dcl (/ f)
  (setq f (spd-get-dcl "SolarPro - Stringing Dialog.dcl"))
  (if f f (spd-get-dcl "SolarPro - Stringing Dialog.dcl")))

(defun asd-method-find-dcl (/ f)
  (setq f (spd-get-dcl "SolarPro - Stringing Method Dialog.dcl"))
  (if f f (spd-get-dcl "SolarPro - Stringing Method Dialog.dcl")))

(defun asd-cache-accept-fields ()
  (setq *asd-s-voc*         (get_tile "s_voc")
        *asd-s-vmp*         (get_tile "s_vmp")
        *asd-s-isc*         (get_tile "s_isc")
        *asd-s-imp*         (get_tile "s_imp")
        *asd-s-watt*        (get_tile "s_watt")
        *asd-s-inv_kw*      (get_tile "s_inv_kw")
        *asd-s-dcac-ratio*  (get_tile "s_dcac_ratio")
        *asd-s-num_inv*     (get_tile "s_num_inv")
        *asd-s-inv-place*   (get_tile "s_inv_place")
        *asd-s-group-mode*  (get_tile "s_group_mode")
        *asd-s-vdc_max*     (get_tile "s_vdc_max")
        *asd-s-num_mppt*    (get_tile "s_num_mppt")
        *asd-s-mppt_vmin*   (get_tile "s_mppt_vmin")
        *asd-s-mppt_vmax*   (get_tile "s_mppt_vmax")
        *asd-s-mppt_imax*   (get_tile "s_mppt_imax")
        *asd-s-mppt_inputs* (get_tile "s_mppt_inputs")
        *asd-s-tc_voc*      (get_tile "s_tc_voc")
        *asd-s-tc_vmp*      (get_tile "s_tc_vmp")
        *asd-s-t_min*       (get_tile "s_t_min")
        *asd-s-t_max*       (get_tile "s_t_max")))

(defun asd-draw-method-preview (/ w h margin rackLeft rackRight rackTop rackBot
                                   cols rows cellW cellH x y col row
                                   wireYTop wireYBot signX endX startX)
  (setq w (dimx_tile "string_method_img")
        h (dimy_tile "string_method_img"))
  (if (or (null w) (null h) (<= w 0) (<= h 0))
    nil
    (progn
      (start_image "string_method_img")
      (fill_image 0 0 w h 255)
      (setq margin 6
            cols 20
            rows 2
            cellW (max 6 (fix (/ (* (- w (* margin 2)) 0.92) cols)))
            cellH (max 10 (fix (/ (* (- h (* margin 2)) 0.34) rows)))
            rackLeft (max margin (fix (/ (- w (* cols cellW)) 2)))
            rackRight (+ rackLeft (* cols cellW))
            rackTop (max margin (fix (/ (- h (* rows cellH)) 2)))
            rackBot (+ rackTop (* rows cellH))
            wireYTop (+ rackTop (fix (/ cellH 2)))
            wireYBot (+ rackTop cellH (fix (/ cellH 2))))
      ;; rack + modules
      (fill_image rackLeft rackTop (- rackRight rackLeft) (- rackBot rackTop) 255)
      (vector_image rackLeft rackTop rackRight rackTop 140)
      (vector_image rackLeft rackBot rackRight rackBot 140)
      (vector_image rackLeft rackTop rackLeft rackBot 140)
      (vector_image rackRight rackTop rackRight rackBot 140)
      (setq col 0)
      (while (< col cols)
        (setq row 0)
        (while (< row rows)
          (setq x (+ rackLeft (* col cellW))
                y (+ rackTop (* row cellH)))
          (fill_image (+ x 1) (+ y 1) (max 1 (- cellW 2)) (max 1 (- cellH 2)) 255)
          (vector_image x y (+ x cellW) y 140)
          (vector_image x (+ y cellH) (+ x cellW) (+ y cellH) 140)
          (vector_image x y x (+ y cellH) 140)
          (vector_image (+ x cellW) y (+ x cellW) (+ y cellH) 140)
          (setq row (1+ row)))
        (setq col (1+ col)))
      (vector_image rackLeft (+ rackTop cellH) rackRight (+ rackTop cellH) 140)
      ;; method preview
      (cond
        ((= *asd-string-method* "Single-Row")
         (setq signX (+ rackLeft 4)
               endX (- rackRight 4))
         (vector_image (+ signX 6) wireYTop (- endX 6) wireYTop 3)
         (vector_image (+ signX 6) wireYBot (- endX 6) wireYBot 3)
         (vector_image signX (- wireYTop 3) signX (+ wireYTop 3) 1)
         (vector_image (- signX 3) wireYTop (+ signX 3) wireYTop 1)
         (vector_image signX (- wireYBot 3) signX (+ wireYBot 3) 1)
         (vector_image (- signX 3) wireYBot (+ signX 3) wireYBot 1)
         (vector_image (- endX 3) wireYTop (+ endX 3) wireYTop 8)
         (vector_image (- endX 3) wireYBot (+ endX 3) wireYBot 8))
        ((= *asd-string-method* "Leapfrog")
         (setq signX (+ rackLeft 4))
         (if (= *asd-string-direction* "Right to Left")
           (setq startX (- rackRight (fix (/ cellW 2))))
           (setq startX (+ rackLeft (fix (/ cellW 2)))))
         (repeat (- cols 1)
           (if (= *asd-string-direction* "Right to Left")
             (progn
               (vector_image startX wireYTop (- startX (fix (/ cellW 2))) (- wireYTop 2) 3)
               (vector_image (- startX (fix (/ cellW 2))) (- wireYTop 2) (- startX cellW) wireYTop 3)
               (setq startX (- startX cellW)))
             (progn
               (vector_image startX wireYTop (+ startX (fix (/ cellW 2))) (- wireYTop 2) 3)
               (vector_image (+ startX (fix (/ cellW 2))) (- wireYTop 2) (+ startX cellW) wireYTop 3)
               (setq startX (+ startX cellW)))))
         (if (= *asd-string-direction* "Right to Left")
           (setq startX (- rackRight (fix (/ cellW 2))))
           (setq startX (+ rackLeft (fix (/ cellW 2)))))
         (repeat (- cols 1)
           (if (= *asd-string-direction* "Right to Left")
             (progn
               (vector_image startX wireYBot (- startX (fix (/ cellW 2))) (- wireYBot 2) 3)
               (vector_image (- startX (fix (/ cellW 2))) (- wireYBot 2) (- startX cellW) wireYBot 3)
               (setq startX (- startX cellW)))
             (progn
               (vector_image startX wireYBot (+ startX (fix (/ cellW 2))) (- wireYBot 2) 3)
               (vector_image (+ startX (fix (/ cellW 2))) (- wireYBot 2) (+ startX cellW) wireYBot 3)
               (setq startX (+ startX cellW)))))
         ;; + and - together on the left
         (vector_image signX (- wireYTop 3) signX (+ wireYTop 3) 1)
         (vector_image (- signX 3) wireYTop (+ signX 3) wireYTop 1)
         (vector_image (+ signX 8) wireYTop (+ signX 14) wireYTop 8)
         (vector_image signX (- wireYBot 3) signX (+ wireYBot 3) 1)
         (vector_image (- signX 3) wireYBot (+ signX 3) wireYBot 1)
         (vector_image (+ signX 8) wireYBot (+ signX 14) wireYBot 8))
        (T
         (setq signX (+ rackLeft 4)
               endX (- rackRight 4))
         (if (= *asd-string-direction* "Right to Left")
           (progn
             (vector_image rackRight wireYTop rackLeft wireYTop 30)
             (vector_image rackLeft wireYTop rackLeft wireYBot 30)
             (vector_image rackLeft wireYBot rackRight wireYBot 30))
           (progn
             (vector_image rackLeft wireYTop rackRight wireYTop 30)
             (vector_image rackRight wireYTop rackRight wireYBot 30)
             (vector_image rackRight wireYBot rackLeft wireYBot 30)))
         (vector_image signX (- wireYTop 3) signX (+ wireYTop 3) 1)
         (vector_image (- signX 3) wireYTop (+ signX 3) wireYTop 1)
         (vector_image (- signX 3) wireYBot (+ signX 3) wireYBot 8)
         (vector_image (- endX 3) wireYBot (+ endX 3) wireYBot 3)))
      (end_image))))

(defun asd-method-changed (idx)
  (setq *asd-string-method*
        (nth (atoi idx) '("U-String" "Single-Row" "Leapfrog")))
  (set_tile "status"
            (cond
              ((= *asd-string-method* "Single-Row") "Single-Row: one rack row per string.")
              ((= *asd-string-method* "Leapfrog") "Leapfrog: row-wise interleaved routing with both cable ends on one side.")
              (T "U-String: current table-based U routing.")))
  (asd-draw-method-preview))

(defun asd-direction-changed (idx)
  (setq *asd-string-direction*
        (nth (atoi idx) '("Left to Right" "Right to Left")))
  (asd-draw-method-preview))

(defun asd-open-method-dialog (/ dcl-path dcl-id result)
  (setq dcl-path (asd-method-find-dcl))
  (if (null dcl-path)
    (progn (alert "Cannot find:\nSolarPro - Stringing Method Dialog.dcl") 0)
    (progn
  (setq dcl-id (load_dialog dcl-path))
      (if (or (null dcl-id) (minusp dcl-id))
        (progn (alert "Failed to load stringing-method DCL.") 0)
        (progn
          (if (not (new_dialog "autostring_method_dialog" dcl-id))
            (progn (unload_dialog dcl-id) (alert "Failed to open stringing-method dialog.") 0)
            (progn
              (if (null *asd-string-method*) (setq *asd-string-method* "U-String"))
              (if (null *asd-string-direction*) (setq *asd-string-direction* "Left to Right"))
              (start_list "string_method")
              (add_list "U-String")
              (add_list "Single-Row")
              (add_list "Leapfrog")
              (end_list)
              (set_tile "string_method"
                        (itoa (cond
                                ((= *asd-string-method* "Single-Row") 1)
                                ((= *asd-string-method* "Leapfrog") 2)
                                (T 0))))
              (start_list "string_direction")
              (add_list "Left to Right")
              (add_list "Right to Left")
              (end_list)
              (set_tile "string_direction"
                        (itoa (if (= *asd-string-direction* "Right to Left") 1 0)))
              (action_tile "string_method" "(asd-method-changed $value)")
              (action_tile "string_direction" "(asd-direction-changed $value)")
              (action_tile "back" "(done_dialog 2)")
              (action_tile "accept" "(done_dialog 1)")
              (action_tile "cancel" "(done_dialog 0)")
              (asd-method-changed (get_tile "string_method"))
               (setq result (start_dialog))
               (unload_dialog dcl-id)
               result)))))))

(defun dcstr-find-dcl (/ f)
  (setq f (spd-get-dcl "SolarPro - DC Stringing Dialog.dcl"))
  (if f f (spd-get-dcl "SolarPro - DC Stringing Dialog.dcl")))

(defun dccaball-find-dcl (/ f)
  (setq f (spd-get-dcl "SolarPro - DC Cabling All Dialog.dcl"))
  (if f f (spd-get-dcl "SolarPro - DC Cabling All Dialog.dcl")))

(defun dccaball-open-dialog (/ dcl-path dcl-id result csize_idx trunk_idx csize)
  (setq dcl-path (dccaball-find-dcl))
  (if (null dcl-path)
    (progn (alert "Cannot find:\nSolarPro - DC Cabling All Dialog.dcl") nil)
    (progn
  (setq dcl-id (load_dialog dcl-path))
      (if (or (null dcl-id) (minusp dcl-id))
        (progn (alert "Failed to load batch DC cabling dialog.") nil)
        (progn
          (if (not (new_dialog "dccablingall_dialog" dcl-id))
            (progn (unload_dialog dcl-id) (alert "Failed to open batch DC cabling dialog.") nil)
            (progn
              (start_list "cab_csize")
              (add_list "4")
              (add_list "6")
              (end_list)
              (setq csize_idx (cond
                                ((and (boundp '*dccab-all-csize*) (= *dccab-all-csize* 6.0)) 1)
                                (T 0)))
              (set_tile "cab_csize" (itoa csize_idx))
              (start_list "cab_trunk_mode")
              (add_list "At Inverter")
              (add_list "Above Inverter")
              (add_list "Below Inverter")
              (end_list)
              (setq trunk_idx (cond
                                ((and (boundp '*dccab-all-trunk-mode*) (= *dccab-all-trunk-mode* "Above")) 1)
                                ((and (boundp '*dccab-all-trunk-mode*) (= *dccab-all-trunk-mode* "Below")) 2)
                                (T 0)))
              (set_tile "cab_trunk_mode" (itoa trunk_idx))
              (set_tile "cab_neg_o" (if (and (boundp '*dccab-all-neg-o*) *dccab-all-neg-o*) *dccab-all-neg-o* "2.5"))
              (set_tile "cab_updown" (if (and (boundp '*dccab-all-updown*) *dccab-all-updown*) *dccab-all-updown* "5.0"))
              (set_tile "cab_trunk_offset" (if (and (boundp '*dccab-all-trunk-offset*) *dccab-all-trunk-offset*) *dccab-all-trunk-offset* "0.0"))
              (set_tile "cab_mps_info"
                        (strcat "Modules/String: "
                                (itoa (if (and (boundp '*asd-mps*) (> *asd-mps* 0)) *asd-mps* 18))
                                " (auto from inverter grouping)"))
              (action_tile
                "accept"
                (strcat
                  "(progn "
                  "(setq *dccab-all-csize* (nth (atoi (get_tile \"cab_csize\")) '(4.0 6.0))) "
                  "(setq *dccab-all-neg-o* (get_tile \"cab_neg_o\")) "
                  "(setq *dccab-all-updown* (get_tile \"cab_updown\")) "
                  "(setq *dccab-all-trunk-mode* (nth (atoi (get_tile \"cab_trunk_mode\")) '(\"At\" \"Above\" \"Below\"))) "
                  "(setq *dccab-all-trunk-offset* (get_tile \"cab_trunk_offset\")) "
                  "(if (or (<= (atof *dccab-all-neg-o*) 0.0) "
                  "(<= (atof *dccab-all-updown*) 0.0) "
                  "(< (atof *dccab-all-trunk-offset*) 0.0)) "
                  "(set_tile \"status\" \"Enter valid positive values. Offset can be 0 or more.\") "
                  "(done_dialog 1)))"))
              (action_tile "cancel" "(done_dialog 0)")
              (setq result (start_dialog))
              (unload_dialog dcl-id)
              (if (= result 1)
                (list *dccab-all-csize*
                      (atof *dccab-all-neg-o*)
                      (atof *dccab-all-updown*)
                      *dccab-all-trunk-mode*
                      (atof *dccab-all-trunk-offset*))
                nil))))))))

(defun dcstr-open-dialog (/ dcl-path dcl-id result dflt-mps dflt-num-inv dflt-spi)
  (setq dcl-path (dcstr-find-dcl))
  (if (null dcl-path)
    (progn (alert "Cannot find:\nSolarPro - DC Stringing Dialog.dcl") nil)
    (progn
  (setq dcl-id (load_dialog dcl-path))
      (if (or (null dcl-id) (minusp dcl-id))
        (progn (alert "Failed to load DC stringing dialog.") nil)
        (progn
          (if (not (new_dialog "dcstringing_dialog" dcl-id))
            (progn (unload_dialog dcl-id) (alert "Failed to open DC stringing dialog.") nil)
            (progn
              (setq dflt-mps (if (and (boundp '*asd-mps*) (> *asd-mps* 0)) (itoa *asd-mps*) "18")
                    dflt-num-inv (if (and (boundp '*asd-num-inv*) (> *asd-num-inv* 0)) (itoa *asd-num-inv*) "1")
                    dflt-spi (if (and (boundp '*asd-spi*) (> *asd-spi* 0)) (itoa *asd-spi*) "1"))
              (set_tile "dc_mps" dflt-mps)
              (set_tile "dc_num_inv" dflt-num-inv)
              (set_tile "dc_spi" dflt-spi)
              (if (null *asd-string-method*) (setq *asd-string-method* "U-String"))
              (if (null *asd-string-direction*) (setq *asd-string-direction* "Left to Right"))
              (start_list "string_method")
              (add_list "U-String")
              (add_list "Single-Row")
              (add_list "Leapfrog")
              (end_list)
              (set_tile "string_method"
                        (itoa (cond
                                ((= *asd-string-method* "Single-Row") 1)
                                ((= *asd-string-method* "Leapfrog") 2)
                                (T 0))))
              (start_list "string_direction")
              (add_list "Left to Right")
              (add_list "Right to Left")
              (end_list)
              (set_tile "string_direction"
                        (itoa (if (= *asd-string-direction* "Right to Left") 1 0)))
              (action_tile "string_method" "(asd-method-changed $value)")
              (action_tile "string_direction" "(asd-direction-changed $value)")
              (action_tile "accept"
                "(progn
                   (setq *dcstr-mps* (atoi (get_tile \"dc_mps\")))
                   (setq *dcstr-num-inv* (atoi (get_tile \"dc_num_inv\")))
                   (setq *dcstr-spi* (atoi (get_tile \"dc_spi\")))
                   (if (or (<= *dcstr-mps* 0) (<= *dcstr-num-inv* 0) (<= *dcstr-spi* 0))
                     (set_tile \"status\" \"Please enter positive values for all DC stringing inputs.\")
                     (done_dialog 1)))")
              (action_tile "cancel" "(done_dialog 0)")
              (asd-method-changed (get_tile "string_method"))
              (setq result (start_dialog))
              (unload_dialog dcl-id)
              (if (= result 1)
                (list result *dcstr-mps* *dcstr-num-inv* *dcstr-spi* *asd-string-method* *asd-string-direction*)
                nil))))))))

;; Called when user clicks the Calculate button inside the dialog.
;; Uses 3-condition temperature-corrected voltage check (matches SLD tool):
;;   Cond A  String Voc at T_min_ambient  <= Vdc_max       (absolute safety)
;;   Cond B  String Voc at T_min_operating <= MPPT_Vmax    (MPPT upper limit)
;;   Cond C  String Vmp at T_max_cell     >= MPPT_Vmin     (MPPT lower limit)
(defun asd-do-calculate (/ voc vmp isc inv_kw num_inv_d vdc_max num_mppt
                            mppt_vmin mppt_vmax mppt_imax mppt_inputs watt mpt
                            tc_voc tc_vmp t_min t_max t_max_cell
                            voc_cold vmp_hot
                            mps_a mps_b mps_c_min mps_raw mps tps spt
                            spm spi tpi ratio total
                            str_voc_a str_voc_b str_vmp_c
                            ok_a ok_b ok_c test_m best_mps best_tps best_spt)
  (setq voc         (atof (get_tile "s_voc"))
        vmp         (atof (get_tile "s_vmp"))
        isc         (atof (get_tile "s_isc"))
        inv_kw      (atof (get_tile "s_inv_kw"))
        num_inv_d   (atoi (get_tile "s_num_inv"))
        vdc_max     (atof (get_tile "s_vdc_max"))
        num_mppt    (atoi (get_tile "s_num_mppt"))
        mppt_inputs (atoi (get_tile "s_mppt_inputs")) ; NEW: Read inputs per MPPT
        mppt_vmin   (atof (get_tile "s_mppt_vmin"))
        mppt_vmax   (atof (get_tile "s_mppt_vmax"))
        mppt_imax   (atof (get_tile "s_mppt_imax"))
        watt        (atof (get_tile "s_watt"))
        tc_voc      (atof (get_tile "s_tc_voc"))   
        tc_vmp      (atof (get_tile "s_tc_vmp"))   
        t_min       (atof (get_tile "s_t_min"))    
        t_max       (atof (get_tile "s_t_max"))    
        t_max_cell  t_max                          
        mpt         (if (and (boundp '*asd-mpt*) (> *asd-mpt* 0)) *asd-mpt* 1))
        
  (if (<= mppt_inputs 0) (setq mppt_inputs 1)) ; Safe fallback

  (if (or (<= voc 0.0) (<= vmp 0.0) (<= isc 0.0)
          (<= inv_kw 0.0) (= num_inv_d 0) (<= vdc_max 0.0)
          (= num_mppt 0) (<= mppt_vmax 0.0))
    (progn (set_tile "status" "ERROR: Fill in all required values before calculating.") (exit)))

  (setq voc_cold (* voc (+ 1.0 (* (/ tc_voc 100.0) (- t_min 25.0)))))
  (setq vmp_hot  (* vmp (+ 1.0 (* (/ tc_vmp 100.0) (- t_max_cell 25.0)))))

  (setq mps_a     (fix (/ vdc_max   voc_cold))            
        mps_b     (fix (/ mppt_vmax  voc_cold))            
        mps_c_min (fix (+ 0.9999 (/ mppt_vmin vmp_hot)))) 

  (setq mps_raw (min mps_a mps_b))

  (setq best_mps 0 best_tps 1 best_spt 1 test_m mps_raw)
        
  (while (>= test_m mps_c_min)
    (if (= best_mps 0)
      (cond
        ((= (rem test_m mpt) 0)
         (setq best_mps test_m best_tps (/ test_m mpt) best_spt 1))
        ((= (rem mpt test_m) 0)
         (setq best_mps test_m best_tps 1 best_spt (/ mpt test_m)))
      )
    )
    (setq test_m (1- test_m)))

  ;; FALLBACK: If no clean match, use Max String and allow spanning
  (if (= best_mps 0)
      (setq best_mps mps_raw best_tps 0 best_spt 0)) ; 0 signifies spanning

  (if (> best_mps 0)
    (progn
      (setq mps best_mps tps best_tps spt best_spt)
      (setq str_voc_a (* mps voc_cold)
            str_voc_b (* mps voc_cold)
            str_vmp_c (* mps vmp_hot)
            ok_a (<= str_voc_a vdc_max)
            ok_b (<= str_voc_b mppt_vmax)
            ok_c (>= str_vmp_c mppt_vmin))
            
      ;; NEW: Constrain Strings per MPPT strictly by inputs AND max current
      (setq spm (min mppt_inputs (if (> isc 0.0) (fix (/ mppt_imax isc)) 1)))
            
      (set_tile "r_cond_a" (strcat "Cond A  " (rtos str_voc_a 2 1) " V <= " (rtos vdc_max 2 0) " V  [Voc @ " (rtos t_min 2 0) "C]  " (if ok_a "PASS" "FAIL")))
      (set_tile "r_cond_b" (strcat "Cond B  " (rtos str_voc_b 2 1) " V <= " (rtos mppt_vmax 2 0) " V  [Voc @ " (rtos t_min 2 0) "C]  " (if ok_b "PASS" "FAIL")))
      (set_tile "r_cond_c" (strcat "Cond C  " (rtos str_vmp_c 2 1) " V >= " (rtos mppt_vmin 2 0) " V  [Vmp @ " (rtos t_max_cell 2 0) "C]  " (if ok_c "PASS" "FAIL")))
                
      (if (and (> tps 0) (> spt 0))
          (if (> tps 1)
            (set_tile "r_mps" (strcat "Modules per String    : " (itoa mps) "  (" (itoa tps) " tables of " (itoa mpt) ")"))
            (set_tile "r_mps" (strcat "Modules per String    : " (itoa mps) "  (" (itoa spt) " strings per table of " (itoa mpt) ")")))
          (set_tile "r_mps" (strcat "Modules per String    : " (itoa mps) "  (Spans across tables)")))
      
      (if (= spm 0)
        (progn
          (set_tile "r_spm"   (strcat "Strings per MPPT     : 0  (Isc " (rtos isc 2 2) " A > MPPT limit " (rtos mppt_imax 2 1) " A)"))
          (set_tile "r_spi"   "Strings per Inverter : ---")
          (set_tile "r_tpi"   "Tables per Inverter  : ---")
          (set_tile "r_ratio" "DC / AC Ratio        : ---")
          (set_tile "r_total" "Total Tables Needed  : ---")
          (set_tile "status"  (strcat "Isc (" (rtos isc 2 2) " A) exceeds Max Current/MPPT (" (rtos mppt_imax 2 1) " A).  Check Isc value."))
          (setq *asd-calc-mps* 0  *asd-calc-spi* 0))
        (progn
          (setq spi   (* spm num_mppt)
                tpi   (max 1 (fix (+ 0.9999 (/ (* (float spi) mps) mpt))))
                total (* num_inv_d tpi)
                ratio (if (> inv_kw 0.0) (/ (* spi mps watt) (* inv_kw 1000.0)) 0.0))
                
          (set_tile "r_spm"   (strcat "Strings per MPPT     : " (itoa spm)))
          (set_tile "r_spi"   (strcat "Strings per Inverter : " (itoa spi)))
          (if (> tps 1)
            (set_tile "r_tpi"   (strcat "Tables per Inverter  : " (itoa tpi) "  (" (itoa tps) " tbl/str)"))
            (set_tile "r_tpi"   (strcat "Tables per Inverter  : " (itoa tpi) "  (" (itoa spt) " str/tbl)")))
          (set_tile "r_ratio" (strcat "DC / AC Ratio        : " (rtos ratio 2 3)))
          (set_tile "r_total" (strcat "Total Tables Needed  : " (itoa total)))
          
          (cond
            ((not ok_a) (set_tile "status" (strcat "FAIL Cond A: " (rtos str_voc_a 2 1) " V > Vdc_max " (rtos vdc_max 2 0) " V.")))
            ((not ok_b) (set_tile "status" (strcat "FAIL Cond B: " (rtos str_voc_b 2 1) " V > MPPT_Vmax " (rtos mppt_vmax 2 0) " V.")))
            ((not ok_c) (set_tile "status" (strcat "FAIL Cond C: " (rtos str_vmp_c 2 1) " V < MPPT_Vmin " (rtos mppt_vmin 2 0) " V.  String too short.")))
            (T (set_tile "status" "SUCCESS: Valid string match found! Click OK to start stringing.")))
            
          (setq *asd-calc-mps* (if (and ok_a ok_b ok_c) mps 0)
                *asd-calc-spi* (if (and ok_a ok_b ok_c) spi 0))))
    )
    ;; NEW: Highly explicit Validation Error for incompatible table sizes
    (progn
      (set_tile "r_cond_a" "Cond A : ---")
      (set_tile "r_cond_b" "Cond B : ---")
      (set_tile "r_cond_c" "Cond C : ---")
      (set_tile "r_mps"    (strcat "Max/Min Modules per String : " (itoa mps_raw) " to " (itoa mps_c_min)))
      (set_tile "r_spm"    "Strings per MPPT     : ---")
      (set_tile "r_spi"    "Strings per Inverter : ---")
      (set_tile "r_tpi"    "Tables per Inverter  : ---")
      (set_tile "r_ratio"  "DC / AC Ratio        : ---")
      (set_tile "r_total"  "Total Tables Needed  : ---")
      (set_tile "status"   (strcat "VALIDATION ERROR: Table Size (" (itoa mpt) ") cannot be formed by Max String (" (itoa mps_raw) "). Adjust Table Size or Voc."))
      (setq *asd-calc-mps* 0  *asd-calc-spi* 0)
    )
  )
)

;; Called when user clicks OK inside the dialog.
(defun asd-do-accept ()
  (asd-cache-accept-fields)
  (done_dialog 1))

(defun asd-current-inv-placement ()
  (nth
    (if (and (boundp '*asd-s-inv-place*) *asd-s-inv-place*)
      (atoi *asd-s-inv-place*)
      1)
    '("Left" "Center" "Right")))

(defun asd-current-grouping-mode ()
  (nth
    (if (and (boundp '*asd-s-group-mode*) *asd-s-group-mode*)
      (atoi *asd-s-group-mode*)
      0)
    '("Linear Strip" "Compact Block")))

;; Open the Auto Stringing dialog.
;; bnd_ent  the boundary polyline entity (for context; not passed into dialog).
(defun asd-open-dialog (bnd_ent / dcl-path dcl-id result)
  (setq dcl-path (asd-find-dcl))
  (if (null dcl-path)
    (progn (alert "Cannot find:\nSolarPro - Stringing Dialog.dcl") (exit)))
  (setq dcl-id (load_dialog dcl-path))
  (if (or (null dcl-id) (minusp dcl-id))
    (progn (alert "Failed to load stringing DCL.") (exit)))
  (setq result 5)
  (while (= result 5)
    (if (not (new_dialog "autostring_dialog" dcl-id))
      (progn (unload_dialog dcl-id) (alert "Failed to open stringing dialog.") (exit)))

    ;; Pre-fill fields  use saved globals from last run, or sensible defaults.
    (set_tile "s_voc"
      (if (and (boundp '*asd-s-voc*)      *asd-s-voc*)      *asd-s-voc*      "43.4"))
    (set_tile "s_vmp"
      (if (and (boundp '*asd-s-vmp*)      *asd-s-vmp*)      *asd-s-vmp*      "40.9"))
    (set_tile "s_isc"
      (if (and (boundp '*asd-s-isc*)      *asd-s-isc*)      *asd-s-isc*      "18.37"))
    (set_tile "s_imp"
      (if (and (boundp '*asd-s-imp*)      *asd-s-imp*)      *asd-s-imp*      "17.43"))
    (set_tile "s_watt"
      (cond
        ((and (boundp '*asd-s-watt*)  *asd-s-watt*)  *asd-s-watt*)
        ((and (boundp '*asd-xd-watt*) (> *asd-xd-watt* 0.0))
         (rtos *asd-xd-watt* 2 0))
        (T "610")))
    (set_tile "s_inv_kw"
      (if (and (boundp '*asd-s-inv_kw*)   *asd-s-inv_kw*)   *asd-s-inv_kw*   "125.0"))
    (set_tile "s_dcac_ratio"
      (if (and (boundp '*asd-s-dcac-ratio*) *asd-s-dcac-ratio*) *asd-s-dcac-ratio* "1.20"))
    (set_tile "s_num_inv"
      (if (and (boundp '*asd-s-num_inv*)  *asd-s-num_inv*)  *asd-s-num_inv*  "1"))
    (start_list "s_inv_place")
    (add_list "Left")
    (add_list "Center")
    (add_list "Right")
    (end_list)
    (set_tile "s_inv_place"
      (if (and (boundp '*asd-s-inv-place*) *asd-s-inv-place*) *asd-s-inv-place* "1"))
    (start_list "s_group_mode")
    (add_list "Linear Strip")
    (add_list "Compact Block")
    (end_list)
    (set_tile "s_group_mode"
      (if (and (boundp '*asd-s-group-mode*) *asd-s-group-mode*) *asd-s-group-mode* "0"))
    (set_tile "s_vdc_max"
      (if (and (boundp '*asd-s-vdc_max*)  *asd-s-vdc_max*)  *asd-s-vdc_max*  "1500"))
    (set_tile "s_num_mppt"
      (if (and (boundp '*asd-s-num_mppt*) *asd-s-num_mppt*) *asd-s-num_mppt* "16"))
    (set_tile "s_mppt_inputs"
      (if (and (boundp '*asd-s-mppt_inputs*) *asd-s-mppt_inputs*) *asd-s-mppt_inputs* "2"))

    (if (and (boundp '*asd-total-mods*) *asd-total-mods*)
        (set_tile "s_total_mods" (strcat "Total Modules: " (itoa *asd-total-mods*) " nos")))
    (if (and (boundp '*asd-site-dc-kw*) (> *asd-site-dc-kw* 0.0))
        (set_tile "s_site_kw" (strcat "Total DC Capacity: " (rtos *asd-site-dc-kw* 2 2) " kWp")))

    (set_tile "s_mppt_vmin"
      (if (and (boundp '*asd-s-mppt_vmin*) *asd-s-mppt_vmin*) *asd-s-mppt_vmin* "850"))
    (set_tile "s_mppt_vmax"
      (if (and (boundp '*asd-s-mppt_vmax*) *asd-s-mppt_vmax*) *asd-s-mppt_vmax* "1300"))
    (set_tile "s_mppt_imax"
      (if (and (boundp '*asd-s-mppt_imax*) *asd-s-mppt_imax*) *asd-s-mppt_imax* "13.0"))
    (set_tile "s_tc_voc"
      (if (and (boundp '*asd-s-tc_voc*) *asd-s-tc_voc*) *asd-s-tc_voc* "-0.30"))
    (set_tile "s_tc_vmp"
      (if (and (boundp '*asd-s-tc_vmp*) *asd-s-tc_vmp*) *asd-s-tc_vmp* "-0.35"))
    (set_tile "s_t_min"
      (if (and (boundp '*asd-s-t_min*) *asd-s-t_min*) *asd-s-t_min* "-10"))
    (set_tile "s_t_max"
      (if (and (boundp '*asd-s-t_max*) *asd-s-t_max*) *asd-s-t_max* "50"))
    (asd-init-db-controls)
    (if (and (boundp '*sp-selected-module-rec*) *sp-selected-module-rec*)
      (asd-apply-selected-module))
    (set_tile "status" "Fill in values, click Calculate, then OK to start stringing.")

    ;; Wire action tiles
    (action_tile "db_mod_mfr" "(asd-module-mfr-changed $value)")
    (action_tile "db_mod_model" "(asd-module-model-changed $value)")
    (action_tile "db_inv_mfr" "(asd-inverter-mfr-changed $value)")
    (action_tile "db_inv_model" "(asd-inverter-model-changed $value)")
    (action_tile "db_use_module" "(asd-apply-selected-module)")
    (action_tile "db_use_inverter" "(asd-apply-selected-inverter)")
    (action_tile "db_new_module" "(asd-cache-fields)(done_dialog 3)")
    (action_tile "db_new_inverter" "(asd-cache-fields)(done_dialog 4)")
    (action_tile "inv_recommend" "(asd-recommend-inverter-count)")
    (action_tile "calc_btn" "(asd-do-calculate)")
    (action_tile "accept"   "(asd-do-accept)")
    (action_tile "cancel"   "(done_dialog 0)")

    (setq result (start_dialog))
    (cond
      ((= result 3) (asd-cache-fields) (spdb-open-new-module-dialog) (setq result 5))
      ((= result 4) (asd-cache-fields) (spdb-open-new-inverter-dialog) (setq result 5))))

  (if (= result 1)
    (setq *asd-run*     T
          *asd-num-inv* (atoi *asd-s-num_inv*)
          *asd-mps*     (if (boundp '*asd-calc-mps*) *asd-calc-mps* 0)
          *asd-spi*     (if (boundp '*asd-calc-spi*) *asd-calc-spi* 0)))

  (unload_dialog dcl-id)
  (if (and dcl-path (findfile dcl-path)) (vl-file-delete dcl-path))
  result)

;; Scan the drawing for all entities that carry FS_SOLAR_DATA XDATA.
;; Returns a list of entity names.
(defun asd-find-boundaries (/ ss idx ename found)
  (setq found nil)
  (if (setq ss (ssget "_X" '((-3 ("FS_SOLAR_DATA")))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ename (ssname ss idx))
        (setq found (cons ename found))
        (setq idx (1+ idx)))))
  found)

(defun sld-popup-fill (key items idx)
  (start_list key)
  (foreach it items (add_list it))
  (end_list)
  (if (null idx) (setq idx 0))
  (if (< idx 0) (setq idx 0))
  (if (>= idx (length items)) (setq idx 0))
  (set_tile key (itoa idx)))

(defun sld-current-module-make ()
  (if (and (boundp '*asd-db-mod-mfrs*) *asd-db-mod-mfrs* (boundp '*asd-db-mod-mfr-idx*))
    (nth *asd-db-mod-mfr-idx* *asd-db-mod-mfrs*)
    ""))

(defun sld-current-module-model ()
  (if (and (boundp '*asd-db-mod-models*) *asd-db-mod-models* (boundp '*asd-db-mod-model-idx*))
    (nth *asd-db-mod-model-idx* *asd-db-mod-models*)
    ""))

(defun sld-current-inverter-make ()
  (if (and (boundp '*asd-db-inv-mfrs*) *asd-db-inv-mfrs* (boundp '*asd-db-inv-mfr-idx*))
    (nth *asd-db-inv-mfr-idx* *asd-db-inv-mfrs*)
    ""))

(defun sld-current-inverter-model ()
  (if (and (boundp '*asd-db-inv-models*) *asd-db-inv-models* (boundp '*asd-db-inv-model-idx*))
    (nth *asd-db-inv-model-idx* *asd-db-inv-models*)
    ""))

(defun sld-find-dcl (/ f)
  (setq f (spd-get-dcl "SolarPro - SLD.dcl"))
  (if f f (spd-get-dcl "SolarPro - SLD.dcl")))

(defun sld-open-dialog (/ dcl-path dcl-id result)
  (setq dcl-path (sld-find-dcl))
  (cond
    ((null dcl-path)
     (alert "Cannot find:\nSolarPro - SLD.dcl")
     nil)
    ((progn
  (setq dcl-id (load_dialog dcl-path))
       (or (null dcl-id) (minusp dcl-id)))
     (alert "Failed to load SLD dialog.")
     nil)
    ((not (new_dialog "createsld" dcl-id))
     (unload_dialog dcl-id)
     (alert "Failed to open SLD dialog.")
     nil)
    (T
     (setq *sld-inv-ac-kv-options* '("0.4" "0.8" "1.1")
           *sld-ht-kv-options*    '("11" "33" "66" "132")
           *sld-winding-options*  '("2 Winding" "3 Winding" "5 Winding")
           *sld-cooling-options*  '("ONAN" "ONAF" "ONAN/ONAF")
           *sld-oltc-options*     '("No" "Yes")
           *sld-sheet-options*    '("A3" "A2" "A1" "A0"))
     (set_tile "sld_mod_watt" (if *sld-mod-watt* *sld-mod-watt* ""))
     (set_tile "sld_total_mod" (if *sld-total-mod* *sld-total-mod* ""))
     (set_tile "sld_dc_kwp" (if *sld-dc-kwp* *sld-dc-kwp* ""))
     (set_tile "sld_mps" (if *sld-mps* *sld-mps* ""))
     (set_tile "sld_spi" (if *sld-spi* *sld-spi* ""))
     (set_tile "sld_num_inv" (if *sld-num-inv* *sld-num-inv* ""))
     (set_tile "sld_inv_make" (if *sld-inv-make* *sld-inv-make* ""))
     (set_tile "sld_inv_model" (if *sld-inv-model* *sld-inv-model* ""))
     (set_tile "sld_inv_kw" (if *sld-inv-kw* *sld-inv-kw* ""))
     (set_tile "sld_mppt" (if *sld-mppt* *sld-mppt* ""))
     (set_tile "sld_acdb_in" (if *sld-acdb-in* *sld-acdb-in* ""))
     (set_tile "sld_acdb_out" (if *sld-acdb-out* *sld-acdb-out* "1"))
     (set_tile "sld_acdb_rating" (if *sld-acdb-rating* *sld-acdb-rating* ""))
     (set_tile "sld_tf_rating" (if *sld-tf-rating* *sld-tf-rating* ""))
     (set_tile "sld_tf_lv" (if *sld-tf-lv* *sld-tf-lv* "0.8"))
     (set_tile "sld_tf_hv" (if *sld-tf-hv* *sld-tf-hv* "33"))
     (set_tile "sld_tf_imp" (if *sld-tf-imp* *sld-tf-imp* ""))
     (set_tile "sld_tf_vector" (if *sld-tf-vector* *sld-tf-vector* "Dyn11"))
     (set_tile "sld_ht_rating" (if *sld-ht-rating* *sld-ht-rating* ""))
     (sld-popup-fill "sld_inv_ac_kv" *sld-inv-ac-kv-options* (if *sld-inv-ac-kv-idx* *sld-inv-ac-kv-idx* 1))
     (sld-popup-fill "sld_tf_winding" *sld-winding-options* (if *sld-tf-winding-idx* *sld-tf-winding-idx* 0))
     (sld-popup-fill "sld_tf_cooling" *sld-cooling-options* (if *sld-tf-cooling-idx* *sld-tf-cooling-idx* 0))
     (sld-popup-fill "sld_tf_oltc" *sld-oltc-options* (if *sld-tf-oltc-idx* *sld-tf-oltc-idx* 0))
     (sld-popup-fill "sld_ht_kv" *sld-ht-kv-options* (if *sld-ht-kv-idx* *sld-ht-kv-idx* 1))
     (sld-popup-fill "sld_sheet" *sld-sheet-options* (if *sld-sheet-idx* *sld-sheet-idx* 2))
     (action_tile "accept"
       "(progn
          (setq *sld-mod-watt*   (get_tile \"sld_mod_watt\"))
          (setq *sld-total-mod*  (get_tile \"sld_total_mod\"))
          (setq *sld-dc-kwp*     (get_tile \"sld_dc_kwp\"))
          (setq *sld-mps*        (get_tile \"sld_mps\"))
          (setq *sld-spi*        (get_tile \"sld_spi\"))
          (setq *sld-num-inv*    (get_tile \"sld_num_inv\"))
          (setq *sld-inv-make*   (get_tile \"sld_inv_make\"))
          (setq *sld-inv-model*  (get_tile \"sld_inv_model\"))
          (setq *sld-inv-kw*     (get_tile \"sld_inv_kw\"))
          (setq *sld-mppt*       (get_tile \"sld_mppt\"))
          (setq *sld-acdb-in*    (get_tile \"sld_acdb_in\"))
          (setq *sld-acdb-out*   (get_tile \"sld_acdb_out\"))
          (setq *sld-acdb-rating* (get_tile \"sld_acdb_rating\"))
          (setq *sld-tf-rating*  (get_tile \"sld_tf_rating\"))
          (setq *sld-tf-lv*      (get_tile \"sld_tf_lv\"))
          (setq *sld-tf-hv*      (get_tile \"sld_tf_hv\"))
          (setq *sld-tf-imp*     (get_tile \"sld_tf_imp\"))
          (setq *sld-tf-vector*  (get_tile \"sld_tf_vector\"))
          (setq *sld-ht-rating*  (get_tile \"sld_ht_rating\"))
          (setq *sld-inv-ac-kv-idx* (atoi (get_tile \"sld_inv_ac_kv\")))
          (setq *sld-tf-winding-idx* (atoi (get_tile \"sld_tf_winding\")))
          (setq *sld-tf-cooling-idx* (atoi (get_tile \"sld_tf_cooling\")))
          (setq *sld-tf-oltc-idx* (atoi (get_tile \"sld_tf_oltc\")))
          (setq *sld-ht-kv-idx*   (atoi (get_tile \"sld_ht_kv\")))
          (setq *sld-sheet-idx*   (atoi (get_tile \"sld_sheet\")))
          (done_dialog 1))")
     (action_tile "cancel" "(done_dialog 0)")
     (setq result (start_dialog))
     (unload_dialog dcl-id)
     result)))

(defun c:CREATESLD (/ boundaries nbnd bnd_ent xdata xd mod_row mod_stk total_tables_bnd total_mods site_kwp result)
  (vl-load-com)
  (setq boundaries (asd-find-boundaries)
        nbnd       (length boundaries))
  (cond
    ((= nbnd 1) (setq bnd_ent (car boundaries)) (princ "\nBoundary detected automatically for SLD."))
    ((> nbnd 1)
     (princ (strcat "\n" (itoa nbnd) " boundaries found. Select the one for SLD: "))
     (setq bnd_ent (car (entsel))))
    (T
     (princ "\nNo SolarPro boundary found. Select boundary polyline for SLD: ")
     (setq bnd_ent (car (entsel)))))
  (if (null bnd_ent) (progn (princ "\nSLD cancelled.") (exit)))
  (setq xdata (cdr (assoc -3 (entget bnd_ent '("FS_SOLAR_DATA")))))
  (if (and xdata (= (caar xdata) "FS_SOLAR_DATA"))
    (progn
      (setq xd             (cdar xdata)
            mod_row        (fix (sp-xd-item-val (nth 7 xd)))
            mod_stk        (fix (sp-xd-item-val (nth 8 xd)))
            total_tables_bnd (length (GetTablesInBoundary bnd_ent))
            total_mods     (* total_tables_bnd (max 1 mod_row) (max 1 mod_stk))
            site_kwp       (/ (* (float total_mods) (sp-xd-item-val (nth 2 xd))) 1000.0))
      (setq *sld-mod-watt*  (rtos (sp-xd-item-val (nth 2 xd)) 2 0)
            *sld-total-mod* (itoa total_mods)
            *sld-dc-kwp*    (rtos site_kwp 2 2)))
    (progn
      (if (and (boundp '*asd-xd-watt*) *asd-xd-watt*) (setq *sld-mod-watt* (rtos *asd-xd-watt* 2 0)))
      (if (and (boundp '*asd-total-mods*) *asd-total-mods*) (setq *sld-total-mod* (itoa *asd-total-mods*)))
      (if (and (boundp '*asd-site-dc-kw*) *asd-site-dc-kw*) (setq *sld-dc-kwp* (rtos *asd-site-dc-kw* 2 2)))))
  (if (and (boundp '*asd-mps*) *asd-mps* (> *asd-mps* 0)) (setq *sld-mps* (itoa *asd-mps*)))
  (if (and (boundp '*asd-spi*) *asd-spi* (> *asd-spi* 0)) (setq *sld-spi* (itoa *asd-spi*)))
  (if (and (boundp '*asd-num-inv*) *asd-num-inv* (> *asd-num-inv* 0)) (setq *sld-num-inv* (itoa *asd-num-inv*)))
  (setq *sld-inv-make*  (sld-current-inverter-make)
        *sld-inv-model* (sld-current-inverter-model))
  (if (and (boundp '*asd-s-inv_kw*) *asd-s-inv_kw*) (setq *sld-inv-kw* *asd-s-inv_kw*))
  (if (and (boundp '*asd-s-num_mppt*) *asd-s-num_mppt*) (setq *sld-mppt* *asd-s-num_mppt*))
  (if (or (null *sld-acdb-in*) (= *sld-acdb-in* "")) (setq *sld-acdb-in* *sld-num-inv*))
  (if (or (null *sld-acdb-out*) (= *sld-acdb-out* "")) (setq *sld-acdb-out* "1"))
  (setq result (sld-open-dialog))
  (if (= result 1)
    (progn
      (setq *sld-inv-ac-kv*  (nth *sld-inv-ac-kv-idx* *sld-inv-ac-kv-options*)
            *sld-tf-winding* (nth *sld-tf-winding-idx* *sld-winding-options*)
            *sld-tf-cooling* (nth *sld-tf-cooling-idx* *sld-cooling-options*)
            *sld-tf-oltc*    (nth *sld-tf-oltc-idx* *sld-oltc-options*)
            *sld-ht-kv*      (nth *sld-ht-kv-idx* *sld-ht-kv-options*)
            *sld-sheet*      (nth *sld-sheet-idx* *sld-sheet-options*))
      (princ "\nSLD setup saved. Basic dialog ready for future SLD drawing generation."))
    (princ "\nSLD setup cancelled."))
  (princ))

(defun c:SLD ()
  (c:CREATESLD))

;; Get all TABLE_* inserts within a boundary polyline
(defun GetTablesInBoundary (boundary-ent / ss idx ename blk-name verts tables)
  (setq verts (get-poly-approx-vertices boundary-ent)
        tables nil)
  (if (and verts (setq ss (ssget "_X" '((0 . "INSERT")))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ename (ssname ss idx)
              blk-name (cdr (assoc 2 (entget ename))))
        (if (and blk-name 
                 (wcmatch (strcase blk-name) "TABLE_*")
                 (PointInPolygonList (cdr (assoc 10 (entget ename))) verts))
          (setq tables (cons ename tables)))
        (setq idx (1+ idx)))))
  tables)

;; Main command  auto-detect boundary, open dialog, run stringing on OK.
(defun c:AUTOSTRINGDIALOG (/ bnd_ent xdata xd p_watt_xd mod_row mod_stk mpt result
                              boundaries nbnd)
  (vl-load-com)
  ;; Step 1: Auto-detect or select boundary
  (setq boundaries (asd-find-boundaries)
        nbnd       (length boundaries))
  (cond
    ;; Exactly one boundary  use it automatically
    ((= nbnd 1)
     (setq bnd_ent (car boundaries))
     (princ "\nBoundary detected automatically."))
    ;; Multiple boundaries  ask user to pick
    ((> nbnd 1)
     (princ (strcat "\n" (itoa nbnd) " boundaries found. Select the one to string: "))
     (setq bnd_ent (car (entsel)))
     (if (null bnd_ent)
       (progn (princ "\nCancelled.") (exit))))
    ;; No boundary with XDATA  ask user to select manually
    (T
     (princ "\nNo SolarPro boundary found. Select boundary polyline manually: ")
     (setq bnd_ent (car (entsel)))
     (if (null bnd_ent)
       (progn (princ "\nCancelled.") (exit)))))

  ;; Step 2: Read XDATA to get table size and module wattage
  (setq xdata (cdr (assoc -3 (entget bnd_ent '("FS_SOLAR_DATA")))))
  (if (and xdata (= (caar xdata) "FS_SOLAR_DATA"))
    (progn
      (setq xd             (cdar xdata)
            p_watt_xd      (sp-xd-item-val (nth 2 xd))
            mod_row        (fix (sp-xd-item-val (nth 7 xd)))
            mod_stk        (fix (sp-xd-item-val (nth 8 xd)))
            placement_type (if (and (nth 12 xd) (= (type (sp-xd-item-val (nth 12 xd))) 'STR))
                             (sp-xd-item-val (nth 12 xd))
                             "Table"))
      (if (or (= placement_type "Continuous") (<= mod_row 0))
        (progn
          (alert "AutoString currently supports table-based layouts only.\n\nThis boundary was generated in Continuous mode, so there are no TABLE_* blocks available for stringing.")
          (exit)))
      (setq mpt (* mod_row mod_stk))
      (setq total_tables_bnd (length (GetTablesInBoundary bnd_ent)))
      (setq *asd-total-mods* (* total_tables_bnd mpt))
      (setq *asd-site-dc-kw* (/ (* (float *asd-total-mods*) p_watt_xd) 1000.0))
      (setq *asd-xd-watt* p_watt_xd
            *asd-mpt*     mpt
            *asd-mod-row* mod_row
            *asd-mod-stk* mod_stk
            *asd-bnd-ent* bnd_ent
            ;; Module geometry for per-row coloring (indices 0,1,3,9,10,11)
            *asd-xd-pw*   (sp-xd-item-val (nth 0  xd))   ; module width
            *asd-xd-ph*   (sp-xd-item-val (nth 1  xd))   ; module height
            *asd-xd-tilt* (sp-xd-item-val (nth 3  xd))   ; tilt angle
            *asd-xd-ori*  (sp-xd-item-val (nth 9  xd))   ; 1.0=Portrait 2.0=Landscape
            *asd-xd-mgh*  (sp-xd-item-val (nth 10 xd))   ; gap between module columns
            *asd-xd-mgv*  (sp-xd-item-val (nth 11 xd)))
      ;; Pre-fill stringing dialog with module electrical data from XDATA (indices 14-21)
      ;; Only overwrite if XDATA has a non-zero value (i.e. was filled in SolarProDialog)
      (if (and (nth 14 xd) (> (sp-xd-item-val (nth 14 xd)) 0.0)) (setq *asd-s-voc*    (rtos (sp-xd-item-val (nth 14 xd)) 2 2)))
      (if (and (nth 15 xd) (> (sp-xd-item-val (nth 15 xd)) 0.0)) (setq *asd-s-vmp*    (rtos (sp-xd-item-val (nth 15 xd)) 2 2)))
      (if (and (nth 16 xd) (> (sp-xd-item-val (nth 16 xd)) 0.0)) (setq *asd-s-isc*    (rtos (sp-xd-item-val (nth 16 xd)) 2 2)))
      (if (and (nth 17 xd) (> (sp-xd-item-val (nth 17 xd)) 0.0)) (setq *asd-s-imp*    (rtos (sp-xd-item-val (nth 17 xd)) 2 2)))
      (if (nth 18 xd) (setq *asd-s-tc_voc*  (rtos (sp-xd-item-val (nth 18 xd)) 2 2)))
      (if (nth 19 xd) (setq *asd-s-tc_vmp*  (rtos (sp-xd-item-val (nth 19 xd)) 2 2)))
      (if (nth 20 xd) (setq *asd-s-t_min*   (rtos (sp-xd-item-val (nth 20 xd)) 2 0)))
      (if (nth 21 xd) (setq *asd-s-t_max*   (rtos (sp-xd-item-val (nth 21 xd)) 2 0)))
      (princ (strcat "\nXDATA: " (itoa mod_row) " x " (itoa mod_stk)
                     " = " (itoa mpt) " modules/table  |  "
                     (rtos p_watt_xd 2 0) " Wp/module")))
    (progn
      ;; No XDATA  fall back to manual entry of the 3 essential values
      (princ "\nNo XDATA on boundary. Enter table configuration manually.")
      (setq mod_row (getint "\nModules per Row in one table <1>: "))
      (if (null mod_row) (setq mod_row 1))
      (setq mod_stk (getint "\nModules per Stack in one table <1>: "))
      (if (null mod_stk) (setq mod_stk 1))
      (setq p_watt_xd (getreal "\nModule Wattage (Wp) <615>: "))
      (if (null p_watt_xd) (setq p_watt_xd 615.0))
      (setq mpt (* mod_row mod_stk))
      (setq total_tables_bnd (length (GetTablesInBoundary bnd_ent)))
      (setq *asd-total-mods* (* total_tables_bnd mpt))
      (setq *asd-site-dc-kw* (/ (* (float *asd-total-mods*) p_watt_xd) 1000.0))
      (setq *asd-xd-watt* p_watt_xd
            *asd-mpt*     mpt
            *asd-mod-row* mod_row
            *asd-mod-stk* mod_stk
            *asd-bnd-ent* bnd_ent
            *asd-xd-pw*   0.0   ; no geometry  will use bounding-box hatch fallback
            *asd-xd-ph*   0.0)))

  ;; Step 3: Open the dialog
  (setq result (asd-open-dialog bnd_ent))

  ;; Step 4: On OK, validate and run stringing
  (if (= result 1)
    (progn
      (if (or (= *asd-mps* 0) (= *asd-spi* 0) (= *asd-num-inv* 0))
        (progn
          (alert "Please click Calculate before clicking OK.\nStringing cancelled.")
          (setq *asd-run* nil)
          (exit)))
      (princ (strcat "\nRunning stringing: "
                     (itoa *asd-mps*) " mods/string, "
                     (itoa *asd-spi*) " strings/inv, "
                     (itoa *asd-num-inv*) " inverters."))
      (c:AUTOSTRING)
      ;; Save electrical data into the boundary's existing XDATA (append indices 14-21).
      ;; Reads the current FS_SOLAR_DATA group, keeps indices 0-13, then writes
      ;; the full 22-field list so layout data is preserved.
      (if (and *asd-bnd-ent* (entget *asd-bnd-ent*))
        (progn
          (if (not (tblsearch "APPID" "FS_SOLAR_DATA")) (regapp "FS_SOLAR_DATA"))
          (setq asd-cur-xd (cdr (assoc -3 (entget *asd-bnd-ent* '("FS_SOLAR_DATA")))))
          (if (and asd-cur-xd (= (caar asd-cur-xd) "FS_SOLAR_DATA"))
            (progn
              ;; Keep the existing layout fields (indices 0-13), strip any old electrical
              (setq asd-base (vl-remove-if
                               '(lambda (x) (not (member (car x) '(1040 1000))))
                               (cdar asd-cur-xd)))
              ;; Truncate to first 14 entries (the layout fields)
              (setq asd-base (list (nth 0 asd-base) (nth 1 asd-base) (nth 2 asd-base)
                                   (nth 3 asd-base) (nth 4 asd-base) (nth 5 asd-base)
                                   (nth 6 asd-base) (nth 7 asd-base) (nth 8 asd-base)
                                   (nth 9 asd-base) (nth 10 asd-base) (nth 11 asd-base)
                                   (nth 12 asd-base) (nth 13 asd-base)))
              (setq asd-new-xd
                (list -3 (append
                  (list "FS_SOLAR_DATA")
                  asd-base
                  (list
                    (cons 1040 (atof *asd-s-voc*))
                    (cons 1040 (atof *asd-s-vmp*))
                    (cons 1040 (atof *asd-s-isc*))
                    (cons 1040 (atof *asd-s-imp*))
                    (cons 1040 (atof *asd-s-tc_voc*))
                    (cons 1040 (atof *asd-s-tc_vmp*))
                    (cons 1040 (atof *asd-s-t_min*))
                    (cons 1040 (atof *asd-s-t_max*))))))
              (setq asd-ed (vl-remove-if '(lambda (x) (= (car x) -3))
                                          (entget *asd-bnd-ent* '("FS_SOLAR_DATA"))))
              (entmod (append asd-ed (list asd-new-xd)))))))
      (setq *asd-run* nil))
    (progn
      (setq *asd-run* nil)
      (princ "\nStringing cancelled.")))
  (princ))
(defun c:INVERTERGROUPINGDIALOG ()
  (c:AUTOSTRINGDIALOG))

(defun c:INVERTERGROUPING ()
  (c:AUTOSTRINGDIALOG))


;;;------------------------------------------------------------
;;; Auto-load message
;;;------------------------------------------------------------
(defun EnsureACDBLayer ()
  (if (not (tblsearch "LAYER" "ACDB"))
    (entmake (list '(0 . "LAYER") 
                   '(100 . "AcDbSymbolTableRecord") 
                   '(100 . "AcDbLayerTableRecord")
                   '(2 . "ACDB") 
                   '(70 . 0) 
                   '(62 . 1) ; Red for ACDB
                    '(6 . "Continuous"))))
)

;; Initialize layers on load
(EnsureACDBLayer)
(princ "\nSolarPro version 4.3 loaded successfully.")
(princ "\n===================================================")
(princ "\n  SolarPro loaded. Commands:")
(princ "\n  SolarProDialog      - Dialog + GenerateLayout")
(princ "\n  GenerateLayout      - Manual prompts layout")
(princ "\n  Refresh             - Refresh existing layout")
(princ "\n  SHADOW              - Pole/LA shadow  | Red | Winter Solstice")
(princ "\n  BSHADOW             - Building shadow  | Orange (>3m) / Blue (<=3m)")
(princ "\n  AUTOSTRINGDIALOG    - Alias: inverter grouping dialog")
(princ "\n  INVERTERGROUPINGDIALOG - Dialog: module/inverter setup + grouping")
(princ "\n  INVERTERGROUPING   - Alias: inverter grouping dialog")
(princ "\n  CREATESLD          - Open Single Line Diagram setup dialog")
(princ "\n  SLD                - Alias for CREATESLD")
(princ "\n  AUTOSTRING          - Auto color tables by inverter (manual)")
(princ "\n  CLEARSTRINGING      - Remove all inverter colors")
(princ "\n  DCCABLINGALL        - Batch DC cable ALL inverters in one run (NEW)")
(princ "\n  PILELABELS          - Label coordinates of all table piles (+ CSV export)")
(princ "\n  CLEARPILELABELS     - Delete all pile coordinate labels from drawing")
(princ "\n  SHADOWCOORDS        - Label E/N coordinates of all LA/pole bases")
(princ "\n  CLEARSHADOWCOORDS   - Delete all shadow coordinate labels")
(princ "\n===================================================")
(princ)

(defun spd-street-lighting-summary (/ ss k bname SL-count)
  (setq SL-count 0)
  (setq ss (ssget "_X" '((0 . "INSERT") (2 . "solarpro_streetlight"))))
  (if ss (setq SL-count (sslength ss)))
  (if (> SL-count 0)
    (list (list "Total Streetlights" (itoa SL-count)))
    nil))

;;;------------------------------------------------------------
;;; Automated Piling Coordinate Exporter & Labeler
;;;------------------------------------------------------------
(defun c:PileLabels
  (/ ss i ent edate bname ins rot b_ent b_edate c_list cx cy gx gy f csv_path do_csv
     pile_count old_labels j max_x is_last b_min_x b_max_x b_min_y b_max_y
     etype x1 x2 y1 y2 g_y1 g_y2 g_y3 g_y4 g_max_y clearance_y)
  (prompt "\nSelect Solar Table blocks for pile extraction: ")
  (setq ss (ssget '((0 . "INSERT") (2 . "TABLE_*,table_*"))))
  (if (not ss)
    (progn (princ "\nNotice: No TABLE_* blocks found. Labels skipped.") (exit)))
  
  ;; Create Layer
  (if (not (tblsearch "LAYER" "PILING_LABELS"))
    (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord")
                   '(100 . "AcDbLayerTableRecord")
                   '(2 . "PILING_LABELS") '(70 . 0) '(62 . 7) '(6 . "Continuous"))))
                   
  ;; Clear old labels to avoid overlapping remnants when regenerating
  (setq old_labels (ssget "X" '((8 . "PILING_LABELS"))))
  (if old_labels
    (progn
      (setq j 0)
      (while (< j (sslength old_labels))
        (entdel (ssname old_labels j))
        (setq j (1+ j)))
    )
  )
                   
  (setq do_csv "No")
  (setq f nil)

  (setq i 0 pile_count 1)
  (while (< i (sslength ss))
    (setq ent (ssname ss i))
    (setq edate (entget ent))
    (setq bname (cdr (assoc 2 edate)))
    (setq ins (cdr (assoc 10 edate)))
    (setq rot (cdr (assoc 50 edate))) ;; Rotation is in radians
    
    ;; Get bounding boundaries of the block geometry
    (setq b_ent (tblobjname "BLOCK" bname))
    (setq c_list nil)
    (setq b_min_x 1e99 b_max_x -1e99 b_min_y 1e99 b_max_y -1e99)
    (if b_ent
      (progn
        (setq b_ent (entnext b_ent))
        (while b_ent
          (setq b_edate (entget b_ent))
          (setq etype (cdr (assoc 0 b_edate)))
          (if (and (member etype '("CIRCLE" "POINT")) (= (strcase (cdr (assoc 8 b_edate))) "PILING"))
            (setq c_list (cons (cdr (assoc 10 b_edate)) c_list)))
          (if (= etype "LINE")
            (progn
              (setq x1 (car (assoc 10 b_edate)) y1 (cadr (assoc 10 b_edate)))
              (setq x2 (car (assoc 11 b_edate)) y2 (cadr (assoc 11 b_edate)))
              (if (< x1 b_min_x) (setq b_min_x x1))
              (if (> x1 b_max_x) (setq b_max_x x1))
              (if (< y1 b_min_y) (setq b_min_y y1))
              (if (> y1 b_max_y) (setq b_max_y y1))
              (if (< x2 b_min_x) (setq b_min_x x2))
              (if (> x2 b_max_x) (setq b_max_x x2))
              (if (< y2 b_min_y) (setq b_min_y y2))
              (if (> y2 b_max_y) (setq b_max_y y2))))
          (setq b_ent (entnext b_ent)))))
          
    (if (= b_max_y -1e99) (setq b_max_y 2.25 b_min_y -2.25 b_max_x 5.0 b_min_x 0.0))
    (setq g_y1 (+ (cadr ins) (+ (* b_min_x (sin rot)) (* b_min_y (cos rot)))))
    (setq g_y2 (+ (cadr ins) (+ (* b_max_x (sin rot)) (* b_min_y (cos rot)))))
    (setq g_y3 (+ (cadr ins) (+ (* b_min_x (sin rot)) (* b_max_y (cos rot)))))
    (setq g_y4 (+ (cadr ins) (+ (* b_max_x (sin rot)) (* b_max_y (cos rot)))))
    (setq g_max_y (max g_y1 g_y2 g_y3 g_y4))

    (setq max_x -1e99)
    (foreach pt c_list
      (if (> (car pt) max_x) (setq max_x (car pt))))
          
    ;; For each local pile
    (foreach c_pt c_list
      (setq cx (car c_pt) cy (cadr c_pt))
      (setq is_last (if (< (abs (- cx max_x)) 0.001) T nil))
      ;; Apply rotation matrix
      (setq gx (+ (car ins) (- (* cx (cos rot)) (* cy (sin rot)))))
      (setq gy (+ (cadr ins) (+ (* cx (sin rot)) (* cy (cos rot)))))
      (setq clearance_y (- g_max_y gy))
      (pile-draw-label (list gx gy 0.0) gx gy is_last clearance_y)
      
      (if f
        (write-line (strcat "P-" (itoa pile_count) "," bname "," (rtos gx 2 3) "," (rtos gy 2 3)) f))
      (setq pile_count (1+ pile_count))
    )
    (setq i (1+ i)))
    
  (if f (close f))
  (setq total_labeled (1- pile_count))
  (princ (strcat "\nSuccessfully extracted and labeled " (itoa total_labeled) " piles."))
  ;; Print pile summary breakdown by table type
  (princ "\n----- Pile Summary -----")
  (foreach row (spd-piling-summary)
    (princ (strcat "\n  " (car row) " : " (cadr row))))
  (if (= (length (spd-piling-summary)) 0)
    (princ "\n  (No piling data found in block definitions)"))
  (princ "\n------------------------")
  (princ)
)

(defun pile-draw-label (pt e n is_last clearance_y / l_x l_y pt2 pt3 e_str n_str lbl_str txt_ins ang p1 p2 base_y max_chars landing)
  ;; Calculate vertical offset to clear the top of the module + a 2.5 unit stretch
  (setq l_y (+ clearance_y (if is_last 3.5 2.8)))
  (setq l_x (/ l_y 6.0))
  
  (setq e_str (rtos (abs e) 2 3)
        n_str (rtos (abs n) 2 3)
        lbl_str (strcat "E:" e_str "\\PN:" n_str))

  ;; Dynamic landing width: Scales perfectly depending on character count to eliminate text overhangs
  (setq max_chars (max (strlen e_str) (strlen n_str)))
  (setq landing (+ (* max_chars 0.11) 0.35))
  
  (setq pt2 (list (+ (car pt) l_x) (+ (cadr pt) l_y) 0.0)
        pt3 (list (+ (car pt2) landing) (cadr pt2) 0.0) ; Dynamically sized landing line
        txt_ins (list (+ (car pt2) 0.05) (+ (cadr pt2) 0.08) 0.0))

  ;; P-Type Reference Point at Pile Center
  (entmake (list '(0 . "POINT") '(100 . "AcDbEntity") '(8 . "PILING_LABELS") '(62 . 7) '(100 . "AcDbPoint")
                 (cons 10 pt)))

  ;; Leader Line (Straight Diagonal)
  (entmake (list '(0 . "LINE") '(100 . "AcDbEntity") '(8 . "PILING_LABELS") '(62 . 7) '(100 . "AcDbLine")
                 (cons 10 pt) (cons 11 pt2)))

  ;; Arrowhead using SOLID (Points TO the pile center pt)
  (setq ang (angle pt pt2))
  (setq p1 (polar pt (+ ang 0.20) 0.25)
        p2 (polar pt (- ang 0.20) 0.25))
  (entmake (list '(0 . "SOLID") '(100 . "AcDbEntity") '(8 . "PILING_LABELS") '(62 . 7) '(100 . "AcDbTrace")
                 (cons 10 pt) (cons 11 p1) (cons 12 p2) (cons 13 p2)))

  ;; Custom Landing Line (Horizontal)
  (entmake (list '(0 . "LINE") '(100 . "AcDbEntity") '(8 . "PILING_LABELS") '(62 . 7) '(100 . "AcDbLine")
                 (cons 10 pt2) (cons 11 pt3)))

  ;; 3-Decimal Coords Block
  (entmake (list '(0 . "MTEXT") '(100 . "AcDbEntity") '(8 . "PILING_LABELS") '(420 . 15886114)
                 '(100 . "AcDbMText") (cons 10 txt_ins) '(40 . 0.16) '(71 . 7)
                 '(90 . 3) '(45 . 1.2) '(63 . 256) '(44 . 1.0)
                 (cons 1 lbl_str)))
)



;;;============================================================
;;; Shadow Analysis  merged from SunShadow.lsp
;;; Commands: SHADOW (pole/LA), BSHADOW (building/structure)
;;;============================================================

;;; ---- Math Utilities ----
(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))
(defun tan-fn (a) (/ (sin a) (cos a)))

(defun asin-fn (x)
  (if (>= (abs x) 1.0)
    (if (> x 0) (/ pi 2.0) (/ pi -2.0))
    (atan x (sqrt (- 1.0 (* x x))))))

(defun acos-fn (x)
  (if (>= x 1.0) 0.0
    (if (<= x -1.0) pi
      (atan (sqrt (- 1.0 (* x x))) x))))

;;;------------------------------------------------------------
;;; Solar position calculator
;;; Returns (altitude . azimuth) in degrees
;;; lat=site latitude, hour=solar decimal time, dec=declination
;;;------------------------------------------------------------
(defun solar-position (lat hour dec / lat-r dec-r ha-r alt-r az-num az-den az-r alt-d az-d)
  (setq lat-r (dtr lat)
        dec-r (dtr dec)
        ha-r  (dtr (* (- hour 12.0) 15.0)))
  (setq alt-r (asin-fn (+ (* (sin lat-r) (sin dec-r))
                           (* (cos lat-r) (cos dec-r) (cos ha-r)))))
  (setq alt-d (rtd alt-r))
  (setq az-num (- (sin dec-r) (* (sin alt-r) (sin lat-r)))
        az-den (* (cos alt-r) (cos lat-r)))
  (if (> (abs az-den) 1e-10)
    (progn
      (setq az-r (acos-fn (/ az-num az-den))
            az-d (rtd az-r))
      (if (> hour 12.0) (setq az-d (- 360.0 az-d))))
    (setq az-d 180.0))
  (cons alt-d az-d))

;;;------------------------------------------------------------
;;; Shadow tip from a base point
;;;------------------------------------------------------------
(defun calc-shadow-tip (base pole-h alt-d az-d / shad-len shad-az dx dy tip)
  (setq shad-len (/ pole-h (tan-fn (dtr alt-d)))
        shad-az  (dtr (+ (- 90.0 az-d) 180.0))
        dx       (* shad-len (cos shad-az))
        dy       (* shad-len (sin shad-az))
        tip      (list (+ (car base) dx) (+ (cadr base) dy)))
  (list tip shad-len))

;;;------------------------------------------------------------
;;; Collect shadow tips for one solstice
;;;------------------------------------------------------------
(defun collect-tips (base pole-h lat dec time-start time-end time-step
                     / tips t-now sun-pos alt-d az-d result)
  (setq tips '()  t-now time-start)
  (while (<= t-now time-end)
    (setq sun-pos (solar-position lat t-now dec)
          alt-d   (car sun-pos)
          az-d    (cdr sun-pos))
    (if (> alt-d 0.5)
      (progn
        (setq result (calc-shadow-tip base pole-h alt-d az-d))
        (setq tips (append tips (list (cons (car result) (cadr result)))))))
    (setq t-now (+ t-now time-step)))
  tips)

;;;------------------------------------------------------------
;;; Layer helpers
;;;------------------------------------------------------------
(defun setup-layer-rgb (lname rgb-str / )
  (setvar "CMDECHO" 0)
  (if (not (tblsearch "LAYER" lname))
    (command "_.-LAYER" "_Make" lname "_Color" "T" rgb-str lname "")
    (command "_.-LAYER" "_Thaw" lname "_On" lname "_Unlock" lname "_Set" lname ""))
  (setvar "CLAYER" lname))

(defun set-transparency (ent pct / edata val)
  (setq edata (entget ent)
        val   (fix (* (/ (float pct) 100.0) 33554432)))
  (if (assoc 440 edata)
    (setq edata (subst (cons 440 val) (assoc 440 edata) edata))
    (setq edata (append edata (list (cons 440 val)))))
  (entmod edata)
  (entupd ent))

;;;------------------------------------------------------------
;;; Convex Hull helpers
;;;------------------------------------------------------------
(defun sh-last (lst) (car (reverse lst)))

(defun cross-product (o a b)
  (- (* (- (car a) (car o)) (- (cadr b) (cadr o)))
     (* (- (cadr a) (cadr o)) (- (car b) (car o)))))

(defun sort-pts (pts)
  (vl-sort pts
    (function (lambda (a b)
      (if (= (car a) (car b))
        (< (cadr a) (cadr b))
        (< (car a) (car b)))))))

(defun remove-dups (pts / result p found)
  (setq result '())
  (foreach p pts
    (setq found nil)
    (foreach r result
      (if (and (< (abs (- (car p) (car r))) 0.001)
               (< (abs (- (cadr p) (cadr r))) 0.001))
        (setq found T)))
    (if (not found) (setq result (append result (list p)))))
  result)

(defun convex-hull (pts / sorted n lower upper i p)
  (setq pts (remove-dups pts))
  (if (<= (length pts) 2)
    pts
    (progn
      (setq sorted (sort-pts pts)
            n      (length sorted)
            lower  '()
            i      0)
      (while (< i n)
        (setq p (nth i sorted))
        (while (and (>= (length lower) 2)
                    (<= (cross-product (nth (- (length lower) 2) lower)
                                       (nth (- (length lower) 1) lower) p) 0))
          (setq lower (reverse (cdr (reverse lower)))))
        (setq lower (append lower (list p))
              i     (1+ i)))
      (setq upper '()
            i     (1- n))
      (while (>= i 0)
        (setq p (nth i sorted))
        (while (and (>= (length upper) 2)
                    (<= (cross-product (nth (- (length upper) 2) upper)
                                       (nth (- (length upper) 1) upper) p) 0))
          (setq upper (reverse (cdr (reverse upper)))))
        (setq upper (append upper (list p))
              i     (1- i)))
      (setq lower (reverse (cdr (reverse lower)))
            upper (reverse (cdr (reverse upper))))
      (append lower upper))))

;;;============================================================
;;; Helper: Extract latitude from boundary XDATA
;;;============================================================
(defun spd-get-lat-from-xd (/ ss ent xdata xd)
  (if (and (boundp '*spd-lat-cache*) *spd-lat-cache*)
      *spd-lat-cache*
      (progn
        (setq ss (ssget "_X" '((-3 ("FS_SOLAR_DATA")))))
        (if ss
          (progn
            (setq ent   (ssname ss 0)
                  xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_DATA"))))
                  xd    (cdar xdata))
            (if (and xd (>= (length xd) 5))
                (setq *spd-lat-cache* (cdr (nth 4 xd)))
                nil))
          nil))))

;;;============================================================
;;; Helper: Centralized shadow drafting logic
;;;============================================================
(defun spd-draw-single-shadow (base-pt pole-h lat shadow-color type-choice la-rad / 
                                w-tips noon-res noon-calc noon-tip noon-len b-ent lbl-pt l-str
                                pts_list vertex_list)
  (vl-load-com)
  (if (not (numberp pole-h)) (setq pole-h 7.0))
  (if (not (numberp lat)) (setq lat 23.53))
  
  (setq w-tips (collect-tips base-pt pole-h lat -23.45 9.0 15.5 0.0833))
  
  (if (and base-pt (listp base-pt) (>= (length w-tips) 2))
    (progn 
      (cond
        ((= type-choice "LA") (setup-layer "SHADOW-LA" "30"))
        ((= type-choice "StreetLight") (setup-layer "STREET_LIGHTING" "74"))
        (t (setup-layer "SHADOW-POLE" "3")))
      
      ;; 1. Build vertex list for entmake LWPOLYLINE
      (setq vertex_list (list (list 10 (car base-pt) (cadr base-pt))))
      (foreach pr w-tips
        (setq vertex_list (cons (list 10 (caar pr) (cadar pr)) vertex_list)))
      (setq vertex_list (reverse vertex_list))
      
       ;; 2. entmake LWPOLYLINE
       (setq b-ent (entmakex (append (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") 
                                          '(8 . "0") '(62 . 256) ; Bylayer
                                          '(100 . "AcDbPolyline")
                                          (cons 90 (length vertex_list)) '(70 . 1))
                                    vertex_list)))
       
       (if b-ent 
         (progn
           (princ (strcat "\nGenerating " type-choice " shadow..."))
           ;; 3. Hatch via Command (Solid hatch is fast)
           (setvar "CMDECHO" 0)
            (command "_.-HATCH" "_P" "SOLID" "_S" b-ent "" "")
           
           ;; 4. Add XData for LA type to track LA locations
           (if (= type-choice "LA")
             (progn
               (if (not (tblsearch "APPID" "FS_SOLAR_DATA")) (regapp "FS_SOLAR_DATA"))
               (entmod (append (entget b-ent) 
                 (list (list -3 
                   (list "FS_SOLAR_DATA"
                     (cons 1000 "LA_SHADOW")       ; Type identifier
                     (cons 1010 base-pt)           ; LA base point (3D point)
                     (cons 1040 la-rad)            ; Protection radius
                     (cons 1040 pole-h)            ; Pole height
                     (cons 1040 lat)               ; Site latitude
                   )
                 ))
               ))
             )
           )
         )
       )
      
      ;; 4. Noon Line calculation
      (setq noon-res (solar-position lat 12.0 -23.45))
      (setq noon-calc (calc-shadow-tip base-pt pole-h (car noon-res) (cdr noon-res))) 
      (setq noon-tip  (if (car noon-calc) (car noon-calc) base-pt))
      
      (if (not (equal noon-tip base-pt))
        (entmake (list '(0 . "LINE") '(8 . "0") '(62 . 256) (cons 10 base-pt) (cons 11 noon-tip))))
           
      ;; 5. Labels
      (setq lbl-pt (list (+ (car base-pt) 1.0) (- (cadr base-pt) 1.0) 0.0))
      (if (= type-choice "LA") 
        (setq l-str (strcat "LA-" (itoa (if *solarpro-la-index* *solarpro-la-index* 1)) " (" (rtos pole-h 2 1) "m)"))
        (setq l-str (strcat type-choice " " (rtos pole-h 2 1) "m")))
      (spd-draw-text lbl-pt l-str 0.5 0 (getvar "CLAYER") 256)

       ;; Draw LA coverage circle if LA type and radius provided
       (if (and (= type-choice "LA") la-rad (numberp la-rad) (> la-rad 0))
         (progn
           (setup-layer "SHADOW-LA" "30")
           (setq circle-ent (entmakex (list '(0 . "CIRCLE") 
                                             '(8 . "SHADOW-LA") 
                                             '(62 . 256) 
                                             (cons 10 base-pt) 
                                             (cons 40 la-rad)
                                             '(70 . 0))))
           ;; Add XData to circle as well
           (if circle-ent
             (progn
               (if (not (tblsearch "APPID" "FS_SOLAR_DATA")) (regapp "FS_SOLAR_DATA"))
               (entmod (append (entget circle-ent) 
                 (list (list -3 
                   (list "FS_SOLAR_DATA"
                     (cons 1000 "LA_PROTECTION")     ; Type identifier
                     (cons 1010 base-pt)             ; LA base point (3D point)
                     (cons 1040 la-rad)              ; Protection radius
                     (cons 1040 pole-h)              ; Pole height
                     (cons 1040 lat)                 ; Site latitude
                   )
                 ))
               ))
             )
           )
         )
       )

      (if (= type-choice "LA") (setq *solarpro-la-index* (1+ (if *solarpro-la-index* *solarpro-la-index* 1))))
    )))
;;;============================================================
;;; Auto-place LA within a boundary (SHADOW command)
;;; Uses hexagonal grid packing for optimal coverage
;;; Draws ONLY shadow polygon (no circles) - circles drawn later via LAProtection
;;;============================================================
(defun spd-auto-place-la (la-rad pole-h lat / bnd-ent bnd-obj minpt maxpt minx maxx miny maxy
                            spacing row-spacing cols rows x y pt count i j)
  (vl-load-com)
  (princ "\nSelect closed boundary polyline for LA placement: ")
  (setq bnd-ent (car (entsel)))
  (if (null bnd-ent)
    (progn (princ "\nNo boundary selected.") (exit)))
  
  (setq bnd-obj (vlax-ename->vla-object bnd-ent))
  (if (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-get-area (list bnd-obj))))
    (progn
      (vla-getboundingbox bnd-obj 'minpt 'maxpt)
      (setq minpt (vlax-safearray->list minpt)
            maxpt (vlax-safearray->list maxpt)
            minx (car minpt) maxx (car maxpt)
            miny (cadr minpt) maxy (cadr maxpt))
      
      ;; Hexagonal grid spacing = radius * sqrt(3) for optimal coverage
      (setq spacing (* la-rad (sqrt 3))
            row-spacing (* la-rad 1.5)
            cols (fix (/ (- maxx minx) spacing))
            rows (fix (/ (- maxy miny) row-spacing)))
      
      (princ (strcat "\nGrid: " (itoa cols) " x " (itoa rows) " = " (itoa (* cols rows)) " potential positions"))
      
      (setq count 0)
      (setq i 0)
      (while (< i cols)
        (setq x (+ minx (* i spacing) (/ spacing 2.0)))
        (setq j 0)
        (while (< j rows)
          (setq y (+ miny (* j row-spacing)))
          ;; Offset every other column for hexagonal packing
          (if (= (rem i 2) 1)
            (setq y (+ y (/ row-spacing 2.0))))
          
          (setq pt (list x y 0.0))
          
          ;; Check if point is inside boundary
          (if (spd-point-in-polygon pt bnd-obj)
            (progn
              (spd-draw-la-shadow-only pt pole-h lat la-rad)
              (setq count (1+ count))
            )
          )
          (setq j (1+ j))
        )
        (setq i (1+ i))
      )
      (princ (strcat "\nPlaced " (itoa count) " LA shadow zones."))
    )
    (princ "\nSelected object is not a valid closed boundary.")
  )
  (princ)
)

;;; Draw LA shadow only (no protection circle) - for SHADOW command auto-placement
(defun spd-draw-la-shadow-only (base-pt pole-h lat la-rad / w-tips vertex_list b-ent)
  (vl-load-com)
  (if (not (numberp pole-h)) (setq pole-h 7.0))
  (if (not (numberp lat)) (setq lat 23.53))
  
  (setq w-tips (collect-tips base-pt pole-h lat -23.45 9.0 15.5 0.0833))
  
  (if (and base-pt (listp base-pt) (>= (length w-tips) 2))
    (progn
      (setup-layer "SHADOW-LA" "30")
      
      ;; Build vertex list for entmake LWPOLYLINE
      (setq vertex_list (list (list 10 (car base-pt) (cadr base-pt))))
      (foreach pr w-tips
        (setq vertex_list (cons (list 10 (caar pr) (cadar pr)) vertex_list)))
      (setq vertex_list (reverse vertex_list))
      
      ;; entmake LWPOLYLINE
      (setq b-ent (entmakex (append (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") 
                                         '(8 . "SHADOW-LA") '(62 . 256) ; Bylayer
                                         '(100 . "AcDbPolyline")
                                         (cons 90 (length vertex_list)) '(70 . 1))
                                   vertex_list)))
      
      (if b-ent 
        (progn
          (princ (strcat "\nGenerating LA shadow..."))
          ;; Hatch via Command (Solid hatch is fast)
          (setvar "CMDECHO" 0)
          (command "_.-HATCH" "_P" "SOLID" "_S" b-ent "" "")
          
          ;; Add XData for LA type to track LA locations
          (if (not (tblsearch "APPID" "FS_SOLAR_DATA")) (regapp "FS_SOLAR_DATA"))
          (entmod (append (entget b-ent) 
            (list (list -3 
              (list "FS_SOLAR_DATA"
                (cons 1000 "LA_SHADOW")       ; Type identifier
                (cons 1010 base-pt)           ; LA base point (3D point)
                (cons 1040 la-rad)            ; Protection radius
                (cons 1040 pole-h)            ; Pole height
                (cons 1040 lat)               ; Site latitude
              )
            ))
          ))
        )
      )
      
      ;; Noon Line calculation
      (setq noon-res (solar-position lat 12.0 -23.45))
      (setq noon-calc (calc-shadow-tip base-pt pole-h (car noon-res) (cdr noon-res))) 
      (setq noon-tip  (if (car noon-calc) (car noon-calc) base-pt))
      
      (if (not (equal noon-tip base-pt))
        (entmake (list '(0 . "LINE") '(8 . "SHADOW-LA") '(62 . 256) (cons 10 base-pt) (cons 11 noon-tip))))
      
      ;; Label
      (setq lbl-pt (list (+ (car base-pt) 1.0) (- (cadr base-pt) 1.0) 0.0))
      (setq l-str (strcat "LA-" (itoa *solarpro-la-index*) " (" (rtos pole-h 2 1) "m)"))
      (spd-draw-text lbl-pt l-str 0.5 0 "SHADOW-LA" 256)
      (setq *solarpro-la-index* (1+ *solarpro-la-index*))
    )
  )
)

;;; Helper: Point in polygon test using ray casting (WCS)
(defun spd-point-in-polygon (pt poly-obj / verts n i j x y inside next-pt)
  (vl-load-com)
  (setq verts (vlax-safearray->list (vlax-variant-value (vla-get-coordinates poly-obj))))
  (setq n (/ (length verts) 2))
  (setq x (car pt) y (cadr pt) inside nil i 0 j (1- n))
  (while (< i n)
    (setq xi (nth (* i 2) verts) yi (nth (1+ (* i 2)) verts)
          xj (nth (* j 2) verts) yj (nth (1+ (* j 2)) verts))
    (if (and (or (> yi y) (> yj y)) (<= (min yi yj) y)
             (< x (+ xj (* (- xi xj) (/ (- y yj) (- yi yj))))))
      (setq inside (not inside)))
    (setq j i i (1+ i)))
  inside
)









;;;============================================================
;;; Command: SHADOW  Pole / LA Shadow
;;;============================================================
(defun c:SHADOW (/ type-choice dcl-id result base-pt pole-h lat la-rad shadow-color 
                    sl-mode sl-height sl-dist-idx sl-side bname spacing curve_ent 
                    obj pick-p1 pick-p2 d1 d2 total-dist dir travelled d_cur pt 
                    param deriv ang rot noon-res noon-alt noon-az noon-calc 
                    noon-tip noon-len old-layer old-osmode old-cmdecho shadow-aci dcl-path
                    la-mode)

  (if (not *solarpro-la-index*) (setq *solarpro-la-index* 1))

  (setq lat (spd-get-lat-from-xd))
  (if (not lat) 
    (progn (setq lat (getreal (strcat "\nEnter site latitude (deg) <23.53>: ")))
           (if (null lat) (setq lat 23.53))
           (setq *spd-lat-cache* lat)))

  (setq old-layer   (getvar "CLAYER")
        old-osmode  (getvar "OSMODE")
        old-cmdecho (getvar "CMDECHO")
        pole-h      7.0)
        
  (defun *error* (msg)
    (if (numberp old-osmode)  (setvar "OSMODE"   old-osmode))
    (if old-layer             (setvar "CLAYER"   old-layer))
    (if (numberp old-cmdecho) (setvar "CMDECHO"  old-cmdecho))
    (if (and msg (/= msg "Function cancelled")) (princ (strcat "\nError: " msg)))
    (princ))

  (setvar "CMDECHO" 0)
  (setvar "OSMODE"  0)

  (initget "Pole LA StreetLight")
  (setq type-choice (getkword "\nPoint type [Pole/LA/StreetLight] <Pole>: "))
  (if (null type-choice) (setq type-choice "Pole"))

  (if (/= type-choice "StreetLight")
    (progn
      (setq base-pt (getpoint (strcat "\nPick " type-choice " base point: ")))
      (if (not base-pt) (setq base-pt nil) (setq base-pt (list (car base-pt) (cadr base-pt))))))

  (if (or (= type-choice "StreetLight") base-pt)
    (cond
       ((= type-choice "LA")
        (progn
          (setq dcl-path (cond ((spd-get-dcl "SolarPro - LA Dialog - Shadow.dcl")) 
                               ((spd-get-dcl "SolarPro - LA Dialog - Shadow.dcl"))))
          (if dcl-path
            (progn
    (setq dcl-id (load_dialog dcl-path))
              (if (new_dialog "la_dialog_shadow" dcl-id)
                (progn
                  (set_tile "la_rad" "90.0") (set_tile "la_height" "7.0") (set_tile "la_lat" (rtos lat 2 2))
                  (set_tile "la_mode_manual" "1")
                  (action_tile "accept" "(setq la-rad (atof (get_tile \"la_rad\")) pole-h (atof (get_tile \"la_height\")) lat (atof (get_tile \"la_lat\")) la-mode (if (= (get_tile \"la_mode_manual\") \"1\") \"manual\" \"auto\")) (done_dialog 1)")
                  (action_tile "cancel" "(done_dialog 0)")
                  (setq result (start_dialog)) (unload_dialog dcl-id)
                  (if (= result 1)
                    (if (= la-mode "auto")
                      (spd-auto-place-la la-rad pole-h lat)
                      (progn
                        (setq base-pt (getpoint "\nPick LA base point: "))
                        (if base-pt (spd-draw-single-shadow base-pt pole-h lat "30" "LA" la-rad))
                      )
                    )
                  )
                )
                (unload_dialog dcl-id)
              )
            )
          )
        )
      )

      ((= type-choice "StreetLight")
        (progn
          (setup-layer "STREET_LIGHTING" "74")
          (setq dcl-path (cond ((spd-get-dcl "SolarPro - Streetlight.dcl")) 
                               ((spd-get-dcl "SolarPro - Streetlight.dcl"))))
          (if dcl-path
            (progn
  (setq dcl-id (load_dialog dcl-path))
              (if (new_dialog "streetlight_dialog" dcl-id)
                (progn
                  (set_tile "sl_height" "7.0") (set_tile "sl_dist" "1")
                  (action_tile "accept" "(setq sl-mode (get_tile \"sl_mode\") sl-height (atof (get_tile \"sl_height\")) sl-dist-idx (get_tile \"sl_dist\") sl-side (get_tile \"sl_side\")) (done_dialog 1)")
                  (action_tile "cancel" "(done_dialog 0)")
                  (setq result (start_dialog)) (unload_dialog dcl-id)
                  (if (= result 1)
                    (progn
                      (setq pole-h sl-height)
                      (setq spacing (atof (nth (atoi sl-dist-idx) '("20" "30" "40" "50" "60"))))
                      (if (= sl-mode "single")
                        (progn (setq base-pt (getpoint "\nPick Streetlight base point: "))
                               (if base-pt (spd-draw-single-shadow base-pt pole-h lat "74" "StreetLight" nil)))
                        (progn (princ "\nSelect boundary for streetlights: ")
                               (setq curve_ent (car (entsel)))
                               (if curve_ent (distribute-streetlights curve_ent pole-h lat spacing sl-side)))))
                  )
                )
                (unload_dialog dcl-id)
              )
            )
          )
        )
      )

      (t 
        (setq pole-h (getreal "\nEnter pole height (m) <7.0>: "))
        (if (null pole-h) (setq pole-h 7.0))
        (spd-draw-single-shadow base-pt pole-h lat "3" "Pole" nil)
      )
    )
  )
  (if old-layer (setvar "CLAYER" old-layer))
  (if (numberp old-osmode)  (setvar "OSMODE"  old-osmode))
  (if (numberp old-cmdecho) (setvar "CMDECHO" old-cmdecho))
  (princ "\nShadow generation complete.")
  (princ))

(defun distribute-streetlights (curve_ent pole-h lat spacing side / len dist pt obj param deriv ang rot shadow-pt)
  (vl-load-com)
  (setq obj (vlax-ename->vla-object curve_ent)
        len (vlax-curve-getDistAtEnd obj)
        dist 0.0)
  (if (or (not spacing) (<= spacing 0.1)) (setq spacing 30.0))
  (while (<= dist len)
    (setq pt (vlax-curve-getPointAtDist obj dist)
          param (vlax-curve-getParamAtDist obj dist)
          deriv (vlax-curve-getFirstDeriv obj param)
          ang (atan (cadr deriv) (car deriv))
          rot (if (= side "left") (+ ang (/ pi 2.0)) (- ang (/ pi 2.0))))
    ;; Place the pole marker (small circle)
    (setup-layer "STREET_LIGHTING" "74")
    (entmake (list '(0 . "CIRCLE") '(8 . "STREET_LIGHTING") '(62 . 256) (cons 10 pt) (cons 40 0.15)))
    ;; Draw the shadow
    (spd-draw-single-shadow pt pole-h lat "74" "StreetLight" nil)
    (setq dist (+ dist spacing))
    (princ (strcat "\rPlaced streetlight at " (rtos dist 2 1) "m / " (rtos len 2 1) "m")))
  (princ (strcat "\nSuccessfully distributed streetlights along curve (Total: " (itoa (fix (/ len spacing))) ")")))




;;;============================================================
;;; Command: BSHADOW  Building / Structure Shadow
;;; Height > 3m : SHADOW-BLDG, Orange, scale 8, 50% transparent
;;; Height <=3m : SHADOW-SMALL, Blue,   scale 0.9, 50% transparent
;;;============================================================
(defun c:BSHADOW (/ ent edata etype bldg-corners bldg-h lat
                    all-pts hull-pts boundary-ent hatch-ent
                    max-len shadow-len dx dy shad-az
                    t-now sun-pos alt-d az-d
                    layer-name hatch-scale am-max pm-max
                    old-layer old-osmode old-cmdecho)

  (defun *error* (msg)
    (if (numberp old-osmode)  (setvar "OSMODE"   old-osmode))
    (if old-layer             (setvar "CLAYER"   old-layer))
    (if (numberp old-cmdecho) (setvar "CMDECHO"  old-cmdecho))
    (if (and msg (/= msg "Function cancelled")) (princ (strcat "\nError: " msg)))
    (princ))

  (setq old-layer   (getvar "CLAYER")
        old-osmode  (getvar "OSMODE")
        old-cmdecho (getvar "CMDECHO")
        pole-h      7.0)
  (setvar "CMDECHO" 0)
  (setvar "OSMODE"  0)

  (princ "\nSelect building rectangle/polyline: ")
  (setq ent (car (entsel)))
  (if (null ent) (progn (princ "\nNo object selected.") (exit)))

  (setq edata (entget ent)
        etype (cdr (assoc 0 edata)))
  (if (/= etype "LWPOLYLINE")
    (progn (princ "\nPlease select a polyline/rectangle.") (exit)))

  (setq bldg-corners '())
  (foreach item edata
    (if (= (car item) 10)
      (setq bldg-corners (append bldg-corners
              (list (list (cadr item) (caddr item)))))))

  (if (< (length bldg-corners) 3)
    (progn (princ "\nNeed at least 3 corners.") (exit)))

  (princ (strcat "\n" (itoa (length bldg-corners)) " corners detected."))

  (initget 7)
  (setq bldg-h (getreal "\nEnter height in meters: "))
  (if (null bldg-h) (exit))

  (setq lat (spd-get-lat-from-xd))
  (if (not lat)
    (progn (initget 7) (setq lat (getreal "\nEnter site latitude (deg) <23.53>: "))))
  (if (null lat) (setq lat 23.53))
  (setq *spd-lat-cache* lat)

  (setq all-pts '()  max-len 0.0  am-max 0.0  pm-max 0.0)
  (foreach c bldg-corners
    (setq all-pts (append all-pts (list c))))

  (foreach dec-val (list -23.45)
    (setq t-now 9.0)
    (while (<= t-now 15.5)
      (setq sun-pos (solar-position lat t-now dec-val)
            alt-d   (car sun-pos)
            az-d    (cdr sun-pos))
      (if (> alt-d 0.5)
        (progn
          (setq shadow-len (/ bldg-h (tan-fn (dtr alt-d)))
                shad-az    (dtr (+ (- 90.0 az-d) 180.0))
                dx         (* shadow-len (cos shad-az))
                dy         (* shadow-len (sin shad-az)))
          (if (> shadow-len max-len) (setq max-len shadow-len))
          (if (< (abs (- t-now 9.0))  0.01) (setq am-max shadow-len))
          (if (< (abs (- t-now 15.5)) 0.01) (setq pm-max shadow-len))
          (foreach c bldg-corners
            (setq all-pts (append all-pts
              (list (list (+ (car c) dx) (+ (cadr c) dy))))))))
      (setq t-now (+ t-now 0.0833))))

  (setq hull-pts (convex-hull all-pts))
  (if (< (length hull-pts) 3)
    (progn (princ "\nCould not compute shadow boundary.") (exit)))

  (setq layer-name "SHADOW-BLDG" hatch-scale 3.0)
  ;; Direct Database Boundary (entmake) - Corrected to Single Call
  (entmake (append
    (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 layer-name) '(62 . 256)
          '(100 . "AcDbPolyline") (cons 90 (length hull-pts)) (cons 70 1))
    (mapcar '(lambda (p) (cons 10 p)) hull-pts)))
  (setq boundary-ent (entlast))

  ;; Robust hatching for building (ANSI31 Scale 3.0)
  (command "_.-HATCH" "_P" "ANSI31" hatch-scale 0 "_S" boundary-ent "" "")
  (setq hatch-ent (entlast))
  (if (and hatch-ent (not (equal hatch-ent boundary-ent)))
    (progn
      (command "_.CHPROP" hatch-ent "" "C" "256" "")
      (set-transparency hatch-ent 50)))

  ;; Add Height Label (e.g. H-5m)
  (setq box (GetPolygonBBox hull-pts))
  (setq mid-pt (list (/ (+ (nth 0 box) (nth 2 box)) 2.0) (/ (+ (nth 1 box) (nth 3 box)) 2.0) 0.0))
  (spd-draw-text mid-pt (strcat "H-" (rtos bldg-h 2 1) "m") (* hatch-scale 0.5) 0 layer-name 256)


  (setvar "CLAYER"  old-layer)
  (setvar "OSMODE"  old-osmode)
  (setvar "CMDECHO" old-cmdecho)

  (princ (strcat
    "\n===== BUILDING SHADOW RESULTS ====="
    "\nHeight       : " (rtos bldg-h 2 2) " m"
    "\nType         : " (if (> bldg-h 3.0) "Building (Red)" "Small Structure (Blue)")
    "\nLatitude     : " (rtos lat 2 2) " deg"
    "\nSolstice     : Winter (Dec 21)"
    "\nTime Range   : 9:00 AM to 3:30 PM"
    "\n9 AM Shadow  : " (rtos am-max 2 2) " m"
    "\n3:30PM Shadow: " (rtos pm-max 2 2) " m"
    "\nMax Shadow   : " (rtos max-len 2 2) " m"
    "\nHatch Scale  : " (rtos hatch-scale 2 1)
    "\nLayer        : " layer-name
    "\n===================================="))
  (princ))

;;;------------------------------------------------------------
;;; Shadow / LA / Pole Coordinate Labeling
;;;------------------------------------------------------------

;;; Draw one coordinate label  same visual style as pile labels
(defun shadow-draw-label (wx wy label_id
                          / pt l_y l_x pt2 pt3 txt_ins
                            e_str n_str lbl_str landing max_chars ang p1 p2)
  (setq l_y     2.5
        l_x     (/ l_y 6.0)
        e_str   (rtos (abs wx) 2 3)
        n_str   (rtos (abs wy) 2 3)
        lbl_str (strcat label_id "\\PE:" e_str "\\PN:" n_str))

  (setq max_chars (max (strlen e_str) (strlen n_str)))
  (setq landing   (+ (* max_chars 0.11) 0.35))

  (setq pt      (list wx wy 0.0)
        pt2     (list (+ wx l_x) (+ wy l_y) 0.0)
        pt3     (list (+ (car pt2) landing) (cadr pt2) 0.0)
        txt_ins (list (+ (car pt2) 0.05) (+ (cadr pt2) 0.08) 0.0))

  ;; Reference point at base
  (entmake (list '(0 . "POINT") '(100 . "AcDbEntity") '(8 . "SHADOW-LABELS") '(62 . 7)
                 '(100 . "AcDbPoint") (cons 10 pt)))

  ;; Leader diagonal line
  (entmake (list '(0 . "LINE") '(100 . "AcDbEntity") '(8 . "SHADOW-LABELS") '(62 . 7)
                 '(100 . "AcDbLine") (cons 10 pt) (cons 11 pt2)))

  ;; Arrowhead SOLID pointing TO base
  (setq ang (angle pt pt2)
        p1  (polar pt (+ ang 0.20) 0.25)
        p2  (polar pt (- ang 0.20) 0.25))
  (entmake (list '(0 . "SOLID") '(100 . "AcDbEntity") '(8 . "SHADOW-LABELS") '(62 . 7)
                 '(100 . "AcDbTrace") (cons 10 pt) (cons 11 p1) (cons 12 p2) (cons 13 p2)))

  ;; Horizontal landing line
  (entmake (list '(0 . "LINE") '(100 . "AcDbEntity") '(8 . "SHADOW-LABELS") '(62 . 7)
                 '(100 . "AcDbLine") (cons 10 pt2) (cons 11 pt3)))

  ;; MTEXT  orange colour, 3 decimal places, same style as pile labels
  (entmake (list '(0 . "MTEXT") '(100 . "AcDbEntity") '(8 . "SHADOW-LABELS") '(420 . 15886114)
                 '(100 . "AcDbMText") (cons 10 txt_ins) '(40 . 0.16) '(71 . 7)
                 '(90 . 3) '(45 . 1.2) '(63 . 256) '(44 . 1.0)
                 (cons 1 lbl_str)))
)

;;; SHADOWCOORDS  labels E/N of all LA/pole base points stored by SHADOW command
(defun c:ShadowCoords (/ old_lbl j ss i ent edata pt wx wy cnt prefix)
  ;; Create SHADOW-LABELS layer if needed
  (if (not (tblsearch "LAYER" "SHADOW-LABELS"))
    (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord")
                   '(100 . "AcDbLayerTableRecord")
                   '(2 . "SHADOW-LABELS") '(70 . 0) '(62 . 7) '(6 . "Continuous"))))

  ;; Clear any existing labels first
  (setq old_lbl (ssget "X" '((8 . "SHADOW-LABELS"))))
  (if old_lbl
    (progn
      (setq j 0)
      (while (< j (sslength old_lbl))
        (entdel (ssname old_lbl j))
        (setq j (1+ j)))))

  ;; Find all marker points planted by SHADOW command
  (setq ss (ssget "X" '((0 . "POINT") (8 . "SHADOW-MARKERS"))))
  (if (not ss)
    (progn
      (princ "\nNo shadow/LA marker points found.")
      (princ "\nRun the SHADOW command first  it will mark each pole/LA base automatically.")
      (exit)))

  ;; Ask label prefix
  (initget "LA POLE SCADA CAMERA")
  (setq prefix (getkword "\nLabel prefix [LA/POLE/SCADA/CAMERA] <LA>: "))
  (if (not prefix) (setq prefix "LA"))

  (setq i 0  cnt 1)
  (while (< i (sslength ss))
    (setq ent   (ssname ss i)
          edata (entget ent)
          pt    (cdr (assoc 10 edata))
          wx    (car pt)
          wy    (cadr pt))
    (shadow-draw-label wx wy (strcat prefix "-" (itoa cnt) "\\P"))
    (setq cnt (1+ cnt)  i (1+ i)))

  (princ (strcat "\n" (itoa (1- cnt)) " " prefix " coordinate(s) labeled on SHADOW-LABELS layer."))
  (princ)
)

;;; CLEARSHADOWCOORDS  removes all labels from SHADOW-LABELS layer
(defun c:ClearShadowCoords (/ old_lbl j)
  (setq old_lbl (ssget "X" '((8 . "SHADOW-LABELS"))))
  (if old_lbl
    (progn
      (setq j 0)
      (while (< j (sslength old_lbl))
        (entdel (ssname old_lbl j))
        (setq j (1+ j)))
      (princ (strcat "\n" (itoa (sslength old_lbl)) " shadow label(s) deleted.")))
    (princ "\nNo shadow coordinate labels found to delete."))
  (princ)
)









;;;------------------------------------------------------------
;;; DEBUGSTRINGS  Diagnostic: prints entity types, layers and
;;; text content so you can verify what the drawing contains.
;;; Run this if DCCABLING says "No strings found".
;;;------------------------------------------------------------
(defun c:DEBUGSTRINGS (/ ss n ename edata lyr typ txt)
  (vl-load-com)
  (princ "\n=== Scanning entire drawing for text entities ===")
  (setq ss (ssget "_X" '((0 . "MTEXT"))))
  (if (null ss) (progn (princ "\nNo MTEXT found at all.") (exit)))
  (setq n 0)
  (while (< n (min 40 (sslength ss)))
    (setq ename (ssname ss n)
          edata (entget ename)
          lyr (cdr (assoc 8 edata))
          txt (cdr (assoc 1 edata)))
    (princ (strcat "\nLAYER:[" (if lyr lyr "?") "] TXT:[" (if txt (substr txt 1 40) "?") "]"))
    (setq n (1+ n)))
  (princ (strcat "\n=== Total MTEXT found: " (itoa (sslength ss)) " ==="))
  (princ)
)

;;;============================================================
;;; Automated DC Cabling  Single Trunk Route per Inverter
;;; Automatically detects all strings belonging to the entered
;;; Inverter ID by searching MTEXT string labels on STRINGING layer.
;;; Routes: each string drops vertically to ONE shared trunk,
;;; trunk runs horizontally to the inverter connection point.
;;;============================================================
(defun c:DCCABLING (/ old_cmdecho inv_id search_key lbl_ss pos_ss all_pos 
                      term_list n idx ename edata raw_txt lbl_pt
                      near_ent near_dist cur_dist pos_x pos_y
                      pt_inv inv_x inv_y trunk_y
                      csize mps neg_o updown total tx ty p1 p2 p3)
  (vl-load-com)
  (setq old_cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)

  (if (not (tblsearch "APPID" "FS_DC_CABLE")) (regapp "FS_DC_CABLE"))
  (if (not (tblsearch "LAYER" "DC_CABLE"))
    (command "_.LAYER" "_New" "DC_CABLE" "_Color" "1" "DC_CABLE" ""))

  ;; Step 1: Get inverter ID and build search string "INV-1-STR-"
  (setq inv_id (getstring "\nEnter Inverter ID (e.g., INV-1): "))
  (if (= inv_id "") (progn (princ "\nCancelled.") (setvar "CMDECHO" old_cmdecho) (exit)))
  (setq search_key (strcat (strcase inv_id) "-STR-"))

  ;; Step 2: Scan ALL text entities in entire drawing (MTEXT and TEXT, any layer)
  ;; This is layer-agnostic so it works regardless of what layer the labels are on.
  (setq term_list nil)
  (setq lbl_ss (ssget "_X" '((0 . "MTEXT"))))
  (setq lbl_ss2 (ssget "_X" '((0 . "TEXT"))))
  (princ (strcat "\nSearching for '" search_key "' in drawing..."))

  ;; Scan MTEXT entities
  (if lbl_ss
    (progn
      (setq idx 0)
      (while (< idx (sslength lbl_ss))
        (setq ename (ssname lbl_ss idx)
              edata (entget ename)
              raw_txt (cdr (assoc 1 edata)))
        (if (and raw_txt (vl-string-search search_key (strcase raw_txt)))
          (progn
            (setq lbl_pt (cdr (assoc 10 edata)))
            (setq term_list (cons (list (car lbl_pt) (cadr lbl_pt) raw_txt) term_list))
            (princ (strcat "\n  Found label: " (substr raw_txt 1 30) " @ layer:" (cdr (assoc 8 edata))))))
        (setq idx (1+ idx)))))

  ;; Scan TEXT entities (regular single-line text)
  (if lbl_ss2
    (progn
      (setq idx 0)
      (while (< idx (sslength lbl_ss2))
        (setq ename (ssname lbl_ss2 idx)
              edata (entget ename)
              raw_txt (cdr (assoc 1 edata)))
        (if (and raw_txt (vl-string-search search_key (strcase raw_txt)))
          (progn
            (setq lbl_pt (cdr (assoc 10 edata)))
            (setq term_list (cons (list (car lbl_pt) (cadr lbl_pt) raw_txt) term_list))
            (princ (strcat "\n  Found TEXT label: " (substr raw_txt 1 30)))))
        (setq idx (1+ idx)))))

  (if (null term_list)
    (progn
      (princ (strcat "\nERROR: No labels found containing '" search_key "'"))
      (princ "\nTip: Run DEBUGSTRINGS to see what text is in your drawing.")
      (setvar "CMDECHO" old_cmdecho) (exit)))

  (princ (strcat "\nFound " (itoa (length term_list)) " string labels for " (strcase inv_id) "."))

  ;; Step 3: Collect ALL + terminal positions from DC_STRINGING (any MTEXT containing "+")
  (setq all_pos nil)
  (setq pos_ss (ssget "_X" '((0 . "MTEXT") (8 . "DC_STRINGING"))))
  (if pos_ss
    (progn
      (setq n 0)
      (while (< n (sslength pos_ss))
        (setq ename (ssname pos_ss n)
              edata (entget ename)
              raw_txt2 (cdr (assoc 1 edata)))
        ;; Accept entity if content has "+" anywhere (handles RTF wrapping)
        (if raw_txt2
          (progn
            (setq pos_x (car  (cdr (assoc 10 edata)))
                  pos_y (cadr (cdr (assoc 10 edata))))
            (setq all_pos (cons (list pos_x pos_y) all_pos))))
        (setq n (1+ n)))))

  (if (null all_pos)
    (progn
      (princ "\nWARNING: No + terminals found on DC_STRINGING. Using label positions as cable origins.")
      ;; Fall back to using the label positions directly
      (setq all_pos (mapcar (function (lambda (x) (list (car x) (cadr x)))) term_list))))

  ;; Step 4: For each matched label, find nearest terminal
  (setq result_list nil)
  (foreach lbl term_list
    (setq lbl_pt (list (car lbl) (cadr lbl)))
    (setq near_ent nil  near_dist 1e38)
    (foreach p all_pos
      (setq cur_dist (distance lbl_pt p))
      (if (< cur_dist near_dist)
        (setq near_dist cur_dist  near_ent p)))
    (if near_ent
      (setq result_list (cons near_ent result_list))
      (setq result_list (cons lbl_pt result_list))))

  (setq term_list result_list)
  (princ (strcat "\nAuto-detected " (itoa (length term_list)) " cable origins for " (strcase inv_id) "."))

  ;; Step 5: User clicks ONE point - the inverter cable entry point
  (setq pt_inv (getpoint "\nClick the Inverter cable entry point: "))
  (if (null pt_inv) (progn (princ "\nCancelled.") (setvar "CMDECHO" old_cmdecho) (exit)))
  (setq inv_x (car pt_inv)  inv_y (cadr pt_inv))

  ;; Step 6: The shared horizontal trunk Y = inverter Y
  ;; (all cables drop vertically to this level, then run horizontally together)
  (setq trunk_y inv_y)

  ;; Step 7: Cable specs  only ask what is not already known from XDATA globals
  ;; mps comes from *asd-mps* set by AUTOSTRINGDIALOG (no need to ask again).
  (setq csize (getreal "\nCable Size (4 or 6 Sq.mm) <4>: "))
  (if (null csize) (setq csize 4.0))

  ;; Modules per string  read from AUTOSTRINGDIALOG global, fall back to 18
  (setq mps (if (and (boundp '*asd-mps*) (> *asd-mps* 0)) *asd-mps* 18))
  (princ (strcat "\n  Modules/string: " (itoa mps) " (from AUTOSTRINGDIALOG)"))

  (setq neg_o (getreal "\n-VE extra length offset (m) <2.5>: "))
  (if (null neg_o) (setq neg_o 2.5))

  (setq updown (getreal "\nUp & Down per leg (m) <5.0>: "))
  (if (null updown) (setq updown 5.0))

  ;; Step 8: Draw each string as: terminal  vertical drop  horizontal trunk  inverter
  ;; Because they all share trunk_y, cables overlap on the horizontal section,
  ;; giving the appearance of ONE cable tray on screen.
  (setq total 0)
  (foreach pt term_list
    (setq tx (car pt)  ty (cadr pt))
    (setq p1 (list tx ty 0.0)          ;; String terminal position
          p2 (list tx trunk_y 0.0)     ;; Drop vertically to trunk level
          p3 (list inv_x trunk_y 0.0)) ;; Run horizontally along trunk to inverter

    (entmakex (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                    '(8 . "DC_CABLE")  '(100 . "AcDbPolyline")
                    '(90 . 3) '(70 . 0)
                    (cons 10 p1) (cons 10 p2) (cons 10 p3)
                    (list -3 (list "FS_DC_CABLE"
                                   (cons 1000 inv_id)
                                   (cons 1000 (itoa mps))
                                   (cons 1000 (rtos csize 2 1))
                                   (cons 1000 (rtos neg_o 2 1))
                                   (cons 1000 (rtos updown 2 1))))))
    (setq total (1+ total)))

  (setvar "CMDECHO" old_cmdecho)
  (princ (strcat "\nDone  " (itoa total) " cables routed to " (strcase inv_id) " via shared trunk."))
  (princ)
)

;;;------------------------------------------------------------
;;; DCCABLINGALL  Batch DC Cabling for ALL Inverters in One Run
;;;
;;; Workflow:
;;;   1. Ask cable specs ONCE (size, mps, neg_o, updown, trunk_offset)
;;;   2. Auto-scan STRINGING layer for all "INV-*" MTEXT labels
;;;      (filters out "STR-" labels so only inverter blocks are found)
;;;   3. For each inverter found:
;;;        a. Build search key "INV-X-STR-"
;;;        b. Find all matching string terminal positions
;;;        c. Route cables: terminal  vertical drop to trunk Y  horizontal to inv X
;;;        d. Embed FS_DC_CABLE XDATA so DCCABLEEXPORT works as normal
;;;   4. Report total cables placed across all inverters
;;;
;;; Result: 20 inverters = 1 command run instead of 20 runs
;;;------------------------------------------------------------
(defun c:DCCABLINGALL (/
    old_cmdecho
    csize mps neg_o updown trunk_offset trunk_mode dccfg
    lbl_ss idx ename edata raw_txt lbl_pt lbl_x lbl_y
    inv_data_list inv_rec inv_id inv_cx inv_cy
    search_key term_list pos_ss all_pos
    n raw_txt2 pos_x pos_y
    lbl_ss2 idx2 ename2 edata2 raw_txt3 lbl_pt2
    result_list near_ent near_dist cur_dist lbl_num
    tx ty trunk_y inv_x p1 p2 p3
    total_cables total_invs skipped_invs
    as-bnds ent xdata verts lbl_ss_raw)

  (vl-load-com)
  (setq old_cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)

  (if (not (tblsearch "APPID" "FS_DC_CABLE")) (regapp "FS_DC_CABLE"))
  (if (not (tblsearch "LAYER" "DC_CABLE"))
    (command "_.LAYER" "_New" "DC_CABLE" "_Color" "1" "DC_CABLE" ""))

  ;; -------------------------------------------------------
  ;; STEP 0: Select boundary
  ;; -------------------------------------------------------
  (setvar "CMDECHO" 1)
  (setq as-bnds (asd-find-boundaries))
  (cond
    ((= (length as-bnds) 1)
     (setq ent (car as-bnds))
     (princ "\nOne SolarPro boundary detected automatically."))
    ((> (length as-bnds) 1)
     (princ (strcat "\n" (itoa (length as-bnds)) " boundaries found. Select the target area for batch cabling: "))
     (setq ent (car (entsel)))
     (if (null ent) (progn (setvar "CMDECHO" old_cmdecho) (exit))))
    (T
     (princ "\nSelect boundary polyline (must have SolarPro layout data): ")
     (setq ent (car (entsel)))
     (if (null ent) (progn (setvar "CMDECHO" old_cmdecho) (exit)))))

  (setvar "CMDECHO" 0)
  (setq xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (not (and xdata (= (caar xdata) "FS_SOLAR_DATA")))
    (progn
      (princ "\nERROR: The selected object has no SolarPro data.")
      (setvar "CMDECHO" old_cmdecho)
      (exit)))
  
  (setq verts (get-poly-approx-vertices ent))

  ;; -------------------------------------------------------
  ;; STEP 1: Ask cable parameters ONCE
  ;; -------------------------------------------------------
  (setq dccfg (dccaball-open-dialog))
  (if (null dccfg)
    (progn
      (princ "\nBatch DC cabling cancelled.")
      (setvar "CMDECHO" old_cmdecho)
      (exit)))

  (setq csize        (nth 0 dccfg)
        neg_o        (nth 1 dccfg)
        updown       (nth 2 dccfg)
        trunk_mode   (nth 3 dccfg)
        trunk_offset (nth 4 dccfg))

  ;; mps  from AUTOSTRINGDIALOG global (*asd-mps*), fall back to 18
  (setq mps (if (and (boundp '*asd-mps*) (> *asd-mps* 0)) *asd-mps* 18))
  (princ (strcat "\n  Modules/string  : " (itoa mps) " (from inverter grouping)"))
  (princ (strcat "\n  Cable size      : " (rtos csize 2 0) " Sq.mm"))
  (princ (strcat "\n  Trunk mode      : " trunk_mode))
  (setvar "CMDECHO" 0)

  ;; -------------------------------------------------------
  ;; STEP 2: Auto-detect inverters (inside boundary only)
  ;; -------------------------------------------------------
  (setq inv_data_list nil)
  (setq lbl_ss (ssget "_X" '((0 . "MTEXT") (8 . "STRINGING"))))

  (if lbl_ss
    (progn
      (setq idx 0)
      (while (< idx (sslength lbl_ss))
        (setq ename  (ssname lbl_ss idx)
              edata  (entget ename)
              raw_txt (cdr (assoc 1 edata))
              lbl_pt (cdr (assoc 10 edata)))
        ;; Condition: Must be INV-, not STR-, and inside boundary
        (if (and raw_txt
                 (vl-string-search "INV-" (strcase raw_txt))
                 (not (vl-string-search "STR-" (strcase raw_txt)))
                 (PointInPolygonList lbl_pt verts))
          (progn
            (setq lbl_x  (car  lbl_pt)
                  lbl_y  (cadr lbl_pt))
            ;; Extract the clean inverter ID text
            (setq inv_id (vl-string-trim " " raw_txt))
            (if (vl-string-search ";" inv_id)
              (setq inv_id (substr inv_id (+ (vl-string-search ";" inv_id) 2)))
            )
            (if (= (substr inv_id (strlen inv_id)) "}")
              (setq inv_id (substr inv_id 1 (1- (strlen inv_id)))))
            (setq inv_id (vl-string-trim " " inv_id))
            
            (if (and (> (strlen inv_id) 3)
                     (= (substr (strcase inv_id) 1 4) "INV-")
                 (not (assoc (strcase inv_id) inv_data_list)))
              (setq inv_data_list (cons (list (strcase inv_id) lbl_x lbl_y) inv_data_list)))))
        (setq idx (1+ idx)))))

  (if (null inv_data_list)
    (progn
      (princ "\nERROR: No INV-* labels found on STRINGING layer.")
      (princ "\nRun AUTOSTRING first to generate inverter labels.")
      (setvar "CMDECHO" old_cmdecho)
      (exit)))

  ;; Sort inverters by their label text (INV-1, INV-2, ... INV-10 etc.)
  (setq inv_data_list
    (vl-sort inv_data_list
      (function (lambda (a b)
        ;; Extract number after "INV-" for numeric sort
        (setq na (atoi (substr (car a) 5))
              nb (atoi (substr (car b) 5)))
        (< na nb)))))

  (princ (strcat "\nFound " (itoa (length inv_data_list)) " inverter(s): "))
  (foreach rec inv_data_list
    (princ (strcat (car rec) " ")))

  ;; -------------------------------------------------------
  ;; STEP 3: Collect ALL + terminal positions from DC_STRINGING
  ;; (used for all inverters  we filter per inverter via proximity)
  ;; -------------------------------------------------------
  (setq all_pos nil)
  (setq pos_ss (ssget "_X" '((0 . "MTEXT") (8 . "DC_STRINGING"))))
  (if pos_ss
    (progn
      (setq n 0)
      (while (< n (sslength pos_ss))
        (setq ename  (ssname pos_ss n)
              edata  (entget ename)
              raw_txt2 (cdr (assoc 1 edata)))
        (if raw_txt2
          (progn
            (setq pos_x (car  (cdr (assoc 10 edata)))
                  pos_y (cadr (cdr (assoc 10 edata))))
            (setq all_pos (cons (list pos_x pos_y) all_pos))))
        (setq n (1+ n)))))

  ;; -------------------------------------------------------
  ;; STEP 4: Loop through each inverter  find its strings, draw cables
  ;; -------------------------------------------------------
  (setq total_cables 0  total_invs 0  skipped_invs 0)

  (foreach inv_rec inv_data_list
    (setq inv_id  (car  inv_rec)
          inv_cx  (cadr  inv_rec)   ; label center X   trunk endpoint X
          inv_cy  (caddr inv_rec))  ; label center Y   trunk Y (+ optional offset)

    (setq search_key (strcat inv_id "-STR-"))
    (setq trunk_y    (cond
                       ((= trunk_mode "Above") (+ inv_cy trunk_offset))
                       ((= trunk_mode "Below") (- inv_cy trunk_offset))
                       (T inv_cy)))
    (setq inv_x      inv_cx)

    ;; --- Find string labels for this inverter ---
    (setq term_list nil)

    ;; Scan MTEXT
    (if lbl_ss
      (progn
        (setq idx 0)
        (while (< idx (sslength lbl_ss))
          (setq ename   (ssname lbl_ss idx)
                edata   (entget ename)
                raw_txt (cdr (assoc 1 edata)))
          (if (and raw_txt
                   (vl-string-search search_key (strcase raw_txt)))
            (progn
              (setq lbl_pt (cdr (assoc 10 edata)))
              (setq term_list (cons (list (car lbl_pt) (cadr lbl_pt) raw_txt) term_list))))
          (setq idx (1+ idx)))))

    ;; Scan regular TEXT entities too
    (setq lbl_ss2 (ssget "_X" '((0 . "TEXT"))))
    (if lbl_ss2
      (progn
        (setq idx2 0)
        (while (< idx2 (sslength lbl_ss2))
          (setq ename2   (ssname lbl_ss2 idx2)
                edata2   (entget ename2)
                raw_txt3 (cdr (assoc 1 edata2)))
          (if (and raw_txt3
                   (vl-string-search search_key (strcase raw_txt3)))
            (progn
              (setq lbl_pt2 (cdr (assoc 10 edata2)))
              (setq term_list (cons (list (car lbl_pt2) (cadr lbl_pt2) raw_txt3) term_list))))
          (setq idx2 (1+ idx2)))))

    (if (null term_list)
      (progn
        (princ (strcat "\n  [SKIP] " inv_id "  no string labels found."))
        (setq skipped_invs (1+ skipped_invs)))
      (progn
        ;; --- Match each label to nearest + terminal position ---
        (setq result_list nil)
        (foreach lbl term_list
          (setq lbl_num (list (car lbl) (cadr lbl)))
          (setq near_ent nil  near_dist 1e38)
          (if all_pos
            (foreach p all_pos
              (setq cur_dist (distance lbl_num p))
              (if (< cur_dist near_dist)
                (setq near_dist cur_dist  near_ent p))))
          (if near_ent
            (setq result_list (cons near_ent result_list))
            (setq result_list (cons lbl_num result_list))))

        ;; --- Draw cables for this inverter ---
        (setq lbl_num 0)  ; reuse var as counter
        (foreach pt result_list
          (setq tx (car pt)  ty (cadr pt))
          (setq p1 (list tx ty 0.0)
                p2 (list tx trunk_y 0.0)
                p3 (list inv_x trunk_y 0.0))
          (entmakex (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                          '(8 . "DC_CABLE")  '(100 . "AcDbPolyline")
                          '(90 . 3) '(70 . 0)
                          (cons 10 p1) (cons 10 p2) (cons 10 p3)
                          (list -3 (list "FS_DC_CABLE"
                                         (cons 1000 inv_id)
                                         (cons 1000 (itoa mps))
                                         (cons 1000 (rtos csize 2 1))
                                         (cons 1000 (rtos neg_o 2 1))
                                         (cons 1000 (rtos updown 2 1))))))
          (setq total_cables (1+ total_cables)
                lbl_num      (1+ lbl_num)))

        (princ (strcat "\n  [OK] " inv_id
                       "  " (itoa lbl_num) " cable(s) routed"
                       "  trunk Y=" (rtos trunk_y 2 2)
                       "  inv X="  (rtos inv_x  2 2)))
        (setq total_invs (1+ total_invs)))))

  (setvar "CMDECHO" old_cmdecho)
  (princ (strcat "\n\n=== DCCABLINGALL Complete ==="
                 "\n  Inverters processed : " (itoa total_invs)
                 "\n  Inverters skipped   : " (itoa skipped_invs)
                 "\n  Total cables routed : " (itoa total_cables)
                 "\n  Use DCCABLEEXPORT to generate BOM."
                 "\n=============================="))
  (princ))

;;;------------------------------------------------------------
;;; Clear DC Cabling (Per Inverter or All)
;;;------------------------------------------------------------
(defun c:CLEARDCCABLING (/ inv_id ss idx ename edata xdata matched total)
  (setq inv_id (getstring "\nEnter Inverter ID to clear (or ALL): "))
  (if (= inv_id "")
    (progn
      (princ "\nAction cancelled.")
      (exit)))

  (setq ss (ssget "_X" '((0 . "LWPOLYLINE") (8 . "DC_CABLE"))))
  (setq total 0)
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ename (ssname ss idx)
              edata (entget ename '("FS_DC_CABLE"))
              xdata (cdr (assoc -3 edata)))
        (if (and xdata (= (caar xdata) "FS_DC_CABLE"))
          (progn
            (setq matched (cdr (assoc 1000 (cdar xdata))))
            (if (or (wcmatch (strcase inv_id) "ALL")
                    (= (strcase matched) (strcase inv_id)))
              (progn
                (entdel ename)
                (setq total (1+ total))))))
        (setq idx (1+ idx)))
      (princ (strcat "\nRemoved " (itoa total) " DC cable(s).")))
    (princ "\nNo DC cables found on layer DC_CABLE."))
  (princ))

;;;------------------------------------------------------------
;;; Export DC Cable BOM to CSV (Grouped by Inverter)
;;;------------------------------------------------------------
(defun c:DCCABLEEXPORT
  (/ ss idx ename edata xdata inv_id mps csize neg_o updown p_list j p1 p2
     raw_len pos_len neg_len tot_len margin vmp imp tc_temp temp_op str_vol str_cur
     r20 r50 vdrop vdrop_pct csv_path f data_map cur_list all_keys str_idx xd
     total_inv_len total_inv_vdrop row_data avg_vdrop first_csize s_no r_mps
     r_pos r_neg r_upd r_tot r_mar r_vmp r_svol r_scur r_r20 r_tc r_r50 r_vdr r_vdrp)
  (vl-load-com)
  (setq ss (ssget "_X" '((0 . "LWPOLYLINE") (8 . "DC_CABLE"))))
  (if (not ss) (progn (princ "\nNo DC cables found to export.") (exit)))

  ;;  Read electrical parameters from boundary XDATA (set by AUTOSTRINGDIALOG) 
  ;; FS_SOLAR_DATA indices: 14=Voc 15=Vmp 16=Isc 17=Imp 18=tc_voc 19=tc_vmp 20=t_min 21=t_max
  ;; Defaults are used only if no boundary with XDATA is found in the drawing.
  (setq vmp    37.25   ; default fallback
        imp     8.86
        temp_op 50.0
        tc_temp 0.00393) ; copper temperature coefficient  physical constant, never changes

  (setq bnd_ss (ssget "_X" '((-3 ("FS_SOLAR_DATA")))))
  (if bnd_ss
    (progn
      (setq bnd_ent (ssname bnd_ss 0)
            bnd_xd  (cdr (assoc -3 (entget bnd_ent '("FS_SOLAR_DATA")))))
      (if (and bnd_xd (= (caar bnd_xd) "FS_SOLAR_DATA"))
        (progn
          (setq xd_fields (cdar bnd_xd))
          (if (and (nth 15 xd_fields) (> (cdr (nth 15 xd_fields)) 0.0))
            (setq vmp (cdr (nth 15 xd_fields))))
          (if (and (nth 17 xd_fields) (> (cdr (nth 17 xd_fields)) 0.0))
            (setq imp (cdr (nth 17 xd_fields))))
          (if (and (nth 21 xd_fields) (> (cdr (nth 21 xd_fields)) 0.0))
            (setq temp_op (cdr (nth 21 xd_fields))))
          (princ (strcat "\nElectrical data loaded from boundary XDATA:"
                         "\n  Vmp = " (rtos vmp 2 2) " V"
                         "\n  Imp = " (rtos imp 2 2) " A"
                         "\n  Operating Temp = " (rtos temp_op 2 1) " C"
                         "\n  Copper tc = 0.00393 (standard)")))
        (princ "\nNo XDATA found on boundary  using default electrical values.")))
    (princ "\nNo SolarPro boundary in drawing  using default electrical values."))

  (setq csv_path (getfiled "Export DC Cable BOM" "DC_Cable_BOM.csv" "csv" 1))
  (if (not csv_path) (exit))
  
  (setq data_map nil)
  (setq idx 0)
  (while (< idx (sslength ss))
    (setq ename (ssname ss idx)
          edata (entget ename '("FS_DC_CABLE"))
          xdata (cdr (assoc -3 edata)))
          
    (if (and xdata (= (caar xdata) "FS_DC_CABLE"))
      (progn
        (setq xd (cdar xdata))
        (if (>= (length xd) 5)
          (progn
            (setq inv_id (cdr (nth 0 xd)))
            (setq mps    (atoi (cdr (nth 1 xd))))
            (setq csize  (atof (cdr (nth 2 xd))))
            (setq neg_o  (atof (cdr (nth 3 xd))))
            (setq updown (atof (cdr (nth 4 xd))))
          )
          (progn
            (setq inv_id (cdr (nth 0 xd)))
            (setq mps 18 csize 4.0 neg_o 2.5 updown 5.0)
          )
        )
        
        (setq p_list nil)
        (foreach item edata
          (if (= (car item) 10) (setq p_list (cons (cdr item) p_list))))
        (setq p_list (reverse p_list))
        
        (setq raw_len 0.0  j 0)
        (while (< j (1- (length p_list)))
          (setq p1 (nth j p_list) p2 (nth (1+ j) p_list))
          (setq raw_len (+ raw_len (distance p1 p2)))
          (setq j (1+ j)))
          
        (setq pos_len raw_len)
        (setq neg_len (+ raw_len neg_o))
        (setq tot_len (+ pos_len neg_len updown updown))
        (setq margin (* tot_len 1.05))
        
        (setq str_vol (* mps vmp))
        (setq str_cur imp)
        (setq r20 (if (>= csize 5.5) 3.390 5.09))
        (setq r50 (* r20 (+ 1.0 (* tc_temp (- temp_op 20.0)))))
        
        (setq vdrop (/ (* str_cur r50 margin) 1000.0))
        (setq vdrop_pct (* (/ vdrop str_vol) 100.0))
        
        (setq row_data (list inv_id mps pos_len neg_len updown updown tot_len margin vmp str_vol str_cur r20 tc_temp r50 vdrop vdrop_pct csize))
        
        (setq cur_list (assoc inv_id data_map))
        (if cur_list
          (setq data_map (subst (cons inv_id (append (cdr cur_list) (list row_data))) cur_list data_map))
          (setq data_map (cons (cons inv_id (list row_data)) data_map)))
      ))
    (setq idx (1+ idx)))
    
  (setq f (open csv_path "w"))
  
  (setq all_keys (mapcar 'car data_map))
  (setq all_keys (vl-sort all_keys '<))
  
  (foreach key all_keys
    (write-line (strcat
    "INVERTER NO,STRING NO,STRING IN SERIES,ACTUAL LENGTH +VE,ACTUAL LENGTH -VE,"
    "UP & DOWN +VE,UP & DOWN -VE,TOTAL CABLE LENGHT,5% MARGIN,"
    "Module Vmp,STRING VOLTAGE,STRING CURRENT,"
    "RESISTANCE (ohm/KM) AT 20C,TEMP COEFFICIENT T,"
    "RESISTANCE (ohm/KM) AT 50C,VOLTAGE DROP,VOLTAGE DROP %") f)
    
    (setq cur_list (cdr (assoc key data_map)))
    ;; Sort by string length ascending
    (setq cur_list (vl-sort cur_list (function (lambda (a b) (< (nth 2 a) (nth 2 b))))))
    
    (setq str_idx 1  total_inv_len 0.0  total_inv_vdrop 0.0  first_csize "")
    (foreach row cur_list
      (setq s_no (if (< str_idx 10) (strcat "S-0" (itoa str_idx)) (strcat "S-" (itoa str_idx))))
      (setq r_mps (itoa (nth 1 row))
            r_pos (rtos (nth 2 row) 2 2)
            r_neg (rtos (nth 3 row) 2 2)
            r_upd (rtos (nth 4 row) 2 2)
            r_tot (rtos (nth 6 row) 2 2)
            r_mar (rtos (nth 7 row) 2 3)
            r_vmp (rtos (nth 8 row) 2 2)
            r_svol (rtos (nth 9 row) 2 2)
            r_scur (rtos (nth 10 row) 2 2)
            r_r20  (rtos (nth 11 row) 2 3)
            r_tc   (rtos (nth 12 row) 2 5)
            r_r50  (rtos (nth 13 row) 2 3)
            r_vdr  (rtos (nth 14 row) 2 3)
            r_vdrp (rtos (nth 15 row) 2 2)
            csize  (rtos (nth 16 row) 2 0))
            
      (setq first_csize csize)
      
      (write-line (strcat key "," s_no "," r_mps "," r_pos "," r_neg "," r_upd "," r_upd "," r_tot "," r_mar "," r_vmp "," r_svol "," r_scur "," r_r20 "," r_tc "," r_r50 "," r_vdr "," r_vdrp) f)
      
      (setq total_inv_len (+ total_inv_len (nth 7 row)))
      (setq total_inv_vdrop (+ total_inv_vdrop (nth 15 row)))
      (setq str_idx (1+ str_idx)))
      
    (setq avg_vdrop (/ total_inv_vdrop (1- str_idx)))
    
    (write-line "" f)
    (write-line (strcat "Cable Specification -,1C " first_csize " Sq.mm Cu XLPO flexible DC cable,,,,,,,,,,,,,,,") f)
    (write-line (strcat "Total Lenght," (rtos total_inv_len 2 2) ",,,,,,,,,,,,,,,") f)
    (write-line (strcat "Average Voltage Drop," (rtos avg_vdrop 2 2) ",%,,,,,,,,,,,,,,") f)
    (write-line "" f)
    (write-line "" f)
  )
  
  (close f)
  (princ (strcat "\nSuccessfully exported BOM to " csv_path))
  (princ)
)

;;;============================================================
;;; Command: LAPROTECTION  Batch apply radii to LA markers
;;;============================================================
(defun c:LAPROTECTION (/ ss i dcl-id result pole-h lat la-rad pt old-echo old-layer base-pt new-ss sel-mode xd override-rad)
  (setq lat (spd-get-lat-from-xd))
  (if (null lat) (setq lat 23.53))
  (setq la-rad 90.0)

  (setq dcl-path
    (cond
      ((spd-get-dcl "SolarPro - LA Dialog - Protection.dcl"))
      ((spd-get-dcl "SolarPro - LA Dialog - Protection.dcl"))
      ((spd-get-dcl "SolarPro - LA Dialog - Protection.dcl"))))
  (if (null dcl-path) (progn (alert "Cannot find:\nSolarPro - LA Dialog - Protection.dcl") (exit)))
  (setq dcl-id (load_dialog dcl-path))
  (if (or (null dcl-id) (minusp dcl-id)) (progn (alert "Failed to load LA dialog.") (exit)))
  (if (not (new_dialog "la_dialog_protection" dcl-id)) (progn (unload_dialog dcl-id) (exit)))
  (set_tile "la_sel_manual" "1")
  (set_tile "la_override_rad" "0")
  (action_tile "accept" "(setq sel-mode (if (= (get_tile \"la_sel_all\") \"1\") \"all\" \"manual\") override-rad (atof (get_tile \"la_override_rad\"))) (done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")
  (setq result (start_dialog))
  (unload_dialog dcl-id)
  (if (= result 0) (exit))

  ;; Get LA entities based on selection mode
  (cond
    ((= sel-mode "all")
     ;; Find all LA shadows by XData
     (princ "\nSearching for LA entities in drawing...")
     (setq ss (ssget "_X" '((0 . "LWPOLYLINE") (-3 ("FS_SOLAR_DATA")))))
     (if (null ss)
       (progn
         (princ "\nNo LA shadows with XData found. Falling back to manual selection...")
         (princ "\nSelect LA marker points or LA shadows: ")
         (setq ss (ssget '((-4 . "<or") (0 . "POINT") (8 . "SHADOW-MARKERS") (0 . "LWPOLYLINE") (8 . "SHADOW-LA") (-4 . "or>"))))
       )
       (princ (strcat "\nFound " (itoa (sslength ss)) " LA shadow(s) with XData."))
     )
    )
    (T
     ;; Manual selection
     (princ "\nSelect LA marker points (on SHADOW-MARKERS layer) or LA shadows (on SHADOW-LA layer): ")
     (setq ss (ssget '((-4 . "<or") (0 . "POINT") (8 . "SHADOW-MARKERS") (0 . "LWPOLYLINE") (8 . "SHADOW-LA") (-4 . "or>"))))
    )
  )

  (if (null ss) (progn (princ "\nNo LA markers or shadows selected.") (exit)))

  (setq old-echo (getvar "CMDECHO") old-layer (getvar "CLAYER"))
  (setvar "CMDECHO" 0)
  (setup-layer "LA_PROTECTION" "8")
  (command "_.-LAYER" "TR" "82" "LA_PROTECTION" "")

  (setq i 0)
  (while (< i (sslength ss))
    (setq edata (entget (ssname ss i) '("FS_SOLAR_DATA")))
    (setq pt nil)
    (setq use-rad la-rad)
    
    ;; Try to get base point and radius from XData first
    (setq xd (cdr (assoc -3 edata)))
    (if (and xd (= (caar xd) "FS_SOLAR_DATA"))
      (progn
        (setq xd (cdar xd))
        ;; Look for LA_SHADOW or LA_PROTECTION type
        (if (or (= (cdr (assoc 1000 xd)) "LA_SHADOW") (= (cdr (assoc 1000 xd)) "LA_PROTECTION"))
          (progn
            (setq pt (cdr (assoc 1010 xd)))  ; 3D point from XData
            (if (assoc 1040 xd) (setq use-rad (cdr (assoc 1040 xd)))) ; radius from XData
          )
        )
      )
    )
    
    ;; Override radius if in "all" mode and override-rad > 0
    (if (and (= sel-mode "all") override-rad (numberp override-rad) (> override-rad 0))
      (setq use-rad override-rad)
    )
    
    ;; Fallback to entity geometry if no XData (manual mode only)
    ;; In "all" mode, non-LA entities carrying FS_SOLAR_DATA (boundaries,
    ;; tables) must be skipped, not circled at their first vertex
    (if (and (null pt) (= sel-mode "manual"))
      (cond
        ((= (cdr (assoc 0 edata)) "POINT")
         (setq pt (cdr (assoc 10 edata))))
        ((= (cdr (assoc 0 edata)) "LWPOLYLINE")
         (setq pt (cdr (assoc 10 edata)))) ; first vertex
        (T (setq pt nil))
      )
    )
    
    (if pt
      (progn
        ;; Draw Circle via entmake
        (setq b-ent (entmakex (list '(0 . "CIRCLE") '(8 . "LA_PROTECTION") '(62 . 256) (cons 10 pt) (cons 40 use-rad))))
        ;; Draw Solid hatch via command (Solid is safe)
        (if b-ent (command "_.-HATCH" "_P" "SOLID" "_S" b-ent "" ""))
      )
    )
    (setq i (1+ i))
  )
  (setvar "CLAYER" old-layer)
  (setvar "CMDECHO" old-echo)
  (princ (strcat "\nApplied protection logic to " (itoa i) " LA(s)."))
  (princ)
)

;;; (spd-get-lat-from-xd is defined before c:SHADOW above)


;;;============================================================
;;; Command: SETACDB  Define ACDB location
;;;============================================================
(defun c:SETACDB (/ pt)
  (setq pt (getpoint "\nPick ACDB location: "))
  (if pt
    (progn
      (setq *solarpro-acdb-pt* pt)
      (if (not (tblsearch "LAYER" "AC_EQUIPMENT")) (command "_.LAYER" "_Make" "AC_EQUIPMENT" "_Color" "2" "" ""))
      (entmake (list '(0 . "POINT") (cons 10 pt) '(8 . "AC_EQUIPMENT")))
      (entmake (list '(0 . "TEXT") (cons 10 (list (car pt) (+ (cadr pt) 0.5) 0)) '(40 . 0.5) (cons 1 "ACDB") '(8 . "AC_EQUIPMENT")))
      (princ "\nACDB marked.")))
  (princ)
)

;;;============================================================
;;; Command: ACCABLING  Route AC cables from Inverters to ACDB
;;;============================================================
(defun c:ACCABLING (/ acdb-ss acdb-ent acdb-obj acdb-pt pmin pmax minpt maxpt
                      path-ent path-obj lbl-ss idx ename edata raw_txt inv-pt inv_list num_inv
                      lay-name c-layer gap width color mid_idx)
  (vl-load-com)
  
  (setq gap 0.17    ; 0.17m gap between parallel cables
        width 0.10  ; Global width of 0.10m
        color 6)    ; Purple (Magenta)
  
  ;; 1. Setup Layer
  (setq lay-name "AC_CABLE")
  (if (not (tblsearch "LAYER" lay-name))
    (command "_.LAYER" "_Make" lay-name "_Color" "4" "" ""))
  (setq c-layer (getvar "CLAYER"))
  (setvar "CLAYER" lay-name)

  ;; 2. Get ACDB Reference (from Layer ACDB or manual pick)
  (setq acdb-ss (ssget "_X" '((8 . "ACDB"))))
  (if acdb-ss
    (progn
      (setq acdb-ent (ssname acdb-ss 0)
            acdb-obj (vlax-ename->vla-object acdb-ent))
      (vla-getboundingbox acdb-obj 'minpt 'maxpt)
      (setq pmin (vlax-safearray->list minpt)
            pmax (vlax-safearray->list maxpt)
            acdb-pt (list (/ (+ (car pmin) (car pmax)) 2.0)
                         (/ (+ (cadr pmin) (cadr pmax)) 2.0)
                         0.0))
      (princ "\nAuto-detected ACDB on layer 'ACDB'."))
    (progn
      (setq acdb-pt (if (boundp '*solarpro-acdb-pt*) *solarpro-acdb-pt* nil))
      (if (null acdb-pt)
        (setq acdb-pt (getpoint "\nLayer 'ACDB' not found. Pick ACDB location manually: ")))))
  
  (if (null acdb-pt) (progn (princ "\nError: No ACDB defined.") (exit)))

  ;; 3. Select or Draw Main Path
  (princ "\nSelect existing Main Path Polyline for custom route, or press Enter for AUTO COMB ROUTING: ")
  (setq path-ent (car (entsel)))
  (setq use_auto (null path-ent))
  
  (if (not use_auto)
    (progn
      (if (or (null path-ent) (/= (cdr (assoc 0 (entget path-ent))) "LWPOLYLINE"))
        (progn (princ "\nError: Must select a valid LWPOLYLINE.") (exit)))
      (setq path-obj (vlax-ename->vla-object path-ent))
    )
  )

  ;; 4. Detect and Sort Inverters
  (setq lbl-ss (ssget "_X" '((0 . "MTEXT") (8 . "STRINGING"))))
  (if (null lbl-ss)
    (progn (princ "\nError: No INV labels found on STRINGING layer.") (exit)))

  (setq inv_list '() idx 0
        min_x 1e99 max_x -1e99 min_y 1e99 max_y -1e99)
  (while (< idx (sslength lbl-ss))
    (setq ename (ssname lbl-ss idx)
          edata (entget ename)
          raw_txt (cdr (assoc 1 edata))
          inv-pt (cdr (assoc 10 edata)))
    (if (and raw_txt (vl-string-search "INV-" (strcase raw_txt)))
      (progn
        (setq inv_list (cons (list nil inv-pt raw_txt) inv_list))
        (setq min_x (min min_x (car inv-pt)) max_x (max max_x (car inv-pt))
              min_y (min min_y (cadr inv-pt)) max_y (max max_y (cadr inv-pt)))
      )
    )
    (setq idx (1+ idx)))
  
  (if (null inv_list) (progn (princ "\nError: No Inverters detected.") (exit)))

  ;; Determine Routing Strategy
  (if use_auto
    (progn
      (setq is_vh (> (- max_y min_y) (- max_x min_x)))
      (if is_vh
        (setq inv_list (vl-sort inv_list (function (lambda (a b) (> (car (nth 1 a)) (car (nth 1 b)))))))
        (setq inv_list (vl-sort inv_list (function (lambda (a b) (> (cadr (nth 1 a)) (cadr (nth 1 b)))))))
      )
    )
    (progn
      ;; Update distances for Custom Path
      (setq clean_list nil)
      (foreach item inv_list
        (setq clean_list (cons (list (vlax-curve-getDistAtPoint path-obj (vlax-curve-getClosestPointTo path-obj (nth 1 item)))
                                     (nth 1 item) (nth 2 item)) clean_list))
      )
      (setq inv_list (vl-sort clean_list (function (lambda (a b) (< (car a) (car b))))))
    )
  )
  
  (setq num_inv (length inv_list)
        mid_idx (/ (1- num_inv) 2.0))

  (if (not (tblsearch "APPID" "FS_AC_CABLE")) (regapp "FS_AC_CABLE"))

;;; Route extrapolation algorithm to clone structural path topology flawlessly parallel
(defun BuildProfileRoute (inv-pt off-ulist / route v_prev i O_prev O_curr is_vert v_next)
  (setq route (list inv-pt))
  (setq v_prev inv-pt)
  (setq i 1)
  (while (< i (length off-ulist))
    (setq O_prev (nth (1- i) off-ulist))
    (setq O_curr (nth i off-ulist))
    
    (setq is_vert (> (abs (- (cadr O_curr) (cadr O_prev))) 
                     (abs (- (car O_curr) (car O_prev)))))
    
    (if (= i 1)
      (if is_vert
        (setq v_next (list (car v_prev) (+ (cadr v_prev) (- (cadr O_curr) (cadr O_prev))) 0.0))
        (setq v_next (list (+ (car v_prev) (- (car O_curr) (car O_prev))) (cadr v_prev) 0.0))
      )
      (if is_vert
        (setq v_next (list (car v_prev) (cadr O_curr) 0.0))
        (setq v_next (list (car O_curr) (cadr v_prev) 0.0))
      )
    )
    (setq route (append route (list v_next)))
    (setq v_prev v_next)
    (setq i (1+ i))
  )
  route
)

(defun safe-dist (p1 p2)
  (sqrt (+ (expt (- (car p1) (car p2)) 2.0) (expt (- (cadr p1) (cadr p2)) 2.0))))

  ;; 5. Routing Loop
  (setq idx 0)
  (foreach item inv_list
    (setq inv-pt  (nth 1 item)
          raw_txt (nth 2 item)
          off_dist (* (- idx mid_idx) gap))
    
    (if use_auto
      (progn
        ;; --- PERFECT COMB AUTO ROUTING ---
        (setq p0 (list (car inv-pt) (cadr inv-pt) 0.0))
        (if is_vh
          (progn
            (setq p1 (list (+ (car p0) off_dist) (cadr p0) 0.0))
            (setq p2 (list (car p1) (+ (cadr acdb-pt) off_dist) 0.0))
            (setq p3 (list (car acdb-pt) (cadr p2) 0.0))
          )
          (progn
            (setq p1 (list (car p0) (+ (cadr p0) off_dist) 0.0))
            (setq p2 (list (+ (car acdb-pt) off_dist) (cadr p1) 0.0))
            (setq p3 (list (car p2) (cadr acdb-pt) 0.0))
          )
        )
        (if acdb-ss
          (setq final-pt (list (car (vlax-curve-getClosestPointTo (vlax-ename->vla-object (ssname acdb-ss 0)) p2))
                               (cadr (vlax-curve-getClosestPointTo (vlax-ename->vla-object (ssname acdb-ss 0)) p2)) 0.0))
          (setq final-pt p3)
        )
        (if (< (abs off_dist) 0.001)
          (setq pts (list p0 p2 final-pt))
          (setq pts (list p0 p1 p2 final-pt))
        )
      )
      (progn
        ;; --- CUSTOM PATH ROUTING EXTENSION ---
        (if (< (abs off_dist) 0.001)
          (progn
            (setq ename (vlax-vla-object->ename path-obj)
                  ulist (get-poly-approx-vertices ename))
            (setq off_path nil)
          )
          (progn
            (setq off_variant (vlax-invoke-method path-obj 'Offset off_dist)
                  off_list    (vlax-safearray->list (vlax-variant-value off_variant))
                  off_path    (car off_list)) 
            (setq ename (vlax-vla-object->ename off_path)
                  ulist (get-poly-approx-vertices ename))
          )
        )

        (setq clean_u nil)
        (foreach pt ulist (setq clean_u (append clean_u (list (list (car pt) (cadr pt) 0.0)))))
        (setq ulist clean_u)

        (if (> (safe-dist (car ulist) acdb-pt) (safe-dist (last ulist) acdb-pt))
          (setq ulist ulist)
          (setq ulist (reverse ulist))
        )

        (setq pts (BuildProfileRoute (list (car inv-pt) (cadr inv-pt) 0.0) ulist))

        (setq u_last (last pts))
        (if acdb-ss
          (setq final-pt (list (car (vlax-curve-getClosestPointTo (vlax-ename->vla-object (ssname acdb-ss 0)) u_last))
                               (cadr (vlax-curve-getClosestPointTo (vlax-ename->vla-object (ssname acdb-ss 0)) u_last)) 0.0))
          (setq final-pt (list (car acdb-pt) (cadr acdb-pt) 0.0)))
        
        (setq pts (append (reverse (cdr (reverse pts))) (list final-pt)))

        (if off_path (vla-delete off_path))
      )
    )

    ;; 5. Draw
    (setvar "CMDECHO" 0)
    (command "_.PLINE")
    (foreach p pts (command p))
    (command "")
          
    (setq new_pline (vlax-ename->vla-object (entget (entlast)))
          new_ent   (entlast)
          new_obj   (vlax-ename->vla-object new_ent))
          
    (vla-put-ConstantWidth new_obj width)
    (vla-put-Color new_obj color)

    ;; Embed XDATA
    (setq xd-list (list -3 (list "FS_AC_CABLE" 
                                (cons 1000 (vl-string-trim "{}" raw_txt))
                                (cons 1040 120.0) 
                                (cons 1040 415.0) 
                                (cons 1040 80.0)  
                                (cons 1040 (vlax-curve-getDistAtPoint new_obj (vlax-curve-getEndPoint new_obj))))))
    (entmod (append (entget new_ent) (list xd-list)))
    (princ (strcat "\nParallel orthogonal routed " raw_txt))
    (setq idx (1+ idx)))

  (setvar "CLAYER" c-layer)
  (princ "\nPremium AC Bundle Complete.")
  (princ)
)


;;; -------------------------------------------------------------------------
;;; SolarPro - Earthing Layout Automation
;;; Task 4 - Fully Automated Earthing Matrix
;;; -------------------------------------------------------------------------

(vl-load-com)

(defun sp-get-table-global-pile-points (ent / ed bname ins rot b_ent b_ed pts pt x y gx gy)
  (setq pts nil
        ed (entget ent)
        bname (cdr (assoc 2 ed))
        ins (cdr (assoc 10 ed))
        rot (cond ((cdr (assoc 50 ed))) (0.0)))
  (if (and bname (setq b_ent (tblobjname "BLOCK" bname)))
    (progn
      (setq b_ent (entnext b_ent))
      (while b_ent
        (setq b_ed (entget b_ent))
        (if (and (member (cdr (assoc 0 b_ed)) '("POINT" "CIRCLE"))
                 (= (strcase (cdr (assoc 8 b_ed))) "PILING"))
          (progn
            (setq pt (cdr (assoc 10 b_ed))
                  x (car pt)
                  y (cadr pt)
                  gx (+ (car ins) (- (* x (cos rot)) (* y (sin rot))))
                  gy (+ (cadr ins) (+ (* x (sin rot)) (* y (cos rot)))))
            (setq pts (cons (list gx gy 0.0) pts))))
        (setq b_ent (entnext b_ent)))))
  (reverse pts))

(defun sp-table-bbox-record (ent / obj minp maxp bmin bmax cx cy h piles)
  (setq obj (vlax-ename->vla-object ent))
  (vla-getboundingbox obj 'minp 'maxp)
  (setq bmin (vlax-safearray->list minp)
        bmax (vlax-safearray->list maxp)
        cx (/ (+ (car bmin) (car bmax)) 2.0)
        cy (/ (+ (cadr bmin) (cadr bmax)) 2.0)
        h  (- (cadr bmax) (cadr bmin))
        piles (sp-get-table-global-pile-points ent))
  (list (cons 'ename ent)
        (cons 'minx (car bmin))
        (cons 'maxx (car bmax))
        (cons 'miny (cadr bmin))
        (cons 'maxy (cadr bmax))
        (cons 'cx cx)
        (cons 'cy cy)
        (cons 'h h)
        (cons 'piles piles)))

(defun sp-rec-val (key rec)
  (cdr (assoc key rec)))

(defun sp-row-sort-left-right (row)
  (vl-sort row '(lambda (a b) (< (sp-rec-val 'cx a) (sp-rec-val 'cx b)))))

(defun sp-group-tables-into-rows (records / sorted sum_h cnt avg_h tol rows current anchor cy)
  (setq sorted (vl-sort records
                        '(lambda (a b)
                           (if (> (abs (- (sp-rec-val 'cy a) (sp-rec-val 'cy b))) 1e-6)
                             (> (sp-rec-val 'cy a) (sp-rec-val 'cy b))
                             (< (sp-rec-val 'cx a) (sp-rec-val 'cx b))))))
  (setq sum_h 0.0 cnt 0)
  (foreach rec records
    (setq sum_h (+ sum_h (sp-rec-val 'h rec))
          cnt (1+ cnt)))
  (setq avg_h (if (> cnt 0) (/ sum_h cnt) 2.5)
        tol (max 0.5 (* avg_h 0.6))
        rows nil
        current nil
        anchor nil)
  (foreach rec sorted
    (setq cy (sp-rec-val 'cy rec))
    (if (or (null current) (> (abs (- cy anchor)) tol))
      (progn
        (if current
          (setq rows (append rows (list (sp-row-sort-left-right current)))))
        (setq current (list rec)
              anchor cy))
      (setq current (append current (list rec)))))
  (if current
    (setq rows (append rows (list (sp-row-sort-left-right current)))))
  rows)

(defun sp-piles-near-centerline (piles cy / tol out)
  (setq tol 0.35
        out nil)
  (foreach pt piles
    (if (<= (abs (- (cadr pt) cy)) tol)
      (setq out (cons pt out))))
  (if out
    (reverse out)
    piles))

(defun sp-leftmost-pile (piles cy / best candidates)
  (setq best nil
        candidates (sp-piles-near-centerline piles cy))
  (foreach pt candidates
    (if (or (null best) (< (car pt) (car best)))
      (setq best pt)))
  best)

(defun sp-rightmost-pile (piles cy / best candidates)
  (setq best nil
        candidates (sp-piles-near-centerline piles cy))
  (foreach pt candidates
    (if (or (null best) (> (car pt) (car best)))
      (setq best pt)))
  best)

(defun sp-draw-earthing-segment (pt_a pt_b /)
  (entmake
    (list '(0 . "LWPOLYLINE")
          '(100 . "AcDbEntity")
          (cons 8 "EARTHING_CABLE")
          '(62 . 3)
          '(100 . "AcDbPolyline")
          '(90 . 2)
          '(70 . 0)
          '(43 . 0.035)
          (cons 10 (list (car pt_a) (cadr pt_a)))
          (cons 10 (list (car pt_b) (cadr pt_b))))))

(defun sp-draw-table-earthing-links (tbl_ss / records i ent rows row idx rec_a rec_b pt_a pt_b count)
  (setq records nil
        i 0
        count 0)
  (while (< i (sslength tbl_ss))
    (setq ent (ssname tbl_ss i))
    (setq records (append records (list (sp-table-bbox-record ent))))
    (setq i (1+ i)))
  (setq rows (sp-group-tables-into-rows records))
  (foreach row rows
    (setq idx 0)
    (while (< idx (1- (length row)))
      (setq rec_a (nth idx row)
            rec_b (nth (1+ idx) row)
            pt_a (sp-rightmost-pile (sp-rec-val 'piles rec_a) (sp-rec-val 'cy rec_a))
            pt_b (sp-leftmost-pile  (sp-rec-val 'piles rec_b) (sp-rec-val 'cy rec_b)))
      (if (and pt_a pt_b)
        (progn
          (sp-draw-earthing-segment pt_a pt_b)
          (setq count (1+ count))))
      (setq idx (1+ idx))))
  count)

(defun sp-connect-row-end-piles-to-perimeter (tbl_ss perim_ent / records i ent rows row first_rec last_rec pt_left pt_right near_left near_right count)
  (setq count 0)
  (if (and tbl_ss perim_ent)
    (progn
      (setq records nil
            i 0)
      (while (< i (sslength tbl_ss))
        (setq ent (ssname tbl_ss i))
        (setq records (append records (list (sp-table-bbox-record ent))))
        (setq i (1+ i)))
      (setq rows (sp-group-tables-into-rows records))
      (foreach row rows
        (if (> (length row) 0)
          (progn
            (setq first_rec (car row)
                  last_rec  (car (reverse row))
                  pt_left   (sp-leftmost-pile  (sp-rec-val 'piles first_rec) (sp-rec-val 'cy first_rec))
                  pt_right  (sp-rightmost-pile (sp-rec-val 'piles last_rec)  (sp-rec-val 'cy last_rec)))
            (if pt_left
              (progn
                (setq near_left (list *sp-earthing-perim-minx* (cadr pt_left) 0.0))
                (if near_left
                  (progn
                    (sp-draw-earthing-segment pt_left near_left)
                    (setq count (1+ count))))))
            (if (and pt_right
                      (or (/= (sp-rec-val 'ename first_rec) (sp-rec-val 'ename last_rec))
                          (> (distance pt_left pt_right) 1e-6)))
              (progn
                (setq near_right (list *sp-earthing-perim-maxx* (cadr pt_right) 0.0))
                (if near_right
                  (progn
                    (sp-draw-earthing-segment pt_right near_right)
                    (setq count (1+ count))))))))))
  count))

(defun sp-build-earthing-perimeter (tbl_ss offset / i ent rec minx miny maxx maxy)
  (setq i 0
        minx 1e99
        miny 1e99
        maxx -1e99
        maxy -1e99)
  (while (< i (sslength tbl_ss))
    (setq ent (ssname tbl_ss i)
          rec (sp-table-bbox-record ent))
    (if (< (sp-rec-val 'minx rec) minx) (setq minx (sp-rec-val 'minx rec)))
    (if (< (sp-rec-val 'miny rec) miny) (setq miny (sp-rec-val 'miny rec)))
    (if (> (sp-rec-val 'maxx rec) maxx) (setq maxx (sp-rec-val 'maxx rec)))
    (if (> (sp-rec-val 'maxy rec) maxy) (setq maxy (sp-rec-val 'maxy rec)))
    (setq i (1+ i)))
  (if (and (< minx maxx) (< miny maxy))
    (progn
      (setq *sp-earthing-perim-minx* (- minx offset)
            *sp-earthing-perim-miny* (- miny offset)
            *sp-earthing-perim-maxx* (+ maxx offset)
            *sp-earthing-perim-maxy* (+ maxy offset))
      (entmakex
        (list '(0 . "LWPOLYLINE")
              '(100 . "AcDbEntity")
              (cons 8 "EARTHING_GRID")
              '(62 . 3)
              '(100 . "AcDbPolyline")
              '(90 . 4)
              '(70 . 1)
              '(43 . 0.035)
              (cons 10 (list *sp-earthing-perim-minx* *sp-earthing-perim-miny*))
              (cons 10 (list *sp-earthing-perim-maxx* *sp-earthing-perim-miny*))
              (cons 10 (list *sp-earthing-perim-maxx* *sp-earthing-perim-maxy*))
              (cons 10 (list *sp-earthing-perim-minx* *sp-earthing-perim-maxy*)))))
    nil))

(defun c:AutoEarthing ( / old_osmode old_cmdecho tbl-ss links_drawn edge_links_drawn offset perim_ent)
  (setq old_osmode (getvar "OSMODE")
        old_cmdecho (getvar "CMDECHO"))
  (setvar "OSMODE" 0)
  (setvar "CMDECHO" 0)

  (setq offset (getdist "\nEarthing perimeter offset from outer tables (m) <1.0>: "))
  (if (or (null offset) (< offset 0.0))
    (setq offset 1.0))

  (vl-cmdf "_.LAYER" "_Make" "EARTHING_GRID" "_Color" "3" "" "_LType" "Continuous" "" "")
  (vl-cmdf "_.LAYER" "_Make" "EARTHING_CABLE" "_Color" "3" "" "_LType" "Continuous" "" "")

  (setq tbl-ss (ssget "_X" '((0 . "INSERT") (2 . "TABLE_*,table_*"))))

  (if tbl-ss
    (progn
      (setq perim_ent (sp-build-earthing-perimeter tbl-ss offset))
      (if perim_ent
        (princ "\nEarthing perimeter created.")
        (princ "\nEarthing perimeter could not be created."))
      ;; First earthing rule only:
      ;; connect last pile of current table to first pile of next table in the same row.
      ;; Peripheral/open-end connection to strip will be added later.
      (setq links_drawn (sp-draw-table-earthing-links tbl-ss))
      (if (> links_drawn 0)
        (princ (strcat "\nTable-to-table earthing links created: " (itoa links_drawn)))
        (princ "\nNo valid neighboring pile pairs found for earthing."))
      ;; Third earthing rule:
      ;; connect open end piles of first/last table in each row to the perimeter strip.
      (if perim_ent
        (progn
          (setq edge_links_drawn (sp-connect-row-end-piles-to-perimeter tbl-ss perim_ent))
          (if (> edge_links_drawn 0)
            (princ (strcat "\nPerimeter end-pile connections created: " (itoa edge_links_drawn)))))))
    (princ "\nError: No tables found in drawing."))

  (setvar "OSMODE" old_osmode)
  (setvar "CMDECHO" old_cmdecho)
  (princ)
)



(defun c:ClearEarthing ( / ss i en)
  (vl-catch-all-apply 'vl-cmdf (list "_.LAYER" "_Unlock" "EARTHING_GRID,EARTHING_PITS,EARTHING_CABLE" ""))
  ;; Also hunt down ANY rogue lines forced to Color 3 (Green) by the old buggy script, regardless of layer
  (setq ss (ssget "_X" '((-4 . "<OR") 
                           (8 . "EARTHING_GRID") 
                           (8 . "EARTHING_PITS") 
                           (8 . "EARTHING_CABLE")
                           (-4 . "<AND") (0 . "LWPOLYLINE,LINE") (62 . 3) (-4 . "AND>")
                         (-4 . "OR>"))))
  (if ss
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq en (ssname ss i))
        (vl-catch-all-apply 'entdel (list en))
        (setq i (1+ i))
      )
      (princ (strcat "\nSuccessfully cleared " (itoa (sslength ss)) " earthing entities (including ghost lines)."))
    )
    (princ "\nNo earthing entities found to clear.")
  )
  (princ)
)

(princ "\nSolarPro Earthing Logic Loaded. Type AutoEarthing to execute.")
(princ "\nType ClearEarthing to remove all generated earthing layouts.")
(princ)

;;;============================================================
;;; SolarPro - Trench Layout and Export Automation
;;; Task 5 - Trench Route generation from Cables
;;;============================================================

(vl-load-com)

;;;------------------------------------------------------------
;;; Command: TRENCHLAYOUT
;;; Selects all DC/AC/Earthing paths and double offsets them.
;;; Drops 10m chainage markers.
;;; Embeds civil volume data as XDATA.
;;;------------------------------------------------------------
(defun c:TRENCHLAYOUT (/ c-layer ss idx en ed obj lay w d offset old-osmode
                       curve-len dist pt ang pt1 pt2 txt-pt rot-ang vol xd
                       off1 off2 e-name last-ent)
  
  ;; 1. Layers Setup
  (if (not (tblsearch "LAYER" "TRENCH"))
    (command "_.LAYER" "_Make" "TRENCH" "_Color" "2" "" "")) ; Yellow
  (if (not (tblsearch "LAYER" "TRENCH_LABEL"))
    (command "_.LAYER" "_Make" "TRENCH_LABEL" "_Color" "3" "" "")) ; Green
  
  (setq w (getreal "\nSpecify general Trench Width in mm <450>: "))
  (if (null w) (setq w 450.0))
  (setq d (getreal "\nSpecify general Trench Depth in mm <900>: "))
  (if (null d) (setq d 900.0))
  
  ;; Assuming drawing units are meters since coordinates in previous codes used meters, 
  ;; but the prompt asks in mm. Wait, earlier codes used 1.5 offset, so let's convert mm to meters.
  (setq offset (/ (/ w 1000.0) 2.0))
  
  ;; 2. Select Source Polylines
  ;; Scan layers DC_CABLE, AC_CABLE, EARTHING_CABLE, EARTHING_GRID
  (setq ss (ssget "_X" '((0 . "LWPOLYLINE,POLYLINE") (8 . "DC_CABLE,AC_CABLE,EARTH_CABLE,EARTHING_GRID,EARTH_MAT,EARTHING_CABLE"))))
  
  (if (not ss)
    (progn
      (princ "\nNo cable routes found on designated layers!")
      (exit)
    )
  )

  (setq c-layer (getvar "CLAYER"))
  (setq old-osmode (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  
  (setq idx 0)
  (while (< idx (sslength ss))
    (setq en (ssname ss idx)
          ed (entget en)
          obj (vlax-ename->vla-object en)
          lay (cdr (assoc 8 ed)))
          
    ;; 3. Double-Wall Offset
    ;; offset distance in drawing units (meters)
    (setq off1 (vl-catch-all-apply 'vla-Offset (list obj offset)))
    (if (not (vl-catch-all-error-p off1))
      (foreach o (vlax-safearray->list (vlax-variant-value off1))
        (vla-put-Layer o "TRENCH")
        (vla-put-Color o 2) ; Color 2 (Yellow)
      )
    )
    (setq off2 (vl-catch-all-apply 'vla-Offset (list obj (- offset))))
    (if (not (vl-catch-all-error-p off2))
      (foreach o (vlax-safearray->list (vlax-variant-value off2))
        (vla-put-Layer o "TRENCH")
        (vla-put-Color o 2)
      )
    )
    
    ;; 4. Embedded Data & Labels
    ;; Calculate Chainage Markers every 10m
    (setq curve-len (vlax-curve-getDistAtParam obj (vlax-curve-getEndParam obj)))
    (setq dist 10.0)
    (setvar "CLAYER" "TRENCH_LABEL")
    (while (< dist curve-len)
      (setq pt (vlax-curve-getPointAtDist obj dist))
      (setq ang (vlax-curve-getFirstDeriv obj (vlax-curve-getParamAtDist obj dist)))
      (setq ang (atan (cadr ang) (car ang)))
      
      ;; Draw chainage line across trench
      (setq pt1 (polar pt (+ ang (/ pi 2.0)) offset))
      (setq pt2 (polar pt (- ang (/ pi 2.0)) offset))
      (command "_.LINE" pt1 pt2 "")
      
      ;; Draw chainage text
      (setq txt-pt (polar pt (+ ang (/ pi 2.0)) (+ offset 0.5))) ; offset text slightly
      (setq rot-ang (/ (* ang 180.0) pi))
      (command "_.TEXT" "J" "BC" txt-pt "0.5" (rtos rot-ang 2 2) (strcat "CH " (rtos dist 2 0)))
      
      (setq dist (+ dist 10.0))
    )
    
    ;; Attach XDATA (FS_TRENCH_BOM) to original polyline
    (if (not (tblsearch "APPID" "FS_TRENCH_BOM")) (regapp "FS_TRENCH_BOM"))
    ;; Embed: Trench Type, Length, Depth(m), Width(m), Volume(m3)
    (setq vol (* (/ w 1000.0) (/ d 1000.0) curve-len))
    (setq xd (list -3 (list "FS_TRENCH_BOM" 
                            (cons 1000 (strcat "TRENCH-" lay))
                            (cons 1040 curve-len)
                            (cons 1040 (/ d 1000.0))
                            (cons 1040 (/ w 1000.0))
                            (cons 1040 vol))))
    (entmod (append ed (list xd)))

    (setq idx (1+ idx))
  )
  
  (setvar "OSMODE" old-osmode)
  (setvar "CLAYER" c-layer)
  (princ (strcat "\nTrench Layout Complete for " (itoa (sslength ss)) " paths."))
  (princ)
)

;;;------------------------------------------------------------
;;; Command: TRENCHEXPORT
;;; Extracts all FS_TRENCH_BOM XDATA to a CSV file.
;;;------------------------------------------------------------
(defun c:TRENCHEXPORT (/ ss idx en edata xd ext-data csv-file f t-type t-len t-depth t-width t-vol
                         tot-vol tot-len)
  ;; Get entities with FS_TRENCH_BOM XDATA
  (setq ss (ssget "_X" '((-3 ("FS_TRENCH_BOM")))))
  
  (if (null ss)
    (progn (princ "\nNo Trench XDATA found. Run TRENCHLAYOUT first.") (exit))
  )
  
  (setq csv-file (getfiled "Export Trench BOM" "C:\\Users\\Admin\\Desktop\\Trench_BOM.csv" "csv" 1))
  (if (null csv-file)
    (progn (princ "\nExport cancelled.") (exit))
  )
  
  (setq f (open csv-file "w"))
  (write-line "TRENCH ID,CABLES INSIDE,LENGTH (m),DEPTH (m),WIDTH (m),EXCAVATION VOLUME (m3)" f)
  
  (setq idx 0 
        tot-vol 0.0
        tot-len 0.0)
        
  (while (< idx (sslength ss))
    (setq en (ssname ss idx))
    (setq edata (entget en '("FS_TRENCH_BOM")))
    (setq xd (cadr (assoc -3 edata)))
    
    (if xd
      (progn
        (setq t-type  (cdr (nth 1 xd)))
        (setq t-len   (cdr (nth 2 xd)))
        (setq t-depth (cdr (nth 3 xd)))
        (setq t-width (cdr (nth 4 xd)))
        (setq t-vol   (cdr (nth 5 xd)))
        
        (write-line (strcat "TR-" (itoa (+ idx 1)) ","
                            t-type ","
                            (rtos t-len 2 2) ","
                            (rtos t-depth 2 2) ","
                            (rtos t-width 2 2) ","
                            (rtos t-vol 2 2)) 
                    f)
                    
        (setq tot-len (+ tot-len t-len))
        (setq tot-vol (+ tot-vol t-vol))
      )
    )
    (setq idx (1+ idx))
  )
  
  ;; Write Summary Line
  (write-line (strcat "TOTAL,," (rtos tot-len 2 2) ",,," (rtos tot-vol 2 2)) f)
  (close f)
  
  (princ (strcat "\nTrench BOM successfully exported to: " csv-file))
  (princ)
)

(princ "\nSolarPro Trenching Logic Loaded. Type TRENCHLAYOUT and TRENCHEXPORT.")
(princ "\n--- SolarPro V2.5 (Fully Resilient Shadows) Loaded Successfully ---")

;;; Count pile entities (POINT or CIRCLE) on PILING layer inside a block definition
(defun spd-count-block-piles (bname / b_ent count ed)
  (setq count 0)
  (if (and bname (setq b_ent (tblobjname "BLOCK" bname)))
    (progn
      (while (setq b_ent (entnext b_ent))
        (setq ed (entget b_ent))
        (if (and (member (cdr (assoc 0 ed)) '("CIRCLE" "POINT"))
                 (= (strcase (cdr (assoc 8 ed))) "PILING"))
          (setq count (1+ count))))))
  count)

;;; Placeholder for PVC Export — not yet implemented
(defun c:SPVCEXPORT ()
  (alert "PVC Export (c:SPVCEXPORT) is not yet implemented.")
  (princ))

(defun spd-get-block-width (bname / itm itms min_p max_p b_min b_max res)
  (setq res 0.0)
  (if (and bname (tblsearch "BLOCK" bname))
    (vl-catch-all-apply
      '(lambda ()
         (setq itms (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object))))
         (setq itm (vla-item itms bname))
         (vla-getboundingbox itm 'min_p 'max_p)
         (setq b_min (vlax-safearray->list min_p)
               b_max (vlax-safearray->list max_p))
         (setq res (- (car b_max) (car b_min))))))
  res)

(defun spd-piling-summary (/ ss k bname bname_counts found bc tbl_cnt np
                              total_piles rows tbl_idx tw rec_np status spacing edge)
  (setq bname_counts nil  total_piles 0  rows nil  tbl_idx 1)
  (vl-catch-all-apply
    '(lambda ()
       (setq spacing (if (and (boundp '*spd-s-pile-db*) *spd-s-pile-db*) (/ (atof *spd-s-pile-db*) 1000.0) 2.0)
             edge    (if (and (boundp '*spd-s-pile-df*) *spd-s-pile-df*) (/ (atof *spd-s-pile-df*) 1000.0) 0.5))
       (if (<= spacing 0.0) (setq spacing 2.0))
       (setq ss (ssget "X" '((0 . "INSERT"))))
       (if ss
         (progn
           (setq k 0)
           (while (< k (sslength ss))
             (setq bname (cdr (assoc 2 (entget (ssname ss k)))))
             (if (and bname (wcmatch (strcase bname) "TABLE_*"))
               (progn
                 (setq found (assoc bname bname_counts))
                 (if found
                   (setq bname_counts (subst (cons bname (1+ (cdr found))) found bname_counts))
                   (setq bname_counts (cons (cons bname 1) bname_counts)))))
             (setq k (1+ k)))))
       (foreach bc bname_counts
         (setq bname   (car bc)
               tbl_cnt (cdr bc)
               np      (spd-count-block-piles bname)
               tw      (spd-get-block-width bname))
         (if (> np 0)
           (progn
             (setq rec_np (fix (+ (/ (- tw (* 2.0 edge)) spacing) 1.99)))
             (if (< rec_np 2) (setq rec_np 2))
             (setq status (if (>= np rec_np) "OK" "Check Piling"))
             (if (= (length bname_counts) 1)
               (setq rows (append rows
                       (list (list "Table Length"      (strcat (rtos tw 2 3) " m"))
                             (list "Piles per Table"   (itoa np))
                             (list "Recommended Piles" (itoa rec_np))
                             (list "Piling Status"     status)
                             (list "Total Piles"        (itoa (* tbl_cnt np))))))
               (progn
                 (setq rows (append rows
                         (list (list (strcat "Type " (itoa tbl_idx) " Length") (strcat (rtos tw 2 2) " m"))
                               (list (strcat "Type " (itoa tbl_idx) " Piles/Table") 
                                     (strcat (itoa np) " (Rec: " (itoa rec_np) ") - " status)))))
                 (setq tbl_idx (1+ tbl_idx))))
             (setq total_piles (+ total_piles (* tbl_cnt np))))))
    ))
  (if (and (> (length bname_counts) 1) (> total_piles 0))
    (setq rows (append rows (list (list "Total Piles (All)" (itoa total_piles))))))
  rows)

;;;------------------------------------------------------------
;;; Core Piling Extraction Logic (Labels and/or CSV)
;;;------------------------------------------------------------
(defun c:ClearPileLabels (/ old_labels j)
  (if (setq old_labels (ssget "X" '((8 . "PILING_LABELS"))))
    (progn (setq j 0) (while (< j (sslength old_labels)) (entdel (ssname old_labels j)) (setq j (1+ j)))
           (princ (strcat "\n" (itoa (sslength old_labels)) " labels deleted.")))
    (princ "\nNo labels found.")) (princ))

;; =============================================================================
;; INTEGRATED DIALOG CONTROLLER (V4.8 - AUTOMATED PILING & HIGH-VIS DIAGRAM)
;; =============================================================================

(defun spd-find-dcl (/ f)
  (setq f (spd-get-dcl "SolarPro - Layout Input Dialog.dcl"))
  (if f f (spd-get-dcl "SolarPro - Layout Input Dialog.dcl")))

(defun spd-get-val (key default / v)
  (setq v (get_tile key))
  (if (and v (/= v "")) v default))

(defun spd-draw-diagram (/ w h dw dh px1 px2 edge_x)
  (setq w (dimx_tile "piling_img")
        h (dimy_tile "piling_img"))
  (if (or (null w) (null h) (<= w 0) (<= h 0)) (exit))

  (start_image "piling_img")
  (fill_image 0 0 w h 250) ; Light background for visibility

  (setq dw (/ (float w) 100.0)
        dh (/ (float h) 100.0))

  ;; Fixed schematic coordinates
  (setq edge_x 15.0 px1 35.0 px2 80.0)

  ;; 1. Draw Table Outline (White/Black - Color 7)
  (vector_image (fix (* edge_x dw)) (fix (* 20 dh)) (fix (* 95 dw)) (fix (* 20 dh)) 7)
  (vector_image (fix (* edge_x dw)) (fix (* 60 dh)) (fix (* 95 dw)) (fix (* 60 dh)) 7)
  (vector_image (fix (* edge_x dw)) (fix (* 20 dh)) (fix (* edge_x dw)) (fix (* 60 dh)) 7)

  ;; 2. Draw Piles (Magenta - Color 6)
  (vector_image (fix (* (- px1 2) dw)) (fix (* 40 dh)) (fix (* (+ px1 2) dw)) (fix (* 40 dh)) 6)
  (vector_image (fix (* px1 dw)) (fix (* (- 40 4) dh)) (fix (* px1 dw)) (fix (* (+ 40 4) dh)) 6)
  (vector_image (fix (* (- px2 2) dw)) (fix (* 40 dh)) (fix (* (+ px2 2) dw)) (fix (* 40 dh)) 6)
  (vector_image (fix (* px2 dw)) (fix (* (- 40 4) dh)) (fix (* px2 dw)) (fix (* (+ 40 4) dh)) 6)

  ;; 3. Draw Dimension Lines & Leaders (Green - Color 3)
  (vector_image (fix (* edge_x dw)) (fix (* 60 dh)) (fix (* edge_x dw)) (fix (* 90 dh)) 3)
  (vector_image (fix (* px1 dw)) (fix (* 45 dh)) (fix (* px1 dw)) (fix (* 90 dh)) 3)
  (vector_image (fix (* px2 dw)) (fix (* 45 dh)) (fix (* px2 dw)) (fix (* 90 dh)) 3)
  (vector_image (fix (* edge_x dw)) (fix (* 80 dh)) (fix (* px1 dw)) (fix (* 80 dh)) 3)
  (vector_image (fix (* px1 dw)) (fix (* 80 dh)) (fix (* px2 dw)) (fix (* 80 dh)) 3)

  ;; 4. Draw Vector Text "1ST"
  (vector_image (fix (* 21 dw)) (fix (* 70 dh)) (fix (* 21 dw)) (fix (* 76 dh)) 3)
  (vector_image (fix (* 23 dw)) (fix (* 70 dh)) (fix (* 25 dw)) (fix (* 70 dh)) 3)
  (vector_image (fix (* 23 dw)) (fix (* 70 dh)) (fix (* 23 dw)) (fix (* 73 dh)) 3)
  (vector_image (fix (* 23 dw)) (fix (* 73 dh)) (fix (* 25 dw)) (fix (* 73 dh)) 3)
  (vector_image (fix (* 25 dw)) (fix (* 73 dh)) (fix (* 25 dw)) (fix (* 76 dh)) 3)
  (vector_image (fix (* 25 dw)) (fix (* 76 dh)) (fix (* 23 dw)) (fix (* 76 dh)) 3)
  (vector_image (fix (* 27 dw)) (fix (* 70 dh)) (fix (* 29 dw)) (fix (* 70 dh)) 3)
  (vector_image (fix (* 28 dw)) (fix (* 70 dh)) (fix (* 28 dw)) (fix (* 76 dh)) 3)

  ;; 5. Draw Vector Text "SPC"
  (vector_image (fix (* 50 dw)) (fix (* 70 dh)) (fix (* 52 dw)) (fix (* 70 dh)) 3)
  (vector_image (fix (* 50 dw)) (fix (* 70 dh)) (fix (* 50 dw)) (fix (* 73 dh)) 3)
  (vector_image (fix (* 50 dw)) (fix (* 73 dh)) (fix (* 52 dw)) (fix (* 73 dh)) 3)
  (vector_image (fix (* 52 dw)) (fix (* 73 dh)) (fix (* 52 dw)) (fix (* 76 dh)) 3)
  (vector_image (fix (* 52 dw)) (fix (* 76 dh)) (fix (* 50 dw)) (fix (* 76 dh)) 3)
  (vector_image (fix (* 54 dw)) (fix (* 76 dh)) (fix (* 54 dw)) (fix (* 70 dh)) 3)
  (vector_image (fix (* 54 dw)) (fix (* 70 dh)) (fix (* 56 dw)) (fix (* 70 dh)) 3)
  (vector_image (fix (* 56 dw)) (fix (* 70 dh)) (fix (* 56 dw)) (fix (* 73 dh)) 3)
  (vector_image (fix (* 56 dw)) (fix (* 73 dh)) (fix (* 54 dw)) (fix (* 73 dh)) 3)
  (vector_image (fix (* 60 dw)) (fix (* 70 dh)) (fix (* 58 dw)) (fix (* 70 dh)) 3)
  (vector_image (fix (* 58 dw)) (fix (* 70 dh)) (fix (* 58 dw)) (fix (* 76 dh)) 3)
  (vector_image (fix (* 58 dw)) (fix (* 76 dh)) (fix (* 60 dw)) (fix (* 76 dh)) 3)

  (end_image))
(defun spd-field-default (key)
  (cond
    ((= key "mount_type") (if *spd-s-mount-type* *spd-s-mount-type* "0"))
    ((= key "gcr") (if *spd-s-gcr* *spd-s-gcr* "40.0"))
    ((= key "tracker_len") (if *spd-s-tracker-len* *spd-s-tracker-len* "90.0"))
    ((= key "motor_gap") (if *spd-s-motor-gap* *spd-s-motor-gap* "1.5"))
    ((= key "tracker_gap") (if *spd-s-tracker-gap* *spd-s-tracker-gap* "0.5"))
    ((= key "capacity_mode") (if *spd-cap-mode* *spd-cap-mode* "1"))
    ((= key "target_mw") (if *spd-s-target* *spd-s-target* "1.0"))
    ((= key "lat") (if *spd-s-lat* *spd-s-lat* "23.530"))
    ((= key "lon") (if *spd-s-lon* *spd-s-lon* "77.630"))
    ((= key "az") (if *spd-s-az* *spd-s-az* "0.0"))
    ((= key "set_off") (if *spd-s-setoff* *spd-s-setoff* "1.0"))
    ((= key "p_w") (if *spd-s-pw* *spd-s-pw* "1.13"))
    ((= key "p_h") (if *spd-s-ph* *spd-s-ph* "2.25"))
    ((= key "p_watt") (if *spd-s-watt* *spd-s-watt* "610"))
    ((= key "p_ori") (if *spd-ori-mode* *spd-ori-mode* "0"))
    ((= key "mod_in_row") (if *spd-s-row* *spd-s-row* "20"))
    ((= key "mod_in_stack") (if *spd-s-stack* *spd-s-stack* "2"))
    ((= key "tilt") (if *spd-s-tilt* *spd-s-tilt* "23.5"))
    ((= key "layout_mode") (if *spd-lay-mode* *spd-lay-mode* "0"))
    ((= key "pitch_mode") (if *spd-s-pmode* *spd-s-pmode* "0"))
    ((= key "manual_pitch") (if *spd-s-mpitch* *spd-s-mpitch* "7.0"))
    ((= key "m_gap_v") (if *spd-s-mgv* *spd-s-mgv* "0.020"))
    ((= key "m_gap_h") (if *spd-s-mgh* *spd-s-mgh* "0.020"))
    ((= key "t_gap_h") (if *spd-s-tgh* *spd-s-tgh* "0.200"))
    ((= key "mod_in_row_2") (if *spd-s-row2* *spd-s-row2* "0"))
    ((= key "mod_in_stack_2") (if *spd-s-stack2* *spd-s-stack2* "0"))
    ((= key "h_road_w") (if *spd-s-hroadw* *spd-s-hroadw* "0.0"))
    ((= key "h_road_f") (if *spd-s-hroadf* *spd-s-hroadf* "0"))
    ((= key "v_road_w") (if *spd-s-vroadw* *spd-s-vroadw* "0.0"))
    ((= key "v_road_f") (if *spd-s-vroadf* *spd-s-vroadf* "0"))
    ((= key "pile_dist_first") (if *spd-s-pile-df* *spd-s-pile-df* "500"))
    ((= key "pile_dist_btw") (if *spd-s-pile-db* *spd-s-pile-db* "1900"))
    ((= key "pile_num") (if *spd-s-pile-np* *spd-s-pile-np* "0"))
    ((= key "pile_radius") (if *spd-s-pile-rad* *spd-s-pile-rad* "150"))
    ((= key "pile_dist_first_2") (if *spd-s-pile-df2* *spd-s-pile-df2* "500"))
    ((= key "pile_dist_btw_2") (if *spd-s-pile-db2* *spd-s-pile-db2* "1900"))
    ((= key "pile_num_2") (if *spd-s-pile-np2* *spd-s-pile-np2* "0"))
    ((= key "energy_source") (if *spd-s-esrc* *spd-s-esrc* "0"))
    ((= key "manual_ghi") (if *spd-s-mghi* *spd-s-mghi* "5.0"))
    (T "")))

(defun spd-page-name (page)
  (nth page '("solarpro_pg_general" "solarpro_pg_module" "solarpro_pg_roads" "solarpro_pg_piling" "solarpro_pg_energy")))

(defun spd-store-page (page)
  (cond
    ((= page 0)
      (setq *spd-s-mount-type* (get_tile "mount_type")
            *spd-cap-mode* (get_tile "capacity_mode")
            *spd-s-target* (get_tile "target_mw")
            *spd-s-lat*    (get_tile "lat")
            *spd-s-lon*    (get_tile "lon")
            *spd-s-az*     (get_tile "az")
            *spd-s-setoff* (get_tile "set_off")))
    ((= page 1)
      (setq *spd-s-gcr*         (get_tile "gcr")
            *spd-s-tracker-len* (get_tile "tracker_len")
            *spd-s-motor-gap*   (get_tile "motor_gap")
            *spd-s-tracker-gap* (get_tile "tracker_gap")
            *spd-s-pw*      (get_tile "p_w")
            *spd-s-ph*      (get_tile "p_h")
            *spd-s-watt*    (get_tile "p_watt")
            *spd-ori-mode*  (get_tile "p_ori")
            *spd-s-row*     (get_tile "mod_in_row")
            *spd-s-stack*   (get_tile "mod_in_stack")
            *spd-s-tilt*    (get_tile "tilt")
            *spd-lay-mode*  (get_tile "layout_mode")
            *spd-s-pmode*   (get_tile "pitch_mode")
            *spd-s-mpitch*  (get_tile "manual_pitch")
            *spd-s-mgv*     (get_tile "m_gap_v")
            *spd-s-mgh*     (get_tile "m_gap_h")
            *spd-s-tgh*     (get_tile "t_gap_h")
            *spd-s-row2*    (get_tile "mod_in_row_2")
            *spd-s-stack2*  (get_tile "mod_in_stack_2")))
    ((= page 2)
      (setq *spd-s-hroadw* (get_tile "h_road_w")
            *spd-s-hroadf* (get_tile "h_road_f")
            *spd-s-vroadw* (get_tile "v_road_w")
            *spd-s-vroadf* (get_tile "v_road_f")))
    ((= page 3)
      (setq *spd-s-pile-df*  (get_tile "pile_dist_first")
            *spd-s-pile-db*  (get_tile "pile_dist_btw")
            *spd-s-pile-np*  (get_tile "pile_num")
            *spd-s-pile-rad* (get_tile "pile_radius")
            *spd-s-pile-df2* (get_tile "pile_dist_first_2")
            *spd-s-pile-db2* (get_tile "pile_dist_btw_2")
            *spd-s-pile-np2* (get_tile "pile_num_2")))
    ((= page 4)
      (setq *spd-s-esrc* (get_tile "energy_source")
            *spd-s-mghi* (get_tile "manual_ghi")))))

(defun spd-commit-dialog-values ()
  (setq *spd-run* T
        *spd-mount_type*    (nth (atoi (spd-field-default "mount_type")) '("Fixed Tilt" "Single Axis Tracker" "Dual Axis Tracker"))
        *spd-gcr*           (atof (spd-field-default "gcr"))
        *spd-tracker_len*   (atof (spd-field-default "tracker_len"))
        *spd-motor_gap*     (atof (spd-field-default "motor_gap"))
        *spd-tracker_gap*   (atof (spd-field-default "tracker_gap"))
        *spd-capacity_mode* (nth (atoi (spd-field-default "capacity_mode")) '("TargetMWp" "Maximum"))
        *spd-target_mw*     (atof (spd-field-default "target_mw"))
        *spd-p_w*           (atof (spd-field-default "p_w"))
        *spd-p_h*           (atof (spd-field-default "p_h"))
        *spd-p_watt*        (atof (spd-field-default "p_watt"))
        *spd-lat*           (atof (spd-field-default "lat"))
        *spd-lon*           (atof (spd-field-default "lon"))
        *spd-az*            (atof (spd-field-default "az"))
        *spd-set_off*       (atof (spd-field-default "set_off"))
        *spd-p_ori*         (nth (atoi (spd-field-default "p_ori")) '("Portrait" "Landscape"))
        *spd-mod_in_row*    (atoi (spd-field-default "mod_in_row"))
        *spd-mod_in_stack*  (atoi (spd-field-default "mod_in_stack"))
        *spd-tilt*          (atof (spd-field-default "tilt"))
        *spd-m_gap_v*       (atof (spd-field-default "m_gap_v"))
        *spd-m_gap_h*       (atof (spd-field-default "m_gap_h"))
        *spd-t_gap_h*       (atof (spd-field-default "t_gap_h"))
        *spd-layout_mode*   (nth (atoi (spd-field-default "layout_mode")) '("Aligned" "Unaligned"))
        *spd-pitch_mode*    (nth (atoi (spd-field-default "pitch_mode")) '("Auto" "Manual"))
        *spd-manual_pitch*  (atof (spd-field-default "manual_pitch"))
        *spd-mod_in_row_2*   (atoi (spd-field-default "mod_in_row_2"))
        *spd-mod_in_stack_2* (atoi (spd-field-default "mod_in_stack_2"))
        *spd-h_road_width*  (atof (spd-field-default "h_road_w"))
        *spd-h_road_freq*   (atoi (spd-field-default "h_road_f"))
        *spd-v_road_width*  (atof (spd-field-default "v_road_w"))
        *spd-v_road_freq*   (atoi (spd-field-default "v_road_f"))
        *spd-energy_source* (nth (atoi (spd-field-default "energy_source")) '("Latitude Default" "Manual GHI" "PVGIS API" "NASA POWER API"))
        *spd-manual_ghi*    (atof (spd-field-default "manual_ghi"))))

(defun spd-calc-piling (is_secondary / pw row mgh mgv df db tw rec_np ori ph k_df k_db k_num is_trk mount_type)
  (if is_secondary
    (setq row (atoi (spd-field-default "mod_in_row_2"))
          k_df "pile_dist_first_2" k_db "pile_dist_btw_2" k_num "pile_num_2")
    (setq row (atoi (spd-field-default "mod_in_row"))
          k_df "pile_dist_first"   k_db "pile_dist_btw"   k_num "pile_num"))
  (setq pw  (atof (spd-field-default "p_w"))
        ph  (atof (spd-field-default "p_h"))
        ori (spd-field-default "p_ori")
        mgh (atof (spd-field-default "m_gap_h"))
        mgv (atof (spd-field-default "m_gap_v"))
        df  (/ (atof (spd-get-val k_df "500")) 1000.0)
        db  (/ (atof (spd-get-val k_db "1900")) 1000.0)
        mount_type (spd-field-default "mount_type")
        is_trk (if (or (= mount_type "1") (= mount_type "2")) T nil))

  (if is_trk
    (if (or (= ori "0") (= ori ""))
        (setq tw (+ (* ph row) (* mgv (max 0 (- row 1)))))
        (setq tw (+ (* pw row) (* mgv (max 0 (- row 1))))))
    (if (or (= ori "0") (= ori ""))
        (setq tw (+ (* pw row) (* mgh (max 0 (- row 1)))))
        (setq tw (+ (* ph row) (* mgh (max 0 (- row 1)))))))
        
  (if (and (> tw 0) (> db 0.01))
    (progn
      (setq rec_np (max 2 (1+ (fix (/ (max 0.1 (- tw (* 2.0 df))) db)))))
      (set_tile k_num (itoa rec_np))
      (if is_secondary
        (setq *spd-s-pile-np2* (itoa rec_np))
        (setq *spd-s-pile-np* (itoa rec_np)))
      (spd-draw-diagram))
    (set_tile "pile_status" "Check table/pile values.")))

(defun spd-toggle-pitch (/ mode)
  (setq mode (get_tile "pitch_mode"))
  (if (= mode "1") (mode_tile "manual_pitch" 0) (mode_tile "manual_pitch" 1)))

(defun spd-mount-changed (val / is_tracker)
  (setq is_tracker (if (or (= val "1") (= val "2")) 1 0))
  (mode_tile "gcr" (- 1 is_tracker))
  (mode_tile "tracker_len" (- 1 is_tracker))
  (mode_tile "motor_gap" (- 1 is_tracker))
  (mode_tile "tilt" is_tracker)
  (mode_tile "pitch_mode" 0)
  (mode_tile "m_gap_v" is_tracker)
  (mode_tile "az" (- 1 is_tracker))
  (spd-toggle-pitch)
  (if (= is_tracker 1) (set_tile "az" "90.0")))

(defun spd-init-nav (page)
  (action_tile "tab_general" (strcat "(spd-store-page " (itoa page) ")(setq *spd-nav-page* 0)(done_dialog 2)"))
  (action_tile "tab_module"  (strcat "(spd-store-page " (itoa page) ")(setq *spd-nav-page* 1)(done_dialog 2)"))
  (action_tile "tab_roads"   (strcat "(spd-store-page " (itoa page) ")(setq *spd-nav-page* 2)(done_dialog 2)"))
  (action_tile "tab_piling"  (strcat "(spd-store-page " (itoa page) ")(setq *spd-nav-page* 3)(done_dialog 2)"))
  (action_tile "tab_energy"  (strcat "(spd-store-page " (itoa page) ")(setq *spd-nav-page* 4)(done_dialog 2)"))
  (action_tile "prev" (strcat "(spd-store-page " (itoa page) ")(setq *spd-nav-page* " (itoa (max 0 (1- page))) ")(done_dialog 2)"))
  (action_tile "next" (strcat "(spd-store-page " (itoa page) ")(setq *spd-nav-page* " (itoa (min 4 (1+ page))) ")(done_dialog 2)"))
  (action_tile "accept" (strcat "(spd-store-page " (itoa page) ")(done_dialog 1)"))
  (action_tile "cancel" "(done_dialog 0)")
  (if (= page 0) (mode_tile "prev" 1))
  (if (= page 4) (mode_tile "next" 1))
  (cond
    ((= page 0) (mode_tile "tab_general" 1))
    ((= page 1) (mode_tile "tab_module" 1))
    ((= page 2) (mode_tile "tab_roads" 1))
    ((= page 3) (mode_tile "tab_piling" 1))
    ((= page 4) (mode_tile "tab_energy" 1))))

(defun spd-init-page (page)
  (spd-init-nav page)
  (cond
    ((= page 0)
      (start_list "mount_type") (add_list "Fixed Tilt") (add_list "Single Axis Tracker") (add_list "Dual Axis Tracker") (end_list)
      (set_tile "mount_type" (spd-field-default "mount_type"))
      (start_list "capacity_mode") (add_list "TargetMWp") (add_list "Maximum") (end_list)
      (set_tile "capacity_mode" (spd-field-default "capacity_mode"))
      (set_tile "target_mw" (spd-field-default "target_mw"))
      (set_tile "lat" (spd-field-default "lat"))
      (set_tile "lon" (spd-field-default "lon"))
      (set_tile "az" (spd-field-default "az"))
      (set_tile "set_off" (spd-field-default "set_off"))
      (action_tile "mount_type" "(spd-mount-changed $value)")
      (spd-mount-changed (spd-field-default "mount_type")))
    ((= page 1)
      (start_list "p_ori") (add_list "Portrait") (add_list "Landscape") (end_list)
      (start_list "layout_mode") (add_list "Aligned") (add_list "Unaligned") (end_list)
      (start_list "pitch_mode") (add_list "Auto") (add_list "Manual") (end_list)
      (spd-init-module-db-controls)
      (set_tile "p_w" (spd-field-default "p_w"))
      (set_tile "p_h" (spd-field-default "p_h"))
      (set_tile "p_watt" (spd-field-default "p_watt"))
      (set_tile "p_ori" (spd-field-default "p_ori"))
      (set_tile "mod_in_row" (spd-field-default "mod_in_row"))
      (set_tile "mod_in_stack" (spd-field-default "mod_in_stack"))
      (set_tile "tilt" (spd-field-default "tilt"))
      (set_tile "layout_mode" (spd-field-default "layout_mode"))
      (set_tile "pitch_mode" (spd-field-default "pitch_mode"))
      (set_tile "manual_pitch" (spd-field-default "manual_pitch"))
      (set_tile "m_gap_v" (spd-field-default "m_gap_v"))
      (set_tile "m_gap_h" (spd-field-default "m_gap_h"))
      (set_tile "t_gap_h" (spd-field-default "t_gap_h"))
      (set_tile "mod_in_row_2" (spd-field-default "mod_in_row_2"))
      (set_tile "mod_in_stack_2" (spd-field-default "mod_in_stack_2"))
      (action_tile "db_spd_mod_mfr" "(spd-module-mfr-changed $value)")
      (action_tile "db_spd_mod_model" "(spd-module-model-changed $value)")
      (action_tile "db_spd_use_module" "(spd-apply-selected-module)")
      (action_tile "db_spd_new_module" "(spd-store-page 1)(done_dialog 3)")
      (set_tile "gcr" (spd-field-default "gcr"))
      (set_tile "tracker_len" (spd-field-default "tracker_len"))
      (set_tile "motor_gap" (spd-field-default "motor_gap"))
      (set_tile "tracker_gap" (spd-field-default "tracker_gap"))
      (action_tile "pitch_mode" "(spd-toggle-pitch)")
      (spd-toggle-pitch)
      (spd-mount-changed (spd-field-default "mount_type")))
    ((= page 2)
      (set_tile "h_road_w" (spd-field-default "h_road_w"))
      (set_tile "h_road_f" (spd-field-default "h_road_f"))
      (set_tile "v_road_w" (spd-field-default "v_road_w"))
      (set_tile "v_road_f" (spd-field-default "v_road_f")))
    ((= page 3)
      (set_tile "pile_dist_first" (spd-field-default "pile_dist_first"))
      (set_tile "pile_dist_btw" (spd-field-default "pile_dist_btw"))
      (set_tile "pile_num" (spd-field-default "pile_num"))
      (set_tile "pile_radius" (spd-field-default "pile_radius"))
      (set_tile "pile_dist_first_2" (spd-field-default "pile_dist_first_2"))
      (set_tile "pile_dist_btw_2" (spd-field-default "pile_dist_btw_2"))
      (set_tile "pile_num_2" (spd-field-default "pile_num_2"))
      (action_tile "btn_calc_pile" "(spd-calc-piling nil)")
      (action_tile "btn_calc_pile_2" "(spd-calc-piling t)")
      (action_tile "pile_dist_first" "(spd-calc-piling nil)")
      (action_tile "pile_dist_btw" "(spd-calc-piling nil)")
      (action_tile "pile_dist_first_2" "(spd-calc-piling t)")
      (action_tile "pile_dist_btw_2" "(spd-calc-piling t)")
      (spd-draw-diagram))
    ((= page 4)
      (start_list "energy_source") (add_list "Latitude Default") (add_list "Manual GHI") (add_list "PVGIS API") (add_list "NASA POWER API") (end_list)
      (set_tile "energy_source" (spd-field-default "energy_source"))
      (set_tile "manual_ghi" (spd-field-default "manual_ghi"))
      (action_tile "energy_source" "(if (= $value \"0\") (mode_tile \"manual_ghi\" 1) (mode_tile \"manual_ghi\" 0))")
      (if (= (spd-field-default "energy_source") "0") (mode_tile "manual_ghi" 1) (mode_tile "manual_ghi" 0)))))

(defun spd-open-dialog (/ dcl-path dcl-id result page)
  (setq dcl-path (spd-find-dcl))
  (if (null dcl-path) (progn (alert "Failed to create DCL file.") (exit)))
  (setq dcl-id (load_dialog dcl-path))
  (if (or (null dcl-id) (< dcl-id 0)) (exit))
  (if (not *spd-nav-page*) (setq *spd-nav-page* 0))
  (setq result 2
        page *spd-nav-page*)
  (while (member result '(2 3))
    (if (not (new_dialog (spd-page-name page) dcl-id))
      (progn (unload_dialog dcl-id) (exit)))
    (spd-init-page page)
    (setq result (start_dialog))
    (cond
      ((= result 2)
       (setq page *spd-nav-page*))
      ((= result 3)
       (spdb-open-new-module-dialog)
       (setq page 1
             result 2
             *spd-nav-page* 1))))
  (if (= result 1) (spd-commit-dialog-values))
  (unload_dialog dcl-id)
  (if (and dcl-path (findfile dcl-path)) (vl-file-delete dcl-path))
  result)

(defun c:SolarProDialog () (if (= (spd-open-dialog) 1) (c:GenerateLayout)) (princ))
(princ "\nSolarPro Engine Loaded. Type SOLARPRO to start.")
(princ "\n--- SolarPro V4.5 (TAB STYLE DIALOG) Loaded ---")
(princ "\n  CLEARPILELABELS     - Clear coordinate labels")
(defun c:PILING () (c:PileLabels))
(princ)

;; Initialize global point style for piling markers on load
(setvar "PDMODE" 35)
(setvar "PDSIZE" 0.25)
(princ "\nPoint Style set (PDMODE=35, PDSIZE=0.25) for Piling Visibility.")
(princ)
















;; -----------------------------------------------------------------------
;; c:YLDCompare     Compare energy yield across up to 5 different tilts
;; -----------------------------------------------------------------------
(defun c:YLDCompare (/ ent vla_ent boundary_handle data_vals p_w p_h p_watt orig_tilt lat lon ghi energy_mode_raw energy_mode
                     mod_in_row mod_in_stack mod_in_row2 mod_in_stack2 p_ori actual_w actual_h m_gap_h m_gap_v
                     table_count1 table_count2 actual_table_count1 actual_table_count2 panel_count
                     table_block_name_full table_block_name_half ss idx ename blk_name ins_pt_blk
                     tilts t_input tilt_idx
                     results solar_alt_winter
                     headers row_energy row_annual row_monthly row_daily row_specific row_solar_alt rows
                     bmin min_pt max_pt ins_pt compare_handle)
  (vl-load-com)
  (setq ent (car (entsel "\nSelect Boundary Polyline to compare yields: ")))
  (if (and ent (= (cdr (assoc 0 (entget ent))) "LWPOLYLINE"))
      (progn
        (setq data_vals (GetSolarDataValues ent))
        (if (not data_vals)
            (princ "\nNo stored solar data found on selected boundary.")
            (progn
              ;; Extract XData
              (setq p_w    (nth 0 data_vals)
                    p_h    (nth 1 data_vals)
                    p_watt (nth 2 data_vals)
                    orig_tilt (nth 3 data_vals)
                    lat    (nth 4 data_vals)
                    lon    (nth 5 data_vals)
                    mod_in_row (fix (nth 7 data_vals))
                    mod_in_stack (fix (nth 8 data_vals))
                    p_ori  (if (= (fix (nth 9 data_vals)) 1) "Portrait" "Landscape")
                    m_gap_h (nth 10 data_vals)
                    m_gap_v (nth 11 data_vals)
                    mod_in_row2 (if (>= (length data_vals) 15) (fix (nth 14 data_vals)) (max 1 (/ mod_in_row 2)))
                    mod_in_stack2 (if (>= (length data_vals) 16) (fix (nth 15 data_vals)) mod_in_stack)
                    table_count1 (if (>= (length data_vals) 17) (fix (nth 16 data_vals)) 0)
                    table_count2 (if (>= (length data_vals) 18) (fix (nth 17 data_vals)) 0)
                    ghi    (if (>= (length data_vals) 19) (nth 18 data_vals) nil)
                    energy_mode_raw (if (>= (length data_vals) 20) (nth 19 data_vals) "Manual GHI")
                    boundary_handle (cdr (assoc 5 (entget ent))))

              (setq actual_w (if (= p_ori "Portrait") p_w p_h)
                    actual_h (if (= p_ori "Portrait") p_h p_w))

              ;; Normalize energy mode
              (setq energy_mode
                (cond
                  ((or (= energy_mode_raw "PVGIS_API") (= energy_mode_raw "PVGIS API") (= energy_mode_raw "Pvgis")) "PVGIS API")
                  ((or (= energy_mode_raw "NASA_POWER_API") (= energy_mode_raw "NASA POWER API") (= energy_mode_raw "Nasa")) "NASA POWER API")
                  ((or (= energy_mode_raw "Manual_GHI") (= energy_mode_raw "Manual GHI") (= energy_mode_raw "Manual")) "Manual GHI")
                  (T "Manual GHI")))

              (setq actual_panel_count 0)
              (setq actual_table_count 0)

              (setq *sp-outer-verts* (DiscretizePolyline ent))

              (if (setq ss (ssget "_X" '((0 . "INSERT"))))
                  (progn
                    (setq idx 0)
                    (while (< idx (sslength ss))
                      (setq ename    (ssname ss idx)
                            blk_name (cdr (assoc 2 (entget ename)))
                            ins_pt_blk (cdr (assoc 10 (entget ename))))
                      (if (and blk_name (wcmatch (strcase blk_name) "TABLE_*") (InsidePoly ins_pt_blk *sp-outer-verts*))
                          (progn
                            (setq actual_table_count (1+ actual_table_count))
                            (setq actual_panel_count (+ actual_panel_count (* mod_in_row mod_in_stack)))))
                      (setq idx (1+ idx)))))

              (setq panel_count actual_panel_count)
              (if (= panel_count 0)
                  (setq panel_count (* table_count1 mod_in_row mod_in_stack)))
              
              (if (or (null panel_count) (<= panel_count 0))
                  (princ "\nWarning: No placed modules found in layout. Yields will be calculated as 0."))

              (if (or (null ghi) (<= ghi 0))
                  (progn
                    (princ "\nWarning: GHI is zero or missing. Assuming default 5.0 for comparison.")
                    (setq ghi 5.0)))

              ;; Prompt for up to 5 tilt angles
              (setq tilts nil tilt_idx 1)
              (while (and (<= tilt_idx 5)
                          (setq t_input (getreal (strcat "\nEnter Tilt Angle " (itoa tilt_idx) " (Press Enter to finish): "))))
                (setq tilts (append tilts (list t_input)))
                (setq tilt_idx (1+ tilt_idx)))

              (if (not tilts)
                  (princ "\nNo tilt angles entered. Exiting.")
                  (progn
                    ;; Initialize row parameters
                    (setq headers (list "Parameters")
                          row_energy (list "Energy DataSource")
                          row_annual (list "Annual Yield (kWh)")
                          row_monthly (list "Monthly Yield (kWh)")
                          row_daily (list "Daily Yield (kWh)")
                          row_specific (list "Spec. Yield (kWh/kWp/day)")
                          row_solar_alt (list "Solar Altitude (deg)"))
                    
                    (setq solar_alt_winter (max 10.0 (- 90.0 (+ (abs lat) 23.44))))

                    ;; Process Yields for each specified tilt
                    (foreach t_val tilts
                      (setq headers (append headers (list (strcat (rtos t_val 2 1) " deg"))))
                      (setq results (CalculateSolarData panel_count p_watt lat t_val ghi))

                      (setq row_energy (append row_energy (list energy_mode)))
                      (setq row_annual (append row_annual (list (rtos (nth 1 results) 2 0))))
                      (setq row_monthly (append row_monthly (list (rtos (/ (nth 1 results) 12.0) 2 0))))
                      (setq row_daily (append row_daily (list (rtos (nth 2 results) 2 2))))
                      (setq row_specific (append row_specific (list (rtos (nth 3 results) 2 3))))
                      (setq row_solar_alt (append row_solar_alt (list (rtos solar_alt_winter 2 2))))
                    )

                    (setq rows (list row_energy row_annual row_monthly row_daily row_specific row_solar_alt))

                    ;; Get Insertion point relative to the layout boundary
                    (setq vla_ent (vlax-ename->vla-object ent))
                    (vla-getboundingbox vla_ent 'min_pt 'max_pt)
                    (setq bmin (vlax-safearray->list min_pt))
                    
                    ;; Automatically place table 4 times the width of the layout summary table (4 * 180 = 720)
                    (setq ins_pt (list (+ (car bmin) 720.0) (- (cadr bmin) 20.0) 0.0))

                    ;; Draw dynamic Yield Comparison table
                    (setq compare_handle (strcat boundary_handle "_YLDCOMPARE"))
                    (DeleteReportEntities compare_handle) ; Overwrite any old comparisons on this boundary
                    (DrawCompareTable ins_pt "YIELD COMPARISON" headers rows compare_handle)
                    (princ "\nYield comparison table generated successfully.")
                  )
              )
            )
        )
      )
      (princ "\nInvalid selection. Please select a boundary polyline with stored solar data.")
  )
  (princ)
)

;; -----------------------------------------------------------------------
;; DrawCompareTable - Draws dynamic tables up to 6 columns wide
;; -----------------------------------------------------------------------
(defun DrawCompareTable (base_pt title headers rows boundary_handle
                         / row_h text_h details_w data_w total_h y_bottom cur_y cur_x i row total_w)
  (setq row_h     10.0
        text_h    4.0
        details_w 76.0
        data_w    55.0
        total_w   (+ details_w (* (1- (length headers)) data_w))
        total_h   (* row_h (+ 1 (length rows)))
        y_bottom  (- (cadr base_pt) total_h))
  (EnsureReportTextStyle)
  (DrawReportMText (list (car base_pt) (+ (cadr base_pt) 8.0) 0.0) 120.0 title 5.0 13158701 boundary_handle)

  ;; Draw horizontal lines
  (DrawReportLine (list (car base_pt) (cadr base_pt) 0.0) (list (+ (car base_pt) total_w) (cadr base_pt) 0.0) boundary_handle)
  (DrawReportLine (list (car base_pt) y_bottom 0.0) (list (+ (car base_pt) total_w) y_bottom 0.0) boundary_handle)
  (setq cur_y (- (cadr base_pt) row_h))
  (while (>= cur_y y_bottom)
    (DrawReportLine (list (car base_pt) cur_y 0.0) (list (+ (car base_pt) total_w) cur_y 0.0) boundary_handle)
    (setq cur_y (- cur_y row_h)))

  ;; Draw vertical lines
  (setq cur_x (car base_pt))
  (DrawReportLine (list cur_x (cadr base_pt) 0.0) (list cur_x y_bottom 0.0) boundary_handle)
  (setq cur_x (+ cur_x details_w))
  (DrawReportLine (list cur_x (cadr base_pt) 0.0) (list cur_x y_bottom 0.0) boundary_handle)
  (setq i 1)
  (while (< i (length headers))
    (setq cur_x (+ cur_x data_w))
    (DrawReportLine (list cur_x (cadr base_pt) 0.0) (list cur_x y_bottom 0.0) boundary_handle)
    (setq i (1+ i)))

  ;; Draw headers
  (setq cur_y (cadr base_pt))
  (setq cur_x (car base_pt))
  (DrawReportMText (list (+ cur_x 2.0) (- cur_y 2.0) 0.0) (- details_w 4.0) (car headers) text_h 13158701 boundary_handle)
  (setq cur_x (+ cur_x details_w))
  (setq i 1)
  (while (< i (length headers))
    (DrawReportMText (list (+ cur_x 2.0) (- cur_y 2.0) 0.0) (- data_w 4.0) (nth i headers) text_h 13158701 boundary_handle)
    (setq cur_x (+ cur_x data_w))
    (setq i (1+ i)))

  ;; Draw rows
  (setq cur_y (- (cadr base_pt) row_h))
  (foreach row rows
    (setq cur_x (car base_pt))
    (DrawReportMText (list (+ cur_x 2.0) (- cur_y 2.0) 0.0) (- details_w 4.0) (car row) text_h 13158701 boundary_handle)
    (setq cur_x (+ cur_x details_w))
    (setq i 1)
    (while (< i (length row))
      (DrawReportMText (list (+ cur_x 2.0) (- cur_y 2.0) 0.0) (- data_w 4.0) (nth i row) text_h 13158701 boundary_handle)
      (setq cur_x (+ cur_x data_w))
      (setq i (1+ i)))
    (setq cur_y (- cur_y row_h)))
)

;;;------------------------------------------------------------
;;;------------------------------------------------------------
;;; SolarPro Command Launcher
;;;------------------------------------------------------------
(defun spl-find-dcl (/ f)
  (setq f (spd-get-dcl "SolarPro - Launcher.dcl"))
  (if f f (spd-get-dcl "SolarPro - Launcher.dcl")))

(defun spl-action (cmd)
  (setq *spl-command* cmd)
  (done_dialog 1))

(defun spl-bind-button (key cmd)
  (action_tile key (strcat "(spl-action \"" cmd "\")")))

(defun spl-run-command (cmd / res)
  (setq res
    (vl-catch-all-apply
      (function
        (lambda ()
          (cond
            ((= cmd "SolarPro") (c:SolarProDialog))
            ((= cmd "GenerateLayout") (c:GenerateLayout))
            ((= cmd "Refresh") (c:Refresh))
            ((= cmd "ObstructionHeight") (c:ObstructionHeight))
            ((= cmd "YLDCompare") (c:YLDCompare))
            ((= cmd "PileLabels") (c:PileLabels))
            ((= cmd "ClearPileLabels") (c:ClearPileLabels))
            ((= cmd "Shadow") (c:SHADOW))
            ((= cmd "BShadow") (c:BSHADOW))
            ((= cmd "ShadowCoords") (c:ShadowCoords))
            ((= cmd "ClearShadowCoords") (c:ClearShadowCoords))
            ((= cmd "InverterGrouping") (c:INVERTERGROUPINGDIALOG))
            ((= cmd "AutoString") (c:AUTOSTRING))
            ((= cmd "ClearStringing") (c:CLEARSTRINGING))
            ((= cmd "DCStringing") (c:DCSTRINGING))
            ((= cmd "ClearDCStringing") (c:CLEARDCSTRINGING))
            ((= cmd "DCCabling") (c:DCCABLING))
            ((= cmd "DCCablingAll") (c:DCCABLINGALL))
            ((= cmd "ClearDCCabling") (c:CLEARDCCABLING))
            ((= cmd "DCCableExport") (c:DCCABLEEXPORT))
            ((= cmd "DebugStrings") (c:DEBUGSTRINGS))
            ((= cmd "CreateSLD") (c:CREATESLD))
            ((= cmd "LAProtection") (c:LAPROTECTION))
            ((= cmd "SetACDB") (c:SETACDB))
            ((= cmd "ACCabling") (c:ACCABLING))
            ((= cmd "AutoEarthing") (c:AutoEarthing))
            ((= cmd "ClearEarthing") (c:ClearEarthing))
            ((= cmd "TrenchLayout") (c:TRENCHLAYOUT))
            ((= cmd "TrenchExport") (c:TRENCHEXPORT))
            ((= cmd "View3D") (c:VIEW3D))
            ((= cmd "View2D") (c:VIEW2D))
            ((= cmd "PVCExport") (c:SPVCEXPORT))
            (T (alert (strcat "Unknown SolarPro launcher command: " cmd))))))))
  (if (vl-catch-all-error-p res)
    (princ (strcat "\nSolarPro launcher command cancelled or failed: "
                   (vl-catch-all-error-message res))))
  (princ))

(defun spl-open-dialog (/ dcl-path dcl-id result)
  (setq dcl-path (spl-find-dcl))
  (if (null dcl-path)
    (progn
      (alert "Failed to create SolarPro launcher DCL.")
      0)
    (progn
      (setq dcl-id (load_dialog dcl-path))
      (if (or (null dcl-id) (minusp dcl-id))
        (progn
          (alert "Failed to load SolarPro launcher DCL.")
          0)
        (progn
          (if (not (new_dialog "solarpro_launcher" dcl-id))
            (progn
              (unload_dialog dcl-id)
              (alert "Failed to open SolarPro launcher.")
              0)
            (progn
              (setq *spl-command* nil)
              (spl-bind-button "cmd_solarpro" "SolarPro")
              (spl-bind-button "cmd_generate" "GenerateLayout")
              (spl-bind-button "cmd_refresh" "Refresh")
              (spl-bind-button "cmd_obstruction" "ObstructionHeight")
              (spl-bind-button "cmd_yldcompare" "YLDCompare")
              (spl-bind-button "cmd_piling" "PileLabels")
              (spl-bind-button "cmd_clearpiling" "ClearPileLabels")
              (spl-bind-button "cmd_shadow" "Shadow")
              (spl-bind-button "cmd_bshadow" "BShadow")
              (spl-bind-button "cmd_shadowcoords" "ShadowCoords")
              (spl-bind-button "cmd_clearshadowcoords" "ClearShadowCoords")
              (spl-bind-button "cmd_invgroup" "InverterGrouping")
              (spl-bind-button "cmd_autostring" "AutoString")
              (spl-bind-button "cmd_clearstring" "ClearStringing")
              (spl-bind-button "cmd_dcstring" "DCStringing")
              (spl-bind-button "cmd_cleardcstring" "ClearDCStringing")
              (spl-bind-button "cmd_dccabling" "DCCabling")
              (spl-bind-button "cmd_dccablingall" "DCCablingAll")
              (spl-bind-button "cmd_cleardccabling" "ClearDCCabling")
              (spl-bind-button "cmd_dccableexport" "DCCableExport")
              (spl-bind-button "cmd_debugstrings" "DebugStrings")
              (spl-bind-button "cmd_sld" "CreateSLD")
              (spl-bind-button "cmd_laprotection" "LAProtection")
              (spl-bind-button "cmd_setacdb" "SetACDB")
              (spl-bind-button "cmd_accabling" "ACCabling")
              (spl-bind-button "cmd_autoearthing" "AutoEarthing")
              (spl-bind-button "cmd_clearearthing" "ClearEarthing")
              (spl-bind-button "cmd_trench" "TrenchLayout")
              (spl-bind-button "cmd_trenchexport" "TrenchExport")
               (spl-bind-button "cmd_view3d" "View3D")
               (spl-bind-button "cmd_view2d" "View2D")
               (spl-bind-button "cmd_pvcexport" "PVCExport")
               (action_tile "close" "(done_dialog 0)")
              (setq result (start_dialog))
              (unload_dialog dcl-id)
              (if (and dcl-path (findfile dcl-path)) (vl-file-delete dcl-path))
              result)))))))

(defun c:SOLARPROLAUNCHER (/ result keep-going)
  (vl-load-com)
  (setq keep-going T)
  (while keep-going
    (setq result (spl-open-dialog))
    (if (and (= result 1) *spl-command*)
      (progn
        (spl-run-command *spl-command*)
        (setq *spl-command* nil))
      (setq keep-going nil)))
  (princ))

(defun c:SOLARPROPALETTE () (c:SOLARPROLAUNCHER))
(defun c:SPL () (c:SOLARPROLAUNCHER))

;;;------------------------------------------------------------
;;; 3D View Commands
;;;------------------------------------------------------------
(defun c:VIEW3D (/ old-cmdecho)
  (vl-load-com)
  (setq old-cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_.VPOINT" (list -1 -1 1))
  (vl-catch-all-apply '(lambda () (command "_.VSCURRENT" "_R")))
  (command "_.ZOOM" "_E")
  (setvar "CMDECHO" old-cmdecho)
  (princ "\n3D view active. Type VIEW2D to return to plan view.")
  (princ))

(defun c:VIEW2D (/ old-cmdecho)
  (vl-load-com)
  (setq old-cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_.PLAN" "")
  (command "_.VSCURRENT" "_2")
  (command "_.ZOOM" "_E")
  (setvar "CMDECHO" old-cmdecho)
  (princ "\nReturned to 2D plan view.")
  (princ))

(princ "\nSolarPro 7.0 loaded successfully.")
(princ "\n===================================================")
(princ "\n  Type SOLARPROLAUNCHER or SPL to open the button launcher.")
(load "D:/SolarPro AcadLISP/Under Development/SolarPro 10062026/SolarPro-PVExport.lsp")
(princ)

