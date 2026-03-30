


SELECT *
FROM raforka_legacy.orku_maelingar
LIMIT 200;

SELECT *
FROM raforka_legacy.orku_einingar;

-- viljum ekki fá eining heiti, tegund maelingar og sendandi maelnggar oft upp
-- færa tíma yfir á gildi #done!
-- má ekki vera landsnet duplicates í orku_stöðvar_eigandi #DONE

-- þarf að gera Conflict ef að það sem er í maeling er duplicate