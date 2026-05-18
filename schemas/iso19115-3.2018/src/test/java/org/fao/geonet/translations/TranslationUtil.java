package org.fao.geonet.translations;

import com.google.common.collect.ImmutableMap;

import java.util.HashMap;
import java.util.Map;

public class TranslationUtil {
    static Map<String, String> translations = new HashMap<>();
    static {
        translations = ImmutableMap.<String, String>builder()
            .put("Template for Vector data (preferred!)_en_fr", "Modèle pour les données vectorielles (préféré!)")
            .put("thumbnail_en_fr", "Imagette")
            .build();
    }

    public static final String translate(String text, String fromLanguage, String toLanguage) {
        String translation = translations.get(text + "_" + fromLanguage + "_" + toLanguage);
        return translation != null ? translation : text;
    }
}
