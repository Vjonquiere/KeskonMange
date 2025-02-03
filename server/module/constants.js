const units = {
  liquid: ["l", "g"],
  fruit: ["piece", "g"],
  vegetable: ["piece", "g"],
  oil: ["g", "PM"],
  grocerie: ["g", "PM"],
  fish: ["g", "piece"],
  meat: ["g", "piece"],
  cremerie: ["g", "l"],
  egg: ["piece"],
  herb: ["bunch", "g"],
};

const ALLERGEN_NUMBER = 14;

const allergens = {
  Gluten: 1,
  Fish: 2,
  Peanuts: 3,
  Celery: 4,
  Sulfates: 5,
  Lupin: 6,
  Eggs: 7,
  Sesame: 8,
  Mustard: 9,
  Mollusks: 10,
  Crustaceans: 11,
  Soy: 12,
  Nuts: 13,
  Milk: 14,
};

module.exports = {
  units: units,
  allergens: allergens,
  ALLERGEN_NUMBER: ALLERGEN_NUMBER,
};
