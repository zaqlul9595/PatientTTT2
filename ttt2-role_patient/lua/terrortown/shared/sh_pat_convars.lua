--CreateConVar("ttt2_pat_cough_cooldown_timer", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

-- hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_patient_dynamic_convars", function(tbl)
  -- tbl[ROLE_PATIENT] = tbl[ROLE_PATIENT] or {}

-- table.insert(tbl[ROLE_PATIENT], {
      -- cvar = "ttt2_pat_cough_cooldown_timer",
      -- slider = true,
      -- min = 5,
      -- max = 120,
      -- decimal = 0,
      -- desc = "ttt2_pat_cough_cooldown_timer (def. 60)"
-- })

--end)