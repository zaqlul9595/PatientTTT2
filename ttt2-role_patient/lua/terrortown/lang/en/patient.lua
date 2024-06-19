local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[PATIENT.name] = "Patient"
L["info_popup_" .. PATIENT.name] = [[You are the Patient! Infect other with your contagious cough!]]
L["body_found_" .. PATIENT.abbr] = "They were a Patient."
L["search_role_" .. PATIENT.abbr] = "This person was a Patient!"
L["target_" .. PATIENT.name] = "Patient"
L["ttt2_desc_" .. PATIENT.name] = [[You are the Patient! Infect other with your contagious cough!]]

-- -- CUSTOM ROLE LANGUAGE STRINGS
-- L["label_rat_traitor_reveal_time"] = "How long should it take to expose a Traitor to the Rat?"

-- -- TIMER ROLE LANGUAGE STRINGS
-- L["ratTimerName"] = "Rat Expose Timer"
-- L["ratTimerDesc"] = "When this timer finishes, exposes a Traitor to you."