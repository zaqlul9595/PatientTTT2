local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[PATIENT.name] = "Patient"
L["info_popup_" .. PATIENT.name] = [[You are the Patient! Infect others with your contagious cough!]]
L["body_found_" .. PATIENT.abbr] = "They were a Patient."
L["search_role_" .. PATIENT.abbr] = "This person was a Patient!"
L["target_" .. PATIENT.name] = "Patient"
L["ttt2_desc_" .. PATIENT.name] = [[You are the Patient! Infect others with your contagious cough!]]

L["lang_pat_immune_title"] = "You are no longer sick!"
L["lang_pat_immune_desc"] = "You have gained immunity powers"