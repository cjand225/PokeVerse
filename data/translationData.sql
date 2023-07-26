-- Call the procedure to insert language codes
CALL Translation.insertSupportedLanguage('en');
CALL Translation.insertSupportedLanguage('fr');
CALL Translation.insertSupportedLanguage('es');
CALL Translation.insertSupportedLanguage('de');
CALL Translation.insertSupportedLanguage('ja');

-- Call the procedure to insert English translations
CALL Translation.insertTranslation('id', 'en', 'ID');
CALL Translation.insertTranslation('generation', 'en', 'Generation');
CALL Translation.insertTranslation('type', 'en', 'Type');
CALL Translation.insertTranslation('name', 'en', 'Name');
CALL Translation.insertTranslation('base stats', 'en', 'Base Stats');
CALL Translation.insertTranslation('hp', 'en', 'HP');
CALL Translation.insertTranslation('attack', 'en', 'Attack');
CALL Translation.insertTranslation('defense', 'en', 'Defense');
CALL Translation.insertTranslation('special attack', 'en', 'Special Attack');
CALL Translation.insertTranslation('special defense', 'en', 'Special Defense');
CALL Translation.insertTranslation('speed', 'en', 'Speed');

-- Call the procedure to insert French translations
CALL Translation.insertTranslation('id', 'fr', 'Identifiant');
CALL Translation.insertTranslation('generation', 'fr', 'Génération');
CALL Translation.insertTranslation('type', 'fr', 'Type');
CALL Translation.insertTranslation('name', 'fr', 'Nom');
CALL Translation.insertTranslation('base stats', 'fr', 'Statistiques de base');
CALL Translation.insertTranslation('hp', 'fr', 'PV');
CALL Translation.insertTranslation('attack', 'fr', 'Attaque');
CALL Translation.insertTranslation('defense', 'fr', 'Défense');
CALL Translation.insertTranslation('special attack', 'fr', 'Attaque Spéciale');
CALL Translation.insertTranslation('special defense', 'fr', 'Défense Spéciale');
CALL Translation.insertTranslation('speed', 'fr', 'Vitesse');

-- Call the procedure to insert Spanish translations
CALL Translation.insertTranslation('id', 'es', 'Identificador');
CALL Translation.insertTranslation('generation', 'es', 'Generación');
CALL Translation.insertTranslation('type', 'es', 'Tipo');
CALL Translation.insertTranslation('name', 'es', 'Nombre');
CALL Translation.insertTranslation('base stats', 'es', 'Estadísticas base');
CALL Translation.insertTranslation('hp', 'es', 'PS');
CALL Translation.insertTranslation('attack', 'es', 'Ataque');
CALL Translation.insertTranslation('defense', 'es', 'Defensa');
CALL Translation.insertTranslation('special attack', 'es', 'Ataque Especial');
CALL Translation.insertTranslation('special defense', 'es', 'Defensa Especial');
CALL Translation.insertTranslation('speed', 'es', 'Velocidad');

-- Call the procedure to insert German translations
CALL Translation.insertTranslation('id', 'de', 'Kennung');
CALL Translation.insertTranslation('generation', 'de', 'Generation');
CALL Translation.insertTranslation('type', 'de', 'Typ');
CALL Translation.insertTranslation('name', 'de', 'Name');
CALL Translation.insertTranslation('base stats', 'de', 'Basisstatistiken');
CALL Translation.insertTranslation('hp', 'de', 'KP');
CALL Translation.insertTranslation('attack', 'de', 'Angriff');
CALL Translation.insertTranslation('defense', 'de', 'Verteidigung');
CALL Translation.insertTranslation('special attack', 'de', 'Spezial-Angriff');
CALL Translation.insertTranslation('special defense', 'de', 'Spezial-Verteidigung');
CALL Translation.insertTranslation('speed', 'de', 'Initiative');

-- Call the procedure to insert Japanese translations
CALL Translation.insertTranslation('id', 'ja', '識別ID');
CALL Translation.insertTranslation('generation', 'ja', '世代');
CALL Translation.insertTranslation('type', 'ja', 'タイプ');
CALL Translation.insertTranslation('name', 'ja', '名前');
CALL Translation.insertTranslation('base stats', 'ja', '基礎統計');
CALL Translation.insertTranslation('hp', 'ja', 'HP');
CALL Translation.insertTranslation('attack', 'ja', 'こうげき');
CALL Translation.insertTranslation('defense', 'ja', 'ぼうぎょ');
CALL Translation.insertTranslation('special attack', 'ja', 'とくこう');
CALL Translation.insertTranslation('special defense', 'ja', 'とくぼう');
CALL Translation.insertTranslation('speed', 'ja', 'すばやさ');

