local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[PATIENT.name] = "Patient"
L["info_popup_" .. PATIENT.name] = [[You are the Patient! Infect others with your contagious cough!]]
L["body_found_" .. PATIENT.abbr] = "They were a Patient."
L["search_role_" .. PATIENT.abbr] = "This person was a Patient!"
L["target_" .. PATIENT.name] = "Patient"
L["ttt2_desc_" .. PATIENT.name] = [[You are the Patient! Infect others with your contagious cough!]]

-- ITEM LANGUAGE STRINGS
L["lang_pat_immune_title"] = "Strong Immune System"
L["lang_pat_immune_desc"] = "Your immune system is strengthened, resulting in quicker movement!"
L["item_patient_infection_title"] = "Weak Immune System"
L["item_patient_infection_desc"] = "Your immune system is compromised, resulting in reduced speed and vision."

-- CONVAR LANGUAGE STRINGS
L["label_pat_cough_cooldown_timer"] = "How long until the patient can cough again: "
L["label_pat_sickness_timer"] = "How long a player is sick for: "
L["label_pat_get_full_health_on_immunity"] = "Sick player gets full health on immunity: "