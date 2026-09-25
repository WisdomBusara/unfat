-- Food catalog seed, per 100g unless noted. Values are reference estimates
-- (USDA/standard nutrition tables for international items; East African
-- items estimated from comparable published data — flag for review rather
-- than treating as lab-verified, per the app's "no silent bad data" rule).
-- Idempotent via ON CONFLICT on lower(name) — safe to rerun.
-- Apply: psql -U kaza -d kaza -f seeds/foods.sql

INSERT INTO foods (name, serving_size, calories, protein, carbs, fat, fiber, category, cuisine) VALUES
-- Kenyan / East African
('Ugali', 100, 112, 2.0, 24.0, 0.5, 1.2, 'grains', 'Kenyan'),
('Githeri', 100, 130, 7.5, 22.0, 1.5, 5.5, 'grains', 'Kenyan'),
('Sukuma wiki', 100, 35, 2.5, 5.0, 0.8, 2.5, 'vegetable', 'Kenyan'),
('Managu', 100, 30, 2.8, 4.5, 0.5, 2.2, 'vegetable', 'Kenyan'),
('Terere', 100, 25, 2.5, 4.0, 0.3, 2.0, 'vegetable', 'Kenyan'),
('Kunde (cowpea leaves)', 100, 30, 3.0, 4.5, 0.4, 2.3, 'vegetable', 'Kenyan'),
('Ndengu (green grams)', 100, 105, 7.0, 19.0, 0.4, 5.0, 'protein', 'Kenyan'),
('Beans, cooked', 100, 127, 8.7, 22.8, 0.5, 6.4, 'protein', 'Kenyan'),
('Millet, cooked', 100, 119, 3.5, 23.7, 1.0, 1.3, 'grains', 'Kenyan'),
('Sorghum, cooked', 100, 110, 3.3, 24.0, 0.8, 2.0, 'grains', 'Kenyan'),
('Cassava, boiled', 100, 160, 1.4, 38.1, 0.3, 1.8, 'grains', 'Kenyan'),
('Sweet potato, boiled', 100, 90, 2.0, 20.7, 0.1, 3.0, 'grains', 'Kenyan'),
('Arrowroot (nduma), boiled', 100, 112, 1.5, 26.0, 0.2, 1.3, 'grains', 'Kenyan'),
('Plantain, boiled', 100, 116, 1.3, 31.0, 0.2, 2.3, 'grains', 'Kenyan'),
('Matoke', 100, 122, 1.2, 31.5, 0.3, 2.6, 'grains', 'East African'),
('Chapati', 100, 297, 6.0, 44.0, 10.5, 2.0, 'grains', 'Kenyan'),
('Mandazi', 100, 320, 6.5, 42.0, 14.0, 1.5, 'grains', 'Kenyan'),
('Nyama choma (roast beef)', 100, 250, 26.0, 0.0, 16.0, 0.0, 'protein', 'Kenyan'),
('Samosa, beef', 100, 260, 8.0, 24.0, 15.0, 1.8, 'other', 'Kenyan'),
('Pilau rice', 100, 180, 3.8, 32.0, 4.0, 0.8, 'grains', 'Kenyan'),
('Tilapia, grilled', 100, 128, 26.0, 0.0, 2.7, 0.0, 'protein', 'Kenyan'),
('Omena (dried silver fish)', 100, 300, 45.0, 0.0, 12.0, 0.0, 'protein', 'Kenyan'),
('Mursik (fermented milk)', 100, 65, 3.3, 4.8, 3.5, 0.0, 'dairy', 'Kenyan'),
('Uji (fermented porridge)', 100, 55, 1.5, 11.0, 0.5, 0.8, 'grains', 'Kenyan'),
('Sukari ndizi (sugar banana)', 100, 89, 1.1, 22.8, 0.3, 2.6, 'fruit', 'Kenyan'),
-- Protein
('Chicken breast, cooked', 100, 165, 31.0, 0.0, 3.6, 0.0, 'protein', NULL),
('Chicken thigh, cooked', 100, 209, 26.0, 0.0, 10.9, 0.0, 'protein', NULL),
('Eggs, boiled', 100, 155, 12.6, 1.1, 10.6, 0.0, 'protein', NULL),
('Salmon, cooked', 100, 208, 20.4, 0.0, 13.4, 0.0, 'protein', NULL),
('Tuna, canned in water', 100, 116, 26.0, 0.0, 1.0, 0.0, 'protein', NULL),
('Lean beef mince, cooked', 100, 250, 26.0, 0.0, 17.0, 0.0, 'protein', NULL),
('Whey protein powder', 100, 400, 80.0, 8.0, 5.0, 0.0, 'protein', NULL),
('Greek yogurt, plain', 100, 59, 10.0, 3.6, 0.4, 0.0, 'dairy', NULL),
('Cottage cheese', 100, 98, 11.1, 3.4, 4.3, 0.0, 'dairy', NULL),
('Tofu, firm', 100, 144, 15.8, 3.0, 8.7, 1.9, 'protein', NULL),
-- Grains / carbs
('White rice, cooked', 100, 130, 2.7, 28.2, 0.3, 0.4, 'grains', NULL),
('Brown rice, cooked', 100, 123, 2.6, 25.6, 1.0, 1.6, 'grains', NULL),
('Oats, dry', 100, 389, 16.9, 66.3, 6.9, 10.6, 'grains', NULL),
('Quinoa, cooked', 100, 120, 4.4, 21.3, 1.9, 2.8, 'grains', NULL),
('Whole wheat bread', 100, 247, 13.0, 41.0, 3.4, 6.0, 'grains', NULL),
('Lentils, cooked', 100, 116, 9.0, 20.1, 0.4, 7.9, 'protein', NULL),
('Chickpeas, cooked', 100, 164, 8.9, 27.4, 2.6, 7.6, 'protein', NULL),
('Sweet corn, boiled', 100, 96, 3.4, 21.0, 1.5, 2.4, 'grains', NULL),
-- Vegetables / fruit
('Broccoli, steamed', 100, 35, 2.4, 7.2, 0.4, 3.3, 'vegetable', NULL),
('Spinach, raw', 100, 23, 2.9, 3.6, 0.4, 2.2, 'vegetable', NULL),
('Tomato', 100, 18, 0.9, 3.9, 0.2, 1.2, 'vegetable', NULL),
('Avocado', 100, 160, 2.0, 8.5, 14.7, 6.7, 'fat', NULL),
('Banana', 100, 89, 1.1, 22.8, 0.3, 2.6, 'fruit', NULL),
('Apple', 100, 52, 0.3, 13.8, 0.2, 2.4, 'fruit', NULL),
('Orange', 100, 47, 0.9, 11.8, 0.1, 2.4, 'fruit', NULL),
-- Fats / nuts
('Olive oil', 100, 884, 0.0, 0.0, 100.0, 0.0, 'fat', NULL),
('Almonds', 100, 579, 21.2, 21.6, 49.9, 12.5, 'fat', NULL),
('Peanut butter', 100, 588, 25.1, 20.0, 50.4, 6.0, 'fat', NULL),
('Peanuts, roasted', 100, 567, 25.8, 16.1, 49.2, 8.5, 'fat', 'Kenyan'),
-- Dairy
('Whole milk', 100, 61, 3.2, 4.8, 3.3, 0.0, 'dairy', NULL),
('Skim milk', 100, 34, 3.4, 5.0, 0.1, 0.0, 'dairy', NULL),
('Cheddar cheese', 100, 403, 25.0, 1.3, 33.1, 0.0, 'dairy', NULL)
ON CONFLICT ((lower(name))) DO NOTHING;
