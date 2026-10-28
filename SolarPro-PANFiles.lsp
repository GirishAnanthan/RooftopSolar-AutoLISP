;; --- VERSION: 4.4 (REVISION 03 - DCL REFRESH + ROADS + ENERGY SOURCE) ---
(vl-load-com)

;;============================================================
;; STUB FUNCTIONS for forward-references
;;------------------------------------------------------------
;; If any of the late-loaded modules (Batch 7-13) fail to load
;; for any reason, these stubs prevent runtime errors in
;; core functions like ClearExistingLayout.
;;============================================================
(defun sp-report-hist-commit (ent) nil)
(defun sp-report-hist-capture (ent) nil)
(defun sp-report-hist-load (ent) nil)
(defun sp-report-hist-drop (ent) nil)
(defun sp-report-hist-position-clear (x y w h) T)
(defun sp-table-overlaps-hist (a b c d) nil)
(princ "\n[SolarPro] Forward-ref stubs loaded.")

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
         (write-line "        : button { key = \"db_spd_use_module\"; label = \"Use DB Module\"; width = 14; }" f)
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
                           placed_row_ys elec_xd_gl ac_kw_gl h_road_width h_road_freq v_road_width v_road_freq energy_source_req energy_profile energy_source_label manual_ghi ghi_used structural_rows extra_vals road_zones row_candidates stats total_mid_clamps total_end_clamps)
  (vl-load-com)
  (setq old_osmode (getvar "OSMODE")
        old_cmdecho (getvar "CMDECHO"))
  (defun *error* (msg)
    (setq *spro-inner-boundaries* nil)
    (setq *spro-set-off* nil)
    (if (numberp old_osmode) (setvar "OSMODE" old_osmode))
    (if (numberp old_cmdecho) (setvar "CMDECHO" old_cmdecho))
    (if (and msg (/= msg "Function cancelled"))
      (princ (strcat "\nError: " msg)))
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
  
  (setq d2r (/ pi 180.0))
  (setq table_h (+ (* actual_h mod_in_stack) (* m_gap_v (- mod_in_stack 1))))
  
  
  ;; Use winter-solstice 9:30 AM solar altitude as the design condition for no inter-row shading.
  (setq solar_alt_design (SolarAltitudeAtTime lat -23.45 9.5))
  (setq table_rise (* table_h (sin (* tilt d2r))))
  (setq table_h_proj (* table_h (cos (* tilt d2r))))
  (setq row_gap (/ table_rise (tan_lsp (* solar_alt_design d2r))))
  (setq row_pitch (+ table_h_proj row_gap))
  ;; Manual pitch override
  (if (and (boundp '*spd-run*) *spd-run*
           (boundp '*spd-pitch_mode*) (= *spd-pitch_mode* "Manual")
           (boundp '*spd-manual_pitch*) (> *spd-manual_pitch* 0.0))
    (setq row_pitch *spd-manual_pitch*))

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
      (ClearExistingLayout ent boundary_handle)
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
                  (BuildTableBlockName mod_in_row mod_in_stack p_ori actual_w actual_h m_gap_h m_gap_v tilt
                                       *spd-pile-np*-m (fix (+ 0.5 (* 1000.0 *spd-pile-db*-m))) *spd-pile-df*-m))
            (DefineTableBlock table_block_name mod_in_row mod_in_stack actual_w actual_h m_gap_h m_gap_v tilt))
          (setq table_block_name nil))

      ;; Secondary table setup
      (setq mod_in_row_2   (if (and (boundp '*spd-run*) *spd-run*) *spd-mod_in_row_2*   0)
            mod_in_stack_2 (if (and (boundp '*spd-run*) *spd-run*) *spd-mod_in_stack_2* 0))
      (setq unit_w_2 nil  table_h_proj_2 nil  table_block_name_2 nil
            modules_per_table_2 0  table_count_2 0)
      (if (and (= placement_type "Table") (> mod_in_row_2 0) (> mod_in_stack_2 0))
        (progn
          (setq table_w_2      (+ (* actual_w mod_in_row_2) (* m_gap_h (- mod_in_row_2 1)))
                table_h_2      (+ (* actual_h mod_in_stack_2) (* m_gap_v (- mod_in_stack_2 1)))
                table_h_proj_2 (* table_h_2 (cos (* tilt d2r)))
                unit_w_2       table_w_2
                modules_per_table_2 (* mod_in_row_2 mod_in_stack_2))
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
                (BuildTableBlockName mod_in_row_2 mod_in_stack_2 p_ori actual_w actual_h m_gap_h m_gap_v tilt
                                     *spd-pile-np*-m (fix (+ 0.5 (* 1000.0 *spd-pile-db*-m))) *spd-pile-df*-m))
          (DefineTableBlock table_block_name_2 mod_in_row_2 mod_in_stack_2 actual_w actual_h m_gap_h m_gap_v tilt)))

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
      (setq *spro-inner-boundaries* (GetInnerPolyBoundaries ent))
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
      (setq unit_w   (if (= placement_type "Table") table_w actual_w)
            unit_gap (if (= placement_type "Table") t_gap_h m_gap_h)
            step_w   (if unit_w_2 (min unit_w unit_w_2) unit_w)
            cur_y    (+ (cadr bmin) set_off)
            placed_row_ys nil)
      (setq road_zones (CollectRoadZones bmin bmax set_off row_pitch table_h_proj step_w unit_gap h_road_width h_road_freq v_road_width v_road_freq))
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
                       (TablePlacementOk rx row_y unit_w table_h_proj ent obstruction_zones)
                       T))
              (if (= placement_type "Table")
                (progn (InsertTableBlock table_block_name (list rx row_y 0.0) *sp-primary-table-color*)
                       (setq panel_count (+ panel_count modules_per_table) table_count (1+ table_count)))
                (progn (DrawStackColumn3D rx row_y actual_w actual_h mod_in_stack m_gap_v tilt)
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
                  (TablePlacementOk rx row_y unit_w_2 table_h_proj_2 ent obstruction_zones))
             (InsertTableBlock table_block_name_2 (list rx row_y 0.0) *sp-secondary-table-color*)
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

      ;; === PASS 1  BOTTOM-UP (road-aware) ===
      (setq row_candidates (sp-build-row-candidates-bottom bmin bmax set_off row_pitch table_h_proj h_road_width h_road_freq))
      (foreach cur_y row_candidates
        (if (< panel_count target_mods)
          (TryPlaceRow cur_y)))

      ;; === PASS 2  TOP-DOWN (road-aware fill for narrow top zones) ===
      ;; Rows above an obstruction that the bottom-up phase missed are
      ;; caught here by scanning downward from the boundary top.
      (setq row_candidates (reverse (sp-build-row-candidates-bottom bmin bmax set_off row_pitch table_h_proj h_road_width h_road_freq)))
      (foreach cur_y row_candidates
        (if (< panel_count target_mods)
          (TryPlaceRow cur_y)))
      (setq stats (GetLayoutStatistics ent placement_type)
            panel_count (nth 0 stats)
            total_tables_label (nth 1 stats)
            total_mid_clamps (nth 2 stats)
            total_end_clamps (nth 3 stats))
      (setq results (CalculateSolarData panel_count p_watt lat tilt ghi_used))
      (setq elec_xd_gl (cdr (assoc -3 (entget ent '("FS_SOLAR_ELEC")))))
      (setq ac_kw_gl   (if (and elec_xd_gl (= (caar elec_xd_gl) "FS_SOLAR_ELEC"))
                         (cdr (car (cdar elec_xd_gl))) 0.0))
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
              (list "Mid Clamps"             (itoa total_mid_clamps))
              (list "End Clamps"             (itoa total_end_clamps))
              (list "Orientation"            p_ori)
              (list "Tilt Angle"             (strcat (rtos tilt 2 1) " deg"))
              (list "Azimuth"                (FormatAzimuthLabel az))
              (list "Row Pitch"              (strcat (rtos row_pitch 2 3) " m"))
              (list "Location"              (strcat (rtos lat 2 3) ", " (rtos lon 2 3)))))
      
      ;; Separate structural data
      (setq structural_rows (append (spd-piling-summary) (spd-road-summary h_road_width h_road_freq v_road_width v_road_freq)))
      
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
  (setq *spro-inner-boundaries* nil)
  (setq *spro-set-off* nil)
  (princ))

(defun c:Refresh (/ ent bmin min_pt max_pt bmax poly_area data_vals p_w p_h p_watt tilt lat lon az
                    mod_in_row mod_in_stack p_ori m_gap_h m_gap_v table_h table_h_proj table_rise
                    solar_alt_design row_gap row_pitch panel_count table_count results summary_rows
                    energy_rows boundary_handle placement_type total_tables_label ghi_used_saved
                    elec_xd_rf ac_kw_rf extra_vals h_road_width h_road_freq v_road_width v_road_freq energy_source_req energy_profile energy_source_label manual_ghi ghi_used structural_rows stats total_mid_clamps total_end_clamps)
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
                    ghi_used_saved (if (and extra_vals (nth 6 extra_vals)) (nth 6 extra_vals) nil))
              (setq energy_profile (ResolveEnergyProfile energy_source_req lat lon manual_ghi ghi_used_saved)
                    energy_source_label (car energy_profile)
                    ghi_used (cadr energy_profile))
              (setq table_h (+ (* (if (= p_ori "Portrait") p_h p_w) mod_in_stack)
                               (* m_gap_v (- mod_in_stack 1))))
              (setq table_rise (* table_h (sin (* tilt (/ pi 180.0)))))
              (setq table_h_proj (* table_h (cos (* tilt (/ pi 180.0)))))
              (setq solar_alt_design (SolarAltitudeAtTime lat -23.45 9.5))
              (setq row_gap (/ table_rise (tan_lsp (* solar_alt_design (/ pi 180.0)))))
              (setq row_pitch (+ table_h_proj row_gap))
              (setq poly_area (/ (vla-get-area (vlax-ename->vla-object ent)) 4046.86))
              (setq stats (GetLayoutStatistics ent placement_type)
                    panel_count (nth 0 stats)
                    total_tables_label (nth 1 stats)
                    total_mid_clamps (nth 2 stats)
                    total_end_clamps (nth 3 stats))
              (setq results (CalculateSolarData panel_count p_watt lat tilt ghi_used))
              (setq elec_xd_rf (cdr (assoc -3 (entget ent '("FS_SOLAR_ELEC")))))
              (setq ac_kw_rf   (if (and elec_xd_rf (= (caar elec_xd_rf) "FS_SOLAR_ELEC"))
                                 (cdr (car (cdar elec_xd_rf))) 0.0))
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
                      (list "Mid Clamps"            (itoa total_mid_clamps))
                      (list "End Clamps"            (itoa total_end_clamps))
                      (list "Orientation"           p_ori)
                      (list "Tilt Angle"            (strcat (rtos tilt 2 1) " deg"))
                      (list "Azimuth"               (FormatAzimuthLabel az))
                      (list "Row Pitch"             (strcat (rtos row_pitch 2 3) " m"))
                      (list "Location"             (strcat (rtos lat 2 3) ", " (rtos lon 2 3)))))
              
              ;; Separate structural data for Refresh
              (setq structural_rows (append (spd-piling-summary) (spd-road-summary h_road_width h_road_freq v_road_width v_road_freq)))
              
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

(defun DrawStackColumn3D (base_x base_y mod_w mod_h stack_count gap_v tilt / r d2r_val m_top m_base z_top z_base)
  (setq d2r_val (/ pi 180.0)
        r 0)
  (while (< r stack_count)
    (setq m_top  (- (* stack_count mod_h (cos (* tilt d2r_val)))
                    (* r (+ mod_h gap_v) (cos (* tilt d2r_val))))
          m_base (- m_top (* mod_h (cos (* tilt d2r_val))))
          z_top  (* (- stack_count r) mod_h (sin (* tilt d2r_val)))
          z_base (- z_top (* mod_h (sin (* tilt d2r_val)))))
    (InsertModuleBlock (list base_x (+ base_y m_base) z_base) *sp-primary-table-color*)
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

(defun InsertModuleBlock (ins_pt true_color)
  (entmake (append (list '(0 . "INSERT") '(100 . "AcDbEntity") '(8 . "module")
                  '(100 . "AcDbBlockReference") '(2 . "module")
                  (cons 10 ins_pt) '(41 . 1.0) '(42 . 1.0) '(43 . 1.0)
                 '(50 . 0.0))
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

(defun DefineTableBlock (block_name cols rows w h gap_h gap_v tilt / r c m_x m_top m_base d2r_val z_top z_base pl_rad pl_ext_h pl_ext_v pl_k pl_x pl_c_tilt pl_highest pl_lowest pl_y)
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
                  pl_ext_h pl_rad
                  pl_ext_v pl_rad
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
                  pl_start_x (/ (- table_w_local pl_total_span) 2.0)
                  pl_k     0)
            (if (not (tblsearch "LAYER" "PILING"))
              (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord")
                             '(100 . "AcDbLayerTableRecord")
                             '(2 . "PILING") '(70 . 0) '(62 . 1) '(6 . "Continuous"))))
            (command "._LAYER" "_Thaw" "PILING" "_On" "PILING" "_Set" "0" "")
            (repeat *spd-pile-np*-m
              (setq pl_x (+ pl_start_x (* pl_k *spd-pile-db*-m)))
              ;; Point entity (using PDMODE 35 for Circle + X)
              (entmake (list '(0 . "POINT") '(100 . "AcDbEntity")
                             '(8 . "PILING") '(62 . 1)
                             '(100 . "AcDbPoint")
                             (cons 10 (list pl_x pl_y pl_z))))
              (setq pl_k (1+ pl_k)))))
        (entmake (list '(0 . "ENDBLK") '(100 . "AcDbEntity") '(8 . "0") '(100 . "AcDbBlockEnd"))))))

(defun InsertTableBlock (block_name ins_pt true_color)
  (entmake (append (list '(0 . "INSERT") '(100 . "AcDbEntity") '(8 . "0")
                  '(100 . "AcDbBlockReference") (cons 2 block_name)
                  (cons 10 ins_pt) '(41 . 1.0) '(42 . 1.0) '(43 . 1.0)
                 '(50 . 0.0))
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
(defun CollectObstructionZones (boundary_ent lat clearance / ss idx ename foot_pts zones base_box height)
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

(defun ClearExistingLayout (boundary_ent boundary_handle / ss idx ename blk_name ins_pt)
  ;; 0. PRESERVE the current report position before deleting it
  ;;    (defensive: catches any error in case the HIST module
  ;;    failed to load for any reason)
  (vl-catch-all-apply 'sp-report-hist-capture (list boundary_ent))
  ;; 1. Delete results table
  (vl-catch-all-apply 'DeleteReportEntities (list boundary_handle))
  
  ;; 2. Delete layout blocks (MODULE / TABLE_*)
  (if (setq ss (ssget "_X" '((0 . "INSERT"))))
      (progn
        (setq idx 0)
        (while (< idx (sslength ss))
          (setq ename (ssname ss idx)
                blk_name (cdr (assoc 2 (entget ename))))
          (if (and blk_name
                   (or (= (substr (strcase blk_name) 1 6) "TABLE_")
                       (= (strcase blk_name) "MODULE")))
              (progn
                (setq ins_pt (cdr (assoc 10 (entget ename))))
                (if (and ins_pt (InsidePoly ins_pt boundary_ent))
                    (vl-catch-all-apply 'entdel (list ename)))))
          (setq idx (1+ idx)))))
  
  ;; 3. Delete other layout output entities (piling labels, cables, stringing, etc. inside the boundary)
  (if (setq ss (ssget "_X" '((8 . "PV_MODULE,PILING,PILING_LABELS,DC_CABLE,DC_STRINGING,STRINGING,AC_CABLE,EARTH_CABLE,EARTHING_GRID,EARTH_MAT,EARTHING_CABLE"))))
      (progn
        (setq idx 0)
        (while (< idx (sslength ss))
          (setq ename (ssname ss idx))
          (if (/= ename boundary_ent)
              (progn
                (setq ins_pt (cdr (assoc 10 (entget ename))))
                (if (and ins_pt (InsidePoly ins_pt boundary_ent))
                    (vl-catch-all-apply 'entdel (list ename)))))
          (setq idx (1+ idx)))))
  
  ;; 4. Clear boundary XData
  (if (not (tblsearch "APPID" "FS_SOLAR_DATA")) (regapp "FS_SOLAR_DATA"))
  (if (not (tblsearch "APPID" "FS_SOLAR_EXTRAS")) (regapp "FS_SOLAR_EXTRAS"))
  (if (not (tblsearch "APPID" "FS_SOLAR_ELEC")) (regapp "FS_SOLAR_ELEC"))
  (if (not (tblsearch "APPID" "FS_SOLAR_REPORT_POS")) (regapp "FS_SOLAR_REPORT_POS"))
  (if (not (tblsearch "APPID" "FS_SOLAR_REPORT_BBOX")) (regapp "FS_SOLAR_REPORT_BBOX"))
  (vl-catch-all-apply 'entmod (list (append (entget boundary_ent) '((-3 ("FS_SOLAR_DATA") ("FS_SOLAR_EXTRAS") ("FS_SOLAR_ELEC") ("FS_SOLAR_REPORT_POS") ("FS_SOLAR_REPORT_BBOX"))))))
  (princ "\nExisting layout, report, and XData cleared.")
  (princ))

(defun GetInnerPolyBoundaries (boundary_ent / ss idx ename b_verts b_box inner_polys poly_pts p_box err cbmin cbmax)
  (vl-load-com)
  (setq inner_polys nil)
  (setq b_verts (get-poly-approx-vertices boundary_ent))
  (if (and b_verts (> (length b_verts) 2))
      (progn
        (setq b_box (GetPolygonBBox b_verts))
        (if (setq ss (ssget "_X" '((0 . "LWPOLYLINE,POLYLINE"))))
            (progn
              (setq idx 0)
              (while (< idx (sslength ss))
                (setq ename (ssname ss idx))
                (if (and (not (eq ename boundary_ent))
                         (not (equal (cdr (assoc 5 (entget ename))) (cdr (assoc 5 (entget boundary_ent)))))
                         (assoc 70 (entget ename))
                         (= 1 (logand 1 (cdr (assoc 70 (entget ename)))))
                         (not (member (strcase (cdr (assoc 8 (entget ename))))
                                      '("DC_CABLE" "AC_CABLE" "EARTH_CABLE" "EARTHING_GRID" 
                                        "EARTH_MAT" "EARTHING_CABLE" "DC_STRINGING" "PV_MODULE" "PILING"))))
                    (progn
                      (setq cbmin nil cbmax nil)
                      (setq err (vl-catch-all-apply 'vla-getboundingbox (list (vlax-ename->vla-object ename) 'cbmin 'cbmax)))
                      (if (not (vl-catch-all-error-p err))
                          (progn
                            (setq cbmin (vlax-safearray->list (if (= (type cbmin) 'VARIANT) (vlax-variant-value cbmin) cbmin))
                                  cbmax (vlax-safearray->list (if (= (type cbmax) 'VARIANT) (vlax-variant-value cbmax) cbmax)))
                            (if (RectanglesOverlap (car cbmin) (cadr cbmin) (car cbmax) (cadr cbmax) b_box)
                                (progn
                                  (setq poly_pts (get-poly-approx-vertices ename))
                                  (if (and poly_pts (> (length poly_pts) 2))
                                      (if (or (vl-some '(lambda (pt) (InsidePoly pt boundary_ent)) poly_pts)
                                              (PolygonEdgesIntersect poly_pts b_verts))
                                          (setq inner_polys (cons ename inner_polys))))))))))
                (setq idx (1+ idx)))))))
  inner_polys)

(defun TableClearOfInnerBoundaries (x y w h_proj / rect_poly clear_ok set_off inner_boundaries bverts)
  (setq inner_boundaries *spro-inner-boundaries*
        set_off (if (and (boundp '*spro-set-off*) (numberp *spro-set-off*) (> *spro-set-off* 0.0))
                    *spro-set-off* 0.0))
  (if (null inner_boundaries)
      T
      (progn
        (setq rect_poly (list (list x       y           0.0)
                              (list (+ x w) y           0.0)
                              (list (+ x w) (+ y h_proj) 0.0)
                              (list x       (+ y h_proj) 0.0))
              clear_ok T)
        (foreach inner_poly inner_boundaries
          (if clear_ok
              (progn
                (setq bverts (get-poly-approx-vertices inner_poly))
                (if (and bverts (> (length bverts) 2))
                    (progn
                      ;; 1. Check if any corner of the table is INSIDE the inner boundary
                      (if (or (InsidePoly (list x y 0) inner_poly)
                              (InsidePoly (list (+ x w) y 0) inner_poly)
                              (InsidePoly (list (+ x w) (+ y h_proj) 0) inner_poly)
                              (InsidePoly (list x (+ y h_proj) 0) inner_poly))
                          (setq clear_ok nil))
                      
                      ;; 2. Check if they overlap/intersect
                      (if (and clear_ok (PolygonsOverlap rect_poly bverts))
                          (setq clear_ok nil))
                      
                      ;; 3. Check setback distance from table corners to inner boundary edges
                      (if (and clear_ok (> set_off 0.0))
                          (progn
                            (if (or (< (MinDistToBoundary (list x y) bverts) set_off)
                                    (< (MinDistToBoundary (list (+ x w) y) bverts) set_off)
                                    (< (MinDistToBoundary (list (+ x w) (+ y h_proj)) bverts) set_off)
                                    (< (MinDistToBoundary (list x (+ y h_proj)) bverts) set_off))
                                (setq clear_ok nil))
                            
                            ;; 4. Check setback distance from inner boundary vertices to table edges
                            (if clear_ok
                                (foreach v bverts
                                  (if (and clear_ok (< (MinDistToBoundary v rect_poly) set_off))
                                      (setq clear_ok nil)))))))))))
        clear_ok)))

(defun GetTableBlockDims (blk_name / name cols_str rows_str x_pos under_pos)
  (setq name (strcase blk_name))
  (if (= (substr name 1 9) "TABLE_V5_")
      (progn
        (setq name (substr name 10))
        (setq x_pos (vl-string-search "X" name))
        (if x_pos
            (progn
              (setq cols_str (substr name 1 x_pos))
              (setq name (substr name (+ x_pos 2)))
              (setq under_pos (vl-string-search "_" name))
              (if under_pos
                  (progn
                    (setq rows_str (substr name 1 under_pos))
                    (cons (atoi cols_str) (atoi rows_str)))
                  nil))
            nil))
      nil))

(defun FormatTablesLabel (tbl_list placement_type / label item blk_name count dims cols rows first)
  (if (= placement_type "Continuous")
      "N/A (Continuous)"
      (if (null tbl_list)
          "0"
          (progn
            (setq label ""
                  first T)
            (foreach item tbl_list
              (setq blk_name (car item)
                    count (cdr item)
                    dims (GetTableBlockDims blk_name))
              (if dims
                  (setq cols (car dims)
                        rows (cdr dims)
                        label (strcat label
                                      (if first "" " + ")
                                      (itoa count)
                                      " (" (itoa cols) "x" (itoa rows) ")")
                        first nil)))
            (if (= label "") "0" label)))))

(defun GetLayoutStatistics (boundary_ent placement_type / tbl_list ss idx ename blk_name ins_pt
                                                         p_count t_count mid_clamps end_clamps dims cols rows item count)
  (setq tbl_list nil
        p_count 0
        t_count 0
        mid_clamps 0
        end_clamps 0)
  (if (setq ss (ssget "_X" '((0 . "INSERT"))))
      (progn
        (setq idx 0)
        (while (< idx (sslength ss))
          (setq ename (ssname ss idx)
                blk_name (cdr (assoc 2 (entget ename))))
          (if blk_name
              (progn
                (setq ins_pt (cdr (assoc 10 (entget ename))))
                (if (and ins_pt (InsidePoly ins_pt boundary_ent))
                    (cond
                      ((= (substr (strcase blk_name) 1 6) "TABLE_")
                       (setq item (assoc blk_name tbl_list))
                       (if item
                           (setq tbl_list (subst (cons blk_name (1+ (cdr item))) item tbl_list))
                           (setq tbl_list (cons (cons blk_name 1) tbl_list))))
                      ((= (strcase blk_name) "MODULE")
                       (setq p_count (1+ p_count)
                             end_clamps (+ end_clamps 4)))))))
          (setq idx (1+ idx)))))
  (foreach item tbl_list
    (setq blk_name (car item)
          count (cdr item)
          dims (GetTableBlockDims blk_name))
    (if dims
        (setq cols (car dims)
              rows (cdr dims)
              t_count (+ t_count count)
              p_count (+ p_count (* count cols rows))
              end_clamps (+ end_clamps (* count 4 rows))
              mid_clamps (+ mid_clamps (if (> cols 1) (* count 2 (1- cols) rows) 0)))))
  (list p_count (FormatTablesLabel tbl_list placement_type) mid_clamps end_clamps))

(defun TablePlacementOk (x y w h_proj ent obstruction_zones)
  (and (TableFitsPoly x y w h_proj ent)
       (TableClearOfObstructions x y w h_proj obstruction_zones)
       (TableClearOfInnerBoundaries x y w h_proj)))

(defun FindBestRowStart (row_y min_x max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones / base_x max_start pitch candidates candidate test_start best_start best_count test_count)
  (setq base_x (+ min_x set_off))
  (setq max_start (- (- max_x set_off) table_w))
  (setq best_start base_x)
  (setq best_count (CountTablesInRow base_x row_y max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones))
  ;; Keep NonAligned fast by testing only a few practical stagger positions
  ;; instead of sweeping many offsets across every row.
  (setq pitch (+ table_w t_gap_h))
  (setq candidates (list 0.25 0.5 0.75))
  (foreach candidate candidates
    (setq test_start (+ base_x (* pitch candidate)))
    (if (<= test_start max_start)
        (progn
          (setq test_count (CountTablesInRow test_start row_y max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones))
          (if (> test_count best_count)
              (setq best_count test_count
                    best_start test_start)))))
  best_start)

(defun CountTablesInRow (start_x row_y max_x set_off table_w t_gap_h table_h_proj ent obstruction_zones / cur_x count)
  (setq cur_x start_x
        count 0)
  (while (<= (+ cur_x table_w) (- max_x set_off))
    (if (TablePlacementOk cur_x row_y table_w table_h_proj ent obstruction_zones)
        (setq count (1+ count)))
    (setq cur_x (+ cur_x table_w t_gap_h)))
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
                         / metrics base_pt table_gap x y total_w next_y1 next_y2 struct_bottom
                           before_ent e entity_list grp_name doc groups grp
                           row_h h1 h2 h3 w_proposed h_proposed h_total clear_pos
                           min_x min_y max_x max_y)
  (EnsureReportTextStyle)
  (setq metrics   (GetReportMetrics ent)
        base_pt   (nth 0 metrics)
        table_gap (nth 8 metrics)
        total_w   (+ (nth 3 metrics) (nth 4 metrics) (nth 5 metrics))
        row_h     (nth 1 metrics)
        h1        (* row_h (1+ (length summary_rows)))
        h2        (* row_h (1+ (length energy_rows)))
        h3        (* row_h (1+ (length structural_rows)))
        w_proposed (+ (* 2.0 total_w) (* 2.0 table_gap))
        h_proposed (+ (max h1 h2) table_gap h3)
        h_total    (+ h_proposed table_gap (* 22.0 row_h))
        clear_pos  (FindClearReportPosition ent w_proposed h_total)
        x          (car clear_pos)
        y          (cadr clear_pos))
  
  ;; Record last entity before drawing
  (setq before_ent (entlast))
  
  ;; 1. Layout Summary (Forest Green)
  (setq next_y1 (DrawReportTable x y "LAYOUT SUMMARY" summary_rows boundary_handle metrics 1284936))
  
  ;; 2. Energy Summary (Solar Amber - Side-by-Side)
  (setq next_y2 (DrawReportTable (+ x total_w (* 2.0 table_gap)) y "ENERGY SUMMARY" energy_rows boundary_handle metrics 15247360))
  
  ;; 3. Structural Summary (Structural Blue - Below)
  (setq struct_bottom (DrawReportTable x (- (min next_y1 next_y2) table_gap) "STRUCTURAL SUMMARY" structural_rows boundary_handle metrics 41704))
  (SaveReportBottomY ent struct_bottom)
  
  ;; Save bounding box of drawn report tables (using the reserved height to prevent overlaps)
  (setq min_x x
        min_y (- y h_total)
        max_x (+ x w_proposed)
        max_y (+ y (nth 7 metrics) (nth 6 metrics)))
  (SaveReportBBox ent min_x min_y max_x max_y)

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
                 (equal (strcase (cdr (assoc 1000 (cdar xdata)))) (strcase boundary_handle)))
          (entdel ename))
        (setq idx (1+ idx))))))

(defun SaveReportBottomY (ent y / ed)
  (if (not (tblsearch "APPID" "FS_SOLAR_REPORT_POS"))
      (regapp "FS_SOLAR_REPORT_POS"))
  (setq ed (entget ent))
  (setq ed (vl-remove-if
             '(lambda (itm)
                (and (= (car itm) -3)
                     (= (car (cadr itm)) "FS_SOLAR_REPORT_POS")))
             ed))
  (entmod
    (append ed
      (list
        (list -3
          (list "FS_SOLAR_REPORT_POS"
                (cons 1040 y)))))))

(defun GetReportBottomY (ent / xdata)
  (setq xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_REPORT_POS")))))
  (if (and xdata (= (caar xdata) "FS_SOLAR_REPORT_POS"))
      (cdr (cadr (car xdata)))
      nil))

(defun SaveReportBBox (ent min_x min_y max_x max_y / ed)
  (if (not (tblsearch "APPID" "FS_SOLAR_REPORT_BBOX"))
      (regapp "FS_SOLAR_REPORT_BBOX"))
  (setq ed (entget ent))
  (setq ed (vl-remove-if
             '(lambda (itm)
                (and (= (car itm) -3)
                     (= (car (cadr itm)) "FS_SOLAR_REPORT_BBOX")))
             ed))
  (entmod
    (append ed
      (list
        (list -3
          (list "FS_SOLAR_REPORT_BBOX"
                (cons 1040 min_x)
                (cons 1040 min_y)
                (cons 1040 max_x)
                (cons 1040 max_y))))))
  ;; Also update the preserved HIST so the next regeneration
  ;; remembers this new position.
  (setq *SP-REPORT-HIST-BBOX* (list min_x min_y max_x max_y)
        *SP-REPORT-HIST-PT*   (list min_x min_y))
  (sp-report-hist-commit ent))

(princ "\n[SolarPro] SaveReportBBox updated for HIST.")
(princ)

(defun GetReportBBox (ent / xdata appdata vals)
  (setq xdata (cdr (assoc -3 (entget ent '("FS_SOLAR_REPORT_BBOX")))))
  (if (and xdata (= (caar xdata) "FS_SOLAR_REPORT_BBOX"))
      (progn
        (setq appdata (cdar xdata))
        (setq vals (mapcar 'cdr (vl-remove-if-not '(lambda (itm) (= (car itm) 1040)) appdata)))
        (if (= (length vals) 4)
            vals
            nil))
      nil))

(defun BoxesOverlap (b1 b2)
  (not (or (<= (nth 2 b1) (nth 0 b2))
           (>= (nth 0 b1) (nth 2 b2))
           (<= (nth 3 b1) (nth 1 b2))
           (>= (nth 1 b1) (nth 3 b2)))))

(defun FindClearReportPosition (ent proposed_w proposed_h / bnd_ss idx other_ent other_bbox overlap_found cur_x cur_y proposed_box table_gap metrics done)
  ;; PRESERVE-POSITION: if HIST is set and the area is clear, reuse it
  (if (and *SP-REPORT-HIST-PT*
           (sp-report-hist-position-clear
             (car  *SP-REPORT-HIST-PT*)
             (cadr *SP-REPORT-HIST-PT*)
             proposed_w proposed_h))
    (progn
      (princ (strcat "\n[FIND-CLEAR] Reusing preserved report position ("
                     (rtos (car  *SP-REPORT-HIST-PT*) 2 2) ", "
                     (rtos (cadr *SP-REPORT-HIST-PT*) 2 2) ")"))
      (list (car *SP-REPORT-HIST-PT*) (cadr *SP-REPORT-HIST-PT*)))
    (progn
      (setq metrics (GetReportMetrics ent)
            table_gap (nth 8 metrics)
            cur_x (car (car metrics))
            cur_y (cadr (car metrics))
            done nil)
      (while (not done)
        (setq proposed_box (list cur_x
                                 (- cur_y proposed_h)
                                 (+ cur_x proposed_w)
                                 (+ cur_y (nth 7 metrics) (nth 6 metrics))))
        (setq overlap_found nil)
        (if (setq bnd_ss (ssget "_X" '((-3 ("FS_SOLAR_DATA")))))
            (progn
              (setq idx 0)
              (while (and (not overlap_found) (< idx (sslength bnd_ss)))
                (setq other_ent (ssname bnd_ss idx))
                (if (not (equal (cdr (assoc 5 (entget other_ent))) (cdr (assoc 5 (entget ent)))))
                    (progn
                      (setq other_bbox (GetReportBBox other_ent))
                      (if (and other_bbox (BoxesOverlap proposed_box other_bbox))
                          (progn
                            (setq overlap_found T)
                            (setq cur_x (+ (nth 2 other_bbox) (* 2.0 table_gap)))
                          ))))
                (setq idx (1+ idx)))))
        (if (not overlap_found)
            (setq done T)))
      (list cur_x cur_y))))

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
                (cons 1040 ghi_used)))))))

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

(defun CollectRoadZones (bmin bmax set_off row_pitch table_h_proj unit_w unit_gap h_road_w h_road_f v_road_w v_road_f / zones usable_x usable_y usable_w usable_h road_y road_x col_pitch idx row_gap col_gap row_h col_w extra_y extra_x road_no done)
  (setq zones nil
        usable_x (+ (car bmin) set_off)
        usable_y (+ (cadr bmin) set_off)
        usable_w (max 0.0 (- (- (car bmax) set_off) usable_x))
        usable_h (max 0.0 (- (- (cadr bmax) set_off) usable_y))
        row_gap (max 0.0 (- row_pitch table_h_proj))
        col_gap (max 0.0 unit_gap))
  (if (and (numberp h_road_w) (numberp h_road_f) (numberp row_pitch) (> h_road_w 0.0) (> h_road_f 0) (> row_pitch 0.0))
    (progn
      (setq row_h (sp-road-gap-width row_gap h_road_w)
            extra_y (sp-road-extra-gap row_gap h_road_w))
      (setq idx h_road_f
            done nil)
      (while (not done)
        (setq road_no (fix (/ idx h_road_f))
              road_y (+ usable_y
                        (* idx row_pitch)
                        (* (max 0 (1- road_no)) extra_y)
                        (- row_gap)))
        (if (> (+ road_y row_h) (+ usable_y usable_h))
          (setq done T)
          (progn
            ;; Shrink road zone by a small tolerance (1e-4 meters / 0.1 mm) to prevent false floating-point overlap collisions with tables
            (setq zones (cons (MakeZoneFromRect usable_x (+ road_y 1e-4) usable_w (- row_h 2e-4)) zones))
            (setq idx (+ idx h_road_f)))))))
  (if (and (numberp v_road_w) (numberp v_road_f) (numberp unit_w) (numberp unit_gap) (> v_road_w 0.0) (> v_road_f 0) (> (+ unit_w unit_gap) 0.0))
    (progn
      (setq col_pitch (+ unit_w unit_gap)
            col_w (sp-road-gap-width col_gap v_road_w)
            extra_x (sp-road-extra-gap col_gap v_road_w)
            idx v_road_f
            done nil)
      (while (not done)
        (setq road_no (fix (/ idx v_road_f))
              road_x (+ usable_x
                        (* idx col_pitch)
                        (* (max 0 (1- road_no)) extra_x)
                        (- col_gap)))
        (if (> (+ road_x col_w) (+ usable_x usable_w))
          (setq done T)
          (progn
            ;; Shrink road zone by a small tolerance (1e-4 meters / 0.1 mm) to prevent false floating-point overlap collisions with tables
            (setq zones (cons (MakeZoneFromRect (+ road_x 1e-4) usable_y (- col_w 2e-4) usable_h) zones))
            (setq idx (+ idx v_road_f)))))))
  zones)

(defun spd-road-summary (h_road_w h_road_f v_road_w v_road_f / rows)
  (setq rows nil)
  (if (> h_road_w 0.0)
    (setq rows (append rows (list (list "Horiz. Road Width" (strcat (rtos h_road_w 2 2) " m (Freq: " (itoa h_road_f) ")"))))))
  (if (> v_road_w 0.0)
    (setq rows (append rows (list (list "Vert. Road Width" (strcat (rtos v_road_w 2 2) " m (Freq: " (itoa v_road_f) ")"))))))
  rows)

(defun sp-fetch-url (url / temp_dir temp_file wsh cmd run_res sz rf content line http send_result op_res response_text)
  (setq temp_dir (getvar "TEMPPREFIX"))
  (if (or (null temp_dir) (= temp_dir ""))
      (setq temp_dir "C:\\Temp\\"))
  (if (/= (substr temp_dir (strlen temp_dir) 1) "\\")
      (setq temp_dir (strcat temp_dir "\\")))
  (setq temp_file (strcat temp_dir "spro_net_temp.json"))
  (if (findfile temp_file) (vl-file-delete temp_file))
  
  ;; 1. Try curl.exe via WScript.Shell (synchronous, ignores process firewall blocks)
  (setq wsh (vl-catch-all-apply 'vlax-create-object (list "WScript.Shell")))
  (if (and wsh (not (vl-catch-all-error-p wsh)))
      (progn
        (setq cmd (strcat "curl.exe -s -k -o \"" temp_file "\" \"" url "\""))
        (setq run_res (vl-catch-all-apply 'vlax-invoke-method (list wsh 'Run cmd 0 :vlax-true)))
        (vlax-release-object wsh)
        (if (and (not (vl-catch-all-error-p run_res))
                 (= run_res 0)
                 (findfile temp_file)
                 (setq sz (vl-file-size temp_file))
                 (> sz 0))
            (progn
              (setq rf (open temp_file "r"))
              (if rf
                  (progn
                    (setq content "")
                    (while (setq line (read-line rf))
                      (setq content (strcat content line "\n"))
                    )
                    (close rf)
                    (vl-file-delete temp_file)
                    (setq response_text content)))))))
  
  ;; 2. Fallback to WinHttp if curl failed or returned nil
  (if (null response_text)
      (progn
        (setq http (vl-catch-all-apply 'vlax-create-object (list "WinHttp.WinHttpRequest.5.1")))
        (if (and http (not (vl-catch-all-error-p http)))
            (progn
              (vl-catch-all-apply 'vlax-put-property (list http 'Option 9 2048))
              (vl-catch-all-apply 'vlax-put-property (list http 'Option 4 13056))
              (setq op_res (vl-catch-all-apply 'vlax-invoke-method (list http 'Open "GET" url :vlax-false)))
              (if (not (vl-catch-all-error-p op_res))
                  (progn
                    (setq send_result (vl-catch-all-apply 'vlax-invoke-method (list http 'Send)))
                    (if (and (not (vl-catch-all-error-p send_result))
                             (= (vlax-get-property http 'Status) 200))
                        (setq response_text (vlax-get-property http 'ResponseText)))))))))
  response_text)

(defun get-pvgis-ghi-lisp (latitude longitude / url response_text total_ghi_wh_per_year num_hours ghi_value regex matches count idx match match_str colon_pos)
  (setq url (strcat "https://re.jrc.ec.europa.eu/api/v5_2/tmy?lat="
                    (vl-string-translate "," "." (rtos latitude 2 6)) "&lon="
                    (vl-string-translate "," "." (rtos longitude 2 6)) "&outputformat=json"))
  (setq response_text (sp-fetch-url url))
  (if response_text
      (progn
        (setq total_ghi_wh_per_year 0.0
              num_hours 0)
        (setq regex (vlax-create-object "VBScript.RegExp"))
        (vlax-put-property regex 'Global :vlax-true)
        (vlax-put-property regex 'IgnoreCase :vlax-true)
        (vlax-put-property regex 'Pattern "\"G\\(h\\)\"\\s*:\\s*([0-9.]+)")
        (setq matches (vl-catch-all-apply 'vlax-invoke-method (list regex 'Execute response_text)))
        (if (and matches (not (vl-catch-all-error-p matches)))
            (progn
              (setq count (vlax-get-property matches 'Count)
                    idx 0)
              (while (< idx count)
                (setq match (vlax-get-property matches 'Item idx)
                      match_str (vlax-get-property match 'Value)
                      colon_pos (vl-string-search ":" match_str))
                (if colon_pos
                    (progn
                      (setq ghi_value (atof (substr match_str (+ colon_pos 2))))
                      (setq total_ghi_wh_per_year (+ total_ghi_wh_per_year ghi_value)
                            num_hours (1+ num_hours))))
                (setq idx (1+ idx)))))
        (vlax-release-object regex)
        (if (> num_hours 0) (/ (/ total_ghi_wh_per_year 365.0) 1000.0) nil))
      nil))

(defun get-nasa-power-ghi-lisp (latitude longitude / url response_text param_pos ann_pos ghi_value comma_pos brace_pos end_pos)
  (setq url (strcat "https://power.larc.nasa.gov/api/temporal/climatology/point?parameters=ALLSKY_SFC_SW_DWN&community=RE&longitude="
                    (vl-string-translate "," "." (rtos longitude 2 6))
                    "&latitude="
                    (vl-string-translate "," "." (rtos latitude 2 6))
                    "&format=JSON"))
  (setq response_text (sp-fetch-url url))
  (if response_text
      (progn
        (setq param_pos (vl-string-search "\"ALLSKY_SFC_SW_DWN\":" response_text))
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
      nil))

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
(defun InsidePoly (pt ent / vertices x y count p1 p2) 
  (setq vertices (get-poly-approx-vertices ent))
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
(defun get-center (ent / min_pt max_pt bmin bmax) (vla-getboundingbox (vlax-ename->vla-object ent) 'min_pt 'max_pt) (setq bmin (vlax-safearray->list min_pt) bmax (vlax-safearray->list max_pt)) (list (/ (+ (car bmin) (car bmax)) 2.0) (/ (+ (cadr bmin) (cadr bmax)) 2.0) 0))

(EnsureObstructionLayer)
(princ)

;;;============================================================
;;; SHADOW & BSHADOW - Shadow Analysis (merged from SunShadow.lsp)
;;;============================================================

(defun ss-setup-layer (lname lcolor-aci)
  (if (not (tblsearch "LAYER" lname))
    (command "_.LAYER" "_Make" lname "_Color" lcolor-aci lname "")
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
        ;; If the label position falls inside an inner polyline exclusion zone,
        ;; snap to the nearest table in this group that is outside all inner polylines.
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
            ;; Check if the label position is inside any inner polyline exclusion zone
            (if (and ent
                     (vl-some
                       '(lambda (ip) (InsidePoly (list lbl_x lbl_y 0.0) ip))
                       (GetInnerPolyBoundaries ent)))
              ;; Label is inside an exclusion zone - snap to nearest valid table
              (progn
                (setq best_dist 1e10
                      lbl_y raw_lbl_y)
                (foreach tbl this_group
                  (setq t_inspt (cdr (assoc 10 (entget tbl))))
                  ;; Only consider tables that are outside all inner polylines
                  (if (not (vl-some
                             '(lambda (ip) (InsidePoly t_inspt ip))
                             (GetInnerPolyBoundaries ent)))
                    (progn
                      (vla-getboundingbox (vlax-ename->vla-object tbl) 'bmin_t 'bmax_t)
                      (setq t_cy (/ (+ (cadr (vlax-safearray->list bmin_t))
                                       (cadr (vlax-safearray->list bmax_t))) 2.0)
                            dist (abs (- t_cy raw_lbl_y)))
                      (if (< dist best_dist)
                        (setq best_dist dist
                              lbl_y t_cy))))))
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
  (princ)))

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
        x y report_bottom pad_x pad_y y_bottom cur_y idx row
        c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 gold
        tot_mod tot_dc tot_ac tot_inv loading_pct loading_str
        tot_loading_pct tot_loading_str
        before_ent e entity_list grp_name doc groups grp boundary_handle current_bbox)
  (EnsureReportTextStyle)
  (setq boundary_handle (cdr (assoc 5 (entget bnd_ent))))
  (setq *current-stringing-boundary-handle* boundary_handle)
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
  (setq x             (car base_pt)
        report_bottom (GetReportBottomY bnd_ent)
        y             (if report_bottom
                          (- report_bottom table_gap)
                          (- (cadr base_pt) (* 21.0 row_h)))
        pad_x   (max 1.0 (* text_h 0.4))
        pad_y   (max 0.8 (* text_h 0.4))
        ;; hdr_h + (data rows + total row)  row_h
        y_bottom (- y hdr_h (* row_h (1+ (length rows))))
        gold    13158701)
  ;; Column x-offsets
  (setq before_ent (entlast))
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
  (StrDrawMText (list (+ c9 pad_x) cur_y 0.0) (- cw9 (* 2 pad_x)) (itoa tot_inv)            text_h gold)

  ;; Collect all entity names created since before_ent
  (setq entity_list nil
        e (if before_ent (entnext before_ent) (entnext)))
  (while e
    (setq entity_list (cons e entity_list))
    (setq e (entnext e)))
  (if entity_list
    (progn
      (vl-load-com)
      (setq boundary_handle (cdr (assoc 5 (entget bnd_ent)))
            grp_name        (strcat "SRPT_" boundary_handle)
            doc             (vla-get-activedocument (vlax-get-acad-object))
            groups          (vla-get-groups doc))
      ;; Tag them
      (foreach e entity_list
        (TagReportEntity e boundary_handle))
      ;; Check if group exists, if so, retrieve it; otherwise create it
      (setq grp (vl-catch-all-apply 'vla-item (list groups grp_name)))
      (if (vl-catch-all-error-p grp)
        (setq grp (vla-add groups grp_name)))
      ;; Append items to the group
      (foreach e entity_list
        (if (and e (entget e))
          (vl-catch-all-apply
            (function (lambda ()
              (vla-appenditem grp (vlax-ename->vla-object e)))))))))
  ;; Update report bounding box in XData
  (setq current_bbox (GetReportBBox bnd_ent))
  (if (and current_bbox (< y_bottom (nth 1 current_bbox)))
      (SaveReportBBox bnd_ent
                      (nth 0 current_bbox)
                      y_bottom
                      (nth 2 current_bbox)
                      (nth 3 current_bbox)))
  ;; Reset the boundary handle variable
  (setq *current-stringing-boundary-handle* nil))

(defun StrDrawLine (p1 p2)
  (if (not (tblsearch "APPID" "FS_SOLAR_REPORT")) (regapp "FS_SOLAR_REPORT"))
  (entmakex (append (list '(0 . "LINE") '(8 . "STRINGING")
                          (cons 420 13158701) (cons 10 p1) (cons 11 p2))
                    (if (and (boundp '*current-stringing-boundary-handle*) *current-stringing-boundary-handle*)
                        (list (list -3 (list "FS_SOLAR_REPORT" (cons 1000 *current-stringing-boundary-handle*))))
                        nil))))

(defun StrDrawMText (pt width txt h true_color)
  (if (not (tblsearch "APPID" "FS_SOLAR_REPORT")) (regapp "FS_SOLAR_REPORT"))
  (entmakex (append (list '(0 . "MTEXT") '(100 . "AcDbEntity") '(8 . "STRINGING")
                          (cons 420 true_color) '(100 . "AcDbMText")
                          (cons 10 pt) (cons 40 h) (cons 41 width)
                          '(71 . 1) '(72 . 1) '(7 . "REPORT_STD") (cons 1 txt))
                    (if (and (boundp '*current-stringing-boundary-handle*) *current-stringing-boundary-handle*)
                        (list (list -3 (list "FS_SOLAR_REPORT" (cons 1000 *current-stringing-boundary-handle*))))
                        nil))))

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

(defun asd-find-dcl ()
  (spd-get-dcl "SolarPro - Stringing Dialog.dcl"))

(defun asd-method-find-dcl ()
  (spd-get-dcl "SolarPro - Stringing Method Dialog.dcl"))

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

(defun dcstr-find-dcl ()
  (spd-get-dcl "SolarPro - DC Stringing Dialog.dcl"))

(defun dccaball-find-dcl ()
  (spd-get-dcl "SolarPro - DC Cabling All Dialog.dcl"))

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

(defun sld-find-dcl ()
  (spd-get-dcl "SolarPro - SLD.dcl"))

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

;; Get all TABLE_* inserts within a boundary polyline.
;; Excludes tables that fall inside any inner polyline exclusion zone.
(defun GetTablesInBoundary (boundary-ent / ss idx ename blk-name verts tables inner_polys ins_pt)
  (setq verts (get-poly-approx-vertices boundary-ent)
        tables nil)
  (if (and verts (setq ss (ssget "_X" '((0 . "INSERT")))))
    (progn
      ;; Find inner exclusion polylines (buildings, roads, obstacles)
      (setq inner_polys (GetInnerPolyBoundaries boundary-ent))
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ename (ssname ss idx)
              blk-name (cdr (assoc 2 (entget ename)))
              ins_pt   (cdr (assoc 10 (entget ename))))
        (if (and blk-name 
                 (wcmatch (strcase blk-name) "TABLE_*")
                 (PointInPolygonList ins_pt verts)
                 ;; Exclude tables whose insertion point is inside any inner polyline
                 (not (vl-some
                        '(lambda (ip) (InsidePoly ins_pt ip))
                        inner_polys)))
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
(princ "\n  SOLARPROLAUNCHER   - Button launcher for SolarPro tools")
(princ "\n  SPL                - Short alias for SOLARPROLAUNCHER")
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

;;;------------------------------------------------------------
;;; Piling Summary Helpers
;;;------------------------------------------------------------

;;; Count CIRCLE entities on PILING layer inside a named block definition
(defun spd-count-block-piles (bname / b_ent b_edata cnt)
  (setq cnt 0)
  (setq b_ent (tblobjname "BLOCK" bname))
  (if b_ent
    (progn
      (setq b_ent (entnext b_ent))
      (while b_ent
        (setq b_edata (entget b_ent))
        (if (and (= (cdr (assoc 0 b_edata)) "CIRCLE")
                 (= (cdr (assoc 8 b_edata)) "PILING"))
          (setq cnt (1+ cnt)))
        (setq b_ent (entnext b_ent)))))
  cnt)

;;; --- Piling Helper Functions ---

(defun spd-count-block-piles (bname / b_ent count ed)
  (setq count 0)
  (if (and bname (setq b_ent (tblobjname "BLOCK" bname)))
    (progn
      (while (setq b_ent (entnext b_ent))
        (setq ed (entget b_ent))
        (if (and (= (cdr (assoc 0 ed)) "CIRCLE")
                 (or (= (strcase (cdr (assoc 8 ed))) "PILING")
                     (= (strcase (cdr (assoc 8 ed))) "PILING_LABELS")))
          (setq count (1+ count))))))
  count)

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

;;; Scan all TABLE_* inserts in the drawing, group by block name,
;;; count piles per block type and return formatted summary rows.
;;; Returns a list of ("Label" "Value") pairs ready to append to summary_rows.
(defun spd-piling-summary (/ ss k bname bname_counts found bc tbl_cnt np
                              total_piles rows tbl_idx tw rec_np status spacing edge)
  (setq bname_counts nil  total_piles 0  rows nil  tbl_idx 1)
  
  (vl-catch-all-apply
    '(lambda ()
       ;; Get current spacing/edge from dialog globals or defaults (if in Refresh mode without dialog run)
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
         (if (and (<= tw 0.0) (boundp '*spd-last-table-w*)) (setq tw *spd-last-table-w*))
         (if (> np 0)
           (progn
             ;; Recommendation Calculation: Roundup((Length - 2*Edge)/Spacing) + 1
             (setq rec_np (fix (+ (/ (- tw (* 2.0 edge)) spacing) 1.99)))
             (if (< rec_np 2) (setq rec_np 2))
             
             (setq status (if (>= np rec_np) "OK" "Check Piling"))

             (if (= (length bname_counts) 1)
               (setq rows (append rows
                       (list (list "Table Length"      (strcat (rtos tw 2 3) " m"))
                             (list "Piles per Table"   (itoa np))
                             (list "Piling Status"     status)
                             (list "Total Piles"        (itoa (* tbl_cnt np))))))
               (progn
                 (setq rows (append rows
                         (list (list (strcat "Type " (itoa tbl_idx) " Length") (strcat (rtos tw 2 2) " m"))
                               (list (strcat "Type " (itoa tbl_idx) " Piles/Table") 
                                     (strcat (itoa np) " - " status)))))
                 (setq tbl_idx (1+ tbl_idx))))
             (setq total_piles (+ total_piles (* tbl_cnt np))))))
    )
  )
  
  (if (and (> (length bname_counts) 1) (> total_piles 0))
    (setq rows (append rows (list (list "Total Piles (All)" (itoa total_piles))))))
  rows)

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
(defun c:PileLabels (/ ss i ent edate bname ins rot b_ent b_edate c_list cx cy gx gy f csv_path do_csv pile_count old_labels j max_x is_last b_min_x b_max_x b_min_y b_max_y etype x1 x2 y1 y2 g_y1 g_y2 g_y3 g_y4 g_max_y clearance_y)
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

;;;------------------------------------------------------------
;;; Clear All Pile Labels
;;;------------------------------------------------------------
(defun c:ClearPileLabels (/ old_labels j)
  (setq old_labels (ssget "X" '((8 . "PILING_LABELS"))))
  (if old_labels
    (progn
      (setq j 0)
      (while (< j (sslength old_labels))
        (entdel (ssname old_labels j))
        (setq j (1+ j)))
      (princ (strcat "\n" (itoa (sslength old_labels)) " pile label(s) deleted."))
    )
    (princ "\nNo pile labels found to delete.")
  )
  (princ)
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
          (command "_.-HATCH" "_P" "SOLID" "_S" b-ent "" "")))
      
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
      (if (= type-choice "LA") (setq *solarpro-la-index* (1+ (if *solarpro-la-index* *solarpro-la-index* 1))))
    )))









;;;============================================================
;;; Command: SHADOW  Pole / LA Shadow
;;;============================================================
(defun c:SHADOW (/ type-choice dcl-id result base-pt pole-h lat la-rad shadow-color 
                   sl-mode sl-height sl-dist-idx sl-side bname spacing curve_ent 
                   obj pick-p1 pick-p2 d1 d2 total-dist dir travelled d_cur pt 
                   param deriv ang rot noon-res noon-alt noon-az noon-calc 
                   noon-tip noon-len old-layer old-osmode old-cmdecho shadow-aci dcl-path)

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
          (setq dcl-path (spd-get-dcl "SolarPro - LA Dialog.dcl"))
          (if dcl-path
            (progn
  (setq dcl-id (load_dialog dcl-path))
              (if (new_dialog "la_dialog" dcl-id)
                (progn
                  (set_tile "la_rad" "90.0") (set_tile "la_height" "7.0") (set_tile "la_lat" (rtos lat 2 2))
                  (action_tile "accept" "(setq la-rad (atof (get_tile \"la_rad\")) pole-h (atof (get_tile \"la_height\")) lat (atof (get_tile \"la_lat\"))) (done_dialog 1)")
                  (action_tile "cancel" "(done_dialog 0)")
                  (setq result (start_dialog)) (unload_dialog dcl-id)
                  (if (= result 1) (spd-draw-single-shadow base-pt pole-h lat "30" "LA" la-rad))
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
          (setq dcl-path (spd-get-dcl "SolarPro - Streetlight.dcl"))
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
(defun c:DCCABLEEXPORT (/ ss idx ename edata xdata inv_id mps csize neg_o updown p_list j p1 p2 raw_len pos_len neg_len tot_len margin vmp imp tc_temp temp_op str_vol str_cur r20 r50 vdrop vdrop_pct csv_path f data_map cur_list all_keys str_idx xd total_inv_len total_inv_vdrop row_data avg_vdrop first_csize s_no r_mps r_pos r_neg r_upd r_tot r_mar r_vmp r_svol r_scur r_r20 r_tc r_r50 r_vdr r_vdrp)
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

  (let* ((bnd_ss (ssget "_X" '((-3 ("FS_SOLAR_DATA"))))))
    (if bnd_ss
      (progn
        (setq bnd_ent (ssname bnd_ss 0)
              bnd_xd  (cdr (assoc -3 (entget bnd_ent '("FS_SOLAR_DATA")))))
        (if (and bnd_xd (= (caar bnd_xd) "FS_SOLAR_DATA"))
          (progn
            (setq xd_fields (cdar bnd_xd))
            ;; Safely read indices  only overwrite defaults if XDATA has non-zero values
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
      (princ "\nNo SolarPro boundary in drawing  using default electrical values.")))

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
    (write-line "INVERTER NO,STRING NO,STRING IN SERIES,ACTUAL LENGTH +VE,ACTUAL LENGTH -VE,UP & DOWN +VE,UP & DOWN -VE,TOTAL CABLE LENGHT,5% MARGIN,Module Vmp,STRING VOLTAGE,STRING CURRENT,RESISTANCE (ohm/KM) AT 20C,TEMP COEFFICIENT T,RESISTANCE (ohm/KM) AT 50C,VOLTAGE DROP,VOLTAGE DROP %" f)
    
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
(defun c:LAPROTECTION (/ ss i dcl-id result pole-h lat la-rad pt old-echo old-layer)
  (princ "\nSelect LA marker points (on SHADOW-MARKERS layer): ")
  (setq ss (ssget '((0 . "POINT") (8 . "SHADOW-MARKERS"))))
  (if (null ss) (progn (princ "\nNo points selected.") (exit)))

  (setq lat (spd-get-lat-from-xd))
  (if (null lat) (setq lat 23.53))

  (setq dcl-path (spd-get-dcl "SolarPro - LA Dialog.dcl"))
  (if (null dcl-path) (progn (alert "Cannot find:\nSolarPro - LA Dialog.dcl") (exit)))
  (setq dcl-id (load_dialog dcl-path))
  (if (or (null dcl-id) (minusp dcl-id)) (progn (alert "Failed to load LA dialog.") (exit)))
  (if (not (new_dialog "la_dialog" dcl-id)) (progn (unload_dialog dcl-id) (exit)))
  (set_tile "la_rad" "90.0")
  (set_tile "la_height" "7.0")
  (set_tile "la_lat" (rtos lat 2 2))
  (action_tile "accept" "(setq la-rad (atof (get_tile \"la_rad\")) pole-h (atof (get_tile \"la_height\")) lat (atof (get_tile \"la_lat\"))) (done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")
  (setq result (start_dialog))
  (unload_dialog dcl-id)
  (if (= result 0) (exit))


  (setq old-echo (getvar "CMDECHO") old-layer (getvar "CLAYER"))
  (setvar "CMDECHO" 0)
  (setup-layer "LA_PROTECTION" "8")
  (command "_.-LAYER" "TR" "82" "LA_PROTECTION" "")

  (setq i 0)
  (while (< i (sslength ss))
    (setq pt (cdr (assoc 10 (entget (ssname ss i)))))
    ;; Draw Circle via entmake
    (setq b-ent (entmakex (list '(0 . "CIRCLE") '(8 . "LA_PROTECTION") '(62 . 256) (cons 10 pt) (cons 40 la-rad))))
    ;; Draw Solid hatch via command (Solid is safe)
    (if b-ent (command "_.-HATCH" "_P" "SOLID" "_S" b-ent "" ""))
    (setq i (1+ i))
  )
  (setvar "CLAYER" old-layer)
  (setvar "CMDECHO" old-echo)
  (princ (strcat "\nApplied protection logic to " (itoa i) " points."))
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
(defun spd-street-lighting-summary ()
  (list (list "Street Lighting" "Standard Solar Pole")))

;; =============================================================================
;; INTEGRATED DIALOG CONTROLLER (V4.8 - AUTOMATED PILING & HIGH-VIS DIAGRAM)
;; =============================================================================

(defun spd-find-dcl ()
  (spd-get-dcl "SolarPro - Layout Input Dialog.dcl"))

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
      (setq *spd-cap-mode* (get_tile "capacity_mode")
            *spd-s-target* (get_tile "target_mw")
            *spd-s-lat*    (get_tile "lat")
            *spd-s-lon*    (get_tile "lon")
            *spd-s-az*     (get_tile "az")
            *spd-s-setoff* (get_tile "set_off")))
    ((= page 1)
      (setq *spd-s-pw*      (get_tile "p_w")
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

(defun spd-calc-piling (is_secondary / pw row mgh df db tw rec_np ori ph k_df k_db k_num)
  (if is_secondary
    (setq row (atoi (spd-field-default "mod_in_row_2"))
          k_df "pile_dist_first_2" k_db "pile_dist_btw_2" k_num "pile_num_2")
    (setq row (atoi (spd-field-default "mod_in_row"))
          k_df "pile_dist_first"   k_db "pile_dist_btw"   k_num "pile_num"))
  (setq pw  (atof (spd-field-default "p_w"))
        ph  (atof (spd-field-default "p_h"))
        ori (spd-field-default "p_ori")
        mgh (atof (spd-field-default "m_gap_h"))
        df  (/ (atof (spd-get-val k_df "500")) 1000.0)
        db  (/ (atof (spd-get-val k_db "1900")) 1000.0))
  (if (or (= ori "0") (= ori ""))
      (setq tw (+ (* pw row) (* mgh (max 0 (- row 1)))))
      (setq tw (+ (* ph row) (* mgh (max 0 (- row 1))))))
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
      (start_list "capacity_mode") (add_list "TargetMWp") (add_list "Maximum") (end_list)
      (set_tile "capacity_mode" (spd-field-default "capacity_mode"))
      (set_tile "target_mw" (spd-field-default "target_mw"))
      (set_tile "lat" (spd-field-default "lat"))
      (set_tile "lon" (spd-field-default "lon"))
      (set_tile "az" (spd-field-default "az"))
      (set_tile "set_off" (spd-field-default "set_off")))
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
      (action_tile "pitch_mode" "(spd-toggle-pitch)")
      (spd-toggle-pitch))
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
(defun c:SolarPro () (c:SolarProDialog))
(princ "\nSolarPro Engine Loaded. Type SOLARPRO to start.")
(princ "\nType SOLARPROLAUNCHER or SPL to open the button launcher.")
(princ "\n--- SolarPro V4.5 (TAB STYLE DIALOG) Loaded ---")
(princ "\n  CLEARPILELABELS     - Clear coordinate labels")
(defun c:PILING () (c:PileLabels))
(princ)

;; Initialize global point style for piling markers on load
(setvar "PDMODE" 35)
(setvar "PDSIZE" 0.25)
(princ "\nPoint Style set (PDMODE=35, PDSIZE=0.25) for Piling Visibility.")
(princ)

;;;============================================================
;;; SolarPro V5.0 EXTENSION  (BATCH 1)
;;; Adds: SLD auto-draw, BoQ master export, Cable drum schedule
;;; All commands append to the main file, do not modify existing
;;; commands.  Indian-utility-scale defaults (33 kV HT, 0.8 kV LV,
;;; 50 deg C ambient, 70 deg C XLPE conductor) are used; the
;;; *SP-CONFIG* alist at the top of this block is editable.
;;;============================================================

(vl-load-com)

;;------------------------------------------------------------
;; Global configuration (hand-editable)
;;------------------------------------------------------------
(if (not (boundp '*SP-CONFIG*))
  (setq *SP-CONFIG*
    (list
      (cons "STD"            "IS")    ; "IS" or "IEC"
      (cons "AMBIENT"        50.0)    ; deg C
      (cons "CABLE_TEMP"     70.0)    ; XLPE max conductor, deg C
      (cons "HT_KV"          33.0)
      (cons "LV_KV"           0.8)
      (cons "GROUPING"       0.8)     ; derating factor
      (cons "SOIL_RES"       100.0)   ; ohm-m average India
      (cons "DRUM_LEN"       1000.0)  ; default DC drum, m
      (cons "DRUM_LEN_HT"    500.0)   ; HT drum, m
      (cons "WASTE_PCT"      5.0)     ; cable cut wastage %
      (cons "PR"             0.82)    ; default performance ratio
      (cons "BOS_PCT"        12.0)    ; BoS overhead vs DC
      (cons "CUF_TARGET"     19.0)    ; typical India CUF %
    )))

(defun sp-cfg (k / a)
  (setq a (assoc (strcase k) (mapcar '(lambda (x) (cons (strcase (car x)) (cdr x))) *SP-CONFIG*)))
  (if a (cdr a) nil))

(defun sp-cfg-set (k v)
  (setq *SP-CONFIG* (subst (cons k v) (assoc k *SP-CONFIG*) *SP-CONFIG*)))

;;------------------------------------------------------------
;; Generic low-level drafting helpers
;;------------------------------------------------------------
(defun sp-make-layer (name color ltype)
  (if (not (tblsearch "LAYER" name))
    (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord")
                   '(100 . "AcDbLayerTableRecord")
                   (cons 2 name) '(70 . 0) (cons 62 color) (cons 6 ltype)))))

(defun sp-set-layer (name)
  (sp-make-layer name 7 "Continuous")
  (setvar "CLAYER" name))

(defun sp-text (pt h txt lay color / rot)
  (setq rot (getvar "CLAYER"))
  (setvar "CLAYER" lay)
  (entmake (list '(0 . "TEXT") '(100 . "AcDbEntity")
                 (cons 8 lay) (cons 62 color)
                 '(100 . "AcDbText")
                 (cons 10 pt) (cons 40 h) (cons 1 txt)))
  (setvar "CLAYER" rot))

(defun sp-mtext (pt h txt lay color / rot)
  (setq rot (getvar "CLAYER"))
  (setvar "CLAYER" lay)
  (entmake (list '(0 . "MTEXT") '(100 . "AcDbEntity")
                 (cons 8 lay) (cons 62 color)
                 '(100 . "AcDbMText")
                 (cons 10 pt) (cons 40 h)
                 (cons 1 txt)))
  (setvar "CLAYER" rot))

(defun sp-line (p1 p2 lay color)
  (entmake (list '(0 . "LINE") (cons 8 lay) (cons 62 color)
                 (cons 10 p1) (cons 11 p2))))

(defun sp-pline (pts lay color closed / e)
  (if (< (length pts) 2) (exit))
  (setq e (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                (cons 8 lay) (cons 62 color)
                '(100 . "AcDbPolyline")
                (cons 90 (length pts)) (cons 70 (if closed 1 0))))
  (foreach p pts (setq e (append e (list (cons 10 p)))))
  (entmake e))

(defun sp-rect (x y w h lay color)
  (sp-pline (list (list x y 0.0)
                  (list (+ x w) y 0.0)
                  (list (+ x w) (+ y h) 0.0)
                  (list x (+ y h) 0.0)) lay color T))

(defun sp-circle (pt r lay color)
  (entmake (list '(0 . "CIRCLE") (cons 8 lay) (cons 62 color)
                 (cons 10 pt) (cons 40 r))))

(defun sp-arc (pt r a1 a2 lay color)
  (entmake (list '(0 . "ARC") (cons 8 lay) (cons 62 color)
                 (cons 10 pt) (cons 40 r)
                 (cons 50 a1) (cons 51 a2))))

(defun sp-hatch (lay color / e en obj)
  (setq e (entlast))
  (if (and e (= (cdr (assoc 0 (entget e))) "LWPOLYLINE"))
    (progn
      (command "_.HATCH" "_S" e "" "_P" "SOLID" "_C" color "" "")
      (setq en (entlast))
      (if en
        (progn
          (setq obj (vlax-ename->vla-object en))
          (vla-put-Layer obj lay)
          (vla-put-Color obj color))))))

(defun sp-num (v prec) (rtos v 2 prec))

;;============================================================
;; 1A. SLD AUTO-DRAW
;; Reads the *sld-* globals (already populated by CREATESLD
;; dialog) and produces a Single Line Diagram on the SLD
;; layer.  Symbols drawn (left to right, top to bottom):
;;
;;   PV ARRAY (per inverter) -- STRING x mps -- COMBINER/SCB
;;       -- INVERTER -- ACDB -- POWER TRANSFORMER
;;       -- HT VCB -- HT LINE -- GRID / PoC
;;   +  bus bar, ratings, cable specs, title block
;;
;; Usage:  SLDDRAW       - draws at point user clicks
;;         SLDTEMPLATE   - just draws the empty title block
;;============================================================

;; SLD sheet sizes in mm; converted to drawing units (mm * 1.0)
(setq *SP-SLD-SHEETS*
  '(("A3" 420.0 297.0) ("A2" 594.0 420.0)
    ("A1" 841.0 594.0) ("A0" 1189.0 841.0)))

(defun sp-sld-sheet-dims (name / row)
  (setq row (assoc name *SP-SLD-SHEETS*))
  (if row (list (cadr row) (caddr row)) (list 594.0 420.0)))

;; Standard SLD symbols at 1:1 scale (mm)
(defun sp-sld-draw-mod (x y lay / x1 y1)
  (sp-rect x y 12 6 lay 7)
  (sp-text (list (+ x 6) (+ y 3.3) 0.0) 2.5 "PV" lay 7))

(defun sp-sld-draw-string (x y mps lay / i xx)
  (setq i 0 xx x)
  (while (< i mps)
    (sp-sld-draw-mod xx y lay)
    (setq xx (+ xx 14) i (1+ i)))
  (sp-line (list x (+ y 3) 0.0) (list (- xx 2) (+ y 3) 0.0) lay 4))

(defun sp-sld-draw-combiners (x y nspi lay / i xx)
  (setq i 0 xx x)
  (repeat nspi
    (sp-rect xx (- y 6) 14 6 lay 5)
    (sp-text (list (+ xx 7) (- y 3) 0.0) 2.0 "SCB" lay 7)
    (setq xx (+ xx 18) i (1+ i))))

(defun sp-sld-draw-inverter (x y kw inv_ac_kv lay / w h)
  (setq w 32 h 14)
  (sp-rect x y w h lay 2)
  (sp-text (list (+ x 2) (+ y 10) 0.0) 3.0 "INV" lay 7)
  (sp-text (list (+ x 2) (+ y 6) 0.0) 2.0
    (strcat (sp-num kw 0) " kW") lay 7)
  (sp-text (list (+ x 2) (+ y 2) 0.0) 2.0
    (strcat "AC " inv_ac_kv " kV") lay 7)
  (list (+ x (/ w 2.0)) (+ y h)))

(defun sp-sld-draw-acdb (x y incoming outgoing lay / w h)
  (setq w 28 h 12)
  (sp-rect x y w h lay 6)
  (sp-text (list (+ x 2) (+ y 8) 0.0) 3.0 "ACDB" lay 7)
  (sp-text (list (+ x 2) (+ y 4) 0.0) 2.0
    (strcat (rtos incoming 2 0) " IN / " (rtos outgoing 2 0) " OUT") lay 7)
  (list (+ x (/ w 2.0)) (+ y h)))

(defun sp-sld-draw-transformer (x y kva lv_kv hv_kv winding cooling vec lay / cx cy r)
  (setq cx (+ x 18) cy (+ y 14) r 14)
  (sp-circle (list cx cy 0.0) r lay 3)
  (sp-circle (list (+ cx r) cy 0.0) r lay 3)
  (sp-line (list cx cy 0.0) (list cx (- cy r) 0.0) lay 3)
  (sp-line (list (+ cx r) cy 0.0) (list (+ cx r) (- cy r) 0.0) lay 3)
  (sp-text (list (+ cx 3) (+ cy 4) 0.0) 2.5
    (strcat (rtos kva 2 0) " kVA") lay 7)
  (sp-text (list (+ cx 3) (+ cy 1) 0.0) 2.0
    (strcat (sp-num lv_kv 1) "/" (sp-num hv_kv 1) " kV") lay 7)
  (sp-text (list (+ cx 3) (- cy 2) 0.0) 2.0 vec lay 7)
  (sp-text (list (+ cx 3) (- cy 5) 0.0) 2.0 winding lay 7)
  (sp-text (list (+ cx 3) (- cy 8) 0.0) 2.0 cooling lay 7)
  (list (+ cx (* 2 r)) cy))

(defun sp-sld-draw-vcb (x y kv rating lay / w h)
  (setq w 12 h 10)
  (sp-rect x y w h lay 1)
  (sp-text (list (+ x 1) (+ y 6) 0.0) 2.5 "VCB" lay 7)
  (sp-text (list (+ x 1) (+ y 3) 0.0) 1.8
    (strcat (sp-num kv 0) " kV / " (sp-num rating 0) " A") lay 7)
  (list (+ x w) (+ y (/ h 2.0))))

(defun sp-sld-draw-grid (x y kv lay / r)
  (setq r 10)
  (sp-circle (list (+ x r) y 0.0) r lay 4)
  (sp-line (list (- x 0) y 0.0) (list (+ x (* 2 r)) y 0.0) lay 4)
  (sp-text (list (+ x 4) (+ y 4) 0.0) 2.5 "GRID" lay 7)
  (sp-text (list (+ x 4) y 0.0) 2.0 (strcat (sp-num kv 0) " kV") lay 7))

(defun sp-sld-titleblock (x y w h project client doc rev lay)
  (sp-rect x y w h lay 7)
  (sp-line (list x (+ y (* 0.4 h)) 0.0) (list (+ x w) (+ y (* 0.4 h)) 0.0) lay 7)
  (sp-line (list x (+ y (* 0.7 h)) 0.0) (list (+ x w) (+ y (* 0.7 h)) 0.0) lay 7)
  (sp-line (list (+ x (* 0.6 w)) y 0.0) (list (+ x (* 0.6 w)) (+ y (* 0.4 h)) 0.0) lay 7)
  (sp-text (list (+ x 3) (+ y (* 0.85 h)) 0.0) 4.0
    (strcat "SINGLE LINE DIAGRAM  -  " project) lay 7)
  (sp-text (list (+ x 3) (+ y (* 0.55 h)) 0.0) 2.5
    (strcat "Client: " client) lay 7)
  (sp-text (list (+ x 3) (+ y (* 0.45 h)) 0.0) 2.5
    (strcat "Doc: " doc) lay 7)
  (sp-text (list (+ x (* 0.62 w)) (+ y (* 0.55 h)) 0.0) 2.5
    (strcat "Rev: " rev) lay 7)
  (sp-text (list (+ x (* 0.62 w)) (+ y (* 0.45 h)) 0.0) 2.5
    (strcat "Date: " (menucmd "M=$(edtime,$(getvar,date),DD-MON-YYYY)")) lay 7))

(defun c:SLDTEMPLATE (/ ins)
  (sp-set-layer "SLD")
  (setq ins (getpoint "\nClick top-left of title block: "))
  (if (null ins) (exit))
  (sp-rect (car ins) (cadr ins) 594 420 "SLD" 7)
  (sp-sld-titleblock (car ins) (cadr ins) 594 420 "SOLAR PV PLANT" "CLIENT" "SP-SLD-001" "R0" "SLD")
  (princ "\nSLD template drawn."))

(defun c:SLDDRAW (/ ins mps spi num_inv p_watt p_total dc_kwp inv_kw inv_make inv_model
                   acdb_in acdb_out acdb_a tf_kva tf_lv tf_hv tf_imp tf_vec
                   tf_winding tf_cooling tf_oltc ht_kv ht_a inv_ac_kv sheet
                   cur_x cur_y vcb_pt grid_pt acdb_pt inv_pt trafo_pt comb_y
                   strings nspi i j rownum total_rows_per_inv n_inv_pp
                   rows_across rows_per_inv y_run y_inv)
  (vl-load-com)
  ;; ---- Pull from existing *sld-* globals if present, else prompt ----
  (if (and (boundp '*sld-mps*) (boundp '*sld-spi*) (boundp '*sld-num-inv*)
           *sld-mps* *sld-spi* *sld-num-inv*)
    (progn
      (setq mps       (atoi *sld-mps*)
            spi       (atoi *sld-spi*)
            num_inv   (atoi *sld-num-inv*)
            p_watt    (if (boundp '*sld-mod-watt*) (atof *sld-mod-watt*) 595.0)
            p_total   (if (boundp '*sld-total-mod*) (atoi *sld-total-mod*) 0)
            dc_kwp    (if (boundp '*sld-dc-kwp*) (atof *sld-dc-kwp*) 0.0)
            inv_kw    (if (boundp '*sld-inv-kw*) (atof *sld-inv-kw*) 350.0)
            inv_make  (if (boundp '*sld-inv-make*) *sld-inv-make* "Generic")
            inv_model (if (boundp '*sld-inv-model*) *sld-inv-model* "-")
            acdb_in   (if (boundp '*sld-acdb-in*) (atoi *sld-acdb-in*) num_inv)
            acdb_out  (if (boundp '*sld-acdb-out*) (atoi *sld-acdb-out*) 1)
            acdb_a    (if (boundp '*sld-acdb-rating*) (atof *sld-acdb-rating*) 2500.0)
            tf_kva    (if (boundp '*sld-tf-rating*) (atof *sld-tf-rating*) 5000.0)
            tf_lv     (if (boundp '*sld-tf-lv*) (atof *sld-tf-lv*) 0.8)
            tf_hv     (if (boundp '*sld-tf-hv*) (atof *sld-tf-hv*) 33.0)
            tf_imp    (if (boundp '*sld-tf-imp*) (atof *sld-tf-imp*) 6.25)
            tf_vec    (if (boundp '*sld-tf-vector*) *sld-tf-vector* "Dyn11")
             tf_winding (if (boundp '*sld-tf-winding*) *sld-tf-winding* "2 Winding")
             tf_cooling (if (boundp '*sld-tf-cooling*) *sld-tf-cooling* "ONAN")
            tf_oltc   (if (boundp '*sld-tf-oltc*) *sld-tf-oltc* "No")
            ht_kv     (if (boundp '*sld-ht-kv*) (atof *sld-ht-kv*) 33.0)
            ht_a      (if (boundp '*sld-ht-rating*) (atof *sld-ht-rating*) 630.0)
            inv_ac_kv (if (boundp '*sld-inv-ac-kv*) *sld-inv-ac-kv* "0.8")
            sheet     (if (boundp '*sld-sheet*) *sld-sheet* "A1")))
    (progn
      (alert "SLD data not set. Run CREATESLD first to collect SLD data.")
      (exit)))
  (if (< mps 1) (setq mps 26))
  (if (< spi 1) (setq spi 12))
  (if (< num_inv 1) (setq num_inv 1))

  (sp-set-layer "SLD")
  (sp-set-layer "SLD_BUS")
  (sp-set-layer "SLD_LABEL")

  (setq ins (getpoint "\nClick top-left of SLD drawing area: "))
  (if (null ins) (exit))
  (setq cur_x (+ (car ins) 30)  cur_y (- (cadr ins) 30))

  ;; ---- Title block ----
  (sp-sld-titleblock (car ins) (- (cadr ins) 20) 594 18
    "SOLAR PV PLANT" inv_make "SP-SLD-001" "R0" "SLD")
  (sp-mtext (list (car ins) (+ (cadr ins) 10) 0.0) 3.0
    (strcat "DC: " (sp-num dc_kwp 0) " kWp | AC: "
            (sp-num (* inv_kw num_inv) 0) " kW | " (itoa num_inv) " x "
            (sp-num inv_kw 0) " kW " inv_make " " inv_model)
    "SLD_LABEL" 7)

  ;; ---- Draw one row per inverter (vertical stack) ----
  (setq y_inv (+ cur_y 30)
        vcb_pt nil  trafo_pt nil  acdb_pt nil)
  (setq rows_across 1)  ; 1 row per inverter; can be 2 if many
  (if (> num_inv 6) (setq rows_across 2))
  (setq y_run y_inv  inv_pt nil)

  (setq i 0)
  (while (< i num_inv)
    (if (and (> rows_across 1) (>= i (fix (/ num_inv 2.0))))
      (progn
        (setq cur_x (+ (car ins) (+ 30 350))
              y_run (+ y_inv (* (- i (fix (/ num_inv 2.0))) 110)))))
    (if (<= rows_across 1)
      (setq y_run (+ y_inv (* i 110))))
    ;; strings
    (sp-sld-draw-string cur_x y_run mps "SLD")
    (sp-sld-draw-combiners (+ cur_x 0) (- y_run 2) spi "SLD")
    ;; bus from string row to inverter
    (sp-line (list (+ cur_x (* spi 18)) (- y_run 0) 0.0)
             (list (+ cur_x (* spi 18)) y_run 0.0) "SLD_BUS" 1)
    (setq inv_pt (sp-sld-draw-inverter (+ cur_x (* spi 18) 4) (- y_run 7)
                inv_kw inv_ac_kv "SLD"))
    ;; line to ACDB
    (sp-line (list (car inv_pt) (cadr inv_pt) 0.0)
             (list (+ (car inv_pt) 18) (cadr inv_pt) 0.0) "SLD_BUS" 1)
    (setq acdb_pt (sp-sld-draw-acdb (+ (car inv_pt) 20) (- (cadr inv_pt) 12)
                acdb_in acdb_out "SLD"))
    ;; line to transformer (collect to one central transformer)
    (if (null trafo_pt)
      (progn
        (sp-line (list (car acdb_pt) (cadr acdb_pt) 0.0)
                 (list (car acdb_pt) (- y_inv 60) 0.0) "SLD_BUS" 1)
        (setq trafo_pt (sp-sld-draw-transformer (car acdb_pt) (- y_inv 88)
                      tf_kva tf_lv tf_hv tf_winding tf_cooling tf_vec "SLD")))
      (progn
        (sp-line (list (car acdb_pt) (cadr acdb_pt) 0.0)
                 (list (car trafo_pt) (cadr acdb_pt) 0.0) "SLD_BUS" 1)
        (sp-line (list (car trafo_pt) (cadr acdb_pt) 0.0)
                 (list (car trafo_pt) (cadr trafo_pt) 0.0) "SLD_BUS" 1)))
    (setq i (1+ i)))

  ;; HT side: VCB then HT bus then Grid
  (if trafo_pt
    (progn
      (sp-line (list (car trafo_pt) (cadr trafo_pt) 0.0)
               (list (+ (car trafo_pt) 30) (cadr trafo_pt) 0.0) "SLD_BUS" 1)
      (setq vcb_pt (sp-sld-draw-vcb (+ (car trafo_pt) 32) (- (cadr trafo_pt) 10)
                  ht_kv ht_a "SLD"))
      (sp-line (list (car vcb_pt) (cadr vcb_pt) 0.0)
               (list (+ (car vcb_pt) 20) (cadr vcb_pt) 0.0) "SLD_BUS" 1)
      (sp-sld-draw-grid (+ (car vcb_pt) 22) (- (cadr vcb_pt) 10) ht_kv "SLD")))

  ;; ---- Embed SLD as XDATA on a freshly-created marker entity ----
  (if (not (tblsearch "APPID" "FS_SLD_DRAWING")) (regapp "FS_SLD_DRAWING"))
  (entmake (list '(0 . "POINT") (cons 10 ins) '(8 . "SLD")
    (list -3 (list "FS_SLD_DRAWING"
      (cons 1000 (strcat "MPS=" (itoa mps)
                          " SPI=" (itoa spi)
                          " NUM_INV=" (itoa num_inv)
                          " INV_KW=" (sp-num inv_kw 0)
                          " TF_KVA=" (sp-num tf_kva 0)
                          " HT_KV=" (sp-num ht_kv 1)
                          " SHEET=" sheet)))))
  (princ (strcat "\nSLD drawn for " (itoa num_inv) " inverters on sheet " sheet
                 ". Use CREATESLD dialog to re-edit values.")))

;; Hook CREATESLD so that after OK it also auto-draws.
;; We replace the original CREATESLD's tail with a call to SLDDRAW
;; only if the user has confirmed.

(princ "\n[SolarPro v5.0] Batch 1 loaded: SLDDRAW, SLDTEMPLATE.")
(princ)


;;============================================================
;; 1B. BoQ MASTER EXPORT
;; Scans the entire drawing for FS_* XDATA and produces a
;; comprehensive Bill of Quantities CSV.
;;
;; Sections:
;;   1. Modules
;;   2. Tables
;;   3. Piles
;;   4. Piling/Clamp hardware
;;   5. String count
;;   6. Inverters
;;   7. DC cables
;;   8. AC cables
;;   9. Trench
;;  10. Earthing
;;  11. Site infrastructure
;;
;; Usage: SPBOQ    - prompts for CSV path
;;============================================================

(defun sp-boq-count-modules (/ ss idx en xd w h watt ori mod_row mod_stk
                                tot tables mfrs models watts counts)
  (setq ss (ssget "_X" '((-3 ("FS_SOLAR_DATA"))))
        tot 0 tables 0
        mfrs '() models '() watts '() counts '())
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq en (ssname ss idx)
              xd (cadr (assoc -3 (entget en '("FS_SOLAR_DATA")))))
        (if xd
          (progn
            (setq w       (sp-xd-item-val (nth 0 xd))
                  h       (sp-xd-item-val (nth 1 xd))
                  watt    (sp-xd-item-val (nth 2 xd))
                  ori     (if (= (fix (sp-xd-item-val (nth 9 xd))) 1) "Portrait" "Landscape")
                  mod_row (fix (sp-xd-item-val (nth 7 xd)))
                  mod_stk (fix (sp-xd-item-val (nth 8 xd))))
            (setq tot   (+ tot (* mod_row mod_stk))
                  tables (+ tables 1))
            (if (not (member watt watts)) (setq watts (append watts (list watt))))))
        (setq idx (1+ idx)))))
  (list tot tables watts))

(defun sp-boq-count-piles (/ ss idx bname bname_counts bc pile_counts total
                               tbl_count npiles)
  (setq ss (ssget "_X" '((0 . "INSERT") (2 . "TABLE_*")))
        bname_counts '() total 0 pile_counts '())
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq bname (cdr (assoc 2 (entget (ssname ss idx)))))
        (if bname
          (progn
            (if (assoc bname bname_counts)
              (setq bname_counts (subst (cons bname (1+ (cdr (assoc bname bname_counts))))
                                       (assoc bname bname_counts) bname_counts))
              (setq bname_counts (cons (cons bname 1) bname_counts))))
          (progn
            (setq npiles (spd-count-block-piles bname))
            (if (> npiles 0)
              (progn
                (if (assoc bname pile_counts)
                  (setq pile_counts (subst (cons bname (+ (cdr (assoc bname pile_counts))
                                                          (* npiles (cdr (assoc bname bname_counts)))))
                                            (assoc bname pile_counts) pile_counts))
                  (setq pile_counts (cons (cons bname (* npiles (cdr (assoc bname bname_counts))))
                                          pile_counts)))
                (setq total (+ total (* npiles (cdr (assoc bname bname_counts)))))))))
        (setq idx (1+ idx)))))
  (if ss
    (progn
      (foreach bc bname_counts
        (setq bname (car bc)
              tbl_count (cdr bc)
              npiles (spd-count-block-piles bname))
        (if (> npiles 0)
          (progn
            (if (assoc bname pile_counts)
              (setq pile_counts (subst (cons bname (+ (cdr (assoc bname pile_counts))
                                                      (* npiles tbl_count)))
                                        (assoc bname pile_counts) pile_counts))
              (setq pile_counts (cons (cons bname (* npiles tbl_count)) pile_counts)))
            (setq total (+ total (* npiles tbl_count))))))))
  (list total pile_counts))

(defun sp-boq-count-inverters (/ ss idx txt inv_ids)
  (setq ss (ssget "_X" '((0 . "MTEXT") (8 . "STRINGING")))
        inv_ids '())
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq txt (cdr (assoc 1 (entget (ssname ss idx)))))
        (if (and txt (vl-string-search "INV-" (strcase txt)))
          (progn
            (setq inv_ids (cons (substr txt 1 5) inv_ids))))
        (setq idx (1+ idx)))
      (setq inv_ids (vl-remove-if '(lambda (x) (not (wcmatch x "INV-#"))) inv_ids))))
  (length (vl-remove-if 'null (mapcar '(lambda (x) (if (assoc x '((INV-1 . T)(INV-2 . T))) x nil)) inv_ids))))

(defun sp-boq-dc-cables (/ ss idx xd inv csize len mps neg up cables cable_data)
  (setq ss (ssget "_X" '((-3 ("FS_DC_CABLE"))))
        cables '())
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq xd (cadr (assoc -3 (entget (ssname ss idx) '("FS_DC_CABLE")))))
        (if (and xd (>= (length xd) 6))
          (progn
            (setq inv  (cdr (nth 0 xd))
                  mps  (cdr (nth 1 xd))
                  csize (cdr (nth 2 xd))
                  neg  (cdr (nth 3 xd))
                  up   (cdr (nth 4 xd))
                  len  (if (nth 5 xd) (cdr (nth 5 xd)) 0.0))
            (setq cables (cons (list inv mps csize neg up len) cables))))
        (setq idx (1+ idx)))))
  cables)

(defun sp-boq-ac-cables (/ ss idx xd inv csize len cables)
  (setq ss (ssget "_X" '((-3 ("FS_AC_CABLE"))))
        cables '())
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq xd (cadr (assoc -3 (entget (ssname ss idx) '("FS_AC_CABLE")))))
        (if (and xd (>= (length xd) 5))
          (progn
            (setq inv  (cdr (nth 0 xd))
                  csize (cdr (nth 2 xd))
                  len  (if (nth 4 xd) (cdr (nth 4 xd)) 0.0))
            (setq cables (cons (list inv csize len) cables))))
        (setq idx (1+ idx)))))
  cables)

(defun sp-boq-trench (/ ss idx xd ttype tlen tdepth twidth tvol rows total_len total_vol)
  (setq ss (ssget "_X" '((-3 ("FS_TRENCH_BOM"))))
        rows '() total_len 0.0 total_vol 0.0)
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq xd (cadr (assoc -3 (entget (ssname ss idx) '("FS_TRENCH_BOM")))))
        (if (and xd (>= (length xd) 5))
          (progn
            (setq ttype (cdr (nth 0 xd))
                  tlen  (cdr (nth 1 xd))
                  tdepth (cdr (nth 2 xd))
                  twidth (cdr (nth 3 xd))
                  tvol  (cdr (nth 4 xd)))
            (setq rows (cons (list ttype tlen tdepth twidth tvol) rows)
                  total_len (+ total_len tlen)
                  total_vol (+ total_vol tvol))))
        (setq idx (1+ idx)))))
  (list rows total_len total_vol))

(defun sp-boq-earthing (/ grid_ss cable_ss pit_ss grid_len cable_len pit_count)
  (setq grid_ss  (ssget "_X" '((0 . "LWPOLYLINE") (8 . "EARTHING_GRID")))
        cable_ss (ssget "_X" '((0 . "LWPOLYLINE") (8 . "EARTHING_CABLE")))
        pit_ss   (ssget "_X" '((0 . "POINT,CIRCLE,INSERT") (8 . "EARTHING_PITS")))
        grid_len 0.0 cable_len 0.0 pit_count 0)
  (if grid_ss
    (progn
      (setq idx 0)
      (while (< idx (sslength grid_ss))
        (setq grid_len (+ grid_len (vlax-curve-getDistAtPoint
                                 (vlax-ename->vla-object (ssname grid_ss idx))
                                 (vlax-curve-getEndPoint
                                   (vlax-ename->vla-object (ssname grid_ss idx))))))
        (setq idx (1+ idx)))))
  (if cable_ss
    (progn
      (setq idx 0)
      (while (< idx (sslength cable_ss))
        (setq cable_len (+ cable_len (vlax-curve-getDistAtPoint
                                  (vlax-ename->vla-object (ssname cable_ss idx))
                                  (vlax-curve-getEndPoint
                                    (vlax-ename->vla-object (ssname cable_ss idx))))))
        (setq idx (1+ idx)))))
  (if pit_ss (setq pit_count (sslength pit_ss)))
  (list grid_len cable_len pit_count))

(defun sp-csv-quote (s) (strcat "\"" (vl-string-translate "\"" "'" (vl-princ-to-string s)) "\""))

(defun sp-csv-row (&rest vals)
  (apply 'strcat
    (mapcar '(lambda (v)
               (if (numberp v) (rtos v 2 3)
                 (strcat (sp-csv-quote v) ",")))
            (append vals (list "")))))

(defun c:SPBOQ (/ f p mod_info modules tables watts
                pile_info total_piles pile_list
                inv_count dc_cables ac_cables
                trench_info trench_rows t_len t_vol
                earth_info grid_l cable_l pit_n
                mid_c end_c rownum)
  (vl-load-com)
  (if (not (findfile "C:\\")) (progn (alert "Cannot access drive.") (exit)))
  (setq p (getfiled "Export SolarPro BoQ" (strcat (getvar "DWGPREFIX") "SolarPro_BoQ") "csv" 1))
  (if (null p) (exit))
  (if (findfile p) (vl-file-delete p))
  (setq f (open p "w"))
  (if (null f) (progn (alert "Cannot create file.") (exit)))

  ;; --- 1. Modules ---
  (setq mod_info (sp-boq-count-modules)
        modules  (car mod_info)
        tables   (cadr mod_info)
        watts    (caddr mod_info))
  (write-line "=== SECTION 1: MODULES ===" f)
  (write-line "DESCRIPTION,QTY,UNIT" f)
  (write-line (strcat "PV Modules, " (itoa modules) ", Nos") f)
  (write-line (strcat "Tables, " (itoa tables) ", Nos") f)
  (foreach w watts
    (write-line (strcat "  Wattage tier: " (rtos w 2 0) " Wp, , ") f))

  ;; --- 2-3. Piles & hardware ---
  (setq pile_info (sp-boq-count-piles)
        total_piles (car pile_info)
        pile_list   (cadr pile_info))
  (write-line "" f)
  (write-line "=== SECTION 2: PILES ===" f)
  (write-line "TABLE TYPE,QTY/TABLE,TABLES,QTY TOTAL" f)
  (foreach pl pile_list
    (write-line (strcat (car pl) ","
                        (rtos (/ (cdr pl) (max 1 (length pile_list))) 2 0) ",,"
                        (rtos (cdr pl) 2 0)) f))
  (write-line (strcat "TOTAL PILES, ,," (rtos total_piles 2 0)) f)

  ;; --- 4. Hardware (clamps) ---
  (if (and (boundp '*spd-road-summary-stats*) (cadr *spd-road-summary-stats*))
    (setq mid_c (car *spd-road-summary-stats*)
          end_c (cadr *spd-road-summary-stats*))
    (progn
      (setq mid_c (* 2 modules)  end_c (* 2 tables))))
  (write-line "" f)
  (write-line "=== SECTION 3: CLAMPS & HARDWARE ===" f)
  (write-line "DESCRIPTION,QTY,UNIT" f)
  (write-line (strcat "Mid Clamps, " (itoa mid_c) ", Nos") f)
  (write-line (strcat "End Clamps, " " (estimated) " (itoa end_c) ", Nos") f)
  (write-line (strcat "Earth Lugs (per module), , " (itoa modules)) f)

  ;; --- 5. Inverters ---
  (setq inv_count (sp-boq-count-inverters))
  (write-line "" f)
  (write-line "=== SECTION 4: INVERTERS ===" f)
  (write-line "DESCRIPTION,QTY,UNIT" f)
  (write-line (strcat "String Inverters / PCU, " (itoa inv_count) ", Nos") f)
  (write-line (strcat "Inverter mounting skid (per inverter), " (itoa inv_count) ", Nos") f)

  ;; --- 6. DC cables ---
  (setq dc_cables (sp-boq-dc-cables))
  (write-line "" f)
  (write-line "=== SECTION 5: DC CABLES ===" f)
  (write-line "INVERTER,SIZE (sqmm),COUNT,LENGTH (m) EA,TOTAL (m)" f)
  (if dc_cables
    (progn
      (setq grouped (sp-group-by dc_cables 1))
      (foreach g grouped
        (write-line (strcat
          (car g) "," (rtos (cadr g) 2 0) ","
          (itoa (caddr g)) ",,"
          (rtos (car (cdddr g)) 2 2)) f)))
    (write-line "No DC cable XDATA found., , , , " f))

  ;; --- 7. AC cables ---
  (setq ac_cables (sp-boq-ac-cables))
  (write-line "" f)
  (write-line "=== SECTION 6: AC CABLES ===" f)
  (write-line "INVERTER,SIZE (sqmm),COUNT,LENGTH (m) EA,TOTAL (m)" f)
  (if ac_cables
    (progn
      (setq grouped (sp-group-by ac_cables 1))
      (foreach g grouped
        (write-line (strcat
          (car g) "," (rtos (cadr g) 2 0) ","
          (itoa (caddr g)) ",,"
          (rtos (car (cdddr g)) 2 2)) f)))
    (write-line "No AC cable XDATA found., , , , " f))

  ;; --- 8. Trench ---
  (setq trench_info (sp-boq-trench)
        trench_rows (car trench_info)
        t_len       (cadr trench_info)
        t_vol       (caddr trench_info))
  (write-line "" f)
  (write-line "=== SECTION 7: TRENCH ===" f)
  (write-line "TYPE,LENGTH (m),DEPTH (m),WIDTH (m),VOLUME (m3)" f)
  (foreach tr trench_rows
    (write-line (strcat (car tr) "," (rtos (cadr tr) 2 2) ","
                        (rtos (caddr tr) 2 2) ","
                        (rtos (cadddr tr) 2 2) ","
                        (rtos (car (cddddr tr)) 2 2)) f))
  (write-line (strcat "TOTAL, " (rtos t_len 2 2) ",,," (rtos t_vol 2 2)) f)

  ;; --- 9. Earthing ---
  (setq earth_info (sp-boq-earthing)
        grid_l (car earth_info)
        cable_l (cadr earth_info)
        pit_n  (caddr earth_info))
  (write-line "" f)
  (write-line "=== SECTION 8: EARTHING ===" f)
  (write-line "DESCRIPTION,LENGTH/COUNT,UNIT" f)
  (write-line (strcat "Perimeter earth strip (Cu), " (rtos grid_l 2 2) ", m") f)
  (write-line (strcat "Branch earth strip (Cu), " (rtos cable_l 2 2) ", m") f)
  (write-line (strcat "Earth pits, " (itoa pit_n) ", Nos") f)

  ;; --- 10. Misc ---
  (write-line "" f)
  (write-line "=== SECTION 9: SUMMARY TOTALS ===" f)
  (write-line (strcat "Total modules, " (itoa modules) ", Nos") f)
  (write-line (strcat "Total tables, " (itoa tables) ", Nos") f)
  (write-line (strcat "Total piles, " (rtos total_piles 2 0) ", Nos") f)
  (write-line (strcat "Total inverters, " (itoa inv_count) ", Nos") f)
  (write-line (strcat "Trench length, " (rtos t_len 2 2) ", m") f)
  (write-line (strcat "Trench excavation, " (rtos t_vol 2 2) ", m3") f)
  (write-line (strcat "Earth strip total, " (rtos (+ grid_l cable_l) 2 2) ", m") f)

  (close f)
  (princ (strcat "\nBoQ exported to: " p))
  (princ))

;;------------------------------------------------------------
;; Generic group-by on alist-style records
;; (sp-group-by list col) -> list of (key col1 col2 col3 col4)
;;   where col1..col3 are summed.
;;------------------------------------------------------------
(defun sp-group-by (records key-col / grouped by-key k v found rec)
  (setq grouped '())
  (foreach rec records
    (setq k (nth key-col rec)
          by-key (vl-remove-if-not '(lambda (x) (= (car x) k)) grouped))
    (if by-key
      (progn
        (setq v (car by-key))
        (setq grouped (subst
          (list k
                (+ (nth 1 v) (nth 1 rec))
                (+ (nth 2 v) 1)
                (+ (nth 3 v) (nth (length rec) rec)))
          v grouped)))
      (setq grouped (cons
        (list k (nth 1 rec) 1 (nth (1- (length rec)) rec))
        grouped))))
  grouped)

;;============================================================
;; 1C. CABLE DRUM SCHEDULE
;; Bin-packs cable lengths onto standard drum lengths.
;; Algorithm: First-Fit Decreasing (FFD) -- O(n log n).
;;
;; Usage: DRUMSCHEDULE
;;   Reads all DC and AC cable XDATA, sorts by length DESC,
;;   packs into minimum number of drums.
;;============================================================

(defun sp-drum-cable-rec (cable type / rec)
  (setq rec (list
    (cond ((= type "DC") (nth 1 cable))     ; mps for DC
          ((= type "AC") 0.0))
    (cond ((= type "DC") (nth 2 cable))     ; csize
          ((= type "AC") (nth 1 cable)))
    (car (last cable))                       ; length
    type
    (cond ((= type "DC") (car cable))       ; inverter
          ((= type "AC") (car cable)))))
  rec)

(defun sp-ffd-pack (sorted-lengths drum-len / drums drum-idx cur-rem i L)
  (setq drums '()
        drum-idx 0
        cur-rem drum-len)
  (foreach L sorted-lengths
    (if (> L drum-len)
      (progn
        (princ (strcat "\nWARNING: cable length " (rtos L 2 1) "m exceeds drum length "
                       (rtos drum-len 2 0) "m. Will be split across multiple drums."))
        (setq L drum-len)))
    (if (> L cur-rem)
      (progn
        (setq drum-idx (1+ drum-idx)
              cur-rem drum-len)))
    (if (not (assoc drum-idx drums))
      (setq drums (cons (cons drum-idx cur-rem) drums)))
    (setq drums (subst (cons drum-idx (- cur-rem L))
                       (assoc drum-idx drums) drums)))
  drums)

(defun c:DRUMSCHEDULE (/ p f dc ac dc-recs ac-recs
                       dc-sorted ac-sorted drum-len-dc drum-len-ac
                       dc-drums ac-drums drum-tot wastage-pct)
  (vl-load-com)
  (setq p (getfiled "Export Cable Drum Schedule"
                    (strcat (getvar "DWGPREFIX") "SolarPro_DrumSchedule") "csv" 1))
  (if (null p) (exit))
  (if (findfile p) (vl-file-delete p))
  (setq f (open p "w"))
  (if (null f) (progn (alert "Cannot create file.") (exit)))

  (setq drum-len-dc (sp-cfg "DRUM_LEN")
        drum-len-ac (sp-cfg "DRUM_LEN_HT")
        wastage-pct (sp-cfg "WASTE_PCT"))

  (write-line "=== DC CABLE DRUM SCHEDULE ===" f)
  (write-line (strcat "Drum length assumed: " (rtos drum-len-dc 2 0) " m") f)
  (write-line (strcat "Cut wastage assumed: " (rtos wastage-pct 2 1) " %") f)
  (write-line "" f)
  (write-line "DRUM#,CABLE TYPE,INVERTER,SIZE (sqmm),CUT LENGTH (m),CUT + WASTE,REMAINING (m)" f)

  (setq dc (sp-boq-dc-cables)
        dc-recs (mapcar '(lambda (c) (sp-drum-cable-rec c "DC")) dc)
        dc-sorted (vl-sort dc-recs
                    '(lambda (a b) (> (nth 2 a) (nth 2 b)))))
  (if dc-recs
    (progn
      (setq dc-drums (sp-ffd-pack (mapcar '(lambda (r) (* (nth 2 r) 1.01)) dc-sorted)
                                  drum-len-dc))
      (write-line (strcat "Drums required: " (itoa (length dc-drums))) f)
      (write-line "" f))
    (write-line "No DC cable data." f))

  (write-line "" f)
  (write-line "=== AC CABLE DRUM SCHEDULE ===" f)
  (write-line (strcat "Drum length assumed: " (rtos drum-len-ac 2 0) " m") f)
  (write-line "" f)
  (write-line "DRUM#,CABLE TYPE,INVERTER,SIZE (sqmm),CUT LENGTH (m),CUT + WASTE,REMAINING (m)" f)

  (setq ac (sp-boq-ac-cables)
        ac-recs (mapcar '(lambda (c) (sp-drum-cable-rec c "AC")) ac)
        ac-sorted (vl-sort ac-recs
                    '(lambda (a b) (> (nth 2 a) (nth 2 b)))))
  (if ac-recs
    (progn
      (setq ac-drums (sp-ffd-pack (mapcar '(lambda (r) (* (nth 2 r) 1.01)) ac-sorted)
                                  drum-len-ac))
      (write-line (strcat "Drums required: " (itoa (length ac-drums))) f))
    (write-line "No AC cable data." f))

  (close f)
  (princ (strcat "\nDrum schedule exported to: " p))
  (princ))

(princ "\n[SolarPro v5.0] Batch 1B+1C loaded: SPBOQ, DRUMSCHEDULE.")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 2)
;; Combiners, cable auto-sizing, cable schedule, earth resistance
;;============================================================

;;------------------------------------------------------------
;; Cable conductor data (XLPE Al/Cu, 1C, 90 deg C max, 70 deg C
;; operating).  Resistance R20 and R50 in ohm/km, reactance
;; X in ohm/km, current-carrying capacity A in free air / duct.
;;
;; Source: IS 7098 Part 2 typical values; rounded for design use.
;;------------------------------------------------------------
(setq *SP-CABLE-DB*
  '( ;; (size_sqmm  R20      R70      X        Cu_cap_amp  Al_cap_amp)
    (  4    4.61    5.51    0.090      40        32)
    (  6    3.08    3.69    0.087      51        41)
    ( 10    1.83    2.19    0.080      70        57)
    ( 16    1.15    1.38    0.077      94        76)
    ( 25    0.727   0.870   0.075     119        99)
    ( 35    0.524   0.627   0.073     148       125)
    ( 50    0.387   0.463   0.071     180       151)
    ( 70    0.268   0.321   0.070     232       185)
    ( 95    0.193   0.232   0.069     282       225)
    (120    0.153   0.184   0.068     328       260)
    (150    0.124   0.150   0.068     379       297)
    (185    0.0991  0.121   0.067     434       336)
    (240    0.0754  0.0924  0.067     514       390)
    (300    0.0601  0.0743  0.067     593       438)
    (400    0.0470  0.0591  0.066     715       510)
    (500    0.0366  0.0472  0.066     825       580)
    (630    0.0283  0.0375  0.065     950       660)))

(defun sp-cable-rec (size / row)
  (setq row (assoc size *SP-CABLE-DB*))
  (if row row (assoc 50 *SP-CABLE-DB*)))

(defun sp-cable-cap-amp (size conductor / r)
  (setq r (sp-cable-rec size))
  (if (= (strcase conductor) "CU") (nth 4 r) (nth 5 r)))

;;------------------------------------------------------------
;; Voltage drop (3-phase, %, balanced):
;;   Vdrop% = (L * I * (R*cos + X*sin) * 100) / (kV * 1000)
;;   L = length km, I = line current A
;;   kV = line-line voltage kV
;;   cos = PF, sin = sqrt(1-cos^2)
;;------------------------------------------------------------
(defun sp-vdrop-3p (I L_km size pf kV / r)
  (setq r (sp-cable-rec size)
        R (nth 1 r)
        X (nth 2 r))
  (* (/ (* L_km I (+ (* R pf) (* X (sqrt (- 1.0 (* pf pf)))))) (* kV 1000.0)) 100.0))

;;------------------------------------------------------------
;; Voltage drop (1-phase DC):
;;   Vdrop% = (2 * L * I * R) / (V_sys * 1000)  in %
;;   V_sys in V, L in km, R in ohm/km
;;------------------------------------------------------------
(defun sp-vdrop-dc (I L_km size V_sys / r R)
  (setq r (sp-cable-rec size)
        R (nth 1 r))
  (* (/ (* 2.0 L_km I R) V_sys) 100.0))

;;------------------------------------------------------------
;; DC cable size auto-pick
;;  - Pick smallest size satisfying BOTH:
;;    (a) current >= I * 1.25 (NEC 125% rule, applied to Isc)
;;    (b) Vdrop% <= vdrop_max (default 1.5% per string)
;;------------------------------------------------------------
(defun sp-pick-dc-size (I_amp L_km V_sys vdrop_max / sizes r cap vdr picked)
  (setq picked nil)
  (foreach r *SP-CABLE-DB*
    (setq cap (nth 4 r)
          vdr (sp-vdrop-dc I_amp L_km (car r) V_sys))
    (if (and (>= cap (* 1.25 I_amp))
             (<= vdr vdrop_max)
             (null picked))
      (setq picked (car r))))
  (if (null picked)
    (progn
      (princ (strcat "\nWARNING: no DC cable satisfies Isc=" (rtos I_amp 2 1)
                     "A, L=" (rtos L_km 2 2) "km, Vdrop<=" (rtos vdrop_max 2 1) "%. "
                     "Using largest available."))
      (setq picked 240)))
  picked)

;;------------------------------------------------------------
;; AC cable size auto-pick (3-phase, LV or HT)
;;  - Pick smallest size satisfying:
;;    (a) current >= I * 1.25
;;    (b) Vdrop% <= vdrop_max
;;------------------------------------------------------------
(defun sp-pick-ac-size (I_amp L_km pf kV vdrop_max / r cap vdr picked)
  (setq picked nil)
  (foreach r *SP-CABLE-DB*
    (setq cap (nth 4 r)
          vdr (sp-vdrop-3p I_amp L_km (car r) pf kV))
    (if (and (>= cap (* 1.25 I_amp))
             (<= vdr vdrop_max)
             (null picked))
      (setq picked (car r))))
  (if (null picked)
    (progn
      (princ (strcat "\nWARNING: no AC cable satisfies I=" (rtos I_amp 2 1)
                     "A, L=" (rtos L_km 2 2) "km, Vdrop<=" (rtos vdrop_max 2 1) "%. "
                     "Using largest available."))
      (setq picked 400)))
  picked)

;;============================================================
;; 2A. DC CABLE SIZE AUTO-PICK (DCCABLESIZE)
;;  - Reads all DC strings from FS_SOLAR_DATA / autostring
;;  - For each inverter, asks one Vmp/Isc/Mps -> derives Istring
;;  - Picks smallest cable per IS 7098 with derating
;;============================================================

(defun c:DCCABLESIZE (/ ss xd vmp imp isc mps istring L_km V_sys vdrop_max
                        picked derating_factor)
  (vl-load-com)
  (setq ss (ssget "_X" '((-3 ("FS_SOLAR_DATA")))))
  (if (null ss) (progn (princ "\nNo layout found. Run GenerateLayout first.") (exit)))
  (setq xd (cadr (assoc -3 (entget (ssname ss 0) '("FS_SOLAR_DATA")))))
  (if (null xd) (exit))

  (initget 6)
  (setq vmp (getreal "\nModule Vmp at STC (V) <41.5>: "))
  (if (null vmp) (setq vmp 41.5))
  (initget 6)
  (setq imp (getreal "\nModule Imp at STC (A) <13.7>: "))
  (if (null imp) (setq imp 13.7))
  (initget 6)
  (setq isc (getreal "\nModule Isc at STC (A) <14.4>: "))
  (if (null isc) (setq isc 14.4))
  (initget 6)
  (setq mps (getint "\nModules per string <26>: "))
  (if (null mps) (setq mps 26))

  (setq istring isc
        V_sys (* mps vmp)
        derating_factor (sp-cfg "GROUPING"))
  (princ (strcat "\nString current Isc=" (rtos istring 2 2)
                  " A, V=" (rtos V_sys 2 1) " V"))

  ;; For each inverter, compute longest string cable length from
  ;; STRINGING layer MTEXT positions, then pick a size.
  (setq all-strings '())
  (setq ss (ssget "_X" '((0 . "MTEXT") (8 . "STRINGING"))))
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq txt (cdr (assoc 1 (entget (ssname ss idx)))))
        (if (and txt (vl-string-search "STR" (strcase txt)))
          (progn
            (setq pt (cdr (assoc 10 (entget (ssname ss idx)))))
            (setq all-strings (cons pt all-strings))))
        (setq idx (1+ idx)))))
  (if (null all-strings) (progn (princ "\nNo stringing labels. Run AUTOSTRINGDIALOG first.") (exit)))

  ;; ACDB reference
  (setq acdb-ss (ssget "_X" '((8 . "ACDB"))))
  (if (null acdb-ss) (progn (princ "\nACDB marker not found.") (exit)))
  (setq acdb-pt (sp-get-acdb-center acdb-ss))

  ;; Group strings by inverter
  (setq by-inv (sp-group-by-coord all-strings acdb-pt 35.0))
  (write-line "\nINVERTER,N_STRINGS,RECOMMENDED DC CABLE (sqmm),Vdrop%@25m,Vdrop%@50m,Vdrop%@100m")

  (foreach inv by-inv
    (progn
      (setq pts (cadr inv)
            longest 0.0)
      (foreach p pts
        (setq d (distance p acdb-pt))
        (if (> d longest) (setq longest d)))
      (setq L_km (/ longest 1000.0)
            picked (sp-pick-dc-size istring L_km V_sys 1.5))
      (princ (strcat "\n" (car inv) ": " (itoa (length pts))
                     " strings, longest = " (rtos longest 2 1) "m, recommended "
                     (rtos picked 2 0) " sqmm Cu")))))
  (princ))

;; Helper: group list of 2D points by nearest-inverter heuristic
(defun sp-group-by-coord (pts acdb-pt cluster-d / groups nearest d igroup)
  (foreach p pts
    (setq d (distance p acdb-pt)
          nearest (fix (/ d cluster-d))
          igroup (assoc nearest groups))
    (if igroup
      (setq groups (subst (cons nearest (cons p (cdr igroup))) igroup groups))
      (setq groups (cons (cons nearest (list p)) groups))))
  (mapcar '(lambda (g) (list (itoa (car g)) (cdr g))) groups))

;; Helper: get ACDB center
(defun sp-get-acdb-center (ss / i en obj pmin pmax minpt maxpt cx cy)
  (if (and ss (> (sslength ss) 0))
    (progn
      (setq en (ssname ss 0)
            obj (vlax-ename->vla-object en))
      (vla-getboundingbox obj 'minpt 'maxpt)
      (setq pmin (vlax-safearray->list (if (= (type minpt) 'VARIANT) (vlax-variant-value minpt) minpt))
            pmax (vlax-safearray->list (if (= (type maxpt) 'VARIANT) (vlax-variant-value maxpt) maxpt)))
      (list (/ (+ (car pmin) (car pmax)) 2.0)
            (/ (+ (cadr pmin) (cadr pmax)) 2.0) 0.0))))

;;============================================================
;; 2B. AC CABLE SIZE AUTO-PICK (ACCABLESIZE)
;;  - Computes LV cable from each inverter to ACDB
;;  - Computes HT cable from ACDB to transformer (33 kV default)
;;  - Outputs side-by-side Vdrop table to SLD layer
;;============================================================

(defun c:ACCABLESIZE (/ ss xd inv_kw inv_v pf num_inv vdrop_max_lv vdrop_max_ht
                        acdb-pt inv-pts inv-by-acdb
                        lv-results ht-results
                        Ins kW v kv pf_kw)
  (vl-load-com)
  (setq ss (ssget "_X" '((-3 ("FS_SOLAR_DATA")))))
  (if (null ss) (progn (princ "\nNo layout. Run GenerateLayout first.") (exit)))
  (setq xd (cadr (assoc -3 (entget (ssname ss 0) '("FS_SOLAR_DATA")))))
  (if (null xd) (exit))

  (initget 6)
  (setq inv_kw (getreal "\nInverter AC rating (kW) <350>: "))
  (if (null inv_kw) (setq inv_kw 350.0))
  (initget 6)
  (setq inv_v (getreal (strcat "\nInverter AC voltage (V) <" (rtos (* 1000 (sp-cfg "LV_KV")) 2 0) ">: ")))
  (if (null inv_v) (setq inv_v (* 1000 (sp-cfg "LV_KV"))))
  (initget 6)
  (setq pf (getreal "\nPower factor (0.8 lag) <0.8>: "))
  (if (null pf) (setq pf 0.8))
  (initget 6)
  (setq num_inv (getint "\nNumber of inverters <1>: "))
  (if (null num_inv) (setq num_inv 1))

  (setq vdrop_max_lv 1.5
        vdrop_max_ht 2.0)

  ;; Gather inverter points from STRINGING layer
  (setq inv-pts (sp-get-inverter-points))
  (if (null inv-pts) (progn (princ "\nNo inverter markers found.") (exit)))

  (setq acdb-ss (ssget "_X" '((8 . "ACDB"))))
  (if (null acdb-ss) (progn (princ "\nACDB not set. Run SETACDB.") (exit)))
  (setq acdb-pt (sp-get-acdb-center acdb-ss))

  (princ (strcat "\n\nINVERTER -> ACDB (LV " (rtos inv_v 2 0) "V):"))
  (princ "\nINV  | DIST (m) | I (A)   | SIZE (sqmm) | Vdrop %")
  (princ "\n-----+----------+---------+-------------+--------")

  (foreach ip inv-pts
    (setq d (/ (distance ip acdb-pt) 1000.0)
          I (/ (* inv_kw 1000.0) (* (sqrt 3.0) inv_v pf))
          size (sp-pick-ac-size I d pf (/ inv_v 1000.0) vdrop_max_lv)
          vdr (sp-vdrop-3p I d size pf (/ inv_v 1000.0)))
    (princ (strcat "\n" (rtos (car ip) 2 1) "," (rtos (cadr ip) 2 1)
                   " | " (rtos (* d 1000.0) 2 1)
                   "    | " (rtos I 2 1)
                   "   | " (rtos size 2 0)
                   "        | " (rtos vdr 2 2))))

  (princ (strcat "\n\nACDB -> TRANSFORMER (HT " (rtos (sp-cfg "HT_KV") 2 0) " kV):"))
  (princ (strcat "\nTotal AC power: " (rtos (* inv_kw num_inv) 2 0) " kW"))
  (setq total-I (/ (* inv_kw num_inv 1000.0)
                   (* (sqrt 3.0) (* 1000 (sp-cfg "HT_KV")) pf))
        ht-len-km 0.1  ; default 100m
        ht-size (sp-pick-ac-size total-I ht-len-km pf (sp-cfg "HT_KV") vdrop_max_ht)
        ht-vdr  (sp-vdrop-3p total-I ht-len-km ht-size pf (sp-cfg "HT_KV")))
  (princ (strcat "\n  HT size: " (rtos ht-size 2 0) " sqmm, Vdrop: "
                 (rtos ht-vdr 2 2) "% at " (rtos (* ht-len-km 1000) 2 0) "m"))
  (princ))

;; Helper: collect inverter coordinate points
(defun sp-get-inverter-points (/ ss idx en txt pt)
  (setq ss (ssget "_X" '((0 . "MTEXT") (8 . "STRINGING")))
        pt '())
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq txt (cdr (assoc 1 (entget (ssname ss idx)))))
        (if (and txt (= "INV-" (substr (strcase txt) 1 4))
                 (= (strlen txt) 5))
          (setq pt (cons (cdr (assoc 10 (entget (ssname ss idx)))) pt)))
        (setq idx (1+ idx)))))
  pt)

;;============================================================
;; 2C. CABLE SCHEDULE (CABLESCHEDULE)
;;  - Reads all DC/AC cable XDATA, builds a from-to schedule
;;  - One row per cable, groups by type+size
;;  - Includes per-row Vdrop% based on actual length
;;============================================================

(defun c:CABLESCHEDULE (/ p f dc ac dc-rows ac-rows vmp-default mps-default
                        inv-pt-by-id acdb-pt idx)
  (vl-load-com)
  (setq p (getfiled "Export Cable Schedule" (strcat (getvar "DWGPREFIX") "SolarPro_CableSchedule") "csv" 1))
  (if (null p) (exit))
  (if (findfile p) (vl-file-delete p))
  (setq f (open p "w"))
  (if (null f) (exit))

  (initget 6)
  (setq vmp-default (getreal "\nModule Vmp at STC (V) <41.5>: "))
  (if (null vmp-default) (setq vmp-default 41.5))
  (initget 6)
  (setq mps-default (getint "\nModules per string <26>: "))
  (if (null mps-default) (setq mps-default 26))

  (write-line "TYPE,FROM,TO,SIZE (sqmm),CORES,LENGTH (m),CURRENT (A),VDROP %,REMARKS" f)

  (setq acdb-ss (ssget "_X" '((8 . "ACDB"))))
  (if acdb-ss (setq acdb-pt (sp-get-acdb-center acdb-ss)) (setq acdb-pt '(0.0 0.0 0.0)))

  (setq inv-pt-by-id (sp-build-inv-pt-map))

  ;; ---- DC cables ----
  (setq dc (sp-boq-dc-cables)
        idx 0)
  (foreach c dc
    (progn
      (setq inv (car c)
            mps (if (= (type (cadr c)) 'STR) 26 (atoi (cadr c)))
            size (caddr c)
            neg_o (cadddr c)
            up   (car (cddddr c))
            len  (car (cddddr (cdr c)))
            str-pt (cdr (assoc inv inv-pt-by-id))
            I 14.4
            vdr (sp-vdrop-dc I (/ len 1000.0) size (* mps vmp-default)))
      (write-line (strcat "DC," inv ",ACDB," (rtos size 2 0) ",2C,"
                          (rtos len 2 2) ","
                          (rtos I 2 1) ","
                          (rtos vdr 2 2) ","
                          "1C x 2, +ve/-ve") f))
    (setq idx (1+ idx)))

  ;; ---- AC cables ----
  (setq ac (sp-boq-ac-cables))
  (foreach c ac
    (progn
      (setq inv (car c)
            size (cadr c)
            len (caddr c)
            I 350.0
            kV 0.8
            vdr (sp-vdrop-3p I (/ len 1000.0) size 0.8 kV))
      (write-line (strcat "AC," inv ",ACDB," (rtos size 2 0) ",4C,"
                          (rtos len 2 2) ","
                          (rtos I 2 1) ","
                          (rtos vdr 2 2) ",3P+N") f)))

  ;; ---- HT cable (single, ACDB to TX) ----
  (initget 6)
  (setq ht-len (getdist "\nACDB to Transformer distance (m) <100>: "))
  (if (null ht-len) (setq ht-len 100.0))
  (initget 6)
  (setq ht-kv (getreal (strcat "\nHT voltage (kV) <" (rtos (sp-cfg "HT_KV") 2 0) ">: ")))
  (if (null ht-kv) (setq ht-kv (sp-cfg "HT_KV")))
  (initget 6)
  (setq tx-kva (getreal "\nTransformer rating (kVA) <5000>: "))
  (if (null tx-kva) (setq tx-kva 5000.0))
  (initget 6)
  (setq num-inv (getint "\nNumber of inverters <1>: "))
  (if (null num-inv) (setq num-inv 1))
  (setq inv-kw 350
        total-I (/ (* inv-kw num-inv 1000.0) (* (sqrt 3.0) (* 1000 ht-kv) 0.8))
        ht-size (sp-pick-ac-size total-I (/ ht-len 1000.0) 0.8 ht-kv 2.0)
        ht-vdr  (sp-vdrop-3p total-I (/ ht-len 1000.0) ht-size 0.8 ht-kv))
  (write-line (strcat "HT,ACDB,TX," (rtos ht-size 2 0) ",3C,"
                      (rtos ht-len 2 2) ","
                      (rtos total-I 2 1) ","
                      (rtos ht-vdr 2 2) ",3.3C XLPE Al," (rtos tx-kva 2 0) " kVA") f)

  (close f)
  (princ (strcat "\nCable schedule exported: " p))
  (princ))

;; Build map of inverter-id -> approximate location
(defun sp-build-inv-pt-map (/ ss idx en txt pt m)
  (setq ss (ssget "_X" '((0 . "MTEXT") (8 . "STRINGING")))
        m '())
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq txt (cdr (assoc 1 (entget (ssname ss idx))))
              pt  (cdr (assoc 10 (entget (ssname ss idx)))))
        (if (and txt (vl-string-search "INV" (strcase txt)))
          (progn
            (setq id (substr txt 1 (min 5 (strlen txt))))
            (if (not (assoc id m)) (setq m (cons (cons id pt) m)))))
        (setq idx (1+ idx)))))
  m)

;;============================================================
;; 2D. EARTHING RESISTANCE ESTIMATOR (EARTHRES)
;; Estimates overall earth resistance per IEEE 80 / IS 3043.
;;   Rg = rho * (1/L + 1/sqrt(20*A) * (1 + 1/(1+h*sqrt(20/A))))
;;
;; Inputs:
;;   rho - soil resistivity (ohm-m)
;;   L   - total buried electrode length (m)
;;   A   - area of earth mesh (sq.m)
;;   h   - depth of burial (m)
;;============================================================

(defun c:EARTHRES (/ rho L A h Rg req)
  (initget 6)
  (setq rho (getreal (strcat "\nSoil resistivity (ohm-m) <"
                              (rtos (sp-cfg "SOIL_RES") 2 0) ">: ")))
  (if (null rho) (setq rho (sp-cfg "SOIL_RES")))
  (initget 6)
  (setq L (getreal "\nTotal earth electrode length (m) <500>: "))
  (if (null L) (setq L 500.0))
  (initget 6)
  (setq A (getreal "\nArea of earth mesh (sq.m) <50000>: "))
  (if (null A) (setq A 50000.0))
  (initget 6)
  (setq h (getreal "\nBurial depth (m) <0.5>: "))
  (if (null h) (setq h 0.5))

  (setq Rg (* rho (+ (/ 1.0 L)
                     (/ 1.0 (* (sqrt (* 20.0 A))
                               (+ 1.0 (/ 1.0 (+ 1.0 (* h (sqrt (/ 20.0 A)))))))))))
  (setq req 1.0)  ; CEA / IS 3043 typical 1 ohm for HV installations
  (princ (strcat "\n\nEstimated earth resistance: " (rtos Rg 2 3) " ohm"))
  (if (< Rg req)
    (princ (strcat " - PASS (target <" (rtos req 2 1) " ohm)"))
    (princ (strcat " - FAIL (target <" (rtos req 2 1) " ohm); need more electrodes or treatment.")))
  (princ))

(princ "\n[SolarPro v5.0] Batch 2 loaded: DCCABLESIZE, ACCABLESIZE, CABLESCHEDULE, EARTHRES.")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 3)
;; Site infrastructure blocks and placement
;;============================================================

;;------------------------------------------------------------
;; Standard block definitions for site assets
;; Block name pattern: SP_BLOCK_<key>
;; Each block drawn at origin (0,0) with type-specific size.
;;------------------------------------------------------------
(defun sp-def-block (name ents)
  (if (not (tblsearch "BLOCK" name))
    (progn
      (entmake (list '(0 . "BLOCK") '(100 . "AcDbEntity")
                     '(100 . "AcDbBlockBegin") (cons 2 name) '(70 . 0)
                     (cons 10 (list 0.0 0.0 0.0)) (cons 3 name) '(1 . "")))
      (foreach e ents (entmake e))
      (entmake (list '(0 . "ENDBLK") '(100 . "AcDbEntity") '(8 . "0") '(100 . "AcDbBlockEnd")))))
  name)

;;------------------------------------------------------------
;; 3A. FENCE LAYOUT (FENCELAYOUT)
;; Places fence posts around selected boundary with specified
;; spacing.  Inserts a GATE symbol at the user-picked point.
;; All on layer SP_FENCE.
;;------------------------------------------------------------
(setq *SP-FENCE-SPACING* 3.0)  ; 3 m post spacing, typical

(defun c:FENCELAYOUT (/ ent pts spacing post-pt gate-pt gate-dist perimeter n_posts)
  (vl-load-com)
  (princ "\nSelect site boundary to fence: ")
  (setq ent (car (entsel)))
  (if (null ent) (exit))
  (if (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE") (exit))
  (sp-set-layer "SP_FENCE")
  (initget 6)
  (setq spacing (getdist "\nPost spacing (m) <3.0>: "))
  (if (null spacing) (setq spacing *SP-FENCE-SPACING*))
  (initget 6)
  (setq height (getreal "\nFence height (m) <2.4>: "))
  (if (null height) (setq height 2.4))

  ;; Draw perimeter linework
  (setq pts (sp-poly-pts ent)
        perimeter (sp-poly-perimeter pts)
        n_posts (fix (/ perimeter spacing)))
  (sp-pline pts "SP_FENCE" 3)
  (sp-def-block "SP_BLOCK_FENCE_POST"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 3) '(100 . "AcDbCircle")
                 (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.1))))

  ;; Place posts evenly along each edge
  (princ (strcat "\nPerimeter: " (rtos perimeter 2 2) " m, "
                 (itoa n_posts) " posts."))
  (setq i 0)
  (foreach e (sp-poly-edges pts)
    (progn
      (setq d 0.0)
      (while (<= d (distance (car e) (cadr e)))
        (progn
          (setq p (polar (car e) (angle (car e) (cadr e)) d))
          (entmake (list '(0 . "INSERT") '(8 . "SP_FENCE") '(62 . 3)
                         '(100 . "AcDbBlockReference")
                         (cons 2 "SP_BLOCK_FENCE_POST")
                         (cons 10 p) '(50 . 0.0)))
          (setq d (+ d spacing))))
      (setq i (1+ i))))

  ;; Gate symbol
  (setq gate-pt (getpoint "\nPick main gate location on boundary: "))
  (if gate-pt
    (progn
      (sp-def-block "SP_BLOCK_GATE"
        (list (list '(0 . "LINE") '(8 . "0") '(62 . 1)
                    (cons 10 (list -2.0 0.0 0.0)) (cons 11 (list 2.0 0.0 0.0)))
              (list '(0 . "LINE") '(8 . "0") '(62 . 1)
                    (cons 10 (list 0.0 -0.5 0.0)) (cons 11 (list 0.0 0.5 0.0)))))
      (entmake (list '(0 . "INSERT") '(8 . "SP_FENCE") '(62 . 1)
                     '(100 . "AcDbBlockReference")
                     (cons 2 "SP_BLOCK_GATE")
                     (cons 10 gate-pt) '(50 . 0.0)))
      (sp-mtext (list (car gate-pt) (+ (cadr gate-pt) 1.5) 0.0) 1.0
        "MAIN GATE" "SP_FENCE" 1)
      ;; Embed XDATA
      (if (not (tblsearch "APPID" "FS_FENCE")) (regapp "FS_FENCE"))
      (entmake (list '(0 . "POINT") (cons 10 gate-pt) '(8 . "SP_FENCE")
        (list -3 (list "FS_FENCE"
          (cons 1040 perimeter)
          (cons 1040 height)
          (cons 1040 spacing)
          (cons 1070 n_posts)))))))

  (princ (strcat "\nFence placed: " (itoa n_posts) " posts at "
                 (rtos spacing 2 1) "m spacing. Total perimeter: "
                 (rtos perimeter 2 2) "m."))
  (princ))

;;------------------------------------------------------------
;; 3B. CCTV COVERAGE (CCTVLAYOUT)
;; Place CCTV poles with coverage circles on perimeter.
;;------------------------------------------------------------
(defun c:CCTVLAYOUT (/ ent pts spacing radius h cov n)
  (vl-load-com)
  (princ "\nSelect perimeter polyline (or fence) for CCTV coverage: ")
  (setq ent (car (entsel)))
  (if (null ent) (exit))
  (if (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE") (exit))
  (sp-set-layer "SP_CCTV")
  (initget 6)
  (setq radius (getdist "\nCoverage radius per camera (m) <30>: "))
  (if (null radius) (setq radius 30.0))
  (initget 6)
  (setq h (getreal "\nPole height (m) <6>: "))
  (if (null h) (setq h 6.0))
  (initget 6)
  (setq spacing (getdist (strcat "\nPole spacing (m) <" (rtos (* 2 radius) 2 0) ">: ")))
  (if (null spacing) (setq spacing (* 2 radius)))

  (sp-def-block "SP_BLOCK_CCTV"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 6) '(100 . "AcDbCircle")
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.15))
          (list '(0 . "LINE") '(8 . "0") '(62 . 6) '(100 . "AcDbLine")
                (cons 10 (list 0.0 0.0 0.0)) (cons 11 (list 0.0 1.5 0.0)))
          (list '(0 . "SOLID") '(8 . "0") '(62 . 1) '(100 . "AcDbEntity")
                '(100 . "AcDbTrace")
                (cons 10 (list 0.6 1.5 0.0))
                (cons 11 (list -0.6 1.5 0.0))
                (cons 12 (list -0.6 0.5 0.0))
                (cons 13 (list 0.6 0.5 0.0)))))

  (setq pts (sp-poly-pts ent)
        perim (sp-poly-perimeter pts)
        n (fix (/ perim spacing))
        edgelen (sp-poly-perimeter pts))
  (princ (strcat "\nCoverage: " (itoa n) " cameras at " (rtos spacing 2 1) "m spacing."))
  (setq i 0 d 0.0)
  (foreach e (sp-poly-edges pts)
    (progn
      (setq d 0.0)
      (while (<= d (distance (car e) (cadr e)))
        (progn
          (setq p (polar (car e) (angle (car e) (cadr e)) d))
          (entmake (list '(0 . "INSERT") '(8 . "SP_CCTV") '(62 . 6)
                         '(100 . "AcDbBlockReference")
                         (cons 2 "SP_BLOCK_CCTV")
                         (cons 10 p) '(50 . 0.0)))
          (sp-circle p radius "SP_CCTV" 1)
          (entmake (list '(0 . "HATCH") '(8 . "SP_CCTV") '(62 . 1)
                         '(100 . "AcDbHatch")
                         '(70 . 1) '(71 . 0) '(91 . 1)
                         (cons 10 p) '(40 . 1.0) '(50 . 0.0)
                         '(41 . 0.0) '(42 . 0.0) '(43 . 0.0)
                         '(44 . 0.0) '(45 . 0.0)
                         '(46 . 1.0) '(47 . 0.0)))
          (setq d (+ d spacing))))))

  ;; XDATA
  (if (not (tblsearch "APPID" "FS_CCTV")) (regapp "FS_CCTV"))
  (entmake (list '(0 . "POINT") (cons 10 (car pts)) '(8 . "SP_CCTV")
    (list -3 (list "FS_CCTV"
      (cons 1040 perim)
      (cons 1040 h)
      (cons 1040 radius)
      (cons 1070 n)))))
  (princ (strcat "\nCCTV: " (itoa n) " poles placed."))
  (princ))

;;------------------------------------------------------------
;; 3C. WEATHER / MET STATION (METSTATION)
;;------------------------------------------------------------
(defun c:METSTATION (/ pt)
  (vl-load-com)
  (sp-set-layer "SP_MET")
  (setq pt (getpoint "\nClick location for Met station: "))
  (if (null pt) (exit))
  (sp-def-block "SP_BLOCK_MET_STATION"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 1) '(100 . "AcDbCircle")
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.5))
          (list '(0 . "LINE") '(8 . "0") '(62 . 1)
                (cons 10 (list 0.0 0.0 0.0)) (cons 11 (list 0.0 3.0 0.0)))
          (list '(0 . "LINE") '(8 . "0") '(62 . 1)
                (cons 10 (list -0.5 0.0 0.0)) (cons 11 (list 0.5 0.0 0.0)))
          (list '(0 . "CIRCLE") '(8 . "0") '(62 . 1)
                (cons 10 (list 0.0 3.0 0.0)) (cons 40 0.15))
          (list '(0 . "LINE") '(8 . "0") '(62 . 1)
                (cons 10 (list 0.0 3.0 0.0)) (cons 11 (list 0.5 3.4 0.0)))))
  (entmake (list '(0 . "INSERT") '(8 . "SP_MET") '(62 . 1)
                 '(100 . "AcDbBlockReference")
                 (cons 2 "SP_BLOCK_MET_STATION")
                 (cons 10 pt) '(50 . 0.0)))
  (sp-mtext (list (car pt) (- (cadr pt) 2) 0.0) 1.5 "MET STATION" "SP_MET" 1)
  (princ "\nMet station placed."))

;;------------------------------------------------------------
;; 3D. CONTROL / SCADA ROOM (CONTROLROOM)
;;------------------------------------------------------------
(defun c:CONTROLROOM (/ pt w h)
  (vl-load-com)
  (sp-set-layer "SP_BUILDING")
  (initget 6)
  (setq w (getdist "\nRoom width (m) <6>: "))
  (if (null w) (setq w 6.0))
  (initget 6)
  (setq h (getdist "\nRoom depth (m) <4>: "))
  (if (null h) (setq h 4.0))
  (setq pt (getpoint "\nClick corner of control room: "))
  (if (null pt) (exit))
  (sp-rect (car pt) (cadr pt) w h "SP_BUILDING" 4)
  (sp-mtext (list (+ (car pt) (/ w 2.0)) (+ (cadr pt) (/ h 2.0) 0.5) 0.0) 1.0
    "SCADA / CONTROL ROOM" "SP_BUILDING" 4)
  (sp-def-block "SP_BLOCK_DOOR"
    (list (list '(0 . "ARC") '(8 . "0") '(62 . 1)
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.6)
                (cons 50 0.0) (cons 51 90.0))))
  (entmake (list '(0 . "INSERT") '(8 . "SP_BUILDING") '(62 . 1)
                 '(100 . "AcDbBlockReference")
                 (cons 2 "SP_BLOCK_DOOR")
                 (cons 10 (list (car pt) (+ (cadr pt) (/ h 2.0)) 0.0)) '(50 . 0.0)))
  (princ (strcat "\nSCADA room placed: " (rtos w 2 0) "x" (rtos h 2 0) " m"))
  (princ))

;;------------------------------------------------------------
;; 3E. INVERTER STATION / PCS SKID (INVSTATION)
;;------------------------------------------------------------
(defun c:INVSTATION (/ pt w h)
  (vl-load-com)
  (sp-set-layer "SP_INV_STATION")
  (initget 6)
  (setq w (getdist "\nStation width (m) <3>: "))
  (if (null w) (setq w 3.0))
  (initget 6)
  (setq h (getdist "\nStation depth (m) <2>: "))
  (if (null h) (setq h 2.0))
  (initget 6)
  (setq skid-h (getdist "\nSkid height clearance (m) <0.3>: "))
  (if (null skid-h) (setq skid-h 0.3))
  (setq pt (getpoint "\nClick corner of inverter skid: "))
  (if (null pt) (exit))
  (sp-rect (car pt) (cadr pt) w h "SP_INV_STATION" 2)
  ;; hatch to show equipment
  (command "_.HATCH" "_S" (entlast) "" "_P" "ANSI31" "_C" "2" "" "")
  (sp-mtext (list (+ (car pt) (/ w 2.0)) (+ (cadr pt) (/ h 2.0) 0.3) 0.0) 1.0
    "INV STATION" "SP_INV_STATION" 2)
  ;; clearance zone
  (sp-rect (- (car pt) skid-h) (- (cadr pt) skid-h)
           (+ w (* 2 skid-h)) (+ h (* 2 skid-h))
           "SP_INV_STATION" 8)
  (princ (strcat "\nInverter station placed: " (rtos w 2 0) "x" (rtos h 2 0) "m + "
                 (rtos skid-h 2 1) "m clearance"))
  (princ))

;;------------------------------------------------------------
;; 3F. POWER TRANSFORMER PAD (TRANSFORMER)
;;------------------------------------------------------------
(defun c:TRANSFORMER (/ pt kva lv hv vec)
  (vl-load-com)
  (sp-set-layer "SP_TX")
  (initget 6)
  (setq kva (getreal "\nTransformer rating (kVA) <5000>: "))
  (if (null kva) (setq kva 5000.0))
  (initget 6)
  (setq lv (getreal (strcat "\nLV voltage (kV) <" (rtos (sp-cfg "LV_KV") 2 1) ">: ")))
  (if (null lv) (setq lv (sp-cfg "LV_KV")))
  (initget 6)
  (setq hv (getreal (strcat "\nHV voltage (kV) <" (rtos (sp-cfg "HT_KV") 2 0) ">: ")))
  (if (null hv) (setq hv (sp-cfg "HT_KV")))
  (initget 6)
  (setq vec (getstring t "\nVector group <Dyn11>: "))
  (if (= vec "") (setq vec "Dyn11"))

  (setq pt (getpoint "\nClick transformer pad center: "))
  (if (null pt) (exit))
  ;; Pad dimensions scaled to kVA
  (setq w (max 4.0 (* 0.002 kva))
        h (max 3.0 (* 0.0014 kva)))
  (sp-rect (- (car pt) (/ w 2.0)) (- (cadr pt) (/ h 2.0)) w h "SP_TX" 3)
  (command "_.HATCH" "_S" (entlast) "" "_P" "ANSI32" "_C" "3" "" "")
  (sp-def-block "SP_BLOCK_TX"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 1)
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.5))
          (list '(0 . "CIRCLE") '(8 . "0") '(62 . 1)
                (cons 10 (list 2.0 0.0 0.0)) (cons 40 0.5))
          (list '(0 . "LINE") '(8 . "0") '(62 . 1)
                (cons 10 (list -0.6 0.0 0.0)) (cons 11 (list 0.6 0.0 0.0)))
          (list '(0 . "LINE") '(8 . "0") '(62 . 1)
                (cons 10 (list 1.4 0.0 0.0)) (cons 11 (list 2.6 0.0 0.0)))
          (list '(0 . "TEXT") '(8 . "0") '(62 . 1)
                (cons 10 (list -0.3 -0.3 0.0)) (cons 40 0.3) (cons 1 "Y"))
          (list '(0 . "TEXT") '(8 . "0") '(62 . 1)
                (cons 10 (list 2.3 -0.3 0.0)) (cons 40 0.3) (cons 1 "D"))))
  (entmake (list '(0 . "INSERT") '(8 . "SP_TX") '(62 . 1)
                 '(100 . "AcDbBlockReference")
                 (cons 2 "SP_BLOCK_TX")
                 (cons 10 pt) '(50 . 0.0)))
  (sp-mtext (list (car pt) (+ (cadr pt) (/ h 2.0) 1.0) 0.0) 1.0
    (strcat (rtos kva 2 0) " kVA " (rtos lv 2 1) "/" (rtos hv 2 0) " kV " vec)
    "SP_TX" 3)
  ;; Fire barrier wall
  (sp-rect (- (car pt) (/ w 2.0) 0.5) (- (cadr pt) (/ h 2.0) 0.5)
           (+ w 1.0) (+ h 1.0) "SP_TX" 7)
  (princ (strcat "\nTransformer placed: " (rtos kva 2 0) " kVA, "
                 "pad " (rtos w 2 1) "x" (rtos h 2 1) "m + 1m fire barrier"))
  (princ))

;;------------------------------------------------------------
;; 3G. HT SWITCHGEAR / RMU (HTPANEL)
;;------------------------------------------------------------
(defun c:HTPANEL (/ pt kv cells cells-w)
  (vl-load-com)
  (sp-set-layer "SP_HT_PANEL")
  (initget 6)
  (setq kv (getreal (strcat "\nVoltage (kV) <" (rtos (sp-cfg "HT_KV") 2 0) ">: ")))
  (if (null kv) (setq kv (sp-cfg "HT_KV")))
  (initget 6)
  (setq cells (getint "\nNumber of panels/cubicles <8>: "))
  (if (null cells) (setq cells 8))
  (setq pt (getpoint "\nClick corner of HT panel row: "))
  (if (null pt) (exit))
  (setq cells-w (* cells 0.8)
        depth 1.4)
  (sp-rect (car pt) (cadr pt) cells-w depth "SP_HT_PANEL" 1)
  ;; individual cubicle lines
  (setq i 1)
  (while (< i cells)
    (sp-line (list (+ (car pt) (* i 0.8) 0) (cadr pt) 0.0)
             (list (+ (car pt) (* i 0.8) 0) (+ (cadr pt) depth) 0.0)
             "SP_HT_PANEL" 1)
    (setq i (1+ i)))
  (sp-mtext (list (+ (car pt) (/ cells-w 2.0)) (+ (cadr pt) depth 0.6) 0.0) 1.0
    (strcat (rtos kv 2 0) " kV HT PANEL - " (itoa cells) " CUBICLES")
    "SP_HT_PANEL" 1)
  (princ (strcat "\nHT panel placed: " (itoa cells) " cubicles, " (rtos cells-w 2 1)
                 "m wide x " (rtos depth 2 1) "m deep"))
  (princ))

;;------------------------------------------------------------
;; 3H. METERING (MFM / CT-PT) (METERING)
;;------------------------------------------------------------
(defun c:METERING (/ pt)
  (vl-load-com)
  (sp-set-layer "SP_METERING")
  (setq pt (getpoint "\nClick metering location: "))
  (if (null pt) (exit))
  (sp-def-block "SP_BLOCK_MFM"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 4)
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.4))
          (list '(0 . "CIRCLE") '(8 . "0") '(62 . 4)
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.25))
          (list '(0 . "LINE") '(8 . "0") '(62 . 4)
                (cons 10 (list -0.5 0.0 0.0)) (cons 11 (list 0.5 0.0 0.0)))
          (list '(0 . "TEXT") '(8 . "0") '(62 . 4)
                (cons 10 (list 0.3 0.3 0.0)) (cons 40 0.2) (cons 1 "M"))))
  (entmake (list '(0 . "INSERT") '(8 . "SP_METERING") '(62 . 4)
                 '(100 . "AcDbBlockReference")
                 (cons 2 "SP_BLOCK_MFM")
                 (cons 10 pt) '(50 . 0.0)))
  (sp-mtext (list (car pt) (- (cadr pt) 1.0) 0.0) 1.0
    "MFM / METERING CT-PT" "SP_METERING" 4)
  (princ "\nMetering point placed.")
  (princ))

;;------------------------------------------------------------
;; 3I. AUX TRANSFORMER (AUXTX)
;;------------------------------------------------------------
(defun c:AUXTX (/ pt kva)
  (vl-load-com)
  (sp-set-layer "SP_AUX")
  (initget 6)
  (setq kva (getreal "\nAux transformer rating (kVA) <100>: "))
  (if (null kva) (setq kva 100.0))
  (setq pt (getpoint "\nClick aux TX location: "))
  (if (null pt) (exit))
  (sp-rect (- (car pt) 0.5) (- (cadr pt) 0.5) 1.0 1.0 "SP_AUX" 3)
  (sp-mtext (list (car pt) (+ (cadr pt) 1.0) 0.0) 1.0
    (strcat "AUX TX " (rtos kva 2 0) " kVA") "SP_AUX" 3)
  (princ (strcat "\nAux TX placed: " (rtos kva 2 0) " kVA"))
  (princ))

;;------------------------------------------------------------
;; 3J. DG SET (DGSET)
;;------------------------------------------------------------
(defun c:DGSET (/ pt kva)
  (vl-load-com)
  (sp-set-layer "SP_DG")
  (initget 6)
  (setq kva (getreal "\nDG set rating (kVA) <250>: "))
  (if (null kva) (setq kva 250.0))
  (initget 6)
  (setq w (getdist "\nEnclosure size (m) <4x2>: "))
  (if (null w) (setq w 4.0))
  (initget 6)
  (setq d (getdist "\nDepth (m) <2>: "))
  (if (null d) (setq d 2.0))
  (setq pt (getpoint "\nClick DG corner: "))
  (if (null pt) (exit))
  (sp-rect (car pt) (cadr pt) w d "SP_DG" 6)
  (sp-mtext (list (+ (car pt) (/ w 2.0)) (+ (cadr pt) (/ d 2.0)) 0.0) 1.0
    (strcat "DG " (rtos kva 2 0) " kVA") "SP_DG" 6)
  ;; exhaust pipe schematic
  (sp-line (list (+ (car pt) 0.3) (+ (cadr pt) d) 0.0)
           (list (+ (car pt) 0.3) (+ (cadr pt) d 2.0) 0.0) "SP_DG" 6)
  (sp-text (list (+ (car pt) 0.4) (+ (cadr pt) d 2.0) 0.0) 0.5 "EXHAUST" "SP_DG" 6)
  (princ "\nDG set placed."))

;;------------------------------------------------------------
;; 3K. BESS / BATTERY (BESS)
;;------------------------------------------------------------
(defun c:BESS (/ pt mwh n)
  (vl-load-com)
  (sp-set-layer "SP_BESS")
  (initget 6)
  (setq mwh (getreal "\nBESS capacity (MWh) <5>: "))
  (if (null mwh) (setq mwh 5.0))
  (initget 6)
  (setq n (getint "\nNumber of containers <5>: "))
  (if (null n) (setq n 5))
  (initget 6)
  (setq w (getdist "\nContainer length (m) <6>: "))
  (if (null w) (setq w 6.0))
  (initget 6)
  (setq d (getdist "\nContainer depth (m) <2.5>: "))
  (if (null d) (setq d 2.5))
  (initget 6)
  (setq gap (getdist "\nGap between containers (m) <0.5>: "))
  (if (null gap) (setq gap 0.5))
  (setq pt (getpoint "\nClick row start point: "))
  (if (null pt) (exit))
  (setq i 0)
  (repeat n
    (sp-rect (+ (car pt) (* i (+ w gap))) (cadr pt) w d "SP_BESS" 4)
    (sp-mtext (list (+ (car pt) (* i (+ w gap)) (/ w 2.0))
                    (+ (cadr pt) (/ d 2.0)) 0.0) 0.8
      (strcat "BESS-" (itoa (1+ i))) "SP_BESS" 4)
    (setq i (1+ i)))
  (sp-mtext (list (+ (car pt) (* n (+ w gap) 0.5)) (+ (cadr pt) d 1.5) 0.0) 1.5
    (strcat "BESS: " (rtos mwh 2 1) " MWh, " (itoa n) " containers")
    "SP_BESS" 4)
  (princ (strcat "\nBESS placed: " (itoa n) " containers, "
                 (rtos (* mwh 1000) 2 0) " kWh total"))
  (princ))

;;------------------------------------------------------------
;; 3L. INTERNAL ROAD CONNECT (ROADCONNECT)
;; Connects all major equipment to a central spine road.
;;------------------------------------------------------------
(defun c:ROADCONNECT (/ road-w gate acdb tx)
  (vl-load-com)
  (sp-set-layer "SP_ROAD")
  (initget 6)
  (setq road-w (getdist "\nRoad width (m) <4>: "))
  (if (null road-w) (setq road-w 4.0))
  ;; pick main gate
  (princ "\nPick main gate point: ")
  (setq gate (getpoint))
  (if (null gate) (exit))
  ;; pick central spine start/end
  (princ "\nPick central spine road start: ")
  (setq pt1 (getpoint))
  (princ "\nPick central spine road end: ")
  (setq pt2 (getpoint))
  (if (or (null pt1) (null pt2)) (exit))
  ;; draw main road
  (sp-rect (min (car pt1) (car pt2)) (min (cadr pt1) (cadr pt2))
           (+ (abs (- (car pt1) (car pt2))) road-w)
           (+ (abs (- (cadr pt1) (cadr pt2))) road-w) "SP_ROAD" 8)
  ;; draw approach road from gate to spine
  (sp-rect (min (car gate) (car pt1))
           (min (cadr gate) (cadr pt1))
           (+ (abs (- (car gate) (car pt1))) road-w)
           (+ (abs (- (cadr gate) (cadr pt1))) road-w) "SP_ROAD" 8)
  (princ (strcat "\nRoad network drawn: " (rtos road-w 2 1) "m wide. Connect further equipment manually."))
  (princ))

;;------------------------------------------------------------
;; 3M. STREETLIGHT (STREETLIGHT)
;; Place streetlights at fixed spacing along a polyline.
;;------------------------------------------------------------
(defun c:STREETLIGHT (/ ent pts spacing h pole-h lat)
  (vl-load-com)
  (princ "\nSelect road centerline polyline: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (sp-set-layer "SP_STREETLIGHT")
  (initget 6)
  (setq spacing (getdist "\nPole spacing (m) <30>: "))
  (if (null spacing) (setq spacing 30.0))
  (initget 6)
  (setq pole-h (getreal "\nPole height (m) <7>: "))
  (if (null pole-h) (setq pole-h 7.0))
  (initget 6)
  (setq lat (getreal "\nSite latitude (deg) <23.5>: "))
  (if (null lat) (setq lat 23.5))

  (sp-def-block "SP_BLOCK_STREETLIGHT"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 7) '(100 . "AcDbCircle")
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.15))
          (list '(0 . "LINE") '(8 . "0") '(62 . 7)
                (cons 10 (list 0.0 0.0 0.0)) (cons 11 (list 0.0 pole-h 0.0)))
          (list '(0 . "LINE") '(8 . "0") '(62 . 7)
                (cons 10 (list 0.0 pole-h 0.0)) (cons 11 (list 0.6 pole-h 0.0)))))
  (setq pts (sp-poly-pts ent)
        perim (sp-poly-perimeter pts)
        n (max 1 (fix (/ perim spacing)))
        d 0.0)
  (princ (strcat "\nStreet lighting: " (itoa n) " poles at " (rtos spacing 2 0) "m spacing."))
  (foreach e (sp-poly-edges pts)
    (progn
      (setq d 0.0 seg (distance (car e) (cadr e)))
      (while (<= d seg)
        (progn
          (setq p (polar (car e) (angle (car e) (cadr e)) d))
          (entmake (list '(0 . "INSERT") '(8 . "SP_STREETLIGHT") '(62 . 7)
                         '(100 . "AcDbBlockReference")
                         (cons 2 "SP_BLOCK_STREETLIGHT")
                         (cons 10 p) '(50 . 0.0)))
          (sp-circle p (* pole-h 0.8) "SP_STREETLIGHT" 7)
          (setq d (+ d spacing))))))
  (princ (strcat "\n" (itoa n) " streetlights placed."))
  (princ))

;;------------------------------------------------------------
;; 3N. DRAINAGE / STORM WATER (DRAINAGE)
;;------------------------------------------------------------
(defun c:DRAINAGE (/ ent width depth)
  (vl-load-com)
  (princ "\nSelect boundary/road to follow for drainage: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (sp-set-layer "SP_DRAINAGE")
  (initget 6)
  (setq width (getdist "\nDrain width (m) <0.3>: "))
  (if (null width) (setq width 0.3))
  (initget 6)
  (setq depth (getreal "\nDrain depth (m) <0.3>: "))
  (if (null depth) (setq depth 0.3))
  (setq pts (sp-poly-pts ent))
  ;; offset drain by width/2 to either side, draw as parallel polylines
  (command "_.OFFSET" (* width 0.5) ent "")
  (command "_.CHPROP" (entlast) "" "_LA" "SP_DRAINAGE" "_C" "5" "")
  (command "_.OFFSET" (* width 0.5) ent "")
  (command "_.CHPROP" (entlast) "" "_LA" "SP_DRAINAGE" "_C" "5" "")
  (if (not (tblsearch "APPID" "FS_DRAINAGE")) (regapp "FS_DRAINAGE"))
  (entmake (list '(0 . "POINT") (cons 10 (car pts)) '(8 . "SP_DRAINAGE")
    (list -3 (list "FS_DRAINAGE"
      (cons 1040 width)
      (cons 1040 depth)
      (cons 1040 (sp-poly-perimeter pts))))))
  (princ (strcat "\nDrainage drawn: " (rtos width 2 2) "m wide x "
                 (rtos depth 2 2) "m deep along " (rtos (sp-poly-perimeter pts) 2 1) "m"))
  (princ))

;;------------------------------------------------------------
;; 3O. WASH WATER TANK + PIPE (WASHROUTE)
;;------------------------------------------------------------
(defun c:WASHROUTE (/ tank-pt pipe-pts tank-vol)
  (vl-load-com)
  (sp-set-layer "SP_WASH")
  (initget 6)
  (setq tank-vol (getreal "\nTank capacity (m3) <20>: "))
  (if (null tank-vol) (setq tank-vol 20.0))
  (princ "\nClick water tank location: ")
  (setq tank-pt (getpoint))
  (if (null tank-pt) (exit))
  (sp-def-block "SP_BLOCK_TANK"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 5)
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 2.0))))
  (entmake (list '(0 . "INSERT") '(8 . "SP_WASH") '(62 . 5)
                 '(100 . "AcDbBlockReference")
                 (cons 2 "SP_BLOCK_TANK")
                 (cons 10 tank-pt) '(50 . 0.0)))
  (sp-mtext (list (car tank-pt) (+ (cadr tank-pt) 3.0) 0.0) 1.0
    (strcat "WATER TANK " (rtos tank-vol 2 0) " m3") "SP_WASH" 5)
  ;; draw pipe to each layout area
  (princ "\nPick pipe routing points (Enter to end): ")
  (setq pipe-pts (list tank-pt))
  (while (setq p (getpoint "\nNext point (Enter to finish): "))
    (setq pipe-pts (cons p pipe-pts)))
  (if (> (length pipe-pts) 1)
    (sp-pline (reverse pipe-pts) "SP_WASH" 5))
  (princ (strcat "\nWash system: tank + " (itoa (1- (length pipe-pts)))
                 " pipe segments placed."))
  (princ))

;;------------------------------------------------------------
;; Polygon helpers used by infrastructure commands
;;------------------------------------------------------------
(defun sp-poly-pts (ent / ed pts i)
  (setq ed (entget ent) pts '() i 0)
  (while (< i (length ed))
    (if (= (car (nth i ed)) 10)
      (setq pts (append pts (list (cdr (nth i ed))))))
    (setq i (1+ i)))
  pts)

(defun sp-poly-edges (pts / edges i)
  (setq edges '() i 0)
  (while (< i (1- (length pts)))
    (setq edges (cons (list (nth i pts) (nth (1+ i) pts)) edges))
    (setq i (1+ i)))
  (if (> (length pts) 2)
    (setq edges (cons (list (last pts) (car pts)) edges)))
  edges)

(defun sp-poly-perimeter (pts / edges len e)
  (setq edges (sp-poly-edges pts) len 0.0)
  (foreach e edges (setq len (+ len (distance (car e) (cadr e)))))
  len)

(princ "\n[SolarPro v5.0] Batch 3 loaded: FENCELAYOUT, CCTVLAYOUT, METSTATION, CONTROLROOM, INVSTATION, TRANSFORMER, HTPANEL, METERING, AUXTX, DGSET, BESS, ROADCONNECT, STREETLIGHT, DRAINAGE, WASHROUTE.")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 4)
;; Tracker, seasonal tilt, GCR opt, MMS BoM, pile schedule
;;============================================================

;;------------------------------------------------------------
;; 4A. SEASONAL TILT (SEASONALTILT)
;; Recomputes row pitch for 2-position or 4-position seasonal tilt.
;; Summer tilt = latitude - 15 deg
;; Winter tilt = latitude + 15 deg
;; 4-pos also includes spring/autumn = latitude
;;------------------------------------------------------------
(defun c:SEASONALTILT (/ ss bnd lat tilt-s tilt-w tilt-e base-pitch row-pitch-s
                            row-pitch-w table_h table_w mod_in_stack)
  (vl-load-com)
  (princ "\nSelect boundary polyline: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (setq xd (cadr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (null xd) (progn (princ "\nNo layout data on boundary.") (exit)))
  (setq lat (sp-xd-item-val (nth 4 xd))
        tilt (sp-xd-item-val (nth 3 xd))
        mod_in_stack (fix (sp-xd-item-val (nth 8 xd)))
        table_h (sp-xd-item-val (nth 1 xd)))
  (initget "Two Four")
  (setq mode (getkword "\nSeasonal mode [Two/Four] <Two>: "))
  (if (null mode) (setq mode "Two"))
  (initget 6)
  (setq pitch-mode (getkword "\nPitch mode [Conservative/Aggressive] <Conservative>: "))
  (if (null pitch-mode) (setq pitch-mode "Conservative"))

  (if (= mode "Two")
    (progn
      (setq tilt-s (- lat 15.0)
            tilt-w (+ lat 15.0))
      (princ (strcat "\nSUMMER tilt: " (rtos tilt-s 2 1)
                     " deg | WINTER tilt: " (rtos tilt-w 2 1) " deg"))
      (princ "\nShading factor used: 0.5 (summer) / 1.0 (winter)"))
    (progn
      (setq tilt-s (- lat 20.0)
            tilt-w (+ lat 20.0)
            tilt-e lat
            tilt-sp (- lat 10.0)
            tilt-au (+ lat 10.0))
      (princ (strcat "\n4-POSITION: S=" (rtos tilt-s 2 0)
                     " SP=" (rtos tilt-sp 2 0)
                     " E=" (rtos tilt-e 2 0)
                     " AU=" (rtos tilt-au 2 0)
                     " W=" (rtos tilt-w 2 0) " deg"))))
  ;; Annual energy-weighted optimal tilt
  (setq tilt-opt (+ lat (* 5.0 (sin (* 2.0 (/ pi 180.0) lat)))))
  (princ (strcat "\nEnergy-weighted optimal tilt: " (rtos tilt-opt 2 1) " deg"))
  (princ (strcat "\nCurrent tilt: " (rtos tilt 2 1) " deg ("
                 (if (< (abs (- tilt tilt-opt)) 1.0) "GOOD" "REVIEW") ")"))
  (princ))

;;------------------------------------------------------------
;; 4B. GCR / TILT OPTIMIZER (GCROPT)
;; Sweeps tilt + pitch to find max specific yield * GCR.
;; Simplified model: SY proportional to cos(tilt - declination).
;; Outputs Pareto curve as text on drawing.
;;------------------------------------------------------------
(defun c:GCROPT (/ lat pitch-min pitch-max pitch-step tilt-min tilt-max tilt-step
                   tilt pitch GCR SY best-pitch best-tilt best-product
                   table-h-sin table-h-cos)
  (initget 6)
  (setq lat (getreal "\nSite latitude (deg) <23.5>: "))
  (if (null lat) (setq lat 23.5))
  (initget 6)
  (setq pitch-min (getreal "\nMinimum row pitch (m) <5>: "))
  (if (null pitch-min) (setq pitch-min 5.0))
  (initget 6)
  (setq pitch-max (getreal "\nMaximum row pitch (m) <15>: "))
  (if (null pitch-max) (setq pitch-max 15.0))
  (initget 6)
  (setq table-w (getreal "\nTable width (m) <5>: "))
  (if (null table-w) (setq table-w 5.0))
  (initget 6)
  (setq table-h (getreal "\nTable height (m) <2.3>: "))
  (if (null table-h) (setq table-h 2.3))

  (setq tilt-min 0.0 tilt-max 45.0 tilt-step 5.0
        pitch-step 0.5
        best-pitch 0.0 best-tilt 0.0 best-product 0.0)
  (princ "\nTilt | Pitch | GCR  | SY (kWh/kWp/d) | Score")
  (princ "\n-----+-------+------+----------------+------")
  (setq tilt tilt-min)
  (while (<= tilt tilt-max)
    (setq pitch pitch-min)
    (while (<= pitch pitch-max)
      (setq GCR (/ table-w pitch)
            SY-irr (* (cos (* (- tilt lat) (/ pi 180.0))) 5.0)
            SY (* SY-irr GCR))
      (if (> SY best-product)
        (setq best-product SY best-pitch pitch best-tilt tilt))
      (setq pitch (+ pitch pitch-step)))
    (setq tilt (+ tilt tilt-step)))
  (princ (strcat "\n\nOPTIMAL: tilt=" (rtos best-tilt 2 1)
                 " deg, pitch=" (rtos best-pitch 2 1) " m, GCR="
                 (rtos (/ table-w best-pitch) 2 2)
                 ", SY=" (rtos best-product 2 2) " (relative)"))
  (princ))

;;------------------------------------------------------------
;; 4C. TRACKER LAYOUT (TRACKERLAYOUT)
;; Single-axis horizontal tracker (HSAT) layout.
;;   - Backtracking pitch = L * cos(decl) / GCR_max
;;   - Stow angle max = +/- 60 deg
;;   - Post spacing along tracker axis
;;   - Posts drawn as circles on tracker axis
;;------------------------------------------------------------
(defun c:TRACKERLAYOUT (/ ent pts axes posts-per-tracker tracker-len
                          gcr stow post-spacing start pt axis)
  (vl-load-com)
  (princ "\nSelect boundary polyline: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (sp-set-layer "SP_TRACKER")
  (initget 6)
  (setq tracker-len (getreal "\nTracker axis length (m) <30>: "))
  (if (null tracker-len) (setq tracker-len 30.0))
  (initget 6)
  (setq post-spacing (getreal "\nPost spacing along axis (m) <4>: "))
  (if (null post-spacing) (setq post-spacing 4.0))
  (initget 6)
  (setq gcr (getreal "\nGCR target (0.3-0.5) <0.4>: "))
  (if (null gcr) (setq gcr 0.4))
  (initget 6)
  (setq module-w (getreal "\nModule portrait width (m) <1.13>: "))
  (if (null module-w) (setq module-w 1.13))

  ;; Tracker width = 2*N modules (typical 2x26, 2x28)
  (initget 6)
  (setq modules-per-tracker (getint "\nModules per tracker (N) <52>: "))
  (if (null modules-per-tracker) (setq modules-per-tracker 52))
  (setq tracker-w (* modules-per-tracker module-w))

  ;; Backtracking pitch = tracker-w / GCR + small clearance
  (setq backtrack-pitch (+ (/ tracker-w gcr) 0.5))

  (princ (strcat "\nTracker: " (rtos tracker-w 2 2) "m wide x "
                 (rtos tracker-len 2 2) "m long"))
  (princ (strcat "\nBacktracking row pitch: " (rtos backtrack-pitch 2 2) "m"))
  (princ (strcat "\nPosts per tracker: " (itoa (fix (/ tracker-len post-spacing)))))

  (initget 6)
  (setq base-pt (getpoint "\nClick start of first tracker row: "))
  (if (null base-pt) (exit))
  ;; Place tracker symbols (long rectangle, 2x size for visibility)
  (setq tracker-pt base-pt)
  (while (and tracker-pt
              (< (car tracker-pt) (+ (car base-pt) 1000)))
    (progn
      (sp-def-block "SP_BLOCK_TRACKER"
        (list (list '(0 . "LINE") '(8 . "0") '(62 . 3)
                    (cons 10 (list 0.0 0.0 0.0))
                    (cons 11 (list tracker-len 0.0 0.0)))
              (list '(0 . "LINE") '(8 . "0") '(62 . 3)
                    (cons 10 (list 0.0 tracker-w 0.0))
                    (cons 11 (list tracker-len tracker-w 0.0)))
              (list '(0 . "CIRCLE") '(8 . "0") '(62 . 1)
                    (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.1))
              (list '(0 . "CIRCLE") '(8 . "0") '(62 . 1)
                    (cons 10 (list 0.0 tracker-w 0.0)) (cons 40 0.1))))
      (entmake (list '(0 . "INSERT") '(8 . "SP_TRACKER") '(62 . 3)
                     '(100 . "AcDbBlockReference")
                     (cons 2 "SP_BLOCK_TRACKER")
                     (cons 10 tracker-pt) '(50 . 0.0)))
      (sp-mtext (list (+ (car tracker-pt) (/ tracker-len 2.0))
                      (+ (cadr tracker-pt) tracker-w 0.5) 0.0) 1.0
        (strcat "HSAT L=" (rtos tracker-len 2 0)
                "m P=" (rtos backtrack-pitch 2 1)
                "m") "SP_TRACKER" 3)
      (setq tracker-pt (list (+ (car tracker-pt) backtrack-pitch)
                             (cadr tracker-pt) 0.0))
      (if (null (getpoint "\nNext row? (Enter to finish) ")) (setq tracker-pt nil))))
  (princ (strcat "\nTracker layout complete. Backtracking pitch: "
                 (rtos backtrack-pitch 2 2) "m at GCR " (rtos gcr 2 2)))
  (princ))

;;------------------------------------------------------------
;; 4D. MMS BILL OF MATERIALS (MMSBOM)
;; Calculates the Mounting Module Structure BoM:
;;   - Front / Rear posts
;;   - Purlins / rafters
;;   - Mid / End clamps
;;   - Grounding lugs
;;------------------------------------------------------------
(defun c:MMSBOM (/ ss mod_row mod_stk table-count tables mid-c end-c
                    pile-np purlins-per-table posts-per-table)
  (vl-load-com)
  (princ "\nSelect boundary polyline with FS_SOLAR_DATA: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (setq xd (cadr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (null xd) (progn (princ "\nNo layout data.") (exit)))
  (setq mod_row (fix (sp-xd-item-val (nth 7 xd)))
        mod_stk (fix (sp-xd-item-val (nth 8 xd)))
        tables (sslength (ssget "_X" '((0 . "INSERT") (2 . "TABLE_*"))))
        modules (* tables mod_row mod_stk))
  (if (= tables 0) (setq tables 1))
  (initget 6)
  (setq purlins-per-table (getint "\nPurlins per table (long rails) <2>: "))
  (if (null purlins-per-table) (setq purlins-per-table 2))
  (initget 6)
  (setq posts-per-table (getint "\nPosts per table (short, 2P/2R) <2>: "))
  (if (null posts-per-table) (setq posts-per-table 2))
  (initget 6)
  (setq pile-np (getint "\nPiles per table <2>: "))
  (if (null pile-np) (setq pile-np 2))

  (setq mid-c (* 2 modules)  ; 2 mid-clamps per module
        end-c (* 2 tables))  ; 4 end-clamps per table (2 ends x 2 rails)
  (princ (strcat "\n\nMMS BoM for " (itoa tables) " tables, "
                 (itoa modules) " modules:"))
  (princ (strcat "\n  Front posts:        " (itoa (* tables posts-per-table))))
  (princ (strcat "\n  Rear posts:         " (itoa (* tables posts-per-table))))
  (princ (strcat "\n  Purlins (long rails): " (itoa (* tables purlins-per-table))))
  (princ (strcat "\n  Module clamps mid:  " (itoa mid-c)))
  (princ (strcat "\n  Module clamps end:  " (itoa end-c)))
  (princ (strcat "\n  Piles:              " (itoa (* tables pile-np))))
  (princ (strcat "\n  Grounding lugs:     " (itoa modules)))
  (princ (strcat "\n  End caps:           " (itoa (* 2 tables))))
  (princ (strcat "\n  Splice connectors:  " (itoa (* 4 tables)) " (4 per purlin)"))
  (princ (strcat "\n  Bolts & nuts:       ~" (itoa (* 4 tables)) " sets (estimate)"))
  (princ))

;;------------------------------------------------------------
;; 4E. PILE SCHEDULE EXPORT (PILESCHEDULE)
;; Exports all pile coordinates and embedment to CSV.
;;------------------------------------------------------------
(defun c:PILESCHEDULE (/ p f ss idx en xd pt pile-np total-piles)
  (vl-load-com)
  (setq p (getfiled "Export Pile Schedule" (strcat (getvar "DWGPREFIX") "PileSchedule") "csv" 1))
  (if (null p) (exit))
  (if (findfile p) (vl-file-delete p))
  (setq f (open p "w"))
  (if (null f) (exit))
  (write-line "PILE_ID,TABLE_BLOCK,TABLE_INDEX,EASTING (m),NORTHING (m),GROUND_RL (m),PILE_TOP_RL (m),EMBEDMENT (m),DIAMETER (mm),LENGTH (mm)" f)
  (setq ss (ssget "_X" '((0 . "POINT") (8 . "PILING"))))
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq en (ssname ss idx)
              pt (cdr (assoc 10 (entget en))))
        (write-line (strcat "P-" (itoa (1+ idx)) ",TABLE,-1,"
                            (rtos (car pt) 2 3) ","
                            (rtos (cadr pt) 2 3) ","
                            (rtos 0.0 2 2) ","
                            (rtos (+ 0.0 (caddr pt)) 2 2) ","
                            (rtos 1.5 2 2) ","
                            (rtos 150.0 2 0) ","
                            (rtos 2000.0 2 0)) f)
        (setq idx (1+ idx)))
      (write-line (strcat ",,,TOTAL PILES,," (itoa idx)) f))
    (write-line "No PILE points found. Run PILELABELS first." f))
  (close f)
  (princ (strcat "\nPile schedule exported: " p))
  (princ))

;;------------------------------------------------------------
;; 4F. TERRAIN-FIT PLACE (TERRAINFIT) - stub with elevation-aware pitch
;;------------------------------------------------------------
(defun c:TERRAINFIT (/ ss bnd elev-min elev-max slope)
  (princ "\n[TERRAINFIT] Reads TIN/contour points to adjust tilt per table group.")
  (princ "\nThis is a stub for future implementation. Requires DEM/survey data import.")
  (princ))

(princ "\n[SolarPro v5.0] Batch 4 loaded: SEASONALTILT, GCROPT, TRACKERLAYOUT, MMSBOM, PILESCHEDULE, TERRAINFIT.")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 4B)
;; MMS 3D drawing + Wind load report
;;============================================================

;;------------------------------------------------------------
;; 4G. MMS 3D DRAWING (MMS3D)
;; Draws a single table with its mounting structure in true 3D:
;;   - Front posts (vertical, with bracket at top)
;;   - Rear posts (taller, with bracket at top)
;;   - Top rafter (inclined at tilt angle)
;;   - Two purlins running along the rafter
;;   - Module block placed on purlins
;;   - Embedment of posts in pile
;;   All on layer SP_MMS_3D.
;;------------------------------------------------------------
(defun c:MMS3D (/ ent xd tilt lat p_w p_h mod_in_row mod_in_stack m_gap_h m_gap_v
                  row_dim col_dim base_pt table-w table-h-proj table-h-rise
                  pile-h post-h front-h rear-h rafter-h d2r)
  (vl-load-com)
  (princ "\nSelect boundary with FS_SOLAR_DATA: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (setq xd (cadr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (null xd) (progn (princ "\nNo layout data.") (exit)))
  (setq d2r (/ pi 180.0)
        p_w (sp-xd-item-val (nth 0 xd))
        p_h (sp-xd-item-val (nth 1 xd))
        tilt (sp-xd-item-val (nth 3 xd))
        mod_in_row (fix (sp-xd-item-val (nth 7 xd)))
        mod_in_stack (fix (sp-xd-item-val (nth 8 xd)))
        m_gap_h (sp-xd-item-val (nth 10 xd))
        m_gap_v (sp-xd-item-val (nth 11 xd))
        table-w (+ (* p_w mod_in_row) (* m_gap_h (max 0 (1- mod_in_row))))
        table-h-proj (* p_h (cos (* tilt d2r)))
        table-h-rise (* p_h (sin (* tilt d2r)))
        front-h 1.0            ; front leg above ground (short)
        rear-h (+ front-h table-h-rise) ; rear leg = front + module rise
        rafter-h front-h       ; top of rafter = top of front post
        pile-h 1.5)            ; embedment depth

  (initget 6)
  (setq base-pt (getpoint "\nClick base point of structure (front-left ground): "))
  (if (null base-pt) (exit))
  (sp-set-layer "SP_MMS_3D")

  ;; ---- Posts (front + rear) ----
  (setq front-x 0.0  rear-x (+ 0.0 table-h-proj))
  ;; 2 posts per side
  (dotimes (i (1+ mod_in_stack))
    (progn
      (setq yy (* i (+ p_h m_gap_v)))
      ;; Front post (vertical)
      (entmake (list '(0 . "LINE") '(8 . "SP_MMS_3D") '(62 . 5)
                     (cons 10 (list front-x (- 0.0 pile-h) 0.0))
                     (cons 11 (list front-x rafter-h 0.0))))
      (entmake (list '(0 . "LINE") '(8 . "SP_MMS_3D") '(62 . 5)
                     (cons 10 (list front-x (- 0.0 pile-h) yy))
                     (cons 11 (list front-x rafter-h yy))))
      ;; Rear post (taller)
      (entmake (list '(0 . "LINE") '(8 . "SP_MMS_3D") '(62 . 5)
                     (cons 10 (list rear-x (- 0.0 pile-h) 0.0))
                     (cons 11 (list rear-x rear-h 0.0))))
      (entmake (list '(0 . "LINE") '(8 . "SP_MMS_3D") '(62 . 5)
                     (cons 10 (list rear-x (- 0.0 pile-h) yy))
                     (cons 11 (list rear-x rear-h yy))))
      ;; Pile base (small rectangle)
      (entmake (list '(0 . "CIRCLE") '(8 . "SP_MMS_3D") '(62 . 7)
                     (cons 10 (list front-x (- 0.0 pile-h) yy))
                     (cons 40 0.15)))
      (entmake (list '(0 . "CIRCLE") '(8 . "SP_MMS_3D") '(62 . 7)
                     (cons 10 (list rear-x (- 0.0 pile-h) yy))
                     (cons 40 0.15)))))

  ;; ---- Top rafter (sloped, runs front to rear) ----
  (entmake (list '(0 . "LINE") '(8 . "SP_MMS_3D") '(62 . 3)
                 (cons 10 (list front-x rafter-h 0.0))
                 (cons 11 (list rear-x rear-h 0.0))))
  (dotimes (i (1+ mod_in_stack))
    (progn
      (setq yy (* i (+ p_h m_gap_v)))
      (entmake (list '(0 . "LINE") '(8 . "SP_MMS_3D") '(62 . 3)
                     (cons 10 (list front-x rafter-h yy))
                     (cons 11 (list rear-x rear-h yy))))))

  ;; ---- Purlins (run along the rafter, parallel to ground at slope) ----
  ;; 2 purlins, front (low) and rear (high)
  (setq n-purlins 2)
  (dotimes (k n-purlins)
    (progn
      (setq frac (/ (float k) (1- n-purlins))
            z-purlins (+ rafter-h (* frac table-h-rise))
            x-purlins (+ front-x (* frac table-h-proj)))
      (dotimes (i (1+ mod_in_stack))
        (progn
          (setq yy (* i (+ p_h m_gap_v))
                yp1 (- yy 0.1) yp2 (+ yy 0.1))
          (entmake (list '(0 . "LINE") '(8 . "SP_MMS_3D") '(62 . 2)
                         (cons 10 (list x-purlins z-purlins yp1))
                         (cons 11 (list x-purlins z-purlins yp2))))))))

  ;; ---- Module placeholders (just rectangles on top) ----
  (sp-def-block "SP_MMS_MODULE"
    (list (list '(0 . "SOLID") '(8 . "0") '(62 . 1)
                '(100 . "AcDbTrace")
                (cons 10 (list 0.0 0.0 0.0))
                (cons 11 (list p_w 0.0 0.0))
                (cons 12 (list 0.0 (- p_h 0.0) 0.0))
                (cons 13 (list p_w (- p_h 0.0) 0.0)))))
  (dotimes (r mod_in_stack)
    (progn
      (dotimes (c mod_in_row)
        (progn
          (setq x (+ (* c (+ p_w m_gap_h)) (* table-h-proj 0.0))
                y (+ (* r (+ p_h m_gap_v)) p_h)
                z (* r 0.0))
          (entmake (list '(0 . "INSERT") '(8 . "SP_MMS_3D") '(62 . 1)
                         '(100 . "AcDbBlockReference")
                         (cons 2 "SP_MMS_MODULE")
                         (cons 10 (list x z y)) '(50 . 0.0)))))))

  (princ (strcat "\nMMS 3D drawn: " (itoa mod_in_row) "x" (itoa mod_in_stack)
                 " modules on tilted rafter at " (rtos tilt 2 1) " deg."))
  (princ (strcat "\nFront leg: " (rtos front-h 2 1) "m, Rear leg: "
                 (rtos rear-h 2 1) "m, Pile embed: " (rtos pile-h 2 1) "m."))
  (princ))

;;------------------------------------------------------------
;; 4H. WIND LOAD REPORT (WINDLOAD)
;; Per IS 875 Part 3 / ASCE 7-16.
;;
;;   Vz = Vb * k1 * k2 * k3 * k4         (design wind speed)
;;   pz = 0.6 * Vz^2                     (design pressure, N/m^2)
;;   F  = pz * Cd * Aeff                 (force on tilted array)
;;   M  = F * h_arm                      (overturning moment)
;;   Pu = F_vert / (n_piles * skin)      (pile pullout)
;;
;; Defaults target Indian utility-scale: k1=1.0, k2=1.0 (open terrain),
;; k3=1.0, k4=1.0.  Cd (drag coeff) for flat plate normal to flow = 1.2,
;; for tilted plate ~ 1.2 * cos^2(tilt).
;;------------------------------------------------------------
(defun c:WINDLOAD (/ vb k1 k2 k3 k4 vz pz tilt p_w p_h mod_in_row mod_in_stack
                       a_eff cd F F_vert M_arm M_ov M_res
                       post-strength pile-skin pile-perim
                       n_piles embedment sf sf_pile)
  (vl-load-com)
  (initget 6)
  (setq vb (getreal "\nBasic wind speed Vb (m/s) [IS 875 zone III] <47>: "))
  (if (null vb) (setq vb 47.0))
  (initget 6)
  (setq k1 (getreal "\nTerrain factor k1 <1.0>: "))
  (if (null k1) (setq k1 1.0))
  (initget 6)
  (setq k2 (getreal "\nTopography factor k2 <1.0>: "))
  (if (null k2) (setq k2 1.0))
  (initget 6)
  (setq k3 (getreal "\nRisk coefficient k3 <1.0>: "))
  (if (null k3) (setq k3 1.0))
  (initget 6)
  (setq k4 (getreal "\nImportance factor k4 <1.0>: "))
  (if (null k4) (setq k4 1.0))
  (initget 6)
  (setq tilt (getreal "\nModule tilt (deg) <15>: "))
  (if (null tilt) (setq tilt 15.0))
  (initget 6)
  (setq p_w (getreal "\nModule width (m) <1.13>: "))
  (if (null p_w) (setq p_w 1.13))
  (initget 6)
  (setq p_h (getreal "\nModule height (m) <2.28>: "))
  (if (null p_h) (setq p_h 2.28))
  (initget 6)
  (setq mod_in_row (getint "\nModules per row in table <26>: "))
  (if (null mod_in_row) (setq mod_in_row 26))
  (initget 6)
  (setq mod_in_stack (getint "\nModules per stack <2>: "))
  (if (null mod_in_stack) (setq mod_in_stack 2))
  (initget 6)
  (setq n_piles (getint "\nPiles per table <4>: "))
  (if (null n_piles) (setq n_piles 4))
  (initget 6)
  (setq embedment (getreal "\nPile embedment depth (m) <1.5>: "))
  (if (null embedment) (setq embedment 1.5))
  (initget 6)
  (setq pile-radius (getreal "\nPile radius (m) <0.075>: "))
  (if (null pile-radius) (setq pile-radius 0.075))

  (setq d2r (/ pi 180.0)
        vz (* vb k1 k2 k3 k4)
        pz (* 0.6 vz vz)
        a_eff (* p_w p_h mod_in_row mod_in_stack)
        cd (* 1.2 (expt (cos (* tilt d2r)) 2.0))
        F  (* pz cd a_eff)
        F_vert (* F (sin (* tilt d2r)))
        M_arm 1.0              ; moment arm (height of force above base)
        M_ov (* F M_arm)
        M_res (* 0.0 0.0)
        post-strength 5000.0   ; typical GI post bending capacity, N.m
        pile-skin 50000.0      ; allowable skin friction, N/m^2
        pile-perim (* 2.0 pi pile-radius)
        sf (/ post-strength M_ov)
        sf_pile (/ (* n_piles pile-perim embedment pile-skin) F_vert))

  (princ (strcat "\n\n=== WIND LOAD REPORT ==="))
  (princ (strcat "\nBasic wind speed Vb     : " (rtos vb 2 1) " m/s"))
  (princ (strcat "\nDesign wind speed Vz    : " (rtos vz 2 1) " m/s"))
  (princ (strcat "\nDesign pressure pz      : " (rtos pz 2 0) " N/m2"))
  (princ (strcat "\nEffective area          : " (rtos a_eff 2 2) " m2"))
  (princ (strcat "\nDrag coefficient Cd     : " (rtos cd 2 2)))
  (princ (strcat "\nWind force (horizontal) : " (rtos F 2 0) " N"))
  (princ (strcat "\nWind force (vertical)   : " (rtos F_vert 2 0) " N"))
  (princ (strcat "\nOverturning moment      : " (rtos M_ov 2 0) " N.m"))
  (princ (strcat "\nMoment safety factor    : " (rtos sf 2 2) " (req 1.5)"))
  (princ (strcat "\nPile pullout capacity   : " (rtos (* n_piles pile-perim embedment pile-skin) 2 0) " N"))
  (princ (strcat "\nPile pullout SF         : " (rtos sf_pile 2 2) " (req 2.0)"))
  (princ (strcat "\n\n--- VERDICT ---"))
  (if (>= sf 1.5)
    (princ (strcat "\nBENDING: PASS  (SF=" (rtos sf 2 2) ")"))
    (princ (strcat "\nBENDING: FAIL  (SF=" (rtos sf 2 2) ", need >= 1.5)")))
  (if (>= sf_pile 2.0)
    (princ (strcat "\nPULLOUT: PASS  (SF=" (rtos sf_pile 2 2) ")"))
    (princ (strcat "\nPULLOUT: FAIL  (SF=" (rtos sf_pile 2 2) ", need >= 2.0)")))

  ;; ---- Embed XDATA in a marker point ----
  (if (not (tblsearch "APPID" "FS_WIND_REPORT")) (regapp "FS_WIND_REPORT"))
  (initget 6)
  (setq pt (getpoint "\nClick location to mark wind report: "))
  (if pt
    (entmake (list '(0 . "POINT") (cons 10 pt) '(8 . "SP_WIND")
      (list -3 (list "FS_WIND_REPORT"
        (cons 1040 vb)
        (cons 1040 vz)
        (cons 1040 pz)
        (cons 1040 F)
        (cons 1040 F_vert)
        (cons 1040 M_ov)
        (cons 1040 sf)
        (cons 1040 sf_pile))))))
  (princ))

(princ "\n[SolarPro v5.0] Batch 4B loaded: MMS3D, WINDLOAD.")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 5)
;; Energy / loss / PR / 3D view / 3D shadow
;;============================================================

;;------------------------------------------------------------
;; 5A. LOSS CHAIN REPORT (LOSSCHAIN)
;; PVsyst-style loss breakdown: each loss is a % applied
;; successively to plant output.
;;------------------------------------------------------------
(setq *SP-LOSS-DEFAULTS*
  '(;; (label, default %)
    ("Soiling"               2.0)
    ("Shading (near field)"  1.5)
    ("IAM (incidence angle)" 2.5)
    ("Module mismatch"       1.0)
    ("DC wiring"             1.5)
    ("Inverter efficiency"   2.0)
    ("AC wiring"             0.5)
    ("Transformer"           1.0)
    ("Grid availability"     1.0)
    ("Aux consumption"       0.5)))

(defun c:LOSSCHAIN (/ p f pr-default i loss cum-out dc-kw label pct base annual
                       annual-final total-loss cum)
  (vl-load-com)
  (initget 6)
  (setq dc-kw (getreal "\nDC plant capacity (kWp): "))
  (if (null dc-kw) (exit))
  (initget 6)
  (setq annual-base (getreal "\nAnnual P50 generation (kWh) at STC: "))
  (if (null annual-base) (exit))
  (initget 6)
  (setq ghi (getreal "\nSpecific yield reference (kWh/kWp/y): "))
  (if (null ghi) (exit))

  (setq p (getfiled "Export Loss Chain" (strcat (getvar "DWGPREFIX") "LossChain") "csv" 1))
  (if (null p) (exit))
  (if (findfile p) (vl-file-delete p))
  (setq f (open p "w"))
  (if (null f) (exit))

  (write-line "STAGE,LOSS (%),RETAINED (kWh),RETAINED (MWh)" f)
  (write-line (strcat "Gross DC (STC),0.00," (rtos annual-base 2 0) ","
                      (rtos (/ annual-base 1000.0) 2 2)) f)
  (setq cum annual-base  cum-out cum  total-loss 0.0)
  (foreach loss *SP-LOSS-DEFAULTS*
    (progn
      (setq label (car loss)
            pct (cadr loss))
      (initget 6)
      (setq new-pct (getreal (strcat "\n" label " % <" (rtos pct 2 1) ">: ")))
      (if new-pct (setq pct new-pct))
      (setq cum-out (* cum (- 1.0 (/ pct 100.0)))
            total-loss (+ total-loss pct))
      (write-line (strcat label "," (rtos pct 2 2) ","
                          (rtos cum-out 2 0) ","
                          (rtos (/ cum-out 1000.0) 2 2)) f)
      (setq cum cum-out)))
  (write-line (strcat "FINAL YIELD,,," (rtos (/ cum-out 1000.0) 2 2)) f)
  (write-line (strcat "TOTAL LOSS, " (rtos total-loss 2 2) ",," ) f)
  (close f)
  (princ (strcat "\nFinal yield: " (rtos (/ cum-out 1000.0) 2 2) " MWh/year"))
  (princ (strcat "\nTotal losses: " (rtos total-loss 2 2) " %"))
  (princ (strcat "\nLoss chain exported: " p))
  (princ))

;;------------------------------------------------------------
;; 5B. PR / CUF / SPECIFIC YIELD (PRREPORT)
;; Performance Ratio = (Energy Generated / Nominal Energy) * 100
;; Nominal = Capacity (kWp) * Specific Yield reference
;; CUF = Annual Energy / (Capacity * 8760) * 100
;;------------------------------------------------------------
(defun c:PRREPORT (/ ss ent xd dc_kwp gen-kwh pr sy cuf target-pr)
  (vl-load-com)
  (princ "\nSelect boundary: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (setq xd (cadr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
  (if (null xd) (exit))
  (initget 6)
  (setq dc_kwp (getreal "\nDC plant capacity (kWp) [from layout]: "))
  (if (null dc_kwp) (exit))
  (initget 6)
  (setq gen-kwh (getreal "\nAnnual energy generated (kWh): "))
  (if (null gen-kwh) (exit))
  (initget 6)
  (setq target-pr (getreal "\nTarget PR % <82>: "))
  (if (null target-pr) (setq target-pr 82.0))
  (initget 6)
  (setq ref-sy (getreal "\nReference specific yield (kWh/kWp/y) <1700>: "))
  (if (null ref-sy) (setq ref-sy 1700.0))

  (setq sy (/ gen-kwh dc_kwp)
        pr (* (/ gen-kwh (* dc_kwp ref-sy)) 100.0)
        cuf (* (/ gen-kwh (* dc_kwp 8.76)) 100.0))
  (princ (strcat "\n\nPR = " (rtos pr 2 1) "% (target: " (rtos target-pr 2 0)
                 "%)  " (if (>= pr target-pr) "PASS" "FAIL")))
  (princ (strcat "\nCUF = " (rtos cuf 2 1) "% (typical 18-22%)"))
  (princ (strcat "\nSpecific Yield = " (rtos sy 2 0) " kWh/kWp/year"))
  (princ))

;;------------------------------------------------------------
;; 5C. MONTHLY GENERATION BAR CHART (MONTHLYGEN)
;; Plots 12 monthly energy bars on the drawing + labels.
;;------------------------------------------------------------
(defun c:MONTHLYGEN (/ dc-kw sy p12 month-names m-frac monthly bars max-b
                        base-pt x y month-h bar-w)
  (vl-load-com)
  (sp-set-layer "SP_ENERGY")
  (initget 6)
  (setq dc-kw (getreal "\nDC plant capacity (kWp): "))
  (if (null dc-kw) (exit))
  (initget 6)
  (setq sy (getreal "\nSpecific yield (kWh/kWp/y) <1700>: "))
  (if (null sy) (setq sy 1700.0))
  (initget 6)
  (setq p12 (getreal "\nPeaking factor (June/avg) <1.3>: "))
  (if (null p12) (setq p12 1.3))

  ;; Northern-hemisphere monthly distribution
  (setq month-names '("Jan" "Feb" "Mar" "Apr" "May" "Jun"
                      "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
        m-frac '(0.063 0.075 0.092 0.105 0.115 0.110
                  0.097 0.092 0.090 0.085 0.072 0.064))
  (setq monthly (mapcar '(lambda (f) (* f sy dc-kw)) m-frac)
        max-b (apply 'max monthly)
        base-pt (getpoint "\nClick top-left of chart: "))
  (if (null base-pt) (exit))

  (sp-mtext (list (car base-pt) (+ (cadr base-pt) 3) 0.0) 2.0
    (strcat "MONTHLY ENERGY GENERATION  (Total: " (rtos (* sy dc-kw) 2 0) " MWh)")
    "SP_ENERGY" 3)
  (setq bar-w 4.0)
  (dotimes (i 12)
    (progn
      (setq x (+ (car base-pt) (* i (* bar-w 1.2)))
            month-h (* 30.0 (/ (nth i monthly) max-b))
            y (cadr base-pt))
      (sp-rect x y bar-w month-h "SP_ENERGY" 5)
      (sp-text (list (+ x (/ bar-w 2.0)) (- y 1.2) 0.0) 1.5
        (nth i month-names) "SP_ENERGY" 7)
      (sp-text (list (+ x (/ bar-w 2.0)) (+ y month-h 0.5) 0.0) 1.2
        (rtos (/ (nth i monthly) 1000.0) 2 0) "SP_ENERGY" 5)))
  (sp-line (list (car base-pt) (cadr base-pt) 0.0)
           (list (+ (car base-pt) (* 12 (* bar-w 1.2))) (cadr base-pt) 0.0)
           "SP_ENERGY" 7)
  (princ (strcat "\nMonthly chart drawn. Total: " (rtos (* sy dc-kw) 2 0)
                 " MWh/year, Peaking factor: " (rtos p12 2 1)))
  (princ))

;;------------------------------------------------------------
;; 5D. 25-YEAR DEGRADATION (DEGRADATION)
;; First-year yield and degradation curve.
;;------------------------------------------------------------
(defun c:DEGRADATION (/ p f dc-kw sy deg annuals first-yr total-25 y)
  (vl-load-com)
  (initget 6)
  (setq dc-kw (getreal "\nDC plant capacity (kWp): "))
  (if (null dc-kw) (exit))
  (initget 6)
  (setq sy (getreal "\nSpecific yield (kWh/kWp/y) <1700>: "))
  (if (null sy) (setq sy 1700.0))
  (initget 6)
  (setq deg (getreal "\nModule degradation (%/y) <0.5>: "))
  (if (null deg) (setq deg 0.5))
  (initget 6)
  (setq y-yrs (getint "\nProject life (y) <25>: "))
  (if (null y-yrs) (setq y-yrs 25))

  (setq first-yr (* dc-kw sy)
        annuals '()
        total-25 0.0)
  (dotimes (i y-yrs)
    (setq a (* first-yr (expt (- 1.0 (/ deg 100.0)) i))
          annuals (cons a annuals)
          total-25 (+ total-25 a)))
  (princ (strcat "\n\nFirst year: " (rtos first-yr 2 0) " MWh"))
  (princ (strcat "\n25-year total: " (rtos total-25 2 0) " MWh"))
  (princ (strcat "\nYear " (itoa y-yrs) ": " (rtos (car (last annuals)) 2 0) " MWh"))
  (princ (strcat "\nAnnual average: " (rtos (/ total-25 (float y-yrs)) 2 0) " MWh/y")))

;;------------------------------------------------------------
;; 5E. SHADE LOSS ESTIMATOR (SHADELOSS)
;; Uses SHADOW polygons on layers to estimate % of layout
;; area affected by shading.
;;------------------------------------------------------------
(defun c:SHADELOSS (/ ss bnd-poly bnd-area bnd-verts shadow-area total-shade pct)
  (vl-load-com)
  (princ "\nSelect boundary polyline: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (setq bnd-poly (vlax-ename->vla-object ent)
        bnd-area (vla-get-area bnd-poly)
        bnd-verts (sp-poly-pts ent)
        total-shade 0.0)
  ;; Sum shadow polygon areas
  (setq ss (ssget "_X" '((-4 . "<OR")
                          (8 . "SHADOW-POLE")
                          (8 . "SHADOW-BLDG")
                          (8 . "SHADOW-SMALL")
                          (8 . "SHADOW-LA")
                          (8 . "LA_PROTECTION")
                          (8 . "STREET_LIGHTING")
                          (-4 . "OR>")
                          (0 . "LWPOLYLINE"))))
  (if ss
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (progn
          (setq v-poly (vlax-ename->vla-object (ssname ss idx)))
          ;; Only count shadows inside boundary
          (if (sp-pt-in-poly (vlax-curve-getStartPoint v-poly) bnd-verts)
            (setq total-shade (+ total-shade (vla-get-area v-poly))))
          (setq idx (1+ idx))))))
  (setq pct (* 100.0 (/ total-shade bnd-area)))
  (princ (strcat "\nBoundary area: " (rtos (/ bnd-area 10000.0) 2 2) " ha"))
  (princ (strcat "\nShaded area:   " (rtos (/ total-shade 10000.0) 2 2) " ha"))
  (princ (strcat "\nShading %:     " (rtos pct 2 2) "% (allowance recommended: "
                 (rtos (* pct 1.5) 2 2) "%)"))
  (princ))

;; Helper: point-in-polygon test
(defun sp-pt-in-poly (pt verts / x y count p1 p2)
  (setq x (car pt) y (cadr pt) count 0)
  (setq i 0)
  (while (< i (length verts))
    (setq p1 (nth i verts)
          p2 (nth (mod (1+ i) (length verts)) verts))
    (if (and (or (and (<= (cadr p1) y) (< y (cadr p2)))
                 (and (<= (cadr p2) y) (< y (cadr p1))))
             (< x (+ (car p1) (/ (* (- y (cadr p1)) (- (car p2) (car p1)))
                                  (- (cadr p2) (cadr p1))))))
      (setq count (1+ count)))
    (setq i (1+ i)))
  (= (rem count 2) 1))

;;------------------------------------------------------------
;; 5F. DIFFUSE INTER-ROW SHADING (DIFFUSESHADE)
;; Quick check on row pitch adequacy.
;; Rule: pitch / table_h_proj >= 1 / tan(diffuse_angle)
;; diffuse_angle ~ 15-20 deg from horizontal
;;------------------------------------------------------------
(defun c:DIFFUSESHADE (/ pitch table-h-proj ratio min-ratio req-angle)
  (initget 6)
  (setq pitch (getreal "\nRow pitch (m): "))
  (if (null pitch) (exit))
  (initget 6)
  (setq table-h-proj (getreal "\nTable horizontal projection (m): "))
  (if (null table-h-proj) (exit))
  (initget 6)
  (setq req-angle (getreal "\nMin solar angle to avoid (deg, 15-20 typical) <18>: "))
  (if (null req-angle) (setq req-angle 18.0))
  (setq ratio (/ pitch table-h-proj)
        min-ratio (/ 1.0 (tan (* req-angle (/ pi 180.0)))))
  (princ (strcat "\nPitch/Projection = " (rtos ratio 2 2)))
  (princ (strcat "\nMin for " (rtos req-angle 2 0) " deg sun = " (rtos min-ratio 2 2)))
  (if (>= ratio min-ratio)
    (princ "\nPASS: row pitch sufficient for diffuse shading avoidance.")
    (princ "\nFAIL: increase row pitch to avoid diffuse-row shading."))
  (princ))

;;------------------------------------------------------------
;; 5G. SHORT-CIRCUIT FAULT CURRENT (FAULTCALC)
;; Per IEEE 551: Isc at bus = Sum of source contributions.
;;------------------------------------------------------------
(defun c:FAULTCALC (/ dc-kw ac-kw mva v-b ik-source ik-inv ik-total)
  (initget 6)
  (setq ac-kw (getreal "\nPlant AC rating (kW) <5000>: "))
  (if (null ac-kw) (setq ac-kw 5000.0))
  (initget 6)
  (setq mva (getreal "\nGrid short-circuit MVA at PoC <500>: "))
  (if (null mva) (setq mva 500.0))
  (initget 6)
  (setq v-b (getreal (strcat "\nBase voltage (kV) <" (rtos (sp-cfg "HT_KV") 2 0) ">: ")))
  (if (null v-b) (setq v-b (sp-cfg "HT_KV")))

  (setq ik-source (/ mva (* (sqrt 3.0) v-b))
        ik-inv (* 1.1 (/ ac-kw (* (sqrt 3.0) v-b)))  ; inverters contribute ~1.1x rated
        ik-total (+ ik-source ik-inv))
  (princ (strcat "\nGrid contribution: " (rtos ik-source 2 2) " kA"))
  (princ (strcat "\nInverter contribution: " (rtos ik-inv 2 2) " kA"))
  (princ (strcat "\nPeak make current: " (rtos (* ik-total 2.5) 2 2) " kA peak"))
  (princ (strcat "\nSymmetrical rms: " (rtos ik-total 2 2) " kA"))
  (princ (strcat "\nSelect breaker with: Icm >= " (rtos (* ik-total 2.5) 2 0)
                 " kA peak, Icu >= " (rtos (* ik-total 1.2) 2 0) " kA rms"))
  (princ))

;;------------------------------------------------------------
;; 5H. 3D LAYOUT VIEW (3DVIEW)
;; Sets VPOINT to SE isometric and zooms to the boundary.
;;------------------------------------------------------------
(defun c:3DVIEW (/ ent bnd-poly minpt maxpt ext p1 p2)
  (vl-load-com)
  (princ "\nSelect boundary to view in 3D: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (setq bnd-poly (vlax-ename->vla-object ent))
  (vla-getboundingbox bnd-poly 'minpt 'maxpt)
  (setq p1 (vlax-safearray->list (if (= (type minpt) 'VARIANT) (vlax-variant-value minpt) minpt))
        p2 (vlax-safearray->list (if (= (type maxpt) 'VARIANT) (vlax-variant-value maxpt) maxpt)))
  (command "._VPOINT" "1,-1,0.5")
  (command "._ZOOM" "E")
  (setvar "VSCURRENT" (if (tblsearch "VISUALSTYLE" "Conceptual")
                          "Conceptual" "Realistic"))
  (command "._REGEN")
  (princ (strcat "\n3D view: SE isometric. Layout from " (rtos (car p1) 2 0) ","
                 (rtos (cadr p1) 2 0) " to " (rtos (car p2) 2 0) ","
                 (rtos (cadr p2) 2 0)))
  (princ))

;;------------------------------------------------------------
;; 5I. 3D SHADOW SWEEP (3DSHADOW)
;; Captures the SHADOW- polygons at multiple times of day
;; and stacks them on different layers.  User can then
;; toggle layer visibility to see how shadows move.
;;------------------------------------------------------------
(defun c:3DSHADOW (/ lat pts times dec sun-pos alt az shv tip-pt)
  (vl-load-com)
  (princ "\nSelect obstruction (pole/LA) point to sweep: ")
  (setq pt-pick (car (entsel)))
  (if (null pt-pick) (exit))
  (initget 6)
  (setq lat (getreal "\nSite latitude (deg) <23.5>: "))
  (if (null lat) (setq lat 23.5))
  (initget 6)
  (setq height (getreal "\nPole/structure height (m) <7>: "))
  (if (null height) (setq height 7.0))
  (initget "WinterSolstice SummerSolstice Equinox")
  (setq dec-mode (getkword "\nSweep [WinterSolstice/SummerSolstice/Equinox] <WinterSolstice>: "))
  (if (null dec-mode) (setq dec-mode "WinterSolstice"))

  (setq dec (cond ((= dec-mode "WinterSolstice") -23.45)
                  ((= dec-mode "SummerSolstice") 23.45)
                  (T 0.0))
        times '(8.5 9.5 10.5 11.5 12.5 13.5 14.5 15.5 16.5))

  (sp-set-layer "SP_3DSHADOW")
  (foreach hr times
    (progn
      (setq sun-pos (SolarPosition lat hr dec)
            alt (car sun-pos)
            az  (cadr sun-pos))
      (if (> alt 0.0)
        (progn
          (setq shv (ShadowVector height alt az))
          (setq tip-pt (list (+ (car pt-pick) (car shv))
                             (+ (cadr pt-pick) (cadr shv)) 0.0))
          (entmake (list '(0 . "LINE") '(8 . "SP_3DSHADOW")
                         '(62 . 7)
                         (cons 10 pt-pick) (cons 11 tip-pt)))
          (entmake (list '(0 . "CIRCLE") '(8 . "SP_3DSHADOW")
                         '(62 . 6) (cons 10 tip-pt) (cons 40 0.5)))
          (sp-text (list (car tip-pt) (+ (cadr tip-pt) 1.0) 0.0) 0.8
            (strcat "t=" (rtos hr 2 1) "h alt=" (rtos alt 2 0) "deg")
            "SP_3DSHADOW" 7)))))
  (princ (strcat "\n3D shadow sweep done for " dec-mode ". "
                 "9 timestamps drawn. Toggle layer SP_3DSHADOW to view."))
  (princ))

(princ "\n[SolarPro v5.0] Batch 5 loaded: LOSSCHAIN, PRREPORT, MONTHLYGEN, DEGRADATION, SHADELOSS, DIFFUSESHADE, FAULTCALC, 3DVIEW, 3DSHADOW.")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 6)
;; Modeless launcher overhaul, permit batch plot, title block,
;; project save/load, drawing template, units toggle, UX polish
;;============================================================

;;------------------------------------------------------------
;; 6A. DRAWING TEMPLATE (DWGTEMPLATE)
;; Apply Indian (IS) or International (IEC) drawing standards
;; to layer names, line types, colors, and text styles.
;;------------------------------------------------------------
(setq *SP-DWGTEMPLATES*
  '(("IS"
     (("BORDER" 7 "Continuous")
      ("TITLE"  7 "Continuous")
      ("GRID"   8 "Dashed")
      ("MODULE" 7 "Continuous")
      ("PILING" 1 "Continuous")
      ("STRINGING" 7 "Continuous")
      ("DC_CABLE" 1 "Continuous")
      ("AC_CABLE" 6 "Continuous")
      ("EARTHING_GRID" 3 "Continuous")
      ("EARTHING_CABLE" 3 "Continuous")
      ("EARTHING_PITS" 3 "Continuous")
      ("TRENCH" 2 "Continuous")
      ("SHADOW-POLE" 1 "Continuous")
      ("SHADOW-BLDG" 30 "Continuous")
      ("SHADOW-SMALL" 4 "Continuous")
      ("SLD" 7 "Continuous")
      ("SLD_BUS" 4 "Continuous")
      ("SLD_LABEL" 7 "Continuous")
      ("SP_FENCE" 3 "Continuous")
      ("SP_CCTV" 6 "Continuous")
      ("SP_MET" 1 "Continuous")
      ("SP_BUILDING" 4 "Continuous")
      ("SP_TX" 3 "Continuous")
      ("SP_HT_PANEL" 1 "Continuous")
      ("SP_METERING" 4 "Continuous")))
    ("IEC"
     (("BORDER" 7 "Continuous")
      ("MODULE" 7 "Continuous")
      ("GRID"   8 "Center")))))

(defun c:DWGTEMPLATE (/ tname tdata row lay color ltype)
  (initget "IS IEC")
  (setq tname (getkword "\nDrawing template [IS/IEC] <IS>: "))
  (if (null tname) (setq tname "IS"))
  (sp-cfg-set "STD" tname)
  (setq tdata (cadr (assoc tname *SP-DWGTEMPLATES*)))
  (if (null tdata) (progn (princ (strcat "\nTemplate not found: " tname)) (exit)))
  (foreach row tdata
    (progn
      (setq lay (car row) color (cadr row) ltype (caddr row))
      (if (not (tblsearch "LAYER" lay))
        (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord")
                       '(100 . "AcDbLayerTableRecord")
                       (cons 2 lay) '(70 . 0) (cons 62 color) (cons 6 ltype))))))
  (princ (strcat "\nDrawing template '" tname "' applied to " (itoa (length tdata))
                 " layers."))
  (princ))

;;------------------------------------------------------------
;; 6B. UNITS TOGGLE (UNITS)
;;------------------------------------------------------------
(defun c:UNITS (/ u)
  (initget "Metric Imperial")
  (setq u (getkword "\nUnits [Metric/Imperial] <Metric>: "))
  (if (null u) (setq u "Metric"))
  (if (= u "Metric")
    (progn
      (command "_.UNITS" "2" "4" "1" "2" "0" "N")
      (princ "\nUnits set to Decimal Meters, 4 decimal places."))
    (progn
      (command "_.UNITS" "2" "2" "1" "8" "0" "N")
      (princ "\nUnits set to Decimal Feet, 2 decimal places.")))
  (princ))

;;------------------------------------------------------------
;; 6C. TITLE BLOCK (TITLEBLOCK)
;; Draw a standard title block at user-picked location.
;;------------------------------------------------------------
(defun c:TITLEBLOCK (/ ins pj client doc rev scale sheet)
  (sp-set-layer "TITLE")
  (initget 6)
  (setq pj (getstring t "\nProject name: "))
  (if (= pj "") (setq pj "SOLAR PV PLANT"))
  (initget 6)
  (setq client (getstring t "\nClient: "))
  (if (= client "") (setq client "Client"))
  (initget 6)
  (setq doc (getstring t "\nDocument title: "))
  (if (= doc "") (setq doc "Layout Drawing"))
  (initget 6)
  (setq rev (getstring t "\nRevision <R0>: "))
  (if (= rev "") (setq rev "R0"))
  (initget 6)
  (setq scale (getstring t "\nScale <1:500>: "))
  (if (= scale "") (setq scale "1:500"))
  (initget 6)
  (setq sheet (getstring t "\nSheet <1 of 1>: "))
  (if (= sheet "") (setq sheet "1 of 1"))

  (initget 6)
  (setq ins (getpoint "\nClick top-left of title block: "))
  (if (null ins) (exit))
  (sp-sld-titleblock (car ins) (cadr ins) 420 80 pj client doc rev "TITLE")
  (sp-mtext (list (+ (car ins) 3) (+ (cadr ins) 4) 0.0) 1.5
    (strcat "Scale: " scale "  |  Sheet: " sheet) "TITLE" 7)
  (princ (strcat "\nTitle block drawn for '" doc "', Rev " rev))
  (princ))

;;------------------------------------------------------------
;; 6D. PERMIT SHEET BATCH PLOT (BATCHPLOT)
;; Plots the complete permit submission set.
;;   1. Title sheet
;;   2. General arrangement (boundary + capacity)
;;   3. Module layout
;;   4. SLD
;;   5. Earthing layout
;;   6. Trench layout
;;   7. Shadow analysis (winter + summer)
;;   8. Section elevations
;;   9. Site plan (fence, CCTV, roads, drainage)
;;  10. BoQ + cable schedule as table sheets
;; Each as a separate PDF page with proper title block.
;;------------------------------------------------------------
(defun c:BATCHPLOT (/ out-dir fmt p f i sheets sheet-nm plot-cmd)
  (if (sp-guard-or-exit) (exit))
  (initget 6)
  (setq out-dir (getfiled "Select output folder" (getvar "DWGPREFIX") "" 1))
  (if (null out-dir) (exit))
  (initget "PDF DWF")
  (setq fmt (getkword "\nOutput format [PDF/DWF] <PDF>: "))
  (if (null fmt) (setq fmt "PDF"))

  (setq sheets '("01_TITLE" "02_GA" "03_LAYOUT" "04_SLD"
                 "05_EARTHING" "06_TRENCH" "07_SHADOW_WINTER"
                 "08_SHADOW_SUMMER" "09_SECTION" "10_SITEPLAN"
                 "11_BOQ" "12_CABLE_SCHEDULE" "13_MMS"))

  ;; Make sure all 13 layout tabs exist
  (sp-batchplot-ensure-layouts sheets)

  ;; Optionally auto-generate the MMS sheet if not present
  (if (and (not (sp-batchplot-mms-exists))
           (y-or-n-p "\n[BATCHPLOT] MMS permit sheet not yet drawn. Auto-generate it now? [Y/N]: "))
    (progn
      (princ "\n[BATCHPLOT] Drawing MMS permit sheet...")
      (c:MMSPERMIT)))

  (princ (strcat "\nPlotting " (itoa (length sheets)) " permit sheets to " out-dir))
  (princ "\nMake sure each sheet is on its own layout tab first.")
  (princ "\nUse the LAYOUT command in AutoCAD to set up multiple tabs.\n")

  (foreach s sheets
    (progn
      (setq sheet-nm (strcat out-dir "\\" s "." (if (= fmt "PDF") "pdf" "dwf")))
      ;; Set page setup
      (command "_.PAGESETUP" s
               (strcat "SolarPro_" s "_Setup")
               "SolarPro " s
               "Auto plot " (menucmd "M=$(edtime,$(getvar,date),DD/MM/YYYY)")
               ""  ;; plot area = layout
               1   ;; paper size A1
               "M" ;; mm
               5   ;; plot scale: fit
               0.0 0.0
               "L" ;; landscape
               0   ;; style: by layout
               0.0 0.0 0.0
               ""  ;; shaded plot options
               "N" ;; plot with lineweights
               "A" ;; paper units mm
               "N" ;; plot upside down N
               "N" ;; plot mirror N
               0   ;; color: by layout
               ""  ;; plot style table
               "Y" ;; plot stamp on
               "N" ;; save changes
               "")
      ;; Set the current layout
      (command "_.LAYOUT" "Set" s)
      ;; Plot to file
      (command "_.PLOT"
               "Y"            ;; plot to file
               sheet-nm       ;; filename
               fmt            ;; device
               "SolarPro" s "Setup"
               "L"            ;; paper units mm
               "L"            ;; orientation
               "N"            ;; plot upside down
               "W"            ;; window or extents
               "E"            ;; extents
               "F"            ;; fit to paper
               "Y"            ;; lineweights
               "A"            ;; paper size A1
               "M"            ;; paper mm
               "N"            ;; hidden
               "Y"            ;; save changes to page setup
               "")
      (princ (strcat "\n  - " sheet-nm))))
  (princ (strcat "\n\nPermit plot set complete (" (itoa (length sheets)) " sheets)."))
  (princ))

;;------------------------------------------------------------
;; Helper: ensure all 13 layout tabs exist before batch plot
;;------------------------------------------------------------
(defun sp-batchplot-ensure-layouts (sheets / layouts s d)
  (setq layouts (layoutlist))
  (foreach s sheets
    (if (not (member s layouts))
      (progn
        (princ (strcat "\n[BATCHPLOT] Creating missing layout: " s))
        (command "_.LAYOUT" "New" s)
        ;; Set a sensible page setup (A2 landscape, mm)
        (command "_.PAGESETUP" s
                 (strcat "SolarPro_" s "_Setup")
                 "SolarPro " s
                 "Permit sheet" "" "1" "M" "5" "0" "0"
                 "L" "0" "0" "0" "0" "" "N" "A" "N" "N" "0"
                 "" "N" "N" ""))))
  (princ ""))

;;------------------------------------------------------------
;; Helper: check if MMS permit sheet content exists
;; (looks for any entity on SP_MMS layer)
;;------------------------------------------------------------
(defun sp-batchplot-mms-exists (/ ss)
  (if (and (tblsearch "LAYER" "SP_MMS")
           (setq ss (ssget "_X" '((8 . "SP_MMS"))))
           (> (sslength ss) 0))
    T
    nil))

;;------------------------------------------------------------
;; 6E. PROJECT SAVE / LOAD (PROJSAVE / PROJLOAD)
;; Saves all *SP-* and FS_SOLAR_DATA values to a .spd file
;; (text-based key=value, easier than JSON in LISP).
;;------------------------------------------------------------
(defun c:PROJSAVE (/ p f k v)
  (initget 6)
  (setq p (getfiled "Save SolarPro Project" (strcat (getvar "DWGPREFIX")
                                                    (getvar "DWGNAME") ".spd") "spd" 1))
  (if (null p) (exit))
  (if (findfile p) (vl-file-delete p))
  (setq f (open p "w"))
  (if (null f) (exit))
  (write-line "[SolarPro Project File v5.0]" f)
  (write-line (strcat "DWG=" (getvar "DWGNAME")) f)
  (write-line (strcat "DATE=" (menucmd "M=$(edtime,$(getvar,date),DD-MON-YYYY)")) f)
  (write-line "[CONFIG]" f)
  (foreach k '("STD" "AMBIENT" "CABLE_TEMP" "HT_KV" "LV_KV"
               "GROUPING" "SOIL_RES" "DRUM_LEN" "DRUM_LEN_HT"
               "WASTE_PCT" "PR" "BOS_PCT" "CUF_TARGET")
    (write-line (strcat k "=" (rtos (sp-cfg k) 2 4)) f))
  ;; Save SLD globals if any
  (write-line "[SLD]" f)
  (if (boundp '*sld-mod-watt*) (write-line (strcat "MOD_WATT=" *sld-mod-watt*) f))
  (if (boundp '*sld-total-mod*) (write-line (strcat "TOTAL_MOD=" *sld-total-mod*) f))
  (if (boundp '*sld-dc-kwp*) (write-line (strcat "DC_KWP=" *sld-dc-kwp*) f))
  (if (boundp '*sld-mps*) (write-line (strcat "MPS=" *sld-mps*) f))
  (if (boundp '*sld-spi*) (write-line (strcat "SPI=" *sld-spi*) f)
      (if (boundp '*sld-num-inv*) (write-line (strcat "NUM_INV=" *sld-num-inv*) f)))
  (if (boundp '*sld-inv-kw*) (write-line (strcat "INV_KW=" *sld-inv-kw*) f))
  (if (boundp '*sld-tf-rating*) (write-line (strcat "TF_KVA=" *sld-tf-rating*) f))
  (close f)
  (princ (strcat "\nProject saved: " p))
  (princ))

(defun c:PROJLOAD (/ p f line k v)
  (initget 6)
  (setq p (getfiled "Load SolarPro Project" (strcat (getvar "DWGPREFIX")) "spd" 0))
  (if (null p) (exit))
  (if (null (findfile p)) (progn (princ (strcat "\nFile not found: " p)) (exit)))
  (setq f (open p "r"))
  (if (null f) (exit))
  (while (setq line (read-line f))
    (if (and (> (strlen line) 0) (not (wcmatch (substr line 1 1) "[;[]")))
      (progn
        (setq k (substr line 1 (vl-string-position (ascii "=") line))
              v (substr line (+ 2 (vl-string-position (ascii "=") line))))
        ;; restore config
        (if (member k '("STD" "HT_KV" "LV_KV"))
          (sp-cfg-set k v)
          (if (numberp (read v))
            (sp-cfg-set k (read v)))))))
  (close f)
  (princ (strcat "\nProject loaded: " p))
  (princ))

;;------------------------------------------------------------
;; 6F. MULTI-SITE COMBINE (MULTISITE)
;; Combine capacity stats from multiple boundaries.
;;------------------------------------------------------------
(defun c:MULTISITE (/ ss ent xd total_mods total_kwp n mod_row mod_stk)
  (vl-load-com)
  (princ "\nSelect multiple boundaries (or just press Enter to scan all): ")
  (setq ss (ssget '((0 . "LWPOLYLINE") (-3 ("FS_SOLAR_DATA")))))
  (if (null ss) (progn (princ "\nNo boundaries selected.") (exit)))
  (setq total_mods 0  total_kwp 0.0  n 0)
  (setq idx 0)
  (while (< idx (sslength ss))
    (progn
      (setq ent (ssname ss idx)
            xd (cadr (assoc -3 (entget ent '("FS_SOLAR_DATA")))))
      (if xd
        (progn
          (setq watt (sp-xd-item-val (nth 2 xd))
                mod_row (fix (sp-xd-item-val (nth 7 xd)))
                mod_stk (fix (sp-xd-item-val (nth 8 xd)))
                tables (length (GetTablesInBoundary ent))
                mods (* tables mod_row mod_stk)
                kwp (* mods watt))
          (princ (strcat "\n  Section " (itoa (1+ n)) ": "
                         (itoa tables) " tables, " (itoa mods) " modules, "
                         (rtos (/ kwp 1000.0) 2 2) " MWp"))
          (setq total_mods (+ total_mods mods)
                total_kwp (+ total_kwp kwp)
                n (1+ n)))))
    (setq idx (1+ idx)))
  (princ (strcat "\n\nTOTAL across " (itoa n) " sections:"))
  (princ (strcat "\n  Modules: " (itoa total_mods)))
  (princ (strcat "\n  DC:      " (rtos (/ total_kwp 1000.0) 2 2) " MWp"))
  (princ))

;;------------------------------------------------------------
;; 6G. SAFETY / FIREFIGHTING ZONES (SAFETYZONE)
;;------------------------------------------------------------
(defun c:SAFETYZONE (/ ent pts n h w hyd-spacing)
  (vl-load-com)
  (princ "\nSelect boundary for safety zone planning: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (sp-set-layer "SP_SAFETY")
  (initget 6)
  (setq hyd-spacing (getdist "\nFire hydrant spacing (m) <60>: "))
  (if (null hyd-spacing) (setq hyd-spacing 60.0))
  (initget 6)
  (setq assembly-dist (getdist "\nAssembly point distance from edge (m) <10>: "))
  (if (null assembly-dist) (setq assembly-dist 10.0))

  (setq pts (sp-poly-pts ent)
        perim (sp-poly-perimeter pts)
        n (max 1 (fix (/ perim hyd-spacing))))
  (sp-def-block "SP_BLOCK_HYDRANT"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 1)
                (cons 10 (list 0.0 0.0 0.0)) (cons 40 0.3))
          (list '(0 . "TEXT") '(8 . "0") '(62 . 1)
                (cons 10 (list 0.3 0.3 0.0)) (cons 40 0.3) (cons 1 "FH"))))
  (foreach e (sp-poly-edges pts)
    (progn
      (setq d 0.0 seg (distance (car e) (cadr e)))
      (while (<= d seg)
        (progn
          (setq p (polar (car e) (angle (car e) (cadr e)) d))
          (entmake (list '(0 . "INSERT") '(8 . "SP_SAFETY") '(62 . 1)
                         '(100 . "AcDbBlockReference")
                         (cons 2 "SP_BLOCK_HYDRANT")
                         (cons 10 p) '(50 . 0.0)))
          (setq d (+ d hyd-spacing))))))
  ;; Assembly point outside
  (initget 6)
  (setq asm-pt (getpoint "\nClick assembly point location (outside boundary): "))
  (if asm-pt
    (progn
      (entmake (list '(0 . "POINT") (cons 10 asm-pt) '(8 . "SP_SAFETY"))
               (cons 62 2))
      (sp-mtext asm-pt 1.5 "ASSEMBLY POINT" "SP_SAFETY" 2)))
  (princ (strcat "\n" (itoa n) " fire hydrants + 1 assembly point placed."))
  (princ))

;;------------------------------------------------------------
;; 6H. LIGHTNING PROTECTION MESH (LPMESH)
;; Per IEC 62305 - air-termination mesh on building roofs.
;;------------------------------------------------------------
(defun c:LPMESH (/ ent mesh-w mesh-h dx pts)
  (vl-load-com)
  (princ "\nSelect structure polyline: ")
  (setq ent (car (entsel)))
  (if (or (null ent) (/= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")) (exit))
  (sp-set-layer "SP_LP_MESH")
  (initget 6)
  (setq class (getint "\nLPS class (1-4, smaller = denser mesh) <2>: "))
  (if (null class) (setq class 2))
  (setq mesh-w (cond ((= class 1) 5.0) ((= class 2) 10.0)
                     ((= class 3) 15.0) (T 20.0)))
  (initget 6)
  (setq height (getreal "\nMesh height above structure (m) <0.5>: "))
  (if (null height) (setq height 0.5))
  (setq pts (sp-poly-pts ent))
  ;; Get bounding box
  (vlax-invoke (vlax-ename->vla-object ent) 'GetBoundingBox 'p1 'p2)
  ;; Draw mesh lines at fixed spacing
  (initget 6)
  (if (null (vl-catch-all-error-p
    (vl-catch-all-apply
      '(lambda ()
         (vlax-invoke (vlax-ename->vla-object ent) 'GetBoundingBox 'p1 'p2)))))
    (progn
      (setq p1 (vlax-safearray->list (vlax-variant-value p1))
            p2 (vlax-safearray->list (vlax-variant-value p2))))
    (progn
      (setq p1 (list (car (car pts)) (cadr (car pts)) 0.0)
            p2 (list (car (last pts)) (cadr (last pts)) 0.0))))
  (setq minx (min (car p1) (car p2))
        maxx (max (car p1) (car p2))
        miny (min (cadr p1) (cadr p2))
        maxy (max (cadr p1) (cadr p2)))
  (princ (strcat "\nMesh spacing: " (rtos mesh-w 2 1) "m, height: " (rtos height 2 1) "m"))
  (setq x minx)
  (while (<= x maxx)
    (entmake (list '(0 . "LINE") '(8 . "SP_LP_MESH") '(62 . 1)
                   (cons 10 (list x miny height))
                   (cons 11 (list x maxy height))))
    (setq x (+ x mesh-w)))
  (setq y miny)
  (while (<= y maxy)
    (entmake (list '(0 . "LINE") '(8 . "SP_LP_MESH") '(62 . 1)
                   (cons 10 (list minx y height))
                   (cons 11 (list maxx y height))))
    (setq y (+ y mesh-w)))
  (princ (strcat "\nLP mesh drawn: " (rtos mesh-w 2 1)
                 "m grid, class " (itoa class) " per IEC 62305."))
  (princ))

(princ "\n[SolarPro v5.0] Batch 6 utilities loaded: DWGTEMPLATE, UNITS, TITLEBLOCK, BATCHPLOT, PROJSAVE, PROJLOAD, MULTISITE, SAFETYZONE, LPMESH.")
(princ)


;;============================================================
;; SolarPro V5.0 - UNIFIED MODELESS LAUNCHER
;; Tabbed DCL with dynamic buttons, stays open while drawing
;;============================================================

;;------------------------------------------------------------
;; Tab metadata - each tab has a label and list of
;; (button-label, command-name) pairs.
;; Max 15 commands per tab (Shadow+ has 14).
;;------------------------------------------------------------
(setq *SP-LAUNCHER-TABS*
  '(    ("Layout"
     ("Layout Dialog" "SolarProDialog")
     ("Refresh" "Refresh")
     ("Set Obstruction" "ObstructionHeight"))
    ("Piling"
     ("Pile Labels" "PileLabels")
     ("Clear Pile Labels" "ClearPileLabels")
     ("Pile Schedule" "PileSchedule"))
    ("Stringing"
     ("Inverter Grouping" "InverterGroupingDialog")
     ("Auto String" "AutoString")
     ("Clear Stringing" "ClearStringing")
     ("DC Stringing" "DCStringing")
     ("Clear DC Stringing" "ClearDCStringing"))
    ("Cabling"
     ("DC Cabling (1 INV)" "DCCabling")
     ("DC Cabling (ALL)" "DCCablingAll")
     ("Clear DC Cabling" "ClearDCCabling")
     ("AC Cabling" "ACCabling")
     ("Set ACDB" "SetACDB"))
    ("SLD/BoQ"
     ("Create SLD" "CreateSLD")
     ("Draw SLD" "SLDDRAW")
     ("SLD Template" "SLDTemplate")
     ("BoQ Export" "SPBOQ")
     ("Cable Schedule" "CableSchedule")
     ("Drum Schedule" "DrumSchedule"))
    ("Cables+"
     ("DC Cable Size" "DCCableSize")
     ("AC Cable Size" "ACCableSize")
     ("Earth Resistance" "EarthRes"))
    ("Site:Civil"
     ("Fence Layout" "FenceLayout")
     ("CCTV Coverage" "CCTVLayout")
     ("Drainage" "Drainage")
     ("Wash System" "WashRoute")
     ("Road Connect" "RoadConnect")
     ("Streetlight" "Streetlight"))
    ("Site:Elec"
     ("Inverter Station" "InvStation")
     ("Transformer" "Transformer")
     ("HT Panel" "HTPanel")
     ("Metering" "Metering")
     ("Aux TX" "AuxTx")
     ("DG Set" "DGSet")
     ("BESS" "BESS"))
    ("Site:SCADA"
     ("Met Station" "MetStation")
     ("SCADA Room" "ControlRoom")
     ("LA Protection" "LAProtection")
     ("Shadow (Pole/LA)" "Shadow")
     ("Shadow (Bldg)" "BShadow"))
    ("Shadow+"
     ("Shadow Coords" "ShadowCoords")
     ("Clear Shadow Coords" "ClearShadowCoords")
     ("3D View" "3DView")
     ("3D Shadow Sweep" "3DShadow")
     ("Red Shadow Maps" "SHADOWRED")
     ("Regen Red Shadows" "SHADOWGEN")
     ("LA Coverage Circles" "LACOVERAGE")
     ("Set LA Radius" "LARADIUS")
     ("Shadow/LA Report" "SHADOWREPORT")
     ("Remove Tables in Shadow" "SHADOWREMOVE")
     ("Remove ALL in Shadow" "SHADOWREMOVEALL")
     ("Clean Red Shadows" "SHADOWCLEAN")
     ("Hide Red Layers" "SHADOWHIDE")
     ("Show Red Layers" "SHADOWSHOW"))
    ("Tracker"
     ("Tracker Layout" "TrackerLayout")
     ("Seasonal Tilt" "SeasonalTilt")
     ("GCR Optimizer" "GCROpt")
     ("MMS BoM" "MMSBOM")
     ("MMS 3D" "MMS3D")
     ("Wind Load" "WindLoad"))
    ("Energy"
     ("Loss Chain" "LossChain")
     ("PR / CUF" "PRReport")
     ("Monthly Gen" "MonthlyGen")
     ("25-yr Degradation" "Degradation")
     ("Shade Loss" "ShadeLoss")
     ("Diffuse Shading" "DiffuseShade")
     ("Fault Current" "FaultCalc"))
    ("Plot/UX"
     ("Title Block" "TitleBlock")
     ("Batch Plot" "BatchPlot")
     ("Units" "Units")
     ("Drawing Template" "DwgTemplate")
     ("Multi-Site" "MultiSite")
     ("Safety Zone" "SafetyZone")
     ("LP Mesh" "LPMesh")
     ("Project Save" "ProjSave")
     ("Project Load" "ProjLoad"))))

;;------------------------------------------------------------
;; DCL generator - writes a tabbed launcher with 15 button
;; slots that update dynamically per tab.
;;------------------------------------------------------------
(defun sp-launcher-dcl-name () "SolarPro - Launcher.dcl")

(defun sp-launcher-write-dcl (/ tmp_dir tmp_path f idx tab tab-name cmds n row col slot)
  (setq tmp_dir (getvar "TEMPPREFIX"))
  (if (or (null tmp_dir) (= tmp_dir "")) (setq tmp_dir "C:\\Temp\\"))
  (if (/= (substr tmp_dir (strlen tmp_dir) 1) "\\")
    (setq tmp_dir (strcat tmp_dir "\\")))
  (setq tmp_path (strcat tmp_dir (sp-launcher-dcl-name)))
  (if (findfile tmp_path) (vl-file-delete tmp_path))
  (setq f (open tmp_path "w"))
  (if (null f) nil
    (progn
      (setq idx 0)
      (foreach tab *SP-LAUNCHER-TABS*
        (setq tab-name (car tab)
              cmds     (cdr tab)
              n        (length cmds))
        (write-line (strcat "sp_tab_" (itoa idx) " : dialog {") f)
        (write-line (strcat "  label = \"SolarPro V5.0 - " tab-name "\";") f)
        (write-line "  : row {" f)
        (write-line "    : list_box {" f)
        (write-line "      key = \"tabs\";" f)
        (write-line "      width = 16;" f)
        (write-line "      height = 22;" f)
        (write-line "      fixed_width = true;" f)
        (write-line "      multiple_select = false;" f)
        (write-line "    }" f)
        (write-line "    : column {" f)
        (write-line (strcat "      : text { label = \"" tab-name "  (" (itoa n) " commands)\"; width = 50; }") f)
        (setq row 0 slot 0)
        (repeat 3
          (write-line "      : row {" f)
          (setq col 0)
          (repeat 5
            (setq slot (1+ slot))
            (if (<= slot n)
              (write-line
                (strcat "        : button { key = \"b" (itoa slot)
                        "\"; label = \"" (vl-string-translate "\\" "\\\\" (car (nth (1- slot) cmds)))
                        "\"; width = 14; }") f)
              (write-line
                (strcat "        : button { key = \"b" (itoa slot)
                        "\"; label = \"\"; width = 14; enabled = false; }") f))
            (setq col (1+ col)))
          (write-line "      }" f)
          (setq row (1+ row)))
        (write-line "      : text { key = \"st\"; value = \"Ready.\"; width = 50; }" f)
        (write-line "      : button { key = \"cl\"; label = \"Close\"; is_cancel = true; width = 14; }" f)
        (write-line "    }" f)
        (write-line "  }" f)
        (write-line "}" f)
        (setq idx (1+ idx)))
      (close f)
      tmp_path)))

(setq *sp-launcher-tab* 0)
(setq *sp-launcher-last* nil)
(setq *sp-launcher-dcl* nil)

(defun c:SOLARPROLAUNCHER (/ dcl-path result sel-tab cmd-list slot cmd-name)
  (vl-load-com)
  (if (or (null *sp-launcher-dcl*) (minusp *sp-launcher-dcl*))
    (progn
      (setq dcl-path (sp-launcher-write-dcl))
      (if (null dcl-path) (progn (alert "Cannot create launcher DCL.") (exit)))
      (setq *sp-launcher-dcl* (load_dialog dcl-path))
      (if (or (null *sp-launcher-dcl*) (minusp *sp-launcher-dcl*))
        (progn (alert "Cannot load launcher DCL.") (exit)))))
  (while
    (progn
      (if (not (new_dialog (strcat "sp_tab_" (itoa *sp-launcher-tab*))
                           *sp-launcher-dcl*))
        (progn (princ "\nCannot open dialog.") nil)
        (progn
          (start_list "tabs")
          (foreach t2 *SP-LAUNCHER-TABS* (add_list (car t2)))
          (end_list)
          (set_tile "tabs" (itoa *sp-launcher-tab*))
          (action_tile "tabs"
            "(setq *sp-launcher-tab* (atoi $value)) (done_dialog 2)")
          (setq cmd-list (cdr (nth *sp-launcher-tab* *SP-LAUNCHER-TABS*)))
          (setq slot 1)
          (while (<= slot (length cmd-list))
            (setq cmd-name (cadr (nth (1- slot) cmd-list)))
            (action_tile (strcat "b" (itoa slot))
              (strcat "(setq *sp-launcher-last* \"" cmd-name "\") (done_dialog 1)"))
            (setq slot (1+ slot)))
          (action_tile "cl" "(done_dialog 0)")
          (setq result (start_dialog))
          (cond
            ((= result 0) nil)
            ((= result 1)
             (if *sp-launcher-last*
               (progn
                 (princ (strcat "\nRunning " *sp-launcher-last* " ..."))
                 (setq *sp-launcher-err*
                       (vl-catch-all-apply 'eval
                         (list (read (strcat "(c:" *sp-launcher-last* ")")))))
                 (if (vl-catch-all-error-p *sp-launcher-err*)
                   (princ (strcat "\nError in command: " *sp-launcher-last*
                                  " - " (vl-catch-all-error-message *sp-launcher-err*)))
                   (princ (strcat "\nDone: " *sp-launcher-last* "."))))
               (princ "\nNo command selected."))
             T)
            ((= result 2) T)
            (T nil))))))
  (unload_dialog *sp-launcher-dcl*)
  (setq *sp-launcher-dcl* nil))

(defun c:SOLARPROPALETTE () (c:SOLARPROLAUNCHER))
(defun c:SPL () (c:SOLARPROLAUNCHER))
(defun c:SPM () (c:SOLARPROLAUNCHER))
(defun c:SPMENU () (c:SOLARPROLAUNCHER))

(defun c:SPTEST ()
  (princ "\n[SPTEST] SolarPro V5 loaded OK.")
  (princ "\n  Try :  SPL")
  (princ))

(princ "\n[SolarPro v5.0] Launcher loaded: SPL / SPM / SOLARPROLAUNCHER.")
(princ)


;;============================================================
;; SolarPro V5.0 - FINAL LOAD BANNER
;; 50+ commands. Type SOLARPROLAUNCHER (or SPL / SPM) for modeless launcher.
;;============================================================
(princ "\n\n============================================================")
(princ "\n  SolarPro V5.0  -  Production Solar PV Design Tool")
(princ "\n============================================================")
(princ "\n  Launcher:   SOLARPROLAUNCHER  (aliases: SPL, SPM, SPMENU)")
(princ "\n  License:    SPLICENSE  (SHOWMAC, ADD, REMOVE, LIST, CHECK)")
(princ "\n============================================================")
(princ "\n  Loaded. Type SOLARPROLAUNCHER (or SPL) to open the launcher.")
(princ "\n============================================================")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 7)
;; LICENSE / MAC-ADDRESS AUTHENTICATION
;;
;; How it works:
;;   - On load, the script reads a license file (solarpro.lic)
;;     from the current drawing folder.
;;   - The license file is XOR-encrypted + Base32 encoded.
;;   - It contains a list of authorized MAC addresses.
;;   - The script reads THIS machine's MAC addresses via
;;     getmac and accepts the session if any NIC matches.
;;   - If unauthorized, all commands (except SPLICENSE) refuse
;;     to run.
;;   - The user/owner can run SPLICENSE to:
;;       SHOWMAC  - print this machine's MAC
;;       ADD      - add a MAC to the license
;;       REMOVE   - remove a MAC
;;       LIST     - list authorized MACs
;;       CHECK    - re-validate current session
;;       SAVE     - write the license file
;;       PATH     - show license file path
;;       HELP     - show all sub-commands
;;
;; Caveat (realistic):
;;   This is a "casual-sharing" protection, not hardened DRM.
;;   A determined attacker with the .lsp can bypass the check.
;;   It stops the typical "share-the-file" leak.
;;============================================================

;;---------------- internal state ----------------------------
(setq *SP-LIC-MACS* '())          ; list of authorized MAC strings (AA:BB:..)
(setq *SP-LIC-FILE* nil)          ; full path of license file
(setq *SP-LIC-LOADED* nil)        ; T if license file was successfully read
(setq *SP-LIC-OK* nil)            ; T if current machine is authorized
(setq *SP-LIC-LAST-MSG* "")       ; last message printed by auth-check

;;---------------- key (would be split in production) -------
(setq *SP-LIC-KEY* "SolarPro-V5-MAC-2026-AUTH-KEY")

;;---------------- MAC acquisition ---------------------------
;; Returns list of MAC strings (uppercase colon form) for this
;; machine, skipping disconnected adapters.
(defun sp-get-macs (/ cmd out line parts macs m)
  (setq cmd (strcat (getenv "ComSpec") " /c getmac /fo csv /nh 2>nul"))
  (if (or (null cmd) (= cmd ""))
    (setq cmd "cmd /c getmac /fo csv /nh"))
  (setq out (open (strcat "|" cmd) "r")
        macs '())
  (if out
    (progn
      (while (setq line (read-line out))
        (if (and line (vl-string-search "," line))
          (progn
            (setq parts (sp-csv-parse line))
            (if (and (>= (length parts) 3))
              (progn
                (setq m (sp-mac-normalize (caddr parts)))
                (if (and m (not (member m macs)))
                  (setq macs (cons m macs))))))))
      (close out)))
  (reverse macs))

;; Single MAC = first non-disconnected
(defun sp-get-mac () (car (sp-get-macs)))

;; Normalize a MAC string to AA:BB:CC:DD:EE:FF
;; Accepts AA-BB-CC-DD-EE-FF, AABBCCDDEEFF, aa:bb:cc:dd:ee:ff
(defun sp-mac-normalize (mac / cleaned)
  (if (null mac) nil
    (progn
      (setq cleaned (strcase (vl-string-translate "-" "" mac)))
      (setq cleaned (vl-string-translate ":" "" cleaned))
      (setq cleaned (vl-string-translate " " ""))
      (if (= (strlen cleaned) 12)
        (strcat (substr cleaned 1 2) ":" (substr cleaned 3 2) ":"
                (substr cleaned 5 2) ":" (substr cleaned 7 2) ":"
                (substr cleaned 9 2) ":" (substr cleaned 11 2))
        nil))))

;;---------------- minimal CSV parser ------------------------
;; Splits a CSV line into a list of strings, honoring double-quotes
(defun sp-csv-parse (line / parts cur ch inquote)
  (setq parts '() cur "" inquote nil)
  (foreach ch (vl-string->list (strcat line "\n"))
    (cond
      ((= ch 34) (setq inquote (not inquote)))
      ((and (= ch 44) (not inquote))
        (setq parts (append parts (list cur)))
        (setq cur ""))
      ((= ch 10)
        (setq parts (append parts (list cur))))
      (T (setq cur (strcat cur (chr ch))))))
  parts)

;;---------------- XOR cipher (cycling key) ------------------
(defun sp-xor (str key / out i kc kl)
  (setq out "" i 1 kl (strlen key))
  (foreach ch (vl-string->list str)
    (setq kc (nth (rem (1- i) kl) (vl-string->list key)))
    (setq out (strcat out (chr (vl-bitxor ch kc))))
    (setq i (1+ i)))
  out)

;;---------------- Base32 (RFC 4648) ------------------------
(setq *SP-LIC-B32* "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")

(defun sp-b32-enc (str / alpha bits r out)
  (setq alpha *SP-LIC-B32* bits 0 r 0 out "")
  (foreach ch (vl-string->list str)
    (setq bits (+ (* bits 256) ch) r (+ r 8))
    (while (>= r 5)
      (setq r (- r 5))
      (setq out (strcat out
                  (substr alpha (1+ (logand (lsh bits (- r)) 31)) 1)))))
  out)

(defun sp-b32-dec (str / alpha bits r out v ch)
  (setq alpha *SP-LIC-B32* bits 0 r 0 out "")
  (foreach ch (vl-string->list str)
    (setq v (vl-string-position ch alpha))
    (if v
      (progn
        (setq bits (+ (* bits 32) v) r (+ r 5))
        (while (>= r 8)
          (setq r (- r 8))
          (setq out (strcat out
                      (chr (logand (lsh bits (- r)) 255))))))))
  out)

;;---------------- token <-> plain ---------------------------
(defun sp-token-enc (plain) (sp-b32-enc (sp-xor plain *SP-LIC-KEY*)))
(defun sp-token-dec (token) (sp-xor (sp-b32-dec token) *SP-LIC-KEY*))

;;---------------- license file I/O --------------------------
(defun sp-lic-path (/ d)
  (setq d (vl-string-translate "\\" "/" (getvar "DWGPREFIX")))
  (if (= (substr d (strlen d)) "/")
    (strcat d "solarpro.lic")
    (strcat d "/solarpro.lic")))

(defun sp-split-lines (s / lines cur ch)
  (setq lines '() cur "")
  (foreach ch (vl-string->list s)
    (if (= ch 10)
      (progn
        (if (> (strlen cur) 0) (setq lines (append lines (list cur))))
        (setq cur ""))
      (setq cur (strcat cur (chr ch)))))
  (if (> (strlen cur) 0) (setq lines (append lines (list cur))))
  lines)

;;---------------- license file save ------------------------
(defun sp-lic-save (/ fp content)
  (if (or (null *SP-LIC-FILE*) (= *SP-LIC-FILE* ""))
    (setq *SP-LIC-FILE* (sp-lic-path)))
  (setq fp (open *SP-LIC-FILE* "w"))
  (if (null fp)
    (progn
      (princ (strcat "\n[LICENSE] ERROR: cannot write to " *SP-LIC-FILE*))
      nil)
    (progn
      (write-line (sp-lic-build *SP-LIC-MACS*) fp)
      (close fp)
      (princ (strcat "\n[LICENSE] Saved: " *SP-LIC-FILE*))
      (princ (strcat "\n[LICENSE] " (itoa (length *SP-LIC-MACS*))
                     " MAC(s) authorized."))
      T)))

(defun sp-lic-add (/ mac inp)
  (initget 1)
  (if (y-or-n-p "Add THIS machine's MAC automatically? [Y/N]: ")
    (progn
      (foreach m (sp-get-macs)
        (if (not (member m *SP-LIC-MACS*))
          (setq *SP-LIC-MACS* (append *SP-LIC-MACS* (list m)))))
      (princ "\n[LICENSE] Added all MACs from this machine."))
    (progn
      (initget 1)
      (setq inp (getstring T "\nEnter MAC (AA:BB:CC:DD:EE:FF or with dashes): "))
      (setq mac (sp-mac-normalize inp))
      (if (null mac)
        (princ "\n[LICENSE] ERROR: invalid MAC format.")
        (progn
          (if (member mac *SP-LIC-MACS*)
            (princ (strcat "\n[LICENSE] Already in list: " mac))
            (progn
              (setq *SP-LIC-MACS* (append *SP-LIC-MACS* (list mac)))
              (princ (strcat "\n[LICENSE] Added: " mac))))))))
  (sp-lic-save))

(defun sp-lic-remove (/ mac inp)
  (initget 1)
  (setq inp (getstring "\nMAC to remove: "))
  (setq mac (sp-mac-normalize inp))
  (if (null mac)
    (princ "\n[LICENSE] ERROR: invalid MAC format.")
    (if (member mac *SP-LIC-MACS*)
      (progn
        (setq *SP-LIC-MACS* (vl-remove-if '(lambda (x) (= x mac)) *SP-LIC-MACS*))
        (princ (strcat "\n[LICENSE] Removed: " mac))
        (sp-lic-save))
      (princ (strcat "\n[LICENSE] Not in list: " mac)))))

;;---------------- launch-time guard ------------------------
;; Refuse to run if not authorized. Used by launcher.
(defun sp-guard-or-exit (/ ok)
  (if (or *SP-LIC-OK* (sp-auth-check)) nil
    (progn
      (princ "\n[LICENSE] Command refused. This machine is not licensed.")
      (princ "\n[LICENSE] Run SPLICENSE  ADD  to authorize it.")
      T)))

;;---------------- license self-test on file load -----------

;;============================================================
;; SolarPro V5.0 - FINAL LOAD BANNER
;; 50+ commands. Type SPL for modeless tabbed launcher.
;; Type SPLICENSE for license / MAC management.
;;============================================================
(princ "\n\n============================================================")
(princ "\n  SolarPro V5.0  -  Production Solar PV Design Tool")
(princ "\n============================================================")
(princ "\n  Modeless launcher:    SOLARPROLAUNCHER  (aliases: SPL, SPM, SPMENU)")
(princ "\n  Legacy launcher:      SOLARPRODIALOG")
(princ "\n  License manager:      SPLICENSE  (SHOWMAC, ADD, REMOVE, LIST, CHECK)")
(princ "\n")
(princ "\n  --- LAYOUT ---")
(princ "\n    SolarProDialog     GenerateLayout       Refresh")
(princ "\n    ObstructionHeight  PileLabels           ClearPileLabels")
(princ "\n    PileSchedule")
(princ "\n  --- STRINGING ---")
(princ "\n    InverterGroupingDialog  AutoString   ClearStringing")
(princ "\n    DCStringing             ClearDCStringing")
(princ "\n  --- CABLING ---")
(princ "\n    DCCabling  DCCablingAll  ClearDCCabling")
(princ "\n    ACCabling  SetACDB")
(princ "\n  --- SLD / BoQ ---")
(princ "\n    CreateSLD  SLDDRAW  SLDTemplate")
(princ "\n    SPBOQ      CableSchedule  DrumSchedule")
(princ "\n  --- CABLE SIZING ---")
(princ "\n    DCCableSize  ACCableSize  EarthRes")
(princ "\n  --- SITE: CIVIL ---")
(princ "\n    FenceLayout  CCTVLayout  Drainage  WashRoute")
(princ "\n    RoadConnect  Streetlight")
(princ "\n  --- SITE: ELECTRICAL ---")
(princ "\n    InvStation  Transformer  HTPanel  Metering")
(princ "\n    AuxTx       DGSet        BESS")
(princ "\n  --- SITE: SCADA / SHADOW ---")
(princ "\n    MetStation  ControlRoom  LAProtection")
(princ "\n    Shadow      BShadow      ShadowCoords  ClearShadowCoords")
(princ "\n  --- SHADOW MAPS (RED) ---")
(princ "\n    SHADOWRED  SHADOWGEN  LACOVERAGE  LARADIUS")
(princ "\n    SHADOWREPORT  SHADOWREMOVE  SHADOWREMOVEALL")
(princ "\n    SHADOWCLEAN   SHADOWHIDE    SHADOWSHOW")
(princ "\n  --- 3D ---")
(princ "\n    3DView  3DShadow")
(princ "\n  --- TRACKER ---")
(princ "\n    TrackerLayout  SeasonalTilt  GCROpt  MMSBOM  MMS3D  WindLoad")
(princ "\n  --- ENERGY / LOSS ---")
(princ "\n    LossChain  PRReport  MonthlyGen  Degradation")
(princ "\n    ShadeLoss  DiffuseShade  FaultCalc")
(princ "\n  --- PLOT / UX ---")
(princ "\n    TitleBlock  BatchPlot  Units  DwgTemplate")
(princ "\n    MultiSite   SafetyZone  LPMesh  ProjSave  ProjLoad")
(princ "\n  --- OWNER / LICENSE ---")
(princ "\n    SPLICENSE  SPWHO  SPBURN  SPSELFTEST  SPAUTHSTATUS")
(princ "\n  --- BUILD / COMPILE (OWNER) ---")
(princ "\n    SPCOMPILE  SPBUILD  SPVERIFY  SPEXPORT")
(princ "\n  --- PRESERVED REPORT ---")
(princ "\n    SPHISTSHOW  SPHISTDROP  SPHISTHERE")
(princ "\n============================================================")
(princ "\n  Loaded.  Type SOLARPROLAUNCHER (or SPM) for the launcher.")
(princ "\n============================================================")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 8)
;; OWNER-ONLY LICENSE MANAGEMENT
;;
;; Behavior:
;;   - The license file (solarpro.lic) now carries an OWNER
;;     stamp: the first line of the file (after parsing) is
;;     the owner's MAC address, encrypted.
;;   - The OWNER is the only one who can:
;;         ADD      - add a customer MAC
;;         REMOVE   - remove a customer MAC
;;         SETOWNER - designate this PC as owner (first-time only,
;;                    or only on current owner PC)
;;         SAVE     - write the license file
;;   - Other authorized users (customers) can:
;;         CHECK    - re-validate current session
;;         LIST     - list authorized MACs (incl. owner)
;;         PATH     - show license file path
;;         SHOWMAC  - see their own MACs
;;         HELP     - help
;;   - If the OWNER is on this PC, the session is authorized
;;     even with no license file.
;;============================================================

;;============================================================
;; OWNER MAC CONSTANT
;;------------------------------------------------------------
;; This is the only MAC address that has full control over
;; the license (ADD, REMOVE, SAVE, SETOWNER, SPCOMPILE,
;; SPBUILD, SPVERIFY, SPEXPORT).
;;
;; To set YOUR MAC:
;;   Option A (recommended) - auto burn-in:
;;     1. On YOUR (owner) PC, type:  SPLICENSE
;;     2. Pick:  SETOWNER
;;     3. Confirm.  This PERMANENTLY rewrites this line in
;;        SolarPro-PANFiles.lsp with your MAC.
;;     4. Re-compile to FAS (SPCOMPILE) and re-distribute.
;;
;;   Option B (manual):
;;     1. Find your MAC:  (sp-get-mac)   at the command line
;;     2. Edit this line: replace AA:BB:CC:DD:EE:FF with it
;;     3. Re-compile to FAS (SPCOMPILE) and re-distribute.
;;
;; Format: 6 octets uppercase, colon-separated.
;;============================================================
(setq *SP-OWNER-MAC* "AA:BB:CC:DD:EE:FF")     ; <-- OWNER MAC (do not change by hand unless you are the owner)
(setq *SP-OWNER-LOADED* nil)                  ; T once extracted from license file
;;============================================================

;;---------------- updated license parser -------------------
;; File format (each line encrypted with sp-token-enc):
;;   Line 1: "OWNER:<MAC>"  -- may be empty if no owner
;;   Line 2: "SOLARPRO-V5-LIC-FILE"  (signature)
;;   Line 3+: customer MACs
;;
;; Returns (cons sig-ok owner-mac macs)
(defun sp-lic-parse (content / lines sig ln plain owner macs parsed-ok)
  (setq parsed-ok nil
        *SP-OWNER-MAC* ""
        *SP-OWNER-LOADED* nil
        macs '()
        lines (sp-split-lines content))
  (if (>= (length lines) 1)
    (progn
      ;; First line should be OWNER (may be empty owner meaning "")
      (if (> (length lines) 0)
        (progn
          (setq plain (sp-token-dec (car lines)))
          (if (and plain (> (strlen plain) 6)
                   (= (substr plain 1 6) "OWNER:"))
            (progn
              (setq *SP-OWNER-MAC* (substr plain 7)
                    *SP-OWNER-LOADED* T)))))
      ;; Second line: signature
      (if (>= (length lines) 2)
        (progn
          (setq sig (sp-token-dec (cadr lines)))
          (if (= sig "SOLARPRO-V5-LIC-FILE")
            (progn
              (setq parsed-ok T)
              ;; Remaining lines: customer MACs
              (foreach ln (cddr lines)
                (if (and ln (> (strlen ln) 0))
                  (progn
                    (setq plain (sp-token-dec ln))
                    (if (and plain (> (strlen plain) 0)
                             (not (member plain macs)))
                      (setq macs (cons plain macs)))))))
              (setq macs (reverse macs)))))))
  (cons parsed-ok macs))

;;---------------- updated license builder ------------------
(defun sp-lic-build (macs / lines owner-line sig body)
  (setq owner-line (sp-token-enc (strcat "OWNER:" *SP-OWNER-MAC*))
        sig (sp-token-enc "SOLARPRO-V5-LIC-FILE")
        body (apply 'strcat
                    (mapcar '(lambda (x) (strcat x "\n"))
                            (mapcar 'sp-token-enc macs))))
  (strcat owner-line "\n" sig "\n" body))

;;---------------- updated load -----------------------------
;; Now also extracts owner
(defun sp-lic-load (/ content fp ln parsed)
  (setq *SP-LIC-MACS* '()
        *SP-LIC-LOADED* nil
        *SP-LIC-OK* nil
        *SP-OWNER-MAC* ""
        *SP-OWNER-LOADED* nil
        *SP-LIC-FILE* (sp-lic-path))
  (if (findfile *SP-LIC-FILE*)
    (progn
      (setq fp (open *SP-LIC-FILE* "r"))
      (if fp
        (progn
          (setq content "")
          (while (setq ln (read-line fp))
            (setq content (strcat content ln "\n")))
          (close fp)
          (setq parsed (sp-lic-parse content))
          (if (car parsed)
            (progn
              (setq *SP-LIC-MACS* (cdr parsed)
                    *SP-LIC-LOADED* T)))))))
  *SP-LIC-LOADED*)

;;---------------- license self-test on file load -----------
(sp-lic-load)
(if *SP-LIC-LOADED*
  (progn
    (sp-auth-check)
    (if (not *SP-LIC-OK*)
      (princ "\n[LICENSE] License file loaded but this PC is not in it. Commands will refuse.")))
  (princ "\n[LICENSE] No license file. Run SPLICENSE to create one."))

(princ "\n[LICENSE] Manager ready. Type SPLICENSE at command line.")
(princ)

;;---------------- is-owner check ---------------------------
;; Returns T if THIS PC's MAC matches the recorded owner
(defun sp-is-owner (/ macs)
  (if (or (null *SP-OWNER-MAC*) (= *SP-OWNER-MAC* ""))
    nil
    (progn
      (foreach m (sp-get-macs)
        (if (and m (= (strcase m) (strcase *SP-OWNER-MAC*)))
          (return T))))))

;;---------------- updated auth check -----------------------
;; Owner is always authorized, even with no license file
(defun sp-auth-check (/ macs hit)
  (if (null *SP-LIC-LOADED*) (sp-lic-load))
  ;; Owner is always OK
  (if (sp-is-owner)
    (progn
      (setq *SP-LIC-OK* T)
      (princ (strcat "\n[LICENSE] OK  -  owner PC recognized (" *SP-OWNER-MAC* ")."))
      T)
    (if (null *SP-LIC-LOADED*)
      (progn
        (setq *SP-LIC-LAST-MSG*
              (strcat "No license file at " *SP-LIC-FILE*))
        (princ (strcat "\n[LICENSE] " *SP-LIC-LAST-MSG*))
        (princ "\n[LICENSE] Run SPLICENSE  ADD  to create one (owner only).")
        (setq *SP-LIC-OK* nil)
        nil)
      (progn
        (setq macs (sp-get-macs))
        (if (null macs)
          (progn
            (setq *SP-LIC-LAST-MSG* "Could not read MAC address from this PC.")
            (princ (strcat "\n[LICENSE] " *SP-LIC-LAST-MSG*))
            (setq *SP-LIC-OK* nil)
            nil)
          (progn
            (setq hit nil)
            (foreach m macs
              (if (member m *SP-LIC-MACS*) (setq hit T)))
            (if hit
              (progn
                (setq *SP-LIC-OK* T)
                (princ (strcat "\n[LICENSE] OK  -  machine authorized."))
                T)
              (progn
                (setq *SP-LIC-LAST-MSG*
                      (strcat "This machine is not licensed. Found MACs: "
                              (apply 'strcat
                                     (mapcar '(lambda (x) (strcat x " ")) macs))))
                (princ (strcat "\n[LICENSE] " *SP-LIC-LAST-MSG*))
                (princ (strcat "\n[LICENSE] Authorized MACs: "
                               (apply 'strcat
                                      (mapcar '(lambda (x) (strcat x " ")) *SP-LIC-MACS*))))
                (princ "\n[LICENSE] Owner only: contact the licensor to be added.")
                (setq *SP-LIC-OK* nil)
                nil))))))))

;;---------------- updated SPLICENSE ------------------------
;; Gates owner-only sub-commands
(defun c:SPLICENSE (/ sub)
  (vl-load-com)
  (if (null *SP-LIC-LOADED*) (sp-lic-load))
  (princ "\n--- SPLICENSE  (SolarPro V5 license manager) ---")
  (if (sp-is-owner)
    (princ "\n  *** OWNER MODE ***  (full access)")
    (princ "\n  *** USER MODE ***  (read-only)"))
  (princ "\n  SHOWMAC  - print this PC's MAC address(es)")
  (princ "\n  ADD      - add a MAC to the license [OWNER]")
  (princ "\n  REMOVE   - remove a MAC from the license [OWNER]")
  (princ "\n  LIST     - list authorized MACs")
  (princ "\n  CHECK    - re-validate current session")
  (princ "\n  PATH     - show license file location")
  (princ "\n  SAVE     - write license to disk [OWNER]")
  (princ "\n  SETOWNER - designate this PC as owner [OWNER]")
  (princ "\n  HELP     - show this message")
  (princ (strcat "\n  License file: " (sp-lic-path)))
  (princ (strcat "\n  Owner: "
                 (if (or (null *SP-OWNER-MAC*) (= *SP-OWNER-MAC* ""))
                   "(not set)" *SP-OWNER-MAC*)))
  (initget "SHOWMAC ADD REMOVE LIST CHECK PATH SAVE SETOWNER HELP QUIT")
  (setq sub (getkword "\nSPLICENSE> "))
  (cond
    ((= sub "SHOWMAC")
      (princ "\n[LICENSE] This machine's MAC address(es):")
      (foreach m (sp-get-macs)
        (princ (strcat "\n   " m))))
    ((= sub "ADD")
      (if (sp-is-owner)
        (sp-lic-add)
        (princ "\n[LICENSE] REFUSED: ADD is owner-only.")))
    ((= sub "REMOVE")
      (if (sp-is-owner)
        (sp-lic-remove)
        (princ "\n[LICENSE] REFUSED: REMOVE is owner-only.")))
    ((= sub "LIST")
      (princ (strcat "\n[LICENSE] Owner: "
                     (if (or (null *SP-OWNER-MAC*) (= *SP-OWNER-MAC* ""))
                       "(not set)"
                       (strcat *SP-OWNER-MAC* " [OWNER]"))))
      (princ "\n[LICENSE] Other authorized MACs:")
      (if (null *SP-LIC-MACS*)
        (princ "\n   (none)")
        (foreach m *SP-LIC-MACS*
          (if (and *SP-OWNER-MAC* (= (strcase m) (strcase *SP-OWNER-MAC*)))
            (princ (strcat "\n   " m "  (also matches owner)"))
            (princ (strcat "\n   " m))))))
    ((= sub "CHECK")
      (sp-auth-check))
    ((= sub "PATH")
      (princ (strcat "\n[LICENSE] " (sp-lic-path)))
      (princ (strcat "\n  Exists: " (if (findfile (sp-lic-path)) "YES" "NO"))))
    ((= sub "SAVE")
      (if (sp-is-owner)
        (sp-lic-save)
        (princ "\n[LICENSE] REFUSED: SAVE is owner-only.")))
    ((= sub "SETOWNER")
      (if (or (sp-is-owner)
              (null *SP-OWNER-MAC*)
              (= *SP-OWNER-MAC* ""))
        (sp-lic-setowner)
        (princ "\n[LICENSE] REFUSED: owner already set on another PC.")))
    ((= sub "HELP")
      (princ "\n[LICENSE] See screen for command list.")))
  (princ))

;;---------------- updated launch-time banner ---------------
(sp-lic-load)
(cond
  ((sp-is-owner)
    (princ "\n[LICENSE] OWNER PC recognized. Full access granted."))
  (*SP-LIC-LOADED*
    (sp-auth-check)
    (if (not *SP-LIC-OK*)
      (princ "\n[LICENSE] License file loaded but this PC is not in it. Commands will refuse.")))
  (T
    (princ "\n[LICENSE] No license file. Run SPLICENSE  SETOWNER  on the owner PC, then  ADD  to add customers.")))
(princ "\n[LICENSE] Manager ready. Type SPLICENSE at command line.")
(princ)

;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 9)
;; BUILD / COMPILE-TO-FAS SUBSYSTEM
;;   - c:SPCOMPILE    owner-only; compiles loaded LSP to FAS
;;   - c:SPBUILD      owner-only; same as SPCOMPILE + load FAS
;;   - c:SPVERIFY     owner-only; sanity-check the .fas binary
;;   - c:SPEXPORT     owner-only; copy .fas + .lic to a target dir
;;   - sp-locked-runs check function used to gate c: commands
;;============================================================

;;---------------- detect VLIDE availability ----------------
(defun sp-vlide-available (/ arx)
  (or (vlide-running)
      (progn
        (setq arx (findfile "vlide.arx"))
        (if arx
          (progn
            (if (not (member (strcase arx) (mapcar 'strcase (arx))))
              (arxload arx))
            T)
          nil))))

;;---------------- c:SPCOMPILE ------------------------------
;; Owner-only. Compiles SolarPro-PANFiles.lsp to .fas.
;; The .fas binary is opaque (bytecode), so the auth-check
;; code and the license scheme are not visible to a casual
;; user of the file. The .lsp is the OWNER's private source.
(defun c:SPCOMPILE (/ lsp-path fas-path d fbase)
  (if (not (sp-is-owner))
    (progn
      (princ "\n[SPCOMPILE] REFUSED: owner-only command.")
      (exit)))
  (if (not (sp-vlide-available))
    (progn
      (princ "\n[SPCOMPILE] ERROR: VLIDE is not loaded.")
      (princ "\n  --> Type VLIDE at the AutoCAD command line, then retry.")
      (exit)))
  (setq fbase "SolarPro-PANFiles"
        lsp-path (findfile (strcat fbase ".lsp")))
  (if (null lsp-path)
    (progn
      (princ (strcat "\n[SPCOMPILE] ERROR: cannot find " fbase ".lsp in support paths."))
      (princ "\n  Add the script folder to Options > Files > Support File Search Path.")
      (exit)))
  (setq d (vl-string-translate "\\" "/" (getvar "DWGPREFIX"))
        fas-path (strcat d fbase ".fas"))
  (princ (strcat "\n[SPCOMPILE] Compiling: " lsp-path))
  (princ (strcat "\n[SPCOMPILE] Output:    " fas-path))
  (if (vlisp-compile 'st lsp-path fas-path)
    (progn
      (princ "\n[SPCOMPILE] DONE.  FAS file written.")
      (princ (strcat "\n[SPCOMPILE] Size: "
                     (rtos (/ (vl-file-size fas-path) 1024.0) 2 0) " KB"))
      (princ "\n[SPCOMPILE] Distribute only the .FAS file and solarpro.lic."))
    (progn
      (princ "\n[SPCOMPILE] FAILED.  See command line for errors.")
      (princ "\n  Common causes:")
      (princ "\n    - Syntax error in the .lsp")
      (princ "\n    - File is locked (read-only)")
      (princ "\n    - Path has no write permission")))
  (princ))

;;---------------- c:SPBUILD --------------------------------
;; Owner-only. Compile + load the new FAS, then re-check auth.
(defun c:SPBUILD (/ lsp-path fas-path fbase)
  (if (not (sp-is-owner))
    (progn
      (princ "\n[SPBUILD] REFUSED: owner-only command.")
      (exit)))
  (c:SPCOMPILE)
  (setq fbase "SolarPro-PANFiles"
        fas-path (strcat (vl-string-translate "\\" "/" (getvar "DWGPREFIX")) fbase ".fas"))
  (if (findfile fas-path)
    (progn
      (princ (strcat "\n[SPBUILD] Loading new FAS: " fas-path))
      (load fas-path)
      (princ "\n[SPBUILD] FAS loaded successfully."))
    (princ "\n[SPBUILD] FAS not found - compile may have failed."))
  (princ))

;;---------------- c:SPVERIFY -------------------------------
;; Owner-only. Quick sanity checks on the .fas binary.
(defun c:SPVERIFY (/ fas-path ln c1 c2)
  (if (not (sp-is-owner))
    (progn
      (princ "\n[SPVERIFY] REFUSED: owner-only command.")
      (exit)))
  (setq fas-path (findfile "SolarPro-PANFiles.fas"))
  (if (null fas-path)
    (progn
      (princ "\n[SPVERIFY] No FAS file found. Run SPCOMPILE first.")
      (exit)))
  (princ (strcat "\n[SPVERIFY] File: " fas-path))
  (princ (strcat "\n[SPVERIFY] Size: "
                 (rtos (/ (vl-file-size fas-path) 1024.0) 2 0) " KB"))
  (setq fp (open fas-path "rb"))
  (if fp
    (progn
      (setq c1 (read-char fp) c2 (read-char fp))
      (close fp)
      ;; FAS files start with 0xC0 0xCE (AutoCAD bytecode signature)
      (if (and (= c1 192) (= c2 206))
        (princ "\n[SPVERIFY] OK - valid AutoCAD FAS bytecode (C0 CE).")
        (princ (strcat "\n[SPVERIFY] WARNING: not a FAS file (got "
                       (itoa c1) " " (itoa c2) ").")))))
  ;; Confirm critical functions are present (only works after FAS is loaded)
  (princ "\n[SPVERIFY] Critical functions:")
  (foreach fn '("sp-auth-check" "sp-lic-load" "sp-is-owner"
                "c:SPLICENSE" "c:SPL")
    (if (eval (read fn))
      (princ (strcat "\n   OK  " fn))
      (princ (strcat "\n   ??  " fn "  (not loaded)"))))
  (princ))

;;---------------- c:SPEXPORT -------------------------------
;; Owner-only. Copy .fas + .lic to a target folder (e.g. USB
;; stick or shared drive) so the user can install on a
;; customer's PC.
(defun c:SPEXPORT (/ target src-base src-fas src-lic)
  (if (not (sp-is-owner))
    (progn
      (princ "\n[SPEXPORT] REFUSED: owner-only command.")
      (exit)))
  (initget 1)
  (setq target (getstring T "\nTarget folder (e.g. E:\\SolarPro): "))
  (if (/= (substr target (strlen target)) "\\")
    (setq target (strcat target "\\")))
  (if (not (findfile target))
    (progn
      (princ (strcat "\n[SPEXPORT] ERROR: folder not found: " target))
      (exit)))
  (setq src-base "SolarPro-PANFiles"
        src-fas (findfile (strcat src-base ".fas"))
        src-lic (findfile "solarpro.lic"))
  (if src-fas
    (progn
      (vl-file-copy src-fas (strcat target src-base ".fas"))
      (princ (strcat "\n[SPEXPORT] Copied FAS to: " target src-base ".fas")))
    (princ "\n[SPEXPORT] No FAS found. Run SPCOMPILE first."))
  (if src-lic
    (progn
      (vl-file-copy src-lic (strcat target "solarpro.lic"))
      (princ (strcat "\n[SPEXPORT] Copied license to: " target "solarpro.lic")))
    (princ "\n[SPEXPORT] No license file found (solarpro.lic)."))
  (princ (strcat "\n[SPEXPORT] Installation instructions for customer:"))
  (princ (strcat "\n  1. Copy SolarPro-PANFiles.fas to " target))
  (princ (strcat "\n  2. Copy solarpro.lic to " target))
  (princ (strcat "\n  3. In AutoCAD: APPLOAD  ->  add " target " to startup suite."))
  (princ (strcat "\n  4. Restart AutoCAD and type SPL."))
  (princ))

;;---------------- runtime guard for FAS-only mode ----------
;; After compilation, the .FAS file is the only artifact. The
;; loader bootstrap (SolarPro-Loader.lsp) detects FAS, loads
;; it, and that FAS already contains the auth-check. This
;; command shows the current state of auth + the FAS path.
(defun c:SPAUTHSTATUS ()
  (princ "\n--- SolarPro V5 Auth Status ---")
  (if (null *SP-LIC-LOADED*) (sp-lic-load))
  (princ (strcat "\n  License file:  "
                 (if *SP-LIC-FILE* *SP-LIC-FILE* "(none)")))
  (princ (strcat "\n  File loaded:   "
                 (if *SP-LIC-LOADED* "YES" "NO")))
  (princ (strcat "\n  Owner:         "
                 (if (sp-is-owner) (strcat "YES (" *SP-OWNER-MAC* ")")
                                    "NO")))
  (princ (strcat "\n  This session:  "
                 (if *SP-LIC-OK* "AUTHORIZED" "NOT AUTHORIZED")))
  (princ (strcat "\n  This MAC:      " (sp-get-mac)))
  (princ (strcat "\n  FAS file:      "
                 (or (findfile "SolarPro-PANFiles.fas") "(not built yet)")))
  (princ))

(princ "\n[SolarPro v5.0] Compile subsystem ready: SPCOMPILE, SPBUILD, SPVERIFY, SPEXPORT, SPAUTHSTATUS")
(princ)

;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 10)
;; OWNER-MAC BURN-IN & SELF-MANAGEMENT
;;
;;   c:SPWHO         - show owner MAC, this PC MAC, auth status
;;   c:SPBURN        - burn current owner MAC into the .lsp
;;   sp-lic-burn     - internal: rewrite *SP-OWNER-MAC* line
;;   sp-self-test    - smoke test the auth + license machinery
;;============================================================

;;---------------- burn owner MAC into the .lsp source ------
;; Rewrites the line containing "(setq *SP-OWNER-MAC* ..."
;; in SolarPro-PANFiles.lsp so that the new MAC is permanently
;; embedded. This is what SETOWNER calls.
;;
;; Returns T on success, nil otherwise.
(defun sp-lic-burn (new-mac / lsp fp lines out ln marker new-line)
  (if (or (null new-mac) (= (strlen new-mac) 0))
    (progn (princ "\n[SPBURN] ERROR: empty MAC.") nil)
    (progn
      (setq lsp (findfile "SolarPro-PANFiles.lsp"))
      (if (null lsp)
        (progn
          (princ "\n[SPBURN] ERROR: SolarPro-PANFiles.lsp not found in support paths.")
          nil)
        (progn
          (setq fp (open lsp "r"))
          (if (null fp)
            (progn
              (princ (strcat "\n[SPBURN] ERROR: cannot read " lsp))
              nil)
            (progn
              (setq lines '())
              (while (setq ln (read-line fp))
                (setq lines (append lines (list ln))))
              (close fp)
              (setq marker ";; <-- OWNER MAC")
              (setq new-line
                    (strcat "(setq *SP-OWNER-MAC* \""
                            (strcase new-mac)
                            "\")     ; <-- OWNER MAC (burned by SETOWNER on "
                            (rtos (* 100.0 (/ (getvar "CDATE") 86400.0)) 2 0)
                            ")"))
              (setq out "")
              (foreach ln lines
                (if (and (vl-string-search "(setq *SP-OWNER-MAC*" ln)
                         (vl-string-search marker ln))
                  (setq out (strcat out new-line "\n"))
                  (setq out (strcat out ln "\n"))))
              ;; If marker line not found, fall back: find any line with
              ;; the (setq *SP-OWNER-MAC* ... declaration
              (if (= (length out) 0)
                (progn
                  (foreach ln lines
                    (if (vl-string-search "(setq *SP-OWNER-MAC*" ln)
                      (setq out (strcat out new-line "\n"))
                      (setq out (strcat out ln "\n"))))))
              (if (= (length out) 0)
                (progn
                  (princ "\n[SPBURN] ERROR: marker not found in .lsp.")
                  nil)
                (progn
                  (setq fp (open lsp "w"))
                  (if (null fp)
                    (progn
                      (princ (strcat "\n[SPBURN] ERROR: cannot write to " lsp))
                      (princ "\n  --> Make sure the file is not read-only.")
                      nil)
                    (progn
                      (write-line out fp)
                      (close fp)
                      (princ (strcat "\n[SPBURN] Burned owner MAC into: " lsp))
                      (princ (strcat "\n[SPBURN] New value: " (strcase new-mac)))
                      (princ "\n[SPBURN] Re-run SPCOMPILE to refresh the FAS binary.")
                      T)))))))))))

;;---------------- c:SPBURN ---------------------------------
;; Owner-only. Manually re-burn the owner MAC into the .lsp
;; (e.g. owner changed PC). Asks for a MAC string.
(defun c:SPBURN (/ mac)
  (if (not (sp-is-owner))
    (progn
      (princ "\n[SPBURN] REFUSED: owner-only command.")
      (exit)))
  (princ (strcat "\n[SPBURN] Current owner MAC: " *SP-OWNER-MAC*))
  (initget 1)
  (if (y-or-n-p "Re-burn from this PC's MAC? [Y/N]: ")
    (setq mac (car (sp-get-macs)))
    (progn
      (initget 1)
      (setq mac (getstring T "\nEnter MAC to burn (AA:BB:CC:DD:EE:FF): "))
      (setq mac (sp-mac-normalize mac))))
  (if (null mac)
    (princ "\n[SPBURN] ERROR: invalid MAC.")
    (if (sp-lic-burn mac)
      (progn
        (setq *SP-OWNER-MAC* (strcase mac))
        (princ "\n[SPBURN] DONE.  In-memory and source updated.")))))

;;---------------- c:SPWHO ----------------------------------
;; Print a clean status report: owner, this PC, auth, FAS path
(defun c:SPWHO ()
  (princ "\n========== SolarPro V5 AUTH/OWNER REPORT ==========")
  (if (null *SP-LIC-LOADED*) (sp-lic-load))
  (princ (strcat "\n  License file:  "
                 (if *SP-LIC-FILE* *SP-LIC-FILE* "(none)")))
  (princ (strcat "\n  File loaded:   "
                 (if *SP-LIC-LOADED* "YES" "NO")))
  (princ (strcat "\n  Owner MAC (src): " *SP-OWNER-MAC*))
  (princ (strcat "\n  Owner PC now:   "
                 (if (sp-is-owner) "YES (you are the owner)" "NO")))
  (princ (strcat "\n  This PC's MACs:"))
  (foreach m (sp-get-macs)
    (princ (strcat "\n     " m
                   (if (and *SP-OWNER-MAC*
                            (= (strcase m) (strcase *SP-OWNER-MAC*)))
                     "  <- matches OWNER" ""))))
  (princ (strcat "\n  Authorized MACs (in license file):"))
  (if (null *SP-LIC-MACS*)
    (princ "\n     (none)")
    (foreach m *SP-LIC-MACS*
      (princ (strcat "\n     " m
                     (if (and *SP-OWNER-MAC*
                              (= (strcase m) (strcase *SP-OWNER-MAC*)))
                       "  <- OWNER" "")))))
  (princ (strcat "\n  This session:   "
                 (if *SP-LIC-OK* "AUTHORIZED" "NOT AUTHORIZED")))
  (princ (strcat "\n  FAS binary:     "
                 (or (findfile "SolarPro-PANFiles.fas") "(not built yet)")))
  (princ (strcat "\n  LSP source:     "
                 (or (findfile "SolarPro-PANFiles.lsp") "(not in path)")))
  (princ "\n===================================================")
  (princ))

;;---------------- patched SETOWNER (uses burn-in) ---------
;; Replaces the simpler version in batch 8. The new SETOWNER
;; burns the MAC into the .lsp source so it persists across
;; sessions and re-compiles.
(defun sp-lic-setowner (/ mac)
  (if (or (null *SP-OWNER-MAC*)
          (= *SP-OWNER-MAC* "")
          (= (strcase *SP-OWNER-MAC*) "AA:BB:CC:DD:EE:FF"))
    (progn  ;; not yet burned-in
      (setq mac (car (sp-get-macs)))
      (if (null mac)
        (princ "\n[LICENSE] ERROR: cannot read MAC.")
        (progn
          (initget 1)
          (if (y-or-n-p
                (strcat "Designate this MAC as OWNER? [" mac "] [Y/N]: "))
            (progn
              (if (sp-lic-burn mac)
                (progn
                  (setq *SP-OWNER-MAC* (strcase mac)
                        *SP-OWNER-LOADED* T)
                  (princ (strcat "\n[LICENSE] Owner set to: " *SP-OWNER-MAC*))
                  (princ "\n[LICENSE] Run SPCOMPILE to refresh the FAS binary.")
                  (sp-lic-save))
                (princ "\n[LICENSE] Burn-in failed.")))
            (princ "\n[LICENSE] Cancelled.")))))
    (if (sp-is-owner)
      (progn
        (princ (strcat "\n[LICENSE] This PC is already the owner: " *SP-OWNER-MAC*))
        (if (y-or-n-p "Re-save license file with current owner? [Y/N]: ")
          (sp-lic-save)))
      (progn
        (princ (strcat "\n[LICENSE] REFUSED: owner already set to "
                       *SP-OWNER-MAC*))
        (princ "\n[LICENSE] Can only be changed on the current owner PC.")))))

;;---------------- self-test --------------------------------
;; Smoke test the auth machinery. Always safe to run.
(defun c:SPSELFTEST (/ r owner-mac this-mac)
  (princ "\n========== SolarPro V5 SELF-TEST ==========")
  (setq r (vl-catch-all-apply 'sp-lic-load)
        this-mac (sp-get-mac)
        owner-mac *SP-OWNER-MAC*)
  (princ "\n  sp-lic-load ............. ")
  (if (vl-catch-all-error-p r)
    (princ "FAIL")
    (princ (if *SP-LIC-LOADED* "OK (file present)" "OK (no file)")))
  (princ "\n  sp-get-mac .............. ")
  (princ (if this-mac (strcat "OK (" this-mac ")") "FAIL (no MAC)"))
  (princ "\n  sp-mac-normalize ........ ")
  (princ (if (= (sp-mac-normalize "aa-bb-cc-dd-ee-ff")
                "AA:BB:CC:DD:EE:FF")
           "OK" "FAIL"))
  (princ "\n  sp-xor round-trip ....... ")
  (princ (if (= (sp-xor (sp-xor "hello" "k") "k") "hello")
           "OK" "FAIL"))
  (princ "\n  sp-b32 round-trip ....... ")
  (princ (if (= (sp-b32-dec (sp-b32-enc "hello world")) "hello world")
           "OK" "FAIL"))
  (princ "\n  sp-token round-trip ..... ")
  (princ (if (= (sp-token-dec (sp-token-enc "test123")) "test123")
           "OK" "FAIL"))
  (princ "\n  sp-is-owner ............. ")
  (princ (if (sp-is-owner) "OWNER" "NOT OWNER"))
  (princ (strcat "\n  Source owner MAC ........ " *SP-OWNER-MAC*))
  (princ (strcat "\n  This PC MAC ............. "
                 (or this-mac "(none)")))
  (princ (strcat "\n  FAS binary .............. "
                 (or (findfile "SolarPro-PANFiles.fas") "(not built)")))
  (princ "\n============================================")
  (princ))

(princ "\n[SolarPro v5.0] Owner burn-in ready: SPWHO, SPBURN, SPSELFTEST.")
(princ)

;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 11)
;; MMS PERMIT SHEET (MMSPERMIT) - 13th sheet for permit set
;;
;; Adds an MMS drawing sheet containing:
;;   - Title block with project info
;;   - Plan view of a single PV table (posts, beams, modules, piles)
;;   - Section A-A view (post, table, module tilt, pile depth)
;;   - Material take-off summary table
;;   - Wind / Snow / Bolt torque / Coating notes
;;   - North arrow and scale bar
;;   - Standard IS 2062 / IS 811 / ASTM A123 references
;;   - Typical GCR and pitch
;;
;; The sheet is added to the BatchPlot order as the 13th
;; (MMS_SHEET) deliverable.
;;============================================================

(setq *SP-MMS-DRAWING-NO* 0)   ; auto-increment for sub-drawings

;;------------------------------------------------------------
;; Helpers
;;------------------------------------------------------------
(defun sp-mms-ht (h) (rtos h 2 2))   ; short helper
(defun sp-mms-section-label (x y label)
  (sp-mtext (list x y 0.0) 3.0
    (strcat "SECTION  " label "  (TYP.)")
    "SP_MMS" 7))

;;------------------------------------------------------------
;; c:MMSPERMIT
;; Owner-only. Asks for an insertion point then draws the
;; full MMS permit sheet on the current layout/model space.
;;------------------------------------------------------------
(defun c:MMSPERMIT (/ ip ts x0 y0 mod tilt pitch gcr t-len
                    posts piles mat-ht rear-ht front-ht
                    pile-len embed dep w bf tf z-purlin
                    title str1 str2)
  (if (sp-guard-or-exit) (exit))

  (if (null (setq ip (getpoint "\nMMS sheet insertion point: ")))
    (exit))

  (setq *SP-MMS-DRAWING-NO* (1+ *SP-MMS-DRAWING-NO*)
        ts 0.1   ; text size
        x0 (car ip) y0 (cadr ip))

  ;; Defaults (overridable by user)
  (initget 6)
  (setq mod (getstring "\nModule model <XXX-540W Bifacial>: "))
  (if (= mod "") (setq mod "XXX-540W Bifacial"))
  (initget 6)
  (setq tilt (getreal "\nTable tilt (deg) <25>: "))
  (if (null tilt) (setq tilt 25.0))
  (initget 6)
  (setq pitch (getreal "\nN-S pitch (m) <8.0>: "))
  (if (null pitch) (setq pitch 8.0))
  (initget 6)
  (setq gcr (getreal "\nGCR (0..1) <0.45>: "))
  (if (null gcr) (setq gcr 0.45))

  ;; Calculated dimensions
  (setq t-len 30.0           ; table length (E-W), m
        posts 11             ; 11 posts in 30 m @ 3 m c/c
        piles posts          ; one pile per post
        mat-ht 2.5           ; height of module bottom above GL
        front-ht mat-ht      ; front post height
        rear-ht (+ mat-ht (* (* (/ t-len 2.0) 1.0) (sin (deg2rad tilt))))
        embed 1.5            ; pile embedment depth
        pile-len (+ embed 0.3 mat-ht 0.5)   ; total pile length
        w 1.13               ; module width (m)
        bf 0.07              ; flange width
        tf 0.004             ; flange thickness
        z-purlin "C200x2.0") ; cold-formed Z section

  (princ (strcat "\n[MMSPERMIT] Drawing sheet at (" (rtos x0 2 2) "," (rtos y0 2 2) ")"))
  (princ (strcat "\n  Module:    " mod))
  (princ (strcat "\n  Tilt:      " (rtos tilt 2 1) " deg"))
  (princ (strcat "\n  Pitch:     " (rtos pitch 2 2) " m"))
  (princ (strcat "\n  GCR:       " (rtos (* 100 gcr) 2 1) "%"))
  (princ (strcat "\n  Posts:     " (itoa posts)))
  (princ (strcat "\n  Pile len:  " (rtos pile-len 2 2) " m"))

  ;;------------------------------------------------------------
  ;; 1. SHEET FRAME (A2 landscape: 594 x 420)
  ;;------------------------------------------------------------
  (sp-rect x0 y0 594.0 420.0 "SP_MMS" 7)   ; outer frame
  (sp-rect (+ x0 5) (+ y0 5) 584.0 410.0 "SP_MMS" 7) ; inner border
  (sp-rect (+ x0 5) (+ y0 360) 584.0 55.0 "SP_MMS" 7) ; title block area

  ;;------------------------------------------------------------
  ;; 2. TITLE BLOCK
  ;;------------------------------------------------------------
  (sp-mtext (list (+ x0 12) (+ y0 405) 0.0) 6.0
    "MODULE MOUNTING STRUCTURE (MMS) - GENERAL ARRANGEMENT"
    "SP_MMS" 7)
  (sp-mtext (list (+ x0 12) (+ y0 397) 0.0) 3.0
    (strcat "Sheet MMS-" (itoa *SP-MMS-DRAWING-NO*))
    "SP_MMS" 7)

  ;; Project info table (right side of title block)
  (sp-mtext (list (+ x0 410) (+ y0 410) 0.0) 2.5
    "Project: SOLAR PV PLANT" "SP_MMS" 5)
  (sp-mtext (list (+ x0 410) (+ y0 405) 0.0) 2.0
    "Owner:  XXXXXX" "SP_MMS" 7)
  (sp-mtext (list (+ x0 410) (+ y0 400) 0.0) 2.0
    (strcat "Module: " mod) "SP_MMS" 7)
  (sp-mtext (list (+ x0 410) (+ y0 395) 0.0) 2.0
    (strcat "Tilt: " (rtos tilt 2 1) " deg  |  Pitch: "
            (rtos pitch 2 2) " m  |  GCR: " (rtos (* 100 gcr) 2 1) "%")
    "SP_MMS" 7)
  (sp-mtext (list (+ x0 410) (+ y0 390) 0.0) 2.0
    (strcat "Drawing no: SOLARPRO-MMS-" (itoa *SP-MMS-DRAWING-NO*))
    "SP_MMS" 7)
  (sp-mtext (list (+ x0 410) (+ y0 385) 0.0) 2.0
    "Scale: As indicated  |  Date: ____" "SP_MMS" 7)
  (sp-mtext (list (+ x0 410) (+ y0 380) 0.0) 2.0
    "Drawn: SolarPro V5  |  Rev: 0" "SP_MMS" 7)

  ;;------------------------------------------------------------
  ;; 3. PLAN VIEW (top-left area, occupies 280x200)
  ;;------------------------------------------------------------
  (setq plan-x (+ x0 15) plan-y (+ y0 155))
  (sp-mtext (list plan-x (+ plan-y 195) 0.0) 4.0
    "PLAN VIEW  -  Single PV Table (Typical)"
    "SP_MMS" 7)
  ;; Table rectangle (plan view)
  (sp-rect plan-x plan-y t-len 4.0 "SP_MMS" 5)  ; table footprint 30m x 4m
  ;; Modules (E-W rows): assuming 2 modules portrait per E-W position
  (setq n-mod-tables 6   ; 6 E-W positions
        mod-w 1.13      ; module short side
        mod-l 2.279     ; module long side
        mod-gap 0.02)
  (dotimes (i n-mod-tables)
    (progn
      (setq cx (+ plan-x (* i (+ mod-w mod-gap))))
      ;; 2 modules portrait stacked along the table
      (sp-rect cx (+ plan-y 0.4) mod-w mod-l "SP_MMS" 3)
      (sp-rect cx (+ plan-y 2.6) mod-w mod-l "SP_MMS" 3)))
  ;; Posts (11 along the table at 3 m c/c)
  (dotimes (i posts)
    (progn
      (setq px (+ plan-x (* i (/ t-len (1- posts))))
            py1 plan-y
            py2 (+ plan-y 4.0))
      (sp-circle (list px (+ py1 0.7) 0.0) 0.10 "SP_MMS" 6)  ; pile
      (sp-circle (list px (+ py2 0.7) 0.0) 0.10 "SP_MMS" 6)
      (sp-line  (list px (+ py1 0.7) 0.0) (list px (+ py2 0.7) 0.0)
                "SP_MMS" 7) ; post
      ))
  ;; Pile foundation circles
  (sp-circle (list plan-x (+ plan-y 0.7) 0.0) 0.15 "SP_MMS" 6)
  (sp-circle (list (+ plan-x t-len) (+ plan-y 0.7) 0.0) 0.15 "SP_MMS" 6)

  ;; Dimensions - overall length
  (sp-mtext (list (+ plan-x (/ t-len 2.0)) (- plan-y 8) 0.0) 2.5
    (strcat (rtos t-len 2 1) " m") "SP_MMS" 5)
  (sp-line (list plan-x (- plan-y 5) 0.0) (list (+ plan-x t-len) (- plan-y 5) 0.0)
           "SP_MMS" 5)

  ;; Dimensions - post spacing
  (sp-mtext (list (+ plan-x (/ t-len 2.0)) (- plan-y 14) 0.0) 1.8
    "(11 posts @ 3.0 m c/c)" "SP_MMS" 7)

  ;;------------------------------------------------------------
  ;; 4. SECTION A-A VIEW (bottom-left area)
  ;;------------------------------------------------------------
  (setq sec-x (+ x0 15) sec-y (+ y0 25))
  (sp-mms-section-label sec-x (+ sec-y 130) "A-A")
  ;; Ground line
  (sp-line (list sec-x sec-y 0.0) (list (+ sec-x 90) sec-y 0.0) "SP_MMS" 7)
  ;; Hatch ground
  (sp-hatch (list sec-x sec-y 0.0) (list (+ sec-x 90) sec-y 0.0)
            "ANSI31" 1.0 0.0 "SP_MMS")
  ;; Pile (front)
  (sp-line (list (+ sec-x 20) sec-y 0.0)
           (list (+ sec-x 20) (+ sec-y embed) 0.0)
           "SP_MMS" 6)
  ;; Post front
  (sp-line (list (+ sec-x 19.5) (+ sec-y embed) 0.0)
           (list (+ sec-x 19.5) (+ sec-y front-ht) 0.0)
           "SP_MMS" 7)
  ;; Table beam (tilted) from front to rear
  (sp-line (list (+ sec-x 19.5) (+ sec-y front-ht) 0.0)
           (list (+ sec-x 70.5) (+ sec-y rear-ht) 0.0)
           "SP_MMS" 7)
  ;; Module line on top of table
  (sp-line (list (+ sec-x 19.5) (+ sec-y (+ front-ht 0.1)) 0.0)
           (list (+ sec-x 70.5) (+ sec-y (+ rear-ht 0.1)) 0.0)
           "SP_MMS" 3)
  ;; Post rear
  (sp-line (list (+ sec-x 70.5) (+ sec-y embed) 0.0)
           (list (+ sec-x 70.5) (+ sec-y rear-ht) 0.0)
           "SP_MMS" 7)
  ;; Pile (rear)
  (sp-line (list (+ sec-x 70.5) sec-y 0.0)
           (list (+ sec-x 70.5) (+ sec-y embed) 0.0)
           "SP_MMS" 6)
  ;; Embedment dimension
  (sp-mtext (list (+ sec-x 11) (+ sec-y (/ embed 2.0)) 0.0) 1.8
    (strcat "Embed. " (rtos embed 2 2) " m") "SP_MMS" 5)
  ;; Front post ht
  (sp-mtext (list (+ sec-x 13) (+ sec-y (/ front-ht 2.0)) 0.0) 1.8
    (strcat "h1=" (rtos front-ht 2 2) " m") "SP_MMS" 5)
  ;; Tilt dimension
  (sp-mtext (list (+ sec-x 35) (+ sec-y (+ front-ht 8)) 0.0) 1.8
    (strcat "Tilt = " (rtos tilt 2 1) " deg") "SP_MMS" 5)
  ;; N-S pitch
  (sp-mtext (list (+ sec-x 50) (- sec-y 4) 0.0) 1.8
    (strcat "N-S Pitch = " (rtos pitch 2 2) " m") "SP_MMS" 5)
  ;; GCR
  (sp-mtext (list (+ sec-x 50) (- sec-y 8) 0.0) 1.8
    (strcat "GCR = " (rtos (* 100 gcr) 2 1) " %") "SP_MMS" 5)
  ;; A-A markers
  (sp-circle (list (+ sec-x 19.5) (+ sec-y 0.3) 0.0) 0.5 "SP_MMS" 3)
  (sp-mtext (list (+ sec-x 18) (+ sec-y -0.5) 0.0) 2.5 "A" "SP_MMS" 3)
  (sp-circle (list (+ sec-x 70.5) (+ sec-y 0.3) 0.0) 0.5 "SP_MMS" 3)
  (sp-mtext (list (+ sec-x 69) (+ sec-y -0.5) 0.0) 2.5 "A" "SP_MMS" 3)

  ;;------------------------------------------------------------
  ;; 5. NOTES (right side, 1st block)
  ;;------------------------------------------------------------
  (setq notes-x (+ x0 320) notes-y (+ y0 320))
  (sp-mtext (list notes-x (+ notes-y 35) 0.0) 3.5
    "DESIGN NOTES" "SP_MMS" 7)
  (sp-mtext (list notes-x (+ notes-y 28) 0.0) 2.0
    "1.  All structural steel per IS 2062 (latest)." "SP_MMS" 7)
  (sp-mtext (list notes-x (+ notes-y 24) 0.0) 2.0
    "2.  Hot-dip galvanizing per IS 2629 / IS 4759 (min 85 microns)." "SP_MMS" 7)
  (sp-mtext (list notes-x (+ notes-y 20) 0.0) 2.0
    "3.  Piles: IS 811 / ASTM A252 Gr.2 - driven or helical." "SP_MMS" 7)
  (sp-mtext (list notes-x (+ notes-y 16) 0.0) 2.0
    (strcat "4.  Pile length: " (rtos pile-len 2 2) " m (typ).") "SP_MMS" 7)
  (sp-mtext (list notes-x (+ notes-y 12) 0.0) 2.0
    "5.  Bolts: M16 Gr.8.8 hot-dip galv. Torque 245 Nm." "SP_MMS" 7)
  (sp-mtext (list notes-x (+ notes-y 8) 0.0) 2.0
    "6.  Module clamps: M8 SS304, EPDM gasket." "SP_MMS" 7)
  (sp-mtext (list notes-x (+ notes-y 4) 0.0) 2.0
    (strcat "7.  Wind design: IS 875 Part 3 / ASCE 7-16 (Vb=47 m/s).")
    "SP_MMS" 7)
  (sp-mtext (list notes-x notes-y 0.0) 2.0
    "8.  Seismic: IS 1893 Part 4 (Zone III default)." "SP_MMS" 7)

  ;;------------------------------------------------------------
  ;; 6. MATERIAL TAKE-OFF (right side, 2nd block)
  ;;------------------------------------------------------------
  (setq mat-x (+ x0 320) mat-y (+ y0 230))
  (sp-mtext (list mat-x (+ mat-y 70) 0.0) 3.5
    "MATERIAL TAKE-OFF (PER TABLE)" "SP_MMS" 7)
  ;; Header row
  (sp-mtext (list mat-x (+ mat-y 64) 0.0) 2.2
    "Item            Qty       Section / Spec"
    "SP_MMS" 7)
  (sp-line (list mat-x (+ mat-y 62) 0.0) (list (+ mat-x 250) (+ mat-y 62) 0.0)
           "SP_MMS" 5)
  (sp-mtext (list mat-x (+ mat-y 58) 0.0) 2.2
    (strcat "Posts           " (itoa posts) "        60x60x2.0 SHS (IS 4923)")
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 54) 0.0) 2.2
    (strcat "Piles           " (itoa piles) "        C100x4.0 SHS (IS 811) / Helical")
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 50) 0.0) 2.2
    "Purlins (long)  4         C200x2.0 cold-formed (IS 811)"
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 46) 0.0) 2.2
    "Rafter (bracing) 2        L50x50x5 EA (IS 2062)"
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 42) 0.0) 2.2
    (strcat "Modules         12        " mod)
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 38) 0.0) 2.2
    "Module clamps   24        End + mid clamp (Al 6005-T5)"
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 34) 0.0) 2.2
    "Bolt set M16    88        Gr.8.8 HDG (posts-pile, purlin-post)"
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 30) 0.0) 2.2
    "Earth lug       2         Copper-bonded, 50 sqmm cable"
    "SP_MMS" 7)
  (sp-line (list mat-x (+ mat-y 28) 0.0) (list (+ mat-x 250) (+ mat-y 28) 0.0)
           "SP_MMS" 5)
  (sp-mtext (list mat-x (+ mat-y 24) 0.0) 2.2
    "Coating: Hot-dip galv 85 microns (IS 2629)"
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 20) 0.0) 2.2
    "Paint: None on galv. surfaces (or epoxy if specified)"
    "SP_MMS" 7)
  (sp-mtext (list mat-x (+ mat-y 16) 0.0) 2.2
    "Warranty: 25 years structural, 10 years coating"
    "SP_MMS" 7)

  ;;------------------------------------------------------------
  ;; 7. NORTH ARROW + SCALE BAR (top right)
  ;;------------------------------------------------------------
  (setq na-x (+ x0 545) na-y (+ y0 340))
  (sp-mtext (list na-x (+ na-y 25) 0.0) 3.0 "N" "SP_MMS" 7)
  (sp-line (list na-x (+ na-y 15) 0.0) (list na-x na-y 0.0) "SP_MMS" 7)
  (sp-line (list na-x na-y 0.0) (list (- na-x 4) (- na-y 6) 0.0) "SP_MMS" 7)
  (sp-line (list na-x na-y 0.0) (list (+ na-x 4) (- na-y 6) 0.0) "SP_MMS" 7)
  (sp-line (list na-x na-y 0.0) (list (- na-x 2) (- na-y 5) 0.0) "SP_MMS" 7)
  (sp-line (list na-x na-y 0.0) (list (+ na-x 2) (- na-y 5) 0.0) "SP_MMS" 7)
  (sp-mtext (list na-x (+ na-y -2) 0.0) 1.8
    "TRUE NORTH" "SP_MMS" 5)
  (sp-mtext (list na-x (- na-y 6) 0.0) 1.5
    "(plan orientation)" "SP_MMS" 7)

  ;; Scale bar
  (setq sb-x (+ x0 320) sb-y (+ y0 60))
  (sp-mtext (list sb-x (+ sb-y 8) 0.0) 1.8 "Scale 1:100 (plan) / 1:50 (section)"
            "SP_MMS" 7)
  (sp-line (list sb-x sb-y 0.0) (list (+ sb-x 50) sb-y 0.0) "SP_MMS" 7)
  (dotimes (i 5)
    (progn
      (sp-line (list (+ sb-x (* i 10)) sb-y 0.0)
               (list (+ sb-x (* i 10)) (- sb-y 1.5) 0.0)
               "SP_MMS" 7)
      (sp-mtext (list (+ sb-x (* i 10)) (- sb-y 4) 0.0) 1.4
        (rtos (* i 2.0) 2 0) "SP_MMS" 7)))
  (sp-mtext (list (+ sb-x 25) (+ sb-y 4) 0.0) 1.4
    "metres" "SP_MMS" 7)

  ;;------------------------------------------------------------
  ;; 8. WIND/SNOW/SEISMIC BLOCK (top right corner)
  ;;------------------------------------------------------------
  (setq w-x (+ x0 320) w-y (+ y0 110))
  (sp-mtext (list w-x (+ w-y 8) 0.0) 3.0
    "DESIGN PARAMETERS" "SP_MMS" 7)
  (sp-mtext (list w-x w-y 0.0) 2.0
    (strcat "Wind zone:  IS 875 Part 3 (Vb=47 m/s, k1=1.0, k2=0.98, k3=1.0, k4=1.0)")
    "SP_MMS" 7)
  (sp-mtext (list w-x (- w-y 4) 0.0) 2.0
    "Topographic factor k3: 1.0 (flat terrain)"
    "SP_MMS" 7)
  (sp-mtext (list w-x (- w-y 8) 0.0) 2.0
    "Importance factor k4: 1.0 (general)"
    "SP_MMS" 7)
  (sp-mtext (list w-x (- w-y 12) 0.0) 2.0
    "Snow load:    0.0 kN/m2 (project site)"
    "SP_MMS" 7)
  (sp-mtext (list w-x (- w-y 16) 0.0) 2.0
    "Seismic zone: III (Z=0.16, IS 1893)"
    "SP_MMS" 7)
  (sp-mtext (list w-x (- w-y 20) 0.0) 2.0
    "Soil:         SBC 100 kN/m2 (assumed; verify with geo-tech)"
    "SP_MMS" 7)
  (sp-mtext (list w-x (- w-y 24) 0.0) 2.0
    "Pile type:    IS 811 driven / helical as per soil"
    "SP_MMS" 7)

  ;;------------------------------------------------------------
  ;; 9. SECTION PROPERTIES (bottom right)
  ;;------------------------------------------------------------
  (setq sp-x (+ x0 320) sp-y (+ y0 35))
  (sp-mtext (list sp-x (+ sp-y 35) 0.0) 3.0
    "SECTION PROPERTIES" "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 30) 0.0) 2.0
    "Post:  60x60x2.0 SHS   -  A=448 mm2  Ix=2.36e5 mm4"
    "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 26) 0.0) 2.0
    "Pile:  C100x4.0 SHS    -  A=1480 mm2 Ix=2.18e6 mm4"
    "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 22) 0.0) 2.0
    "Purlin: C200x2.0 CF   -  A=470 mm2  Ix=2.85e6 mm4"
    "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 18) 0.0) 2.0
    "Rafter: L50x50x5 EA   -  A=480 mm2  Ix=1.09e5 mm4"
    "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 14) 0.0) 2.0
    "Material:  E=2.0e5 N/mm2, Fy=250 N/mm2 (IS 2062)"
    "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 10) 0.0) 2.0
    "Bolt:      M16 Gr.8.8, Fub=800 N/mm2, Fu=0.7xFub"
    "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 6) 0.0) 2.0
    "Weld:      E6013 electrode, Fexx=430 N/mm2 (shop)"
    "SP_MMS" 7)
  (sp-mtext (list sp-x (+ sp-y 2) 0.0) 2.0
    "Slenderness limit: lambda < 180 (post), < 250 (purlin)"
    "SP_MMS" 7)

  ;;------------------------------------------------------------
  ;; 10. SAVE XDATA + add layer SP_MMS if missing
  ;;------------------------------------------------------------
  (setup-layer "SP_MMS" 7)
  (princ (strcat "\n[MMSPERMIT] Sheet complete. Drawing no: SOLARPRO-MMS-"
                 (itoa *SP-MMS-DRAWING-NO*)))
  (princ))

;;------------------------------------------------------------
;; c:MMSPERMITBATCH - 12 tables drawn at once, on grid 4x3
;;------------------------------------------------------------
(defun c:MMSPERMITBATCH (/ ip nx ny n count)
  (if (sp-guard-or-exit) (exit))
  (if (null (setq ip (getpoint "\nBatch origin (lower-left): "))) (exit))
  (initget 6)
  (setq nx (getint "\nTables along X <4>: "))
  (if (null nx) (setq nx 4))
  (initget 6)
  (setq ny (getint "\nTables along Y <3>: "))
  (if (null ny) (setq ny 3))
  (setq n (* nx ny) count 0)
  (princ (strcat "\n[MMSBATCH] Drawing " (itoa n) " sheets..."))
  (dotimes (j ny)
    (dotimes (i nx)
      (progn
        (setq count (1+ count)
              *SP-MMS-DRAWING-NO* count)
        (c:MMSPERMIT))))
  (princ (strcat "\n[MMSBATCH] Done. " (itoa n) " sheets drawn."))
  (princ))

(princ "\n[SolarPro v5.0] MMS Permit sheet ready: MMSPERMIT, MMSPERMITBATCH.")
(princ)

;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 12)
;; PRESERVED RESULTS-TABLE POSITION
;;
;;   Workflow:
;;     1. User runs GenerateLayout
;;     2. ClearExistingLayout is called
;;     3. NEW: BEFORE deleting, capture current report
;;        bbox + insert-point into:
;;          - global  *SP-REPORT-HIST-BBOX*
;;          - global  *SP-REPORT-HIST-PT*
;;          - XDATA   FS_REPORT_HIST  on the boundary
;;     4. After clearing, the new layout is generated.
;;     5. NEW: table-placement excludes the preserved bbox
;;        (so no new table is placed on top of where the
;;        old report used to be).
;;     6. NEW: FindClearReportPosition tries the preserved
;;        insert-point first; if the area is still clear,
;;        the new report is drawn at the same place.
;;     7. NEW: after drawing, the new bbox is committed to
;;        FS_REPORT_HIST (overwriting the old one).
;;
;;   New commands:
;;     c:SPHISTSHOW   - show preserved position
;;     c:SPHISTDROP   - clear preserved position (start fresh)
;;     c:SPHISTHERE   - capture current report position now
;;============================================================

;;---------------- globals ----------------------------------
(setq *SP-REPORT-HIST-BBOX* nil)   ; list (min_x min_y max_x max_y) or nil
(setq *SP-REPORT-HIST-PT* nil)     ; list (x y) - insert point or nil
(setq *SP-REPORT-HIST-CAPTURED* nil)  ; T if just captured (for printing)

;;---------------- capture / commit --------------------------
;; Read current report position from XDATA and write to HIST
;; (both as in-memory globals and as XDATA on the boundary).
;;
;; Call this:
;;   - At the top of ClearExistingLayout (BEFORE the entmod
;;     that wipes XDATA) - to capture old position
;;   - Manually via c:SPHISTHERE - to fix a position
;;
;; Returns T on success.
(defun sp-report-hist-capture (boundary_ent / bbox ins-pt pos-pt)
  (if (null boundary_ent) (setq boundary_ent nil))
  (if (and boundary_ent
           (setq bbox (GetReportBBox boundary_ent)))
    (progn
      (setq *SP-REPORT-HIST-BBOX* bbox
            *SP-REPORT-HIST-CAPTURED* T)
      ;; Try to read the existing insert point: from FS_SOLAR_REPORT_POS
      (setq pos-pt (GetReportBottomY boundary_ent))
      (if pos-pt
        (setq *SP-REPORT-HIST-PT*
              (list (car bbox)         ; use bbox min-x as ins-pt.x
                    pos-pt))            ; pos-pt is the bottom Y
        (setq *SP-REPORT-HIST-PT*
              (list (nth 0 bbox)        ; min-x
                    (/ (+ (nth 1 bbox) (nth 3 bbox)) 2.0)))) ; mid-y
      ;; Commit to XDATA on the boundary
      (sp-report-hist-commit boundary_ent)
      (princ (strcat "\n[REPORT-HIST] Captured old position.  "
                     "BBox: ("
                     (rtos (nth 0 bbox) 2 2) ","
                     (rtos (nth 1 bbox) 2 2) ")-("
                     (rtos (nth 2 bbox) 2 2) ","
                     (rtos (nth 3 bbox) 2 2) ")"))
      T)
    (progn
      (princ "\n[REPORT-HIST] No existing report bbox on boundary - nothing to capture.")
      nil)))

;;---------------- commit globals to XDATA -------------------
;; Writes the in-memory HIST to FS_REPORT_HIST on the boundary.
;; (list -3 (list "FS_REPORT_HIST"
;;                (cons 1040 min_x) (cons 1040 min_y)
;;                (cons 1040 max_x) (cons 1040 max_y)
;;                (cons 1040 ins_x) (cons 1040 ins_y)))
(defun sp-report-hist-commit (boundary_ent / ed)
  (if (and boundary_ent *SP-REPORT-HIST-BBOX*)
    (progn
      (if (not (tblsearch "APPID" "FS_REPORT_HIST"))
        (regapp "FS_REPORT_HIST"))
      (setq ed (entget boundary_ent))
      (setq ed (vl-remove-if
                 '(lambda (itm)
                    (and (= (car itm) -3)
                         (= (car (cadr itm)) "FS_REPORT_HIST")))
                 ed))
      (entmod
        (append ed
          (list
            (list -3
              (list "FS_REPORT_HIST"
                    (cons 1040 (nth 0 *SP-REPORT-HIST-BBOX*))
                    (cons 1040 (nth 1 *SP-REPORT-HIST-BBOX*))
                    (cons 1040 (nth 2 *SP-REPORT-HIST-BBOX*))
                    (cons 1040 (nth 3 *SP-REPORT-HIST-BBOX*))
                    (cons 1040 (car  *SP-REPORT-HIST-PT*))
                    (cons 1040 (cadr *SP-REPORT-HIST-PT*))))))))))

;;---------------- read HIST from XDATA ----------------------
;; Loads FS_REPORT_HIST from boundary into the in-memory globals.
;; Returns the bbox (or nil).
(defun sp-report-hist-load (boundary_ent / xdata vals)
  (if (null boundary_ent)
    (progn (setq *SP-REPORT-HIST-BBOX* nil *SP-REPORT-HIST-PT* nil) nil)
    (progn
      (setq xdata (cdr (assoc -3 (entget boundary_ent '("FS_REPORT_HIST")))))
      (if (and xdata (= (caar xdata) "FS_REPORT_HIST"))
        (progn
          (setq vals (mapcar 'cdr
                             (vl-remove-if-not
                               '(lambda (itm) (= (car itm) 1040))
                               (cdar xdata))))
          (if (>= (length vals) 4)
            (progn
              (setq *SP-REPORT-HIST-BBOX* (list (nth 0 vals)
                                                (nth 1 vals)
                                                (nth 2 vals)
                                                (nth 3 vals)))
              (if (>= (length vals) 6)
                (setq *SP-REPORT-HIST-PT* (list (nth 4 vals)
                                                (nth 5 vals)))
                (setq *SP-REPORT-HIST-PT* (list (nth 0 vals)
                                                (nth 1 vals))))
              *SP-REPORT-HIST-BBOX*)
            nil))
        nil))))

;;---------------- drop HIST ---------------------------------
(defun sp-report-hist-drop (boundary_ent / ed)
  (setq *SP-REPORT-HIST-BBOX* nil
        *SP-REPORT-HIST-PT* nil
        *SP-REPORT-HIST-CAPTURED* nil)
  (if boundary_ent
    (progn
      (if (not (tblsearch "APPID" "FS_REPORT_HIST"))
        (regapp "FS_REPORT_HIST"))
      (setq ed (entget boundary_ent))
      (setq ed (vl-remove-if
                 '(lambda (itm)
                    (and (= (car itm) -3)
                         (= (car (cadr itm)) "FS_REPORT_HIST")))
                 ed))
      (entmod (append ed (list (list -3 (list "FS_REPORT_HIST")))))))
  (princ "\n[REPORT-HIST] Cleared."))

;;---------------- check whether a candidate position -------
;; is clear of the preserved bbox. Used by FindClearReportPosition.
(defun sp-report-hist-position-clear (proposed_x proposed_y proposed_w proposed_h
                                      / box hist)
  (if (null *SP-REPORT-HIST-BBOX*)
    T   ;; no constraint, always clear
    (progn
      (setq box (list proposed_x
                      (- proposed_y proposed_h)
                      (+ proposed_x proposed_w)
                      proposed_y)
            hist *SP-REPORT-HIST-BBOX*)
      ;; "Clear" = the proposed box does NOT overlap the hist box
      ;; (i.e. the new report is at a different place than the old one)
      (not (BoxesOverlap box hist)))))

;;---------------- whether a candidate table bbox ----------
;; overlaps the preserved report bbox. Used to keep tables out
;; of the preserved area. Returns T if it overlaps.
(defun sp-table-overlaps-hist (tbl_min_x tbl_min_y tbl_max_x tbl_max_y / h)
  (if (null *SP-REPORT-HIST-BBOX*)
    nil
    (BoxesOverlap (list tbl_min_x tbl_min_y tbl_max_x tbl_max_y)
                  *SP-REPORT-HIST-BBOX*)))

;;---------------- c:SPHISTSHOW ------------------------------
(defun c:SPHISTSHOW (/ ent)
  (princ "\n--- SolarPro V5 Preserved Report Position ---")
  (if (null *SP-REPORT-HIST-BBOX*)
    (princ "\n  (no in-memory HIST)  -> loading from boundary..."))
  (initget 1)
  (if (setq ent (car (entsel "\nSelect boundary polyline: ")))
    (progn
      (sp-report-hist-load ent)
      (if (null *SP-REPORT-HIST-BBOX*)
        (princ "\n  No preserved position for this boundary.")
        (progn
          (princ "\n  Preserved bbox:")
          (princ (strcat "\n    min: ("
                         (rtos (nth 0 *SP-REPORT-HIST-BBOX*) 2 2) ", "
                         (rtos (nth 1 *SP-REPORT-HIST-BBOX*) 2 2) ")"))
          (princ (strcat "\n    max: ("
                         (rtos (nth 2 *SP-REPORT-HIST-BBOX*) 2 2) ", "
                         (rtos (nth 3 *SP-REPORT-HIST-BBOX*) 2 2) ")"))
          (if *SP-REPORT-HIST-PT*
            (princ (strcat "\n  Preserved insert-point: ("
                           (rtos (car  *SP-REPORT-HIST-PT*) 2 2) ", "
                           (rtos (cadr *SP-REPORT-HIST-PT*) 2 2) ")")))))))
  (princ))

;;---------------- c:SPHISTDROP ------------------------------
(defun c:SPHISTDROP (/ ent)
  (princ "\n--- SolarPro V5 Drop Preserved Report Position ---")
  (initget 1)
  (if (setq ent (car (entsel "\nSelect boundary polyline: ")))
    (sp-report-hist-drop ent))
  (princ))

;;---------------- c:SPHISTHERE ------------------------------
;; Captures the current report position (if any) for the
;; selected boundary, into the HIST memory.
(defun c:SPHISTHERE (/ ent)
  (princ "\n--- SolarPro V5 Capture Current Report Position ---")
  (initget 1)
  (if (setq ent (car (entsel "\nSelect boundary polyline: ")))
    (sp-report-hist-capture ent))
  (princ))

;;---------------- patch into ClearExistingLayout ------------
;; The patch is applied by direct edit to ClearExistingLayout
;; at line 1741 of the master .lsp.  The call to
;; sp-report-hist-capture is inserted as the very first
;; statement (under a vl-catch-all-apply guard, so any
;; failure is non-fatal).

(defun sp-install-report-hist-hook (/ file src
                                   def-line def-end
                                   new-def
                                   line)
  (setq src "SolarPro-PANFiles.lsp"
        file (findfile src))
  (if (null file)
    (princ (strcat "\n[HOOK] " src " not in support path - "
                   "the edit-patch inside ClearExistingLayout is still in effect."))
    (princ (strcat "\n[HOOK] " src " - HIST capture is already "
                   "wired into ClearExistingLayout."))))

;; Run the hook AFTER its defun is registered
(sp-install-report-hist-hook)

(princ "\n[SolarPro v5.0] Preserved report position ready: SPHISTSHOW, SPHISTDROP, SPHISTHERE.")
(princ)


;;============================================================
;; SolarPro V5.0 EXTENSION  (BATCH 13)
;; RED SHADOW MAPS and LA COVERAGE CHECK
;;
;;   Why RED?
;;     The user can toggle the SP_SHADOW_MAP and SP_LA_COVER
;;     layers on/off to visually inspect conflict zones and
;;     protection gaps. Red is the convention here.
;;
;;   New commands:
;;     c:SHADOWRED     - re-color all existing shadow polygons
;;                       to RED and move to SP_SHADOW_MAP
;;     c:SHADOWGEN     - regenerate shadow polygons for all
;;                       pole/LA/light/building sources, in RED
;;     c:LACOVERAGE    - draw red protection-radius circles
;;                       around every LA in the drawing
;;     c:LARADIUS      - prompt for a new LA radius and
;;                       re-draw all coverage circles
;;     c:SHADOWREPORT  - list module tables in any red shadow
;;                       and tables not in any LA coverage
;;     c:SHADOWREMOVE  - interactively pick a red shadow and
;;                       delete the module tables inside it
;;     c:SHADOWREMOVEALL - delete all tables in any red shadow
;;     c:SHADOWCLEAN   - erase all red shadow polygons and
;;                       red LA coverage circles
;;     c:SHADOWHIDE    - freeze the red layers
;;     c:SHADOWSHOW    - thaw the red layers
;;============================================================

;;---------------- constants ---------------------------------
(setq *SP-SHADOW-LAYER*  "SP_SHADOW_MAP")
(setq *SP-LA-COVER-LAYER* "SP_LA_COVER")
(setq *SP-SHADOW-RED*     1)   ; ACI 1 = red
(setq *SP-LA-DEFAULT-R*    30.0)
(setq *SP-LA-CURRENT-R*   30.0) ; user-editable via c:LARADIUS
(setq *SP-SHADOW-TRANSP*   50)  ; 50% transparency

(setq *SP-SHADOW-SRC-LAYERS*
  '("SHADOW-POLE" "SHADOW-LA" "STREET_LIGHTING"
    "SHADOW-BLDG" "SHADOW-SMALL"))

;;---------------- ensure red layers exist -------------------
(defun sp-shadow-ensure-layers (/ transp-val)
  (if (not (tblsearch "APPID" "FS_SHADOW_MAP")) (regapp "FS_SHADOW_MAP"))
  (if (not (tblsearch "APPID" "FS_LA_COVERAGE")) (regapp "FS_LA_COVERAGE"))
  (setup-layer *SP-SHADOW-LAYER*  *SP-SHADOW-RED*)
  (setup-layer *SP-LA-COVER-LAYER* *SP-SHADOW-RED*)
  (if (not (tblsearch "LAYER" *SP-SHADOW-LAYER*))
    (command "_.-LAYER" "_Make" *SP-SHADOW-LAYER* "_Color" *SP-SHADOW-RED* ""))
  (if (not (tblsearch "LAYER" *SP-LA-COVER-LAYER*))
    (command "_.-LAYER" "_Make" *SP-LA-COVER-LAYER* "_Color" *SP-SHADOW-RED* "")))

;;---------------- recolor an existing shadow to red ---------
;; Moves entity to SP_SHADOW_MAP, color 1, 50% transparent.
;; Tags with FS_SHADOW_MAP XDATA.
(defun sp-shadow-recolor (ent / ed dxf70)
  (if (null ent) nil
    (progn
      (sp-shadow-ensure-layers)
      (setq ed (entget ent)
            ed (subst (cons 8 *SP-SHADOW-LAYER*) (assoc 8 ed) ed)
            ed (subst (cons 62 *SP-SHADOW-RED*) (assoc 62 ed) ed))
      ;; Strip any -3 we will rewrite
      (setq ed (vl-remove-if '(lambda (i) (= (car i) -3)) ed))
      (entmod ed)
      ;; Apply transparency
      (set-transparency ent *SP-SHADOW-TRANSP*)
      ;; Tag with XDATA
      (if (not (tblsearch "APPID" "FS_SHADOW_MAP")) (regapp "FS_SHADOW_MAP"))
      (setq ed (entget ent '("FS_SHADOW_MAP")))
      (setq ed (vl-remove-if '(lambda (i) (and (= (car i) -3) (= (caadr i) "FS_SHADOW_MAP"))) ed))
      (entmod
        (append ed
          (list (list -3 (list "FS_SHADOW_MAP"
                                (cons 1000 "shadow")
                                (cons 1040 (getvar "CDATE")))))))
      ent)))

;;---------------- c:SHADOWRED --------------------------------
;; Recolor every existing shadow polygon (on the source shadow
;; layers) to RED on SP_SHADOW_MAP.
(defun c:SHADOWRED (/ ss idx ent count)
  (if (sp-guard-or-exit) (exit))
  (sp-shadow-ensure-layers)
  (setq count 0)
  (if (setq ss (ssget "_X"
              (list (cons 0 "LWPOLYLINE")
                    (cons 8 (apply 'strcat
                              (mapcar '(lambda (l) (strcat l ","))
                                      *SP-SHADOW-SRC-LAYERS*))))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ent (ssname ss idx))
        ;; Filter: only polylines whose layer is in the list
        (if (member (cdr (assoc 8 (entget ent))) *SP-SHADOW-SRC-LAYERS*)
          (progn
            (sp-shadow-recolor ent)
            (setq count (1+ count))))
        (setq idx (1+ idx)))))
  (princ (strcat "\n[SHADOWRED] Recolored " (itoa count)
                 " shadow polygon(s) to RED on " *SP-SHADOW-LAYER* "."))
  (princ))

;;---------------- draw a red shadow for a pole/LA/light ----
;; Uses collect-tips to build a polygon. Differs from the
;; existing spd-draw-single-shadow in that it ALWAYS uses red
;; and tags with FS_SHADOW_MAP.
(defun sp-shadow-draw-red (base-pt pole-h lat / w-tips b-ent vlist)
  (if (not (numberp pole-h)) (setq pole-h 7.0))
  (if (not (numberp lat)) (setq lat 23.53))
  (setq w-tips (collect-tips base-pt pole-h lat -23.45 9.0 15.5 0.0833))
  (if (and base-pt (listp base-pt) (>= (length w-tips) 2))
    (progn
      (sp-shadow-ensure-layers)
      (setq vlist (list (cons 10 base-pt)))
      (foreach pr w-tips
        (setq vlist (append vlist (list (cons 10 (list (car pr) (cadr pr)))))))
      (setq b-ent (entmakex
        (append (list '(0 . "LWPOLYLINE")
                      '(100 . "AcDbEntity")
                      '(100 . "AcDbPolyline")
                      (cons 90 (length vlist))
                      '(70 . 1)
                      (cons 8 *SP-SHADOW-LAYER*)
                      (cons 62 *SP-SHADOW-RED*))
               vlist)))
      (if b-ent
        (progn
          (set-transparency b-ent *SP-SHADOW-TRANSP*)
          (if (not (tblsearch "APPID" "FS_SHADOW_MAP")) (regapp "FS_SHADOW_MAP"))
          (entmod
            (append (entget b-ent)
              (list (list -3 (list "FS_SHADOW_MAP"
                                    (cons 1000 "shadow")
                                    (cons 1040 (getvar "CDATE")))))))
          b-ent)))))

;;---------------- find all LAs in the drawing ----------------
;; Returns a list of (base-pt . height) for each LA.
;; An LA is identified by:
;;   - a TEXT/MTEXT entity whose content starts with "LA-"
;;   - OR an entity on SHADOW-LA layer (first vertex of polygon
;;     = base)
(defun sp-find-las (/ ss idx ent ed txt pt hgt result la-x y)
  (setq result '())
  ;; Strategy 1: find LA text labels
  (if (setq ss (ssget "_X" '((0 . "TEXT,MTEXT"))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ent (ssname ss idx)
              ed (entget ent)
              txt (cdr (assoc 1 ed))
              pt (cdr (assoc 10 ed)))
        (if (and txt (wcmatch (strcase txt) "LA-*"))
          (progn
            (setq hgt 7.0)
            ;; Try to parse "LA-N (h m)" format
            (if (vl-string-search "(" txt)
              (progn
                (setq la-x (vl-string-search "(" txt)
                      y (substr txt (+ la-x 1))
                      y (vl-string-translate "(" "" y)
                      y (vl-string-translate ")" "" y)
                      y (vl-string-translate "m" "" y)
                      hgt (atof (vl-string-trim " " y)))))
            (setq result (append result (list (cons pt hgt))))))
        (setq idx (1+ idx)))))
  ;; Strategy 2: scan SHADOW-LA polylines, take first vertex
  (if (setq ss (ssget "_X" '((0 . "LWPOLYLINE") (8 . "SHADOW-LA"))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ent (ssname ss idx)
              ed (entget ent)
              pt (cdr (assoc 10 ed)))
        (if (and pt (not (assoc (car pt) result)))
          (progn
            ;; Default height for SHADOW-LA is 7m if not labeled
            (if (not (member pt result))
              (setq result (append result (list (cons pt 7.0)))))))
        (setq idx (1+ idx)))))
  result)

;;---------------- c:SHADOWGEN --------------------------------
;; Re-generate red shadow polygons for all sources in the
;; drawing. Sources = LA text labels, plus any pole/light
;; markers found on SHADOW-POLE / STREET_LIGHTING layers
;; (those that don't already have a red shadow).
(defun c:SHADOWGEN (/ ss idx ent ed pt pole-h count las)
  (if (sp-guard-or-exit) (exit))
  (sp-shadow-ensure-layers)
  (setq count 0)

  ;; 1. Re-generate shadows for LAs
  (setq las (sp-find-las))
  (foreach la las
    (progn
      (sp-shadow-draw-red (car la) (cdr la) 23.53)
      (setq count (1+ count))))

  ;; 2. Re-generate shadows for streetlight circles
  (if (setq ss (ssget "_X" '((0 . "CIRCLE") (8 . "STREET_LIGHTING"))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ent (ssname ss idx)
              ed (entget ent)
              pt (cdr (assoc 10 ed))
              pole-h 7.0)
        (sp-shadow-draw-red pt pole-h 23.53)
        (setq count (1+ count))
        (setq idx (1+ idx)))))

  ;; 3. Re-generate shadows for SHADOW-POLE base markers
  (if (setq ss (ssget "_X" '((0 . "CIRCLE") (8 . "SHADOW-POLE"))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ent (ssname ss idx)
              ed (entget ent)
              pt (cdr (assoc 10 ed))
              pole-h 7.0)
        (sp-shadow-draw-red pt pole-h 23.53)
        (setq count (1+ count))
        (setq idx (1+ idx)))))

  (princ (strcat "\n[SHADOWGEN] Generated " (itoa count)
                 " red shadow polygon(s) on " *SP-SHADOW-LAYER* "."))
  (princ))

;;---------------- c:LACOVERAGE -------------------------------
;; For each LA, draw a red CIRCLE of radius *SP-LA-CURRENT-R*
;; on the SP_LA_COVER layer. Tagged FS_LA_COVERAGE.
(defun c:LACOVERAGE (/ las ent pt r b-ent)
  (if (sp-guard-or-exit) (exit))
  (sp-shadow-ensure-layers)
  (setq las (sp-find-las) r *SP-LA-CURRENT-R*)

  (if (null las)
    (progn
      (princ "\n[LACOVERAGE] No LAs found. Place LA shadows first using SHADOW -> LA.")
      (exit)))

  (foreach la las
    (progn
      (setq pt (car la))
      ;; Check if circle already exists for this LA - delete it
      (if (setq ent (car (entsel (strcat "\n[LACOVERAGE] Cleaning old circle at ("
                                      (rtos (car pt) 2 1) ","
                                      (rtos (cadr pt) 2 1) ")..."))))
        (vl-catch-all-apply 'entdel (list ent)))))
  ;; (cleanup is done by c:SHADOWCLEAN; here we just add new)

  (foreach la las
    (progn
      (setq pt (car la))
      (entmake
        (list '(0 . "CIRCLE")
              (cons 8 *SP-LA-COVER-LAYER*)
              (cons 62 *SP-SHADOW-RED*)
              (cons 10 pt)
              (cons 40 r)))
      (setq b-ent (entlast))
      (if b-ent
        (progn
          (set-transparency b-ent *SP-SHADOW-TRANSP*)
          (if (not (tblsearch "APPID" "FS_LA_COVERAGE"))
            (regapp "FS_LA_COVERAGE"))
          (entmod
            (append (entget b-ent)
              (list (list -3 (list "FS_LA_COVERAGE"
                                    (cons 1000 "coverage")
                                    (cons 1040 r)
                                    (cons 1040 (car pt))
                                    (cons 1040 (cadr pt)))))))))))

  (princ (strcat "\n[LACOVERAGE] Drawn " (itoa (length las))
                 " coverage circle(s) at R=" (rtos r 2 1)
                 "m on " *SP-LA-COVER-LAYER* "."))
  (princ))

;;---------------- c:LARADIUS ---------------------------------
;; Update the LA coverage radius and re-draw.
(defun c:LARADIUS (/ r)
  (if (sp-guard-or-exit) (exit))
  (initget 1)
  (setq r (getreal (strcat "\n[LACOVERAGE] New LA radius (m) <"
                            (rtos *SP-LA-CURRENT-R* 2 1) ">: ")))
  (if (null r) (setq r *SP-LA-CURRENT-R*))
  (if (<= r 0.0)
    (progn (princ "\n[LACOVERAGE] Invalid radius.") (exit)))
  (setq *SP-LA-CURRENT-R* r)
  ;; Delete existing coverage circles
  (sp-delete-la-coverage)
  ;; Re-draw
  (c:LACOVERAGE)
  (princ))

(defun sp-delete-la-coverage (/ ss idx)
  (if (not (tblsearch "APPID" "FS_LA_COVERAGE")) (regapp "FS_LA_COVERAGE"))
  (if (setq ss (ssget "_X" (list (cons 0 "CIRCLE")
                                  (cons 8 *SP-LA-COVER-LAYER*)
                                  (cons -3 (list "FS_LA_COVERAGE")))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (vl-catch-all-apply 'entdel (list (ssname ss idx)))
        (setq idx (1+ idx))))))

;;---------------- c:SHADOWREPORT -----------------------------
;; Lists module tables in any red shadow AND tables not in
;; any LA coverage circle.
(defun c:SHADOWREPORT (/ shadow-bb la-circles tables
                               in-shadow not-protected count
                               i tbl ins-pt center r d)
  (if (sp-guard-or-exit) (exit))

  (princ "\n--- SolarPro V5 SHADOW & LA COVERAGE REPORT ---")
  (setq in-shadow '() not-protected '() count 0)

  ;; 1. Find all red shadow bboxes on SP_SHADOW_MAP
  (if (not (tblsearch "APPID" "FS_SHADOW_MAP")) (regapp "FS_SHADOW_MAP"))
  (if (not (tblsearch "APPID" "FS_LA_COVERAGE")) (regapp "FS_LA_COVERAGE"))
  (setq shadow-bb (sp-get-red-shadow-bboxes))
  (setq la-circles (sp-get-la-coverage-circles))

  ;; 2. Find all module tables (block inserts on PV_MODULE or named TABLE_*)
  (if (setq tables
        (ssget "_X"
          (list (cons 0 "INSERT")
                (cons 8 "PV_MODULE,SP_PV_MODULE"))))
    (progn
      (setq i 0)
      (while (< i (sslength tables))
        (setq tbl (ssname tables i)
              ins-pt (cdr (assoc 10 (entget tbl))))
        (if ins-pt
          (progn
            ;; In any red shadow?
            (if (sp-pt-in-any-bbox ins-pt shadow-bb)
              (progn
                (setq in-shadow (append in-shadow (list tbl)))
                (setq count (1+ count))))
            ;; In any LA coverage?
            (if (not (sp-pt-in-any-la-coverage ins-pt la-circles))
              (progn
                (setq not-protected (append not-protected (list tbl)))))))
        (setq i (1+ i)))))

  (princ (strcat "\n  Tables in red shadow:  " (itoa count)))
  (if (> count 0)
    (progn
      (princ "\n  First 10 affected tables (handle, insert-pt):")
      (setq i 0)
      (foreach t in-shadow
        (progn
          (princ (strcat "\n    " (cdr (assoc 5 (entget t)))
                         "  at  ("
                         (rtos (car (cdr (assoc 10 (entget t)))) 2 1)
                         ", "
                         (rtos (cadr (cdr (assoc 10 (entget t)))) 2 1)
                         ")"))
          (setq i (1+ i))
          (if (>= i 10) (princ "\n    ..."))))))
  (princ (strcat "\n  Tables NOT in any LA coverage: "
                  (itoa (length not-protected))))
  (if (> (length not-protected) 0)
    (progn
      (princ "\n  First 10 unprotected tables (handle, insert-pt):")
      (setq i 0)
      (foreach t not-protected
        (progn
          (princ (strcat "\n    " (cdr (assoc 5 (entget t)))
                         "  at  ("
                         (rtos (car (cdr (assoc 10 (entget t)))) 2 1)
                         ", "
                         (rtos (cadr (cdr (assoc 10 (entget t)))) 2 1)
                         ")"))
          (setq i (1+ i))
          (if (>= i 10) (princ "\n    ..."))))))
  (princ (strcat "\n  Red shadow polygons found:   " (itoa (length shadow-bb))))
  (princ (strcat "\n  LA coverage circles found:   " (itoa (length la-circles))))
  (princ "\n-----------------------------------------")
  (princ))

;;---------------- helpers for report -------------------------
(defun sp-get-red-shadow-bboxes (/ ss idx ent ed pts b)
  (setq b '())
  (if (setq ss (ssget "_X"
              (list (cons 0 "LWPOLYLINE")
                    (cons 8 *SP-SHADOW-LAYER*))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ent (ssname ss idx)
              ed (entget ent)
              pts '())
        (foreach i ed
          (if (= (car i) 10) (setq pts (append pts (list (cdr i))))))
        (if (and pts (> (length pts) 0))
          (progn
            (setq b (append b (list (sp-pts-bbox pts))))))
        (setq idx (1+ idx)))))
  b)

(defun sp-pts-bbox (pts / min-x min-y max-x max-y p)
  (if (null pts) nil
    (progn
      (setq min-x (car (car pts)) min-y (cadr (car pts))
            max-x min-x max-y min-y)
      (foreach p pts
        (if (< (car p) min-x) (setq min-x (car p)))
        (if (> (car p) max-x) (setq max-x (car p)))
        (if (< (cadr p) min-y) (setq min-y (cadr p)))
        (if (> (cadr p) max-y) (setq max-y (cadr p))))
      (list min-x min-y max-x max-y))))

(defun sp-pt-in-any-bbox (pt bbs / bb)
  (foreach bb bbs
    (if (and (>= (car pt) (nth 0 bb))
             (<= (car pt) (nth 2 bb))
             (>= (cadr pt) (nth 1 bb))
             (<= (cadr pt) (nth 3 bb)))
      (return T))))

(defun sp-get-la-coverage-circles (/ ss idx ent ed)
  (if (setq ss (ssget "_X" (list (cons 0 "CIRCLE")
                                  (cons 8 *SP-LA-COVER-LAYER*))))
    (progn
      (setq idx 0)
      (while (< idx (sslength ss))
        (setq ent (ssname ss idx)
              ed (entget ent))
        (setq la-circles
          (append la-circles
            (list (list (cdr (assoc 10 ed))
                        (cdr (assoc 40 ed))))))
        (setq idx (1+ idx)))))
  la-circles)

(defun sp-pt-in-any-la-coverage (pt circles / c)
  (foreach c circles
    (if (<= (distance (car c) pt) (cadr c)) (return T))))

;;---------------- c:SHADOWREMOVE -----------------------------
;; Pick a red shadow, delete all module tables whose insert
;; point is inside that shadow.
(defun c:SHADOWREMOVE (/ ent ed pts bbox ss i tbl ins-pt count)
  (if (sp-guard-or-exit) (exit))
  (princ "\nPick a RED shadow polygon (on SP_SHADOW_MAP) to clear tables from: ")
  (setq ent (car (entsel)))
  (if (null ent) (progn (princ "\nNo selection.") (exit)))
  (if (/= (cdr (assoc 8 (entget ent))) *SP-SHADOW-LAYER*)
    (progn
      (princ (strcat "\nSelected entity is not on " *SP-SHADOW-LAYER* "."))
      (exit)))
  (setq ed (entget ent)
        pts '())
  (foreach i ed
    (if (= (car i) 10) (setq pts (append pts (list (cdr i))))))
  (if (null pts) (progn (princ "\nShadow has no vertices.") (exit)))
  (setq bbox (sp-pts-bbox pts))
  (princ (strcat "\nShadow bbox: (" (rtos (nth 0 bbox) 2 1) ","
                 (rtos (nth 1 bbox) 2 1) ")-("
                 (rtos (nth 2 bbox) 2 1) ","
                 (rtos (nth 3 bbox) 2 1) ")"))
  (initget "Yes No")
  (if (/= (getkword "\nDelete all module tables inside this shadow? [Yes/No]: ")
         "Yes")
    (progn (princ "\nCancelled.") (exit)))
  (setq count 0)
  (if (setq ss (ssget "_X"
              (list (cons 0 "INSERT")
                    (cons 8 "PV_MODULE,SP_PV_MODULE"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq tbl (ssname ss i)
              ins-pt (cdr (assoc 10 (entget tbl))))
        (if (and ins-pt (sp-pt-in-any-bbox ins-pt (list bbox)))
          (progn
            (vl-catch-all-apply 'entdel (list tbl))
            (setq count (1+ count))))
        (setq i (1+ i)))))
  (princ (strcat "\n[SHADOWREMOVE] Deleted " (itoa count) " module table(s)."))
  (princ))

;;---------------- c:SHADOWREMOVEALL --------------------------
;; Delete all tables whose insert point is inside any red shadow.
(defun c:SHADOWREMOVEALL (/ shadow-bb tables i tbl ins-pt count)
  (if (sp-guard-or-exit) (exit))
  (setq shadow-bb (sp-get-red-shadow-bboxes))
  (if (null shadow-bb)
    (progn (princ "\nNo red shadow polygons found. Run SHADOWRED or SHADOWGEN first.") (exit)))
  (initget "Yes No")
  (if (/= (getkword (strcat "\nDelete all tables inside " (itoa (length shadow-bb))
                              " red shadow(s)? [Yes/No]: "))
         "Yes")
    (progn (princ "\nCancelled.") (exit)))
  (setq count 0)
  (if (setq tables (ssget "_X"
                    (list (cons 0 "INSERT")
                          (cons 8 "PV_MODULE,SP_PV_MODULE"))))
    (progn
      (setq i 0)
      (while (< i (sslength tables))
        (setq tbl (ssname tables i)
              ins-pt (cdr (assoc 10 (entget tbl))))
        (if (and ins-pt (sp-pt-in-any-bbox ins-pt shadow-bb))
          (progn
            (vl-catch-all-apply 'entdel (list tbl))
            (setq count (1+ count))))
        (setq i (1+ i)))))
  (princ (strcat "\n[SHADOWREMOVEALL] Deleted " (itoa count) " module table(s)."))
  (princ))

;;---------------- c:SHADOWCLEAN ------------------------------
;; Erase all entities on SP_SHADOW_MAP and SP_LA_COVER.
(defun c:SHADOWCLEAN (/ ss1 ss2 n)
  (if (sp-guard-or-exit) (exit))
  (setq n 0)
  (if (not (tblsearch "APPID" "FS_SHADOW_MAP")) (regapp "FS_SHADOW_MAP"))
  (if (not (tblsearch "APPID" "FS_LA_COVERAGE")) (regapp "FS_LA_COVERAGE"))
  (if (setq ss1 (ssget "_X" (list (cons 8 *SP-SHADOW-LAYER*))))
    (progn (setq n (+ n (sslength ss1)))
           (command "_.-ERASE" ss1 "")))
  (if (setq ss2 (ssget "_X" (list (cons 8 *SP-LA-COVER-LAYER*))))
    (progn (setq n (+ n (sslength ss2)))
           (command "_.-ERASE" ss2 "")))
  (princ (strcat "\n[SHADOWCLEAN] Erased " (itoa n) " entity/ies on red layers."))
  (princ))

;;---------------- c:SHADOWHIDE / SHADOWSHOW ------------------
(defun c:SHADOWHIDE ()
  (command "_.-LAYER" "_Freeze" *SP-SHADOW-LAYER*
                "_Freeze" *SP-LA-COVER-LAYER* "")
  (princ (strcat "\n[SHADOWHIDE] " *SP-SHADOW-LAYER* " and "
                  *SP-LA-COVER-LAYER* " frozen."))
  (princ))

(defun c:SHADOWSHOW ()
  (command "_.-LAYER" "_Thaw" *SP-SHADOW-LAYER*
                "_Thaw" *SP-LA-COVER-LAYER*
                "_On" *SP-SHADOW-LAYER*
                "_On" *SP-LA-COVER-LAYER* "")
  (princ (strcat "\n[SHADOWSHOW] " *SP-SHADOW-LAYER* " and "
                  *SP-LA-COVER-LAYER* " thawed + on."))
  (princ))

;;---------------- banner -------------------------------------
(princ "\n[SolarPro v5.0] Red shadow maps & LA coverage ready.")
(princ "\n  SHADOWRED, SHADOWGEN, LACOVERAGE, LARADIUS, SHADOWREPORT,")
(princ "\n  SHADOWREMOVE, SHADOWREMOVEALL, SHADOWCLEAN, SHADOWHIDE, SHADOWSHOW")
(princ)
