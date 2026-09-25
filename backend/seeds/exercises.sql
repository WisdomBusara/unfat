-- Exercise catalog seed. Idempotent via ON CONFLICT on lower(name) — safe
-- to rerun; existing rows are left untouched, only new names are added.
-- Apply: psql -U kaza -d kaza -f seeds/exercises.sql

INSERT INTO exercises (name, category, primary_muscles, secondary_muscles, equipment, difficulty, movement_pattern) VALUES
-- Resistance — lower body
('Barbell back squat', 'resistance', '["quadriceps","glutes"]', '["hamstrings","core"]', 'barbell', 'intermediate', 'squat'),
('Goblet squat', 'resistance', '["quadriceps","glutes"]', '["core"]', 'dumbbells', 'beginner', 'squat'),
('Bulgarian split squat', 'resistance', '["quadriceps","glutes"]', '["hamstrings"]', 'dumbbells', 'intermediate', 'lunge'),
('Walking lunge', 'resistance', '["quadriceps","glutes"]', '["hamstrings","core"]', 'dumbbells', 'beginner', 'lunge'),
('Romanian deadlift', 'resistance', '["hamstrings","glutes"]', '["lower_back"]', 'barbell', 'intermediate', 'hinge'),
('Conventional deadlift', 'resistance', '["hamstrings","glutes","lower_back"]', '["core","forearms"]', 'barbell', 'advanced', 'hinge'),
('Leg press', 'resistance', '["quadriceps","glutes"]', '["hamstrings"]', 'machines', 'beginner', 'squat'),
('Leg curl', 'resistance', '["hamstrings"]', '[]', 'machines', 'beginner', 'isolation'),
('Calf raise', 'resistance', '["calves"]', '[]', 'dumbbells', 'beginner', 'isolation'),
('Hip thrust', 'resistance', '["glutes"]', '["hamstrings"]', 'barbell', 'intermediate', 'hinge'),
-- Resistance — upper body push
('Barbell bench press', 'resistance', '["chest","triceps"]', '["anterior_deltoid"]', 'barbell', 'intermediate', 'horizontal_push'),
('Dumbbell bench press', 'resistance', '["chest","triceps"]', '["anterior_deltoid"]', 'dumbbells', 'beginner', 'horizontal_push'),
('Overhead press', 'resistance', '["anterior_deltoid","triceps"]', '["core"]', 'barbell', 'intermediate', 'vertical_push'),
('Dumbbell shoulder press', 'resistance', '["anterior_deltoid","triceps"]', '["core"]', 'dumbbells', 'beginner', 'vertical_push'),
('Incline dumbbell press', 'resistance', '["upper_chest","triceps"]', '["anterior_deltoid"]', 'dumbbells', 'intermediate', 'incline_push'),
('Cable tricep pushdown', 'resistance', '["triceps"]', '[]', 'cables', 'beginner', 'isolation'),
('Lateral raise', 'resistance', '["lateral_deltoid"]', '[]', 'dumbbells', 'beginner', 'isolation'),
-- Resistance — upper body pull
('Barbell row', 'resistance', '["lats","rhomboids"]', '["biceps","lower_back"]', 'barbell', 'intermediate', 'horizontal_pull'),
('Dumbbell row', 'resistance', '["lats","rhomboids"]', '["biceps"]', 'dumbbells', 'beginner', 'horizontal_pull'),
('Lat pulldown', 'resistance', '["lats"]', '["biceps"]', 'machines', 'beginner', 'vertical_pull'),
('Seated cable row', 'resistance', '["lats","rhomboids"]', '["biceps"]', 'cables', 'beginner', 'horizontal_pull'),
('Dumbbell bicep curl', 'resistance', '["biceps"]', '["forearms"]', 'dumbbells', 'beginner', 'isolation'),
('Face pull', 'resistance', '["rear_deltoid","rhomboids"]', '[]', 'cables', 'beginner', 'horizontal_pull'),
('Kettlebell swing', 'resistance', '["glutes","hamstrings"]', '["core","shoulders"]', 'kettlebells', 'intermediate', 'hinge'),
('Kettlebell goblet carry', 'resistance', '["core","forearms"]', '["glutes"]', 'kettlebells', 'beginner', 'carry'),
-- Calisthenics — beginner
('Wall push-up', 'calisthenics', '["chest","triceps"]', '["anterior_deltoid"]', 'none', 'beginner', 'horizontal_push'),
('Incline push-up', 'calisthenics', '["chest","triceps"]', '["anterior_deltoid"]', 'none', 'beginner', 'horizontal_push'),
('Push-up', 'calisthenics', '["chest","triceps"]', '["anterior_deltoid","core"]', 'none', 'beginner', 'horizontal_push'),
('Bodyweight squat', 'calisthenics', '["quadriceps","glutes"]', '["core"]', 'none', 'beginner', 'squat'),
('Glute bridge', 'calisthenics', '["glutes"]', '["hamstrings"]', 'none', 'beginner', 'hinge'),
('Plank', 'calisthenics', '["core"]', '["shoulders"]', 'none', 'beginner', 'isometric'),
('Dead bug', 'calisthenics', '["core"]', '[]', 'none', 'beginner', 'core_stability'),
('Superman hold', 'calisthenics', '["lower_back","glutes"]', '[]', 'none', 'beginner', 'isometric'),
-- Calisthenics — intermediate
('Pull-up', 'calisthenics', '["lats"]', '["biceps","forearms"]', 'pull_up_bar', 'intermediate', 'vertical_pull'),
('Chin-up', 'calisthenics', '["lats","biceps"]', '["forearms"]', 'pull_up_bar', 'intermediate', 'vertical_pull'),
('Dip', 'calisthenics', '["chest","triceps"]', '["anterior_deltoid"]', 'dip_bars', 'intermediate', 'vertical_push'),
('Decline push-up', 'calisthenics', '["upper_chest","triceps"]', '["anterior_deltoid"]', 'none', 'intermediate', 'horizontal_push'),
('Hanging knee raise', 'calisthenics', '["core"]', '["hip_flexors"]', 'pull_up_bar', 'intermediate', 'core_stability'),
('Pike push-up', 'calisthenics', '["anterior_deltoid","triceps"]', '["core"]', 'none', 'intermediate', 'vertical_push'),
('Inverted row', 'calisthenics', '["lats","rhomboids"]', '["biceps"]', 'none', 'beginner', 'horizontal_pull'),
-- Calisthenics — advanced
('Muscle-up', 'calisthenics', '["lats","chest","triceps"]', '["core"]', 'pull_up_bar', 'advanced', 'compound'),
('Handstand push-up', 'calisthenics', '["anterior_deltoid","triceps"]', '["core"]', 'none', 'advanced', 'vertical_push'),
('L-sit', 'calisthenics', '["core","hip_flexors"]', '["triceps"]', 'none', 'advanced', 'isometric'),
('Pistol squat', 'calisthenics', '["quadriceps","glutes"]', '["core"]', 'none', 'advanced', 'squat'),
('Front lever', 'calisthenics', '["lats","core"]', '["shoulders"]', 'pull_up_bar', 'advanced', 'isometric'),
-- Cardio
('Brisk walking', 'cardio', '["legs"]', '[]', 'none', 'beginner', 'locomotion'),
('Jogging', 'cardio', '["legs"]', '[]', 'none', 'beginner', 'locomotion'),
('Running intervals', 'cardio', '["legs"]', '["core"]', 'none', 'intermediate', 'locomotion'),
('Outdoor cycling', 'cardio', '["quadriceps","glutes"]', '["calves"]', 'bike', 'beginner', 'locomotion'),
('Stationary bike', 'cardio', '["quadriceps","glutes"]', '["calves"]', 'bike', 'beginner', 'locomotion'),
('Rowing machine', 'cardio', '["lats","legs"]', '["core","biceps"]', 'rowing_machine', 'intermediate', 'compound'),
('Jump rope', 'cardio', '["calves"]', '["shoulders","core"]', 'jump_rope', 'intermediate', 'plyometric'),
('Stair climbing', 'cardio', '["quadriceps","glutes"]', '["calves"]', 'none', 'beginner', 'locomotion'),
('Swimming laps', 'cardio', '["lats","shoulders"]', '["core","legs"]', 'swimming_pool', 'intermediate', 'compound'),
('Elliptical', 'cardio', '["legs"]', '["shoulders"]', 'machines', 'beginner', 'locomotion'),
-- Combat conditioning
('Shadowboxing', 'combat', '["shoulders","core"]', '["legs"]', 'none', 'beginner', 'rotational'),
('Heavy bag rounds', 'combat', '["shoulders","core"]', '["legs"]', 'combat_equipment', 'intermediate', 'rotational'),
('Pad work', 'combat', '["shoulders","core"]', '["legs"]', 'combat_equipment', 'intermediate', 'rotational'),
('Footwork ladder drills', 'combat', '["legs"]', '["core"]', 'none', 'beginner', 'agility'),
('Technical sparring', 'combat', '["full_body"]', '[]', 'combat_equipment', 'advanced', 'compound'),
('Grappling rounds', 'combat', '["full_body"]', '[]', 'none', 'advanced', 'compound'),
-- Mobility / Yoga
('Dynamic hip circles', 'mobility', '["hip_flexors"]', '[]', 'none', 'beginner', 'mobility'),
('World''s greatest stretch', 'mobility', '["hip_flexors","hamstrings"]', '["thoracic_spine"]', 'none', 'beginner', 'mobility'),
('Downward dog', 'yoga', '["shoulders","hamstrings"]', '["calves"]', 'none', 'beginner', 'stretch'),
('Cat-cow', 'mobility', '["spine"]', '[]', 'none', 'beginner', 'mobility'),
('Thoracic spine rotation', 'mobility', '["thoracic_spine"]', '[]', 'none', 'beginner', 'mobility'),
('Ankle mobility drill', 'mobility', '["ankles"]', '[]', 'none', 'beginner', 'mobility'),
('90/90 hip stretch', 'mobility', '["hips"]', '[]', 'none', 'intermediate', 'stretch')
ON CONFLICT ((lower(name))) DO NOTHING;
